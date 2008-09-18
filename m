From: akpm@linux-foundation.org
Subject: - atmel_lcdfb-disable-lcd-and-dma-engines-when-suspending.patch removed from -mm tree
Date: Thu, 18 Sep 2008 13:56:15 -0700
Message-ID: <200809182056.m8IKuFXo019180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754631AbYIRU4U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Sep 2008 16:56:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haavard.skinnemoen@atmel.com, nicolas.ferre@atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel_lcdfb: disable LCD and DMA engines when suspending
has been removed from the -mm tree.  Its filename was
     atmel_lcdfb-disable-lcd-and-dma-engines-when-suspending.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_lcdfb: disable LCD and DMA engines when suspending
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

When suspending the system with atmel_lcdfb enabled, I sometimes see
this:

[17179610.896000] atmel_lcdfb atmel_lcdfb.0: FIFO underflow 0x10

Which can be explained by the fact that we're not stopping the LCD
controller and its DMA engine when suspending, we're just gating the
clocks to them.

There's another potential issue which may be harder to trigger but
much more nasty: If we gate the clocks at _just_ the right moment,
e.g. when the DMA engine is doing a bus transaction, we may cause the
DMA engine to violate the system bus protocol and cause a lockup.

Avoid these issues by shutting down the LCD controller before entering
suspend (and restarting it when resuming). This prevents the underrun
from happening in the first place, and prevents whatever nastiness is
happening when the bus clock stops in the middle of a DMA transfer.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atmel_lcdfb.c |   84 +++++++++++++++++++---------------
 1 file changed, 49 insertions(+), 35 deletions(-)

diff -puN drivers/video/atmel_lcdfb.c~atmel_lcdfb-disable-lcd-and-dma-engines-when-suspending drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel_lcdfb-disable-lcd-and-dma-engines-when-suspending
+++ a/drivers/video/atmel_lcdfb.c
@@ -208,6 +208,36 @@ static unsigned long compute_hozval(unsi
 	return value;
 }
 
+static void atmel_lcdfb_stop_nowait(struct atmel_lcdfb_info *sinfo)
+{
+	/* Turn off the LCD controller and the DMA controller */
+	lcdc_writel(sinfo, ATMEL_LCDC_PWRCON,
+			sinfo->guard_time << ATMEL_LCDC_GUARDT_OFFSET);
+
+	/* Wait for the LCDC core to become idle */
+	while (lcdc_readl(sinfo, ATMEL_LCDC_PWRCON) & ATMEL_LCDC_BUSY)
+		msleep(10);
+
+	lcdc_writel(sinfo, ATMEL_LCDC_DMACON, 0);
+}
+
+static void atmel_lcdfb_stop(struct atmel_lcdfb_info *sinfo)
+{
+	atmel_lcdfb_stop_nowait(sinfo);
+
+	/* Wait for DMA engine to become idle... */
+	while (lcdc_readl(sinfo, ATMEL_LCDC_DMACON) & ATMEL_LCDC_DMABUSY)
+		msleep(10);
+}
+
+static void atmel_lcdfb_start(struct atmel_lcdfb_info *sinfo)
+{
+	lcdc_writel(sinfo, ATMEL_LCDC_DMACON, sinfo->default_dmacon);
+	lcdc_writel(sinfo, ATMEL_LCDC_PWRCON,
+		(sinfo->guard_time << ATMEL_LCDC_GUARDT_OFFSET)
+		| ATMEL_LCDC_PWR);
+}
+
 static void atmel_lcdfb_update_dma(struct fb_info *info,
 			       struct fb_var_screeninfo *var)
 {
@@ -420,26 +450,8 @@ static void atmel_lcdfb_reset(struct atm
 {
 	might_sleep();
 
-	/* LCD power off */
-	lcdc_writel(sinfo, ATMEL_LCDC_PWRCON, sinfo->guard_time << ATMEL_LCDC_GUARDT_OFFSET);
-
-	/* wait for the LCDC core to become idle */
-	while (lcdc_readl(sinfo, ATMEL_LCDC_PWRCON) & ATMEL_LCDC_BUSY)
-		msleep(10);
-
-	/* DMA disable */
-	lcdc_writel(sinfo, ATMEL_LCDC_DMACON, 0);
-
-	/* wait for DMA engine to become idle */
-	while (lcdc_readl(sinfo, ATMEL_LCDC_DMACON) & ATMEL_LCDC_DMABUSY)
-		msleep(10);
-
-	/* LCD power on */
-	lcdc_writel(sinfo, ATMEL_LCDC_PWRCON,
-		(sinfo->guard_time << ATMEL_LCDC_GUARDT_OFFSET) | ATMEL_LCDC_PWR);
-
-	/* DMA enable */
-	lcdc_writel(sinfo, ATMEL_LCDC_DMACON, sinfo->default_dmacon);
+	atmel_lcdfb_stop(sinfo);
+	atmel_lcdfb_start(sinfo);
 }
 
 /**
@@ -471,14 +483,7 @@ static int atmel_lcdfb_set_par(struct fb
 		 info->var.xres, info->var.yres,
 		 info->var.xres_virtual, info->var.yres_virtual);
 
-	/* Turn off the LCD controller and the DMA controller */
-	lcdc_writel(sinfo, ATMEL_LCDC_PWRCON, sinfo->guard_time << ATMEL_LCDC_GUARDT_OFFSET);
-
-	/* Wait for the LCDC core to become idle */
-	while (lcdc_readl(sinfo, ATMEL_LCDC_PWRCON) & ATMEL_LCDC_BUSY)
-		msleep(10);
-
-	lcdc_writel(sinfo, ATMEL_LCDC_DMACON, 0);
+	atmel_lcdfb_stop_nowait(sinfo);
 
 	if (info->var.bits_per_pixel == 1)
 		info->fix.visual = FB_VISUAL_MONO01;
@@ -583,13 +588,7 @@ static int atmel_lcdfb_set_par(struct fb
 	while (lcdc_readl(sinfo, ATMEL_LCDC_DMACON) & ATMEL_LCDC_DMABUSY)
 		msleep(10);
 
-	dev_dbg(info->device, "  * re-enable DMA engine\n");
-	/* ...and enable it with updated configuration */
-	lcdc_writel(sinfo, ATMEL_LCDC_DMACON, sinfo->default_dmacon);
-
-	dev_dbg(info->device, "  * re-enable LCDC core\n");
-	lcdc_writel(sinfo, ATMEL_LCDC_PWRCON,
-		(sinfo->guard_time << ATMEL_LCDC_GUARDT_OFFSET) | ATMEL_LCDC_PWR);
+	atmel_lcdfb_start(sinfo);
 
 	dev_dbg(info->device, "  * DONE\n");
 
@@ -1032,11 +1031,20 @@ static int atmel_lcdfb_suspend(struct pl
 	struct fb_info *info = platform_get_drvdata(pdev);
 	struct atmel_lcdfb_info *sinfo = info->par;
 
+	/*
+	 * We don't want to handle interrupts while the clock is
+	 * stopped. It may take forever.
+	 */
+	lcdc_writel(sinfo, ATMEL_LCDC_IDR, ~0UL);
+
 	sinfo->saved_lcdcon = lcdc_readl(sinfo, ATMEL_LCDC_CONTRAST_VAL);
 	lcdc_writel(sinfo, ATMEL_LCDC_CONTRAST_CTR, 0);
 	if (sinfo->atmel_lcdfb_power_control)
 		sinfo->atmel_lcdfb_power_control(0);
+
+	atmel_lcdfb_stop(sinfo);
 	atmel_lcdfb_stop_clock(sinfo);
+
 	return 0;
 }
 
@@ -1046,9 +1054,15 @@ static int atmel_lcdfb_resume(struct pla
 	struct atmel_lcdfb_info *sinfo = info->par;
 
 	atmel_lcdfb_start_clock(sinfo);
+	atmel_lcdfb_start(sinfo);
 	if (sinfo->atmel_lcdfb_power_control)
 		sinfo->atmel_lcdfb_power_control(1);
 	lcdc_writel(sinfo, ATMEL_LCDC_CONTRAST_CTR, sinfo->saved_lcdcon);
+
+	/* Enable FIFO & DMA errors */
+	lcdc_writel(sinfo, ATMEL_LCDC_IER, ATMEL_LCDC_UFLWI
+			| ATMEL_LCDC_OWRI | ATMEL_LCDC_MERI);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from haavard.skinnemoen@atmel.com are

origin.patch
linux-next.patch

