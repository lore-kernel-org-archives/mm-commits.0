From: akpm@linux-foundation.org
Subject: + backlight-convert-pwm_bl-to-dev_pm_ops.patch added to -mm tree
Date: Wed, 04 Jan 2012 14:34:38 -0800
Message-ID: <20120104223439.9B93520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:32895 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115Ab2ADWem (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2012 17:34:42 -0500
Received: by eaak10 with SMTP id k10so338639eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Jan 2012 14:34:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, FlorianSchandinat@gmx.de, rpurdie@rpsys.net


The patch titled
     Subject: backlight: convert pwm_bl to dev_pm_ops
has been added to the -mm tree.  Its filename is
     backlight-convert-pwm_bl-to-dev_pm_ops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: backlight: convert pwm_bl to dev_pm_ops

Should be no functional changes, mainly a reorganisation to support future
work.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/pwm_bl.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff -puN drivers/video/backlight/pwm_bl.c~backlight-convert-pwm_bl-to-dev_pm_ops drivers/video/backlight/pwm_bl.c
--- a/drivers/video/backlight/pwm_bl.c~backlight-convert-pwm_bl-to-dev_pm_ops
+++ a/drivers/video/backlight/pwm_bl.c
@@ -169,10 +169,9 @@ static int pwm_backlight_remove(struct p
 }
 
 #ifdef CONFIG_PM
-static int pwm_backlight_suspend(struct platform_device *pdev,
-				 pm_message_t state)
+static int pwm_backlight_suspend(struct device *dev)
 {
-	struct backlight_device *bl = platform_get_drvdata(pdev);
+	struct backlight_device *bl = dev_get_drvdata(dev);
 	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
 
 	if (pb->notify)
@@ -184,27 +183,29 @@ static int pwm_backlight_suspend(struct 
 	return 0;
 }
 
-static int pwm_backlight_resume(struct platform_device *pdev)
+static int pwm_backlight_resume(struct device *dev)
 {
-	struct backlight_device *bl = platform_get_drvdata(pdev);
+	struct backlight_device *bl = dev_get_drvdata(dev);
 
 	backlight_update_status(bl);
 	return 0;
 }
+
+static SIMPLE_DEV_PM_OPS(pwm_backlight_pm_ops, pwm_backlight_suspend,
+			 pwm_backlight_resume);
+
 #else
-#define pwm_backlight_suspend	NULL
-#define pwm_backlight_resume	NULL
+#define pwm_backlight_pm_ops	NULL
 #endif
 
 static struct platform_driver pwm_backlight_driver = {
 	.driver		= {
 		.name	= "pwm-backlight",
 		.owner	= THIS_MODULE,
+		.pm	= &pwm_backlight_pm_ops,
 	},
 	.probe		= pwm_backlight_probe,
 	.remove		= pwm_backlight_remove,
-	.suspend	= pwm_backlight_suspend,
-	.resume		= pwm_backlight_resume,
 };
 
 module_platform_driver(pwm_backlight_driver);
_
Subject: Subject: backlight: convert pwm_bl to dev_pm_ops

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch
backlight-convert-drivers-video-backlight-to-use-module_platform_driver.patch
backlight-convert-platform_lcd-to-devm_kzalloc.patch
backlight-convert-pwm_bl-to-dev_pm_ops.patch
backlight-convert-pwm_bl-to-dev_pm_ops-fix.patch
leds-convert-led-platform-drivers-to-module_platform_driver.patch
leds-convert-led-i2c-drivers-to-module_i2c_driver.patch
leds-convert-leds-dac124s085-to-module_spi_driver.patch
leds-convert-wm831x-status-driver-to-devm_kzalloc.patch
leds-convert-wm8350-driver-to-devm_kzalloc.patch
drivers-rtc-rtc-wm831xc-remove-unused-period-irq-handler.patch
drivers-rtc-rtc-wm831xc-convert-to-devm_kzalloc.patch
rtc-convert-drivers-rtc-to-use-module_platform_driver.patch
drivers-rtc-interfacec-fix-alarm-rollover-when-day-or-month-is-out-of-range.patch

