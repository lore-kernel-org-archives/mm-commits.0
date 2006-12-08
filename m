From: akpm@osdl.org
Subject: - atyfb-fix-compiler-warnings.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:13:56 -0800
Message-ID: <200612082013.kB8KDu88003123@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59640 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946750AbWLHUOB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: syrjala@sci.fi, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     atyfb: Fix compiler warnings
has been removed from the -mm tree.  Its filename was
     atyfb-fix-compiler-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atyfb: Fix compiler warnings
From: Ville Syrjala <syrjala@sci.fi>

Fix some compiler warnings and remove an #ifdef.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/aty/atyfb_base.c |   35 +++++++++++++++----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff -puN drivers/video/aty/atyfb_base.c~atyfb-fix-compiler-warnings drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-fix-compiler-warnings
+++ a/drivers/video/aty/atyfb_base.c
@@ -2350,11 +2350,7 @@ static int __devinit aty_init(struct fb_
 	const char *ramname = NULL, *xtal;
 	int gtb_memsize, has_var = 0;
 	struct fb_var_screeninfo var;
-	u8 pll_ref_div;
 	u32 i;
-#if defined(CONFIG_PPC)
-	int sense;
-#endif
 
 	init_waitqueue_head(&par->vblank.wait);
 	spin_lock_init(&par->int_lock);
@@ -2464,18 +2460,21 @@ static int __devinit aty_init(struct fb_
 			par->pll_limits.mclk = 63;
 	}
 
-	if (M64_HAS(GTB_DSP)
-	    && (pll_ref_div = aty_ld_pll_ct(PLL_REF_DIV, par))) {
-		int diff1, diff2;
-		diff1 = 510 * 14 / pll_ref_div - par->pll_limits.pll_max;
-		diff2 = 510 * 29 / pll_ref_div - par->pll_limits.pll_max;
-		if (diff1 < 0)
-			diff1 = -diff1;
-		if (diff2 < 0)
-			diff2 = -diff2;
-		if (diff2 < diff1) {
-			par->ref_clk_per = 1000000000000ULL / 29498928;
-			xtal = "29.498928";
+	if (M64_HAS(GTB_DSP)) {
+		u8 pll_ref_div = aty_ld_pll_ct(PLL_REF_DIV, par);
+
+		if (pll_ref_div) {
+			int diff1, diff2;
+			diff1 = 510 * 14 / pll_ref_div - par->pll_limits.pll_max;
+			diff2 = 510 * 29 / pll_ref_div - par->pll_limits.pll_max;
+			if (diff1 < 0)
+				diff1 = -diff1;
+			if (diff2 < 0)
+				diff2 = -diff2;
+			if (diff2 < diff1) {
+				par->ref_clk_per = 1000000000000ULL / 29498928;
+				xtal = "29.498928";
+			}
 		}
 	}
 #endif /* CONFIG_FB_ATY_CT */
@@ -2668,6 +2667,7 @@ static int __devinit aty_init(struct fb_
 				has_var = 1;
 		} else {
 			if (default_vmode == VMODE_CHOOSE) {
+				int sense;
 				if (M64_HAS(G3_PB_1024x768))
 					/* G3 PowerBook with 1024x768 LCD */
 					default_vmode = VMODE_1024_768_60;
@@ -3711,6 +3711,8 @@ static int __devinit atyfb_atari_probe(v
 
 #endif /* CONFIG_ATARI */
 
+#ifdef CONFIG_PCI
+
 static void __devexit atyfb_remove(struct fb_info *info)
 {
 	struct atyfb_par *par = (struct atyfb_par *) info->par;
@@ -3758,7 +3760,6 @@ static void __devexit atyfb_remove(struc
 	framebuffer_release(info);
 }
 
-#ifdef CONFIG_PCI
 
 static void __devexit atyfb_pci_remove(struct pci_dev *pdev)
 {
_

Patches currently in -mm which might be from syrjala@sci.fi are

atyfb-fix-compiler-warnings.patch
atyfb-fix-sparse-warnings.patch
atyfb-fix-blanking-level.patch
atyfb-remove-pointless-aty_init.patch
atyfb-fix-__init-and-__devinit.patch
atyfb-remove-aty_cmap_regs.patch
atyfb-improve-atyfb_atari_probe.patch
atyfb-improve-power-management.patch

