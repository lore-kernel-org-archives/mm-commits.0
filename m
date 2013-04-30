From: akpm@linux-foundation.org
Subject: [merged] backlight-ep93xx-convert-ep93xx-to-dev_pm_ops.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:51:57 -0700
Message-ID: <20130430185157.6F5F75A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:45185 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab3D3Sv6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:51:58 -0400
Received: by mail-ve0-f202.google.com with SMTP id ox1so76984veb.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:51:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: ep93xx: convert ep93xx to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     backlight-ep93xx-convert-ep93xx-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: ep93xx: convert ep93xx to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ep93xx_bl.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN drivers/video/backlight/ep93xx_bl.c~backlight-ep93xx-convert-ep93xx-to-dev_pm_ops drivers/video/backlight/ep93xx_bl.c
--- a/drivers/video/backlight/ep93xx_bl.c~backlight-ep93xx-convert-ep93xx-to-dev_pm_ops
+++ a/drivers/video/backlight/ep93xx_bl.c
@@ -115,35 +115,33 @@ static int ep93xxbl_remove(struct platfo
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int ep93xxbl_suspend(struct platform_device *dev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int ep93xxbl_suspend(struct device *dev)
 {
-	struct backlight_device *bl = platform_get_drvdata(dev);
+	struct backlight_device *bl = dev_get_drvdata(dev);
 
 	return ep93xxbl_set(bl, 0);
 }
 
-static int ep93xxbl_resume(struct platform_device *dev)
+static int ep93xxbl_resume(struct device *dev)
 {
-	struct backlight_device *bl = platform_get_drvdata(dev);
+	struct backlight_device *bl = dev_get_drvdata(dev);
 
 	backlight_update_status(bl);
 	return 0;
 }
-#else
-#define ep93xxbl_suspend	NULL
-#define ep93xxbl_resume		NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(ep93xxbl_pm_ops, ep93xxbl_suspend, ep93xxbl_resume);
+
 static struct platform_driver ep93xxbl_driver = {
 	.driver		= {
 		.name	= "ep93xx-bl",
 		.owner	= THIS_MODULE,
+		.pm	= &ep93xxbl_pm_ops,
 	},
 	.probe		= ep93xxbl_probe,
 	.remove		= ep93xxbl_remove,
-	.suspend	= ep93xxbl_suspend,
-	.resume		= ep93xxbl_resume,
 };
 
 module_platform_driver(ep93xxbl_driver);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

