From: akpm@linux-foundation.org
Subject: + leds-convert-wm831x-status-driver-to-devm_kzalloc.patch added to -mm tree
Date: Fri, 16 Dec 2011 15:47:52 -0800
Message-ID: <20111216234753.B3FCE20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:62668 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab1LPXr4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2011 18:47:56 -0500
Received: by faar15 with SMTP id r15so138533faa.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2011 15:47:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, rpurdie@rpsys.net


The patch titled
     Subject: leds: convert wm831x status driver to devm_kzalloc()
has been added to the -mm tree.  Its filename is
     leds-convert-wm831x-status-driver-to-devm_kzalloc.patch

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
Subject: leds: convert wm831x status driver to devm_kzalloc()

Saves a small amount of code and systematically eliminates leaks.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-wm831x-status.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/leds/leds-wm831x-status.c~leds-convert-wm831x-status-driver-to-devm_kzalloc drivers/leds/leds-wm831x-status.c
--- a/drivers/leds/leds-wm831x-status.c~leds-convert-wm831x-status-driver-to-devm_kzalloc
+++ a/drivers/leds/leds-wm831x-status.c
@@ -237,7 +237,8 @@ static int wm831x_status_probe(struct pl
 		goto err;
 	}
 
-	drvdata = kzalloc(sizeof(struct wm831x_status), GFP_KERNEL);
+	drvdata = devm_kzalloc(&pdev->dev, sizeof(struct wm831x_status),
+			       GFP_KERNEL);
 	if (!drvdata)
 		return -ENOMEM;
 	dev_set_drvdata(&pdev->dev, drvdata);
@@ -300,7 +301,6 @@ static int wm831x_status_probe(struct pl
 
 err_led:
 	led_classdev_unregister(&drvdata->cdev);
-	kfree(drvdata);
 err:
 	return ret;
 }
@@ -311,7 +311,6 @@ static int wm831x_status_remove(struct p
 
 	device_remove_file(drvdata->cdev.dev, &dev_attr_src);
 	led_classdev_unregister(&drvdata->cdev);
-	kfree(drvdata);
 
 	return 0;
 }
_
Subject: Subject: leds: convert wm831x status driver to devm_kzalloc()

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

