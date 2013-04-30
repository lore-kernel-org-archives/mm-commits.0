From: akpm@linux-foundation.org
Subject: [merged] backlight-lm3533_bl-convert-lm3533_bl-to-dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:52:05 -0700
Message-ID: <20130430185205.7321C5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:43334 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077Ab3D3SwG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:52:06 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so86321qen.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:52:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: lm3533_bl: convert lm3533_bl to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     backlight-lm3533_bl-convert-lm3533_bl-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: lm3533_bl: convert lm3533_bl to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lm3533_bl.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff -puN drivers/video/backlight/lm3533_bl.c~backlight-lm3533_bl-convert-lm3533_bl-to-dev_pm_ops drivers/video/backlight/lm3533_bl.c
--- a/drivers/video/backlight/lm3533_bl.c~backlight-lm3533_bl-convert-lm3533_bl-to-dev_pm_ops
+++ a/drivers/video/backlight/lm3533_bl.c
@@ -368,29 +368,28 @@ static int lm3533_bl_remove(struct platf
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int lm3533_bl_suspend(struct platform_device *pdev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int lm3533_bl_suspend(struct device *dev)
 {
-	struct lm3533_bl *bl = platform_get_drvdata(pdev);
+	struct lm3533_bl *bl = dev_get_drvdata(dev);
 
-	dev_dbg(&pdev->dev, "%s\n", __func__);
+	dev_dbg(dev, "%s\n", __func__);
 
 	return lm3533_ctrlbank_disable(&bl->cb);
 }
 
-static int lm3533_bl_resume(struct platform_device *pdev)
+static int lm3533_bl_resume(struct device *dev)
 {
-	struct lm3533_bl *bl = platform_get_drvdata(pdev);
+	struct lm3533_bl *bl = dev_get_drvdata(dev);
 
-	dev_dbg(&pdev->dev, "%s\n", __func__);
+	dev_dbg(dev, "%s\n", __func__);
 
 	return lm3533_ctrlbank_enable(&bl->cb);
 }
-#else
-#define lm3533_bl_suspend	NULL
-#define lm3533_bl_resume	NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(lm3533_bl_pm_ops, lm3533_bl_suspend, lm3533_bl_resume);
+
 static void lm3533_bl_shutdown(struct platform_device *pdev)
 {
 	struct lm3533_bl *bl = platform_get_drvdata(pdev);
@@ -404,12 +403,11 @@ static struct platform_driver lm3533_bl_
 	.driver = {
 		.name	= "lm3533-backlight",
 		.owner	= THIS_MODULE,
+		.pm	= &lm3533_bl_pm_ops,
 	},
 	.probe		= lm3533_bl_probe,
 	.remove		= lm3533_bl_remove,
 	.shutdown	= lm3533_bl_shutdown,
-	.suspend	= lm3533_bl_suspend,
-	.resume		= lm3533_bl_resume,
 };
 module_platform_driver(lm3533_bl_driver);
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

