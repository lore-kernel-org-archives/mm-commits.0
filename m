From: akpm@linux-foundation.org
Subject: - tridentfb-improve-clock-setting-accuracy.patch removed from -mm tree
Date: Tue, 13 May 2008 14:33:21 -0700
Message-ID: <200805132133.m4DLXLU0000811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761626AbYEMVdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:33:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     tridentfb: improve clock setting accuracy
has been removed from the -mm tree.  Its filename was
     tridentfb-improve-clock-setting-accuracy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: improve clock setting accuracy
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Improve clock calculation precision (to kHz from MHz) and removes parameter
field vclk from the tridentfb_par structure.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-improve-clock-setting-accuracy drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-improve-clock-setting-accuracy
+++ a/drivers/video/tridentfb.c
@@ -27,7 +27,6 @@
 #define VERSION		"0.7.8-NEWAPI"
 
 struct tridentfb_par {
-	int vclk;		/* in MHz */
 	void __iomem *io_virt;	/* iospace virtual memory address */
 };
 
@@ -669,27 +668,26 @@ static void set_screen_start(int base)
 		 (read3X4(CRTHiOrd) & 0xF8) | ((base & 0xE0000) >> 17));
 }
 
-/* Use 20.12 fixed-point for NTSC value and frequency calculation */
-#define calc_freq(n, m, k)  ( ((unsigned long)0xE517 * (n + 8) / ((m + 2) * (1 << k))) >> 12 )
-
 /* Set dotclock frequency */
-static void set_vclk(int freq)
+static void set_vclk(unsigned long freq)
 {
 	int m, n, k;
-	int f, fi, d, di;
+	unsigned long f, fi, d, di;
 	unsigned char lo = 0, hi = 0;
 
-	d = 20;
+	d = 20000;
 	for (k = 2; k >= 0; k--)
 		for (m = 0; m < 63; m++)
 			for (n = 0; n < 128; n++) {
-				fi = calc_freq(n, m, k);
+				fi = ((14318l * (n + 8)) / (m + 2)) >> k;
 				if ((di = abs(fi - freq)) < d) {
 					d = di;
 					f = fi;
 					lo = n;
 					hi = (k << 6) | m;
 				}
+				if (fi > freq)
+					break;
 			}
 	if (chip3D) {
 		write3C4(ClockHigh, hi);
@@ -888,6 +886,8 @@ static int tridentfb_set_par(struct fb_i
 	struct fb_var_screeninfo *var = &info->var;
 	int bpp = var->bits_per_pixel;
 	unsigned char tmp;
+	unsigned long vclk;
+
 	debug("enter\n");
 	hdispend = var->xres / 8 - 1;
 	hsyncstart = (var->xres + var->right_margin) / 8;
@@ -1014,11 +1014,11 @@ static int tridentfb_set_par(struct fb_i
 	write3X4(Performance, 0x92);
 	write3X4(PCIReg, 0x07);		/* MMIO & PCI read and write burst enable */
 
-	/* convert from picoseconds to MHz */
-	par->vclk = 1000000 / info->var.pixclock;
+	/* convert from picoseconds to kHz */
+	vclk = PICOS2KHZ(info->var.pixclock);
 	if (bpp == 32)
-		par->vclk *= 2;
-	set_vclk(par->vclk);
+		vclk *= 2;
+	set_vclk(vclk);
 
 	write3C4(0, 3);
 	write3C4(1, 1);		/* set char clock 8 dots wide */
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
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
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch

