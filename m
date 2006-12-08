From: akpm@osdl.org
Subject: - atyfb-remove-aty_cmap_regs.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:14:08 -0800
Message-ID: <200612082014.kB8KE8qS003138@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59674 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946806AbWLHUOM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: syrjala@sci.fi, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     atyfb: Remove aty_cmap_regs
has been removed from the -mm tree.  Its filename was
     atyfb-remove-aty_cmap_regs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atyfb: Remove aty_cmap_regs
From: Ville Syrjala <syrjala@sci.fi>

Remove aty_cmap_regs. Access the LUT in the same way as other registers.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/aty/atyfb.h      |    1 
 drivers/video/aty/atyfb_base.c |   45 ++++++++-----------------------
 2 files changed, 12 insertions(+), 34 deletions(-)

diff -puN drivers/video/aty/atyfb.h~atyfb-remove-aty_cmap_regs drivers/video/aty/atyfb.h
--- a/drivers/video/aty/atyfb.h~atyfb-remove-aty_cmap_regs
+++ a/drivers/video/aty/atyfb.h
@@ -126,7 +126,6 @@ union aty_pll {
      */
 
 struct atyfb_par {
-	struct aty_cmap_regs __iomem *aty_cmap_regs;
 	struct { u8 red, green, blue; } palette[256];
 	const struct aty_dac_ops *dac_ops;
 	const struct aty_pll_ops *pll_ops;
diff -puN drivers/video/aty/atyfb_base.c~atyfb-remove-aty_cmap_regs drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-remove-aty_cmap_regs
+++ a/drivers/video/aty/atyfb_base.c
@@ -203,14 +203,6 @@ static void ATIReduceRatio(int *Numerato
      *  The Hardware parameters for each card
      */
 
-struct aty_cmap_regs {
-	u8 windex;
-	u8 lut;
-	u8 mask;
-	u8 rindex;
-	u8 cntl;
-};
-
 struct pci_mmap_map {
 	unsigned long voff;
 	unsigned long poff;
@@ -1937,17 +1929,14 @@ static void atyfb_save_palette(struct at
 		aty_st_8(DAC_CNTL, tmp, par);
 		aty_st_8(DAC_MASK, 0xff, par);
 
-		writeb(i, &par->aty_cmap_regs->rindex);
-		atyfb_save.r[enter][i] = readb(&par->aty_cmap_regs->lut);
-		atyfb_save.g[enter][i] = readb(&par->aty_cmap_regs->lut);
-		atyfb_save.b[enter][i] = readb(&par->aty_cmap_regs->lut);
-		writeb(i, &par->aty_cmap_regs->windex);
-		writeb(atyfb_save.r[1 - enter][i],
-		       &par->aty_cmap_regs->lut);
-		writeb(atyfb_save.g[1 - enter][i],
-		       &par->aty_cmap_regs->lut);
-		writeb(atyfb_save.b[1 - enter][i],
-		       &par->aty_cmap_regs->lut);
+		aty_st_8(DAC_R_INDEX, i, par);
+		atyfb_save.r[enter][i] = aty_ld_8(DAC_DATA, par);
+		atyfb_save.g[enter][i] = aty_ld_8(DAC_DATA, par);
+		atyfb_save.b[enter][i] = aty_ld_8(DAC_DATA, par);
+		aty_st_8(DAC_W_INDEX, i, par);
+		aty_st_8(DAC_DATA, atyfb_save.r[1 - enter][i], par);
+		aty_st_8(DAC_DATA, atyfb_save.g[1 - enter][i], par);
+		aty_st_8(DAC_DATA, atyfb_save.b[1 - enter][i], par);
 	}
 }
 
@@ -2355,9 +2344,6 @@ static int __devinit aty_init(struct fb_
 	init_waitqueue_head(&par->vblank.wait);
 	spin_lock_init(&par->int_lock);
 
-	par->aty_cmap_regs =
-	    (struct aty_cmap_regs __iomem *) (par->ati_regbase + 0xc0);
-
 #ifdef CONFIG_PPC_PMAC
 	/* The Apple iBook1 uses non-standard memory frequencies. We detect it
 	 * and set the frequency manually. */
@@ -2862,17 +2848,10 @@ static int atyfb_blank(int blank, struct
 static void aty_st_pal(u_int regno, u_int red, u_int green, u_int blue,
 		       const struct atyfb_par *par)
 {
-#ifdef CONFIG_ATARI
-	out_8(&par->aty_cmap_regs->windex, regno);
-	out_8(&par->aty_cmap_regs->lut, red);
-	out_8(&par->aty_cmap_regs->lut, green);
-	out_8(&par->aty_cmap_regs->lut, blue);
-#else
-	writeb(regno, &par->aty_cmap_regs->windex);
-	writeb(red, &par->aty_cmap_regs->lut);
-	writeb(green, &par->aty_cmap_regs->lut);
-	writeb(blue, &par->aty_cmap_regs->lut);
-#endif
+	aty_st_8(DAC_W_INDEX, regno, par);
+	aty_st_8(DAC_DATA, red, par);
+	aty_st_8(DAC_DATA, green, par);
+	aty_st_8(DAC_DATA, blue, par);
 }
 
     /*
_

Patches currently in -mm which might be from syrjala@sci.fi are

atyfb-remove-aty_cmap_regs.patch
atyfb-improve-atyfb_atari_probe.patch
atyfb-improve-power-management.patch

