From: akpm@linux-foundation.org
Subject: + pm3fb-header-file-reduction.patch added to -mm tree
Date: Thu, 26 Jul 2007 12:00:26 -0700
Message-ID: <200707261900.l6QJ0Qn0015621@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37615 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936377AbXGZTBS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 15:01:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     pm3fb: header file reduction
has been added to the -mm tree.  Its filename is
     pm3fb-header-file-reduction.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pm3fb: header file reduction
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch removes constants named AAA_DISABLE with value 0. They are redudant
and misleading ( a |= AAA_DISABLE does nothing and usually should be
a &= ~AAA_ENABLE).

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm3fb.c |    5 ++---
 include/video/pm3fb.h |   37 -------------------------------------
 2 files changed, 2 insertions(+), 40 deletions(-)

diff -puN drivers/video/pm3fb.c~pm3fb-header-file-reduction drivers/video/pm3fb.c
--- a/drivers/video/pm3fb.c~pm3fb-header-file-reduction
+++ a/drivers/video/pm3fb.c
@@ -886,7 +886,7 @@ static int pm3fb_set_par(struct fb_info 
 	if ((info->var.activate & FB_ACTIVATE_MASK) == FB_ACTIVATE_NOW)
 		par->video |= PM3VideoControl_ENABLE;
 	else {
-		par->video |= PM3VideoControl_DISABLE;
+		par->video &= ~PM3VideoControl_ENABLE;
 		DPRINTK("PM3Video disabled\n");
 	}
 	switch (bpp) {
@@ -911,8 +911,7 @@ static int pm3fb_set_par(struct fb_info 
 
 /*	pm3fb_clear_memory(info, 0);*/
 	pm3fb_clear_colormap(par, 0, 0, 0);
-	PM3_WRITE_DAC_REG(par, PM3RD_CursorMode,
-			  PM3RD_CursorMode_CURSOR_DISABLE);
+	PM3_WRITE_DAC_REG(par, PM3RD_CursorMode, 0);
 	pm3fb_init_engine(info);
 	pm3fb_write_mode(info);
 	return 0;
diff -puN include/video/pm3fb.h~pm3fb-header-file-reduction include/video/pm3fb.h
--- a/include/video/pm3fb.h~pm3fb-header-file-reduction
+++ a/include/video/pm3fb.h
@@ -55,7 +55,6 @@
 	#define PM3ByApertureMode_BYTESWAP_BADC			(1<<0)
 	#define PM3ByApertureMode_BYTESWAP_CDAB			(2<<0)
 	#define PM3ByApertureMode_BYTESWAP_DCBA			(3<<0)
-	#define PM3ByApertureMode_PATCH_DISABLE			(0<<2)
 	#define PM3ByApertureMode_PATCH_ENABLE			(1<<2)
 	#define PM3ByApertureMode_FORMAT_RAW			(0<<3)
 	#define PM3ByApertureMode_FORMAT_YUYV			(1<<3)
@@ -112,7 +111,6 @@
 #define PM3VsStart						0x3048
 #define PM3VsEnd						0x3050
 #define PM3VideoControl						0x3058
-	#define PM3VideoControl_DISABLE				(0<<0)
 	#define PM3VideoControl_ENABLE				(1<<0)
 	#define PM3VideoControl_BLANK_ACTIVE_HIGH		(0<<1)
 	#define PM3VideoControl_BLANK_ACTIVE_LOW		(1<<1)
@@ -133,7 +131,6 @@
 	#define PM3VideoControl_BUFFER_SWAP_SYNCON_FRAMEBLANK	(0<<9)
 	#define PM3VideoControl_BUFFER_SWAP_FREE_RUNNING	(1<<9)
 	#define PM3VideoControl_BUFFER_SWAP_LIMITETO_FRAMERATE	(2<<9)
-	#define PM3VideoControl_STEREO_DISABLE			(0<<11)
 	#define PM3VideoControl_STEREO_ENABLE			(1<<11)
 	#define PM3VideoControl_RIGHT_EYE_ACTIVE_HIGH		(0<<12)
 	#define PM3VideoControl_RIGHT_EYE_ACTIVE_LOW		(1<<12)
@@ -142,12 +139,10 @@
 	#define PM3VideoControl_SYNC_MODE_INDEPENDENT		(0<<16)
 	#define PM3VideoControl_SYNC_MODE_SYNCTO_VSA		(1<<16)
 	#define PM3VideoControl_SYNC_MODE_SYNCTO_VSB		(2<<16)
-	#define PM3VideoControl_PATCH_DISABLE			(0<<18)
 	#define PM3VideoControl_PATCH_ENABLE			(1<<18)
 	#define PM3VideoControl_PIXELSIZE_8BIT			(0<<19)
 	#define PM3VideoControl_PIXELSIZE_16BIT			(1<<19)
 	#define PM3VideoControl_PIXELSIZE_32BIT			(2<<19)
-	#define PM3VideoControl_DISPLAY_DISABLE			(0<<21)
 	#define PM3VideoControl_DISPLAY_ENABLE			(1<<21)
 	#define PM3VideoControl_PATCH_OFFSET_X(off)	(((off)&0x3f)<<22)
 	#define PM3VideoControl_PATCH_OFFSET_Y(off)	(((off)&0x3f)<<28)
@@ -159,10 +154,8 @@
 #define PM3MiscControl						0x3088
 
 #define PM3VideoOverlayUpdate					0x3100
-        #define PM3VideoOverlayUpdate_DISABLE                   (0<<0)
         #define PM3VideoOverlayUpdate_ENABLE                    (1<<0)
 #define PM3VideoOverlayMode					0x3108
-	#define PM3VideoOverlayMode_DISABLE			(0<<0)
 	#define PM3VideoOverlayMode_ENABLE			(1<<0)
         #define PM3VideoOverlayMode_BUFFERSYNC_MANUAL           (0<<1)
         #define PM3VideoOverlayMode_BUFFERSYNC_VIDEOSTREAMA     (1<<1)
@@ -250,25 +243,16 @@
 #define PM3RD_IndexedData					0x4030
 #define PM3RD_IndexControl					0x4038
 	#define PM3RD_IndexControl_AUTOINCREMENT_ENABLE		(1<<0)
-	#define PM3RD_IndexControl_AUTOINCREMENT_DISABLE	(0<<0)
 
 /* Indirect Registers */
 #define PM3RD_MiscControl					0x000
-	#define PM3RD_MiscControl_HIGHCOLOR_RES_DISABLE		(0<<0)
 	#define PM3RD_MiscControl_HIGHCOLOR_RES_ENABLE		(1<<0)
-	#define PM3RD_MiscControl_PIXELDOUBLE_DISABLE		(0<<1)
 	#define PM3RD_MiscControl_PIXELDOUBLE_ENABLE		(1<<1)
-	#define PM3RD_MiscControl_LASTREAD_ADDR_DISABLE		(0<<2)
 	#define PM3RD_MiscControl_LASTREAD_ADDR_ENABLE		(1<<2)
-	#define PM3RD_MiscControl_DIRECTCOLOR_DISABLE		(0<<3)
 	#define PM3RD_MiscControl_DIRECTCOLOR_ENABLE		(1<<3)
-	#define PM3RD_MiscControl_OVERLAY_DISABLE		(0<<4)
 	#define PM3RD_MiscControl_OVERLAY_ENABLE		(1<<4)
-	#define PM3RD_MiscControl_PIXELDOUBLE_BUFFER_DISABLE	(0<<5)
 	#define PM3RD_MiscControl_PIXELDOUBLE_BUFFER_ENABLE	(1<<5)
-	#define PM3RD_MiscControl_VSB_OUTPUT_DISABLE		(0<<6)
 	#define PM3RD_MiscControl_VSB_OUTPUT_ENABLE		(1<<6)
-	#define PM3RD_MiscControl_STEREODOUBLE_BUFFER_DISABLE	(0<<7)
 	#define PM3RD_MiscControl_STEREODOUBLE_BUFFER_ENABLE	(1<<7)
 #define PM3RD_SyncControl					0x001
 	#define PM3RD_SyncControl_HSYNC_ACTIVE_LOW		(0<<0)
@@ -288,15 +272,10 @@
 #define PM3RD_DACControl					0x002
 	#define PM3RD_DACControl_DAC_POWER_ON			(0<<0)
 	#define PM3RD_DACControl_DAC_POWER_OFF			(1<<0)
-	#define PM3RD_DACControl_SYNC_ON_GREEN_DISABLE		(0<<3)
 	#define PM3RD_DACControl_SYNC_ON_GREEN_ENABLE		(1<<3)
-	#define PM3RD_DACControl_BLANK_RED_DAC_DISABLE		(0<<4)
 	#define PM3RD_DACControl_BLANK_RED_DAC_ENABLE		(1<<4)
-	#define PM3RD_DACControl_BLANK_GREEN_DAC_DISABLE	(0<<5)
 	#define PM3RD_DACControl_BLANK_GREEN_DAC_ENABLE		(1<<5)
-	#define PM3RD_DACControl_BLANK_BLUE_DAC_DISABLE		(0<<6)
 	#define PM3RD_DACControl_BLANK_BLUE_DAC_ENABLE		(1<<6)
-	#define PM3RD_DACControl_BLANK_PEDESTAL_DISABLE		(0<<7)
 	#define PM3RD_DACControl_BLANK_PEDESTAL_ENABLE		(1<<7)
 #define PM3RD_PixelSize						0x003
 	#define PM3RD_PixelSize_24_BIT_PIXELS			(4<<0)
@@ -305,7 +284,6 @@
 	#define PM3RD_PixelSize_8_BIT_PIXELS			(0<<0)
 #define PM3RD_ColorFormat					0x004
 	#define PM3RD_ColorFormat_LINEAR_COLOR_EXT_ENABLE	(1<<6)
-	#define PM3RD_ColorFormat_LINEAR_COLOR_EXT_DISABLE	(0<<6)
 	#define PM3RD_ColorFormat_COLOR_ORDER_BLUE_LOW		(1<<5)
 	#define PM3RD_ColorFormat_COLOR_ORDER_RED_LOW		(0<<5)
 	#define PM3RD_ColorFormat_COLOR_FORMAT_MASK		(0x1f<<0)
@@ -323,7 +301,6 @@
 	#define PM3RD_ColorFormat_565_FRONT_COLOR		(16<<0)
 	#define PM3RD_ColorFormat_565_BACK_COLOR		(17<<0)
 #define PM3RD_CursorMode					0x005
-	#define PM3RD_CursorMode_CURSOR_DISABLE			(0<<0)
 	#define PM3RD_CursorMode_CURSOR_ENABLE			(1<<0)
 	#define PM3RD_CursorMode_FORMAT_64x64_2BPE_P0123	(0<<2)
 	#define PM3RD_CursorMode_FORMAT_32x32_2BPE_P0		(1<<2)
@@ -334,16 +311,12 @@
 	#define PM3RD_CursorMode_FORMAT_32x32_4BPE_P23		(6<<2)
 	#define PM3RD_CursorMode_TYPE_MS			(0<<4)
 	#define PM3RD_CursorMode_TYPE_X				(1<<4)
-	#define PM3RD_CursorMode_REVERSE_PIXEL_ORDER_DISABLE	(0<<6)
 	#define PM3RD_CursorMode_REVERSE_PIXEL_ORDER_ENABLE	(1<<6)
 	#define PM3RD_CursorMode_REVERSE_PIXEL_ORDER_3_COLOR	(2<<6)
 	#define PM3RD_CursorMode_REVERSE_PIXEL_ORDER_15_COLOR	(3<<6)
 #define PM3RD_CursorControl					0x006
-	#define PM3RD_CursorControl_DOUBLE_X_DISABLED		(0<<0)
 	#define PM3RD_CursorControl_DOUBLE_X_ENABLED		(1<<0)
-	#define PM3RD_CursorControl_DOUBLE_Y_DISABLED		(0<<1)
 	#define PM3RD_CursorControl_DOUBLE_Y_ENABLED		(1<<1)
-	#define PM3RD_CursorControl_READBACK_POS_DISABLED	(0<<2)
 	#define PM3RD_CursorControl_READBACK_POS_ENABLED	(1<<2)
 
 #define PM3RD_CursorXLow					0x007
@@ -354,16 +327,12 @@
 #define PM3RD_CursorHotSpotY					0x00c
 #define PM3RD_OverlayKey					0x00d
 #define PM3RD_Pan						0x00e
-	#define PM3RD_Pan_DISABLE				(0<<0)
 	#define PM3RD_Pan_ENABLE				(1<<0)
-	#define PM3RD_Pan_GATE_DISABLE				(0<<1)
 	#define PM3RD_Pan_GATE_ENABLE				(1<<1)
 #define PM3RD_Sense						0x00f
 
 #define PM3RD_CheckControl					0x018
-	#define PM3RD_CheckControl_PIXEL_DISABLED		(0<<0)
 	#define PM3RD_CheckControl_PIXEL_ENABLED		(1<<0)
-	#define PM3RD_CheckControl_LUT_DISABLED			(0<<1)
 	#define PM3RD_CheckControl_LUT_ENABLED			(1<<1)
 #define PM3RD_CheckPixelRed					0x019
 #define PM3RD_CheckPixelGreen					0x01a
@@ -374,14 +343,12 @@
 #define PM3RD_Scratch						0x01f
 
 #define PM3RD_VideoOverlayControl				0x020
-        #define PM3RD_VideoOverlayControl_DISABLE               (0<<0)
         #define PM3RD_VideoOverlayControl_ENABLE                (1<<0)
         #define PM3RD_VideoOverlayControl_MODE_MASK             (3<<1)
         #define PM3RD_VideoOverlayControl_MODE_MAINKEY          (0<<1)
         #define PM3RD_VideoOverlayControl_MODE_OVERLAYKEY       (1<<1)
         #define PM3RD_VideoOverlayControl_MODE_ALWAYS           (2<<1)
         #define PM3RD_VideoOverlayControl_MODE_BLEND            (3<<1)
-        #define PM3RD_VideoOverlayControl_DIRECTCOLOR_DISABLED  (0<<3)
         #define PM3RD_VideoOverlayControl_DIRECTCOLOR_ENABLED   (1<<3)
         #define PM3RD_VideoOverlayControl_BLENDSRC_MAIN         (0<<4)
         #define PM3RD_VideoOverlayControl_BLENDSRC_REGISTER     (1<<4)
@@ -420,7 +387,6 @@
 	#define PM3RD_DClkControl_LOCKED			(1<<1)
 	#define PM3RD_DClkControl_NOT_LOCKED			(0<<1)
 	#define PM3RD_DClkControl_ENABLE			(1<<0)
-	#define PM3RD_DClkControl_DISABLE			(0<<0)
 #define PM3RD_DClk0PreScale					0x201
 #define PM3RD_DClk0FeedbackScale				0x202
 #define PM3RD_DClk0PostScale					0x203
@@ -435,7 +401,6 @@
 #define PM3RD_DClk3FeedbackScale				0x20b
 #define PM3RD_DClk3PostScale					0x20c
 #define PM3RD_KClkControl					0x20d
-	#define PM3RD_KClkControl_DISABLE			(0<<0)
 	#define PM3RD_KClkControl_ENABLE			(1<<0)
 	#define PM3RD_KClkControl_NOT_LOCKED			(0<<1)
 	#define PM3RD_KClkControl_LOCKED			(1<<1)
@@ -450,7 +415,6 @@
 #define PM3RD_KClkFeedbackScale					0x20f
 #define PM3RD_KClkPostScale					0x210
 #define PM3RD_MClkControl					0x211
-	#define PM3RD_MClkControl_DISABLE			(0<<0)
 	#define PM3RD_MClkControl_ENABLE			(1<<0)
 	#define PM3RD_MClkControl_NOT_LOCKED			(0<<1)
 	#define PM3RD_MClkControl_LOCKED			(1<<1)
@@ -468,7 +432,6 @@
 #define PM3RD_MClkFeedbackScale					0x213
 #define PM3RD_MClkPostScale					0x214
 #define PM3RD_SClkControl					0x215
-	#define PM3RD_SClkControl_DISABLE			(0<<0)
 	#define PM3RD_SClkControl_ENABLE			(1<<0)
 	#define PM3RD_SClkControl_NOT_LOCKED			(0<<1)
 	#define PM3RD_SClkControl_LOCKED			(1<<1)
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

git-hwmon.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
tdfxfb-coding-style-improvement.patch
tridentfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
