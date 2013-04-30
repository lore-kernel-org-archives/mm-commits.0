From: akpm@linux-foundation.org
Subject: [merged] backlight-adp5520-convert-adp5520_bl-to-dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:51:47 -0700
Message-ID: <20130430185147.6ADDC5A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:41768 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab3D3Svs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:51:48 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so86208ggm.5
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:51:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: adp5520: convert adp5520_bl to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     backlight-adp5520-convert-adp5520_bl-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: adp5520: convert adp5520_bl to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp5520_bl.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff -puN drivers/video/backlight/adp5520_bl.c~backlight-adp5520-convert-adp5520_bl-to-dev_pm_ops drivers/video/backlight/adp5520_bl.c
--- a/drivers/video/backlight/adp5520_bl.c~backlight-adp5520-convert-adp5520_bl-to-dev_pm_ops
+++ a/drivers/video/backlight/adp5520_bl.c
@@ -349,35 +349,34 @@ static int adp5520_bl_remove(struct plat
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int adp5520_bl_suspend(struct platform_device *pdev,
-				 pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int adp5520_bl_suspend(struct device *dev)
 {
-	struct backlight_device *bl = platform_get_drvdata(pdev);
+	struct backlight_device *bl = dev_get_drvdata(dev);
+
 	return adp5520_bl_set(bl, 0);
 }
 
-static int adp5520_bl_resume(struct platform_device *pdev)
+static int adp5520_bl_resume(struct device *dev)
 {
-	struct backlight_device *bl = platform_get_drvdata(pdev);
+	struct backlight_device *bl = dev_get_drvdata(dev);
 
 	backlight_update_status(bl);
 	return 0;
 }
-#else
-#define adp5520_bl_suspend	NULL
-#define adp5520_bl_resume	NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(adp5520_bl_pm_ops, adp5520_bl_suspend,
+			adp5520_bl_resume);
+
 static struct platform_driver adp5520_bl_driver = {
 	.driver		= {
 		.name	= "adp5520-backlight",
 		.owner	= THIS_MODULE,
+		.pm	= &adp5520_bl_pm_ops,
 	},
 	.probe		= adp5520_bl_probe,
 	.remove		= adp5520_bl_remove,
-	.suspend	= adp5520_bl_suspend,
-	.resume		= adp5520_bl_resume,
 };
 
 module_platform_driver(adp5520_bl_driver);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

