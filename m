From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-at91sam9-convert-at91_rtc_driver-to-dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:01:09 -0700
Message-ID: <20130430190109.72D175A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:36466 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933593Ab3D3TBK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:01:10 -0400
Received: by mail-ye0-f202.google.com with SMTP id r11so87478yen.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:01:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-at91sam9: convert at91_rtc_driver to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     rtc-rtc-at91sam9-convert-at91_rtc_driver-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-at91sam9: convert at91_rtc_driver to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91sam9.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff -puN drivers/rtc/rtc-at91sam9.c~rtc-rtc-at91sam9-convert-at91_rtc_driver-to-dev_pm_ops drivers/rtc/rtc-at91sam9.c
--- a/drivers/rtc/rtc-at91sam9.c~rtc-rtc-at91sam9-convert-at91_rtc_driver-to-dev_pm_ops
+++ a/drivers/rtc/rtc-at91sam9.c
@@ -404,14 +404,13 @@ static void at91_rtc_shutdown(struct pla
 	rtt_writel(rtc, MR, mr & ~rtc->imr);
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 
 /* AT91SAM9 RTC Power management control */
 
-static int at91_rtc_suspend(struct platform_device *pdev,
-					pm_message_t state)
+static int at91_rtc_suspend(struct device *dev)
 {
-	struct sam9_rtc	*rtc = platform_get_drvdata(pdev);
+	struct sam9_rtc	*rtc = dev_get_drvdata(dev);
 	u32		mr = rtt_readl(rtc, MR);
 
 	/*
@@ -420,7 +419,7 @@ static int at91_rtc_suspend(struct platf
 	 */
 	rtc->imr = mr & (AT91_RTT_ALMIEN | AT91_RTT_RTTINCIEN);
 	if (rtc->imr) {
-		if (device_may_wakeup(&pdev->dev) && (mr & AT91_RTT_ALMIEN)) {
+		if (device_may_wakeup(dev) && (mr & AT91_RTT_ALMIEN)) {
 			enable_irq_wake(rtc->irq);
 			/* don't let RTTINC cause wakeups */
 			if (mr & AT91_RTT_RTTINCIEN)
@@ -432,13 +431,13 @@ static int at91_rtc_suspend(struct platf
 	return 0;
 }
 
-static int at91_rtc_resume(struct platform_device *pdev)
+static int at91_rtc_resume(struct device *dev)
 {
-	struct sam9_rtc	*rtc = platform_get_drvdata(pdev);
+	struct sam9_rtc	*rtc = dev_get_drvdata(dev);
 	u32		mr;
 
 	if (rtc->imr) {
-		if (device_may_wakeup(&pdev->dev))
+		if (device_may_wakeup(dev))
 			disable_irq_wake(rtc->irq);
 		mr = rtt_readl(rtc, MR);
 		rtt_writel(rtc, MR, mr | rtc->imr);
@@ -446,20 +445,18 @@ static int at91_rtc_resume(struct platfo
 
 	return 0;
 }
-#else
-#define at91_rtc_suspend	NULL
-#define at91_rtc_resume		NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(at91_rtc_pm_ops, at91_rtc_suspend, at91_rtc_resume);
+
 static struct platform_driver at91_rtc_driver = {
 	.probe		= at91_rtc_probe,
 	.remove		= at91_rtc_remove,
 	.shutdown	= at91_rtc_shutdown,
-	.suspend	= at91_rtc_suspend,
-	.resume		= at91_rtc_resume,
 	.driver		= {
 		.name	= "rtc-at91sam9",
 		.owner	= THIS_MODULE,
+		.pm	= &at91_rtc_pm_ops,
 	},
 };
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

