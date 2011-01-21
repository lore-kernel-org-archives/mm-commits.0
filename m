From: akpm@linux-foundation.org
Subject: [merged] drivers-leds-ledtrig-gpioc-make-output-match-input-tighten-input-checking.patch removed from -mm tree
Date: Fri, 21 Jan 2011 12:31:54 -0800
Message-ID: <201101212031.p0LKVswb031659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750701Ab1AUUdL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Jan 2011 15:33:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkrzyszt@tis.icnet.pl, lethal@linux-sh.org, richard.purdie@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     drivers/leds/ledtrig-gpio.c: make output match input, tighten input checking
has been removed from the -mm tree.  Its filename was
     drivers-leds-ledtrig-gpioc-make-output-match-input-tighten-input-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/leds/ledtrig-gpio.c: make output match input, tighten input checking
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

Replicate changes made to drivers/leds/ledtrig-backlight.c.

Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Richard Purdie <richard.purdie@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/ledtrig-gpio.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/leds/ledtrig-gpio.c~drivers-leds-ledtrig-gpioc-make-output-match-input-tighten-input-checking drivers/leds/ledtrig-gpio.c
--- a/drivers/leds/ledtrig-gpio.c~drivers-leds-ledtrig-gpioc-make-output-match-input-tighten-input-checking
+++ a/drivers/leds/ledtrig-gpio.c
@@ -99,7 +99,7 @@ static ssize_t gpio_trig_inverted_show(s
 	struct led_classdev *led = dev_get_drvdata(dev);
 	struct gpio_trig_data *gpio_data = led->trigger_data;
 
-	return sprintf(buf, "%s\n", gpio_data->inverted ? "yes" : "no");
+	return sprintf(buf, "%u\n", gpio_data->inverted);
 }
 
 static ssize_t gpio_trig_inverted_store(struct device *dev,
@@ -107,16 +107,17 @@ static ssize_t gpio_trig_inverted_store(
 {
 	struct led_classdev *led = dev_get_drvdata(dev);
 	struct gpio_trig_data *gpio_data = led->trigger_data;
-	unsigned inverted;
+	unsigned long inverted;
 	int ret;
 
-	ret = sscanf(buf, "%u", &inverted);
-	if (ret < 1) {
-		dev_err(dev, "invalid value\n");
+	ret = strict_strtoul(buf, 10, &inverted);
+	if (ret < 0)
+		return ret;
+
+	if (inverted > 1)
 		return -EINVAL;
-	}
 
-	gpio_data->inverted = !!inverted;
+	gpio_data->inverted = inverted;
 
 	/* After inverting, we need to update the LED. */
 	schedule_work(&gpio_data->work);
_

Patches currently in -mm which might be from jkrzyszt@tis.icnet.pl are

origin.patch
linux-next.patch

