From: akpm@linux-foundation.org
Subject: [merged] leds-add-output-inversion-option-to-backlight-trigger.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:03:28 -0800
Message-ID: <201101132006.p0DK69Mc029702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56308 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933695Ab1AMUMI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:12:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkrzyszt@tis.icnet.pl, lethal@linux-sh.org, richard.purdie@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     leds: add output inversion option to backlight trigger
has been removed from the -mm tree.  Its filename was
     leds-add-output-inversion-option-to-backlight-trigger.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: add output inversion option to backlight trigger
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

Extend the LED backlight tirgger driver with an option that allows for
inverting the trigger output polarity.

With the invertion option provided, I (ab)use the backlight trigger for
driving a LED that indicates LCD display blank condtition on my Amstrad
Delta videophone.  Since the machine has no dedicated power LED, it was
not possible to distinguish if the display was blanked, or the machine was
turned off, without touching it.

The invert sysfs control is patterned after a similiar function of the GPIO
trigger driver.

[akpm@linux-foundation.org: make output match input, tighten input checking]
[akpm@linux-foundation.org: make output match input, tighten input checking]
Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Paul Mundt <lethal@linux-sh.org>
Acked-by: Richard Purdie <richard.purdie@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-led |   10 +++
 drivers/leds/ledtrig-backlight.c          |   61 ++++++++++++++++++--
 2 files changed, 67 insertions(+), 4 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-class-led~leds-add-output-inversion-option-to-backlight-trigger Documentation/ABI/testing/sysfs-class-led
--- a/Documentation/ABI/testing/sysfs-class-led~leds-add-output-inversion-option-to-backlight-trigger
+++ a/Documentation/ABI/testing/sysfs-class-led
@@ -26,3 +26,13 @@ Description:
 		scheduler is chosen. Trigger specific parameters can appear in
 		/sys/class/leds/<led> once a given trigger is selected.
 
+What:		/sys/class/leds/<led>/inverted
+Date:		January 2011
+KernelVersion:	2.6.38
+Contact:	Richard Purdie <rpurdie@rpsys.net>
+Description:
+		Invert the LED on/off state. This parameter is specific to
+		gpio and backlight triggers. In case of the backlight trigger,
+		it is usefull when driving a LED which is intended to indicate
+		a device in a standby like state.
+
diff -puN drivers/leds/ledtrig-backlight.c~leds-add-output-inversion-option-to-backlight-trigger drivers/leds/ledtrig-backlight.c
--- a/drivers/leds/ledtrig-backlight.c~leds-add-output-inversion-option-to-backlight-trigger
+++ a/drivers/leds/ledtrig-backlight.c
@@ -26,6 +26,7 @@ struct bl_trig_notifier {
 	int brightness;
 	int old_status;
 	struct notifier_block notifier;
+	unsigned invert;
 };
 
 static int fb_notifier_callback(struct notifier_block *p,
@@ -36,23 +37,64 @@ static int fb_notifier_callback(struct n
 	struct led_classdev *led = n->led;
 	struct fb_event *fb_event = data;
 	int *blank = fb_event->data;
+	int new_status = *blank ? BLANK : UNBLANK;
 
 	switch (event) {
 	case FB_EVENT_BLANK :
-		if (*blank && n->old_status == UNBLANK) {
+		if (new_status == n->old_status)
+			break;
+
+		if ((n->old_status == UNBLANK) ^ n->invert) {
 			n->brightness = led->brightness;
 			led_set_brightness(led, LED_OFF);
-			n->old_status = BLANK;
-		} else if (!*blank && n->old_status == BLANK) {
+		} else {
 			led_set_brightness(led, n->brightness);
-			n->old_status = UNBLANK;
 		}
+
+		n->old_status = new_status;
+
 		break;
 	}
 
 	return 0;
 }
 
+static ssize_t bl_trig_invert_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led = dev_get_drvdata(dev);
+	struct bl_trig_notifier *n = led->trigger_data;
+
+	return sprintf(buf, "%u\n", n->invert);
+}
+
+static ssize_t bl_trig_invert_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t num)
+{
+	struct led_classdev *led = dev_get_drvdata(dev);
+	struct bl_trig_notifier *n = led->trigger_data;
+	unsigned long invert;
+	int ret;
+
+	ret = strict_strtoul(buf, 10, &invert);
+	if (ret < 0)
+		return ret;
+
+	if (invert > 1)
+		return -EINVAL;
+
+	n->invert = invert;
+
+	/* After inverting, we need to update the LED. */
+	if ((n->old_status == BLANK) ^ n->invert)
+		led_set_brightness(led, LED_OFF);
+	else
+		led_set_brightness(led, n->brightness);
+
+	return num;
+}
+static DEVICE_ATTR(inverted, 0644, bl_trig_invert_show, bl_trig_invert_store);
+
 static void bl_trig_activate(struct led_classdev *led)
 {
 	int ret;
@@ -66,6 +108,10 @@ static void bl_trig_activate(struct led_
 		return;
 	}
 
+	ret = device_create_file(led->dev, &dev_attr_inverted);
+	if (ret)
+		goto err_invert;
+
 	n->led = led;
 	n->brightness = led->brightness;
 	n->old_status = UNBLANK;
@@ -74,6 +120,12 @@ static void bl_trig_activate(struct led_
 	ret = fb_register_client(&n->notifier);
 	if (ret)
 		dev_err(led->dev, "unable to register backlight trigger\n");
+
+	return;
+
+err_invert:
+	led->trigger_data = NULL;
+	kfree(n);
 }
 
 static void bl_trig_deactivate(struct led_classdev *led)
@@ -82,6 +134,7 @@ static void bl_trig_deactivate(struct le
 		(struct bl_trig_notifier *) led->trigger_data;
 
 	if (n) {
+		device_remove_file(led->dev, &dev_attr_inverted);
 		fb_unregister_client(&n->notifier);
 		kfree(n);
 	}
_

Patches currently in -mm which might be from jkrzyszt@tis.icnet.pl are

origin.patch
linux-next.patch

