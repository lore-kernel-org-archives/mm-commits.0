From: akpm@linux-foundation.org
Subject: - pxafb-introduce-lcd_readwritel-to-wrap-the-__raw_readwritel.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:17 -0700
Message-ID: <200805010925.m419PHWT030187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752770AbYEAJpu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:45:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.miao@marvell.com, adaplas@pol.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     pxafb: introduce lcd_{read,write}l() to wrap the __raw_{read,write}l()
has been removed from the -mm tree.  Its filename was
     pxafb-introduce-lcd_readwritel-to-wrap-the-__raw_readwritel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pxafb: introduce lcd_{read,write}l() to wrap the __raw_{read,write}l()
From: Eric Miao <eric.miao@marvell.com>

using __raw_{read,write}l() everywhere looks messy, introduce
lcd_{read,write}l() to get this cleaned up a bit

Signed-off-by: eric miao <eric.miao@marvell.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pxafb.c |   59 +++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 24 deletions(-)

diff -puN drivers/video/pxafb.c~pxafb-introduce-lcd_readwritel-to-wrap-the-__raw_readwritel drivers/video/pxafb.c
--- a/drivers/video/pxafb.c~pxafb-introduce-lcd_readwritel-to-wrap-the-__raw_readwritel
+++ a/drivers/video/pxafb.c
@@ -71,6 +71,18 @@ static int pxafb_activate_var(struct fb_
 				struct pxafb_info *);
 static void set_ctrlr_state(struct pxafb_info *fbi, u_int state);
 
+static inline unsigned long
+lcd_readl(struct pxafb_info *fbi, unsigned int off)
+{
+	return __raw_readl(fbi->mmio_base + off);
+}
+
+static inline void
+lcd_writel(struct pxafb_info *fbi, unsigned int off, unsigned long val)
+{
+	__raw_writel(val, fbi->mmio_base + off);
+}
+
 static inline void pxafb_schedule_work(struct pxafb_info *fbi, u_int state)
 {
 	unsigned long flags;
@@ -684,8 +696,7 @@ static int pxafb_activate_var(struct fb_
 	fbi->reg_lccr1 = new_regs.lccr1;
 	fbi->reg_lccr2 = new_regs.lccr2;
 	fbi->reg_lccr3 = new_regs.lccr3;
-	fbi->reg_lccr4 = __raw_readl(fbi->mmio_base + LCCR4) &
-				(~LCCR4_PAL_FOR_MASK);
+	fbi->reg_lccr4 = lcd_readl(fbi, LCCR4) & ~LCCR4_PAL_FOR_MASK;
 	fbi->reg_lccr4 |= (fbi->lccr4 & LCCR4_PAL_FOR_MASK);
 	set_hsync_time(fbi, pcd);
 	local_irq_restore(flags);
@@ -694,12 +705,12 @@ static int pxafb_activate_var(struct fb_
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
@@ -785,14 +796,14 @@ static void pxafb_enable_controller(stru
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
@@ -805,11 +816,11 @@ static void pxafb_disable_controller(str
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
@@ -824,15 +835,15 @@ static void pxafb_disable_controller(str
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

origin.patch
git-arm.patch
gpio-pca953x-add-support-for-pca9555-i2c-i-o-expander.patch

