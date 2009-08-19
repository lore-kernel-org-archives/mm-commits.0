From: akpm@linux-foundation.org
Subject: + viafb-clean-up-viamodeh.patch added to -mm tree
Date: Wed, 19 Aug 2009 11:49:54 -0700
Message-ID: <200908191849.n7JInsww025623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752911AbZHSSuQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Aug 2009 14:50:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn


The patch titled
     viafb: clean up viamode.h
has been added to the -mm tree.  Its filename is
     viafb-clean-up-viamodeh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: clean up viamode.h
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Remove unneeeded declarations from the header and makes it more
maintainable by evaluating the array size in the file the array exist in
and exporting it via variables.  This removes the need to keep the array
size in the header in sync with the real array size.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viamode.c |   10 ++
 drivers/video/via/viamode.h |  138 +++++-----------------------------
 2 files changed, 32 insertions(+), 116 deletions(-)

diff -puN drivers/video/via/viamode.c~viafb-clean-up-viamodeh drivers/video/via/viamode.c
--- a/drivers/video/via/viamode.c~viafb-clean-up-viamodeh
+++ a/drivers/video/via/viamode.c
@@ -1006,3 +1006,13 @@ struct VideoModeTable CEA_HDMI_Modes[] =
 	{VIA_RES_1280X720, CEAM1280x720, ARRAY_SIZE(CEAM1280x720)},
 	{VIA_RES_1920X1080, CEAM1920x1080, ARRAY_SIZE(CEAM1920x1080)}
 };
+
+int NUM_TOTAL_RES_MAP_REFRESH = ARRAY_SIZE(res_map_refresh_tbl);
+int NUM_TOTAL_CEA_MODES = ARRAY_SIZE(CEA_HDMI_Modes);
+int NUM_TOTAL_CN400_ModeXregs = ARRAY_SIZE(CN400_ModeXregs);
+int NUM_TOTAL_CN700_ModeXregs = ARRAY_SIZE(CN700_ModeXregs);
+int NUM_TOTAL_KM400_ModeXregs = ARRAY_SIZE(KM400_ModeXregs);
+int NUM_TOTAL_CX700_ModeXregs = ARRAY_SIZE(CX700_ModeXregs);
+int NUM_TOTAL_CLE266_ModeXregs = ARRAY_SIZE(CLE266_ModeXregs);
+int NUM_TOTAL_PATCH_MODE = ARRAY_SIZE(res_patch_table);
+int NUM_TOTAL_MODETABLE = ARRAY_SIZE(CLE266Modes);
diff -puN drivers/video/via/viamode.h~viafb-clean-up-viamodeh drivers/video/via/viamode.h
--- a/drivers/video/via/viamode.h~viafb-clean-up-viamodeh
+++ a/drivers/video/via/viamode.h
@@ -50,127 +50,33 @@ struct res_map_refresh {
 	int vmode_refresh;
 };
 
-#define NUM_TOTAL_RES_MAP_REFRESH ARRAY_SIZE(res_map_refresh_tbl)
-#define NUM_TOTAL_CEA_MODES  ARRAY_SIZE(CEA_HDMI_Modes)
-#define NUM_TOTAL_CN400_ModeXregs ARRAY_SIZE(CN400_ModeXregs)
-#define NUM_TOTAL_CN700_ModeXregs ARRAY_SIZE(CN700_ModeXregs)
-#define NUM_TOTAL_KM400_ModeXregs ARRAY_SIZE(KM400_ModeXregs)
-#define NUM_TOTAL_CX700_ModeXregs ARRAY_SIZE(CX700_ModeXregs)
-#define NUM_TOTAL_CLE266_ModeXregs ARRAY_SIZE(CLE266_ModeXregs)
-#define NUM_TOTAL_PATCH_MODE ARRAY_SIZE(res_patch_table)
-#define NUM_TOTAL_MODETABLE ARRAY_SIZE(CLE266Modes)
+extern int NUM_TOTAL_RES_MAP_REFRESH;
+extern int NUM_TOTAL_CEA_MODES;
+extern int NUM_TOTAL_CN400_ModeXregs;
+extern int NUM_TOTAL_CN700_ModeXregs;
+extern int NUM_TOTAL_KM400_ModeXregs;
+extern int NUM_TOTAL_CX700_ModeXregs;
+extern int NUM_TOTAL_CLE266_ModeXregs;
+extern int NUM_TOTAL_PATCH_MODE;
+extern int NUM_TOTAL_MODETABLE;
 
 /********************/
 /* Mode Table       */
 /********************/
 
-/* 480x640 */
-extern struct crt_mode_table CRTM480x640[1];
-/* 640x480*/
-extern struct crt_mode_table CRTM640x480[5];
-/*720x480 (GTF)*/
-extern struct crt_mode_table CRTM720x480[1];
-/*720x576 (GTF)*/
-extern struct crt_mode_table CRTM720x576[1];
-/* 800x480 (CVT) */
-extern struct crt_mode_table CRTM800x480[1];
-/* 800x600*/
-extern struct crt_mode_table CRTM800x600[5];
-/* 848x480 (CVT) */
-extern struct crt_mode_table CRTM848x480[1];
-/*856x480 (GTF) convert to 852x480*/
-extern struct crt_mode_table CRTM852x480[1];
-/*1024x512 (GTF)*/
-extern struct crt_mode_table CRTM1024x512[1];
-/* 1024x600*/
-extern struct crt_mode_table CRTM1024x600[1];
-/* 1024x768*/
-extern struct crt_mode_table CRTM1024x768[4];
-/* 1152x864*/
-extern struct crt_mode_table CRTM1152x864[1];
-/* 1280x720 (HDMI 720P)*/
-extern struct crt_mode_table CRTM1280x720[2];
-/*1280x768 (GTF)*/
-extern struct crt_mode_table CRTM1280x768[2];
-/* 1280x800 (CVT) */
-extern struct crt_mode_table CRTM1280x800[1];
-/*1280x960*/
-extern struct crt_mode_table CRTM1280x960[1];
-/* 1280x1024*/
-extern struct crt_mode_table CRTM1280x1024[3];
-/* 1368x768 (GTF) */
-extern struct crt_mode_table CRTM1368x768[1];
-/*1440x1050 (GTF)*/
-extern struct crt_mode_table CRTM1440x1050[1];
-/* 1600x1200*/
-extern struct crt_mode_table CRTM1600x1200[2];
-/* 1680x1050 (CVT) */
-extern struct crt_mode_table CRTM1680x1050[2];
-/* 1680x1050 (CVT Reduce Blanking) */
-extern struct crt_mode_table CRTM1680x1050_RB[1];
-/* 1920x1080 (CVT)*/
-extern struct crt_mode_table CRTM1920x1080[1];
-/* 1920x1080 (CVT with Reduce Blanking) */
-extern struct crt_mode_table CRTM1920x1080_RB[1];
-/* 1920x1440*/
-extern struct crt_mode_table CRTM1920x1440[2];
-/* 1400x1050 (CVT) */
-extern struct crt_mode_table CRTM1400x1050[2];
-/* 1400x1050 (CVT Reduce Blanking) */
-extern struct crt_mode_table CRTM1400x1050_RB[1];
-/* 960x600 (CVT) */
-extern struct crt_mode_table CRTM960x600[1];
-/* 1000x600 (GTF) */
-extern struct crt_mode_table CRTM1000x600[1];
-/* 1024x576 (GTF) */
-extern struct crt_mode_table CRTM1024x576[1];
-/* 1088x612 (CVT) */
-extern struct crt_mode_table CRTM1088x612[1];
-/* 1152x720 (CVT) */
-extern struct crt_mode_table CRTM1152x720[1];
-/* 1200x720 (GTF) */
-extern struct crt_mode_table CRTM1200x720[1];
-/* 1280x600 (GTF) */
-extern struct crt_mode_table CRTM1280x600[1];
-/* 1360x768 (CVT) */
-extern struct crt_mode_table CRTM1360x768[1];
-/* 1360x768 (CVT Reduce Blanking) */
-extern struct crt_mode_table CRTM1360x768_RB[1];
-/* 1366x768 (GTF) */
-extern struct crt_mode_table CRTM1366x768[2];
-/* 1440x900 (CVT) */
-extern struct crt_mode_table CRTM1440x900[2];
-/* 1440x900 (CVT Reduce Blanking) */
-extern struct crt_mode_table CRTM1440x900_RB[1];
-/* 1600x900 (CVT) */
-extern struct crt_mode_table CRTM1600x900[1];
-/* 1600x900 (CVT Reduce Blanking) */
-extern struct crt_mode_table CRTM1600x900_RB[1];
-/* 1600x1024 (GTF) */
-extern struct crt_mode_table CRTM1600x1024[1];
-/* 1792x1344 (DMT) */
-extern struct crt_mode_table CRTM1792x1344[1];
-/* 1856x1392 (DMT) */
-extern struct crt_mode_table CRTM1856x1392[1];
-/* 1920x1200 (CVT) */
-extern struct crt_mode_table CRTM1920x1200[1];
-/* 1920x1200 (CVT with Reduce Blanking) */
-extern struct crt_mode_table CRTM1920x1200_RB[1];
-/* 2048x1536 (CVT) */
-extern struct crt_mode_table CRTM2048x1536[1];
-extern struct VideoModeTable CLE266Modes[47];
-extern struct crt_mode_table CEAM1280x720[1];
-extern struct crt_mode_table CEAM1920x1080[1];
-extern struct VideoModeTable CEA_HDMI_Modes[2];
+extern struct VideoModeTable CLE266Modes[];
+extern struct crt_mode_table CEAM1280x720[];
+extern struct crt_mode_table CEAM1920x1080[];
+extern struct VideoModeTable CEA_HDMI_Modes[];
 
-extern struct res_map_refresh res_map_refresh_tbl[61];
-extern struct io_reg CN400_ModeXregs[52];
-extern struct io_reg CN700_ModeXregs[66];
-extern struct io_reg KM400_ModeXregs[55];
-extern struct io_reg CX700_ModeXregs[58];
-extern struct io_reg VX800_ModeXregs[58];
-extern struct io_reg CLE266_ModeXregs[32];
-extern struct io_reg PM1024x768[2];
-extern struct patch_table res_patch_table[1];
+extern struct res_map_refresh res_map_refresh_tbl[];
+extern struct io_reg CN400_ModeXregs[];
+extern struct io_reg CN700_ModeXregs[];
+extern struct io_reg KM400_ModeXregs[];
+extern struct io_reg CX700_ModeXregs[];
+extern struct io_reg VX800_ModeXregs[];
+extern struct io_reg CLE266_ModeXregs[];
+extern struct io_reg PM1024x768[];
+extern struct patch_table res_patch_table[];
 extern struct VPITTable VPIT;
 #endif /* __VIAMODE_H__ */
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

viafb-remove-duplicated-cx700-register-init.patch
viafb-remove-temporary-start-address-setting.patch
viafb-merge-viafb_update_viafb_par-in-viafb_update_fix.patch
viafb-split-viafb_set_start_addr-up.patch
viafb-fix-ioremap_nocache-error-handling.patch
viafb-clean-up-viamodeh.patch
viafb-remove-duplicated-mode-information.patch
viafb-clean-up-duoview.patch
viafb-clean-up-virtual-memory-handling.patch
fb-fix-fb_pan_display-range-check.patch

