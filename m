From: akpm@linux-foundation.org
Subject: - pxafb-introduce-lcd_readwritel-to-wrap-the-__raw_readwritel.patch removed from -mm tree
Date: Tue, 15 Apr 2008 17:10:12 -0700
Message-ID: <200804160010.m3G0ACOi023035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753972AbYDPALB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 20:11:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.miao@marvell.com, adaplas@pol.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     pxafb: introduce lcd_{read,write}l() to wrap the __raw_{read,write}l()
has been removed from the -mm tree.  Its filename was
     pxafb-introduce-lcd_readwritel-to-wrap-the-__raw_readwritel.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pxafb: introduce lcd_{read,write}l() to wrap the __raw_{read,write}l()
From: Eric Miao <eric.miao@marvell.com>

Using __raw_{read,write}l() everywhere looks messy, introduce
lcd_{read,write}l() to get this cleaned up a bit

Signed-off-by: eric miao <eric.miao@marvell.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pxafb.c |   50 ++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 24 deletions(-)

diff -puN drivers/video/pxafb.c~pxafb-introduce-lcd_readwritel-to-wrap-the-__raw_readwritel drivers/video/pxafb.c
--- a/drivers/video/pxafb.c~pxafb-introduce-lcd_readwritel-to-wrap-the-__raw_readwritel
+++ a/drivers/video/pxafb.c
@@ -64,6 +64,9 @@
 #define LCCR3_INVALID_CONFIG_MASK	(LCCR3_HSP | LCCR3_VSP |\
 					 LCCR3_PCD | LCCR3_BPP)
 
+#define lcd_readl(f, off)	__raw_readl((f)->mmio_base + (off))
+#define lcd_writel(f, off, v)	__raw_writel((v), (f)->mmio_base + (off))
+
 static void (*pxafb_backlight_power)(int);
 static void (*pxafb_lcd_power)(int, struct fb_var_screeninfo *);
 
@@ -684,8 +687,7 @@ static int pxafb_activate_var(struct fb_
 	fbi->reg_lccr1 = new_regs.lccr1;
 	fbi->reg_lccr2 = new_regs.lccr2;
 	fbi->reg_lccr3 = new_regs.lccr3;
-	fbi->reg_lccr4 = __raw_readl(fbi->mmio_base + LCCR4) &
-				(~LCCR4_PAL_FOR_MASK);
+	fbi->reg_lccr4 = lcd_readl(fbi, LCCR4) & ~LCCR4_PAL_FOR_MASK;
 	fbi->reg_lccr4 |= (fbi->lccr4 & LCCR4_PAL_FOR_MASK);
 	set_hsync_time(fbi, pcd);
 	local_irq_restore(flags);
@@ -694,12 +696,12 @@ static int pxafb_activate_var(struct fb_
 	 * Only update the registers if the controller is enabled
 	 * and something has changed.
 	 */
-	if ((__raw_readl(fbi->mmio_base + LCCR0) != fbi->reg_lccr0) ||
-	    (__raw_readl(fbi->mmio_base + LCCR1) != fbi->reg_lccr1) ||
-	    (__raw_readl(fbi->mmio_base + LCCR2) != fbi->reg_lccr2) ||
-	    (__raw_readl(fbi->mmio_base + LCCR3) != fbi->reg_lccr3) ||
-	    (__raw_readl(fbi->mmio_base + FDADR0) != fbi->fdadr[0]) ||
-	    (__raw_readl(fbi->mmio_base + FDADR1) != fbi->fdadr[1]))
+	if ((lcd_readl(fbi, LCCR0) != fbi->reg_lccr0) ||
+	    (lcd_readl(fbi, LCCR1) != fbi->reg_lccr1) ||
+	    (lcd_readl(fbi, LCCR2) != fbi->reg_lccr2) ||
+	    (lcd_readl(fbi, LCCR3) != fbi->reg_lccr3) ||
+	    (lcd_readl(fbi, FDADR0) != fbi->fdadr[0]) ||
+	    (lcd_readl(fbi, FDADR1) != fbi->fdadr[1]))
 		pxafb_schedule_work(fbi, C_REENABLE);
 
 	return 0;
@@ -785,14 +787,14 @@ static void pxafb_enable_controller(stru
 	clk_enable(fbi->clk);
 
 	/* Sequence from 11.7.10 */
-	__raw_writel(fbi->reg_lccr3, fbi->mmio_base + LCCR3);
-	__raw_writel(fbi->reg_lccr2, fbi->mmio_base + LCCR2);
-	__raw_writel(fbi->reg_lccr1, fbi->mmio_base + LCCR1);
-	__raw_writel(fbi->reg_lccr0 & ~LCCR0_ENB, fbi->mmio_base + LCCR0);
-
-	__raw_writel(fbi->fdadr[0], fbi->mmio_base + FDADR0);
-	__raw_writel(fbi->fdadr[1], fbi->mmio_base + FDADR1);
-	__raw_writel(fbi->reg_lccr0 | LCCR0_ENB, fbi->mmio_base + LCCR0);
+	lcd_writel(fbi, LCCR3, fbi->reg_lccr3);
+	lcd_writel(fbi, LCCR2, fbi->reg_lccr2);
+	lcd_writel(fbi, LCCR1, fbi->reg_lccr1);
+	lcd_writel(fbi, LCCR0, fbi->reg_lccr0 & ~LCCR0_ENB);
+
+	lcd_writel(fbi, FDADR0, fbi->fdadr[0]);
+	lcd_writel(fbi, FDADR1, fbi->fdadr[1]);
+	lcd_writel(fbi, LCCR0, fbi->reg_lccr0 | LCCR0_ENB);
 }
 
 static void pxafb_disable_controller(struct pxafb_info *fbi)
@@ -805,11 +807,11 @@ static void pxafb_disable_controller(str
 	add_wait_queue(&fbi->ctrlr_wait, &wait);
 
 	/* Clear LCD Status Register */
-	__raw_writel(0xffffffff, fbi->mmio_base + LCSR);
+	lcd_writel(fbi, LCSR, 0xffffffff);
 
-	lccr0 = __raw_readl(fbi->mmio_base + LCCR0) & ~LCCR0_LDM;
-	__raw_writel(lccr0, fbi->mmio_base + LCCR0);
-	__raw_writel(lccr0 | LCCR0_DIS, fbi->mmio_base + LCCR0);
+	lccr0 = lcd_readl(fbi, LCCR0) & ~LCCR0_LDM;
+	lcd_writel(fbi, LCCR0, lccr0);
+	lcd_writel(fbi, LCCR0, lccr0 | LCCR0_DIS);
 
 	schedule_timeout(200 * HZ / 1000);
 	remove_wait_queue(&fbi->ctrlr_wait, &wait);
@@ -824,15 +826,15 @@ static void pxafb_disable_controller(str
 static irqreturn_t pxafb_handle_irq(int irq, void *dev_id)
 {
 	struct pxafb_info *fbi = dev_id;
-	unsigned int lccr0, lcsr = __raw_readl(fbi->mmio_base + LCSR);
+	unsigned int lccr0, lcsr = lcd_readl(fbi, LCSR);
 
 	if (lcsr & LCSR_LDD) {
-		lccr0 = __raw_readl(fbi->mmio_base + LCCR0) | LCCR0_LDM;
-		__raw_writel(lccr0, fbi->mmio_base + LCCR0);
+		lccr0 = lcd_readl(fbi, LCCR0);
+		lcd_writel(fbi, LCCR0, lccr0 | LCCR0_LDM);
 		wake_up(&fbi->ctrlr_wait);
 	}
 
-	__raw_writel(lcsr, fbi->mmio_base + LCSR);
+	lcd_writel(fbi, LCSR, lcsr);
 	return IRQ_HANDLED;
 }
 
_

Patches currently in -mm which might be from eric.miao@marvell.com are

git-arm.patch
pxafb-un-nest-pxafb_parse_options-to-cleanup-the-coding-style-issue.patch
pxafb-fix-various-coding-style-issues-for-pxafb.patch
pxafb-purge-unnecessary-pr_debug-and-comments-from-pxafb.patch
pxafb-sanitize-the-usage-of-ifdef-processing-pxafb-parameters.patch
pxafb-convert-fb-driver-to-use-ioremap-and-__raw_readl-writel.patch
pxafb-introduce-struct-pxafb_dma_buff-for-palette-and-dma-descriptors.patch
pxafb-introduce-register-independent-lcd-connection-type-for-pxafb.patch
pxafb-make-lubbock-mainstone-zylonite-littleton-to-use-new-lcd-connection-type.patch
pxafb-introduce-lcd_readwritel-to-wrap-the-__raw_readwritel.patch
pxafb-use-completion-for-lcd-disable-wait-code.patch
pxafb-move-parallel-lcd-timing-setup-into-dedicate-function.patch
pxafb-preliminary-smart-panel-interface-support.patch
pxafb-preliminary-smart-panel-interface-support-update.patch

