From: akpm@linux-foundation.org
Subject: + backlight-convert-platform_lcd-to-devm_kzalloc.patch added to -mm tree
Date: Wed, 04 Jan 2012 14:34:34 -0800
Message-ID: <20120104223435.7EBC95C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:41848 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115Ab2ADWeh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2012 17:34:37 -0500
Received: by eekc1 with SMTP id c1so616923eek.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Jan 2012 14:34:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, FlorianSchandinat@gmx.de, rpurdie@rpsys.net


The patch titled
     Subject: backlight: convert platform_lcd to devm_kzalloc()
has been added to the -mm tree.  Its filename is
     backlight-convert-platform_lcd-to-devm_kzalloc.patch

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
Subject: backlight: convert platform_lcd to devm_kzalloc()

Saves some error handling code and eliminates a class of leaks.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/platform_lcd.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/platform_lcd.c~backlight-convert-platform_lcd-to-devm_kzalloc drivers/video/backlight/platform_lcd.c
--- a/drivers/video/backlight/platform_lcd.c~backlight-convert-platform_lcd-to-devm_kzalloc
+++ a/drivers/video/backlight/platform_lcd.c
@@ -85,7 +85,8 @@ static int __devinit platform_lcd_probe(
 		return -EINVAL;
 	}
 
-	plcd = kzalloc(sizeof(struct platform_lcd), GFP_KERNEL);
+	plcd = devm_kzalloc(&pdev->dev, sizeof(struct platform_lcd),
+			    GFP_KERNEL);
 	if (!plcd) {
 		dev_err(dev, "no memory for state\n");
 		return -ENOMEM;
@@ -98,7 +99,7 @@ static int __devinit platform_lcd_probe(
 	if (IS_ERR(plcd->lcd)) {
 		dev_err(dev, "cannot register lcd device\n");
 		err = PTR_ERR(plcd->lcd);
-		goto err_mem;
+		goto err;
 	}
 
 	platform_set_drvdata(pdev, plcd);
@@ -106,8 +107,7 @@ static int __devinit platform_lcd_probe(
 
 	return 0;
 
- err_mem:
-	kfree(plcd);
+ err:
 	return err;
 }
 
@@ -116,7 +116,6 @@ static int __devexit platform_lcd_remove
 	struct platform_lcd *plcd = platform_get_drvdata(pdev);
 
 	lcd_device_unregister(plcd->lcd);
-	kfree(plcd);
 
 	return 0;
 }
_
Subject: Subject: backlight: convert platform_lcd to devm_kzalloc()

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

