From: akpm@linux-foundation.org
Subject: + input-route-kbd-leds-through-the-generic-leds-layer.patch added to -mm tree
Date: Tue, 08 Oct 2013 16:06:25 -0700
Message-ID: <52548ff1.uM0pWwYFNKvIKHqZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671Ab3JHXG1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Oct 2013 19:06:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, steev@genesi-usa.com, s.hauer@pengutronix.de, robdclark@gmail.com, pavel@ucw.cz, matt@genesi-usa.com, jacmet@sunsite.dk, evan@ebroder.net, dmitry.torokhov@gmail.com, dh.herrmann@gmail.com, devos@fedoraproject.org, cooloney@gmail.com, arnaud.patard@rtp-net.org, samuel.thibault@ens-lyon.org

Subject: + input-route-kbd-leds-through-the-generic-leds-layer.patch added to -mm tree
To: samuel.thibault@ens-lyon.org,arnaud.patard@rtp-net.org,cooloney@gmail.com,devos@fedoraproject.org,dh.herrmann@gmail.com,dmitry.torokhov@gmail.com,evan@ebroder.net,jacmet@sunsite.dk,matt@genesi-usa.com,pavel@ucw.cz,robdclark@gmail.com,s.hauer@pengutronix.de,steev@genesi-usa.com
From: akpm@linux-foundation.org
Date: Tue, 08 Oct 2013 16:06:25 -0700


The patch titled
     Subject: input: route kbd LEDs through the generic LEDs layer
has been added to the -mm tree.  Its filename is
     input-route-kbd-leds-through-the-generic-leds-layer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/input-route-kbd-leds-through-the-generic-leds-layer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/input-route-kbd-leds-through-the-generic-leds-layer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: input: route kbd LEDs through the generic LEDs layer

This permits to reassign keyboard LEDs to something else than keyboard
"leds" state, by adding keyboard led and modifier triggers connected to a
series of VT input LEDs, themselves connected to VT input triggers, which
per-input device LEDs use by default.  Userland can thus easily change the
LED behavior of (a priori) all input devices, or of particular input
devices.

This also permits to fix #7063 from userland by using a modifier to
implement proper CapsLock behavior and have the keyboard caps lock led
show that modifier state.

[ebroder@mokafive.com: Rebased to 3.2-rc1 or so, cleaned up some includes, and fixed some constants]
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Evan Broder <evan@ebroder.net>
Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
Tested-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Matt Sealey <matt@genesi-usa.com>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Niels de Vos <devos@fedoraproject.org>
Cc: Steev Klimaszewski <steev@genesi-usa.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/leds/leds-class.txt |    3 
 drivers/input/Kconfig             |    9 +
 drivers/input/Makefile            |    1 
 drivers/input/input.c             |    6 
 drivers/input/leds.c              |  247 ++++++++++++++++++++++++++++
 drivers/leds/Kconfig              |    3 
 drivers/tty/Kconfig               |    4 
 drivers/tty/vt/keyboard.c         |  110 +++++++++---
 include/linux/input.h             |   20 ++
 9 files changed, 370 insertions(+), 33 deletions(-)

diff -puN Documentation/leds/leds-class.txt~input-route-kbd-leds-through-the-generic-leds-layer Documentation/leds/leds-class.txt
--- a/Documentation/leds/leds-class.txt~input-route-kbd-leds-through-the-generic-leds-layer
+++ a/Documentation/leds/leds-class.txt
@@ -2,9 +2,6 @@
 LED handling under Linux
 ========================
 
-If you're reading this and thinking about keyboard leds, these are
-handled by the input subsystem and the led class is *not* needed.
-
 In its simplest form, the LED class just allows control of LEDs from
 userspace. LEDs appear in /sys/class/leds/. The maximum brightness of the
 LED is defined in max_brightness file. The brightness file will set the brightness
diff -puN drivers/input/Kconfig~input-route-kbd-leds-through-the-generic-leds-layer drivers/input/Kconfig
--- a/drivers/input/Kconfig~input-route-kbd-leds-through-the-generic-leds-layer
+++ a/drivers/input/Kconfig
@@ -178,6 +178,15 @@ comment "Input Device Drivers"
 
 source "drivers/input/keyboard/Kconfig"
 
+config INPUT_LEDS
+	tristate "LED Support"
+	depends on LEDS_CLASS
+	select LEDS_TRIGGERS
+	default y
+	help
+	  This option enables support for LEDs on keyboards managed
+	  by the input layer.
+
 source "drivers/input/mouse/Kconfig"
 
 source "drivers/input/joystick/Kconfig"
diff -puN drivers/input/Makefile~input-route-kbd-leds-through-the-generic-leds-layer drivers/input/Makefile
--- a/drivers/input/Makefile~input-route-kbd-leds-through-the-generic-leds-layer
+++ a/drivers/input/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_INPUT_MOUSEDEV)	+= mousedev
 obj-$(CONFIG_INPUT_JOYDEV)	+= joydev.o
 obj-$(CONFIG_INPUT_EVDEV)	+= evdev.o
 obj-$(CONFIG_INPUT_EVBUG)	+= evbug.o
+obj-$(CONFIG_INPUT_LEDS)	+= leds.o
 
 obj-$(CONFIG_INPUT_KEYBOARD)	+= keyboard/
 obj-$(CONFIG_INPUT_MOUSE)	+= mouse/
diff -puN drivers/input/input.c~input-route-kbd-leds-through-the-generic-leds-layer drivers/input/input.c
--- a/drivers/input/input.c~input-route-kbd-leds-through-the-generic-leds-layer
+++ a/drivers/input/input.c
@@ -708,6 +708,9 @@ static void input_disconnect_device(stru
 		handle->open = 0;
 
 	spin_unlock_irq(&dev->event_lock);
+
+	if (is_event_supported(EV_LED, dev->evbit, EV_MAX))
+		input_led_disconnect(dev);
 }
 
 /**
@@ -2092,6 +2095,9 @@ int input_register_device(struct input_d
 
 	list_add_tail(&dev->node, &input_dev_list);
 
+	if (is_event_supported(EV_LED, dev->evbit, EV_MAX))
+		input_led_connect(dev);
+
 	list_for_each_entry(handler, &input_handler_list, node)
 		input_attach_handler(dev, handler);
 
diff -puN /dev/null drivers/input/leds.c
--- /dev/null
+++ a/drivers/input/leds.c
@@ -0,0 +1,247 @@
+/*
+ * LED support for the input layer
+ *
+ * Copyright 2010-2013 Samuel Thibault <samuel.thibault@ens-lyon.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/leds.h>
+#include <linux/input.h>
+
+/*
+ * Keyboard LEDs are propagated by default like the following example:
+ *
+ * VT keyboard numlock trigger
+ * -> vt::numl VT LED
+ * -> vt-numl VT trigger
+ * -> per-device inputX::numl LED
+ *
+ * Userland can however choose the trigger for the vt::numl LED, or
+ * independently choose the trigger for any inputx::numl LED.
+ *
+ *
+ * VT LED classes and triggers are registered on-demand according to
+ * existing LED devices
+ */
+
+/* Handler for VT LEDs, just triggers the corresponding VT trigger. */
+static void vt_led_set(struct led_classdev *cdev,
+			  enum led_brightness brightness);
+static struct led_classdev vt_leds[LED_CNT] = {
+#define DEFINE_INPUT_LED(vt_led, nam, deftrig) \
+	[vt_led] = { \
+		.name = "vt::"nam, \
+		.max_brightness = 1, \
+		.brightness_set = vt_led_set, \
+		.default_trigger = deftrig, \
+	}
+/* Default triggers for the VT LEDs just correspond to the legacy
+ * usage. */
+	DEFINE_INPUT_LED(LED_NUML, "numl", "kbd-numlock"),
+	DEFINE_INPUT_LED(LED_CAPSL, "capsl", "kbd-capslock"),
+	DEFINE_INPUT_LED(LED_SCROLLL, "scrolll", "kbd-scrollock"),
+	DEFINE_INPUT_LED(LED_COMPOSE, "compose", NULL),
+	DEFINE_INPUT_LED(LED_KANA, "kana", "kbd-kanalock"),
+	DEFINE_INPUT_LED(LED_SLEEP, "sleep", NULL),
+	DEFINE_INPUT_LED(LED_SUSPEND, "suspend", NULL),
+	DEFINE_INPUT_LED(LED_MUTE, "mute", NULL),
+	DEFINE_INPUT_LED(LED_MISC, "misc", NULL),
+	DEFINE_INPUT_LED(LED_MAIL, "mail", NULL),
+	DEFINE_INPUT_LED(LED_CHARGING, "charging", NULL),
+};
+static const char *const vt_led_names[LED_CNT] = {
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
+static void vt_led_trigger_activate(struct led_classdev *cdev);
+/* VT triggers */
+static struct led_trigger vt_led_triggers[LED_CNT] = {
+#define DEFINE_INPUT_LED_TRIGGER(vt_led, nam) \
+	[vt_led] = { \
+		.name = "vt-"nam, \
+		.activate = vt_led_trigger_activate, \
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
+
+/* Lock for registration coherency */
+static DEFINE_MUTEX(vt_led_registered_lock);
+
+/* Which VT LED classes and triggers are registered */
+static unsigned long vt_led_registered[BITS_TO_LONGS(LED_CNT)];
+
+/* Number of input devices having each LED */
+static int vt_led_references[LED_CNT];
+
+/* VT LED state change, tell the VT trigger.  */
+static void vt_led_set(struct led_classdev *cdev,
+			  enum led_brightness brightness)
+{
+	int led = cdev - vt_leds;
+
+	led_trigger_event(&vt_led_triggers[led], !!brightness);
+}
+
+/* LED state change for some keyboard, notify that keyboard.  */
+static void perdevice_input_led_set(struct led_classdev *cdev,
+			  enum led_brightness brightness)
+{
+	struct input_dev *dev;
+	struct led_classdev *leds;
+	int led;
+
+	dev = cdev->dev->platform_data;
+	if (!dev)
+		/* Still initializing */
+		return;
+	leds = dev->leds;
+	led = cdev - leds;
+
+	input_event(dev, EV_LED, led, !!brightness);
+	input_event(dev, EV_SYN, SYN_REPORT, 0);
+}
+
+/* Keyboard hotplug, initialize its LED status */
+static void vt_led_trigger_activate(struct led_classdev *cdev)
+{
+	struct led_trigger *trigger = cdev->trigger;
+	int led = trigger - vt_led_triggers;
+
+	if (cdev->brightness_set)
+		cdev->brightness_set(cdev, vt_leds[led].brightness);
+}
+
+/* Free led stuff from input device, used at abortion and disconnection.  */
+static void input_led_delete(struct input_dev *dev)
+{
+	if (dev) {
+		struct led_classdev *leds = dev->leds;
+		if (leds) {
+			int i;
+			for (i = 0; i < LED_CNT; i++)
+				kfree(leds[i].name);
+			kfree(leds);
+			dev->leds = NULL;
+		}
+	}
+}
+
+/* A new input device with potential LEDs to connect.  */
+int input_led_connect(struct input_dev *dev)
+{
+	int i, error = 0;
+	struct led_classdev *leds;
+
+	dev->leds = leds = kzalloc(sizeof(*leds) * LED_CNT, GFP_KERNEL);
+	if (!dev->leds)
+		return -ENOMEM;
+
+	/* lazily register missing VT LEDs */
+	mutex_lock(&vt_led_registered_lock);
+	for (i = 0; i < LED_CNT; i++)
+		if (vt_leds[i].name && test_bit(i, dev->ledbit)) {
+			if (!vt_led_references[i]) {
+				led_trigger_register(&vt_led_triggers[i]);
+				/* This keyboard is first to have led i,
+				 * try to register it */
+				if (!led_classdev_register(NULL, &vt_leds[i]))
+					vt_led_references[i] = 1;
+				else
+					led_trigger_unregister(&vt_led_triggers[i]);
+			} else
+				vt_led_references[i]++;
+		}
+	mutex_unlock(&vt_led_registered_lock);
+
+	/* and register this device's LEDs */
+	for (i = 0; i < LED_CNT; i++)
+		if (vt_leds[i].name && test_bit(i, dev->ledbit)) {
+			leds[i].name = kasprintf(GFP_KERNEL, "%s::%s",
+						dev_name(&dev->dev),
+						vt_led_names[i]);
+			if (!leds[i].name) {
+				error = -ENOMEM;
+				goto err;
+			}
+			leds[i].max_brightness = 1;
+			leds[i].brightness_set = perdevice_input_led_set;
+			leds[i].default_trigger = vt_led_triggers[i].name;
+		}
+
+	/* No issue so far, we can register for real.  */
+	for (i = 0; i < LED_CNT; i++)
+		if (leds[i].name) {
+			led_classdev_register(&dev->dev, &leds[i]);
+			leds[i].dev->platform_data = dev;
+			perdevice_input_led_set(&leds[i],
+					vt_leds[i].brightness);
+		}
+
+	return 0;
+
+err:
+	input_led_delete(dev);
+	return error;
+}
+
+/* Disconnected input device. Clean it, and deregister now-useless VT LEDs
+ * and triggers.  */
+extern void input_led_disconnect(struct input_dev *dev)
+{
+	int i;
+	struct led_classdev *leds = dev->leds;
+
+	for (i = 0; i < LED_CNT; i++)
+		if (leds[i].name)
+			led_classdev_unregister(&leds[i]);
+
+	input_led_delete(dev);
+
+	mutex_lock(&vt_led_registered_lock);
+	for (i = 0; i < LED_CNT; i++) {
+		if (!vt_leds[i].name || !test_bit(i, dev->ledbit))
+			continue;
+
+		vt_led_references[i]--;
+		if (vt_led_references[i]) {
+			/* Still some devices needing it */
+			continue;
+		}
+
+		led_classdev_unregister(&vt_leds[i]);
+		led_trigger_unregister(&vt_led_triggers[i]);
+		clear_bit(i, vt_led_registered);
+	}
+	mutex_unlock(&vt_led_registered_lock);
+}
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("User LED support for input layer");
+MODULE_AUTHOR("Samuel Thibault <samuel.thibault@ens-lyon.org>");
diff -puN drivers/leds/Kconfig~input-route-kbd-leds-through-the-generic-leds-layer drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~input-route-kbd-leds-through-the-generic-leds-layer
+++ a/drivers/leds/Kconfig
@@ -11,9 +11,6 @@ menuconfig NEW_LEDS
 	  Say Y to enable Linux LED support.  This allows control of supported
 	  LEDs from both userspace and optionally, by kernel events (triggers).
 
-	  This is not related to standard keyboard LEDs which are controlled
-	  via the input system.
-
 if NEW_LEDS
 
 config LEDS_CLASS
diff -puN drivers/tty/Kconfig~input-route-kbd-leds-through-the-generic-leds-layer drivers/tty/Kconfig
--- a/drivers/tty/Kconfig~input-route-kbd-leds-through-the-generic-leds-layer
+++ a/drivers/tty/Kconfig
@@ -13,6 +13,10 @@ config VT
 	bool "Virtual terminal" if EXPERT
 	depends on !S390 && !UML
 	select INPUT
+	select NEW_LEDS
+	select LEDS_CLASS
+	select LEDS_TRIGGERS
+	select INPUT_LEDS
 	default y
 	---help---
 	  If you say Y here, you will get support for terminal devices with
diff -puN drivers/tty/vt/keyboard.c~input-route-kbd-leds-through-the-generic-leds-layer drivers/tty/vt/keyboard.c
--- a/drivers/tty/vt/keyboard.c~input-route-kbd-leds-through-the-generic-leds-layer
+++ a/drivers/tty/vt/keyboard.c
@@ -33,6 +33,7 @@
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/leds.h>
 
 #include <linux/kbd_kern.h>
 #include <linux/kbd_diacr.h>
@@ -130,6 +131,7 @@ static char rep;					/* flag telling cha
 static int shift_state = 0;
 
 static unsigned char ledstate = 0xff;			/* undefined */
+static unsigned char lockstate = 0xff;			/* undefined */
 static unsigned char ledioctl;
 
 /*
@@ -961,6 +963,41 @@ static void k_brl(struct vc_data *vc, un
 	}
 }
 
+/* We route VT keyboard "leds" through triggers */
+static void kbd_ledstate_trigger_activate(struct led_classdev *cdev);
+
+static struct led_trigger ledtrig_ledstate[] = {
+#define DEFINE_LEDSTATE_TRIGGER(kbd_led, nam) \
+	[kbd_led] = { \
+		.name = nam, \
+		.activate = kbd_ledstate_trigger_activate, \
+	}
+	DEFINE_LEDSTATE_TRIGGER(VC_SCROLLOCK, "kbd-scrollock"),
+	DEFINE_LEDSTATE_TRIGGER(VC_NUMLOCK,   "kbd-numlock"),
+	DEFINE_LEDSTATE_TRIGGER(VC_CAPSLOCK,  "kbd-capslock"),
+	DEFINE_LEDSTATE_TRIGGER(VC_KANALOCK,  "kbd-kanalock"),
+#undef DEFINE_LEDSTATE_TRIGGER
+};
+
+static void kbd_lockstate_trigger_activate(struct led_classdev *cdev);
+
+static struct led_trigger ledtrig_lockstate[] = {
+#define DEFINE_LOCKSTATE_TRIGGER(kbd_led, nam) \
+	[kbd_led] = { \
+		.name = nam, \
+		.activate = kbd_lockstate_trigger_activate, \
+	}
+	DEFINE_LOCKSTATE_TRIGGER(VC_SHIFTLOCK,  "kbd-shiftlock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_ALTGRLOCK,  "kbd-altgrlock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_CTRLLOCK,   "kbd-ctrllock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_ALTLOCK,    "kbd-altlock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_SHIFTLLOCK, "kbd-shiftllock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_SHIFTRLOCK, "kbd-shiftrlock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_CTRLLLOCK,  "kbd-ctrlllock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_CTRLRLOCK,  "kbd-ctrlrlock"),
+#undef DEFINE_LOCKSTATE_TRIGGER
+};
+
 /*
  * The leds display either (i) the status of NumLock, CapsLock, ScrollLock,
  * or (ii) whatever pattern of lights people want to show using KDSETLED,
@@ -995,18 +1032,25 @@ static inline unsigned char getleds(void
 	return kbd->ledflagstate;
 }
 
-static int kbd_update_leds_helper(struct input_handle *handle, void *data)
+/* Called on trigger connection, to set initial state */
+static void kbd_ledstate_trigger_activate(struct led_classdev *cdev)
 {
-	unsigned char leds = *(unsigned char *)data;
+	struct led_trigger *trigger = cdev->trigger;
+	int led = trigger - ledtrig_ledstate;
 
-	if (test_bit(EV_LED, handle->dev->evbit)) {
-		input_inject_event(handle, EV_LED, LED_SCROLLL, !!(leds & 0x01));
-		input_inject_event(handle, EV_LED, LED_NUML,    !!(leds & 0x02));
-		input_inject_event(handle, EV_LED, LED_CAPSL,   !!(leds & 0x04));
-		input_inject_event(handle, EV_SYN, SYN_REPORT, 0);
-	}
+	tasklet_disable(&keyboard_tasklet);
+	led_trigger_event(trigger, ledstate & (1 << led) ? LED_FULL : LED_OFF);
+	tasklet_enable(&keyboard_tasklet);
+}
 
-	return 0;
+static void kbd_lockstate_trigger_activate(struct led_classdev *cdev)
+{
+	struct led_trigger *trigger = cdev->trigger;
+	int led = trigger - ledtrig_lockstate;
+
+	tasklet_disable(&keyboard_tasklet);
+	led_trigger_event(trigger, lockstate & (1 << led) ? LED_FULL : LED_OFF);
+	tasklet_enable(&keyboard_tasklet);
 }
 
 /**
@@ -1095,16 +1139,29 @@ static void kbd_bh(unsigned long dummy)
 {
 	unsigned char leds;
 	unsigned long flags;
-	
+	int i;
+
 	spin_lock_irqsave(&led_lock, flags);
 	leds = getleds();
 	spin_unlock_irqrestore(&led_lock, flags);
 
 	if (leds != ledstate) {
-		input_handler_for_each_handle(&kbd_handler, &leds,
-					      kbd_update_leds_helper);
+		for (i = 0; i < ARRAY_SIZE(ledtrig_ledstate); i++)
+			if ((leds ^ ledstate) & (1 << i))
+				led_trigger_event(&ledtrig_ledstate[i],
+						leds & (1 << i)
+						? LED_FULL : LED_OFF);
 		ledstate = leds;
 	}
+
+	if (kbd->lockstate != lockstate) {
+		for (i = 0; i < ARRAY_SIZE(ledtrig_lockstate); i++)
+			if ((kbd->lockstate ^ lockstate) & (1 << i))
+				led_trigger_event(&ledtrig_lockstate[i],
+						kbd->lockstate & (1 << i)
+						? LED_FULL : LED_OFF);
+		lockstate = kbd->lockstate;
+	}
 }
 
 DECLARE_TASKLET_DISABLED(keyboard_tasklet, kbd_bh, 0);
@@ -1442,20 +1499,6 @@ static void kbd_disconnect(struct input_
 	kfree(handle);
 }
 
-/*
- * Start keyboard handler on the new keyboard by refreshing LED state to
- * match the rest of the system.
- */
-static void kbd_start(struct input_handle *handle)
-{
-	tasklet_disable(&keyboard_tasklet);
-
-	if (ledstate != 0xff)
-		kbd_update_leds_helper(handle, &ledstate);
-
-	tasklet_enable(&keyboard_tasklet);
-}
-
 static const struct input_device_id kbd_ids[] = {
 	{
 		.flags = INPUT_DEVICE_ID_MATCH_EVBIT,
@@ -1477,7 +1520,6 @@ static struct input_handler kbd_handler
 	.match		= kbd_match,
 	.connect	= kbd_connect,
 	.disconnect	= kbd_disconnect,
-	.start		= kbd_start,
 	.name		= "kbd",
 	.id_table	= kbd_ids,
 };
@@ -1501,6 +1543,20 @@ int __init kbd_init(void)
 	if (error)
 		return error;
 
+	for (i = 0; i < ARRAY_SIZE(ledtrig_ledstate); i++) {
+		error = led_trigger_register(&ledtrig_ledstate[i]);
+		if (error)
+			pr_err("error %d while registering trigger %s\n",
+					error, ledtrig_ledstate[i].name);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(ledtrig_lockstate); i++) {
+		error = led_trigger_register(&ledtrig_lockstate[i]);
+		if (error)
+			pr_err("error %d while registering trigger %s\n",
+					error, ledtrig_lockstate[i].name);
+	}
+
 	tasklet_enable(&keyboard_tasklet);
 	tasklet_schedule(&keyboard_tasklet);
 
diff -puN include/linux/input.h~input-route-kbd-leds-through-the-generic-leds-layer include/linux/input.h
--- a/include/linux/input.h~input-route-kbd-leds-through-the-generic-leds-layer
+++ a/include/linux/input.h
@@ -164,6 +164,8 @@ struct input_dev {
 	unsigned long snd[BITS_TO_LONGS(SND_CNT)];
 	unsigned long sw[BITS_TO_LONGS(SW_CNT)];
 
+	struct led_classdev *leds;
+
 	int (*open)(struct input_dev *dev);
 	void (*close)(struct input_dev *dev);
 	int (*flush)(struct input_dev *dev, struct file *file);
@@ -531,4 +533,22 @@ int input_ff_erase(struct input_dev *dev
 int input_ff_create_memless(struct input_dev *dev, void *data,
 		int (*play_effect)(struct input_dev *, void *, struct ff_effect *));
 
+#ifdef CONFIG_INPUT_LEDS
+
+int input_led_connect(struct input_dev *dev);
+void input_led_disconnect(struct input_dev *dev);
+
+#else
+
+int input_led_connect(struct input_dev *dev)
+{
+	return 0;
+}
+
+void input_led_disconnect(struct input_dev *dev)
+{
+}
+
+#endif
+
 #endif
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

input-route-kbd-leds-through-the-generic-leds-layer.patch
linux-next.patch

