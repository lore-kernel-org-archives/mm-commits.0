From: akpm@linux-foundation.org
Subject: + drivers-leds-ledtrig-gpioc-make-output-match-input-tighten-input-checking.patch added to -mm tree
Date: Wed, 19 Jan 2011 14:53:07 -0800
Message-ID: <201101192253.p0JMr7gU008272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753812Ab1ASWxP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Jan 2011 17:53:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkrzyszt@tis.icnet.pl, lethal@linux-sh.org, richard.purdie@linuxfoundation.org


The patch titled
     drivers/leds/ledtrig-gpio.c: make output match input, tighten input checking
has been added to the -mm tree.  Its filename is
     drivers-leds-ledtrig-gpioc-make-output-match-input-tighten-input-checking.patch

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

drivers-leds-ledtrig-gpioc-make-output-match-input-tighten-input-checking.patch

