!
! A MODULE for non numerical routines (sorting and locate)
!
! Copyright (C) 2005  Alberto Ramos <alberto@martin.ft.uam.es>
!
! This program is free software; you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation; either version 2 of the License, or
! (at your option) any later version.
!
! This program is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with this program; if not, write to the Free Software
! Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
! USA
! 

! ***************************************************
! *
MODULE BDio
! *
! ***************************************************
! *
! * NonNumeric routines for sorting and locating
! * data.
! *
! ***************************************************

  USE ISO_FORTRAN_ENV

  IMPLICIT NONE


  Integer :: BDIO_MAGIC, BDIO_VERSION, BDIO_BIN_GENERIC, &
       & BDIO_ASC_EXEC, BDIO_BIN_INT32BE, BDIO_BIN_INT32LE, &
       & BDIO_BIN_INT64BE, BDIO_BIN_INT64LE, BDIO_BIN_F32BE, &
       & BDIO_BIN_F32LE, BDIO_BIN_F64BE, BDIO_BIN_F64LE, &
       & BDIO_ASC_GENERIC, BDIO_ASC_XML, BDIO_BIN_INT32, &
       & BDIO_BIN_INT64, BDIO_BIN_F32, BDIO_BIN_F64, BDIO_R_MODE, &
       & BDIO_W_MODE, BDIO_A_MODE, BDIO_H_STATE, BDIO_R_STATE, &
       & BDIO_N_STATE, BDIO_E_STATE, BDIO_LEND, BDIO_BEND, &
       & BDIO_MAX_RECORD_LENGTH, BDIO_MAX_LONG_RECORD_LENGTH, &
       & BDIO_BUF_SIZE, BDIO_MAX_HOST_LENGTH, BDIO_MAX_USER_LENGTH, &
       & BDIO_MAX_PINFO_LENGTH

  Data BDIO_MAGIC /Z'7ffbd07e'/
  Data BDIO_VERSION /1/
  
  ! Record data formats
  DATA BDIO_BIN_GENERIC /Z'00'/
  DATA BDIO_ASC_EXEC    /Z'01'/
  DATA BDIO_BIN_INT32BE /Z'02'/
  DATA BDIO_BIN_INT32LE /Z'03'/
  DATA BDIO_BIN_INT64BE /Z'04'/
  DATA BDIO_BIN_INT64LE /Z'05'/
  DATA BDIO_BIN_F32BE   /Z'06'/
  DATA BDIO_BIN_F32LE   /Z'07'/
  DATA BDIO_BIN_F64BE   /Z'08'/
  DATA BDIO_BIN_F64LE   /Z'09'/
  DATA BDIO_ASC_GENERIC /Z'0A'/
  DATA BDIO_ASC_XML     /Z'0B'/

  DATA BDIO_BIN_INT32   /Z'F0'/
  DATA BDIO_BIN_INT64   /Z'F1'/
  DATA BDIO_BIN_F32     /Z'F2'/
  DATA BDIO_BIN_F64     /Z'F3'/

  DATA  BDIO_R_MODE /0/
  DATA  BDIO_W_MODE /1/
  DATA  BDIO_A_MODE /2/

  DATA  BDIO_H_STATE /1/
  DATA  BDIO_R_STATE /2/
  DATA  BDIO_N_STATE /3/
  DATA  BDIO_E_STATE /4/

  DATA  BDIO_LEND /0/
  DATA  BDIO_BEND /1/

  DATA  BDIO_MAX_RECORD_LENGTH /1048575/
  DATA  BDIO_MAX_LONG_RECORD_LENGTH /268435455 /

  DATA  BDIO_BUF_SIZE /7777/

  DATA  BDIO_MAX_HOST_LENGTH /256/

  DATA  BDIO_MAX_USER_LENGTH /33/

  DATA  BDIO_MAX_PINFO_LENGTH /3505/
  

  Type BDIO_t
     Integer :: Istate, Imode, Iverbose, nerr, Ihcnt
     Integer :: Iversion, ifn, iferr, imagic, irstart, rcnt, rlen
     Integer :: ridx, rfmt, ruinfo
     Logical :: lendian, verbose
  End type BDIO_t


  Interface byteswap
     Module Procedure byteswap_int, byteswap_intV, byteswap_R, &
          & byteswap_RV, byteswap_DV, byteswap_D, byteswap_DZ, &
          & byteswap_DZV, byteswap_ZV, byteswap_Z
  End Interface byteswap




  Private :: BDIO_MAGIC, BDIO_VERSION, BDIO_BIN_GENERIC, &
       & BDIO_ASC_EXEC, BDIO_BIN_INT32BE, BDIO_BIN_INT32LE, &
       & BDIO_BIN_INT64BE, BDIO_BIN_INT64LE, BDIO_BIN_F32BE, &
       & BDIO_BIN_F32LE, BDIO_BIN_F64BE, BDIO_BIN_F64LE, &
       & BDIO_ASC_GENERIC, BDIO_ASC_XML, BDIO_BIN_INT32, &
       & BDIO_BIN_INT64, BDIO_BIN_F32, BDIO_BIN_F64, BDIO_R_MODE, &
       & BDIO_W_MODE, BDIO_A_MODE, BDIO_H_STATE, BDIO_R_STATE, &
       & BDIO_N_STATE, BDIO_E_STATE, BDIO_LEND, BDIO_BEND, &
       & BDIO_MAX_RECORD_LENGTH, BDIO_MAX_LONG_RECORD_LENGTH, &
       & BDIO_BUF_SIZE, BDIO_MAX_HOST_LENGTH, BDIO_MAX_USER_LENGTH, &
       & BDIO_MAX_PINFO_LENGTH, byteswap_int, byteswap_intV, byteswap_R, &
       & byteswap_RV, byteswap_DV, byteswap_D, byteswap_DZ, &
       & byteswap_DZV, byteswap_ZV, byteswap_Z

  CONTAINS

! ********************************
! *
    Subroutine BDIO_read_header(fbd)
! *
! ********************************

      Type (BDIO_t), Intent (inout) :: fbd

      Integer (kind=4) :: i4
      Integer (kind=2) :: i2
!      Integer (kind=1) :: i1
!      Character (len=4) :: c4

      Read(fbd%ifn)i4
      If (i4/=BDIO_MAGIC) Then
         Write(0,*)'File not recognized as BDIO'
         Stop
      End If

      Write(*,*)i4
      Read(fbd%ifn)i2
      Write(*,*)i2

      Return
    End Subroutine BDIO_read_header

! ********************************
! *
    Function BDIO_open(fname, mode, protocol_info) Result (fbd)
! *
! ********************************
      Character (len=*), Intent (in) :: fname, protocol_info
      Character (len=1), Intent (in) :: mode
      
      Type (BDIO_t) :: fbd

      Logical :: is_used
!      Integer :: JJ


      Select Case (mode)
      Case ('r')
         fbd%imode = BDIO_R_MODE
      Case ('w')
         fbd%imode = BDIO_W_MODE
      Case ('a')
         fbd%imode = BDIO_A_MODE
      Case Default
         Write(*,*)'Error'
         Stop
      End Select
      
      fbd%lendian = isLittleEndian()

      fbd%ifn = 69
      Do 
         Inquire(fbd%ifn, Opened=is_used)
         If (is_used) Then
            fbd%ifn = fbd%ifn + 1
         Else
            Exit
         End If
      End Do
      Open (File=Trim(fname), unit=fbd%ifn, ACTION="READ", &
           & Form='UNFORMATTED', Access='STREAM')

      Return
    End Function BDIO_open

! ********************************         
! *  
    Function isLittleEndian()
! * 
! ********************************    

      Logical :: isLittleEndian
      Character (kind=1) :: ch(4)
      Integer (kind=4) :: I(1), Isw

      I   = 0
      Isw = 0
      ch = Transfer(I, ch)
      ch(1) = achar(48)
      I   = Transfer(ch, I)

      Isw = 48
      CALL ByteSwap_int(Isw)

      isLittleEndian = .True.
      If (I(1) == 48) Then
         Return
      Else If (I(1) == Isw) Then
         isLittleEndian = .False.
         Return
      Else
         Write(0,*)'What a mess of Endianness!'
      End If

      Return
    End Function isLittleEndian

! ********************************
! *
    Subroutine byteswap_int(Iii)
! *
! ********************************

      Integer, Intent (inout) :: Iii
      
      Character (kind=1) :: isw(4)
      Integer :: J(1)

      isw  = Transfer(Iii,isw, 4)
      J    = Transfer(isw(4:1:-1), J)
      Iii  = J(1)

      Return
    End Subroutine byteswap_int

! ********************************
! *
    Subroutine byteswap_intV(Iii)
! *
! ********************************

      Integer, Intent (inout) :: Iii(:)
      
      Character (kind=1) :: isw(4)
      Integer :: J(1), K

      Do K = 1, Size(Iii)
         isw  = Transfer(Iii(K),isw, 4)
         J    = Transfer(isw(4:1:-1), J)
         Iii(K)  = J(1)
      End Do

      Return
    End Subroutine byteswap_intV

! ********************************
! *
    Subroutine byteswap_R(d)
! *
! ********************************

      Real (kind=4), Intent (inout) :: d
      
      Character (kind=1) :: isw(4)
      Real (kind=4) :: dd(1)

      isw  = Transfer(d,isw, 4)
      dd   = Transfer(isw(4:1:-1), dd)
      d  = dd(1)

      Return
    End Subroutine byteswap_R

! ********************************
! *
    Subroutine byteswap_RV(d)
! *
! ********************************

      Real (kind=4), Intent (inout) :: d(:)
      
      Character (kind=1) :: isw(4)
      Real (kind=4) :: dd(1)
      Integer :: I

      Do I = 1, Size(d)
         isw  = Transfer(d(I),isw, 4)
         dd   = Transfer(isw(4:1:-1), dd)
         d(I) = dd(1)
      End Do

      Return
    End Subroutine byteswap_RV

! ********************************
! *
    Subroutine byteswap_D(d)
! *
! ********************************

      Real (kind=8), Intent (inout) :: d
      
      Character (kind=1) :: isw(8)
      Real (kind=8) :: dd(1)

      isw  = Transfer(d,isw, 8)
      dd   = Transfer(isw(8:1:-1), dd)
      d  = dd(1)

      Return
    End Subroutine byteswap_D

! ********************************
! *
    Subroutine byteswap_DV(d)
! *
! ********************************

      Real (kind=8), Intent (inout) :: d(:)
      
      Character (kind=1) :: isw(8)
      Real (kind=8) :: dd(1)
      Integer :: I

      Do I = 1, Size(d)
         isw  = Transfer(d(I),isw, 8)
         dd   = Transfer(isw(8:1:-1), dd)
         d(I) = dd(1)
      End Do

      Return
    End Subroutine byteswap_DV

! ********************************
! *
    Subroutine byteswap_Z(z)
! *
! ********************************

      Complex (kind=4), Intent (inout) :: z
      
      Real (kind=4) :: d(2)

      d = Transfer(z,d)
      CALL ByteSwap(d)
      z = Transfer(d, z)

      Return
    End Subroutine byteswap_Z

! ********************************
! *
    Subroutine byteswap_DZ(z)
! *
! ********************************

      Complex (kind=8), Intent (inout) :: z
      
      Real (kind=8) :: d(2)

      d = Transfer(z,d)
      CALL ByteSwap(d)
      z = Transfer(d, z)

      Return
    End Subroutine byteswap_DZ

! ********************************
! *
    Subroutine byteswap_DZV(z)
! *
! ********************************

      Complex (kind=8), Intent (inout) :: z(:)
      
      Real (kind=8) :: d(2)
      Integer :: I

      Do I = 1, Size(z)
         d = Transfer(z(I),d)
         CALL ByteSwap(d)
         z(I) = Transfer(d, z(I))
      End Do

      Return
    End Subroutine byteswap_DZV

! ********************************
! *
    Subroutine byteswap_ZV(z)
! *
! ********************************

      Complex (kind=4), Intent (inout) :: z(:)
      
      Real (kind=4) :: d(2)
      Integer :: I

      Do I = 1, Size(z)
         d = Transfer(z(I),d)
         CALL ByteSwap(d)
         z(I) = Transfer(d, z(I))
      End Do

      Return
    End Subroutine byteswap_ZV

    
End MODULE BDio
