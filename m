From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-puv3-convert-puv3_rtc_driver-to-dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:01:20 -0700
Message-ID: <20130430190120.738D75A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:64001 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933297Ab3D3TBV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:01:21 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so87563vcb.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:01:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-puv3: convert puv3_rtc_driver to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     rtc-rtc-puv3-convert-puv3_rtc_driver-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-puv3: convert puv3_rtc_driver to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-puv3.c |   27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff -puN drivers/rtc/rtc-puv3.c~rtc-rtc-puv3-convert-puv3_rtc_driver-to-dev_pm_ops drivers/rtc/rtc-puv3.c
--- a/drivers/rtc/rtc-puv3.c~rtc-rtc-puv3-convert-puv3_rtc_driver-to-dev_pm_ops
+++ a/drivers/rtc/rtc-puv3.c
@@ -207,14 +207,14 @@ static const struct rtc_class_ops puv3_r
 	.proc	        = puv3_rtc_proc,
 };
 
-static void puv3_rtc_enable(struct platform_device *pdev, int en)
+static void puv3_rtc_enable(struct device *dev, int en)
 {
 	if (!en) {
 		writel(readl(RTC_RTSR) & ~RTC_RTSR_HZE, RTC_RTSR);
 	} else {
 		/* re-enable the device, and check it is ok */
 		if ((readl(RTC_RTSR) & RTC_RTSR_HZE) == 0) {
-			dev_info(&pdev->dev, "rtc disabled, re-enabling\n");
+			dev_info(dev, "rtc disabled, re-enabling\n");
 			writel(readl(RTC_RTSR) | RTC_RTSR_HZE, RTC_RTSR);
 		}
 	}
@@ -276,7 +276,7 @@ static int puv3_rtc_probe(struct platfor
 		goto err_nores;
 	}
 
-	puv3_rtc_enable(pdev, 1);
+	puv3_rtc_enable(&pdev->dev, 1);
 
 	/* register RTC and exit */
 	rtc = rtc_device_register("pkunity", &pdev->dev, &puv3_rtcops,
@@ -296,44 +296,41 @@ static int puv3_rtc_probe(struct platfor
 	return 0;
 
  err_nortc:
-	puv3_rtc_enable(pdev, 0);
+	puv3_rtc_enable(&pdev->dev, 0);
 	release_resource(puv3_rtc_mem);
 
  err_nores:
 	return ret;
 }
 
-#ifdef CONFIG_PM
-
+#ifdef CONFIG_PM_SLEEP
 static int ticnt_save;
 
-static int puv3_rtc_suspend(struct platform_device *pdev, pm_message_t state)
+static int puv3_rtc_suspend(struct device *dev)
 {
 	/* save RTAR for anyone using periodic interrupts */
 	ticnt_save = readl(RTC_RTAR);
-	puv3_rtc_enable(pdev, 0);
+	puv3_rtc_enable(dev, 0);
 	return 0;
 }
 
-static int puv3_rtc_resume(struct platform_device *pdev)
+static int puv3_rtc_resume(struct device *dev)
 {
-	puv3_rtc_enable(pdev, 1);
+	puv3_rtc_enable(dev, 1);
 	writel(ticnt_save, RTC_RTAR);
 	return 0;
 }
-#else
-#define puv3_rtc_suspend NULL
-#define puv3_rtc_resume  NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(puv3_rtc_pm_ops, puv3_rtc_suspend, puv3_rtc_resume);
+
 static struct platform_driver puv3_rtc_driver = {
 	.probe		= puv3_rtc_probe,
 	.remove		= puv3_rtc_remove,
-	.suspend	= puv3_rtc_suspend,
-	.resume		= puv3_rtc_resume,
 	.driver		= {
 		.name	= "PKUnity-v3-RTC",
 		.owner	= THIS_MODULE,
+		.pm	= &puv3_rtc_pm_ops,
 	}
 };
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

