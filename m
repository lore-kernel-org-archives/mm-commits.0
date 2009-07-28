From: akpm@linux-foundation.org
Subject: + leds-fix-coding-style-in-worker-thread-code-for-ledtrig-gpio.patch added to -mm tree
Date: Tue, 28 Jul 2009 15:33:29 -0700
Message-ID: <200907282233.n6SMXTUk029826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753306AbZG1WeE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jul 2009 18:34:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cascardo@holoscopio.com, rpurdie@rpsys.net, srcvale@holoscopio.com


The patch titled
     leds: fix coding style in worker thread code for ledtrig-gpio.
has been added to the -mm tree.  Its filename is
     leds-fix-coding-style-in-worker-thread-code-for-ledtrig-gpio.patch

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
Subject: leds: fix coding style in worker thread code for ledtrig-gpio.
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Signed-off-by: Samuel R. C. Vale <srcvale@holoscopio.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/ledtrig-gpio.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN drivers/leds/ledtrig-gpio.c~leds-fix-coding-style-in-worker-thread-code-for-ledtrig-gpio drivers/leds/ledtrig-gpio.c
--- a/drivers/leds/ledtrig-gpio.c~leds-fix-coding-style-in-worker-thread-code-for-ledtrig-gpio
+++ a/drivers/leds/ledtrig-gpio.c
@@ -44,22 +44,22 @@ static void gpio_trig_work(struct work_s
 			struct gpio_trig_data, work);
 	int tmp;
 
-       if (!gpio_data->gpio)
+	if (!gpio_data->gpio)
 	       return;
 
-       tmp = gpio_get_value(gpio_data->gpio);
-       if (gpio_data->inverted)
-	       tmp = !tmp;
-
-       if (tmp) {
-               if (gpio_data->desired_brightness)
-                       led_set_brightness(gpio_data->led,
-                                       gpio_data->desired_brightness);
-               else
-                       led_set_brightness(gpio_data->led, LED_FULL);
-       } else {
-               led_set_brightness(gpio_data->led, LED_OFF);
-       }
+	tmp = gpio_get_value(gpio_data->gpio);
+	if (gpio_data->inverted)
+		tmp = !tmp;
+
+	if (tmp) {
+		if (gpio_data->desired_brightness)
+			led_set_brightness(gpio_data->led,
+					   gpio_data->desired_brightness);
+		else
+			led_set_brightness(gpio_data->led, LED_FULL);
+	} else {
+		led_set_brightness(gpio_data->led, LED_OFF);
+	}
 }
 
 static ssize_t gpio_trig_brightness_show(struct device *dev,
_

Patches currently in -mm which might be from cascardo@holoscopio.com are

rtc-mark-if-rtc-cmos-drivers-were-successfully-registered.patch
linux-next.patch
leds-fix-coding-style-in-worker-thread-code-for-ledtrig-gpio.patch
leds-fix-multiple-requests-and-releases-of-irq-for-gpio-led-trigger.patch
leds-after-setting-inverted-attribute-we-must-update-the-led.patch

