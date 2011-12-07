From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-wm831xc-remove-unused-period-irq-handler.patch added to -mm tree
Date: Wed, 07 Dec 2011 14:26:09 -0800
Message-ID: <201112072226.pB7MQ9BT021214@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:58663 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752Ab1LGW0L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Dec 2011 17:26:11 -0500
Received: by yenm5 with SMTP id m5so145264yen.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Dec 2011 14:26:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, a.zummo@towertech.it


The patch titled
     Subject: drivers/rtc/rtc-wm831x.c: remove unused period IRQ handler
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-wm831xc-remove-unused-period-irq-handler.patch

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
Subject: drivers/rtc/rtc-wm831x.c: remove unused period IRQ handler

Due to changes in the RTC core the period interrupt is now unused so
delete the code managing it.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-wm831x.c |   20 --------------------
 1 file changed, 20 deletions(-)

diff -puN drivers/rtc/rtc-wm831x.c~drivers-rtc-rtc-wm831xc-remove-unused-period-irq-handler drivers/rtc/rtc-wm831x.c
--- a/drivers/rtc/rtc-wm831x.c~drivers-rtc-rtc-wm831xc-remove-unused-period-irq-handler
+++ a/drivers/rtc/rtc-wm831x.c
@@ -324,15 +324,6 @@ static irqreturn_t wm831x_alm_irq(int ir
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t wm831x_per_irq(int irq, void *data)
-{
-	struct wm831x_rtc *wm831x_rtc = data;
-
-	rtc_update_irq(wm831x_rtc->rtc, 1, RTC_IRQF | RTC_UF);
-
-	return IRQ_HANDLED;
-}
-
 static const struct rtc_class_ops wm831x_rtc_ops = {
 	.read_time = wm831x_rtc_readtime,
 	.set_mmss = wm831x_rtc_set_mmss,
@@ -405,7 +396,6 @@ static int wm831x_rtc_probe(struct platf
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
 	struct wm831x_rtc *wm831x_rtc;
-	int per_irq = platform_get_irq_byname(pdev, "PER");
 	int alm_irq = platform_get_irq_byname(pdev, "ALM");
 	int ret = 0;
 
@@ -433,14 +423,6 @@ static int wm831x_rtc_probe(struct platf
 		goto err;
 	}
 
-	ret = request_threaded_irq(per_irq, NULL, wm831x_per_irq,
-				   IRQF_TRIGGER_RISING, "RTC period",
-				   wm831x_rtc);
-	if (ret != 0) {
-		dev_err(&pdev->dev, "Failed to request periodic IRQ %d: %d\n",
-			per_irq, ret);
-	}
-
 	ret = request_threaded_irq(alm_irq, NULL, wm831x_alm_irq,
 				   IRQF_TRIGGER_RISING, "RTC alarm",
 				   wm831x_rtc);
@@ -459,11 +441,9 @@ err:
 static int __devexit wm831x_rtc_remove(struct platform_device *pdev)
 {
 	struct wm831x_rtc *wm831x_rtc = platform_get_drvdata(pdev);
-	int per_irq = platform_get_irq_byname(pdev, "PER");
 	int alm_irq = platform_get_irq_byname(pdev, "ALM");
 
 	free_irq(alm_irq, wm831x_rtc);
-	free_irq(per_irq, wm831x_rtc);
 	rtc_device_unregister(wm831x_rtc->rtc);
 	kfree(wm831x_rtc);
 
_
Subject: Subject: drivers/rtc/rtc-wm831x.c: remove unused period IRQ handler

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch
backlight-convert-drivers-video-backlight-to-use-module_platform_driver.patch
leds-convert-led-platform-drivers-to-module_platform_driver.patch
leds-convert-led-i2c-drivers-to-module_i2c_driver.patch
leds-convert-leds-dac124s085-to-module_spi_driver.patch
drivers-rtc-rtc-wm831xc-remove-unused-period-irq-handler.patch
drivers-rtc-rtc-wm831xc-convert-to-devm_kzalloc.patch

