From: akpm@linux-foundation.org
Subject: + leds-route-kbd-leds-through-the-generic-leds-layer.patch added to -mm tree
Date: Thu, 18 Mar 2010 11:58:59 -0700
Message-ID: <201003181859.o2IIwxQj009834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47209 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706Ab0CRS7f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 14:59:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samuel.thibault@ens-lyon.org, dmitry.torokhov@gmail.com, pavel@ucw.cz, rpurdie@rpsys.net


The patch titled
     leds: route kbd LEDs through the generic LEDs layer
has been added to the -mm tree.  Its filename is
     leds-route-kbd-leds-through-the-generic-leds-layer.patch

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
Subject: leds: route kbd LEDs through the generic LEDs layer
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

This permits to reassign keyboard LEDs to something else than keyboard
"leds" state, by adding keyboard led and modifier triggers connected to a
series of global input LEDs, themselves connected to global input
triggers, which per-input device LEDs use by default.  Userland can thus
easily change the LED behavior of (a priori) all input devices, or of
particular input devices.

This also permits to fix #7063 from userland by using a modifier to
implement proper CapsLock behavior and have the keyboard caps lock led
show that modifier state.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/leds-class.txt |    3 
 drivers/char/keyboard.c      |   96 +++++++++-
 drivers/leds/Kconfig         |   11 -
 drivers/leds/Makefile        |    1 
 drivers/leds/leds-input.c    |  307 +++++++++++++++++++++++++++++++++
 5 files changed, 409 insertions(+), 9 deletions(-)

diff -puN Documentation/leds-class.txt~route-kbd-leds-through-the-generic-leds-layer-5th-version Documentation/leds-class.txt
--- a/Documentation/leds-class.txt~route-kbd-leds-through-the-generic-leds-layer-5th-version
+++ a/Documentation/leds-class.txt
@@ -2,9 +2,6 @@
 LED handling under Linux
 ========================
 
-If you're reading this and thinking about keyboard leds, these are
-handled by the input subsystem and the led class is *not* needed.
-
 In its simplest form, the LED class just allows control of LEDs from
 userspace. LEDs appear in /sys/class/leds/. The maximum brightness of the
 LED is defined in max_brightness file. The brightness file will set the brightness
diff -puN drivers/char/keyboard.c~route-kbd-leds-through-the-generic-leds-layer-5th-version drivers/char/keyboard.c
--- a/drivers/char/keyboard.c~route-kbd-leds-through-the-generic-leds-layer-5th-version
+++ a/drivers/char/keyboard.c
@@ -34,6 +34,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/irq.h>
+#include <linux/leds.h>
 
 #include <linux/kbd_kern.h>
 #include <linux/kbd_diacr.h>
@@ -139,6 +140,9 @@ static unsigned int diacr;
 static char rep;					/* flag telling character repeat */
 
 static unsigned char ledstate = 0xff;			/* undefined */
+#ifdef CONFIG_LEDS_INPUT
+static unsigned char lockstate = 0xff;			/* undefined */
+#endif
 static unsigned char ledioctl;
 
 static struct ledptr {
@@ -1009,6 +1013,35 @@ static void k_brl(struct vc_data *vc, un
 	}
 }
 
+#ifdef CONFIG_LEDS_INPUT
+/* When input-based leds are enabled, we route keyboard "leds" through triggers
+ */
+static void kbd_ledstate_trigger_activate(struct led_classdev *cdev);
+static struct led_trigger ledtrig_ledstate[] = {
+#define DEFINE_LEDSTATE_TRIGGER(kbd_led, nam) \
+	[kbd_led] = { .name = nam, .activate = kbd_ledstate_trigger_activate, }
+	DEFINE_LEDSTATE_TRIGGER(VC_SCROLLOCK, "scrollock"),
+	DEFINE_LEDSTATE_TRIGGER(VC_NUMLOCK,   "numlock"),
+	DEFINE_LEDSTATE_TRIGGER(VC_CAPSLOCK,  "capslock"),
+	DEFINE_LEDSTATE_TRIGGER(VC_KANALOCK,  "kanalock"),
+#undef DEFINE_LEDSTATE_TRIGGER
+};
+static void kbd_lockstate_trigger_activate(struct led_classdev *cdev);
+static struct led_trigger ledtrig_lockstate[] = {
+#define DEFINE_LOCKSTATE_TRIGGER(kbd_led, nam) \
+	[kbd_led] = { .name = nam, .activate = kbd_lockstate_trigger_activate, }
+	DEFINE_LOCKSTATE_TRIGGER(VC_SHIFTLOCK,  "shiftlock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_ALTGRLOCK,  "altgrlock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_CTRLLOCK,   "ctrllock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_ALTLOCK,    "altlock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_SHIFTLLOCK, "shiftllock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_SHIFTRLOCK, "shiftrlock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_CTRLLLOCK,  "ctrlllock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_CTRLRLOCK,  "ctrlrlock"),
+#undef DEFINE_LOCKSTATE_TRIGGER
+};
+#endif
+
 /*
  * The leds display either (i) the status of NumLock, CapsLock, ScrollLock,
  * or (ii) whatever pattern of lights people want to show using KDSETLED,
@@ -1052,19 +1085,44 @@ static inline unsigned char getleds(void
 	return leds;
 }
 
+#ifdef CONFIG_LEDS_INPUT
+/* Called on trigger connection, to set initial state */
+static void kbd_ledstate_trigger_activate(struct led_classdev *cdev)
+{
+	struct led_trigger *trigger = cdev->trigger;
+	int led = trigger - ledtrig_ledstate;
+
+	tasklet_disable(&keyboard_tasklet);
+	led_trigger_event(trigger, ledstate & (1 << led) ? INT_MAX : LED_OFF);
+	tasklet_enable(&keyboard_tasklet);
+}
+static void kbd_lockstate_trigger_activate(struct led_classdev *cdev)
+{
+	struct led_trigger *trigger = cdev->trigger;
+	int led = trigger - ledtrig_lockstate;
+
+	tasklet_disable(&keyboard_tasklet);
+	led_trigger_event(trigger, lockstate & (1 << led) ? INT_MAX : LED_OFF);
+	tasklet_enable(&keyboard_tasklet);
+}
+#else
 static int kbd_update_leds_helper(struct input_handle *handle, void *data)
 {
 	unsigned char leds = *(unsigned char *)data;
 
 	if (test_bit(EV_LED, handle->dev->evbit)) {
-		input_inject_event(handle, EV_LED, LED_SCROLLL, !!(leds & 0x01));
-		input_inject_event(handle, EV_LED, LED_NUML,    !!(leds & 0x02));
-		input_inject_event(handle, EV_LED, LED_CAPSL,   !!(leds & 0x04));
+		input_inject_event(handle, EV_LED, LED_SCROLLL,
+				!!(leds & VC_SCROLLOCK));
+		input_inject_event(handle, EV_LED, LED_NUML,
+				!!(leds & VC_NUMLOCK));
+		input_inject_event(handle, EV_LED, LED_CAPSL,
+				!!(leds & VC_CAPSLOCK));
 		input_inject_event(handle, EV_SYN, SYN_REPORT, 0);
 	}
 
 	return 0;
 }
+#endif
 
 /*
  * This is the tasklet that updates LED state on all keyboards
@@ -1078,10 +1136,31 @@ static void kbd_bh(unsigned long dummy)
 	unsigned char leds = getleds();
 
 	if (leds != ledstate) {
+#ifdef CONFIG_LEDS_INPUT
+		int i;
+		for (i = 0; i < ARRAY_SIZE(ledtrig_ledstate); i++)
+			if ((leds ^ ledstate) & (1 << i))
+				led_trigger_event(&ledtrig_ledstate[i],
+						leds & (1 << i)
+						? INT_MAX : LED_OFF);
+#else
 		input_handler_for_each_handle(&kbd_handler, &leds,
 					      kbd_update_leds_helper);
+#endif
 		ledstate = leds;
 	}
+
+#ifdef CONFIG_LEDS_INPUT
+	if (kbd->lockstate != lockstate) {
+		int i;
+		for (i = 0; i < ARRAY_SIZE(ledtrig_lockstate); i++)
+			if ((kbd->lockstate ^ lockstate) & (1 << i))
+				led_trigger_event(&ledtrig_lockstate[i],
+						kbd->lockstate & (1 << i)
+						? INT_MAX : LED_OFF);
+		lockstate = kbd->lockstate;
+	}
+#endif
 }
 
 DECLARE_TASKLET_DISABLED(keyboard_tasklet, kbd_bh, 0);
@@ -1436,6 +1515,7 @@ static void kbd_disconnect(struct input_
 	kfree(handle);
 }
 
+#ifndef CONFIG_LEDS_INPUT
 /*
  * Start keyboard handler on the new keyboard by refreshing LED state to
  * match the rest of the system.
@@ -1449,6 +1529,7 @@ static void kbd_start(struct input_handl
 
 	tasklet_enable(&keyboard_tasklet);
 }
+#endif
 
 static const struct input_device_id kbd_ids[] = {
 	{
@@ -1471,7 +1552,9 @@ static struct input_handler kbd_handler 
 	.match		= kbd_match,
 	.connect	= kbd_connect,
 	.disconnect	= kbd_disconnect,
+#ifndef CONFIG_LEDS_INPUT
 	.start		= kbd_start,
+#endif
 	.name		= "kbd",
 	.id_table	= kbd_ids,
 };
@@ -1498,5 +1581,12 @@ int __init kbd_init(void)
 	tasklet_enable(&keyboard_tasklet);
 	tasklet_schedule(&keyboard_tasklet);
 
+#ifdef CONFIG_LEDS_INPUT
+	for (i = 0; i < ARRAY_SIZE(ledtrig_ledstate); i++)
+		led_trigger_register(&ledtrig_ledstate[i]);
+	for (i = 0; i < ARRAY_SIZE(ledtrig_lockstate); i++)
+		led_trigger_register(&ledtrig_lockstate[i]);
+#endif
+
 	return 0;
 }
diff -puN drivers/leds/Kconfig~route-kbd-leds-through-the-generic-leds-layer-5th-version drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~route-kbd-leds-through-the-generic-leds-layer-5th-version
+++ a/drivers/leds/Kconfig
@@ -4,9 +4,6 @@ menuconfig NEW_LEDS
 	  Say Y to enable Linux LED support.  This allows control of supported
 	  LEDs from both userspace and optionally, by kernel events (triggers).
 
-	  This is not related to standard keyboard LEDs which are controlled
-	  via the input system.
-
 if NEW_LEDS
 
 config LEDS_CLASS
@@ -26,6 +23,14 @@ config LEDS_88PM860X
 	  This option enables support for on-chip LED drivers found on Marvell
 	  Semiconductor 88PM8606 PMIC.
 
+config LEDS_INPUT
+	tristate "LED Support using input keyboards"
+	depends on LEDS_CLASS
+	select LEDS_TRIGGERS
+	help
+	  This option enables support for the LEDs on keyboard managed
+	  by the input layer.
+
 config LEDS_ATMEL_PWM
 	tristate "LED Support using Atmel PWM outputs"
 	depends on ATMEL_PWM
diff -puN drivers/leds/Makefile~route-kbd-leds-through-the-generic-leds-layer-5th-version drivers/leds/Makefile
--- a/drivers/leds/Makefile~route-kbd-leds-through-the-generic-leds-layer-5th-version
+++ a/drivers/leds/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_LEDS_TRIGGERS)		+= led-trig
 obj-$(CONFIG_LEDS_88PM860X)		+= leds-88pm860x.o
 obj-$(CONFIG_LEDS_ATMEL_PWM)		+= leds-atmel-pwm.o
 obj-$(CONFIG_LEDS_BD2802)		+= leds-bd2802.o
+obj-$(CONFIG_LEDS_INPUT)		+= leds-input.o
 obj-$(CONFIG_LEDS_LOCOMO)		+= leds-locomo.o
 obj-$(CONFIG_LEDS_MIKROTIK_RB532)	+= leds-rb532.o
 obj-$(CONFIG_LEDS_S3C24XX)		+= leds-s3c24xx.o
diff -puN /dev/null drivers/leds/leds-input.c
--- /dev/null
+++ a/drivers/leds/leds-input.c
@@ -0,0 +1,307 @@
+/*
+ * LED support for the input layer
+ *
+ * Copyright 2010 Samuel Thibault <samuel.thibault@ens-lyon.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/leds.h>
+#include <linux/input.h>
+
+#include "leds.h"
+
+/*
+ * Keyboard LEDs are propagated by default like the following example:
+ *
+ * keyboard numlock trigger
+ * -> input::numl global input LED
+ * -> input-numl global input trigger
+ * -> per-device <device>-input::numl LED
+ *
+ * Userland can however choose the trigger for the input::numl LED, or
+ * independently choose the trigger for any input-<device>::numl LED.
+ */
+
+/* Global LED classes and triggers are registered on-demand according to
+ * existing devices */
+
+/* Handler for global input LEDs, just triggers the corresponding global input
+ * trigger. */
+static void input_led_set(struct led_classdev *cdev,
+			  enum led_brightness brightness);
+static struct led_classdev input_leds[LED_CNT] = {
+#define DEFINE_INPUT_LED(input_led, nam, deftrig) \
+	[input_led] = { \
+		.name = "input::"nam, \
+		.max_brightness = 1, \
+		.brightness_set = input_led_set, \
+		.default_trigger = deftrig, \
+	}
+/* Default triggers for the global input LEDs just correspond to the legacy
+ * usage. */
+	DEFINE_INPUT_LED(LED_NUML, "numl", "numlock"),
+	DEFINE_INPUT_LED(LED_CAPSL, "capsl", "capslock"),
+	DEFINE_INPUT_LED(LED_SCROLLL, "scrolll", "scrollock"),
+	DEFINE_INPUT_LED(LED_COMPOSE, "compose", NULL),
+	DEFINE_INPUT_LED(LED_KANA, "kana", "kanalock"),
+	DEFINE_INPUT_LED(LED_SLEEP, "sleep", NULL),
+	DEFINE_INPUT_LED(LED_SUSPEND, "suspend", NULL),
+	DEFINE_INPUT_LED(LED_MUTE, "mute", NULL),
+	DEFINE_INPUT_LED(LED_MISC, "misc", NULL),
+	DEFINE_INPUT_LED(LED_MAIL, "mail", NULL),
+	DEFINE_INPUT_LED(LED_CHARGING, "charging", NULL),
+};
+static const char *const input_led_names[LED_CNT] = {
+	[LED_NUML] = "numl",
+	[LED_CAPSL] = "capsl",
+	[LED_SCROLLL] = "scrolll",
+	[LED_COMPOSE] = "compose",
+	[LED_KANA] = "kana",
+	[LED_SLEEP] = "sleep",
+	[LED_SUSPEND] = "suspend",
+	[LED_MUTE] = "mute",
+	[LED_MISC] = "misc",
+	[LED_MAIL] = "mail",
+	[LED_CHARGING] = "charging",
+};
+/* Handler for hotplug initialization */
+static void input_led_trigger_activate(struct led_classdev *cdev);
+/* Global input triggers */
+static struct led_trigger input_led_triggers[LED_CNT] = {
+#define DEFINE_INPUT_LED_TRIGGER(input_led, nam) \
+	[input_led] = { \
+		.name = "input-"nam, \
+		.activate = input_led_trigger_activate, \
+	}
+	DEFINE_INPUT_LED_TRIGGER(LED_NUML, "numl"),
+	DEFINE_INPUT_LED_TRIGGER(LED_CAPSL, "capsl"),
+	DEFINE_INPUT_LED_TRIGGER(LED_SCROLLL, "scrolll"),
+	DEFINE_INPUT_LED_TRIGGER(LED_COMPOSE, "compose"),
+	DEFINE_INPUT_LED_TRIGGER(LED_KANA, "kana"),
+	DEFINE_INPUT_LED_TRIGGER(LED_SLEEP, "sleep"),
+	DEFINE_INPUT_LED_TRIGGER(LED_SUSPEND, "suspend"),
+	DEFINE_INPUT_LED_TRIGGER(LED_MUTE, "mute"),
+	DEFINE_INPUT_LED_TRIGGER(LED_MISC, "misc"),
+	DEFINE_INPUT_LED_TRIGGER(LED_MAIL, "mail"),
+	DEFINE_INPUT_LED_TRIGGER(LED_CHARGING, "charging"),
+};
+/* Lock for registration coherency */
+static DEFINE_SPINLOCK(input_led_registered_lock);
+/* Which global LED classes and triggers are registered */
+static unsigned long input_led_registered[BITS_TO_LONGS(LED_CNT)];
+
+/* Our input handler to catch connect/disconnect */
+static struct input_handler input_led_handler;
+
+/* Global input LED state change, tell the global input trigger.  */
+static void input_led_set(struct led_classdev *cdev,
+			  enum led_brightness brightness)
+{
+	int led = cdev - input_leds;
+
+	led_trigger_event(&input_led_triggers[led], !!brightness);
+}
+
+/* LED state change for some keyboard, notify that keyboard.  */
+static void perdevice_input_led_set(struct led_classdev *cdev,
+			  enum led_brightness brightness)
+{
+	struct input_handle *handle;
+	struct led_classdev *leds;
+	int led;
+
+	handle = cdev->dev->platform_data;
+	if (!handle)
+		/* Still initializing */
+		return;
+	leds = handle->private;
+	led = cdev - leds;
+
+	input_inject_event(handle, EV_LED, led, !!brightness);
+	input_inject_event(handle, EV_SYN, SYN_REPORT, 0);
+}
+
+/* Keyboard hotplug, initialize its LED status */
+static void input_led_trigger_activate(struct led_classdev *cdev)
+{
+	struct led_trigger *trigger = cdev->trigger;
+	int led = trigger - input_led_triggers;
+
+	if (cdev->brightness_set)
+		cdev->brightness_set(cdev, input_leds[led].brightness);
+}
+
+/* Free an input handle, used at abortion and disconnection.  */
+static void input_led_delete_handle(struct input_handle *handle)
+{
+	if (handle) {
+		struct led_classdev *leds = handle->private;
+		if (leds) {
+			int i;
+			for (i = 0; i < LED_CNT; i++)
+				kfree(leds[i].name);
+			kfree(leds);
+		}
+		kfree(handle);
+	}
+}
+
+/* A new input device with potential LEDs to connect.  */
+static int input_led_connect(struct input_handler *handler,
+			      struct input_dev *dev,
+			      const struct input_device_id *id)
+{
+	struct input_handle *handle;
+	int i, error = 0;
+	unsigned long flags;
+	struct led_classdev *leds;
+
+	if (!test_bit(EV_LED, dev->keybit))
+		return -ENODEV;
+
+	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
+	if (!handle) {
+		error = -ENOMEM;
+		goto err;
+	}
+
+	handle->private = leds = kzalloc(sizeof(*leds) * LED_CNT,
+						GFP_KERNEL);
+	if (!handle->private) {
+		error = -ENOMEM;
+		goto err;
+	}
+
+	handle->dev = dev;
+	handle->handler = handler;
+	handle->name = "input leds";
+
+	error = input_register_handle(handle);
+	if (error)
+		goto err;
+
+	/* lazily register missing global input LEDs */
+	spin_lock_irqsave(&input_led_registered_lock, flags);
+	for (i = 0; i < LED_CNT; i++)
+		if (input_leds[i].name
+				&& !test_bit(i, input_led_registered)
+				&& test_bit(i, dev->ledbit)) {
+			led_trigger_register(&input_led_triggers[i]);
+			/* This keyboard has led i, try to register it */
+			if (!led_classdev_register(NULL, &input_leds[i]))
+				set_bit(i, input_led_registered);
+			else
+				led_trigger_unregister(&input_led_triggers[i]);
+		}
+	spin_unlock_irqrestore(&input_led_registered_lock, flags);
+
+	/* and register this device's LEDs */
+	for (i = 0; i < LED_CNT; i++)
+		if (input_leds[i].name && test_bit(i, dev->ledbit)) {
+			leds[i].name = kasprintf(GFP_KERNEL, "%s::%s",
+						dev_name(&dev->dev),
+						input_led_names[i]);
+			if (!leds[i].name) {
+				error = -ENOMEM;
+				goto err_handler;
+			}
+			leds[i].max_brightness = 1;
+			leds[i].brightness_set = perdevice_input_led_set;
+			leds[i].default_trigger = input_led_triggers[i].name;
+		}
+
+	/* No issue so far, we can register for real.  */
+	for (i = 0; i < LED_CNT; i++)
+		if (leds[i].name) {
+			led_classdev_register(&dev->dev, &leds[i]);
+			leds[i].dev->platform_data = handle;
+			perdevice_input_led_set(&leds[i],
+					input_leds[i].brightness);
+		}
+
+	return 0;
+
+err_handler:
+	input_unregister_handler(&input_led_handler);
+err:
+	input_led_delete_handle(handle);
+	return error;
+}
+
+/* Disconnected input device. Clean it, and deregister now-useless global LEDs
+ * and triggers.  */
+static void input_led_disconnect(struct input_handle *handle)
+{
+	int unregister, i;
+	unsigned long flags;
+	struct led_classdev *leds = handle->private;
+
+	for (i = 0; i < LED_CNT; i++)
+		if (leds[i].name)
+			led_classdev_unregister(&leds[i]);
+
+	input_unregister_handle(handle);
+	input_led_delete_handle(handle);
+
+	spin_lock_irqsave(&input_led_registered_lock, flags);
+	for (i = 0; i < LED_CNT; i++) {
+		if (!test_bit(i, input_led_registered))
+			continue;
+
+		unregister = 1;
+		list_for_each_entry(handle, &input_led_handler.h_list, h_node) {
+			if (test_bit(i, handle->dev->ledbit)) {
+				unregister = 0;
+				break;
+			}
+		}
+		if (!unregister)
+			continue;
+
+		led_classdev_unregister(&input_leds[i]);
+		led_trigger_unregister(&input_led_triggers[i]);
+		clear_bit(i, input_led_registered);
+	}
+	spin_unlock_irqrestore(&input_led_registered_lock, flags);
+}
+
+/* Only handle input devices which have LEDs */
+static const struct input_device_id input_led_ids[] = {
+	{
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT,
+		.evbit = { BIT_MASK(EV_LED) },
+	},
+
+	{ },	/* Terminating entry */
+};
+
+static struct input_handler input_led_handler = {
+	.connect	= input_led_connect,
+	.disconnect	= input_led_disconnect,
+	.name		= "input leds",
+	.id_table	= input_led_ids,
+};
+
+static int __init input_led_init(void)
+{
+	return input_register_handler(&input_led_handler);
+}
+
+static void __exit input_led_exit(void)
+{
+	/* This also disconnects all devices and thus unregisters LEDs and
+	 * triggers */
+	input_unregister_handler(&input_led_handler);
+}
+
+module_init(input_led_init);
+module_exit(input_led_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("User LED support for input layer");
+MODULE_AUTHOR("Samuel Thibault <samuel.thibault@ens-lyon.org>");
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

leds-route-kbd-leds-through-the-generic-leds-layer.patch

