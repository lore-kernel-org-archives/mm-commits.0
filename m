From: akpm@linux-foundation.org
Subject: + neofb-drop-the-xtimings-structure.patch added to -mm tree
Date: Sat, 05 Jul 2008 12:33:12 -0700
Message-ID: <200807051933.m65JXCAp003083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752394AbYGETdP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 5 Jul 2008 15:33:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     neofb: drop the xtimings structure
has been added to the -mm tree.  Its filename is
     neofb-drop-the-xtimings-structure.patch

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
Subject: neofb: drop the xtimings structure
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Remove the xtimings structure which only stored some values to be used
later (mostly once).  Calculate and use these values in places they are
needed.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/neofb.c    |   88 ++++++++++++++++---------------------
 include/video/neomagic.h |   17 -------
 2 files changed, 40 insertions(+), 65 deletions(-)

diff -puN drivers/video/neofb.c~neofb-drop-the-xtimings-structure drivers/video/neofb.c
--- a/drivers/video/neofb.c~neofb-drop-the-xtimings-structure
+++ a/drivers/video/neofb.c
@@ -259,15 +259,20 @@ static void neoCalcVCLK(const struct fb_
  */
 
 static int vgaHWInit(const struct fb_var_screeninfo *var,
-		     const struct fb_info *info,
-		     struct neofb_par *par, struct xtimings *timings)
+		     struct neofb_par *par)
 {
+	int hsync_end = var->xres + var->right_margin + var->hsync_len;
+	int htotal = (hsync_end + var->left_margin) >> 3;
+	int vsync_start = var->yres + var->lower_margin;
+	int vsync_end = vsync_start + var->vsync_len;
+	int vtotal = vsync_end + var->upper_margin;
+
 	par->MiscOutReg = 0x23;
 
-	if (!(timings->sync & FB_SYNC_HOR_HIGH_ACT))
+	if (!(var->sync & FB_SYNC_HOR_HIGH_ACT))
 		par->MiscOutReg |= 0x40;
 
-	if (!(timings->sync & FB_SYNC_VERT_HIGH_ACT))
+	if (!(var->sync & FB_SYNC_VERT_HIGH_ACT))
 		par->MiscOutReg |= 0x80;
 
 	/*
@@ -282,25 +287,25 @@ static int vgaHWInit(const struct fb_var
 	/*
 	 * CRTC Controller
 	 */
-	par->CRTC[0] = (timings->HTotal >> 3) - 5;
-	par->CRTC[1] = (timings->HDisplay >> 3) - 1;
-	par->CRTC[2] = (timings->HDisplay >> 3) - 1;
-	par->CRTC[3] = (((timings->HTotal >> 3) - 1) & 0x1F) | 0x80;
-	par->CRTC[4] = (timings->HSyncStart >> 3);
-	par->CRTC[5] = ((((timings->HTotal >> 3) - 1) & 0x20) << 2)
-	    | (((timings->HSyncEnd >> 3)) & 0x1F);
-	par->CRTC[6] = (timings->VTotal - 2) & 0xFF;
-	par->CRTC[7] = (((timings->VTotal - 2) & 0x100) >> 8)
-	    | (((timings->VDisplay - 1) & 0x100) >> 7)
-	    | ((timings->VSyncStart & 0x100) >> 6)
-	    | (((timings->VDisplay - 1) & 0x100) >> 5)
-	    | 0x10 | (((timings->VTotal - 2) & 0x200) >> 4)
-	    | (((timings->VDisplay - 1) & 0x200) >> 3)
-	    | ((timings->VSyncStart & 0x200) >> 2);
+	par->CRTC[0] = htotal - 5;
+	par->CRTC[1] = (var->xres >> 3) - 1;
+	par->CRTC[2] = (var->xres >> 3) - 1;
+	par->CRTC[3] = ((htotal - 1) & 0x1F) | 0x80;
+	par->CRTC[4] = ((var->xres + var->right_margin) >> 3);
+	par->CRTC[5] = (((htotal - 1) & 0x20) << 2)
+	    | (((hsync_end >> 3)) & 0x1F);
+	par->CRTC[6] = (vtotal - 2) & 0xFF;
+	par->CRTC[7] = (((vtotal - 2) & 0x100) >> 8)
+	    | (((var->yres - 1) & 0x100) >> 7)
+	    | ((vsync_start & 0x100) >> 6)
+	    | (((var->yres - 1) & 0x100) >> 5)
+	    | 0x10 | (((vtotal - 2) & 0x200) >> 4)
+	    | (((var->yres - 1) & 0x200) >> 3)
+	    | ((vsync_start & 0x200) >> 2);
 	par->CRTC[8] = 0x00;
-	par->CRTC[9] = (((timings->VDisplay - 1) & 0x200) >> 4) | 0x40;
+	par->CRTC[9] = (((var->yres - 1) & 0x200) >> 4) | 0x40;
 
-	if (timings->dblscan)
+	if (var->vmode & FB_VMODE_DOUBLE)
 		par->CRTC[9] |= 0x80;
 
 	par->CRTC[10] = 0x00;
@@ -309,13 +314,13 @@ static int vgaHWInit(const struct fb_var
 	par->CRTC[13] = 0x00;
 	par->CRTC[14] = 0x00;
 	par->CRTC[15] = 0x00;
-	par->CRTC[16] = timings->VSyncStart & 0xFF;
-	par->CRTC[17] = (timings->VSyncEnd & 0x0F) | 0x20;
-	par->CRTC[18] = (timings->VDisplay - 1) & 0xFF;
+	par->CRTC[16] = vsync_start & 0xFF;
+	par->CRTC[17] = (vsync_end & 0x0F) | 0x20;
+	par->CRTC[18] = (var->yres - 1) & 0xFF;
 	par->CRTC[19] = var->xres_virtual >> 4;
 	par->CRTC[20] = 0x00;
-	par->CRTC[21] = (timings->VDisplay - 1) & 0xFF;
-	par->CRTC[22] = (timings->VTotal - 1) & 0xFF;
+	par->CRTC[21] = (var->yres - 1) & 0xFF;
+	par->CRTC[22] = (vtotal - 1) & 0xFF;
 	par->CRTC[23] = 0xC3;
 	par->CRTC[24] = 0xFF;
 
@@ -736,11 +741,11 @@ neofb_check_var(struct fb_var_screeninfo
 static int neofb_set_par(struct fb_info *info)
 {
 	struct neofb_par *par = info->par;
-	struct xtimings timings;
 	unsigned char temp;
 	int i, clock_hi = 0;
 	int lcd_stretch;
 	int hoffset, voffset;
+	int vsync_start, vtotal;
 
 	DBG("neofb_set_par");
 
@@ -748,28 +753,15 @@ static int neofb_set_par(struct fb_info 
 
 	vgaHWProtect(1);	/* Blank the screen */
 
-	timings.dblscan = info->var.vmode & FB_VMODE_DOUBLE;
-	timings.interlaced = info->var.vmode & FB_VMODE_INTERLACED;
-	timings.HDisplay = info->var.xres;
-	timings.HSyncStart = timings.HDisplay + info->var.right_margin;
-	timings.HSyncEnd = timings.HSyncStart + info->var.hsync_len;
-	timings.HTotal = timings.HSyncEnd + info->var.left_margin;
-	timings.VDisplay = info->var.yres;
-	timings.VSyncStart = timings.VDisplay + info->var.lower_margin;
-	timings.VSyncEnd = timings.VSyncStart + info->var.vsync_len;
-	timings.VTotal = timings.VSyncEnd + info->var.upper_margin;
-	timings.sync = info->var.sync;
-	timings.pixclock = PICOS2KHZ(info->var.pixclock);
-
-	if (timings.pixclock < 1)
-		timings.pixclock = 1;
+	vsync_start = info->var.yres + info->var.lower_margin;
+	vtotal = vsync_start + info->var.vsync_len + info->var.upper_margin;
 
 	/*
 	 * This will allocate the datastructure and initialize all of the
 	 * generic VGA registers.
 	 */
 
-	if (vgaHWInit(&info->var, info, par, &timings))
+	if (vgaHWInit(&info->var, par))
 		return -EINVAL;
 
 	/*
@@ -808,10 +800,10 @@ static int neofb_set_par(struct fb_info 
 	par->ExtCRTDispAddr = 0x10;
 
 	/* Vertical Extension */
-	par->VerticalExt = (((timings.VTotal - 2) & 0x400) >> 10)
-	    | (((timings.VDisplay - 1) & 0x400) >> 9)
-	    | (((timings.VSyncStart) & 0x400) >> 8)
-	    | (((timings.VSyncStart) & 0x400) >> 7);
+	par->VerticalExt = (((vtotal - 2) & 0x400) >> 10)
+	    | (((info->var.yres - 1) & 0x400) >> 9)
+	    | (((vsync_start) & 0x400) >> 8)
+	    | (((vsync_start) & 0x400) >> 7);
 
 	/* Fast write bursts on unless disabled. */
 	if (par->pci_burst)
@@ -972,7 +964,7 @@ static int neofb_set_par(struct fb_info 
 	 * Calculate the VCLK that most closely matches the requested dot
 	 * clock.
 	 */
-	neoCalcVCLK(info, par, timings.pixclock);
+	neoCalcVCLK(info, par, PICOS2KHZ(info->var.pixclock));
 
 	/* Since we program the clocks ourselves, always use VCLK3. */
 	par->MiscOutReg |= 0x0C;
diff -puN include/video/neomagic.h~neofb-drop-the-xtimings-structure include/video/neomagic.h
--- a/include/video/neomagic.h~neofb-drop-the-xtimings-structure
+++ a/include/video/neomagic.h
@@ -90,23 +90,6 @@
 #define PCI_CHIP_NM2360 0x0006
 #define PCI_CHIP_NM2380 0x0016
 
-
-struct xtimings {
-	unsigned int pixclock;
-	unsigned int HDisplay;
-	unsigned int HSyncStart;
-	unsigned int HSyncEnd;
-	unsigned int HTotal;
-	unsigned int VDisplay;
-	unsigned int VSyncStart;
-	unsigned int VSyncEnd;
-	unsigned int VTotal;
-	unsigned int sync;
-	int dblscan;
-	int interlaced;
-};
-
-
 /* --------------------------------------------------------------------- */
 
 typedef volatile struct {
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
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
tridentfb-add-imageblit-acceleration-for-blade3d-family.patch
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
neofb-drop-the-xtimings-structure.patch

