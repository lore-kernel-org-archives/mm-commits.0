From: akpm@linux-foundation.org
Subject: + drivers-leds-leds-mc13783c-fix-off-by-one-for-checking-num_leds.patch added to -mm tree
Date: Thu, 15 Dec 2011 13:29:15 -0800
Message-ID: <20111215212916.0B1BE5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:46788 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab1LOV3S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2011 16:29:18 -0500
Received: by eaad1 with SMTP id d1so71838eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2011 13:29:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, philippe.retornaz@epfl.ch, rpurdie@rpsys.net


The patch titled
     Subject: drivers/leds/leds-mc13783.c: fix off-by-one for checking num_leds
has been added to the -mm tree.  Its filename is
     drivers-leds-leds-mc13783c-fix-off-by-one-for-checking-num_leds.patch

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
Subject: drivers/leds/leds-mc13783.c: fix off-by-one for checking num_leds

The LED id begins from 0.  Thus the maximum number of leds should be
MC13783_LED_MAX + 1.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Philippe Retornaz <philippe.retornaz@epfl.ch>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-mc13783.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/leds/leds-mc13783.c~drivers-leds-leds-mc13783c-fix-off-by-one-for-checking-num_leds drivers/leds/leds-mc13783.c
--- a/drivers/leds/leds-mc13783.c~drivers-leds-leds-mc13783c-fix-off-by-one-for-checking-num_leds
+++ a/drivers/leds/leds-mc13783.c
@@ -275,7 +275,7 @@ static int __devinit mc13783_led_probe(s
 		return -ENODEV;
 	}
 
-	if (pdata->num_leds < 1 || pdata->num_leds > MC13783_LED_MAX) {
+	if (pdata->num_leds < 1 || pdata->num_leds > (MC13783_LED_MAX + 1)) {
 		dev_err(&pdev->dev, "Invalid led count %d\n", pdata->num_leds);
 		return -EINVAL;
 	}
_
Subject: Subject: drivers/leds/leds-mc13783.c: fix off-by-one for checking num_leds

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
backlight-convert-drivers-video-backlight-to-use-module_platform_driver.patch
leds-convert-led-platform-drivers-to-module_platform_driver.patch
leds-convert-led-i2c-drivers-to-module_i2c_driver.patch
leds-convert-leds-dac124s085-to-module_spi_driver.patch
drivers-leds-leds-lp5523c-remove-unneeded-forward-declaration.patch
leds-bd2802-use-gpio_request_one.patch
leds-netxbig-use-gpio_request_one.patch
drivers-leds-leds-mc13783c-fix-off-by-one-for-checking-num_leds.patch

