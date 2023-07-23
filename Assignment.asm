INCLUDE EMU8086.INC

.model small
.stack 100h

.data
  MULTI         DB 10,13,10,13,'List of Fitness Classes (monthly)' 
                DB 10,13,'1) Pilates - RM160' 
                DB 10,13,'2) Kickboxing - RM200'
                DB 10,13,'3) Zumba - RM150 ' 
                DB 10,13,'4) Aerobics - RM120'
                DB 10,13,'5) Yoga - RM100'
                DB 10,13,'$'
              
  MULTI_INST    DB 10,13,10,13,'Personal Training Instructor Fees' 
                DB 10,13,'1) Hourly basis - RM50' 
                DB 10,13,'2) Daily basis - RM200'
                DB 10,13,'3) Weekly basis - RM900'
                DB 10,13,'4) Monthly basis - RM3000'
                DB 10,13,'$'   
                
  MULTI_DISC    DB 10,13,10,13,'Discount Promotion' 
                DB 10,13,'1) Minimum 2 classes for a discount of RM10' 
                DB 10,13,'2) Minimum 3 classes for a discount of RM20'
                DB 10,13,'3) Minimum 4 classes for a discount of RM40'
                DB 10,13,'4) New client has a discount of RM30'
                DB 10,13,'$' 

  SINGLE        DB 10,13,'Select an option: $'
  OUTPUT        DB 10,13,10,13,'Option selected: $'
          
  YESNO         DB 10,13,10,13,'Do you want to add another class? (1-Yes, 0-NO) $'
  
  DISPLAY_TOTAL DB 10,13,10,13,'Total fee: RM$ '   
  TOTAL         DW 0         ; variable to store the total fee
  
  DISPLAY_COUNT DB 10,13, 'Number of classes entered: $' 
  CLASS_COUNT   DW 0         ; variable to store the class count                                      
  
  DISCOUNTED    DB 10,13,10,13,'Total fee (after discount): RM$ '
                    
  MIN_CLASSES   DW 2         ; minimum number of classes required for discount
  MIN_CLASSES_2 DW 3         ; minimum number of classes for the second discount
  MIN_CLASSES_3 DW 4         ; minimum number of classes for the third discount
  
  DISCOUNT_2    DW 10        ; discount for 2 classes or more
  DISCOUNT_3    DW 20        ; discount for 3 classes or more
  DISCOUNT_4    DW 40        ; discount for 4 classes or more  
  
  INVALID_INPUT DB 10,13,10,13, 'Invalid input. Please enter a valid option.'
                DB '$'

.code
start:  
  MOV AX, @data
  MOV DS, AX                                                                         
  CALL clear_screen   

start1:   
  CALL display_multi   ; display multiple lines 

;--------------------------------------------

  LEA DX, SINGLE       ; display single line
  MOV AH, 9
  INT 21H

  MOV AH, 1            ; asks for a keyboard input.
  INT 21H              ; stored in AL register.

  MOV BL, AL           ; save a copy of AL in BL 
                                      
  LEA DX, OUTPUT       ; display single line
  MOV AH, 9
  INT 21H 

  MOV AH, 2            ; write character to standard output
  MOV DL, BL
  INT 21H
 
;--------------------------------------------

; compare the option 
  CMP DL, 31H
  JZ  OPT1
  CMP DL, 32H
  JZ  OPT2
  CMP DL, 33H
  JZ  OPT3
  CMP DL, 34H
  JZ  OPT4
  CMP DL, 35H
  JZ  OPT5

; Display error message for invalid input
  LEA DX, INVALID_INPUT
  MOV AH, 9
  INT 21H
  
  JMP start1            

OPT1: 
  MOV AX, [TOTAL]             ; load the current total value
  ADD AX, 160                 ; add class fee
  MOV [TOTAL], AX             ; store the updated total value
  INC WORD PTR [CLASS_COUNT]  ; increment class count
  JMP ADD_CLASS

OPT2: 
  MOV AX, [TOTAL]
  ADD AX, 200
  MOV [TOTAL], AX
  INC WORD PTR [CLASS_COUNT]
  JMP ADD_CLASS

OPT3: 
  MOV AX, [TOTAL]
  ADD AX, 150
  MOV [TOTAL], AX
  INC WORD PTR [CLASS_COUNT]
  JMP ADD_CLASS

OPT4: 
  MOV AX, [TOTAL]
  ADD AX, 120
  MOV [TOTAL], AX
  INC WORD PTR [CLASS_COUNT]
  JMP ADD_CLASS

OPT5: 
  MOV AX, [TOTAL]
  ADD AX, 100   
  MOV [TOTAL], AX
  INC WORD PTR [CLASS_COUNT]
  JMP ADD_CLASS
  
;--------------------------------------------

ADD_CLASS:     
  LEA DX, YESNO        ; display single line
  MOV AH, 9
  INT 21H

  MOV AH, 1            ; asks for a keyboard input.
  INT 21H              ; stored in AL register.

  MOV BL, AL           ; save a copy of AL in BL 

  LEA DX, OUTPUT       ; display single line
  MOV AH, 9
  INT 21H 

  MOV AH, 2            ; write character to standard output
  MOV DL, BL             
  INT 21H              
  
;--------------------------------------------

; check if user chooses to add a class
  CMP DL, 31H
  JZ  start1
  CMP DL, 30H
  JZ  INSTRUCTOR
  
; Display error message for invalid input
  LEA DX, INVALID_INPUT
  MOV AH, 9
  INT 21H
  
  JMP ADD_CLASS   

INSTRUCTOR:  
  CALL display_multi1

;--------------------------------------------             
  LEA DX, SINGLE       ; display single line
  MOV AH, 9
  INT 21H

  MOV AH, 1            ; asks for a keyboard input.
  INT 21H              ; stored in AL register.

  MOV BL, AL           ; save a copy of AL in BL 

  LEA DX, OUTPUT       ; display single line
  MOV AH, 9
  INT 21H 

  MOV AH, 2            ; write character to standard output
  MOV DL, BL
  INT 21H

;--------------------------------------------

; compare option with user's choice
  CMP DL, 31H
  JZ  OPT_INT1
  CMP DL, 32H
  JZ  OPT_INT2
  CMP DL, 33H
  JZ  OPT_INT3
  CMP DL, 34H
  JZ  OPT_INT4   

; Display error message for invalid input
  LEA DX, INVALID_INPUT
  MOV AH, 9
  INT 21H
  
  JMP INSTRUCTOR
  
OPT_INT1: 
  MOV AX, [TOTAL]
  ADD AX, 50
  MOV [TOTAL], AX
  JMP GRAND_TOTAL
         
OPT_INT2: 
  MOV AX, [TOTAL]
  ADD AX, 200
  MOV [TOTAL], AX
  JMP GRAND_TOTAL
         
OPT_INT3: 
  MOV AX, [TOTAL]
  ADD AX, 900
  MOV [TOTAL], AX
  JMP GRAND_TOTAL
                  
OPT_INT4: 
  MOV AX, [TOTAL]
  ADD AX, 3000
  MOV [TOTAL], AX
  JMP GRAND_TOTAL   

GRAND_TOTAL: 
  LEA DX, DISPLAY_TOTAL    
  MOV AH, 9
  INT 21H
  MOV AX, [TOTAL]
  CALL PRINT_NUM  
  
; Display the number of classes entered
  CALL display_multi2
  
  LEA DX, DISPLAY_COUNT
  MOV AH, 9
  INT 21H
  MOV AX, [CLASS_COUNT]
  CALL PRINT_NUM
  
  ; Calculate discount
  MOV BX, [CLASS_COUNT]
  CMP BX, [MIN_CLASSES]   ; Check if the class count is equal to or greater than 
                          ; the minimum classes required for the first discount
  JL  NO_DISCOUNT         ; If not, jump to NO_DISCOUNT
  MOV AX, [DISCOUNT_2]    ; Load the first discount value
  SUB [TOTAL], AX         ; Subtract the discount from the total        
  
  CMP BX, [MIN_CLASSES_2] ; Check if the class count is equal to or greater than 
                          ; the minimum classes required for the second discount
  JL  NO_DISCOUNT         ; If not, jump to NO_DISCOUNT
  MOV AX, [DISCOUNT_3]    ; Load the second discount value 
  SUB AX, 10
  SUB [TOTAL], AX         ; Subtract the discount from the total
  
  CMP BX, [MIN_CLASSES_3] ; Check if the class count is equal to or greater than 
                          ; the minimum classes required for the third discount
  JL  NO_DISCOUNT         ; If not, jump to NO_DISCOUNT
  MOV AX, [DISCOUNT_4]    ; Load the third discount value      
  SUB AX, 20
  SUB [TOTAL], AX         ; Subtract the discount from the total
  
NO_DISCOUNT:
  LEA DX, DISCOUNTED      ; Display the discounted total line
  MOV AH, 9
  INT 21H   
  SUB [TOTAL],30 
  MOV AX, [TOTAL]
  CALL PRINT_NUM
  
  JMP quit
             
quit:
  JMP $            
            
RET      

;wait for any key    
MOV AH, 7
INT 21h

;finish program
MOV AX, 4c00h
INT 21h

;---------------------------------------------

clear_screen proc
  mov ah, 0
  mov al, 3
  int 10H
  ret
clear_screen endp 

display_multi proc
  mov dx, offset MULTI
  mov ah, 9
  int 21h              
  ret
display_multi endp  

display_multi1 proc
  mov dx, offset MULTI_INST
  mov ah, 9
  int 21h
  ret
display_multi1 endp 
   
display_multi2 proc
  mov dx, offset MULTI_DISC
  mov ah, 9
  int 21h
  ret
display_multi2 endp 
   
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS 

end start
