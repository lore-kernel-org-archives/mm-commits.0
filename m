From: akpm@linux-foundation.org
Subject: [merged] leds-fix-multiple-requests-and-releases-of-irq-for-gpio-led-trigger.patch removed from -mm tree
Date: Thu, 27 Aug 2009 12:18:37 -0700
Message-ID: <200908271918.n7RJIbUn010495@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751812AbZH0TSq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Aug 2009 15:18:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cascardo@holoscopio.com, rpurdie@rpsys.net, srcvale@holoscopio.com, mm-commits@vger.kernel.org


The patch titled
     leds: fix multiple requests and releases of IRQ for GPIO LED Trigger
has been removed from the -mm tree.  Its filename was
     leds-fix-multiple-requests-and-releases-of-irq-for-gpio-led-trigger.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: fix multiple requests and releases of IRQ for GPIO LED Trigger
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

When setting the same GPIO number, multiple IRQ shared requests will be
done without freing the previous request.  It will also try to free a
failed request or an already freed IRQ if 0 was written to the gpio file.

All these oops and leaks were fixed with the following solution: keep the
previous allocated GPIO (if any) still allocated in case the new request
fails.  The alternative solution would desallocate the previous allocated
GPIO and set gpio as 0.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Signed-off-by: Samuel R. C. Vale <srcvale@holoscopio.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/ledtrig-gpio.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff -puN drivers/leds/ledtrig-gpio.c~leds-fix-multiple-requests-and-releases-of-irq-for-gpio-led-trigger drivers/leds/ledtrig-gpio.c
--- a/drivers/leds/ledtrig-gpio.c~leds-fix-multiple-requests-and-releases-of-irq-for-gpio-led-trigger
+++ a/drivers/leds/ledtrig-gpio.c
@@ -146,20 +146,26 @@ static ssize_t gpio_trig_gpio_store(stru
 		return -EINVAL;
 	}
 
+	if (gpio_data->gpio == gpio)
+		return n;
+
 	if (!gpio) {
-		free_irq(gpio_to_irq(gpio_data->gpio), led);
+		if (gpio_data->gpio != 0)
+			free_irq(gpio_to_irq(gpio_data->gpio), led);
+		gpio_data->gpio = 0;
 		return n;
 	}
 
-	if (gpio_data->gpio > 0 && gpio_data->gpio != gpio)
-		free_irq(gpio_to_irq(gpio_data->gpio), led);
-
-	gpio_data->gpio = gpio;
 	ret = request_irq(gpio_to_irq(gpio), gpio_trig_irq,
 			IRQF_SHARED | IRQF_TRIGGER_RISING
 			| IRQF_TRIGGER_FALLING, "ledtrig-gpio", led);
-	if (ret)
+	if (ret) {
 		dev_err(dev, "request_irq failed with error %d\n", ret);
+	} else {
+		if (gpio_data->gpio != 0)
+			free_irq(gpio_to_irq(gpio_data->gpio), led);
+		gpio_data->gpio = gpio;
+	}
 
 	return ret ? ret : n;
 }
@@ -211,7 +217,8 @@ static void gpio_trig_deactivate(struct 
 		device_remove_file(led->dev, &dev_attr_inverted);
 		device_remove_file(led->dev, &dev_attr_desired_brightness);
 		flush_work(&gpio_data->work);
-		free_irq(gpio_to_irq(gpio_data->gpio),led);
+		if (gpio_data->gpio != 0)
+			free_irq(gpio_to_irq(gpio_data->gpio), led);
 		kfree(gpio_data);
 	}
 }
_

Patches currently in -mm which might be from cascardo@holoscopio.com are

origin.patch
linux-next.patch
leds-fix-coding-style-in-worker-thread-code-for-ledtrig-gpio.patch

