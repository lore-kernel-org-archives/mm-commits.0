From: akpm@linux-foundation.org
Subject: - blackfin-rtc-driver-fix-bug-only-rtc-interrupt-can-wake-up-deeper-sleep-core.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:56:28 -0700
Message-ID: <200808062056.m76KuSJE014669@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756291AbYHFVKa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 17:10:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sonic.zhang@analog.com, a.zummo@towertech.it, bryan.wu@analog.com, cooloney@kernel.org, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     blackfin RTC driver: Fix bug Only RTC interrupt can wake up deeper sleep core
has been removed from the -mm tree.  Its filename was
     blackfin-rtc-driver-fix-bug-only-rtc-interrupt-can-wake-up-deeper-sleep-core.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin RTC driver: Fix bug Only RTC interrupt can wake up deeper sleep core
From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff -puN drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-fix-bug-only-rtc-interrupt-can-wake-up-deeper-sleep-core drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~blackfin-rtc-driver-fix-bug-only-rtc-interrupt-can-wake-up-deeper-sleep-core
+++ a/drivers/rtc/rtc-bfin.c
@@ -430,6 +430,30 @@ static int __devexit bfin_rtc_remove(str
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int bfin_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+{
+#ifdef PM_WAKEUP_SIC_IWR
+	struct bfin_rtc *rtc = dev_get_drvdata(&pdev->dev);
+#endif
+	bfin_rtc_reset(&pdev->dev);
+#ifdef PM_WAKEUP_SIC_IWR
+	bfin_write_RTC_SWCNT(10);
+	bfin_rtc_int_set(rtc, RTC_ISTAT_STOPWATCH);
+#endif
+	return 0;
+}
+
+static int bfin_rtc_resume(struct platform_device *pdev)
+{
+#ifdef PM_WAKEUP_SIC_IWR
+	struct bfin_rtc *rtc = dev_get_drvdata(&pdev->dev);
+	bfin_rtc_int_clear(rtc, RTC_ISTAT_STOPWATCH);
+#endif
+	return 0;
+}
+#endif
+
 static struct platform_driver bfin_rtc_driver = {
 	.driver		= {
 		.name	= "rtc-bfin",
@@ -437,6 +461,10 @@ static struct platform_driver bfin_rtc_d
 	},
 	.probe		= bfin_rtc_probe,
 	.remove		= __devexit_p(bfin_rtc_remove),
+#ifdef CONFIG_PM
+	.suspend	= bfin_rtc_suspend,
+	.resume		= bfin_rtc_resume,
+#endif
 };
 
 static int __init bfin_rtc_init(void)
_

Patches currently in -mm which might be from sonic.zhang@analog.com are


