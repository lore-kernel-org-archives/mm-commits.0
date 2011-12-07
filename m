From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-wm831xc-convert-to-devm_kzalloc.patch added to -mm tree
Date: Wed, 07 Dec 2011 14:26:01 -0800
Message-ID: <201112072226.pB7MQ2bB026153@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:36403 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757752Ab1LGW0K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Dec 2011 17:26:10 -0500
Received: by ggnp2 with SMTP id p2so126940ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 07 Dec 2011 14:26:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, a.zummo@towertech.it, plagnioj@jcrosoft.com


The patch titled
     Subject: drivers/rtc/rtc-wm831x.c: convert to devm_kzalloc()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-wm831xc-convert-to-devm_kzalloc.patch

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
Subject: drivers/rtc/rtc-wm831x.c: convert to devm_kzalloc()

Marginally less code and eliminate the possibility of memory leaks.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-wm831x.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-wm831x.c~drivers-rtc-rtc-wm831xc-convert-to-devm_kzalloc drivers/rtc/rtc-wm831x.c
--- a/drivers/rtc/rtc-wm831x.c~drivers-rtc-rtc-wm831xc-convert-to-devm_kzalloc
+++ a/drivers/rtc/rtc-wm831x.c
@@ -399,7 +399,7 @@ static int wm831x_rtc_probe(struct platf
 	int alm_irq = platform_get_irq_byname(pdev, "ALM");
 	int ret = 0;
 
-	wm831x_rtc = kzalloc(sizeof(*wm831x_rtc), GFP_KERNEL);
+	wm831x_rtc = devm_kzalloc(&pdev->dev, sizeof(*wm831x_rtc), GFP_KERNEL);
 	if (wm831x_rtc == NULL)
 		return -ENOMEM;
 
@@ -434,7 +434,6 @@ static int wm831x_rtc_probe(struct platf
 	return 0;
 
 err:
-	kfree(wm831x_rtc);
 	return ret;
 }
 
@@ -445,7 +444,6 @@ static int __devexit wm831x_rtc_remove(s
 
 	free_irq(alm_irq, wm831x_rtc);
 	rtc_device_unregister(wm831x_rtc->rtc);
-	kfree(wm831x_rtc);
 
 	return 0;
 }
_
Subject: Subject: drivers/rtc/rtc-wm831x.c: convert to devm_kzalloc()

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch
backlight-convert-drivers-video-backlight-to-use-module_platform_driver.patch
leds-convert-led-platform-drivers-to-module_platform_driver.patch
leds-convert-led-i2c-drivers-to-module_i2c_driver.patch
leds-convert-leds-dac124s085-to-module_spi_driver.patch
drivers-rtc-rtc-wm831xc-remove-unused-period-irq-handler.patch
drivers-rtc-rtc-wm831xc-convert-to-devm_kzalloc.patch

