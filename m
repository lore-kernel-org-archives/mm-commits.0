From: akpm@linux-foundation.org
Subject: + leds-netxbig-use-gpio_request_one.patch added to -mm tree
Date: Thu, 01 Dec 2011 12:51:58 -0800
Message-ID: <201112012051.pB1KpxaD017660@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:36088 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab1LAUwD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Dec 2011 15:52:03 -0500
Received: by eekd41 with SMTP id d41so19094eek.1
        for <mm-commits@vger.kernel.org>; Thu, 01 Dec 2011 12:52:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, rpurdie@rpsys.net, sguinot@lacie.com


The patch titled
     Subject: drivers/leds/leds-netxbig.c: use gpio_request_one()
has been added to the -mm tree.  Its filename is
     leds-netxbig-use-gpio_request_one.patch

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
Subject: drivers/leds/leds-netxbig.c: use gpio_request_one()

Use gpio_request_one() instead of multiple gpiolib calls.  This also
simplifies error handling a bit.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Simon Guinot <sguinot@lacie.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-netxbig.c |   24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff -puN drivers/leds/leds-netxbig.c~leds-netxbig-use-gpio_request_one drivers/leds/leds-netxbig.c
--- a/drivers/leds/leds-netxbig.c~leds-netxbig-use-gpio_request_one
+++ a/drivers/leds/leds-netxbig.c
@@ -81,35 +81,23 @@ static int __devinit gpio_ext_init(struc
 
 	/* Configure address GPIOs. */
 	for (i = 0; i < gpio_ext->num_addr; i++) {
-		err = gpio_request(gpio_ext->addr[i], "GPIO extension addr");
+		err = gpio_request_one(gpio_ext->addr[i], GPIOF_OUT_INIT_LOW,
+				       "GPIO extension addr");
 		if (err)
 			goto err_free_addr;
-		err = gpio_direction_output(gpio_ext->addr[i], 0);
-		if (err) {
-			gpio_free(gpio_ext->addr[i]);
-			goto err_free_addr;
-		}
 	}
 	/* Configure data GPIOs. */
 	for (i = 0; i < gpio_ext->num_data; i++) {
-		err = gpio_request(gpio_ext->data[i], "GPIO extension data");
+		err = gpio_request_one(gpio_ext->data[i], GPIOF_OUT_INIT_LOW,
+				   "GPIO extension data");
 		if (err)
 			goto err_free_data;
-		err = gpio_direction_output(gpio_ext->data[i], 0);
-		if (err) {
-			gpio_free(gpio_ext->data[i]);
-			goto err_free_data;
-		}
 	}
 	/* Configure "enable select" GPIO. */
-	err = gpio_request(gpio_ext->enable, "GPIO extension enable");
+	err = gpio_request_one(gpio_ext->enable, GPIOF_OUT_INIT_LOW,
+			       "GPIO extension enable");
 	if (err)
 		goto err_free_data;
-	err = gpio_direction_output(gpio_ext->enable, 0);
-	if (err) {
-		gpio_free(gpio_ext->enable);
-		goto err_free_data;
-	}
 
 	return 0;
 
_
Subject: Subject: drivers/leds/leds-netxbig.c: use gpio_request_one()

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

