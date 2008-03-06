From: akpm@linux-foundation.org
Subject: + leds-call-gpio_cansleep-only-after-gpio_request-succeeded.patch added to -mm tree
Date: Thu, 06 Mar 2008 14:43:49 -0800
Message-ID: <200803062243.m26MhnTN022188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757211AbYCFWpF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:45:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Uwe.Kleine-Koenig@digi.com, dbrownell@users.sourceforge.net, raph@8d.com, rpurdie@rpsys.net


The patch titled
     leds: call gpio_cansleep only after gpio_request succeeded
has been added to the -mm tree.  Its filename is
     leds-call-gpio_cansleep-only-after-gpio_request-succeeded.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: call gpio_cansleep only after gpio_request succeeded
From: Uwe Kleine-Koeni <Uwe.Kleine-Koenig@digi.com>

If you have GPIO_LIB gpio_cansleep oopses on an invalid gpio.  So better
gpio_request your pin first.

Signed-off-by: Uwe Kleine-Koeni <Uwe.Kleine-Koenig@digi.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Raphael Assenat <raph@8d.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-gpio.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/leds/leds-gpio.c~leds-call-gpio_cansleep-only-after-gpio_request-succeeded drivers/leds/leds-gpio.c
--- a/drivers/leds/leds-gpio.c~leds-call-gpio_cansleep-only-after-gpio_request-succeeded
+++ a/drivers/leds/leds-gpio.c
@@ -79,6 +79,10 @@ static int gpio_led_probe(struct platfor
 		cur_led = &pdata->leds[i];
 		led_dat = &leds_data[i];
 
+		ret = gpio_request(cur_led->gpio, cur_led->name);
+		if (ret < 0)
+			goto err;
+
 		led_dat->cdev.name = cur_led->name;
 		led_dat->cdev.default_trigger = cur_led->default_trigger;
 		led_dat->gpio = cur_led->gpio;
@@ -87,10 +91,6 @@ static int gpio_led_probe(struct platfor
 		led_dat->cdev.brightness_set = gpio_led_set;
 		led_dat->cdev.brightness = LED_OFF;
 
-		ret = gpio_request(led_dat->gpio, led_dat->cdev.name);
-		if (ret < 0)
-			goto err;
