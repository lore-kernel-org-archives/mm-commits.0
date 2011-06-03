From: akpm@linux-foundation.org
Subject: [to-be-updated] drivers-rtc-rtc-stmp3xxxc-remove-uie-handlers.patch removed from -mm tree
Date: Fri, 03 Jun 2011 16:08:48 -0700
Message-ID: <201106032308.p53N8mKw013294@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754247Ab1FCXJS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2011 19:09:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: w.sang@pengutronix.de, a.zummo@towertech.it, johnstul@us.ibm.com, shawn.guo@freescale.com, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc/rtc-stmp3xxx.c: remove UIE handlers
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-stmp3xxxc-remove-uie-handlers.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-stmp3xxx.c: remove UIE handlers
From: Wolfram Sang <w.sang@pengutronix.de>

The RTC core handles UIE since 6610e08 (RTC: Rework RTC code to use
timerqueue for events), so remove the specific interrupt in this driver. 
To make it work at all, enable interrupts in set_alarm() if needed.  Drop
IRQF_DISABLED which is deprecated, while we are here.  Finally, add my
copyright after all these changes.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Tested-by: Shawn Guo <shawn.guo@freescale.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-stmp3xxx.c |   57 ++++++++++-------------------------
 1 file changed, 17 insertions(+), 40 deletions(-)

diff -puN drivers/rtc/rtc-stmp3xxx.c~drivers-rtc-rtc-stmp3xxxc-remove-uie-handlers drivers/rtc/rtc-stmp3xxx.c
--- a/drivers/rtc/rtc-stmp3xxx.c~drivers-rtc-rtc-stmp3xxxc-remove-uie-handlers
+++ a/drivers/rtc/rtc-stmp3xxx.c
@@ -6,6 +6,7 @@
  *
  * Copyright 2008 Freescale Semiconductor, Inc. All Rights Reserved.
  * Copyright 2008 Embedded Alley Solutions, Inc All Rights Reserved.
+ * Copyright 2011 Wolfram Sang, Pengutronix e.K.
  */
 
 /*
@@ -33,7 +34,6 @@
 #define STMP3XXX_RTC_CTRL_ALARM_IRQ_EN		0x00000001
 #define STMP3XXX_RTC_CTRL_ONEMSEC_IRQ_EN	0x00000002
 #define STMP3XXX_RTC_CTRL_ALARM_IRQ		0x00000004
-#define STMP3XXX_RTC_CTRL_ONEMSEC_IRQ		0x00000008
 
 #define STMP3XXX_RTC_STAT		0x10
 #define STMP3XXX_RTC_STAT_STALE_SHIFT		16
@@ -52,9 +52,8 @@
 
 struct stmp3xxx_rtc_data {
 	struct rtc_device *rtc;
-	unsigned irq_count;
 	void __iomem *io;
-	int irq_alarm, irq_1msec;
+	int irq_alarm;
 };
 
 static void stmp3xxx_wait_time(struct stmp3xxx_rtc_data *rtc_data)
@@ -92,31 +91,16 @@ static int stmp3xxx_rtc_set_mmss(struct 
 static irqreturn_t stmp3xxx_rtc_interrupt(int irq, void *dev_id)
 {
 	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev_id);
-	u32 status;
-	u32 events = 0;
-
-	status = readl(rtc_data->io + STMP3XXX_RTC_CTRL) &
-			(STMP3XXX_RTC_CTRL_ALARM_IRQ | STMP3XXX_RTC_CTRL_ONEMSEC_IRQ);
+	u32 status = readl(rtc_data->io + STMP3XXX_RTC_CTRL);
 
 	if (status & STMP3XXX_RTC_CTRL_ALARM_IRQ) {
 		writel(STMP3XXX_RTC_CTRL_ALARM_IRQ,
 				rtc_data->io + STMP3XXX_RTC_CTRL_CLR);
-		events |= RTC_AF | RTC_IRQF;
+		rtc_update_irq(rtc_data->rtc, 1, RTC_AF | RTC_IRQF);
+		return IRQ_HANDLED;
 	}
 
-	if (status & STMP3XXX_RTC_CTRL_ONEMSEC_IRQ) {
-		writel(STMP3XXX_RTC_CTRL_ONEMSEC_IRQ,
-				rtc_data->io + STMP3XXX_RTC_CTRL_CLR);
-		if (++rtc_data->irq_count % 1000 == 0) {
-			events |= RTC_UF | RTC_IRQF;
-			rtc_data->irq_count = 0;
-		}
-	}
-
-	if (events)
-		rtc_update_irq(rtc_data->rtc, 1, events);
-
-	return IRQ_HANDLED;
+	return IRQ_NONE;
 }
 
 static int stmp3xxx_alarm_irq_enable(struct device *dev, unsigned int enabled)
@@ -154,6 +138,9 @@ static int stmp3xxx_rtc_set_alarm(struct
 
 	rtc_tm_to_time(&alm->time, &t);
 	writel(t, rtc_data->io + STMP3XXX_RTC_ALARM);
+
+	stmp3xxx_alarm_irq_enable(dev, alm->enabled);
+
 	return 0;
 }
 
@@ -173,10 +160,9 @@ static int stmp3xxx_rtc_remove(struct pl
 	if (!rtc_data)
 		return 0;
 
-	writel(STMP3XXX_RTC_CTRL_ONEMSEC_IRQ_EN | STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
+	writel(STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
 			rtc_data->io + STMP3XXX_RTC_CTRL_CLR);
 	free_irq(rtc_data->irq_alarm, &pdev->dev);
-	free_irq(rtc_data->irq_1msec, &pdev->dev);
 	rtc_device_unregister(rtc_data->rtc);
 	platform_set_drvdata(pdev, NULL);
 	iounmap(rtc_data->io);
@@ -210,7 +196,6 @@ static int stmp3xxx_rtc_probe(struct pla
 	}
 
 	rtc_data->irq_alarm = platform_get_irq(pdev, 0);
-	rtc_data->irq_1msec = platform_get_irq(pdev, 1);
 
 	if (!(readl(STMP3XXX_RTC_STAT + rtc_data->io) &
 			STMP3XXX_RTC_STAT_RTC_PRESENT)) {
@@ -227,6 +212,9 @@ static int stmp3xxx_rtc_probe(struct pla
 			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE,
 			rtc_data->io + STMP3XXX_RTC_PERSISTENT0_CLR);
 
+	writel(STMP3XXX_RTC_CTRL_ONEMSEC_IRQ_EN | STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
+			rtc_data->io + STMP3XXX_RTC_CTRL_CLR);
+
 	rtc_data->rtc = rtc_device_register(pdev->name, &pdev->dev,
 				&stmp3xxx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc_data->rtc)) {
@@ -234,29 +222,17 @@ static int stmp3xxx_rtc_probe(struct pla
 		goto out_remap;
 	}
 
-	rtc_data->irq_count = 0;
-	err = request_irq(rtc_data->irq_alarm, stmp3xxx_rtc_interrupt,
-			IRQF_DISABLED, "RTC alarm", &pdev->dev);
+	err = request_irq(rtc_data->irq_alarm, stmp3xxx_rtc_interrupt, 0,
+			"RTC alarm", &pdev->dev);
 	if (err) {
 		dev_err(&pdev->dev, "Cannot claim IRQ%d\n",
 			rtc_data->irq_alarm);
 		goto out_irq_alarm;
 	}
-	err = request_irq(rtc_data->irq_1msec, stmp3xxx_rtc_interrupt,
-			IRQF_DISABLED, "RTC tick", &pdev->dev);
-	if (err) {
-		dev_err(&pdev->dev, "Cannot claim IRQ%d\n",
-			rtc_data->irq_1msec);
-		goto out_irq1;
-	}
 
 	return 0;
 
-out_irq1:
-	free_irq(rtc_data->irq_alarm, &pdev->dev);
 out_irq_alarm:
-	writel(STMP3XXX_RTC_CTRL_ONEMSEC_IRQ_EN | STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
-			rtc_data->io + STMP3XXX_RTC_CTRL_CLR);
 	rtc_device_unregister(rtc_data->rtc);
 out_remap:
 	platform_set_drvdata(pdev, NULL);
@@ -313,5 +289,6 @@ module_init(stmp3xxx_rtc_init);
 module_exit(stmp3xxx_rtc_exit);
 
 MODULE_DESCRIPTION("STMP3xxx RTC Driver");
-MODULE_AUTHOR("dmitry pervushin <dpervushin@embeddedalley.com>");
+MODULE_AUTHOR("dmitry pervushin <dpervushin@embeddedalley.com> and "
+		"Wolfram Sang <w.sang@pengutronix.de>");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

linux-next.patch
rtc-driver-for-pt7c4338-chip.patch

