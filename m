From: akpm@linux-foundation.org
Subject: + neofb-drop-redundant-code.patch added to -mm tree
Date: Wed, 02 Jul 2008 10:53:31 -0700
Message-ID: <200807021753.m62HrVUL028641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016AbYGBRyD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 13:54:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     neofb: drop redundant code
has been added to the -mm tree.  Its filename is
     neofb-drop-redundant-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: neofb: drop redundant code
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Drop structure which is only set but never read.  Drop variables which are
only set and never read.  Convert one long switch into two shorter ones.

Add cpu_relax() in busy waiting loop.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/neofb.c |   95 +++++++++-------------------------------
 1 file changed, 22 insertions(+), 73 deletions(-)

diff -puN drivers/video/neofb.c~neofb-drop-redundant-code drivers/video/neofb.c
--- a/drivers/video/neofb.c~neofb-drop-redundant-code
+++ a/drivers/video/neofb.c
@@ -479,7 +479,8 @@ static inline int neo2200_sync(struct fb
 {
 	struct neofb_par *par = info->par;
 
-	while (readl(&par->neo2200->bltStat) & 1);
+	while (readl(&par->neo2200->bltStat) & 1)
+		cpu_relax();
 	return 0;
 }
 
@@ -587,34 +588,14 @@ static int
 neofb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
 	struct neofb_par *par = info->par;
-	unsigned int pixclock = var->pixclock;
-	struct xtimings timings;
 	int memlen, vramlen;
 	int mode_ok = 0;
 
 	DBG("neofb_check_var");
 
-	if (!pixclock)
-		pixclock = 10000;	/* 10ns = 100MHz */
-	timings.pixclock = 1000000000 / pixclock;
-	if (timings.pixclock < 1)
-		timings.pixclock = 1;
-
-	if (timings.pixclock > par->maxClock)
+	if (PICOS2KHZ(var->pixclock) > par->maxClock)
 		return -EINVAL;
 
-	timings.dblscan = var->vmode & FB_VMODE_DOUBLE;
-	timings.interlaced = var->vmode & FB_VMODE_INTERLACED;
-	timings.HDisplay = var->xres;
-	timings.HSyncStart = timings.HDisplay + var->right_margin;
-	timings.HSyncEnd = timings.HSyncStart + var->hsync_len;
-	timings.HTotal = timings.HSyncEnd + var->left_margin;
-	timings.VDisplay = var->yres;
-	timings.VSyncStart = timings.VDisplay + var->lower_margin;
-	timings.VSyncEnd = timings.VSyncStart + var->vsync_len;
-	timings.VTotal = timings.VSyncEnd + var->upper_margin;
-	timings.sync = var->sync;
-
 	/* Is the mode larger than the LCD panel? */
 	if (par->internal_display &&
             ((var->xres > par->NeoPanelWidth) ||
@@ -1923,9 +1904,6 @@ static int __devinit neo_init_hw(struct 
 	int maxClock = 65000;
 	int CursorMem = 1024;
 	int CursorOff = 0x100;
-	int linearSize = 1024;
-	int maxWidth = 1024;
-	int maxHeight = 1024;
 
 	DBG("neo_init_hw");
 
@@ -1944,81 +1922,52 @@ static int __devinit neo_init_hw(struct 
 	case FB_ACCEL_NEOMAGIC_NM2070:
 		videoRam = 896;
 		maxClock = 65000;
-		CursorMem = 2048;
-		CursorOff = 0x100;
-		linearSize = 1024;
-		maxWidth = 1024;
-		maxHeight = 1024;
 		break;
 	case FB_ACCEL_NEOMAGIC_NM2090:
 	case FB_ACCEL_NEOMAGIC_NM2093:
-		videoRam = 1152;
-		maxClock = 80000;
-		CursorMem = 2048;
-		CursorOff = 0x100;
-		linearSize = 2048;
-		maxWidth = 1024;
-		maxHeight = 1024;
-		break;
 	case FB_ACCEL_NEOMAGIC_NM2097:
 		videoRam = 1152;
 		maxClock = 80000;
-		CursorMem = 1024;
-		CursorOff = 0x100;
-		linearSize = 2048;
-		maxWidth = 1024;
-		maxHeight = 1024;
 		break;
 	case FB_ACCEL_NEOMAGIC_NM2160:
 		videoRam = 2048;
 		maxClock = 90000;
-		CursorMem = 1024;
-		CursorOff = 0x100;
-		linearSize = 2048;
-		maxWidth = 1024;
-		maxHeight = 1024;
 		break;
 	case FB_ACCEL_NEOMAGIC_NM2200:
 		videoRam = 2560;
 		maxClock = 110000;
-		CursorMem = 1024;
-		CursorOff = 0x1000;
-		linearSize = 4096;
-		maxWidth = 1280;
-		maxHeight = 1024;	/* ???? */
-
-		par->neo2200 = (Neo2200 __iomem *) par->mmio_vbase;
 		break;
 	case FB_ACCEL_NEOMAGIC_NM2230:
 		videoRam = 3008;
 		maxClock = 110000;
-		CursorMem = 1024;
-		CursorOff = 0x1000;
-		linearSize = 4096;
-		maxWidth = 1280;
-		maxHeight = 1024;	/* ???? */
-
-		par->neo2200 = (Neo2200 __iomem *) par->mmio_vbase;
 		break;
 	case FB_ACCEL_NEOMAGIC_NM2360:
 		videoRam = 4096;
 		maxClock = 110000;
-		CursorMem = 1024;
-		CursorOff = 0x1000;
-		linearSize = 4096;
-		maxWidth = 1280;
-		maxHeight = 1024;	/* ???? */
-
-		par->neo2200 = (Neo2200 __iomem *) par->mmio_vbase;
 		break;
 	case FB_ACCEL_NEOMAGIC_NM2380:
 		videoRam = 6144;
 		maxClock = 110000;
+		break;
+	}
+	switch (info->fix.accel) {
+	case FB_ACCEL_NEOMAGIC_NM2070:
+	case FB_ACCEL_NEOMAGIC_NM2090:
+	case FB_ACCEL_NEOMAGIC_NM2093:
+		CursorMem = 2048;
+		CursorOff = 0x100;
+		break;
+	case FB_ACCEL_NEOMAGIC_NM2097:
+	case FB_ACCEL_NEOMAGIC_NM2160:
+		CursorMem = 1024;
+		CursorOff = 0x100;
+		break;
+	case FB_ACCEL_NEOMAGIC_NM2200:
+	case FB_ACCEL_NEOMAGIC_NM2230:
+	case FB_ACCEL_NEOMAGIC_NM2360:
+	case FB_ACCEL_NEOMAGIC_NM2380:
 		CursorMem = 1024;
 		CursorOff = 0x1000;
-		linearSize = 8192;
-		maxWidth = 1280;
-		maxHeight = 1024;	/* ???? */
 
 		par->neo2200 = (Neo2200 __iomem *) par->mmio_vbase;
 		break;
@@ -2032,7 +1981,7 @@ static int __devinit neo_init_hw(struct 
 */
 	par->maxClock = maxClock;
 	par->cursorOff = CursorOff;
-	return ((videoRam * 1024));
+	return videoRam * 1024;
 }
 
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

linux-next.patch
tridentfb-replace-macros-with-functions.patch
tridentfb-convert-fb_info-into-allocated-one.patch
tridentfb-move-global-pseudo-palette-into-structure.patch
tridentfb-move-global-chip_id-into-structure.patch
tridentfb-move-global-flat-panel-variable-into-structure.patch
tridentfb-convert-is_blade-and-is_xp-macros-into-functions.patch
tridentfb-move-global-acceleration-hooks-into-structure.patch
tridentfb-make-use-of-functions-and-constants-from-the-vgah.patch
tridentfb-fix-timing-calculations.patch
tridentfb-use-mmio-access-for-clock-setting.patch
tridentfb-fix-clock-settings-for-older-trident-96xx-chips.patch
tridentfb-improve-probe-function.patch
tridentfb-improved-register-values-on-tgui-9680.patch
tridentfb-add-tgui-9440-support.patch
tridentfb-fix-unitialized-pseudo_palette.patch
tridentfb-improve-check_var-function.patch
tridentfb-preserve-memory-type-settings.patch
tridentfb-fix-hi-color-modes-for-tgui-9440.patch
tridentfb-add-acceleration-for-tgui-families.patch
tridentfb-acceleration-code-improvements.patch
tridentfb-acceleration-bug-fixes.patch
tridentfb-various-pixclock-and-timing-improvements.patch
tridentfb-acceleration-constants-change.patch
tridentfb-source-code-improvements.patch
tridentfb-fix-console-freeze-when-switching-from-x11.patch
tridentfb-fix-224-color-logo-at-8-bpp.patch
tridentfb-y-panning-fixes.patch
tridentfb-blade3d-clock-fixes.patch
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
fbcon-make-logo_height-a-local-variable.patch
uvesafb-change-mode-parameter-to-mode_option.patch
tridentfb-documentation-update.patch
tdfxfb-add-mode_option-module-parameter.patch
vga16fb-source-code-improvement.patch
tdfxfb-remove-ypan-checks-done-by-a-higher-layer.patch
vfb-only-enable-if-explicitly-requested-when-compiled-in.patch
hgafb-convert-to-new-platform-driver-api-bugzilla-9689.patch
skeletonfb-update-to-correct-platform-driver-usage.patch
neofb-simplify-clock-calculation.patch
neofb-drop-redundant-code.patch

