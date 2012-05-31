From: akpm@linux-foundation.org
Subject: [merged] leds-add-new-transient-trigger-for-one-shot-timer-activation.patch removed from -mm tree
Date: Thu, 31 May 2012 12:19:50 -0700
Message-ID: <20120531191950.7FB4CA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:46966 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933093Ab2EaTTx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:19:53 -0400
Received: by were53 with SMTP id e53so76004wer.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:19:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shuahkhan@gmail.com, bryan.wu@canonical.com, jonas@southpole.se, neilb@suse.de, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: leds: add new transient trigger for one shot timer activation
has been removed from the -mm tree.  Its filename was
     leds-add-new-transient-trigger-for-one-shot-timer-activation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Shuah Khan <shuahkhan@gmail.com>
Subject: leds: add new transient trigger for one shot timer activation

The leds timer trigger does not currently have an interface to activate a
one shot timer.  The current support allows for setting two timers, one
for specifying how long a state to be on, and the second for how long the
state to be off.  The delay_on value specifies the time period an LED
should stay in on state, followed by a delay_off value that specifies how
long the LED should stay in off state.  The on and off cycle repeats until
the trigger gets deactivated.  There is no provision for one time
activation to implement features that require an on or off state to be
held just once and then stay in the original state forever.

Without one shot timer interface, user space can still use timer trigger
to set a timer to hold a state, however when user space application
crashes or goes away without deactivating the timer, the hardware will be
left in that state permanently.

As a specific example of this use-case, let's look at vibrate feature on
phones.  Vibrate function on phones is implemented using PWM pins on SoC
or PMIC.  There is a need to activate one shot timer to control the
vibrate feature, to prevent user space crashes leaving the phone in
vibrate mode permanently causing the battery to drain.

This trigger exports three properties, activate, state, and duration When
transient trigger is activated these properties are set to default values.

- duration allows setting timer value in msecs. The initial value is 0.
- activate allows activating and deactivating the timer specified by
  duration as needed. The initial and default value is 0.  This will allow
  duration to be set after trigger activation.
- state allows user to specify a transient state to be held for the specified
  duration.

Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: NeilBrown <neilb@suse.de>
Cc: Bryan Wu <bryan.wu@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/leds/ledtrig-transient.txt |  152 +++++++++++++
 drivers/leds/Kconfig                     |    8 
 drivers/leds/Makefile                    |    1 
 drivers/leds/ledtrig-transient.c         |  237 +++++++++++++++++++++
 4 files changed, 398 insertions(+)

diff -puN /dev/null Documentation/leds/ledtrig-transient.txt
--- /dev/null
+++ a/Documentation/leds/ledtrig-transient.txt
@@ -0,0 +1,152 @@
+LED Transient Trigger
+=====================
+
+The leds timer trigger does not currently have an interface to activate
+a one shot timer. The current support allows for setting two timers, one for
+specifying how long a state to be on, and the second for how long the state
+to be off. The delay_on value specifies the time period an LED should stay
+in on state, followed by a delay_off value that specifies how long the LED
+should stay in off state. The on and off cycle repeats until the trigger
+gets deactivated. There is no provision for one time activation to implement
+features that require an on or off state to be held just once and then stay in
+the original state forever.
+
+Without one shot timer interface, user space can still use timer trigger to
+set a timer to hold a state, however when user space application crashes or
+goes away without deactivating the timer, the hardware will be left in that
+state permanently.
+
+As a specific example of this use-case, let's look at vibrate feature on
+phones. Vibrate function on phones is implemented using PWM pins on SoC or
+PMIC. There is a need to activate one shot timer to control the vibrate
+feature, to prevent user space crashes leaving the phone in vibrate mode
+permanently causing the battery to drain.
+
+Transient trigger addresses the need for one shot timer activation. The
+transient trigger can be enabled and disabled just like the other leds
+triggers.
+
+When an led class device driver registers itself, it can specify all leds
+triggers it supports and a default trigger. During registration, activation
+routine for the default trigger gets called. During registration of an led
+class device, the LED state does not change.
+
+When the driver unregisters, deactivation routine for the currently active
+trigger will be called, and LED state is changed to LED_OFF.
+
+Driver suspend changes the LED state to LED_OFF and resume doesn't change
+the state. Please note that there is no explicit interaction between the
+suspend and resume actions and the currently enabled trigger. LED state
+changes are suspended while the driver is in suspend state. Any timers
+that are active at the time driver gets suspended, continue to run, without
+being able to actually change the LED state. Once driver is resumed, triggers
+start functioning again.
+
+LED state changes are controlled using brightness which is a common led
+class device property. When brightness is set to 0 from user space via
+echo 0 > brightness, it will result in deactivating the current trigger.
+
+Transient trigger uses standard register and unregister interfaces. During
+trigger registration, for each led class device that specifies this trigger
+as its default trigger, trigger activation routine will get called. During
+registration, the LED state does not change, unless there is another trigger
+active, in which case LED state changes to LED_OFF.
+
+During trigger unregistration, LED state gets changed to LED_OFF.
+
+Transient trigger activation routine doesn't change the LED state. It
+creates its properties and does its initialization. Transient trigger
+deactivation routine, will cancel any timer that is active before it cleans
+up and removes the properties it created. It will restore the LED state to
+non-transient state. When driver gets suspended, irrespective of the transient
+state, the LED state changes to LED_OFF.
+
+Transient trigger can be enabled and disabled from user space on led class
+devices, that support this trigger as shown below:
+
+echo transient > trigger
+echo none > trigger
+
+NOTE: Add a new property trigger state to control the state.
+
+This trigger exports three properties, activate, state, and duration. When
+transient trigger is activated these properties are set to default values.
+
+- duration allows setting timer value in msecs. The initial value is 0.
+- activate allows activating and deactivating the timer specified by
+  duration as needed. The initial and default value is 0.  This will allow
+  duration to be set after trigger activation.
+- state allows user to specify a transient state to be held for the specified
+  duration.
+
+	activate - one shot timer activate mechanism.
+		1 when activated, 0 when deactivated.
+		default value is zero when transient trigger is enabled,
+		to allow duration to be set.
+
+		activate state indicates a timer with a value of specified
+		duration running.
+		deactivated state indicates that there is no active timer
+		running.
+
+	duration - one shot timer value. When activate is set, duration value
+		is used to start a timer that runs once. This value doesn't
+		get changed by the trigger unless user does a set via
+		echo new_value > duration
+
+	state - transient state to be held. It has two values 0 or 1. 0 maps
+		to LED_OFF and 1 maps to LED_FULL. The specified state is
+		held for the duration of the one shot timer and then the
+		state gets changed to the non-transient state which is the
+		inverse of transient state.
+		If state = LED_FULL, when the timer runs out the state will
+		go back to LED_OFF.
+		If state = LED_OFF, when the timer runs out the state will
+		go back to LED_FULL.
+		Please note that current LED state is not checked prior to
+		changing the state to the specified state.
+		Driver could map these values to inverted depending on the
+		default states it defines for the LED in its brightness_set()
+		interface which is called from the led brightness_set()
+		interfaces to control the LED state.
+
+When timer expires activate goes back to deactivated state, duration is left
+at the set value to be used when activate is set at a future time. This will
+allow user app to set the time once and activate it to run it once for the
+specified value as needed. When timer expires, state is restored to the
+non-transient state which is the inverse of the transient state.
+
+	echo 1 > activate - starts timer = duration when duration is not 0.
+	echo 0 > activate - cancels currently running timer.
+	echo n > duration - stores timer value to be used upon next
+                            activate. Currently active timer if
+                            any, continues to run for the specified time.
+	echo 0 > duration - stores timer value to be used upon next
+                            activate. Currently active timer if any,
+                            continues to run for the specified time.
+	echo 1 > state    - stores desired transient state LED_FULL to be
+			    held for the specified duration.
+	echo 0 > state    - stores desired transient state LED_OFF to be
+			    held for the specified duration.
+
+What is not supported:
+======================
+- Timer activation is one shot and extending and/or shortening the timer
+  is not supported.
+
+Example use-case 1:
+	echo transient > trigger
+	echo n > duration
+	echo 1 > state
+repeat the following step as needed:
+	echo 1 > activate - start timer = duration to run once
+	echo 1 > activate - start timer = duration to run once
+	echo none > trigger
+
+This trigger is intended to be used for for the following example use cases:
+ - Control of vibrate (phones, tablets etc.) hardware by user space app.
+ - Use of LED by user space app as activity indicator.
+ - Use of LED by user space app as a kind of watchdog indicator -- as
+       long as the app is alive, it can keep the LED illuminated, if it dies
+       the LED will be extinguished automatically.
+ - Use by any user space app that needs a transient GPIO output.
diff -puN drivers/leds/Kconfig~leds-add-new-transient-trigger-for-one-shot-timer-activation drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-add-new-transient-trigger-for-one-shot-timer-activation
+++ a/drivers/leds/Kconfig
@@ -479,4 +479,12 @@ config LEDS_TRIGGER_DEFAULT_ON
 comment "iptables trigger is under Netfilter config (LED target)"
 	depends on LEDS_TRIGGERS
 
+config LEDS_TRIGGER_TRANSIENT
+	tristate "LED Transient Trigger"
+	depends on LEDS_TRIGGERS
+	help
+	  This allows one time activation of a transient state on
+	  GPIO/PWM based hadrware.
+	  If unsure, say Y.
+
 endif # NEW_LEDS
diff -puN drivers/leds/Makefile~leds-add-new-transient-trigger-for-one-shot-timer-activation drivers/leds/Makefile
--- a/drivers/leds/Makefile~leds-add-new-transient-trigger-for-one-shot-timer-activation
+++ a/drivers/leds/Makefile
@@ -57,3 +57,4 @@ obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)	+= 
 obj-$(CONFIG_LEDS_TRIGGER_BACKLIGHT)	+= ledtrig-backlight.o
 obj-$(CONFIG_LEDS_TRIGGER_GPIO)		+= ledtrig-gpio.o
 obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)	+= ledtrig-default-on.o
+obj-$(CONFIG_LEDS_TRIGGER_TRANSIENT)	+= ledtrig-transient.o
diff -puN /dev/null drivers/leds/ledtrig-transient.c
--- /dev/null
+++ a/drivers/leds/ledtrig-transient.c
@@ -0,0 +1,237 @@
+/*
+ * LED Kernel Transient Trigger
+ *
+ * Copyright (C) 2012 Shuah Khan <shuahkhan@gmail.com>
+ *
+ * Based on Richard Purdie's ledtrig-timer.c and Atsushi Nemoto's
+ * ledtrig-heartbeat.c
+ * Design and use-case input from Jonas Bonn <jonas@southpole.se> and
+ * Neil Brown <neilb@suse.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+/*
+ * Transient trigger allows one shot timer activation. Please refer to
+ * Documentation/leds/ledtrig-transient.txt for details
+*/
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/timer.h>
+#include <linux/leds.h>
+#include "leds.h"
+
+struct transient_trig_data {
+	int activate;
+	int state;
+	int restore_state;
+	unsigned long duration;
+	struct timer_list timer;
+};
+
+static void transient_timer_function(unsigned long data)
+{
+	struct led_classdev *led_cdev = (struct led_classdev *) data;
+	struct transient_trig_data *transient_data = led_cdev->trigger_data;
+
+	transient_data->activate = 0;
+	led_set_brightness(led_cdev, transient_data->restore_state);
+}
+
+static ssize_t transient_activate_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct transient_trig_data *transient_data = led_cdev->trigger_data;
+
+	return sprintf(buf, "%d\n", transient_data->activate);
+}
+
+static ssize_t transient_activate_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct transient_trig_data *transient_data = led_cdev->trigger_data;
+	unsigned long state;
+	ssize_t ret;
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		return ret;
+
+	if (state != 1 && state != 0)
+		return -EINVAL;
+
+	/* cancel the running timer */
+	if (state == 0 && transient_data->activate == 1) {
+		del_timer(&transient_data->timer);
+		transient_data->activate = state;
+		led_set_brightness(led_cdev, transient_data->restore_state);
+		return size;
+	}
+
+	/* start timer if there is no active timer */
+	if (state == 1 && transient_data->activate == 0 &&
+	    transient_data->duration != 0) {
+		transient_data->activate = state;
+		led_set_brightness(led_cdev, transient_data->state);
+		transient_data->restore_state =
+		    (transient_data->state == LED_FULL) ? LED_OFF : LED_FULL;
+		mod_timer(&transient_data->timer,
+			  jiffies + transient_data->duration);
+	}
+
+	/* state == 0 && transient_data->activate == 0
+		timer is not active - just return */
+	/* state == 1 && transient_data->activate == 1
+		timer is already active - just return */
+
+	return size;
+}
+
+static ssize_t transient_duration_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct transient_trig_data *transient_data = led_cdev->trigger_data;
+
+	return sprintf(buf, "%lu\n", transient_data->duration);
+}
+
+static ssize_t transient_duration_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct transient_trig_data *transient_data = led_cdev->trigger_data;
+	unsigned long state;
+	ssize_t ret;
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		return ret;
+
+	transient_data->duration = state;
+	return size;
+}
+
+static ssize_t transient_state_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct transient_trig_data *transient_data = led_cdev->trigger_data;
+	int state;
+
+	state = (transient_data->state == LED_FULL) ? 1 : 0;
+	return sprintf(buf, "%d\n", state);
+}
+
+static ssize_t transient_state_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct transient_trig_data *transient_data = led_cdev->trigger_data;
+	unsigned long state;
+	ssize_t ret;
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		return ret;
+
+	if (state != 1 && state != 0)
+		return -EINVAL;
+
+	transient_data->state = (state == 1) ? LED_FULL : LED_OFF;
+	return size;
+}
+
+static DEVICE_ATTR(activate, 0644, transient_activate_show,
+		   transient_activate_store);
+static DEVICE_ATTR(duration, 0644, transient_duration_show,
+		   transient_duration_store);
+static DEVICE_ATTR(state, 0644, transient_state_show, transient_state_store);
+
+static void transient_trig_activate(struct led_classdev *led_cdev)
+{
+	int rc;
+	struct transient_trig_data *tdata;
+
+	tdata = kzalloc(sizeof(struct transient_trig_data), GFP_KERNEL);
+	if (!tdata) {
+		dev_err(led_cdev->dev,
+			"unable to allocate transient trigger\n");
+		return;
+	}
+	led_cdev->trigger_data = tdata;
+
+	rc = device_create_file(led_cdev->dev, &dev_attr_activate);
+	if (rc)
+		goto err_out;
+
+	rc = device_create_file(led_cdev->dev, &dev_attr_duration);
+	if (rc)
+		goto err_out_duration;
+
+	rc = device_create_file(led_cdev->dev, &dev_attr_state);
+	if (rc)
+		goto err_out_state;
+
+	setup_timer(&tdata->timer, transient_timer_function,
+		    (unsigned long) led_cdev);
+	led_cdev->activated = true;
+
+	return;
+
+err_out_state:
+	device_remove_file(led_cdev->dev, &dev_attr_duration);
+err_out_duration:
+	device_remove_file(led_cdev->dev, &dev_attr_activate);
+err_out:
+	dev_err(led_cdev->dev, "unable to register transient trigger\n");
+	led_cdev->trigger_data = NULL;
+	kfree(tdata);
+}
+
+static void transient_trig_deactivate(struct led_classdev *led_cdev)
+{
+	struct transient_trig_data *transient_data = led_cdev->trigger_data;
+
+	if (led_cdev->activated) {
+		del_timer_sync(&transient_data->timer);
+		led_set_brightness(led_cdev, transient_data->restore_state);
+		device_remove_file(led_cdev->dev, &dev_attr_activate);
+		device_remove_file(led_cdev->dev, &dev_attr_duration);
+		device_remove_file(led_cdev->dev, &dev_attr_state);
+		led_cdev->trigger_data = NULL;
+		led_cdev->activated = false;
+		kfree(transient_data);
+	}
+}
+
+static struct led_trigger transient_trigger = {
+	.name     = "transient",
+	.activate = transient_trig_activate,
+	.deactivate = transient_trig_deactivate,
+};
+
+static int __init transient_trig_init(void)
+{
+	return led_trigger_register(&transient_trigger);
+}
+
+static void __exit transient_trig_exit(void)
+{
+	led_trigger_unregister(&transient_trigger);
+}
+
+module_init(transient_trig_init);
+module_exit(transient_trig_exit);
+
+MODULE_AUTHOR("Shuah Khan <shuahkhan@gmail.com>");
+MODULE_DESCRIPTION("Transient LED trigger");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from shuahkhan@gmail.com are

origin.patch

