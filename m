From: akpm@linux-foundation.org
Subject: + leds-bd2802-use-gpio_request_one.patch added to -mm tree
Date: Thu, 01 Dec 2011 12:51:55 -0800
Message-ID: <201112012051.pB1KptBn017619@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:33743 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab1LAUv5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Dec 2011 15:51:57 -0500
Received: by yenr11 with SMTP id r11so153575yen.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Dec 2011 12:51:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, q1.kim@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/leds/leds-bd2802.c: use gpio_request_one()
has been added to the -mm tree.  Its filename is
     leds-bd2802-use-gpio_request_one.patch

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
From: Axel Lin <axel.lin@gmail.com>
Subject: drivers/leds/leds-bd2802.c: use gpio_request_one()

Use gpio_request_one() instead of multiple gpiolib calls.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Kim Kyuwon <q1.kim@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-bd2802.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/leds/leds-bd2802.c~leds-bd2802-use-gpio_request_one drivers/leds/leds-bd2802.c
--- a/drivers/leds/leds-bd2802.c~leds-bd2802-use-gpio_request_one
+++ a/drivers/leds/leds-bd2802.c
@@ -688,8 +688,7 @@ static int __devinit bd2802_probe(struct
 	i2c_set_clientdata(client, led);
 
 	/* Configure RESET GPIO (L: RESET, H: RESET cancel) */
-	gpio_request(pdata->reset_gpio, "RGB_RESETB");
-	gpio_direction_output(pdata->reset_gpio, 1);
+	gpio_request_one(pdata->reset_gpio, GPIOF_OUT_INIT_HIGH, "RGB_RESETB");
 
 	/* Tacss = min 0.1ms */
 	udelay(100);
_
Subject: Subject: drivers/leds/leds-bd2802.c: use gpio_request_one()

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
sbus-convert-drivers-sbus-char-to-use-module_platform_driver.patch
backlight-convert-drivers-video-backlight-to-use-module_platform_driver.patch
leds-convert-led-platform-drivers-to-module_platform_driver.patch
leds-convert-led-i2c-drivers-to-module_i2c_driver.patch
leds-convert-leds-dac124s085-to-module_spi_driver.patch
drivers-leds-leds-lp5523c-remove-unneeded-forward-declaration.patch
leds-bd2802-use-gpio_request_one.patch
leds-netxbig-use-gpio_request_one.patch

