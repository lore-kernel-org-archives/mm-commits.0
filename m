From: akpm@linux-foundation.org
Subject: + backlight-convert-platform_lcd-to-dev_pm_ops.patch added to -mm tree
Date: Tue, 21 Feb 2012 14:06:34 -0800
Message-ID: <20120221220634.84849A0331@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:45100 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab2BUWGg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Feb 2012 17:06:36 -0500
Received: by wgbds12 with SMTP id ds12so246010wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 21 Feb 2012 14:06:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: convert platform_lcd to dev_pm_ops
has been added to the -mm tree.  Its filename is
     backlight-convert-platform_lcd-to-dev_pm_ops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: backlight: convert platform_lcd to dev_pm_ops

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
backlight-convert-backlight-spi-drivers-to-module_spi_driver.patch
backlight-convert-platform_lcd-to-dev_pm_ops.patch

