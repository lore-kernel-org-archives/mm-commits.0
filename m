From: akpm@linux-foundation.org
Subject: + leds-change-existing-triggers-to-use-activated-flag.patch added to -mm tree
Date: Fri, 20 Apr 2012 14:02:40 -0700
Message-ID: <20120420210240.4616CA03CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:40749 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab2DTVCm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Apr 2012 17:02:42 -0400
Received: by qabg24 with SMTP id g24so109294qab.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Apr 2012 14:02:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shuahkhan@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: leds: change existing triggers to use activated flag
has been added to the -mm tree.  Its filename is
     leds-change-existing-triggers-to-use-activated-flag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shuah Khan <shuahkhan@gmail.com>
Subject: leds: change existing triggers to use activated flag

Change existing triggers backlight, gpio, and heartbeat to use the new
->activated flag to set activate successful status in their activate
routines and check it in their deactivate routines to do cleanup.

Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/ledtrig-backlight.c |    4 +++-
 drivers/leds/ledtrig-gpio.c      |    4 +++-
 drivers/leds/ledtrig-heartbeat.c |    4 +++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff -puN drivers/leds/ledtrig-backlight.c~leds-change-existing-triggers-to-use-activated-flag drivers/leds/ledtrig-backlight.c
--- a/drivers/leds/ledtrig-backlight.c~leds-change-existing-triggers-to-use-activated-flag
+++ a/drivers/leds/ledtrig-backlight.c
@@ -120,6 +120,7 @@ static void bl_trig_activate(struct led_
 	ret = fb_register_client(&n->notifier);
 	if (ret)
 		dev_err(led->dev, "unable to register backlight trigger\n");
+	led->activated = true;
 
 	return;
 
@@ -133,10 +134,11 @@ static void bl_trig_deactivate(struct le
 	struct bl_trig_notifier *n =
 		(struct bl_trig_notifier *) led->trigger_data;
 
-	if (n) {
+	if (led->activated) {
 		device_remove_file(led->dev, &dev_attr_inverted);
 		fb_unregister_client(&n->notifier);
 		kfree(n);
+		led->activated = false;
 	}
 }
 
diff -puN drivers/leds/ledtrig-gpio.c~leds-change-existing-triggers-to-use-activated-flag drivers/leds/ledtrig-gpio.c
--- a/drivers/leds/ledtrig-gpio.c~leds-change-existing-triggers-to-use-activated-flag
+++ a/drivers/leds/ledtrig-gpio.c
@@ -200,6 +200,7 @@ static void gpio_trig_activate(struct le
 	gpio_data->led = led;
 	led->trigger_data = gpio_data;
 	INIT_WORK(&gpio_data->work, gpio_trig_work);
+	led->activated = true;
 
 	return;
 
@@ -217,7 +218,7 @@ static void gpio_trig_deactivate(struct 
 {
 	struct gpio_trig_data *gpio_data = led->trigger_data;
 
-	if (gpio_data) {
+	if (led->activated) {
 		device_remove_file(led->dev, &dev_attr_gpio);
 		device_remove_file(led->dev, &dev_attr_inverted);
 		device_remove_file(led->dev, &dev_attr_desired_brightness);
@@ -225,6 +226,7 @@ static void gpio_trig_deactivate(struct 
 		if (gpio_data->gpio != 0)
 			free_irq(gpio_to_irq(gpio_data->gpio), led);
 		kfree(gpio_data);
+		led->activated = false;
 	}
 }
 
diff -puN drivers/leds/ledtrig-heartbeat.c~leds-change-existing-triggers-to-use-activated-flag drivers/leds/ledtrig-heartbeat.c
--- a/drivers/leds/ledtrig-heartbeat.c~leds-change-existing-triggers-to-use-activated-flag
+++ a/drivers/leds/ledtrig-heartbeat.c
@@ -83,15 +83,17 @@ static void heartbeat_trig_activate(stru
 		    led_heartbeat_function, (unsigned long) led_cdev);
 	heartbeat_data->phase = 0;
 	led_heartbeat_function(heartbeat_data->timer.data);
+	led_cdev->activated = true;
 }
 
 static void heartbeat_trig_deactivate(struct led_classdev *led_cdev)
 {
 	struct heartbeat_trig_data *heartbeat_data = led_cdev->trigger_data;
 
-	if (heartbeat_data) {
+	if (led_cdev->activated) {
 		del_timer_sync(&heartbeat_data->timer);
 		kfree(heartbeat_data);
+		led_cdev->activated = false;
 	}
 }
 
_
Subject: Subject: leds: change existing triggers to use activated flag

Patches currently in -mm which might be from shuahkhan@gmail.com are

linux-next.patch
leds-add-led-driver-for-lm3556-chip.patch
leds-simple_strtoul-cleanup.patch
leds-add-new-field-to-led_classdev-struct-to-save-activation-state.patch
leds-change-existing-triggers-to-use-activated-flag.patch
leds-change-ledtrig-timer-to-use-activated-flag.patch

