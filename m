From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-sh-switch-to-using-simple_dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:58:22 -0700
Message-ID: <20130430185822.6ECEE31C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:60261 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933370Ab3D3S6X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:58:23 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so86989vbe.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:58:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-sh: switch to using SIMPLE_DEV_PM_OPS
has been removed from the -mm tree.  Its filename was
     rtc-rtc-sh-switch-to-using-simple_dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-sh: switch to using SIMPLE_DEV_PM_OPS

Switch to using the SIMPLE_DEV_PM_OPS macro to declare the driver's
pm_ops.  It reduces code size.  Also, CONFIG_PM_SLEEP is added to prevent
build warning when CONFIG_PM_SLEEP is not selected.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-sh.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-sh.c~rtc-rtc-sh-switch-to-using-simple_dev_pm_ops drivers/rtc/rtc-sh.c
--- a/drivers/rtc/rtc-sh.c~rtc-rtc-sh-switch-to-using-simple_dev_pm_ops
+++ a/drivers/rtc/rtc-sh.c
@@ -790,6 +790,7 @@ static void sh_rtc_set_irq_wake(struct d
 	}
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int sh_rtc_suspend(struct device *dev)
 {
 	if (device_may_wakeup(dev))
@@ -805,17 +806,15 @@ static int sh_rtc_resume(struct device *
 
 	return 0;
 }
+#endif
 
-static const struct dev_pm_ops sh_rtc_dev_pm_ops = {
-	.suspend = sh_rtc_suspend,
-	.resume = sh_rtc_resume,
-};
+static SIMPLE_DEV_PM_OPS(sh_rtc_pm_ops, sh_rtc_suspend, sh_rtc_resume);
 
 static struct platform_driver sh_rtc_platform_driver = {
 	.driver		= {
 		.name	= DRV_NAME,
 		.owner	= THIS_MODULE,
-		.pm	= &sh_rtc_dev_pm_ops,
+		.pm	= &sh_rtc_pm_ops,
 	},
 	.remove		= __exit_p(sh_rtc_remove),
 };
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

