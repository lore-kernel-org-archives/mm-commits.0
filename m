From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-pxa-switch-to-using-simple_dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:58:15 -0700
Message-ID: <20130430185815.731635A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:37825 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933350Ab3D3S6R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:58:17 -0400
Received: by mail-yh0-f73.google.com with SMTP id f35so86994yha.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:58:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-pxa: switch to using SIMPLE_DEV_PM_OPS
has been removed from the -mm tree.  Its filename was
     rtc-rtc-pxa-switch-to-using-simple_dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-pxa: switch to using SIMPLE_DEV_PM_OPS

Switch to using the SIMPLE_DEV_PM_OPS macro to declare the driver's
pm_ops.  It reduces code size.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pxa.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN drivers/rtc/rtc-pxa.c~rtc-rtc-pxa-switch-to-using-simple_dev_pm_ops drivers/rtc/rtc-pxa.c
--- a/drivers/rtc/rtc-pxa.c~rtc-rtc-pxa-switch-to-using-simple_dev_pm_ops
+++ a/drivers/rtc/rtc-pxa.c
@@ -416,7 +416,7 @@ static struct of_device_id pxa_rtc_dt_id
 MODULE_DEVICE_TABLE(of, pxa_rtc_dt_ids);
 #endif
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int pxa_rtc_suspend(struct device *dev)
 {
 	struct pxa_rtc *pxa_rtc = dev_get_drvdata(dev);
@@ -434,21 +434,16 @@ static int pxa_rtc_resume(struct device
 		disable_irq_wake(pxa_rtc->irq_Alrm);
 	return 0;
 }
-
-static const struct dev_pm_ops pxa_rtc_pm_ops = {
-	.suspend	= pxa_rtc_suspend,
-	.resume		= pxa_rtc_resume,
-};
 #endif
 
+static SIMPLE_DEV_PM_OPS(pxa_rtc_pm_ops, pxa_rtc_suspend, pxa_rtc_resume);
+
 static struct platform_driver pxa_rtc_driver = {
 	.remove		= __exit_p(pxa_rtc_remove),
 	.driver		= {
 		.name	= "pxa-rtc",
 		.of_match_table = of_match_ptr(pxa_rtc_dt_ids),
-#ifdef CONFIG_PM
 		.pm	= &pxa_rtc_pm_ops,
-#endif
 	},
 };
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

