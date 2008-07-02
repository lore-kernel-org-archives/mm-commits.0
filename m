From: akpm@linux-foundation.org
Subject: + neofb-simplify-clock-calculation.patch added to -mm tree
Date: Tue, 01 Jul 2008 20:17:54 -0700
Message-ID: <200807020317.m623Hsgo028766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762552AbYGBDR4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 23:17:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     neofb: simplify clock calculation
has been added to the -mm tree.  Its filename is
     neofb-simplify-clock-calculation.patch

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
Subject: neofb: simplify clock calculation
From: Krzysztof Helt <krzysztof.h1@wp.pl>

There is nothing to gain by converting value in kHz to fixed point MHz. 
Just calculate everything in kHz.

A reorder of the loop allows reducing number of iterations (check if
frequency is not too high already).

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/neofb.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff -puN drivers/video/neofb.c~neofb-simplify-clock-calculation drivers/video/neofb.c
--- a/drivers/video/neofb.c~neofb-simplify-clock-calculation
+++ a/drivers/video/neofb.c
@@ -201,7 +201,6 @@ static int neoFindMode(int xres, int yre
  *
  * Determine the closest clock frequency to the one requested.
  */
-#define REF_FREQ 0xe517		/* 14.31818 in 20.12 fixed point */
 #define MAX_N 127
 #define MAX_D 31
 #define MAX_F 1
@@ -211,27 +210,24 @@ static void neoCalcVCLK(const struct fb_
 {
 	int n, d, f;
 	int n_best = 0, d_best = 0, f_best = 0;
-	long f_best_diff = (0x7ffff << 12);	/* 20.12 */
-	long f_target = (freq << 12) / 1000;	/* 20.12 */
+	long f_best_diff = 0x7ffff;
 
 	for (f = 0; f <= MAX_F; f++)
-		for (n = 0; n <= MAX_N; n++)
-			for (d = 0; d <= MAX_D; d++) {
-				long f_out;	/* 20.12 */
-				long f_diff;	/* 20.12 */
-
-				f_out =
-				    ((((n + 1) << 12) / ((d +
-							  1) *
-							 (1 << f))) >> 12)
-				    * REF_FREQ;
-				f_diff = abs(f_out - f_target);
-				if (f_diff < f_best_diff) {
+		for (d = 0; d <= MAX_D; d++)
+			for (n = 0; n <= MAX_N; n++) {
+				long f_out;
+				long f_diff;
+
+				f_out = ((14318 * (n + 1)) / (d + 1)) >> f;
+				f_diff = abs(f_out - freq);
+				if (f_diff <= f_best_diff) {
 					f_best_diff = f_diff;
 					n_best = n;
 					d_best = d;
 					f_best = f;
 				}
+				if (f_out > freq)
+					break;
 			}
 
 	if (info->fix.accel == FB_ACCEL_NEOMAGIC_NM2200 ||
@@ -248,11 +244,11 @@ static void neoCalcVCLK(const struct fb_
 	par->VCLK3Denominator = d_best;
 
 #ifdef NEOFB_DEBUG
-	printk("neoVCLK: f:%d NumLow=%d NumHi=%d Den=%d Df=%d\n",
-	       f_target >> 12,
+	printk(KERN_DEBUG "neoVCLK: f:%ld NumLow=%d NumHi=%d Den=%d Df=%ld\n",
+	       freq,
 	       par->VCLK3NumeratorLow,
 	       par->VCLK3NumeratorHigh,
-	       par->VCLK3Denominator, f_best_diff >> 12);
+	       par->VCLK3Denominator, f_best_diff);
 #endif
 }
 
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

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

