From: akpm@linux-foundation.org
Subject: - leds-call-gpio_cansleep-only-after-gpio_request-succeeded.patch removed from -mm tree
Date: Mon, 10 Mar 2008 11:05:47 -0700
Message-ID: <200803101805.m2AI5l8i030130@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753802AbYCJSHM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 14:07:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Uwe.Kleine-Koenig@digi.com, dbrownell@users.sourceforge.net, raph@8d.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: call gpio_cansleep only after gpio_request succeeded
has been removed from the -mm tree.  Its filename was
     leds-call-gpio_cansleep-only-after-gpio_request-succeeded.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
