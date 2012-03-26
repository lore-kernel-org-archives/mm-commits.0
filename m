From: akpm@linux-foundation.org
Subject: [merged] backlight-convert-platform_lcd-to-dev_pm_ops.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:29:06 -0700
Message-ID: <20120326192906.65708A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:46715 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2CZT3I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:29:08 -0400
Received: by mail-fa0-f74.google.com with SMTP id a19so298392faa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:29:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: convert platform_lcd to dev_pm_ops
has been removed from the -mm tree.  Its filename was
     backlight-convert-platform_lcd-to-dev_pm_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: convert platform_lcd to dev_pm_ops

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/platform_lcd.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN drivers/video/backlight/platform_lcd.c~backlight-convert-platform_lcd-to-dev_pm_ops drivers/video/backlight/platform_lcd.c
--- a/drivers/video/backlight/platform_lcd.c~backlight-convert-platform_lcd-to-dev_pm_ops
+++ a/drivers/video/backlight/platform_lcd.c
@@ -121,9 +121,9 @@ static int __devexit platform_lcd_remove
 }
 
 #ifdef CONFIG_PM
-static int platform_lcd_suspend(struct platform_device *pdev, pm_message_t st)
+static int platform_lcd_suspend(struct device *dev)
 {
-	struct platform_lcd *plcd = platform_get_drvdata(pdev);
+	struct platform_lcd *plcd = dev_get_drvdata(dev);
 
 	plcd->suspended = 1;
 	platform_lcd_set_power(plcd->lcd, plcd->power);
@@ -131,29 +131,30 @@ static int platform_lcd_suspend(struct p
 	return 0;
 }
 
-static int platform_lcd_resume(struct platform_device *pdev)
+static int platform_lcd_resume(struct device *dev)
 {
-	struct platform_lcd *plcd = platform_get_drvdata(pdev);
+	struct platform_lcd *plcd = dev_get_drvdata(dev);
 
 	plcd->suspended = 0;
 	platform_lcd_set_power(plcd->lcd, plcd->power);
 
 	return 0;
 }
-#else
-#define platform_lcd_suspend NULL
-#define platform_lcd_resume NULL
+
+static SIMPLE_DEV_PM_OPS(platform_lcd_pm_ops, platform_lcd_suspend,
+			platform_lcd_resume);
 #endif
 
 static struct platform_driver platform_lcd_driver = {
 	.driver		= {
 		.name	= "platform-lcd",
 		.owner	= THIS_MODULE,
+#ifdef CONFIG_PM
+		.pm	= &platform_lcd_pm_ops,
+#endif
 	},
 	.probe		= platform_lcd_probe,
 	.remove		= __devexit_p(platform_lcd_remove),
-	.suspend        = platform_lcd_suspend,
-	.resume         = platform_lcd_resume,
 };
 
 module_platform_driver(platform_lcd_driver);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch

