From: akpm@linux-foundation.org
Subject: - blackfin-rtc-driver-add-support-for-power-management-framework.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:56:30 -0700
Message-ID: <200808062056.m76KuURR014672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763441AbYHFVUT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 17:20:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, a.zummo@towertech.it, bryan.wu@analog.com, cooloney@kernel.org, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     blackfin RTC driver: add support for power management framework
has been removed from the -mm tree.  Its filename was
     blackfin-rtc-driver-add-support-for-power-management-framework.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin RTC driver: add support for power management framework
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff -puN drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-add-support-for-power-management-framework drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-add-support-for-power-management-framework
+++ a/drivers/rtc/rtc-bfin.c
@@ -2,7 +2,7 @@
  * Blackfin On-Chip Real Time Clock Driver
  *  Supports BF52[257]/BF53[123]/BF53[467]/BF54[24789]
  *
- * Copyright 2004-2007 Analog Devices Inc.
+ * Copyright 2004-2008 Analog Devices Inc.
  *
  * Enter bugs at http://blackfin.uclinux.org/
  *
@@ -412,6 +412,8 @@ static int __devinit bfin_rtc_probe(stru
 
 	platform_set_drvdata(pdev, rtc);
 
+	device_init_wakeup(&pdev->dev, 1);
+
 	return 0;
 
  err:
@@ -433,25 +435,28 @@ static int __devexit bfin_rtc_remove(str
 #ifdef CONFIG_PM
 static int bfin_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 {
-#ifdef PM_WAKEUP_SIC_IWR
 	struct bfin_rtc *rtc = dev_get_drvdata(&pdev->dev);
-#endif
-	bfin_rtc_reset(&pdev->dev);
-#ifdef PM_WAKEUP_SIC_IWR
-	bfin_write_RTC_SWCNT(10);
-	bfin_rtc_int_set(rtc, RTC_ISTAT_STOPWATCH);
-#endif
+
+	if (device_may_wakeup(&pdev->dev))
+		enable_irq_wake(IRQ_RTC);
+	else
+		bfin_rtc_int_clear(rtc, -1);
+
 	return 0;
 }
 
 static int bfin_rtc_resume(struct platform_device *pdev)
 {
-#ifdef PM_WAKEUP_SIC_IWR
-	struct bfin_rtc *rtc = dev_get_drvdata(&pdev->dev);
-	bfin_rtc_int_clear(rtc, RTC_ISTAT_STOPWATCH);
-#endif
+	if (device_may_wakeup(&pdev->dev))
+		disable_irq_wake(IRQ_RTC);
+	else
+		bfin_write_RTC_ISTAT(-1);
+
 	return 0;
 }
+#else
+# define bfin_rtc_suspend NULL
+# define bfin_rtc_resume  NULL
 #endif
 
 static struct platform_driver bfin_rtc_driver = {
@@ -461,10 +466,8 @@ static struct platform_driver bfin_rtc_d
 	},
 	.probe		= bfin_rtc_probe,
 	.remove		= __devexit_p(bfin_rtc_remove),
-#ifdef CONFIG_PM
 	.suspend	= bfin_rtc_suspend,
 	.resume		= bfin_rtc_resume,
-#endif
 };
 
 static int __init bfin_rtc_init(void)
_

Patches currently in -mm which might be from vapier.adi@gmail.com are


