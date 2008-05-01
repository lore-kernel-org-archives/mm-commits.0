From: akpm@linux-foundation.org
Subject: - pxafb-move-parallel-lcd-timing-setup-into-dedicate-function.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:20 -0700
Message-ID: <200805010925.m419PKHW030193@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755339AbYEAJZ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:25:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.miao@marvell.com, adaplas@pol.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     pxafb: move parallel LCD timing setup into dedicate function
has been removed from the -mm tree.  Its filename was
     pxafb-move-parallel-lcd-timing-setup-into-dedicate-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pxafb: move parallel LCD timing setup into dedicate function
From: Eric Miao <eric.miao@marvell.com>

the new_regs stuff has been removed, and all the setup (modification to those
fbi->reg_*) is protected with IRQ disabled

   * disable IRQ is too heavy here, provided that no IRQ context will
     touch the fbi->reg_* and the only possible contending place is
     in the CPUFREQ_POSTCHANGE (task context), a mutex will be better,
     leave this for future improvement

Signed-off-by: eric miao <eric.miao@marvell.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pxafb.c |   89 +++++++++++++++++++++-------------------
 drivers/video/pxafb.h |    8 ---
 2 files changed, 47 insertions(+), 50 deletions(-)

diff -puN drivers/video/pxafb.c~pxafb-move-parallel-lcd-timing-setup-into-dedicate-function drivers/video/pxafb.c
--- a/drivers/video/pxafb.c~pxafb-move-parallel-lcd-timing-setup-into-dedicate-function
+++ a/drivers/video/pxafb.c
@@ -594,6 +594,43 @@ static int setup_frame_dma(struct pxafb_
 	return 0;
 }
 
+static void setup_parallel_timing(struct pxafb_info *fbi,
+				  struct fb_var_screeninfo *var)
+{
+	unsigned int lines_per_panel, pcd = get_pcd(fbi, var->pixclock);
+
+	fbi->reg_lccr1 =
+		LCCR1_DisWdth(var->xres) +
+		LCCR1_HorSnchWdth(var->hsync_len) +
+		LCCR1_BegLnDel(var->left_margin) +
+		LCCR1_EndLnDel(var->right_margin);
+
+	/*
+	 * If we have a dual scan LCD, we need to halve
+	 * the YRES parameter.
+	 */
+	lines_per_panel = var->yres;
+	if ((fbi->lccr0 & LCCR0_SDS) == LCCR0_Dual)
+		lines_per_panel /= 2;
+
+	fbi->reg_lccr2 =
+		LCCR2_DisHght(lines_per_panel) +
+		LCCR2_VrtSnchWdth(var->vsync_len) +
+		LCCR2_BegFrmDel(var->upper_margin) +
+		LCCR2_EndFrmDel(var->lower_margin);
+
+	fbi->reg_lccr3 = fbi->lccr3 |
+		(var->sync & FB_SYNC_HOR_HIGH_ACT ?
+		 LCCR3_HorSnchH : LCCR3_HorSnchL) |
+		(var->sync & FB_SYNC_VERT_HIGH_ACT ?
+		 LCCR3_VrtSnchH : LCCR3_VrtSnchL);
+
+	if (pcd) {
+		fbi->reg_lccr3 |= LCCR3_PixClkDiv(pcd);
+		set_hsync_time(fbi, pcd);
+	}
+}
+
 /*
  * pxafb_activate_var():
  *	Configures LCD Controller based on entries in var parameter.
@@ -602,9 +639,7 @@ static int setup_frame_dma(struct pxafb_
 static int pxafb_activate_var(struct fb_var_screeninfo *var,
 			      struct pxafb_info *fbi)
 {
-	struct pxafb_lcd_reg new_regs;
 	u_long flags;
-	u_int lines_per_panel, pcd = get_pcd(fbi, var->pixclock);
 	size_t nbytes;
 
 #if DEBUG_VAR
@@ -645,61 +680,31 @@ static int pxafb_activate_var(struct fb_
 		printk(KERN_ERR "%s: invalid lower_margin %d\n",
 			fbi->fb.fix.id, var->lower_margin);
 #endif
+	/* Update shadow copy atomically */
+	local_irq_save(flags);
+
+	setup_parallel_timing(fbi, var);
 
-	new_regs.lccr0 = fbi->lccr0 |
+	fbi->reg_lccr0 = fbi->lccr0 |
 		(LCCR0_LDM | LCCR0_SFM | LCCR0_IUM | LCCR0_EFM |
 		 LCCR0_QDM | LCCR0_BM  | LCCR0_OUM);
 
-	new_regs.lccr1 =
-		LCCR1_DisWdth(var->xres) +
-		LCCR1_HorSnchWdth(var->hsync_len) +
-		LCCR1_BegLnDel(var->left_margin) +
-		LCCR1_EndLnDel(var->right_margin);
-
-	/*
-	 * If we have a dual scan LCD, we need to halve
-	 * the YRES parameter.
-	 */
-	lines_per_panel = var->yres;
-	if ((fbi->lccr0 & LCCR0_SDS) == LCCR0_Dual)
-		lines_per_panel /= 2;
-
-	new_regs.lccr2 =
-		LCCR2_DisHght(lines_per_panel) +
-		LCCR2_VrtSnchWdth(var->vsync_len) +
-		LCCR2_BegFrmDel(var->upper_margin) +
-		LCCR2_EndFrmDel(var->lower_margin);
+	fbi->reg_lccr3 |= pxafb_bpp_to_lccr3(var);
 
-	new_regs.lccr3 = fbi->lccr3 |
-		pxafb_bpp_to_lccr3(var) |
-		(var->sync & FB_SYNC_HOR_HIGH_ACT ?
-		 LCCR3_HorSnchH : LCCR3_HorSnchL) |
-		(var->sync & FB_SYNC_VERT_HIGH_ACT ?
-		 LCCR3_VrtSnchH : LCCR3_VrtSnchL);
+	nbytes = var->yres * fbi->fb.fix.line_length;
 
-	if (pcd)
-		new_regs.lccr3 |= LCCR3_PixClkDiv(pcd);
-
-	/* Update shadow copy atomically */
-	local_irq_save(flags);
-
-	nbytes = lines_per_panel * fbi->fb.fix.line_length;
-
-	if ((fbi->lccr0 & LCCR0_SDS) == LCCR0_Dual)
+	if ((fbi->lccr0 & LCCR0_SDS) == LCCR0_Dual) {
+		nbytes = nbytes / 2;
 		setup_frame_dma(fbi, DMA_LOWER, PAL_NONE, nbytes, nbytes);
+	}
 
 	if (var->bits_per_pixel >= 16)
 		setup_frame_dma(fbi, DMA_BASE, PAL_NONE, 0, nbytes);
 	else
 		setup_frame_dma(fbi, DMA_BASE, PAL_BASE, 0, nbytes);
 
-	fbi->reg_lccr0 = new_regs.lccr0;
-	fbi->reg_lccr1 = new_regs.lccr1;
-	fbi->reg_lccr2 = new_regs.lccr2;
-	fbi->reg_lccr3 = new_regs.lccr3;
 	fbi->reg_lccr4 = lcd_readl(fbi, LCCR4) & ~LCCR4_PAL_FOR_MASK;
 	fbi->reg_lccr4 |= (fbi->lccr4 & LCCR4_PAL_FOR_MASK);
-	set_hsync_time(fbi, pcd);
 	local_irq_restore(flags);
 
 	/*
diff -puN drivers/video/pxafb.h~pxafb-move-parallel-lcd-timing-setup-into-dedicate-function drivers/video/pxafb.h
--- a/drivers/video/pxafb.h~pxafb-move-parallel-lcd-timing-setup-into-dedicate-function
+++ a/drivers/video/pxafb.h
@@ -21,14 +21,6 @@
  * for more details.
  */
 
-/* Shadows for LCD controller registers */
-struct pxafb_lcd_reg {
-	unsigned int lccr0;
-	unsigned int lccr1;
-	unsigned int lccr2;
-	unsigned int lccr3;
-};
