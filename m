From: akpm@linux-foundation.org
Subject: [merged] leds-fix-coding-style-in-worker-thread-code-for-ledtrig-gpio.patch removed from -mm tree
Date: Tue, 08 Sep 2009 14:26:19 -0700
Message-ID: <200909082126.n88LQJOU006730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751926AbZIHV0a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2009 17:26:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cascardo@holoscopio.com, rpurdie@rpsys.net, srcvale@holoscopio.com, mm-commits@vger.kernel.org


The patch titled
     leds: fix coding style in worker thread code for ledtrig-gpio.
has been removed from the -mm tree.  Its filename was
     leds-fix-coding-style-in-worker-thread-code-for-ledtrig-gpio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: fix coding style in worker thread code for ledtrig-gpio.
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Signed-off-by: Samuel R. C. Vale <srcvale@holoscopio.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/ledtrig-gpio.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN drivers/leds/ledtrig-gpio.c~leds-fix-coding-style-in-worker-thread-code-for-ledtrig-gpio drivers/leds/ledtrig-gpio.c
--- a/drivers/leds/ledtrig-gpio.c~leds-fix-coding-style-in-worker-thread-code-for-ledtrig-gpio
+++ a/drivers/leds/ledtrig-gpio.c
@@ -44,22 +44,22 @@ static void gpio_trig_work(struct work_s
 			struct gpio_trig_data, work);
 	int tmp;
 
-       if (!gpio_data->gpio)
-	       return;
+	if (!gpio_data->gpio)
+		return;
 
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

linux-next.patch

