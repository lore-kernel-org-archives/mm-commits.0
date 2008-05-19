From: akpm@linux-foundation.org
Subject: + atmel_lcdfb-fifo-underflow-management.patch added to -mm tree
Date: Mon, 19 May 2008 15:56:13 -0700
Message-ID: <200805192256.m4JMuDXH025258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752902AbYESW4n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 18:56:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.ferre@atmel.com, hskinnemoen@atmel.com, linux@maxim.org.za


The patch titled
     atmel_lcdfb: FIFO underflow management
has been added to the -mm tree.  Its filename is
     atmel_lcdfb-fifo-underflow-management.patch

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
Subject: atmel_lcdfb: FIFO underflow management
From: Nicolas Ferre <nicolas.ferre@atmel.com>

Manage atmel_lcdfb FIFO underflow

Resetting the LCD and DMA allows to fix screen shifting after a FIFO
underflow.  It follows reset sequence from errata "LCD Screen Shifting
After a Reset".

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andrew Victor <linux@maxim.org.za>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atmel_lcdfb.c |   50 +++++++++++++++++++++++++++++++++-
 include/video/atmel_lcdc.h  |    1 
 2 files changed, 50 insertions(+), 1 deletion(-)

diff -puN drivers/video/atmel_lcdfb.c~atmel_lcdfb-fifo-underflow-management drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel_lcdfb-fifo-underflow-management
+++ a/drivers/video/atmel_lcdfb.c
@@ -379,6 +379,33 @@ static int atmel_lcdfb_check_var(struct 
 	return 0;
 }
 
+/*
+ * LCD reset sequence
+ */
+static void atmel_lcdfb_reset(struct atmel_lcdfb_info *sinfo)
+{
+	/* LCD power off */
+	lcdc_writel(sinfo, ATMEL_LCDC_PWRCON, sinfo->guard_time << ATMEL_LCDC_GUARDT_OFFSET);
+
+	/* wait for the LCDC core to become idle */
+	while (lcdc_readl(sinfo, ATMEL_LCDC_PWRCON) & ATMEL_LCDC_BUSY)
+		msleep(10);
+
+	/* DMA disable */
+	lcdc_writel(sinfo, ATMEL_LCDC_DMACON, 0);
+
+	/* wait for DMA engine to become idle */
+	while (lcdc_readl(sinfo, ATMEL_LCDC_DMACON) & ATMEL_LCDC_DMABUSY)
+		msleep(10);
+
+	/* LCD power on */
+	lcdc_writel(sinfo, ATMEL_LCDC_PWRCON,
+		(sinfo->guard_time << ATMEL_LCDC_GUARDT_OFFSET) | ATMEL_LCDC_PWR);
+
+	/* DMA enable */
+	lcdc_writel(sinfo, ATMEL_LCDC_DMACON, sinfo->default_dmacon);
+}
+
 /**
  *      atmel_lcdfb_set_par - Alters the hardware state.
  *      @info: frame buffer structure that represents a single frame buffer
@@ -511,6 +538,8 @@ static int atmel_lcdfb_set_par(struct fb
 
 	/* Disable all interrupts */
 	lcdc_writel(sinfo, ATMEL_LCDC_IDR, ~0UL);
+	/* Enable FIFO & DMA errors */
+	lcdc_writel(sinfo, ATMEL_LCDC_IER, ATMEL_LCDC_UFLWI | ATMEL_LCDC_OWRI | ATMEL_LCDC_MERI);
 
 	/* ...wait for DMA engine to become idle... */
 	while (lcdc_readl(sinfo, ATMEL_LCDC_DMACON) & ATMEL_LCDC_DMABUSY)
@@ -645,10 +674,26 @@ static irqreturn_t atmel_lcdfb_interrupt
 	u32 status;
 
 	status = lcdc_readl(sinfo, ATMEL_LCDC_ISR);
-	lcdc_writel(sinfo, ATMEL_LCDC_IDR, status);
+	if (status & ATMEL_LCDC_UFLWI) {
+		dev_warn(info->device, "FIFO underflow %#x\n", status);
+		/* reset DMA and FIFO to avoid screen shifting */
+		schedule_work(&sinfo->task);
+	}
+	lcdc_writel(sinfo, ATMEL_LCDC_ICR, status);
 	return IRQ_HANDLED;
 }
 
+/*
+ * LCD controller task (to reset the LCD)
+ */
+static void atmel_lcdfb_task(struct work_struct *work)
+{
+	struct atmel_lcdfb_info *sinfo =
+		container_of(work, struct atmel_lcdfb_info, task);
+
+	atmel_lcdfb_reset(sinfo);
+}
+
 static int __init atmel_lcdfb_init_fbinfo(struct atmel_lcdfb_info *sinfo)
 {
 	struct fb_info *info = sinfo->info;
@@ -824,6 +869,9 @@ static int __init atmel_lcdfb_probe(stru
 		goto unmap_mmio;
 	}
 
+	/* Initialize bottom half workqueue */
+	INIT_WORK(&sinfo->task, atmel_lcdfb_task);
+
 	ret = atmel_lcdfb_init_fbinfo(sinfo);
 	if (ret < 0) {
 		dev_err(dev, "init fbinfo failed: %d\n", ret);
diff -puN include/video/atmel_lcdc.h~atmel_lcdfb-fifo-underflow-management include/video/atmel_lcdc.h
--- a/include/video/atmel_lcdc.h~atmel_lcdfb-fifo-underflow-management
+++ a/include/video/atmel_lcdc.h
@@ -37,6 +37,7 @@ struct atmel_lcdfb_info {
 	struct fb_info		*info;
 	void __iomem		*mmio;
 	unsigned long		irq_base;
+	struct work_struct	task;
 
 	unsigned int		guard_time;
 	struct platform_device	*pdev;
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

atmel_lcdfb-fifo-underflow-management.patch

