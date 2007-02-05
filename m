From: akpm@linux-foundation.org
Subject: + drivers-video-sis-convert-to-generic-boolean.patch added to -mm tree
Date: Mon, 05 Feb 2007 13:02:20 -0800
Message-ID: <200702052102.l15L2KsA031085@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33374 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933437AbXBEVDC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 16:03:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ricknu-0@student.ltu.se, jsimmons@infradead.org, thomas@tungstengraphics.com


The patch titled
     drivers/video/sis: Convert to generic boolean
has been added to the -mm tree.  Its filename is
     drivers-video-sis-convert-to-generic-boolean.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/video/sis: Convert to generic boolean
From: Richard Knutsson <ricknu-0@student.ltu.se>

Convert:
FALSE   -> false
TRUE    -> true
BOOLEAN -> bool

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Thomas Hellstrom <thomas@tungstengraphics.com>
Cc: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/sis/init.c       |  140 ++++++++--------
 drivers/video/sis/init.h       |   36 ++--
 drivers/video/sis/init301.c    |  260 +++++++++++++++----------------
 drivers/video/sis/init301.h    |   14 -
 drivers/video/sis/initextlfb.c |   18 +-
 drivers/video/sis/sis.h        |    2 
 drivers/video/sis/sis_main.c   |  214 ++++++++++++-------------
 drivers/video/sis/sis_main.h   |  112 ++++++-------
 drivers/video/sis/vgatypes.h   |   12 -
 drivers/video/sis/vstruct.h    |   44 ++---
 10 files changed, 420 insertions(+), 432 deletions(-)

diff -puN drivers/video/sis/init.c~drivers-video-sis-convert-to-generic-boolean drivers/video/sis/init.c
--- a/drivers/video/sis/init.c~drivers-video-sis-convert-to-generic-boolean
+++ a/drivers/video/sis/init.c
@@ -317,23 +317,23 @@ InitTo310Pointer(struct SiS_Private *SiS
 }
 #endif
 
-BOOLEAN
+bool
 SiSInitPtr(struct SiS_Private *SiS_Pr)
 {
    if(SiS_Pr->ChipType < SIS_315H) {
 #ifdef SIS300
       InitTo300Pointer(SiS_Pr);
 #else
-      return FALSE;
+      return false;
 #endif
    } else {
 #ifdef SIS315H
       InitTo310Pointer(SiS_Pr);
 #else
-      return FALSE;
+      return false;
 #endif
    }
-   return TRUE;
+   return true;
 }
 
 /*********************************************/
@@ -345,7 +345,7 @@ static
 #endif
 unsigned short
 SiS_GetModeID(int VGAEngine, unsigned int VBFlags, int HDisplay, int VDisplay,
-		int Depth, BOOLEAN FSTN, int LCDwidth, int LCDheight)
+		int Depth, bool FSTN, int LCDwidth, int LCDheight)
 {
    unsigned short ModeIndex = 0;
 
@@ -483,7 +483,7 @@ SiS_GetModeID(int VGAEngine, unsigned in
 
 unsigned short
 SiS_GetModeID_LCD(int VGAEngine, unsigned int VBFlags, int HDisplay, int VDisplay,
-		int Depth, BOOLEAN FSTN, unsigned short CustomT, int LCDwidth, int LCDheight,
+		int Depth, bool FSTN, unsigned short CustomT, int LCDwidth, int LCDheight,
 		unsigned int VBFlags2)
 {
    unsigned short ModeIndex = 0;
@@ -873,7 +873,7 @@ SiS_GetModeID_VGA2(int VGAEngine, unsign
 		break;
    }
 
-   return SiS_GetModeID(VGAEngine, 0, HDisplay, VDisplay, Depth, FALSE, 0, 0);
+   return SiS_GetModeID(VGAEngine, 0, HDisplay, VDisplay, Depth, false, 0, 0);
 }
 
 
@@ -1020,12 +1020,12 @@ SiS_GetSysFlags(struct SiS_Private *SiS_
 
    /* 661 and newer: NEVER write non-zero to SR11[7:4] */
    /* (SR11 is used for DDC and in enable/disablebridge) */
-   SiS_Pr->SiS_SensibleSR11 = FALSE;
+   SiS_Pr->SiS_SensibleSR11 = false;
    SiS_Pr->SiS_MyCR63 = 0x63;
    if(SiS_Pr->ChipType >= SIS_330) {
       SiS_Pr->SiS_MyCR63 = 0x53;
       if(SiS_Pr->ChipType >= SIS_661) {
-         SiS_Pr->SiS_SensibleSR11 = TRUE;
+         SiS_Pr->SiS_SensibleSR11 = true;
       }
    }
 
@@ -1253,7 +1253,7 @@ SiS_GetModeFlag(struct SiS_Private *SiS_
 /*        HELPER: Determine ROM usage        */
 /*********************************************/
 
-BOOLEAN
+bool
 SiSDetermineROMLayout661(struct SiS_Private *SiS_Pr)
 {
    unsigned char  *ROMAddr  = SiS_Pr->VirtualRomBase;
@@ -1261,16 +1261,16 @@ SiSDetermineROMLayout661(struct SiS_Priv
 
    if(SiS_Pr->ChipType >= XGI_20) {
       /* XGI ROMs don't qualify */
-      return FALSE;
+      return false;
    } else if(SiS_Pr->ChipType >= SIS_761) {
       /* I very much assume 761, 340 and newer will use new layout */
-      return TRUE;
+      return true;
    } else if(SiS_Pr->ChipType >= SIS_661) {
       if((ROMAddr[0x1a] == 'N') &&
 	 (ROMAddr[0x1b] == 'e') &&
 	 (ROMAddr[0x1c] == 'w') &&
 	 (ROMAddr[0x1d] == 'V')) {
-	 return TRUE;
+	 return true;
       }
       romversoffs = ROMAddr[0x16] | (ROMAddr[0x17] << 8);
       if(romversoffs) {
@@ -1280,17 +1280,17 @@ SiSDetermineROMLayout661(struct SiS_Priv
 	 }
       }
       if((romvmaj != 0) || (romvmin >= 92)) {
-	 return TRUE;
+	 return true;
       }
    } else if(IS_SIS650740) {
       if((ROMAddr[0x1a] == 'N') &&
 	 (ROMAddr[0x1b] == 'e') &&
 	 (ROMAddr[0x1c] == 'w') &&
 	 (ROMAddr[0x1d] == 'V')) {
-	 return TRUE;
+	 return true;
       }
    }
-   return FALSE;
+   return false;
 }
 
 static void
@@ -1299,8 +1299,8 @@ SiSDetermineROMUsage(struct SiS_Private 
    unsigned char  *ROMAddr  = SiS_Pr->VirtualRomBase;
    unsigned short romptr = 0;
 
-   SiS_Pr->SiS_UseROM = FALSE;
-   SiS_Pr->SiS_ROMNew = FALSE;
+   SiS_Pr->SiS_UseROM = false;
+   SiS_Pr->SiS_ROMNew = false;
    SiS_Pr->SiS_PWDOffset = 0;
 
    if(SiS_Pr->ChipType >= XGI_20) return;
@@ -1312,15 +1312,15 @@ SiSDetermineROMUsage(struct SiS_Private 
 	  * of the BIOS image.
 	  */
 	 if((ROMAddr[3] == 0xe9) && ((ROMAddr[5] << 8) | ROMAddr[4]) > 0x21a)
-	    SiS_Pr->SiS_UseROM = TRUE;
+	    SiS_Pr->SiS_UseROM = true;
       } else if(SiS_Pr->ChipType < SIS_315H) {
 	 /* Sony's VAIO BIOS 1.09 follows the standard, so perhaps
 	  * the others do as well
 	  */
-	 SiS_Pr->SiS_UseROM = TRUE;
+	 SiS_Pr->SiS_UseROM = true;
       } else {
 	 /* 315/330 series stick to the standard(s) */
-	 SiS_Pr->SiS_UseROM = TRUE;
+	 SiS_Pr->SiS_UseROM = true;
 	 if((SiS_Pr->SiS_ROMNew = SiSDetermineROMLayout661(SiS_Pr))) {
 	    SiS_Pr->SiS_EMIOffset = 14;
 	    SiS_Pr->SiS_PWDOffset = 17;
@@ -1488,7 +1488,7 @@ SiS_GetVBType(struct SiS_Private *SiS_Pr
 /*********************************************/
 
 #ifdef SIS_LINUX_KERNEL
-static BOOLEAN
+static bool
 SiS_CheckMemorySize(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
 		unsigned short ModeIdIndex)
 {
@@ -1496,10 +1496,10 @@ SiS_CheckMemorySize(struct SiS_Private *
    unsigned short modeflag = SiS_GetModeFlag(SiS_Pr, ModeNo, ModeIdIndex);
    unsigned short memorysize = ((modeflag & MemoryInfoFlag) >> MemorySizeShift) + 1;
 
-   if(!AdapterMemSize) return TRUE;
+   if(!AdapterMemSize) return true;
 
-   if(AdapterMemSize < memorysize) return FALSE;
-   return TRUE;
+   if(AdapterMemSize < memorysize) return false;
+   return true;
 }
 #endif
 
@@ -1605,7 +1605,7 @@ SiS_ClearBuffer(struct SiS_Private *SiS_
 /*           HELPER: SearchModeID            */
 /*********************************************/
 
-BOOLEAN
+bool
 SiS_SearchModeID(struct SiS_Private *SiS_Pr, unsigned short *ModeNo,
 		unsigned short *ModeIdIndex)
 {
@@ -1617,7 +1617,7 @@ SiS_SearchModeID(struct SiS_Private *SiS
 
       for((*ModeIdIndex) = 0; ;(*ModeIdIndex)++) {
 	 if(SiS_Pr->SiS_SModeIDTable[(*ModeIdIndex)].St_ModeID == (*ModeNo)) break;
-	 if(SiS_Pr->SiS_SModeIDTable[(*ModeIdIndex)].St_ModeID == 0xFF) return FALSE;
+	 if(SiS_Pr->SiS_SModeIDTable[(*ModeIdIndex)].St_ModeID == 0xFF) return false;
       }
 
       if((*ModeNo) == 0x07) {
@@ -1635,11 +1635,11 @@ SiS_SearchModeID(struct SiS_Private *SiS
 
       for((*ModeIdIndex) = 0; ;(*ModeIdIndex)++) {
 	 if(SiS_Pr->SiS_EModeIDTable[(*ModeIdIndex)].Ext_ModeID == (*ModeNo)) break;
-	 if(SiS_Pr->SiS_EModeIDTable[(*ModeIdIndex)].Ext_ModeID == 0xFF) return FALSE;
+	 if(SiS_Pr->SiS_EModeIDTable[(*ModeIdIndex)].Ext_ModeID == 0xFF) return false;
       }
 
    }
-   return TRUE;
+   return true;
 }
 
 /*********************************************/
@@ -1696,13 +1696,13 @@ SiS_GetRefCRT1CRTC(struct SiS_Private *S
 /*           HELPER: LowModeTests            */
 /*********************************************/
 
-static BOOLEAN
+static bool
 SiS_DoLowModeTest(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
 {
    unsigned short temp, temp1, temp2;
 
    if((ModeNo != 0x03) && (ModeNo != 0x10) && (ModeNo != 0x12))
-      return TRUE;
+      return true;
    temp = SiS_GetReg(SiS_Pr->SiS_P3d4,0x11);
    SiS_SetRegOR(SiS_Pr->SiS_P3d4,0x11,0x80);
    temp1 = SiS_GetReg(SiS_Pr->SiS_P3d4,0x00);
@@ -1712,13 +1712,13 @@ SiS_DoLowModeTest(struct SiS_Private *Si
    SiS_SetReg(SiS_Pr->SiS_P3d4,0x11,temp);
    if((SiS_Pr->ChipType >= SIS_315H) ||
       (SiS_Pr->ChipType == SIS_300)) {
-      if(temp2 == 0x55) return FALSE;
-      else return TRUE;
+      if(temp2 == 0x55) return false;
+      else return true;
    } else {
-      if(temp2 != 0x55) return TRUE;
+      if(temp2 != 0x55) return true;
       else {
 	 SiS_SetRegOR(SiS_Pr->SiS_P3d4,0x35,0x01);
-	 return FALSE;
+	 return false;
       }
    }
 }
@@ -3237,14 +3237,14 @@ static void
 SiS_SetPitch(struct SiS_Private *SiS_Pr, ScrnInfoPtr pScrn)
 {
    SISPtr pSiS = SISPTR(pScrn);
-   BOOLEAN isslavemode = FALSE;
+   bool isslavemode = false;
 
    if( (pSiS->VBFlags2 & VB2_VIDEOBRIDGE) &&
        ( ((pSiS->VGAEngine == SIS_300_VGA) &&
 	  (SiS_GetReg(SiS_Pr->SiS_Part1Port,0x00) & 0xa0) == 0x20) ||
 	 ((pSiS->VGAEngine == SIS_315_VGA) &&
 	  (SiS_GetReg(SiS_Pr->SiS_Part1Port,0x00) & 0x50) == 0x10) ) ) {
-      isslavemode = TRUE;
+      isslavemode = true;
    }
 
    /* We need to set pitch for CRT1 if bridge is in slave mode, too */
@@ -3264,10 +3264,10 @@ SiS_SetPitch(struct SiS_Private *SiS_Pr,
 
 #ifdef SIS_XORG_XF86
 /* We need pScrn for setting the pitch correctly */
-BOOLEAN
-SiSSetMode(struct SiS_Private *SiS_Pr, ScrnInfoPtr pScrn, unsigned short ModeNo, BOOLEAN dosetpitch)
+bool
+SiSSetMode(struct SiS_Private *SiS_Pr, ScrnInfoPtr pScrn, unsigned short ModeNo, bool dosetpitch)
 #else
-BOOLEAN
+bool
 SiSSetMode(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
 #endif
 {
@@ -3277,8 +3277,8 @@ SiSSetMode(struct SiS_Private *SiS_Pr, u
 #ifdef SIS_LINUX_KERNEL
    unsigned short KeepLockReg;
 
-   SiS_Pr->UseCustomMode = FALSE;
-   SiS_Pr->CRT1UsesCustomMode = FALSE;
+   SiS_Pr->UseCustomMode = false;
+   SiS_Pr->CRT1UsesCustomMode = false;
 #endif
 
    SiS_Pr->SiS_flag_clearbuffer = 0;
@@ -3317,7 +3317,7 @@ SiSSetMode(struct SiS_Private *SiS_Pr, u
    SiS_UnLockCRT2(SiS_Pr);
 
    if(!SiS_Pr->UseCustomMode) {
-      if(!(SiS_SearchModeID(SiS_Pr, &ModeNo, &ModeIdIndex))) return FALSE;
+      if(!(SiS_SearchModeID(SiS_Pr, &ModeNo, &ModeIdIndex))) return false;
    } else {
       ModeIdIndex = 0;
    }
@@ -3347,18 +3347,18 @@ SiSSetMode(struct SiS_Private *SiS_Pr, u
 #ifdef SIS_LINUX_KERNEL
    /* Check memory size (kernel framebuffer driver only) */
    if(!SiS_CheckMemorySize(SiS_Pr, ModeNo, ModeIdIndex)) {
-      return FALSE;
+      return false;
    }
 #endif
 
    SiS_OpenCRTC(SiS_Pr);
 
    if(SiS_Pr->UseCustomMode) {
-      SiS_Pr->CRT1UsesCustomMode = TRUE;
+      SiS_Pr->CRT1UsesCustomMode = true;
       SiS_Pr->CSRClock_CRT1 = SiS_Pr->CSRClock;
       SiS_Pr->CModeFlag_CRT1 = SiS_Pr->CModeFlag;
    } else {
-      SiS_Pr->CRT1UsesCustomMode = FALSE;
+      SiS_Pr->CRT1UsesCustomMode = false;
    }
 
    /* Set mode on CRT1 */
@@ -3445,7 +3445,7 @@ SiSSetMode(struct SiS_Private *SiS_Pr, u
    if(KeepLockReg != 0xA1) SiS_SetReg(SiS_Pr->SiS_P3c4,0x05,0x00);
 #endif
 
-   return TRUE;
+   return true;
 }
 
 /*********************************************/
@@ -3454,14 +3454,14 @@ SiSSetMode(struct SiS_Private *SiS_Pr, u
 /*********************************************/
 
 #ifdef SIS_XORG_XF86
-BOOLEAN
+bool
 SiSBIOSSetMode(struct SiS_Private *SiS_Pr, ScrnInfoPtr pScrn,
-               DisplayModePtr mode, BOOLEAN IsCustom)
+               DisplayModePtr mode, bool IsCustom)
 {
    SISPtr pSiS = SISPTR(pScrn);
    unsigned short ModeNo = 0;
 
-   SiS_Pr->UseCustomMode = FALSE;
+   SiS_Pr->UseCustomMode = false;
 
    if((IsCustom) && (SiS_CheckBuildCustomMode(pScrn, mode, pSiS->VBFlags))) {
 
@@ -3475,13 +3475,13 @@ SiSBIOSSetMode(struct SiS_Private *SiS_P
 
       /* Don't need vbflags here; checks done earlier */
       ModeNo = SiS_GetModeNumber(pScrn, mode, pSiS->VBFlags);
-      if(!ModeNo) return FALSE;
+      if(!ModeNo) return false;
 
       xf86DrvMsgVerb(pScrn->scrnIndex, X_INFO, 3, "Setting standard mode 0x%x\n", ModeNo);
 
    }
 
-   return(SiSSetMode(SiS_Pr, pScrn, ModeNo, TRUE));
+   return(SiSSetMode(SiS_Pr, pScrn, ModeNo, true));
 }
 
 /*********************************************/
@@ -3489,9 +3489,9 @@ SiSBIOSSetMode(struct SiS_Private *SiS_P
 /*           for Dual-Head modes             */
 /*********************************************/
 
-BOOLEAN
+bool
 SiSBIOSSetModeCRT2(struct SiS_Private *SiS_Pr, ScrnInfoPtr pScrn,
-               DisplayModePtr mode, BOOLEAN IsCustom)
+               DisplayModePtr mode, bool IsCustom)
 {
    SISIOADDRESS BaseAddr = SiS_Pr->IOAddress;
    SISPtr  pSiS = SISPTR(pScrn);
@@ -3502,7 +3502,7 @@ SiSBIOSSetModeCRT2(struct SiS_Private *S
    unsigned short ModeNo = 0;
    unsigned char  backupreg = 0;
 
-   SiS_Pr->UseCustomMode = FALSE;
+   SiS_Pr->UseCustomMode = false;
 
    /* Remember: Custom modes for CRT2 are ONLY supported
     *     -) on the 30x/B/C, and
@@ -3516,7 +3516,7 @@ SiSBIOSSetModeCRT2(struct SiS_Private *S
    } else {
 
 	 ModeNo = SiS_GetModeNumber(pScrn, mode, pSiS->VBFlags);
-	 if(!ModeNo) return FALSE;
+	 if(!ModeNo) return false;
 
    }
 
@@ -3550,10 +3550,10 @@ SiSBIOSSetModeCRT2(struct SiS_Private *S
       if(pSiSEnt->CRT1ModeNo == -1) {
 	 xf86DrvMsgVerb(pScrn->scrnIndex, X_INFO, 3,
 		"Setting CRT2 mode delayed until after setting CRT1 mode\n");
-	 return TRUE;
+	 return true;
       }
 #endif
-      pSiSEnt->CRT2ModeSet = TRUE;
+      pSiSEnt->CRT2ModeSet = true;
    }
 #endif
 
@@ -3578,7 +3578,7 @@ SiSBIOSSetModeCRT2(struct SiS_Private *S
    SiS_UnLockCRT2(SiS_Pr);
 
    if(!SiS_Pr->UseCustomMode) {
-      if(!(SiS_SearchModeID(SiS_Pr, &ModeNo, &ModeIdIndex))) return FALSE;
+      if(!(SiS_SearchModeID(SiS_Pr, &ModeNo, &ModeIdIndex))) return false;
    } else {
       ModeIdIndex = 0;
    }
@@ -3658,7 +3658,7 @@ SiSBIOSSetModeCRT2(struct SiS_Private *S
 
    SiS_Handle760(SiS_Pr);
 
-   return TRUE;
+   return true;
 }
 
 /*********************************************/
@@ -3666,9 +3666,9 @@ SiSBIOSSetModeCRT2(struct SiS_Private *S
 /*           for Dual-Head modes             */
 /*********************************************/
 
-BOOLEAN
+bool
 SiSBIOSSetModeCRT1(struct SiS_Private *SiS_Pr, ScrnInfoPtr pScrn,
-                   DisplayModePtr mode, BOOLEAN IsCustom)
+                   DisplayModePtr mode, bool IsCustom)
 {
    SISIOADDRESS BaseAddr = SiS_Pr->IOAddress;
    SISPtr  pSiS = SISPTR(pScrn);
@@ -3677,10 +3677,10 @@ SiSBIOSSetModeCRT1(struct SiS_Private *S
 #ifdef SISDUALHEAD
    SISEntPtr pSiSEnt = pSiS->entityPrivate;
    unsigned char  backupcr30, backupcr31, backupcr38, backupcr35, backupp40d=0;
-   BOOLEAN backupcustom;
+   bool backupcustom;
 #endif
 
-   SiS_Pr->UseCustomMode = FALSE;
+   SiS_Pr->UseCustomMode = false;
 
    if((IsCustom) && (SiS_CheckBuildCustomMode(pScrn, mode, pSiS->VBFlags))) {
 
@@ -3697,7 +3697,7 @@ SiSBIOSSetModeCRT1(struct SiS_Private *S
    } else {
 
 	 ModeNo = SiS_GetModeNumber(pScrn, mode, 0); /* don't give VBFlags */
-	 if(!ModeNo) return FALSE;
+	 if(!ModeNo) return false;
 
 	 xf86DrvMsgVerb(pScrn->scrnIndex, X_INFO, 3,
 	 	"Setting standard mode 0x%x on CRT1\n", ModeNo);
@@ -3721,7 +3721,7 @@ SiSBIOSSetModeCRT1(struct SiS_Private *S
    SiS_UnLockCRT2(SiS_Pr);
 
    if(!SiS_Pr->UseCustomMode) {
-      if(!(SiS_SearchModeID(SiS_Pr, &ModeNo, &ModeIdIndex))) return FALSE;
+      if(!(SiS_SearchModeID(SiS_Pr, &ModeNo, &ModeIdIndex))) return false;
    } else {
       ModeIdIndex = 0;
    }
@@ -3771,11 +3771,11 @@ SiSBIOSSetModeCRT1(struct SiS_Private *S
 #endif
 
    if(SiS_Pr->UseCustomMode) {
-      SiS_Pr->CRT1UsesCustomMode = TRUE;
+      SiS_Pr->CRT1UsesCustomMode = true;
       SiS_Pr->CSRClock_CRT1 = SiS_Pr->CSRClock;
       SiS_Pr->CModeFlag_CRT1 = SiS_Pr->CModeFlag;
    } else {
-      SiS_Pr->CRT1UsesCustomMode = FALSE;
+      SiS_Pr->CRT1UsesCustomMode = false;
    }
 
    /* Reset CRT2 if changing mode on CRT1 */
@@ -3838,7 +3838,7 @@ SiSBIOSSetModeCRT1(struct SiS_Private *S
    /* Backup/Set ModeNo in BIOS scratch area */
    SiS_GetSetModeID(pScrn,ModeNo);
 
-   return TRUE;
+   return true;
 }
 #endif /* Linux_XF86 */
 
@@ -4082,7 +4082,7 @@ SiS_Generic_ConvertCRData(struct SiS_Pri
 			DisplayModePtr current
 #endif
 #ifdef SIS_LINUX_KERNEL
-			struct fb_var_screeninfo *var, BOOLEAN writeres
+			struct fb_var_screeninfo *var, bool writeres
 #endif
 )
 {
diff -puN drivers/video/sis/init.h~drivers-video-sis-convert-to-generic-boolean drivers/video/sis/init.h
--- a/drivers/video/sis/init.h~drivers-video-sis-convert-to-generic-boolean
+++ a/drivers/video/sis/init.h
@@ -1521,13 +1521,13 @@ static const struct SiS_LVDSCRT1Data SiS
    0x00}}
 };
 
-BOOLEAN		SiSInitPtr(struct SiS_Private *SiS_Pr);
+bool		SiSInitPtr(struct SiS_Private *SiS_Pr);
 #ifdef SIS_XORG_XF86
 unsigned short	SiS_GetModeID(int VGAEngine, unsigned int VBFlags, int HDisplay, int VDisplay,
-				int Depth, BOOLEAN FSTN, int LCDwith, int LCDheight);
+				int Depth, bool FSTN, int LCDwith, int LCDheight);
 #endif
 unsigned short	SiS_GetModeID_LCD(int VGAEngine, unsigned int VBFlags, int HDisplay,
-				int VDisplay, int Depth, BOOLEAN FSTN,
+				int VDisplay, int Depth, bool FSTN,
 				unsigned short CustomT, int LCDwith, int LCDheight,
 				unsigned int VBFlags2);
 unsigned short	SiS_GetModeID_TV(int VGAEngine, unsigned int VBFlags, int HDisplay,
@@ -1558,12 +1558,12 @@ void		SiS_SetEnableDstn(struct SiS_Priva
 void		SiS_SetEnableFstn(struct SiS_Private *SiS_Pr, int enable);
 unsigned short	SiS_GetModeFlag(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
 				unsigned short ModeIdIndex);
-BOOLEAN		SiSDetermineROMLayout661(struct SiS_Private *SiS_Pr);
+bool		SiSDetermineROMLayout661(struct SiS_Private *SiS_Pr);
 #ifndef SIS_LINUX_KERNEL
 void		SiS_GetVBType(struct SiS_Private *SiS_Pr);
 #endif
 
-BOOLEAN		SiS_SearchModeID(struct SiS_Private *SiS_Pr, unsigned short *ModeNo,
+bool		SiS_SearchModeID(struct SiS_Private *SiS_Pr, unsigned short *ModeNo,
 				unsigned short *ModeIdIndex);
 unsigned short	SiS_GetModePtr(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
 				unsigned short ModeIdIndex);
@@ -1581,17 +1581,17 @@ unsigned short	SiS_GetLatencyFactor630(s
 #endif
 void		SiS_LoadDAC(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short ModeIdIndex);
 #ifdef SIS_XORG_XF86
-BOOLEAN		SiSSetMode(struct SiS_Private *SiS_Pr, ScrnInfoPtr pScrn, unsigned short ModeNo,
-				BOOLEAN dosetpitch);
-BOOLEAN		SiSBIOSSetMode(struct SiS_Private *SiS_Pr, ScrnInfoPtr pScrn,
-				DisplayModePtr mode, BOOLEAN IsCustom);
-BOOLEAN		SiSBIOSSetModeCRT2(struct SiS_Private *SiS_Pr, ScrnInfoPtr pScrn,
-				DisplayModePtr mode, BOOLEAN IsCustom);
-BOOLEAN		SiSBIOSSetModeCRT1(struct SiS_Private *SiS_Pr, ScrnInfoPtr pScrn,
-				DisplayModePtr mode, BOOLEAN IsCustom);
+bool		SiSSetMode(struct SiS_Private *SiS_Pr, ScrnInfoPtr pScrn, unsigned short ModeNo,
+				bool dosetpitch);
+bool		SiSBIOSSetMode(struct SiS_Private *SiS_Pr, ScrnInfoPtr pScrn,
+				DisplayModePtr mode, bool IsCustom);
+bool		SiSBIOSSetModeCRT2(struct SiS_Private *SiS_Pr, ScrnInfoPtr pScrn,
+				DisplayModePtr mode, bool IsCustom);
+bool		SiSBIOSSetModeCRT1(struct SiS_Private *SiS_Pr, ScrnInfoPtr pScrn,
+				DisplayModePtr mode, bool IsCustom);
 #endif
 #ifdef SIS_LINUX_KERNEL
-BOOLEAN		SiSSetMode(struct SiS_Private *SiS_Pr, unsigned short ModeNo);
+bool		SiSSetMode(struct SiS_Private *SiS_Pr, unsigned short ModeNo);
 #endif
 void		SiS_CalcCRRegisters(struct SiS_Private *SiS_Pr, int depth);
 void		SiS_CalcLCDACRT1Timing(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
@@ -1602,7 +1602,7 @@ void		SiS_Generic_ConvertCRData(struct S
 #endif
 #ifdef SIS_LINUX_KERNEL
 void		SiS_Generic_ConvertCRData(struct SiS_Private *SiS_Pr, unsigned char *crdata, int xres,
-				int yres, struct fb_var_screeninfo *var, BOOLEAN writeres);
+				int yres, struct fb_var_screeninfo *var, bool writeres);
 #endif
 
 /* From init301.c: */
@@ -1615,7 +1615,7 @@ extern void		SiS_SetTVMode(struct SiS_Pr
 				unsigned short ModeIdIndex);
 extern void		SiS_UnLockCRT2(struct SiS_Private *SiS_Pr);
 extern void		SiS_DisableBridge(struct SiS_Private *);
-extern BOOLEAN		SiS_SetCRT2Group(struct SiS_Private *, unsigned short);
+extern bool		SiS_SetCRT2Group(struct SiS_Private *, unsigned short);
 extern unsigned short	SiS_GetRatePtr(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
 				unsigned short ModeIdIndex);
 extern void		SiS_WaitRetrace1(struct SiS_Private *SiS_Pr);
@@ -1624,8 +1624,8 @@ extern unsigned short	SiS_GetResInfo(str
 extern unsigned short	SiS_GetCH700x(struct SiS_Private *SiS_Pr, unsigned short tempax);
 extern unsigned short	SiS_GetVCLK2Ptr(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
 				unsigned short ModeIdIndex, unsigned short RRTI);
-extern BOOLEAN		SiS_IsVAMode(struct SiS_Private *);
-extern BOOLEAN		SiS_IsDualEdge(struct SiS_Private *);
+extern bool		SiS_IsVAMode(struct SiS_Private *);
+extern bool		SiS_IsDualEdge(struct SiS_Private *);
 
 #ifdef SIS_XORG_XF86
 /* From other modules: */
diff -puN drivers/video/sis/init301.c~drivers-video-sis-convert-to-generic-boolean drivers/video/sis/init301.c
--- a/drivers/video/sis/init301.c~drivers-video-sis-convert-to-generic-boolean
+++ a/drivers/video/sis/init301.c
@@ -200,7 +200,7 @@ GetLCDStructPtr661_2(struct SiS_Private 
 /*           Adjust Rate for CRT2            */
 /*********************************************/
 
-static BOOLEAN
+static bool
 SiS_AdjustCRT2Rate(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short ModeIdIndex,
 		unsigned short RRTI, unsigned short *i)
 {
@@ -269,7 +269,7 @@ SiS_AdjustCRT2Rate(struct SiS_Private *S
    /* Look backwards in table for matching CRT2 mode */
    for(; SiS_Pr->SiS_RefIndex[RRTI + (*i)].ModeID == modeid; (*i)--) {
       infoflag = SiS_Pr->SiS_RefIndex[RRTI + (*i)].Ext_InfoFlag;
-      if(infoflag & checkmask) return TRUE;
+      if(infoflag & checkmask) return true;
       if((*i) == 0) break;
    }
 
@@ -279,9 +279,9 @@ SiS_AdjustCRT2Rate(struct SiS_Private *S
    for((*i) = 0; ; (*i)++) {
       if(SiS_Pr->SiS_RefIndex[RRTI + (*i)].ModeID != modeid) break;
       infoflag = SiS_Pr->SiS_RefIndex[RRTI + (*i)].Ext_InfoFlag;
-      if(infoflag & checkmask) return TRUE;
+      if(infoflag & checkmask) return true;
    }
-   return FALSE;
+   return false;
 }
 
 /*********************************************/
@@ -405,7 +405,7 @@ SiS_SaveCRT2Info(struct SiS_Private *SiS
 /*********************************************/
 
 #ifdef SIS300
-static BOOLEAN
+static bool
 SiS_CR36BIOSWord23b(struct SiS_Private *SiS_Pr)
 {
    unsigned char  *ROMAddr = SiS_Pr->VirtualRomBase;
@@ -415,13 +415,13 @@ SiS_CR36BIOSWord23b(struct SiS_Private *
       if((ROMAddr[0x233] == 0x12) && (ROMAddr[0x234] == 0x34)) {
 	 temp = 1 << ((SiS_GetReg(SiS_Pr->SiS_P3d4,0x36) >> 4) & 0x0f);
 	 temp1 = SISGETROMW(0x23b);
-	 if(temp1 & temp) return TRUE;
+	 if(temp1 & temp) return true;
       }
    }
-   return FALSE;
+   return false;
 }
 
-static BOOLEAN
+static bool
 SiS_CR36BIOSWord23d(struct SiS_Private *SiS_Pr)
 {
    unsigned char  *ROMAddr = SiS_Pr->VirtualRomBase;
@@ -431,10 +431,10 @@ SiS_CR36BIOSWord23d(struct SiS_Private *
       if((ROMAddr[0x233] == 0x12) && (ROMAddr[0x234] == 0x34)) {
 	 temp = 1 << ((SiS_GetReg(SiS_Pr->SiS_P3d4,0x36) >> 4) & 0x0f);
 	 temp1 = SISGETROMW(0x23d);
-	 if(temp1 & temp) return TRUE;
+	 if(temp1 & temp) return true;
       }
    }
-   return FALSE;
+   return false;
 }
 #endif
 
@@ -687,38 +687,38 @@ SiS_VBLongWait(struct SiS_Private *SiS_P
 /*********************************************/
 
 #ifdef SIS300
-static BOOLEAN
+static bool
 SiS_Is301B(struct SiS_Private *SiS_Pr)
 {
-   if(SiS_GetReg(SiS_Pr->SiS_Part4Port,0x01) >= 0xb0) return TRUE;
-   return FALSE;
+   if(SiS_GetReg(SiS_Pr->SiS_Part4Port,0x01) >= 0xb0) return true;
+   return false;
 }
 #endif
 
-static BOOLEAN
+static bool
 SiS_CRT2IsLCD(struct SiS_Private *SiS_Pr)
 {
    if(SiS_Pr->ChipType == SIS_730) {
-      if(SiS_GetReg(SiS_Pr->SiS_P3c4,0x13) & 0x20) return TRUE;
+      if(SiS_GetReg(SiS_Pr->SiS_P3c4,0x13) & 0x20) return true;
    }
-   if(SiS_GetReg(SiS_Pr->SiS_P3d4,0x30) & 0x20) return TRUE;
-   return FALSE;
+   if(SiS_GetReg(SiS_Pr->SiS_P3d4,0x30) & 0x20) return true;
+   return false;
 }
 
-BOOLEAN
+bool
 SiS_IsDualEdge(struct SiS_Private *SiS_Pr)
 {
 #ifdef SIS315H
    if(SiS_Pr->ChipType >= SIS_315H) {
       if((SiS_Pr->ChipType != SIS_650) || (SiS_GetReg(SiS_Pr->SiS_P3d4,0x5f) & 0xf0)) {
-	 if(SiS_GetReg(SiS_Pr->SiS_P3d4,0x38) & EnableDualEdge) return TRUE;
+	 if(SiS_GetReg(SiS_Pr->SiS_P3d4,0x38) & EnableDualEdge) return true;
       }
    }
 #endif
-   return FALSE;
+   return false;
 }
 
-BOOLEAN
+bool
 SiS_IsVAMode(struct SiS_Private *SiS_Pr)
 {
 #ifdef SIS315H
@@ -726,70 +726,70 @@ SiS_IsVAMode(struct SiS_Private *SiS_Pr)
 
    if(SiS_Pr->ChipType >= SIS_315H) {
       flag = SiS_GetReg(SiS_Pr->SiS_P3d4,0x38);
-      if((flag & EnableDualEdge) && (flag & SetToLCDA)) return TRUE;
+      if((flag & EnableDualEdge) && (flag & SetToLCDA)) return true;
    }
 #endif
-   return FALSE;
+   return false;
 }
 
 #ifdef SIS315H
-static BOOLEAN
+static bool
 SiS_IsVAorLCD(struct SiS_Private *SiS_Pr)
 {
-   if(SiS_IsVAMode(SiS_Pr))  return TRUE;
-   if(SiS_CRT2IsLCD(SiS_Pr)) return TRUE;
-   return FALSE;
+   if(SiS_IsVAMode(SiS_Pr))  return true;
+   if(SiS_CRT2IsLCD(SiS_Pr)) return true;
+   return false;
 }
 #endif
 
-static BOOLEAN
+static bool
 SiS_IsDualLink(struct SiS_Private *SiS_Pr)
 {
 #ifdef SIS315H
    if(SiS_Pr->ChipType >= SIS_315H) {
       if((SiS_CRT2IsLCD(SiS_Pr)) ||
          (SiS_IsVAMode(SiS_Pr))) {
-	 if(SiS_Pr->SiS_LCDInfo & LCDDualLink) return TRUE;
+	 if(SiS_Pr->SiS_LCDInfo & LCDDualLink) return true;
       }
    }
 #endif
-   return FALSE;
+   return false;
 }
 
 #ifdef SIS315H
-static BOOLEAN
+static bool
 SiS_TVEnabled(struct SiS_Private *SiS_Pr)
 {
-   if((SiS_GetReg(SiS_Pr->SiS_Part2Port,0x00) & 0x0f) != 0x0c) return TRUE;
+   if((SiS_GetReg(SiS_Pr->SiS_Part2Port,0x00) & 0x0f) != 0x0c) return true;
    if(SiS_Pr->SiS_VBType & VB_SISYPBPR) {
-      if(SiS_GetReg(SiS_Pr->SiS_Part2Port,0x4d) & 0x10) return TRUE;
+      if(SiS_GetReg(SiS_Pr->SiS_Part2Port,0x4d) & 0x10) return true;
    }
-   return FALSE;
+   return false;
 }
 #endif
 
 #ifdef SIS315H
-static BOOLEAN
+static bool
 SiS_LCDAEnabled(struct SiS_Private *SiS_Pr)
 {
-   if(SiS_GetReg(SiS_Pr->SiS_Part1Port,0x13) & 0x04) return TRUE;
-   return FALSE;
+   if(SiS_GetReg(SiS_Pr->SiS_Part1Port,0x13) & 0x04) return true;
+   return false;
 }
 #endif
 
 #ifdef SIS315H
-static BOOLEAN
+static bool
 SiS_WeHaveBacklightCtrl(struct SiS_Private *SiS_Pr)
 {
    if((SiS_Pr->ChipType >= SIS_315H) && (SiS_Pr->ChipType < SIS_661)) {
-      if(SiS_GetReg(SiS_Pr->SiS_P3d4,0x79) & 0x10) return TRUE;
+      if(SiS_GetReg(SiS_Pr->SiS_P3d4,0x79) & 0x10) return true;
    }
-   return FALSE;
+   return false;
 }
 #endif
 
 #ifdef SIS315H
-static BOOLEAN
+static bool
 SiS_IsNotM650orLater(struct SiS_Private *SiS_Pr)
 {
    unsigned short flag;
@@ -798,90 +798,90 @@ SiS_IsNotM650orLater(struct SiS_Private 
       flag = SiS_GetReg(SiS_Pr->SiS_P3d4,0x5f) & 0xf0;
       /* Check for revision != A0 only */
       if((flag == 0xe0) || (flag == 0xc0) ||
-         (flag == 0xb0) || (flag == 0x90)) return FALSE;
-   } else if(SiS_Pr->ChipType >= SIS_661) return FALSE;
-   return TRUE;
+         (flag == 0xb0) || (flag == 0x90)) return false;
+   } else if(SiS_Pr->ChipType >= SIS_661) return false;
+   return true;
 }
 #endif
 
 #ifdef SIS315H
-static BOOLEAN
+static bool
 SiS_IsYPbPr(struct SiS_Private *SiS_Pr)
 {
    if(SiS_Pr->ChipType >= SIS_315H) {
       /* YPrPb = 0x08 */
-      if(SiS_GetReg(SiS_Pr->SiS_P3d4,0x38) & EnableCHYPbPr) return TRUE;
+      if(SiS_GetReg(SiS_Pr->SiS_P3d4,0x38) & EnableCHYPbPr) return true;
    }
-   return FALSE;
+   return false;
 }
 #endif
 
 #ifdef SIS315H
-static BOOLEAN
+static bool
 SiS_IsChScart(struct SiS_Private *SiS_Pr)
 {
    if(SiS_Pr->ChipType >= SIS_315H) {
       /* Scart = 0x04 */
-      if(SiS_GetReg(SiS_Pr->SiS_P3d4,0x38) & EnableCHScart) return TRUE;
+      if(SiS_GetReg(SiS_Pr->SiS_P3d4,0x38) & EnableCHScart) return true;
    }
-   return FALSE;
+   return false;
 }
 #endif
 
 #ifdef SIS315H
-static BOOLEAN
+static bool
 SiS_IsTVOrYPbPrOrScart(struct SiS_Private *SiS_Pr)
 {
    unsigned short flag;
 
    if(SiS_Pr->ChipType >= SIS_315H) {
       flag = SiS_GetReg(SiS_Pr->SiS_P3d4,0x30);
-      if(flag & SetCRT2ToTV)        return TRUE;
+      if(flag & SetCRT2ToTV)        return true;
       flag = SiS_GetReg(SiS_Pr->SiS_P3d4,0x38);
-      if(flag & EnableCHYPbPr)      return TRUE;  /* = YPrPb = 0x08 */
-      if(flag & EnableCHScart)      return TRUE;  /* = Scart = 0x04 - TW */
+      if(flag & EnableCHYPbPr)      return true;  /* = YPrPb = 0x08 */
+      if(flag & EnableCHScart)      return true;  /* = Scart = 0x04 - TW */
    } else {
       flag = SiS_GetReg(SiS_Pr->SiS_P3d4,0x30);
-      if(flag & SetCRT2ToTV)        return TRUE;
+      if(flag & SetCRT2ToTV)        return true;
    }
-   return FALSE;
+   return false;
 }
 #endif
 
 #ifdef SIS315H
-static BOOLEAN
+static bool
 SiS_IsLCDOrLCDA(struct SiS_Private *SiS_Pr)
 {
    unsigned short flag;
 
    if(SiS_Pr->ChipType >= SIS_315H) {
       flag = SiS_GetReg(SiS_Pr->SiS_P3d4,0x30);
-      if(flag & SetCRT2ToLCD) return TRUE;
+      if(flag & SetCRT2ToLCD) return true;
       flag = SiS_GetReg(SiS_Pr->SiS_P3d4,0x38);
-      if(flag & SetToLCDA)    return TRUE;
+      if(flag & SetToLCDA)    return true;
    } else {
       flag = SiS_GetReg(SiS_Pr->SiS_P3d4,0x30);
-      if(flag & SetCRT2ToLCD) return TRUE;
+      if(flag & SetCRT2ToLCD) return true;
    }
-   return FALSE;
+   return false;
 }
 #endif
 
-static BOOLEAN
+static bool
 SiS_HaveBridge(struct SiS_Private *SiS_Pr)
 {
    unsigned short flag;
 
    if(SiS_Pr->SiS_IF_DEF_LVDS == 1) {
-      return TRUE;
+      return true;
    } else if(SiS_Pr->SiS_VBType & VB_SISVB) {
       flag = SiS_GetReg(SiS_Pr->SiS_Part4Port,0x00);
-      if((flag == 1) || (flag == 2)) return TRUE;
+      if((flag == 1) || (flag == 2)) return true;
    }
-   return FALSE;
+   return false;
 }
 
-static BOOLEAN
+static bool
 SiS_BridgeIsEnabled(struct SiS_Private *SiS_Pr)
 {
    unsigned short flag;
@@ -890,23 +890,23 @@ SiS_BridgeIsEnabled(struct SiS_Private *
       flag = SiS_GetReg(SiS_Pr->SiS_Part1Port,0x00);
       if(SiS_Pr->ChipType < SIS_315H) {
 	flag &= 0xa0;
-	if((flag == 0x80) || (flag == 0x20)) return TRUE;
+	if((flag == 0x80) || (flag == 0x20)) return true;
       } else {
 	flag &= 0x50;
-	if((flag == 0x40) || (flag == 0x10)) return TRUE;
+	if((flag == 0x40) || (flag == 0x10)) return true;
       }
    }
-   return FALSE;
+   return false;
 }
 
-static BOOLEAN
+static bool
 SiS_BridgeInSlavemode(struct SiS_Private *SiS_Pr)
 {
    unsigned short flag1;
 
    flag1 = SiS_GetReg(SiS_Pr->SiS_P3d4,0x31);
-   if(flag1 & (SetInSlaveMode >> 8)) return TRUE;
-   return FALSE;
+   if(flag1 & (SetInSlaveMode >> 8)) return true;
+   return false;
 }
 
 /*********************************************/
@@ -1461,11 +1461,11 @@ SiS_GetLCDInfoBIOS(struct SiS_Private *S
 
    if((ROMAddr = GetLCDStructPtr661(SiS_Pr))) {
       if((temp = SISGETROMW(6)) != SiS_Pr->PanelHT) {
-	 SiS_Pr->SiS_NeedRomModeData = TRUE;
+	 SiS_Pr->SiS_NeedRomModeData = true;
 	 SiS_Pr->PanelHT  = temp;
       }
       if((temp = SISGETROMW(8)) != SiS_Pr->PanelVT) {
-	 SiS_Pr->SiS_NeedRomModeData = TRUE;
+	 SiS_Pr->SiS_NeedRomModeData = true;
 	 SiS_Pr->PanelVT  = temp;
       }
       SiS_Pr->PanelHRS = SISGETROMW(10);
@@ -1516,7 +1516,7 @@ void
 SiS_GetLCDResInfo(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short ModeIdIndex)
 {
   unsigned short temp,modeflag,resinfo=0,modexres=0,modeyres=0;
-  BOOLEAN panelcanscale = FALSE;
+  bool panelcanscale = false;
 #ifdef SIS300
   unsigned char *ROMAddr = SiS_Pr->VirtualRomBase;
   static const unsigned char SiS300SeriesLCDRes[] =
@@ -1534,10 +1534,10 @@ SiS_GetLCDResInfo(struct SiS_Private *Si
   SiS_Pr->PanelHRE        = 999; /* HSync end */
   SiS_Pr->PanelVRS        = 999; /* VSync start */
   SiS_Pr->PanelVRE        = 999; /* VSync end */
-  SiS_Pr->SiS_NeedRomModeData = FALSE;
+  SiS_Pr->SiS_NeedRomModeData = false;
 
   /* Alternative 1600x1200@60 timing for 1600x1200 LCDA */
-  SiS_Pr->Alternate1600x1200 = FALSE;
+  SiS_Pr->Alternate1600x1200 = false;
 
   if(!(SiS_Pr->SiS_VBInfo & (SetCRT2ToLCD | SetCRT2ToLCDA))) return;
 
@@ -1633,7 +1633,7 @@ SiS_GetLCDResInfo(struct SiS_Private *Si
       SiS_Pr->SiS_LCDInfo |= DontExpandLCD;
   }
 
-  panelcanscale = (SiS_Pr->SiS_LCDInfo & DontExpandLCD) ? TRUE : FALSE;
+  panelcanscale = (bool)(SiS_Pr->SiS_LCDInfo & DontExpandLCD);
 
   if(!SiS_Pr->UsePanelScaler)          SiS_Pr->SiS_LCDInfo &= ~DontExpandLCD;
   else if(SiS_Pr->UsePanelScaler == 1) SiS_Pr->SiS_LCDInfo |= DontExpandLCD;
@@ -1833,7 +1833,7 @@ SiS_GetLCDResInfo(struct SiS_Private *Si
 				  SiS_Pr->PanelHRS =   48; SiS_Pr->PanelHRE =   32;
 				  SiS_Pr->PanelVRS =    2; SiS_Pr->PanelVRE =    4;
 				  SiS_Pr->PanelVCLKIdx315 = VCLK130_315;
-				  SiS_Pr->Alternate1600x1200 = TRUE;
+				  SiS_Pr->Alternate1600x1200 = true;
 			       }
 			    } else if(SiS_Pr->SiS_IF_DEF_LVDS) {
 			       SiS_Pr->PanelHT  = 2048; SiS_Pr->PanelVT  = 1320;
@@ -3448,7 +3448,7 @@ SiS_GetCRT2Data301(struct SiS_Private *S
 
      } else {
 
-	BOOLEAN gotit = FALSE;
+	bool gotit = false;
 
 	if((SiS_Pr->SiS_LCDInfo & DontExpandLCD) && (!(SiS_Pr->SiS_LCDInfo & LCDPass11))) {
 
@@ -3456,7 +3456,7 @@ SiS_GetCRT2Data301(struct SiS_Private *S
 	   SiS_Pr->SiS_VGAVT = SiS_Pr->PanelVT;
 	   SiS_Pr->SiS_HT    = SiS_Pr->PanelHT;
 	   SiS_Pr->SiS_VT    = SiS_Pr->PanelVT;
-	   gotit = TRUE;
+	   gotit = true;
 
 	} else if( (!(SiS_Pr->SiS_LCDInfo & DontExpandLCD)) && (romptr) && (ROMAddr) ) {
 
@@ -3474,7 +3474,7 @@ SiS_GetCRT2Data301(struct SiS_Private *S
 	      if(ROMAddr[romptr+9] & 0x80) SiS_Pr->SiS_RVBHRS2 -= tempax;
 	      else                         SiS_Pr->SiS_RVBHRS2 += tempax;
 	   }
-	   if(SiS_Pr->SiS_VGAHT) gotit = TRUE;
+	   if(SiS_Pr->SiS_VGAHT) gotit = true;
 	   else {
 	      SiS_Pr->SiS_LCDInfo |= DontExpandLCD;
 	      SiS_Pr->SiS_LCDInfo &= ~LCDPass11;
@@ -3485,7 +3485,7 @@ SiS_GetCRT2Data301(struct SiS_Private *S
 	      SiS_Pr->SiS_HT      = SiS_Pr->PanelHT;
 	      SiS_Pr->SiS_VT      = SiS_Pr->PanelVT;
 	      SiS_Pr->SiS_RVBHRS2 = 0;
-	      gotit = TRUE;
+	      gotit = true;
 	   }
 #endif
 
@@ -3960,8 +3960,8 @@ SiS_DisableBridge(struct SiS_Private *Si
 #ifdef SIS315H	   /* 315 series */
 
 	   int didpwd = 0;
-	   BOOLEAN custom1 = ((SiS_Pr->SiS_CustomT == CUT_COMPAQ1280) ||
-	                      (SiS_Pr->SiS_CustomT == CUT_CLEVO1400)) ? TRUE : FALSE;
+	   bool custom1 = (SiS_Pr->SiS_CustomT == CUT_COMPAQ1280) ||
+	                  (SiS_Pr->SiS_CustomT == CUT_CLEVO1400);
 
 	   modenum = SiS_GetReg(SiS_Pr->SiS_P3d4,0x34) & 0x7f;
 
@@ -4313,7 +4313,7 @@ SiS_EnableBridge(struct SiS_Private *SiS
   unsigned short temp=0, tempah;
 #ifdef SIS315H
   unsigned short temp1, pushax=0;
-  BOOLEAN delaylong = FALSE;
+  bool delaylong = false;
 #endif
 
   if(SiS_Pr->SiS_VBType & VB_SISVB) {
@@ -4448,7 +4448,7 @@ SiS_EnableBridge(struct SiS_Private *SiS
 
 	    if(!(SiS_GetReg(SiS_Pr->SiS_P3d4,0x31) & 0x40)) {
 	       SiS_PanelDelayLoop(SiS_Pr, 3, 10);
-	       delaylong = TRUE;
+	       delaylong = true;
 	    }
 
 	 }
@@ -4530,7 +4530,7 @@ SiS_EnableBridge(struct SiS_Private *SiS
 			SiS_Pr->EMI_33 = ROMAddr[romptr + SiS_Pr->SiS_EMIOffset + 2];
 			if(ROMAddr[romptr + 1] & 0x10) SiS_Pr->EMI_30 = 0x40;
 			/* emidelay = SISGETROMW((romptr + 0x22)); */
-			SiS_Pr->HaveEMI = SiS_Pr->HaveEMILCD = SiS_Pr->OverruleEMI = TRUE;
+			SiS_Pr->HaveEMI = SiS_Pr->HaveEMILCD = SiS_Pr->OverruleEMI = true;
 		     }
 		  }
 
@@ -4644,7 +4644,7 @@ SiS_EnableBridge(struct SiS_Private *SiS
 			SiS_PanelDelayLoop(SiS_Pr, 3, 5);
 			if(delaylong) {
 			   SiS_PanelDelayLoop(SiS_Pr, 3, 5);
-			   delaylong = FALSE;
+			   delaylong = false;
 			}
 			SiS_WaitVBRetrace(SiS_Pr);
 			SiS_WaitVBRetrace(SiS_Pr);
@@ -5454,7 +5454,7 @@ SiS_SetGroup1_LVDS(struct SiS_Private *S
   unsigned short modeflag, resinfo = 0;
   unsigned short push2, tempax, tempbx, tempcx, temp;
   unsigned int   tempeax = 0, tempebx, tempecx, tempvcfact = 0;
-  BOOLEAN islvds = FALSE, issis  = FALSE, chkdclkfirst = FALSE;
+  bool islvds = false, issis  = false, chkdclkfirst = false;
 #ifdef SIS300
   unsigned short crt2crtc = 0;
 #endif
@@ -5480,17 +5480,17 @@ SiS_SetGroup1_LVDS(struct SiS_Private *S
 
   /* is lvds if really LVDS, or 301B-DH with external LVDS transmitter */
   if((SiS_Pr->SiS_IF_DEF_LVDS == 1) || (SiS_Pr->SiS_VBType & VB_NoLCD)) {
-     islvds = TRUE;
+     islvds = true;
   }
 
   /* is really sis if sis bridge, but not 301B-DH */
   if((SiS_Pr->SiS_VBType & VB_SISVB) && (!(SiS_Pr->SiS_VBType & VB_NoLCD))) {
-     issis = TRUE;
+     issis = true;
   }
 
   if((SiS_Pr->ChipType >= SIS_315H) && (islvds) && (!(SiS_Pr->SiS_VBInfo & SetCRT2ToLCDA))) {
      if((!SiS_Pr->SiS_IF_DEF_FSTN) && (!SiS_Pr->SiS_IF_DEF_DSTN)) {
-        chkdclkfirst = TRUE;
+        chkdclkfirst = true;
      }
   }
 
@@ -6447,13 +6447,13 @@ SiS_SetGroup2_C_ELV(struct SiS_Private *
    SiS_SetRegANDOR(SiS_Pr->SiS_Part2Port,0x4e,0xeb,temp);
 }
 
-static BOOLEAN
+static bool
 SiS_GetCRT2Part2Ptr(struct SiS_Private *SiS_Pr,unsigned short ModeNo,unsigned short ModeIdIndex,
 		    unsigned short RefreshRateTableIndex,unsigned short *CRT2Index,
 		    unsigned short *ResIndex)
 {
 
-  if(SiS_Pr->ChipType < SIS_315H) return FALSE;
+  if(SiS_Pr->ChipType < SIS_315H) return false;
 
   if(ModeNo <= 0x13)
      (*ResIndex) = SiS_Pr->SiS_SModeIDTable[ModeIdIndex].St_CRT2CRTC;
@@ -6688,7 +6688,7 @@ SiS_SetGroup2(struct SiS_Private *SiS_Pr
   unsigned short i, j, tempax, tempbx, tempcx, tempch, tempcl, temp;
   unsigned short push2, modeflag, crt2crtc, bridgeoffset;
   unsigned int   longtemp, PhaseIndex;
-  BOOLEAN        newtvphase;
+  bool           newtvphase;
   const unsigned char *TimingPoint;
 #ifdef SIS315H
   unsigned short resindex, CRT2Index;
@@ -6721,11 +6721,11 @@ SiS_SetGroup2(struct SiS_Private *SiS_Pr
   PhaseIndex  = 0x01; /* SiS_PALPhase */
   TimingPoint = SiS_Pr->SiS_PALTiming;
 
-  newtvphase = FALSE;
+  newtvphase = false;
   if( (SiS_Pr->SiS_VBType & VB_SIS30xBLV) &&
       ( (!(SiS_Pr->SiS_VBInfo & SetInSlaveMode)) ||
 	(SiS_Pr->SiS_TVMode & TVSetTVSimuMode) ) ) {
-     newtvphase = TRUE;
+     newtvphase = true;
   }
 
   if(SiS_Pr->SiS_VBInfo & SetCRT2ToHiVision) {
@@ -7754,13 +7754,13 @@ SiS_SetGroup5(struct SiS_Private *SiS_Pr
 /*     MODIFY CRT1 GROUP FOR SLAVE MODE      */
 /*********************************************/
 
-static BOOLEAN
+static bool
 SiS_GetLVDSCRT1Ptr(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short ModeIdIndex,
 		   unsigned short RefreshRateTableIndex, unsigned short *ResIndex,
 		   unsigned short *DisplayType)
  {
   unsigned short modeflag = 0;
-  BOOLEAN checkhd = TRUE;
+  bool checkhd = true;
 
   /* Pass 1:1 not supported here */
 
@@ -7792,7 +7792,7 @@ SiS_GetLVDSCRT1Ptr(struct SiS_Private *S
      (*DisplayType = 0);
      switch(SiS_Pr->SiS_LCDResInfo) {
      case Panel_320x240_1: (*DisplayType) = 50;
-			   checkhd = FALSE;
+			   checkhd = false;
 			   break;
      case Panel_320x240_2: (*DisplayType) = 14;
 			   break;
@@ -7802,7 +7802,7 @@ SiS_GetLVDSCRT1Ptr(struct SiS_Private *S
 			   break;
      case Panel_1024x600:  (*DisplayType) = 26;
 			   break;
-     default: return TRUE;
+     default: return true;
      }
 
      if(checkhd) {
@@ -7815,7 +7815,7 @@ SiS_GetLVDSCRT1Ptr(struct SiS_Private *S
 
   }
 
-  return TRUE;
+  return true;
 }
 
 static void
@@ -8654,7 +8654,7 @@ SiS_ChrontelDoSomething1(struct SiS_Priv
 /*      MAIN: SET CRT2 REGISTER GROUP        */
 /*********************************************/
 
-BOOLEAN
+bool
 SiS_SetCRT2Group(struct SiS_Private *SiS_Pr, unsigned short ModeNo)
 {
 #ifdef SIS300
@@ -8690,7 +8690,7 @@ SiS_SetCRT2Group(struct SiS_Private *SiS
    if(SiS_Pr->SiS_VBInfo & DisableCRT2Display) {
       SiS_LockCRT2(SiS_Pr);
       SiS_DisplayOn(SiS_Pr);
-      return TRUE;
+      return true;
    }
 
    SiS_GetCRT2Data(SiS_Pr, ModeNo, ModeIdIndex, RefreshRateTableIndex);
@@ -8828,7 +8828,7 @@ SiS_SetCRT2Group(struct SiS_Private *SiS
       SiS_LockCRT2(SiS_Pr);
    }
 
-   return TRUE;
+   return true;
 }
 
 
@@ -8908,7 +8908,7 @@ SiS_SetTrumpBlockLoop(struct SiS_Private
   return NULL;
 }
 
-static BOOLEAN
+static bool
 SiS_SetTrumpionBlock(struct SiS_Private *SiS_Pr, unsigned char *dataptr)
 {
   SiS_Pr->SiS_DDC_DeviceAddr = 0xF0;  		/* DAB (Device Address Byte) */
@@ -8921,14 +8921,14 @@ SiS_SetTrumpionBlock(struct SiS_Private 
 
   while(*dataptr) {
      dataptr = SiS_SetTrumpBlockLoop(SiS_Pr, dataptr);
-     if(!dataptr) return FALSE;
+     if(!dataptr) return false;
   }
 #ifdef SIS_XORG_XF86
 #ifdef TWDEBUG
   xf86DrvMsg(0, X_INFO, "Trumpion block success\n");
 #endif
 #endif
-  return TRUE;
+  return true;
 }
 #endif
 
@@ -8939,7 +8939,7 @@ SiS_SetTrumpionBlock(struct SiS_Private 
  * 0x0a, possibly for working around the DDC problems
  */
 
-static BOOLEAN
+static bool
 SiS_SetChReg(struct SiS_Private *SiS_Pr, unsigned short reg, unsigned char val, unsigned short myor)
 {
   unsigned short temp, i;
@@ -8958,9 +8958,9 @@ SiS_SetChReg(struct SiS_Private *SiS_Pr,
      if(temp) continue;							/*    (ERROR: no ack) */
      if(SiS_SetStop(SiS_Pr)) continue;					/* Set stop condition */
      SiS_Pr->SiS_ChrontelInit = 1;
-     return TRUE;
+     return true;
   }
-  return FALSE;
+  return false;
 }
 
 /* Write to Chrontel 700x */
@@ -9119,7 +9119,7 @@ static
 #endif
 unsigned short
 SiS_InitDDCRegs(struct SiS_Private *SiS_Pr, unsigned int VBFlags, int VGAEngine,
-                unsigned short adaptnum, unsigned short DDCdatatype, BOOLEAN checkcr32,
+                unsigned short adaptnum, unsigned short DDCdatatype, bool checkcr32,
 		unsigned int VBFlags2)
 {
      unsigned char ddcdtype[] = { 0xa0, 0xa0, 0xa0, 0xa2, 0xa6 };
@@ -9287,7 +9287,7 @@ SiS_DoProbeDDC(struct SiS_Private *SiS_P
 {
     unsigned char mask, value;
     unsigned short  temp, ret=0;
-    BOOLEAN failed = FALSE;
+    bool failed = false;
 
     SiS_SetSwitchDDC2(SiS_Pr);
     if(SiS_PrepareDDC(SiS_Pr)) {
@@ -9308,7 +9308,7 @@ SiS_DoProbeDDC(struct SiS_Private *SiS_P
            mask = 0xff;
 	   value = 0xff;
        } else {
-           failed = TRUE;
+           failed = true;
 	   ret = 0xFFFF;
 #ifdef SIS_XORG_XF86
 #ifdef TWDEBUG
@@ -9317,7 +9317,7 @@ SiS_DoProbeDDC(struct SiS_Private *SiS_P
 #endif
        }
     }
-    if(failed == FALSE) {
+    if(!failed) {
        temp = (unsigned char)SiS_ReadDDC2Data(SiS_Pr);
        SiS_SendACK(SiS_Pr, 1);
        temp &= mask;
@@ -9431,7 +9431,7 @@ SiS_HandleDDC(struct SiS_Private *SiS_Pr
    if((!(VBFlags2 & VB2_VIDEOBRIDGE)) && (adaptnum > 0))
       return 0xFFFF;
 
-   if(SiS_InitDDCRegs(SiS_Pr, VBFlags, VGAEngine, adaptnum, DDCdatatype, FALSE, VBFlags2) == 0xFFFF)
+   if(SiS_InitDDCRegs(SiS_Pr, VBFlags, VGAEngine, adaptnum, DDCdatatype, false, VBFlags2) == 0xFFFF)
       return 0xFFFF;
 
    sr1f = SiS_GetReg(SiS_Pr->SiS_P3c4,0x1f);
@@ -9829,7 +9829,7 @@ SetDelayComp(struct SiS_Private *SiS_Pr,
 {
   unsigned char  *ROMAddr = SiS_Pr->VirtualRomBase;
   unsigned short delay=0,index,myindex,temp,romptr=0;
-  BOOLEAN dochiptest = TRUE;
+  bool dochiptest = true;
 
   if(SiS_Pr->SiS_VBInfo & SetCRT2ToLCDA) {
      SiS_SetRegAND(SiS_Pr->SiS_Part1Port,0x20,0xbf);
@@ -9864,7 +9864,7 @@ SetDelayComp(struct SiS_Private *SiS_Pr,
 
   } else if(SiS_Pr->SiS_VBInfo & (SetCRT2ToLCD|SetCRT2ToLCDA)) {  /* ----------	LCD/LCDA */
 
-     BOOLEAN gotitfrompci = FALSE;
+     bool gotitfrompci = false;
 
      /* Could we detect a PDC for LCD or did we get a user-defined? If yes, use it */
 
@@ -9916,22 +9916,22 @@ SetDelayComp(struct SiS_Private *SiS_Pr,
      case CUT_COMPAQ1280:
      case CUT_COMPAQ12802:
 	if(SiS_Pr->SiS_LCDResInfo == Panel_1280x1024) {
-	   gotitfrompci = TRUE;
-	   dochiptest = FALSE;
+	   gotitfrompci = true;
+	   dochiptest = false;
 	   delay = 0x03;
 	}
 	break;
      case CUT_CLEVO1400:
      case CUT_CLEVO14002:
-	gotitfrompci = TRUE;
-	dochiptest = FALSE;
+	gotitfrompci = true;
+	dochiptest = false;
 	delay = 0x02;
 	break;
      case CUT_CLEVO1024:
      case CUT_CLEVO10242:
         if(SiS_Pr->SiS_LCDResInfo == Panel_1024x768) {
-	   gotitfrompci = TRUE;
-	   dochiptest = FALSE;
+	   gotitfrompci = true;
+	   dochiptest = false;
 	   delay = 0x33;
 	   SiS_SetReg(SiS_Pr->SiS_Part1Port,0x2D,delay);
 	   delay &= 0x0f;
@@ -10009,7 +10009,7 @@ SetDelayComp(struct SiS_Private *SiS_Pr,
 
      if(SiS_Pr->SiS_VBInfo & SetCRT2ToLCDA) {
 	SiS_SetRegANDOR(SiS_Pr->SiS_Part1Port,0x2D,0x0F,((delay << 4) & 0xf0));
-	dochiptest = FALSE;
+	dochiptest = false;
      }
 
   } else if(SiS_Pr->SiS_VBInfo & SetCRT2ToTV) {			/* ------------ TV */
@@ -10043,12 +10043,12 @@ SetDelayComp(struct SiS_Private *SiS_Pr,
 	   case CUT_CLEVO1400:
 	   case CUT_CLEVO14002:
 	      delay = 0x02;
-	      dochiptest = FALSE;
+	      dochiptest = false;
 	      break;
 	   case CUT_CLEVO1024:
 	   case CUT_CLEVO10242:
 	      delay = 0x03;
-	      dochiptest = FALSE;
+	      dochiptest = false;
    	      break;
 	   default:
               delay = SiS310_TVDelayCompensation_651301LV[index];
@@ -10085,7 +10085,7 @@ SetDelayComp(struct SiS_Private *SiS_Pr,
 
      if(SiS_LCDAEnabled(SiS_Pr)) {
 	delay &= 0x0f;
-	dochiptest = FALSE;
+	dochiptest = false;
      }
 
   } else return;
@@ -10728,7 +10728,7 @@ SiS_FinalizeLCD(struct SiS_Private *SiS_
 	      SiS_SetReg(SiS_Pr->SiS_Part1Port,0x1c,0x00);
 	      SiS_SetReg(SiS_Pr->SiS_Part1Port,0x1d,0x1b);
 	   }
-	   if((SiS_Pr->Backup == TRUE) && (SiS_Pr->Backup_Mode == ModeNo)) {
+	   if(SiS_Pr->Backup && (SiS_Pr->Backup_Mode == ModeNo)) {
 	      SiS_SetReg(SiS_Pr->SiS_Part1Port,0x14,SiS_Pr->Backup_14);
 	      SiS_SetReg(SiS_Pr->SiS_Part1Port,0x15,SiS_Pr->Backup_15);
 	      SiS_SetReg(SiS_Pr->SiS_Part1Port,0x16,SiS_Pr->Backup_16);
diff -puN drivers/video/sis/init301.h~drivers-video-sis-convert-to-generic-boolean drivers/video/sis/init301.h
--- a/drivers/video/sis/init301.h~drivers-video-sis-convert-to-generic-boolean
+++ a/drivers/video/sis/init301.h
@@ -363,8 +363,8 @@ void		SiS_LockCRT2(struct SiS_Private *S
 void		SiS_EnableCRT2(struct SiS_Private *SiS_Pr);
 unsigned short	SiS_GetRatePtr(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short ModeIdIndex);
 void		SiS_WaitRetrace1(struct SiS_Private *SiS_Pr);
-BOOLEAN		SiS_IsDualEdge(struct SiS_Private *SiS_Pr);
-BOOLEAN		SiS_IsVAMode(struct SiS_Private *SiS_Pr);
+bool		SiS_IsDualEdge(struct SiS_Private *SiS_Pr);
+bool		SiS_IsVAMode(struct SiS_Private *SiS_Pr);
 void		SiS_GetVBInfo(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
 			unsigned short ModeIdIndex, int checkcrt2mode);
 void		SiS_SetYPbPr(struct SiS_Private *SiS_Pr);
@@ -379,7 +379,7 @@ void		SiS_DisableBridge(struct SiS_Priva
 #ifndef SIS_LINUX_KERNEL
 void		SiS_EnableBridge(struct SiS_Private *SiS_Pr);
 #endif
-BOOLEAN		SiS_SetCRT2Group(struct SiS_Private *SiS_Pr, unsigned short ModeNo);
+bool		SiS_SetCRT2Group(struct SiS_Private *SiS_Pr, unsigned short ModeNo);
 void		SiS_SiS30xBLOn(struct SiS_Private *SiS_Pr);
 void		SiS_SiS30xBLOff(struct SiS_Private *SiS_Pr);
 
@@ -403,7 +403,7 @@ void		SiS_Chrontel701xBLOff(struct SiS_P
 #endif /* 315 */
 
 #ifdef SIS300
-static  BOOLEAN	SiS_SetTrumpionBlock(struct SiS_Private *SiS_Pr, unsigned char *dataptr);
+static  bool	SiS_SetTrumpionBlock(struct SiS_Private *SiS_Pr, unsigned char *dataptr);
 void		SiS_SetChrontelGPIO(struct SiS_Private *SiS_Pr, unsigned short myvbinfo);
 #endif
 
@@ -416,14 +416,14 @@ unsigned short	SiS_HandleDDC(struct SiS_
 #ifdef SIS_XORG_XF86
 unsigned short		SiS_InitDDCRegs(struct SiS_Private *SiS_Pr, unsigned int VBFlags,
 				int VGAEngine, unsigned short adaptnum, unsigned short DDCdatatype,
-				BOOLEAN checkcr32, unsigned int VBFlags2);
+				bool checkcr32, unsigned int VBFlags2);
 unsigned short		SiS_ProbeDDC(struct SiS_Private *SiS_Pr);
 unsigned short		SiS_ReadDDC(struct SiS_Private *SiS_Pr, unsigned short DDCdatatype,
 				unsigned char *buffer);
 #else
 static unsigned short	SiS_InitDDCRegs(struct SiS_Private *SiS_Pr, unsigned int VBFlags,
 				int VGAEngine, unsigned short adaptnum, unsigned short DDCdatatype,
-				BOOLEAN checkcr32, unsigned int VBFlags2);
+				bool checkcr32, unsigned int VBFlags2);
 static unsigned short	SiS_ProbeDDC(struct SiS_Private *SiS_Pr);
 static unsigned short	SiS_ReadDDC(struct SiS_Private *SiS_Pr, unsigned short DDCdatatype,
 				unsigned char *buffer);
@@ -469,7 +469,7 @@ extern void		SiS_SetRegOR(SISIOADDRESS, 
 extern void		SiS_SetRegAND(SISIOADDRESS, unsigned short, unsigned short);
 extern void		SiS_DisplayOff(struct SiS_Private *SiS_Pr);
 extern void		SiS_DisplayOn(struct SiS_Private *SiS_Pr);
-extern BOOLEAN		SiS_SearchModeID(struct SiS_Private *, unsigned short *, unsigned short *);
+extern bool		SiS_SearchModeID(struct SiS_Private *, unsigned short *, unsigned short *);
 extern unsigned short	SiS_GetModeFlag(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
 				unsigned short ModeIdIndex);
 extern unsigned short	SiS_GetModePtr(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short ModeIdIndex);
diff -puN drivers/video/sis/initextlfb.c~drivers-video-sis-convert-to-generic-boolean drivers/video/sis/initextlfb.c
--- a/drivers/video/sis/initextlfb.c~drivers-video-sis-convert-to-generic-boolean
+++ a/drivers/video/sis/initextlfb.c
@@ -38,14 +38,14 @@ int		sisfb_mode_rate_to_dclock(struct Si
 			unsigned char modeno, unsigned char rateindex);
 int		sisfb_mode_rate_to_ddata(struct SiS_Private *SiS_Pr, unsigned char modeno,
 			unsigned char rateindex, struct fb_var_screeninfo *var);
-BOOLEAN		sisfb_gettotalfrommode(struct SiS_Private *SiS_Pr, unsigned char modeno,
+bool		sisfb_gettotalfrommode(struct SiS_Private *SiS_Pr, unsigned char modeno,
 			int *htotal, int *vtotal, unsigned char rateindex);
 
-extern BOOLEAN	SiSInitPtr(struct SiS_Private *SiS_Pr);
-extern BOOLEAN	SiS_SearchModeID(struct SiS_Private *SiS_Pr, unsigned short *ModeNo,
+extern bool	SiSInitPtr(struct SiS_Private *SiS_Pr);
+extern bool	SiS_SearchModeID(struct SiS_Private *SiS_Pr, unsigned short *ModeNo,
 			unsigned short *ModeIdIndex);
 extern void	SiS_Generic_ConvertCRData(struct SiS_Private *SiS_Pr, unsigned char *crdata,
-			int xres, int yres, struct fb_var_screeninfo *var, BOOLEAN writeres);
+			int xres, int yres, struct fb_var_screeninfo *var, bool writeres);
 
 int
 sisfb_mode_rate_to_dclock(struct SiS_Private *SiS_Pr, unsigned char modeno,
@@ -131,7 +131,7 @@ sisfb_mode_rate_to_ddata(struct SiS_Priv
 			(unsigned char *)&SiS_Pr->SiS_CRT1Table[index].CR[0],
 			SiS_Pr->SiS_RefIndex[RRTI].XRes,
 			SiS_Pr->SiS_RefIndex[RRTI].YRes,
-			var, FALSE);
+			var, false);
 
     if(SiS_Pr->SiS_RefIndex[RRTI].Ext_InfoFlag & 0x8000)
        var->sync &= ~FB_SYNC_VERT_HIGH_ACT;
@@ -175,7 +175,7 @@ sisfb_mode_rate_to_ddata(struct SiS_Priv
     return 1;
 }
 
-BOOLEAN
+bool
 sisfb_gettotalfrommode(struct SiS_Private *SiS_Pr, unsigned char modeno, int *htotal,
 			int *vtotal, unsigned char rateindex)
 {
@@ -184,7 +184,7 @@ sisfb_gettotalfrommode(struct SiS_Privat
     unsigned short RRTI = 0;
     unsigned char  sr_data, cr_data, cr_data2;
 
-    if(!SiSInitPtr(SiS_Pr)) return FALSE;
+    if(!SiSInitPtr(SiS_Pr)) return false;
 
     if(rateindex > 0) rateindex--;
 
@@ -195,7 +195,7 @@ sisfb_gettotalfrommode(struct SiS_Privat
     }
 #endif
 
-    if(!(SiS_SearchModeID(SiS_Pr, &ModeNo, &ModeIdIndex))) return FALSE;
+    if(!(SiS_SearchModeID(SiS_Pr, &ModeNo, &ModeIdIndex))) return false;
 
     RRTI = SiS_Pr->SiS_EModeIDTable[ModeIdIndex].REFindex;
     if(SiS_Pr->SiS_RefIndex[RRTI].Ext_InfoFlag & HaveWideTiming) {
@@ -226,7 +226,7 @@ sisfb_gettotalfrommode(struct SiS_Privat
     if(SiS_Pr->SiS_RefIndex[RRTI].Ext_InfoFlag & InterlaceMode)
        *vtotal *= 2;
 
-    return TRUE;
+    return true;
 }
 
 
diff -puN drivers/video/sis/sis.h~drivers-video-sis-convert-to-generic-boolean drivers/video/sis/sis.h
--- a/drivers/video/sis/sis.h~drivers-video-sis-convert-to-generic-boolean
+++ a/drivers/video/sis/sis.h
@@ -526,7 +526,7 @@ struct sis_video_info {
 		u16 vmax;
 		u32 dclockmax;
 		u8  feature;
-		BOOLEAN datavalid;
+		bool datavalid;
 	}		sisfb_thismonitor;
 
 	unsigned short	chip_id;	/* PCI ID of chip */
diff -puN drivers/video/sis/sis_main.c~drivers-video-sis-convert-to-generic-boolean drivers/video/sis/sis_main.c
--- a/drivers/video/sis/sis_main.c~drivers-video-sis-convert-to-generic-boolean
+++ a/drivers/video/sis/sis_main.c
@@ -110,7 +110,7 @@ sisfb_setdefaultparms(void)
 /* ------------- Parameter parsing -------------- */
 
 static void __devinit
-sisfb_search_vesamode(unsigned int vesamode, BOOLEAN quiet)
+sisfb_search_vesamode(unsigned int vesamode, bool quiet)
 {
 	int i = 0, j = 0;
 
@@ -150,7 +150,7 @@ sisfb_search_vesamode(unsigned int vesam
 }
 
 static void __devinit
-sisfb_search_mode(char *name, BOOLEAN quiet)
+sisfb_search_mode(char *name, bool quiet)
 {
 	unsigned int j = 0, xres = 0, yres = 0, depth = 0, rate = 0;
 	int i = 0;
@@ -251,7 +251,7 @@ sisfb_get_vga_mode_from_kernel(void)
 			"sisfb: Using vga mode %s pre-set by kernel as default\n",
 			mymode);
 
-		sisfb_search_mode(mymode, TRUE);
+		sisfb_search_mode(mymode, true);
 	}
 #endif
 	return;
@@ -307,7 +307,7 @@ static void __init
 sisfb_search_specialtiming(const char *name)
 {
 	int i = 0;
-	BOOLEAN found = FALSE;
+	bool found = false;
 
 	/* We don't know the hardware specs yet and there is no ivideo */
 
@@ -322,7 +322,7 @@ sisfb_search_specialtiming(const char *n
 			if(!strnicmp(name,mycustomttable[i].optionName,
 			   strlen(mycustomttable[i].optionName))) {
 				sisfb_specialtiming = mycustomttable[i].SpecialID;
-				found = TRUE;
+				found = true;
 				printk(KERN_INFO "sisfb: Special timing for %s %s forced (\"%s\")\n",
 					mycustomttable[i].vendorName,
 					mycustomttable[i].cardName,
@@ -353,7 +353,7 @@ sisfb_detect_custom_timing(struct sis_vi
 {
 	unsigned char *biosver = NULL;
 	unsigned char *biosdate = NULL;
-	BOOLEAN footprint;
+	bool footprint;
 	u32 chksum = 0;
 	int i, j;
 
@@ -380,16 +380,16 @@ sisfb_detect_custom_timing(struct sis_vi
 		      (mycustomttable[i].bioschksum == chksum)))		&&
 		    (mycustomttable[i].pcisubsysvendor == ivideo->subsysvendor) &&
 		    (mycustomttable[i].pcisubsyscard == ivideo->subsysdevice) ) {
-			footprint = TRUE;
+			footprint = true;
 			for(j = 0; j < 5; j++) {
 				if(mycustomttable[i].biosFootprintAddr[j]) {
 					if(ivideo->SiS_Pr.UseROM) {
 						if(ivideo->SiS_Pr.VirtualRomBase[mycustomttable[i].biosFootprintAddr[j]] !=
 							mycustomttable[i].biosFootprintData[j]) {
-							footprint = FALSE;
+							footprint = false;
 						}
 					} else
-						footprint = FALSE;
+						footprint = false;
 				}
 			}
 			if(footprint) {
@@ -406,7 +406,7 @@ sisfb_detect_custom_timing(struct sis_vi
 	} while(mycustomttable[i].chipID);
 }
 
-static BOOLEAN __devinit
+static bool __devinit
 sisfb_interpret_edid(struct sisfb_monitor *monitor, u8 *buffer)
 {
 	int i, j, xres, yres, refresh, index;
@@ -417,13 +417,13 @@ sisfb_interpret_edid(struct sisfb_monito
 	   buffer[4] != 0xff || buffer[5] != 0xff ||
 	   buffer[6] != 0xff || buffer[7] != 0x00) {
 		printk(KERN_DEBUG "sisfb: Bad EDID header\n");
-		return FALSE;
+		return false;
 	}
 
 	if(buffer[0x12] != 0x01) {
 		printk(KERN_INFO "sisfb: EDID version %d not supported\n",
 			buffer[0x12]);
-		return FALSE;
+		return false;
 	}
 
 	monitor->feature = buffer[0x18];
@@ -449,7 +449,7 @@ sisfb_interpret_edid(struct sisfb_monito
 		  monitor->vmin = buffer[j + 5];
 		  monitor->vmax = buffer[j + 6];
 		  monitor->dclockmax = buffer[j + 9] * 10 * 1000;
-		  monitor->datavalid = TRUE;
+		  monitor->datavalid = true;
 		  break;
 	       }
 	       j += 18;
@@ -501,7 +501,7 @@ sisfb_interpret_edid(struct sisfb_monito
 	      index += 2;
 	   }
 	   if((monitor->hmin <= monitor->hmax) && (monitor->vmin <= monitor->vmax)) {
-	      monitor->datavalid = TRUE;
+	      monitor->datavalid = true;
 	   }
 	}
 
@@ -514,7 +514,7 @@ sisfb_handle_ddc(struct sis_video_info *
 	unsigned short temp, i, realcrtno = crtno;
 	unsigned char  buffer[256];
 
-	monitor->datavalid = FALSE;
+	monitor->datavalid = false;
 
 	if(crtno) {
 	   if(ivideo->vbflags & CRT2_LCD)      realcrtno = 1;
@@ -563,7 +563,7 @@ sisfb_handle_ddc(struct sis_video_info *
 
 /* -------------- Mode validation --------------- */
 
-static BOOLEAN
+static bool
 sisfb_verify_rate(struct sis_video_info *ivideo, struct sisfb_monitor *monitor,
 		int mode_idx, int rate_idx, int rate)
 {
@@ -571,10 +571,10 @@ sisfb_verify_rate(struct sis_video_info 
 	unsigned int dclock, hsync;
 
 	if(!monitor->datavalid)
-		return TRUE;
+		return true;
 
 	if(mode_idx < 0)
-		return FALSE;
+		return false;
 
 	/* Skip for 320x200, 320x240, 640x400 */
 	switch(sisbios_mode[mode_idx].mode_no[ivideo->mni]) {
@@ -587,34 +587,34 @@ sisfb_verify_rate(struct sis_video_info 
 	case 0x2f:
 	case 0x5d:
 	case 0x5e:
-		return TRUE;
+		return true;
 #ifdef CONFIG_FB_SIS_315
 	case 0x5a:
 	case 0x5b:
-		if(ivideo->sisvga_engine == SIS_315_VGA) return TRUE;
+		if(ivideo->sisvga_engine == SIS_315_VGA) return true;
 #endif
 	}
 
 	if(rate < (monitor->vmin - 1))
-		return FALSE;
+		return false;
 	if(rate > (monitor->vmax + 1))
-		return FALSE;
+		return false;
 
 	if(sisfb_gettotalfrommode(&ivideo->SiS_Pr,
 				  sisbios_mode[mode_idx].mode_no[ivideo->mni],
 				  &htotal, &vtotal, rate_idx)) {
 		dclock = (htotal * vtotal * rate) / 1000;
 		if(dclock > (monitor->dclockmax + 1000))
-			return FALSE;
+			return false;
 		hsync = dclock / htotal;
 		if(hsync < (monitor->hmin - 1))
-			return FALSE;
+			return false;
 		if(hsync > (monitor->hmax + 1))
-			return FALSE;
+			return false;
         } else {
-		return FALSE;
+		return false;
 	}
-	return TRUE;
+	return true;
 }
 
 static int
@@ -732,49 +732,49 @@ sisfb_search_refresh_rate(struct sis_vid
 	}
 }
 
-static BOOLEAN
+static bool
 sisfb_bridgeisslave(struct sis_video_info *ivideo)
 {
 	unsigned char P1_00;
 
 	if(!(ivideo->vbflags2 & VB2_VIDEOBRIDGE))
-		return FALSE;
+		return false;
 
 	inSISIDXREG(SISPART1,0x00,P1_00);
 	if( ((ivideo->sisvga_engine == SIS_300_VGA) && (P1_00 & 0xa0) == 0x20) ||
 	    ((ivideo->sisvga_engine == SIS_315_VGA) && (P1_00 & 0x50) == 0x10) ) {
-		return TRUE;
+		return true;
 	} else {
-		return FALSE;
+		return false;
 	}
 }
 
-static BOOLEAN
+static bool
 sisfballowretracecrt1(struct sis_video_info *ivideo)
 {
 	u8 temp;
 
 	inSISIDXREG(SISCR,0x17,temp);
 	if(!(temp & 0x80))
-		return FALSE;
+		return false;
 
 	inSISIDXREG(SISSR,0x1f,temp);
 	if(temp & 0xc0)
-		return FALSE;
+		return false;
 
-	return TRUE;
+	return true;
 }
 
-static BOOLEAN
+static bool
 sisfbcheckvretracecrt1(struct sis_video_info *ivideo)
 {
 	if(!sisfballowretracecrt1(ivideo))
-		return FALSE;
+		return false;
 
 	if(inSISREG(SISINPSTAT) & 0x08)
-		return TRUE;
+		return true;
 	else
-		return FALSE;
+		return false;
 }
 
 static void
@@ -791,7 +791,7 @@ sisfbwaitretracecrt1(struct sis_video_in
 	while((inSISREG(SISINPSTAT) & 0x08) && --watchdog);
 }
 
-static BOOLEAN
+static bool
 sisfbcheckvretracecrt2(struct sis_video_info *ivideo)
 {
 	unsigned char temp, reg;
@@ -799,17 +799,17 @@ sisfbcheckvretracecrt2(struct sis_video_
 	switch(ivideo->sisvga_engine) {
 	case SIS_300_VGA: reg = 0x25; break;
 	case SIS_315_VGA: reg = 0x30; break;
-	default:	  return FALSE;
+	default:	  return false;
 	}
 
 	inSISIDXREG(SISPART1, reg, temp);
 	if(temp & 0x02)
-		return TRUE;
+		return true;
 	else
-		return FALSE;
+		return false;
 }
 
-static BOOLEAN
+static bool
 sisfb_CheckVBRetrace(struct sis_video_info *ivideo)
 {
 	if(ivideo->currentvbflags & VB_DISPTYPE_DISP2) {
@@ -874,7 +874,7 @@ static int
 sisfb_myblank(struct sis_video_info *ivideo, int blank)
 {
 	u8 sr01, sr11, sr1f, cr63=0, p2_0, p1_13;
-	BOOLEAN backlight = TRUE;
+	bool backlight = true;
 
 	switch(blank) {
 		case FB_BLANK_UNBLANK:	/* on */
@@ -884,7 +884,7 @@ sisfb_myblank(struct sis_video_info *ivi
 			cr63  = 0x00;
 			p2_0  = 0x20;
 			p1_13 = 0x00;
-			backlight = TRUE;
+			backlight = true;
 			break;
 		case FB_BLANK_NORMAL:	/* blank */
 			sr01  = 0x20;
@@ -893,7 +893,7 @@ sisfb_myblank(struct sis_video_info *ivi
 			cr63  = 0x00;
 			p2_0  = 0x20;
 			p1_13 = 0x00;
-			backlight = TRUE;
+			backlight = true;
 			break;
 		case FB_BLANK_VSYNC_SUSPEND:	/* no vsync */
 			sr01  = 0x20;
@@ -902,7 +902,7 @@ sisfb_myblank(struct sis_video_info *ivi
 			cr63  = 0x40;
 			p2_0  = 0x40;
 			p1_13 = 0x80;
-			backlight = FALSE;
+			backlight = false;
 			break;
 		case FB_BLANK_HSYNC_SUSPEND:	/* no hsync */
 			sr01  = 0x20;
@@ -911,7 +911,7 @@ sisfb_myblank(struct sis_video_info *ivi
 			cr63  = 0x40;
 			p2_0  = 0x80;
 			p1_13 = 0x40;
-			backlight = FALSE;
+			backlight = false;
 			break;
 		case FB_BLANK_POWERDOWN:	/* off */
 			sr01  = 0x20;
@@ -920,7 +920,7 @@ sisfb_myblank(struct sis_video_info *ivi
 			cr63  = 0x40;
 			p2_0  = 0xc0;
 			p1_13 = 0xc0;
-			backlight = FALSE;
+			backlight = false;
 			break;
 		default:
 			return 1;
@@ -1109,11 +1109,11 @@ sisfb_calc_pitch(struct sis_video_info *
 static void
 sisfb_set_pitch(struct sis_video_info *ivideo)
 {
-	BOOLEAN isslavemode = FALSE;
+	bool isslavemode = false;
 	unsigned short HDisplay1 = ivideo->scrnpitchCRT1 >> 3;
 	unsigned short HDisplay2 = ivideo->video_linelength >> 3;
 
-	if(sisfb_bridgeisslave(ivideo)) isslavemode = TRUE;
+	if(sisfb_bridgeisslave(ivideo)) isslavemode = true;
 
 	/* We need to set pitch for CRT1 if bridge is in slave mode, too */
 	if((ivideo->currentvbflags & VB_DISPTYPE_DISP1) || (isslavemode)) {
@@ -1178,7 +1178,7 @@ sisfb_set_mode(struct sis_video_info *iv
 
 	sisfb_pre_setmode(ivideo);
 
-	if(SiSSetMode(&ivideo->SiS_Pr, modeno) == 0) {
+	if(!SiSSetMode(&ivideo->SiS_Pr, modeno)) {
 		printk(KERN_ERR "sisfb: Setting mode[0x%x] failed\n", ivideo->mode_no);
 		return -EINVAL;
 	}
@@ -1446,7 +1446,7 @@ sisfb_check_var(struct fb_var_screeninfo
 	unsigned int drate = 0, hrate = 0, maxyres;
 	int found_mode = 0;
 	int refresh_rate, search_idx, tidx;
-	BOOLEAN recalc_clock = FALSE;
+	bool recalc_clock = false;
 	u32 pixclock;
 
 	htotal = var->left_margin + var->xres + var->right_margin + var->hsync_len;
@@ -1524,7 +1524,7 @@ sisfb_check_var(struct fb_var_screeninfo
 	    (var->bits_per_pixel == 8) ) {
 		/* Slave modes on LVDS and 301B-DH */
 		refresh_rate = 60;
-		recalc_clock = TRUE;
+		recalc_clock = true;
 	} else if( (ivideo->current_htotal == htotal) &&
 		   (ivideo->current_vtotal == vtotal) &&
 		   (ivideo->current_pixclock == pixclock) ) {
@@ -1545,17 +1545,17 @@ sisfb_check_var(struct fb_var_screeninfo
 		} else {
 			refresh_rate = 60;
 		}
-		recalc_clock = TRUE;
+		recalc_clock = true;
 	} else if((pixclock) && (htotal) && (vtotal)) {
 		drate = 1000000000 / pixclock;
 		hrate = (drate * 1000) / htotal;
 		refresh_rate = (unsigned int) (hrate * 2 / vtotal);
 	} else if(ivideo->current_refresh_rate) {
 		refresh_rate = ivideo->current_refresh_rate;
-		recalc_clock = TRUE;
+		recalc_clock = true;
 	} else {
 		refresh_rate = 60;
-		recalc_clock = TRUE;
+		recalc_clock = true;
 	}
 
 	myrateindex = sisfb_search_refresh_rate(ivideo, refresh_rate, search_idx);
@@ -2181,7 +2181,7 @@ sisfb_detect_VB_connect(struct sis_video
 
 /* ------------------ Sensing routines ------------------ */
 
-static BOOLEAN __devinit
+static bool __devinit
 sisfb_test_DDC1(struct sis_video_info *ivideo)
 {
     unsigned short old;
@@ -2191,13 +2191,13 @@ sisfb_test_DDC1(struct sis_video_info *i
     do {
 	if(old != SiS_ReadDDC1Bit(&ivideo->SiS_Pr)) break;
     } while(count--);
-    return (count == -1) ? FALSE : TRUE;
+    return (count != -1);
 }
 
 static void __devinit
 sisfb_sense_crt1(struct sis_video_info *ivideo)
 {
-    BOOLEAN mustwait = FALSE;
+    bool mustwait = false;
     u8  sr1F, cr17;
 #ifdef CONFIG_FB_SIS_315
     u8  cr63=0;
@@ -2208,7 +2208,7 @@ sisfb_sense_crt1(struct sis_video_info *
     inSISIDXREG(SISSR,0x1F,sr1F);
     orSISIDXREG(SISSR,0x1F,0x04);
     andSISIDXREG(SISSR,0x1F,0x3F);
-    if(sr1F & 0xc0) mustwait = TRUE;
+    if(sr1F & 0xc0) mustwait = true;
 
 #ifdef CONFIG_FB_SIS_315
     if(ivideo->sisvga_engine == SIS_315_VGA) {
@@ -2222,7 +2222,7 @@ sisfb_sense_crt1(struct sis_video_info *
     cr17 &= 0x80;
     if(!cr17) {
        orSISIDXREG(SISCR,0x17,0x80);
-       mustwait = TRUE;
+       mustwait = true;
        outSISIDXREG(SISSR, 0x00, 0x01);
        outSISIDXREG(SISSR, 0x00, 0x03);
     }
@@ -2284,7 +2284,7 @@ SiS_SenseLCD(struct sis_video_info *ivid
 	u8 reg, cr37 = 0, paneltype = 0;
 	u16 xres, yres;
 
-	ivideo->SiS_Pr.PanelSelfDetected = FALSE;
+	ivideo->SiS_Pr.PanelSelfDetected = false;
 
 	/* LCD detection only for TMDS bridges */
 	if(!(ivideo->vbflags2 & VB2_SISTMDSBRIDGE))
@@ -2361,7 +2361,7 @@ SiS_SenseLCD(struct sis_video_info *ivid
 	setSISIDXREG(SISCR, 0x37, 0x0c, cr37);
 	orSISIDXREG(SISCR, 0x32, 0x08);
 
-	ivideo->SiS_Pr.PanelSelfDetected = TRUE;
+	ivideo->SiS_Pr.PanelSelfDetected = true;
 }
 
 static int __devinit
@@ -3016,7 +3016,7 @@ sisfb_save_pdc_emi(struct sis_video_info
 			int tmp;
 			inSISIDXREG(SISPART1,0x13,tmp);
 			if(tmp & 0x04) {
-				ivideo->SiS_Pr.SiS_UseLCDA = TRUE;
+				ivideo->SiS_Pr.SiS_UseLCDA = true;
 				ivideo->detectedlcda = 0x03;
 			}
 		}
@@ -3071,9 +3071,9 @@ sisfb_save_pdc_emi(struct sis_video_info
 				inSISIDXREG(SISPART4,0x31,ivideo->SiS_Pr.EMI_31);
 				inSISIDXREG(SISPART4,0x32,ivideo->SiS_Pr.EMI_32);
 				inSISIDXREG(SISPART4,0x33,ivideo->SiS_Pr.EMI_33);
-				ivideo->SiS_Pr.HaveEMI = TRUE;
+				ivideo->SiS_Pr.HaveEMI = true;
 				if((tmp & 0x20) || (ivideo->detectedlcda != 0xff)) {
-					ivideo->SiS_Pr.HaveEMILCD = TRUE;
+					ivideo->SiS_Pr.HaveEMILCD = true;
 				}
 			}
 		}
@@ -3558,8 +3558,8 @@ sisfb_pre_setmode(struct sis_video_info 
 	}
 #endif
 
-	SiS_SetEnableDstn(&ivideo->SiS_Pr, FALSE);
-	SiS_SetEnableFstn(&ivideo->SiS_Pr, FALSE);
+	SiS_SetEnableDstn(&ivideo->SiS_Pr, false);
+	SiS_SetEnableFstn(&ivideo->SiS_Pr, false);
 	ivideo->curFSTN = ivideo->curDSTN = 0;
 
 	switch(ivideo->currentvbflags & VB_DISPTYPE_DISP2) {
@@ -3814,8 +3814,8 @@ sisfb_set_TVyposoffset(struct sis_video_
 static void
 sisfb_post_setmode(struct sis_video_info *ivideo)
 {
-	BOOLEAN crt1isoff = FALSE;
-	BOOLEAN doit = TRUE;
+	bool crt1isoff = false;
+	bool doit = true;
 #if defined(CONFIG_FB_SIS_300) || defined(CONFIG_FB_SIS_315)
 	u8 reg;
 #endif
@@ -3834,17 +3834,17 @@ sisfb_post_setmode(struct sis_video_info
 
 	/* We can't switch off CRT1 if bridge is in slave mode */
 	if(ivideo->vbflags2 & VB2_VIDEOBRIDGE) {
-		if(sisfb_bridgeisslave(ivideo)) doit = FALSE;
+		if(sisfb_bridgeisslave(ivideo)) doit = false;
 	} else
 		ivideo->sisfb_crt1off = 0;
 
 #ifdef CONFIG_FB_SIS_300
 	if(ivideo->sisvga_engine == SIS_300_VGA) {
 		if((ivideo->sisfb_crt1off) && (doit)) {
-			crt1isoff = TRUE;
+			crt1isoff = true;
 			reg = 0x00;
 		} else {
-			crt1isoff = FALSE;
+			crt1isoff = false;
 			reg = 0x80;
 		}
 		setSISIDXREG(SISCR, 0x17, 0x7f, reg);
@@ -3853,11 +3853,11 @@ sisfb_post_setmode(struct sis_video_info
 #ifdef CONFIG_FB_SIS_315
 	if(ivideo->sisvga_engine == SIS_315_VGA) {
 		if((ivideo->sisfb_crt1off) && (doit)) {
-			crt1isoff = TRUE;
+			crt1isoff = true;
 			reg  = 0x40;
 			reg1 = 0xc0;
 		} else {
-			crt1isoff = FALSE;
+			crt1isoff = false;
 			reg  = 0x00;
 			reg1 = 0x00;
 		}
@@ -4004,9 +4004,9 @@ sisfb_setup(char *options)
 		} else if(!strnicmp(this_opt, "tvstandard:",11)) {
 			sisfb_search_tvstd(this_opt + 11);
 		} else if(!strnicmp(this_opt, "mode:", 5)) {
-			sisfb_search_mode(this_opt + 5, FALSE);
+			sisfb_search_mode(this_opt + 5, false);
 		} else if(!strnicmp(this_opt, "vesa:", 5)) {
-			sisfb_search_vesamode(simple_strtoul(this_opt + 5, NULL, 0), FALSE);
+			sisfb_search_vesamode(simple_strtoul(this_opt + 5, NULL, 0), false);
 		} else if(!strnicmp(this_opt, "rate:", 5)) {
 			sisfb_parm_rate = simple_strtoul(this_opt + 5, NULL, 0);
 		} else if(!strnicmp(this_opt, "forcecrt1:", 10)) {
@@ -4062,7 +4062,7 @@ sisfb_setup(char *options)
 			   sisfb_lvdshl = temp;
 			}
 		} else if(this_opt[0] >= '0' && this_opt[0] <= '9') {
-			sisfb_search_mode(this_opt, TRUE);
+			sisfb_search_mode(this_opt, true);
 #if !defined(__i386__) && !defined(__x86_64__)
 		} else if(!strnicmp(this_opt, "resetcard", 9)) {
 			sisfb_resetcard = 1;
@@ -4564,9 +4564,9 @@ sisfb_post_sis300(struct pci_dev *pdev)
 	sisfb_sense_crt1(ivideo);
 
 	/* Set default mode, don't clear screen */
-	ivideo->SiS_Pr.SiS_UseOEM = FALSE;
-	SiS_SetEnableDstn(&ivideo->SiS_Pr, FALSE);
-	SiS_SetEnableFstn(&ivideo->SiS_Pr, FALSE);
+	ivideo->SiS_Pr.SiS_UseOEM = false;
+	SiS_SetEnableDstn(&ivideo->SiS_Pr, false);
+	SiS_SetEnableFstn(&ivideo->SiS_Pr, false);
 	ivideo->curFSTN = ivideo->curDSTN = 0;
 	ivideo->SiS_Pr.VideoMemorySize = 8 << 20;
 	SiSSetMode(&ivideo->SiS_Pr, 0x2e | 0x80);
@@ -5680,9 +5680,9 @@ sisfb_post_xgi(struct pci_dev *pdev)
 	} else {
 
 		/* Set default mode, don't clear screen */
-		ivideo->SiS_Pr.SiS_UseOEM = FALSE;
-		SiS_SetEnableDstn(&ivideo->SiS_Pr, FALSE);
-		SiS_SetEnableFstn(&ivideo->SiS_Pr, FALSE);
+		ivideo->SiS_Pr.SiS_UseOEM = false;
+		SiS_SetEnableDstn(&ivideo->SiS_Pr, false);
+		SiS_SetEnableFstn(&ivideo->SiS_Pr, false);
 		ivideo->curFSTN = ivideo->curDSTN = 0;
 		ivideo->SiS_Pr.VideoMemorySize = 8 << 20;
 		SiSSetMode(&ivideo->SiS_Pr, 0x2e | 0x80);
@@ -5723,9 +5723,9 @@ sisfb_post_xgi(struct pci_dev *pdev)
 	}
 
 	/* Set default mode, don't clear screen */
-	ivideo->SiS_Pr.SiS_UseOEM = FALSE;
-	SiS_SetEnableDstn(&ivideo->SiS_Pr, FALSE);
-	SiS_SetEnableFstn(&ivideo->SiS_Pr, FALSE);
+	ivideo->SiS_Pr.SiS_UseOEM = false;
+	SiS_SetEnableDstn(&ivideo->SiS_Pr, false);
+	SiS_SetEnableFstn(&ivideo->SiS_Pr, false);
 	ivideo->curFSTN = ivideo->curDSTN = 0;
 	SiSSetMode(&ivideo->SiS_Pr, 0x2e | 0x80);
 
@@ -5819,7 +5819,7 @@ sisfb_probe(struct pci_dev *pdev, const 
 	ivideo->detectedpdca = 0xff;
 	ivideo->detectedlcda = 0xff;
 
-	ivideo->sisfb_thismonitor.datavalid = FALSE;
+	ivideo->sisfb_thismonitor.datavalid = false;
 
 	ivideo->current_base = 0;
 
@@ -5871,21 +5871,21 @@ sisfb_probe(struct pci_dev *pdev, const 
 
 	ivideo->SiS_Pr.SiS_Backup70xx = 0xff;
 	ivideo->SiS_Pr.SiS_CHOverScan = -1;
-	ivideo->SiS_Pr.SiS_ChSW = FALSE;
-	ivideo->SiS_Pr.SiS_UseLCDA = FALSE;
-	ivideo->SiS_Pr.HaveEMI = FALSE;
-	ivideo->SiS_Pr.HaveEMILCD = FALSE;
-	ivideo->SiS_Pr.OverruleEMI = FALSE;
-	ivideo->SiS_Pr.SiS_SensibleSR11 = FALSE;
+	ivideo->SiS_Pr.SiS_ChSW = false;
+	ivideo->SiS_Pr.SiS_UseLCDA = false;
+	ivideo->SiS_Pr.HaveEMI = false;
+	ivideo->SiS_Pr.HaveEMILCD = false;
+	ivideo->SiS_Pr.OverruleEMI = false;
+	ivideo->SiS_Pr.SiS_SensibleSR11 = false;
 	ivideo->SiS_Pr.SiS_MyCR63 = 0x63;
 	ivideo->SiS_Pr.PDC  = -1;
 	ivideo->SiS_Pr.PDCA = -1;
-	ivideo->SiS_Pr.DDCPortMixup = FALSE;
+	ivideo->SiS_Pr.DDCPortMixup = false;
 #ifdef CONFIG_FB_SIS_315
 	if(ivideo->chip >= SIS_330) {
 		ivideo->SiS_Pr.SiS_MyCR63 = 0x53;
 		if(ivideo->chip >= SIS_661) {
-			ivideo->SiS_Pr.SiS_SensibleSR11 = TRUE;
+			ivideo->SiS_Pr.SiS_SensibleSR11 = true;
 		}
 	}
 #endif
@@ -5969,7 +5969,7 @@ sisfb_probe(struct pci_dev *pdev, const 
         	do {
 			if(mychswtable[i].subsysVendor == ivideo->subsysvendor &&
 			   mychswtable[i].subsysCard   == ivideo->subsysdevice) {
-				ivideo->SiS_Pr.SiS_ChSW = TRUE;
+				ivideo->SiS_Pr.SiS_ChSW = true;
 				printk(KERN_DEBUG "sisfb: Identified [%s %s] "
 					"requiring Chrontel/GPIO setup\n",
 					mychswtable[i].vendorName,
@@ -6018,20 +6018,20 @@ sisfb_probe(struct pci_dev *pdev, const 
 	/* Search and copy ROM image */
 	ivideo->bios_abase = NULL;
 	ivideo->SiS_Pr.VirtualRomBase = NULL;
-	ivideo->SiS_Pr.UseROM = FALSE;
-	ivideo->haveXGIROM = ivideo->SiS_Pr.SiS_XGIROM = FALSE;
+	ivideo->SiS_Pr.UseROM = false;
+	ivideo->haveXGIROM = ivideo->SiS_Pr.SiS_XGIROM = false;
 	if(ivideo->sisfb_userom) {
 		ivideo->SiS_Pr.VirtualRomBase = sisfb_find_rom(pdev);
 		ivideo->bios_abase = ivideo->SiS_Pr.VirtualRomBase;
-		ivideo->SiS_Pr.UseROM = (ivideo->SiS_Pr.VirtualRomBase) ? TRUE : FALSE;
+		ivideo->SiS_Pr.UseROM = (bool)(ivideo->SiS_Pr.VirtualRomBase);
 		printk(KERN_INFO "sisfb: Video ROM %sfound\n",
 			ivideo->SiS_Pr.UseROM ? "" : "not ");
 		if((ivideo->SiS_Pr.UseROM) && (ivideo->chip >= XGI_20)) {
-		   ivideo->SiS_Pr.UseROM = FALSE;
-		   ivideo->haveXGIROM = ivideo->SiS_Pr.SiS_XGIROM = TRUE;
+		   ivideo->SiS_Pr.UseROM = false;
+		   ivideo->haveXGIROM = ivideo->SiS_Pr.SiS_XGIROM = true;
 		   if( (ivideo->revision_id == 2) &&
 		       (!(ivideo->bios_abase[0x1d1] & 0x01)) ) {
-			ivideo->SiS_Pr.DDCPortMixup = TRUE;
+			ivideo->SiS_Pr.DDCPortMixup = true;
 		   }
 		}
 	} else {
@@ -6677,9 +6677,9 @@ static int __init sisfb_init_module(void
 		sisfb_search_tvstd(tvstandard);
 
 	if(mode)
-		sisfb_search_mode(mode, FALSE);
+		sisfb_search_mode(mode, false);
 	else if(vesa != -1)
-		sisfb_search_vesamode(vesa, FALSE);
+		sisfb_search_vesamode(vesa, false);
 
 	sisfb_crt1off = (crt1off == 0) ? 1 : 0;
 
diff -puN drivers/video/sis/sis_main.h~drivers-video-sis-convert-to-generic-boolean drivers/video/sis/sis_main.h
--- a/drivers/video/sis/sis_main.h~drivers-video-sis-convert-to-generic-boolean
+++ a/drivers/video/sis/sis_main.h
@@ -411,54 +411,54 @@ static const struct _sis_vrate {
 	u16 xres;
 	u16 yres;
 	u16 refresh;
-	BOOLEAN SiS730valid32bpp;
+	bool SiS730valid32bpp;
 } sisfb_vrate[] = {
-	{1,  320,  200,  70,  TRUE},
-	{1,  320,  240,  60,  TRUE},
-	{1,  400,  300,  60,  TRUE},
-	{1,  512,  384,  60,  TRUE},
-	{1,  640,  400,  72,  TRUE},
-	{1,  640,  480,  60,  TRUE}, {2,  640,  480,  72,  TRUE}, {3,  640,  480,  75,  TRUE},
-	{4,  640,  480,  85,  TRUE}, {5,  640,  480, 100,  TRUE}, {6,  640,  480, 120,  TRUE},
-	{7,  640,  480, 160,  TRUE}, {8,  640,  480, 200,  TRUE},
-	{1,  720,  480,  60,  TRUE},
-	{1,  720,  576,  58,  TRUE},
-	{1,  768,  576,  58,  TRUE},
-	{1,  800,  480,  60,  TRUE}, {2,  800,  480,  75,  TRUE}, {3,  800,  480,  85,  TRUE},
-	{1,  800,  600,  56,  TRUE}, {2,  800,  600,  60,  TRUE}, {3,  800,  600,  72,  TRUE},
-	{4,  800,  600,  75,  TRUE}, {5,  800,  600,  85,  TRUE}, {6,  800,  600, 105,  TRUE},
-	{7,  800,  600, 120,  TRUE}, {8,  800,  600, 160,  TRUE},
-	{1,  848,  480,  39,  TRUE}, {2,  848,  480,  60,  TRUE},
-	{1,  856,  480,  39,  TRUE}, {2,  856,  480,  60,  TRUE},
-	{1,  960,  540,  60,  TRUE},
-	{1,  960,  600,  60,  TRUE},
-	{1, 1024,  576,  60,  TRUE}, {2, 1024,  576,  75,  TRUE}, {3, 1024,  576,  85,  TRUE},
-	{1, 1024,  600,  60,  TRUE},
-	{1, 1024,  768,  43,  TRUE}, {2, 1024,  768,  60,  TRUE}, {3, 1024,  768,  70, FALSE},
-	{4, 1024,  768,  75, FALSE}, {5, 1024,  768,  85,  TRUE}, {6, 1024,  768, 100,  TRUE},
-	{7, 1024,  768, 120,  TRUE},
-	{1, 1152,  768,  60,  TRUE},
-	{1, 1152,  864,  60,  TRUE}, {2, 1152,  864,  75,  TRUE}, {3, 1152,  864,  84,  TRUE},
-	{1, 1280,  720,  60,  TRUE}, {2, 1280,  720,  75,  TRUE}, {3, 1280,  720,  85,  TRUE},
-	{1, 1280,  768,  60,  TRUE},
-	{1, 1280,  800,  60,  TRUE},
-	{1, 1280,  854,  60,  TRUE},
-	{1, 1280,  960,  60,  TRUE}, {2, 1280,  960,  85,  TRUE},
-	{1, 1280, 1024,  43,  TRUE}, {2, 1280, 1024,  60,  TRUE}, {3, 1280, 1024,  75,  TRUE},
-	{4, 1280, 1024,  85,  TRUE},
-	{1, 1360,  768,  60,  TRUE},
-	{1, 1360, 1024,  59,  TRUE},
-	{1, 1400, 1050,  60,  TRUE}, {2, 1400, 1050,  75,  TRUE},
-	{1, 1600, 1200,  60,  TRUE}, {2, 1600, 1200,  65,  TRUE}, {3, 1600, 1200,  70,  TRUE},
-	{4, 1600, 1200,  75,  TRUE}, {5, 1600, 1200,  85,  TRUE}, {6, 1600, 1200, 100,  TRUE},
-	{7, 1600, 1200, 120,  TRUE},
-	{1, 1680, 1050,  60,  TRUE},
-	{1, 1920, 1080,  30,  TRUE},
-	{1, 1920, 1440,  60,  TRUE}, {2, 1920, 1440,  65,  TRUE}, {3, 1920, 1440,  70,  TRUE},
-	{4, 1920, 1440,  75,  TRUE}, {5, 1920, 1440,  85,  TRUE}, {6, 1920, 1440, 100,  TRUE},
-	{1, 2048, 1536,  60,  TRUE}, {2, 2048, 1536,  65,  TRUE}, {3, 2048, 1536,  70,  TRUE},
-	{4, 2048, 1536,  75,  TRUE}, {5, 2048, 1536,  85,  TRUE},
-	{0,    0,    0,   0, FALSE}
+	{1,  320,  200,  70,  true},
+	{1,  320,  240,  60,  true},
+	{1,  400,  300,  60,  true},
+	{1,  512,  384,  60,  true},
+	{1,  640,  400,  72,  true},
+	{1,  640,  480,  60,  true}, {2,  640,  480,  72,  true}, {3,  640,  480,  75,  true},
+	{4,  640,  480,  85,  true}, {5,  640,  480, 100,  true}, {6,  640,  480, 120,  true},
+	{7,  640,  480, 160,  true}, {8,  640,  480, 200,  true},
+	{1,  720,  480,  60,  true},
+	{1,  720,  576,  58,  true},
+	{1,  768,  576,  58,  true},
+	{1,  800,  480,  60,  true}, {2,  800,  480,  75,  true}, {3,  800,  480,  85,  true},
+	{1,  800,  600,  56,  true}, {2,  800,  600,  60,  true}, {3,  800,  600,  72,  true},
+	{4,  800,  600,  75,  true}, {5,  800,  600,  85,  true}, {6,  800,  600, 105,  true},
+	{7,  800,  600, 120,  true}, {8,  800,  600, 160,  true},
+	{1,  848,  480,  39,  true}, {2,  848,  480,  60,  true},
+	{1,  856,  480,  39,  true}, {2,  856,  480,  60,  true},
+	{1,  960,  540,  60,  true},
+	{1,  960,  600,  60,  true},
+	{1, 1024,  576,  60,  true}, {2, 1024,  576,  75,  true}, {3, 1024,  576,  85,  true},
+	{1, 1024,  600,  60,  true},
+	{1, 1024,  768,  43,  true}, {2, 1024,  768,  60,  true}, {3, 1024,  768,  70, false},
+	{4, 1024,  768,  75, false}, {5, 1024,  768,  85,  true}, {6, 1024,  768, 100,  true},
+	{7, 1024,  768, 120,  true},
+	{1, 1152,  768,  60,  true},
+	{1, 1152,  864,  60,  true}, {2, 1152,  864,  75,  true}, {3, 1152,  864,  84,  true},
+	{1, 1280,  720,  60,  true}, {2, 1280,  720,  75,  true}, {3, 1280,  720,  85,  true},
+	{1, 1280,  768,  60,  true},
+	{1, 1280,  800,  60,  true},
+	{1, 1280,  854,  60,  true},
+	{1, 1280,  960,  60,  true}, {2, 1280,  960,  85,  true},
+	{1, 1280, 1024,  43,  true}, {2, 1280, 1024,  60,  true}, {3, 1280, 1024,  75,  true},
+	{4, 1280, 1024,  85,  true},
+	{1, 1360,  768,  60,  true},
+	{1, 1360, 1024,  59,  true},
+	{1, 1400, 1050,  60,  true}, {2, 1400, 1050,  75,  true},
+	{1, 1600, 1200,  60,  true}, {2, 1600, 1200,  65,  true}, {3, 1600, 1200,  70,  true},
+	{4, 1600, 1200,  75,  true}, {5, 1600, 1200,  85,  true}, {6, 1600, 1200, 100,  true},
+	{7, 1600, 1200, 120,  true},
+	{1, 1680, 1050,  60,  true},
+	{1, 1920, 1080,  30,  true},
+	{1, 1920, 1440,  60,  true}, {2, 1920, 1440,  65,  true}, {3, 1920, 1440,  70,  true},
+	{4, 1920, 1440,  75,  true}, {5, 1920, 1440,  85,  true}, {6, 1920, 1440, 100,  true},
+	{1, 2048, 1536,  60,  true}, {2, 2048, 1536,  65,  true}, {3, 2048, 1536,  70,  true},
+	{4, 2048, 1536,  75,  true}, {5, 2048, 1536,  85,  true},
+	{0,    0,    0,   0, false}
 };
 
 static struct _sisfbddcsmodes {
@@ -691,7 +691,7 @@ extern int	sisfb_initaccel(struct sis_vi
 extern void	sisfb_syncaccel(struct sis_video_info *ivideo);
 
 /* Internal general routines */
-static void	sisfb_search_mode(char *name, BOOLEAN quiet);
+static void	sisfb_search_mode(char *name, bool quiet);
 static int	sisfb_validate_mode(struct sis_video_info *ivideo, int modeindex, u32 vbflags);
 static u8	sisfb_search_refresh_rate(struct sis_video_info *ivideo, unsigned int rate,
 				int index);
@@ -702,10 +702,10 @@ static int	sisfb_do_set_var(struct fb_va
 				struct fb_info *info);
 static void	sisfb_pre_setmode(struct sis_video_info *ivideo);
 static void	sisfb_post_setmode(struct sis_video_info *ivideo);
-static BOOLEAN	sisfb_CheckVBRetrace(struct sis_video_info *ivideo);
-static BOOLEAN	sisfbcheckvretracecrt2(struct sis_video_info *ivideo);
-static BOOLEAN	sisfbcheckvretracecrt1(struct sis_video_info *ivideo);
-static BOOLEAN	sisfb_bridgeisslave(struct sis_video_info *ivideo);
+static bool	sisfb_CheckVBRetrace(struct sis_video_info *ivideo);
+static bool	sisfbcheckvretracecrt2(struct sis_video_info *ivideo);
+static bool	sisfbcheckvretracecrt1(struct sis_video_info *ivideo);
+static bool	sisfb_bridgeisslave(struct sis_video_info *ivideo);
 static void	sisfb_detect_VB_connect(struct sis_video_info *ivideo);
 static void	sisfb_get_VB_type(struct sis_video_info *ivideo);
 static void	sisfb_set_TVxposoffset(struct sis_video_info *ivideo, int val);
@@ -737,20 +737,20 @@ static void		sisfb_free_node(struct SIS_
 
 /* Routines from init.c/init301.c */
 extern unsigned short	SiS_GetModeID_LCD(int VGAEngine, unsigned int VBFlags, int HDisplay,
-				int VDisplay, int Depth, BOOLEAN FSTN, unsigned short CustomT,
+				int VDisplay, int Depth, bool FSTN, unsigned short CustomT,
 				int LCDwith, int LCDheight, unsigned int VBFlags2);
 extern unsigned short	SiS_GetModeID_TV(int VGAEngine, unsigned int VBFlags, int HDisplay,
 				int VDisplay, int Depth, unsigned int VBFlags2);
 extern unsigned short	SiS_GetModeID_VGA2(int VGAEngine, unsigned int VBFlags, int HDisplay,
 				int VDisplay, int Depth, unsigned int VBFlags2);
 extern void		SiSRegInit(struct SiS_Private *SiS_Pr, SISIOADDRESS BaseAddr);
-extern BOOLEAN		SiSSetMode(struct SiS_Private *SiS_Pr, unsigned short ModeNo);
+extern bool		SiSSetMode(struct SiS_Private *SiS_Pr, unsigned short ModeNo);
 extern void		SiS_SetEnableDstn(struct SiS_Private *SiS_Pr, int enable);
 extern void		SiS_SetEnableFstn(struct SiS_Private *SiS_Pr, int enable);
 
-extern BOOLEAN		SiSDetermineROMLayout661(struct SiS_Private *SiS_Pr);
+extern bool		SiSDetermineROMLayout661(struct SiS_Private *SiS_Pr);
 
-extern BOOLEAN		sisfb_gettotalfrommode(struct SiS_Private *SiS_Pr, unsigned char modeno,
+extern bool		sisfb_gettotalfrommode(struct SiS_Private *SiS_Pr, unsigned char modeno,
 				int *htotal, int *vtotal, unsigned char rateindex);
 extern int		sisfb_mode_rate_to_dclock(struct SiS_Private *SiS_Pr,
 				unsigned char modeno, unsigned char rateindex);
diff -puN drivers/video/sis/vgatypes.h~drivers-video-sis-convert-to-generic-boolean drivers/video/sis/vgatypes.h
--- a/drivers/video/sis/vgatypes.h~drivers-video-sis-convert-to-generic-boolean
+++ a/drivers/video/sis/vgatypes.h
@@ -57,18 +57,6 @@
 #include <linux/version.h>
 #endif
 
-#ifndef FALSE
-#define FALSE   0
-#endif
-
-#ifndef TRUE
-#define TRUE    1
-#endif
-
-#ifndef BOOLEAN
-typedef unsigned int BOOLEAN;
-#endif
-
 #define SISIOMEMTYPE
 
 #ifdef SIS_LINUX_KERNEL
diff -puN drivers/video/sis/vstruct.h~drivers-video-sis-convert-to-generic-boolean drivers/video/sis/vstruct.h
--- a/drivers/video/sis/vstruct.h~drivers-video-sis-convert-to-generic-boolean
+++ a/drivers/video/sis/vstruct.h
@@ -240,7 +240,7 @@ struct SiS_Private
 	void				*ivideo;
 #endif
 	unsigned char 			*VirtualRomBase;
-	BOOLEAN				UseROM;
+	bool				UseROM;
 #ifdef SIS_LINUX_KERNEL
 	unsigned char SISIOMEMTYPE	*VideoMemoryAddress;
 	unsigned int			VideoMemorySize;
@@ -283,24 +283,24 @@ struct SiS_Private
 #ifdef SIS_XORG_XF86
 	unsigned short			SiS_CP1, SiS_CP2, SiS_CP3, SiS_CP4;
 #endif
-	BOOLEAN				SiS_UseROM;
-	BOOLEAN				SiS_ROMNew;
-	BOOLEAN				SiS_XGIROM;
-	BOOLEAN				SiS_NeedRomModeData;
-	BOOLEAN				PanelSelfDetected;
-	BOOLEAN				DDCPortMixup;
+	bool				SiS_UseROM;
+	bool				SiS_ROMNew;
+	bool				SiS_XGIROM;
+	bool				SiS_NeedRomModeData;
+	bool				PanelSelfDetected;
+	bool				DDCPortMixup;
 	int				SiS_CHOverScan;
-	BOOLEAN				SiS_CHSOverScan;
-	BOOLEAN				SiS_ChSW;
-	BOOLEAN				SiS_UseLCDA;
+	bool				SiS_CHSOverScan;
+	bool				SiS_ChSW;
+	bool				SiS_UseLCDA;
 	int				SiS_UseOEM;
 	unsigned int			SiS_CustomT;
 	int				SiS_UseWide, SiS_UseWideCRT2;
 	int				SiS_TVBlue;
 	unsigned short			SiS_Backup70xx;
-	BOOLEAN				HaveEMI;
-	BOOLEAN				HaveEMILCD;
-	BOOLEAN				OverruleEMI;
+	bool				HaveEMI;
+	bool				HaveEMILCD;
+	bool				OverruleEMI;
 	unsigned char			EMI_30,EMI_31,EMI_32,EMI_33;
 	unsigned short			SiS_EMIOffset;
 	unsigned short			SiS_PWDOffset;
@@ -352,7 +352,7 @@ struct SiS_Private
 	unsigned short			SiS_DDC_ReadAddr;
 	unsigned short			SiS_DDC_SecAddr;
 	unsigned short			SiS_ChrontelInit;
-	BOOLEAN				SiS_SensibleSR11;
+	bool				SiS_SensibleSR11;
 	unsigned short			SiS661LCD2TableSize;
 
 	unsigned short			SiS_PanelMinLVDS;
@@ -494,10 +494,10 @@ struct SiS_Private
 	unsigned short			PanelVRS,  PanelVRE;
 	unsigned short			PanelVCLKIdx300;
 	unsigned short			PanelVCLKIdx315;
-	BOOLEAN				Alternate1600x1200;
+	bool				Alternate1600x1200;
 
-	BOOLEAN				UseCustomMode;
-	BOOLEAN				CRT1UsesCustomMode;
+	bool				UseCustomMode;
+	bool				CRT1UsesCustomMode;
 	unsigned short			CHDisplay;
 	unsigned short			CHSyncStart;
 	unsigned short			CHSyncEnd;
@@ -523,7 +523,7 @@ struct SiS_Private
 
 	int				LVDSHL;
 
-	BOOLEAN				Backup;
+	bool				Backup;
 	unsigned char			Backup_Mode;
 	unsigned char			Backup_14;
 	unsigned char			Backup_15;
@@ -542,12 +542,12 @@ struct SiS_Private
 	int				CenterScreen;
 
 	unsigned short			CP_Vendor, CP_Product;
-	BOOLEAN				CP_HaveCustomData;
+	bool				CP_HaveCustomData;
 	int				CP_PreferredX, CP_PreferredY, CP_PreferredIndex;
 	int				CP_MaxX, CP_MaxY, CP_MaxClock;
 	unsigned char			CP_PrefSR2B, CP_PrefSR2C;
 	unsigned short			CP_PrefClock;
-	BOOLEAN				CP_Supports64048075;
+	bool				CP_Supports64048075;
 	int				CP_HDisplay[7], CP_VDisplay[7];	/* For Custom LCD panel dimensions */
 	int				CP_HTotal[7], CP_VTotal[7];
 	int				CP_HSyncStart[7], CP_VSyncStart[7];
@@ -555,8 +555,8 @@ struct SiS_Private
 	int				CP_HBlankStart[7], CP_VBlankStart[7];
 	int				CP_HBlankEnd[7], CP_VBlankEnd[7];
 	int				CP_Clock[7];
-	BOOLEAN				CP_DataValid[7];
-	BOOLEAN				CP_HSync_P[7], CP_VSync_P[7], CP_SyncValid[7];
+	bool				CP_DataValid[7];
+	bool				CP_HSync_P[7], CP_VSync_P[7], CP_SyncValid[7];
 };
 
 #endif
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

drivers-media-video-convert-to-generic-boolean-values.patch
hp100-convert-pci_module_init-to-pci_register_driver.patch
drivers-scsi-buslogic-replace-boolean-by-bool.patch
git-cryptodev.patch
drivers-block-dac960-converted-boolean-to-bool.patch
drivers-isdn-hardware-eicon-convert-to-generic-boolean-values.patch
drivers-isdn-hisax-convert-to-generic-boolean-values.patch
drivers-video-sis-convert-to-generic-boolean.patch
