From: akpm@linux-foundation.org
Subject: + leds-convert-wm8350-driver-to-devm_kzalloc.patch added to -mm tree
Date: Fri, 16 Dec 2011 15:47:56 -0800
Message-ID: <20111216234757.9340B20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:51991 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760045Ab1LPXsA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Dec 2011 18:48:00 -0500
Received: by lagu2 with SMTP id u2so116668lag.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2011 15:47:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, rpurdie@rpsys.net


The patch titled
     Subject: leds: convert wm8350 driver to devm_kzalloc()
has been added to the -mm tree.  Its filename is
     leds-convert-wm8350-driver-to-devm_kzalloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: leds: convert wm8350 driver to devm_kzalloc()

Saves a small amount of code and systematically eliminates leaks.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-wm8350.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/leds/leds-wm8350.c~leds-convert-wm8350-driver-to-devm_kzalloc drivers/leds/leds-wm8350.c
--- a/drivers/leds/leds-wm8350.c~leds-convert-wm8350-driver-to-devm_kzalloc
+++ a/drivers/leds/leds-wm8350.c
@@ -227,7 +227,7 @@ static int wm8350_led_probe(struct platf
 		goto err_isink;
 	}
 
-	led = kzalloc(sizeof(*led), GFP_KERNEL);
+	led = devm_kzalloc(&pdev->dev, sizeof(*led), GFP_KERNEL);
 	if (led == NULL) {
 		ret = -ENOMEM;
 		goto err_dcdc;
@@ -259,12 +259,10 @@ static int wm8350_led_probe(struct platf
 
 	ret = led_classdev_register(&pdev->dev, &led->cdev);
 	if (ret < 0)
-		goto err_led;
+		goto err_dcdc;
 
 	return 0;
 
- err_led:
-	kfree(led);
  err_dcdc:
 	regulator_put(dcdc);
  err_isink:
@@ -281,7 +279,6 @@ static int wm8350_led_remove(struct plat
 	wm8350_led_disable(led);
 	regulator_put(led->dcdc);
 	regulator_put(led->isink);
-	kfree(led);
 	return 0;
 }
 
_
Subject: Subject: leds: convert wm8350 driver to devm_kzalloc()

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch
backlight-convert-drivers-video-backlight-to-use-module_platform_driver.patch
leds-convert-led-platform-drivers-to-module_platform_driver.patch
leds-convert-led-i2c-drivers-to-module_i2c_driver.patch
leds-convert-leds-dac124s085-to-module_spi_driver.patch
leds-convert-wm831x-status-driver-to-devm_kzalloc.patch
leds-convert-wm8350-driver-to-devm_kzalloc.patch
drivers-rtc-rtc-wm831xc-remove-unused-period-irq-handler.patch
drivers-rtc-rtc-wm831xc-convert-to-devm_kzalloc.patch

