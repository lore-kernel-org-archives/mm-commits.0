From: akpm@linux-foundation.org
Subject: + cirrusfb-fix-interlaced-modes.patch added to -mm tree
Date: Mon, 30 Mar 2009 15:42:34 -0700
Message-ID: <200903302242.n2UMgY8g011194@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757232AbZC3Won (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 18:44:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     cirrusfb: fix interlaced modes
has been added to the -mm tree.  Its filename is
     cirrusfb-fix-interlaced-modes.patch

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
Subject: cirrusfb: fix interlaced modes
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Fix calculations of timings for interlaced modes.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |   35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-fix-interlaced-modes drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-fix-interlaced-modes
+++ a/drivers/video/cirrusfb.c
@@ -701,45 +701,52 @@ static int cirrusfb_set_par_foo(struct f
 
 	hsyncstart = var->xres + var->right_margin;
 	hsyncend = hsyncstart + var->hsync_len;
-	htotal = (hsyncend + var->left_margin) / 8 - 5;
-	hdispend = var->xres / 8 - 1;
-	hsyncstart = hsyncstart / 8 + 1;
-	hsyncend = hsyncend / 8 + 1;
+	htotal = (hsyncend + var->left_margin) / 8;
+	hdispend = var->xres / 8;
+	hsyncstart = hsyncstart / 8;
+	hsyncend = hsyncend / 8;
 
-	yres = var->yres;
-	vsyncstart = yres + var->lower_margin;
+	vdispend = var->yres;
+	vsyncstart = vdispend + var->lower_margin;
 	vsyncend = vsyncstart + var->vsync_len;
 	vtotal = vsyncend + var->upper_margin;
-	vdispend = yres - 1;
 
 	if (var->vmode & FB_VMODE_DOUBLE) {
-		yres *= 2;
+		vdispend *= 2;
 		vsyncstart *= 2;
 		vsyncend *= 2;
 		vtotal *= 2;
 	} else if (var->vmode & FB_VMODE_INTERLACED) {
-		yres = (yres + 1) / 2;
+		vdispend = (vdispend + 1) / 2;
 		vsyncstart = (vsyncstart + 1) / 2;
 		vsyncend = (vsyncend + 1) / 2;
 		vtotal = (vtotal + 1) / 2;
 	}
-
-	vtotal -= 2;
-	vsyncstart -= 1;
-	vsyncend -= 1;
-
+	yres = vdispend;
 	if (yres >= 1024) {
 		vtotal /= 2;
 		vsyncstart /= 2;
 		vsyncend /= 2;
 		vdispend /= 2;
 	}
+
+	vdispend -= 1;
+	vsyncstart -= 1;
+	vsyncend -= 1;
+	vtotal -= 2;
+
 	if (cinfo->multiplexing) {
 		htotal /= 2;
 		hsyncstart /= 2;
 		hsyncend /= 2;
 		hdispend /= 2;
 	}
+
+	htotal -= 5;
+	hdispend -= 1;
+	hsyncstart += 1;
+	hsyncend += 1;
+
 	/* unlock register VGA_CRTC_H_TOTAL..CRT7 */
 	vga_wcrt(regbase, VGA_CRTC_V_SYNC_END, 0x20);	/* previously: 0x00) */
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix3.patch
cirrusfb-fix-laguna-chipset-memory-detection-and-clock-setting.patch
cirrusfb-add-laguna-additional-overflow-register.patch
cirrusfb-add-mmio-registers-for-laguna-chipsets.patch
cirrusfb-do-not-calculate-line-length-twice.patch
cirrusfb-use-5-6-5-rgb-for-16bpp-mode.patch
cirrusfb-various-improvements.patch
cirrusfb-laguna-chipset-8bpp-fix.patch
cirrusfb-check_var-improvements.patch
cirrusfb-various-laguna-fixes.patch
cirrusfb-acceleration-improvements.patch
cirrusfb-add-imageblit-function.patch
cirrusfb-fix-error-paths-in-cirrusfb_xxx_register.patch
cirrusfb-fix-error-paths-in-cirrusfb_xxx_register-fix.patch
cirrusfb-gd5446-fixes.patch
cirrusfb-use-24bpp-instead-of-32bpp.patch
cirrusfb-fix-clock-doubling.patch
cirrusfb-fix-clock-doubling-fix.patch
cirrusfb-add-accelerator-constant.patch
cirrusfb-add-accelerator-constantpatch-compilation-fix.patch
cirrusfb-set-mclk-in-one-place.patch
cirrusfb-set-mclk-in-one-place-fix.patch
cirrusfb-gd5434-aka-sd64-support-fixed.patch
cirrusfb-fix-threshold-register-mask-for-laguna-chips.patch
cirrusfb-fix-interlaced-modes.patch
drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path.patch
tdfxfb-fix-memory-leaks-in-removal-path.patch
tridentfb-fix-memory-leaks-in-removal-path.patch
vfb-fix-memory-leaks-in-removal-path.patch
sstfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
stifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
valkyriefb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
68328fb-fix-cmap-memory-leaks.patch
amba-clcd-fix-cmap-memory-leaks.patch
amifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
asiliantfb-fix-cmap-memory-leaks.patch
asiliantfb-fix-cmap-memory-leaks-fix.patch
remove-cyblafb-driver.patch
nvidiafb-remove-open_lock-mutex.patch
fb-hide-hardware-cursor-in-graphics-mode-mach64.patch
atyfb-speed-up-mach64-cursor.patch
tridentfb-delete-acceleration-kconfig-option.patch

