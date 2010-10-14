From: akpm@linux-foundation.org
Subject: + leds-add-led-trigger-for-input-subsystem-led-events.patch added to -mm tree
Date: Thu, 14 Oct 2010 14:16:03 -0700
Message-ID: <201010142116.o9ELG3L3019651@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756067Ab0JNVQw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Oct 2010 17:16:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter.korsgaard@genesi-usa.com, dtor@mail.ru, rpurdie@rpsys.net


The patch titled
     leds: add led trigger for input subsystem led events
has been added to the -mm tree.  Its filename is
     leds-add-led-trigger-for-input-subsystem-led-events.patch

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
Subject: leds: add led trigger for input subsystem led events
From: Peter Korsgaard <peter.korsgaard@genesi-usa.com>

Add a LED trigger for the numlock/capslock/scrolllock states of the input
subsystem.  This is handy for devices like the Efika smartbook [1], which
uses a standard USB HID keyboard, but keyboard LEDs are connected directly
to GPIOs, or for any other situation where you want to show
num/caps/scrolllock state on LED subsystem LEDs.

[1] http://www.genesi-usa.com/products/smartbook

Signed-off-by: Peter Korsgaard <peter.korsgaard@genesi-usa.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig         |    7 +
 drivers/leds/Makefile        |    1 
 drivers/leds/ledtrig-input.c |  165 +++++++++++++++++++++++++++++++++
 3 files changed, 173 insertions(+)

diff -puN drivers/leds/Kconfig~leds-add-led-trigger-for-input-subsystem-led-events drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-add-led-trigger-for-input-subsystem-led-events
+++ a/drivers/leds/Kconfig
@@ -405,6 +405,13 @@ config LEDS_TRIGGER_DEFAULT_ON
 	  This allows LEDs to be initialised in the ON state.
 	  If unsure, say Y.
 
+config LEDS_TRIGGER_INPUT
+	tristate "Input subsystem LEDs Trigger"
+	depends on INPUT
+	help
+	  This allows LEDs to be controlled according to the state of
+	  the input subsystem LEDs (capslock/numlock/scrolllock/..)
+
 comment "iptables trigger is under Netfilter config (LED target)"
 	depends on LEDS_TRIGGERS
 
diff -puN drivers/leds/Makefile~leds-add-led-trigger-for-input-subsystem-led-events drivers/leds/Makefile
--- a/drivers/leds/Makefile~leds-add-led-trigger-for-input-subsystem-led-events
+++ a/drivers/leds/Makefile
@@ -53,3 +53,4 @@ obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)	+= 
 obj-$(CONFIG_LEDS_TRIGGER_BACKLIGHT)	+= ledtrig-backlight.o
 obj-$(CONFIG_LEDS_TRIGGER_GPIO)		+= ledtrig-gpio.o
 obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)	+= ledtrig-default-on.o
+obj-$(CONFIG_LEDS_TRIGGER_INPUT)	+= ledtrig-input.o
diff -puN /dev/null drivers/leds/ledtrig-input.c
--- /dev/null
+++ a/drivers/leds/ledtrig-input.c
@@ -0,0 +1,165 @@
+/*
+ * led trigger for input subsystem led states
+ *
+ * Peter Korsgaard <peter.korsgaard@genesi-usa.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/input.h>
+#include <linux/leds.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+#include "leds.h"
+
+struct input_trig {
+	int value; /* current value of input LED */
+	struct work_struct work;
+	struct led_trigger trig;
+};
+
+static int trig_connect(struct input_handler *handler, struct input_dev *dev,
+			 const struct input_device_id *id)
+{
+	struct input_handle *handle;
+	int error;
+
+	handle = kzalloc(sizeof(struct input_handle), GFP_KERNEL);
+	if (!handle)
+		return -ENOMEM;
+
+	handle->dev = dev;
+	handle->handler = handler;
+	handle->name = "ledtrig-input";
+
+	error = input_register_handle(handle);
+	if (error)
+		goto err_free_handle;
+
+	error = input_open_device(handle);
+	if (error)
+		goto err_unregister_handle;
+
+	return 0;
+
+ err_unregister_handle:
+	input_unregister_handle(handle);
+ err_free_handle:
+	kfree(handle);
+	return error;
+}
+
+static void trig_disconnect(struct input_handle *handle)
+{
+	input_close_device(handle);
+	input_unregister_handle(handle);
+	kfree(handle);
+}
+
+static void trig_activate(struct led_classdev *led_cdev)
+{
+	struct input_trig *input = container_of(led_cdev->trigger,
+						struct input_trig, trig);
+
+	led_set_brightness(led_cdev, input->value ? LED_FULL : LED_OFF);
+}
+
+static struct input_trig trig[] = {
+	[LED_NUML] = {
+		.trig = {
+			.name = "numlock",
+			.activate = trig_activate,
+		},
+	},
+	[LED_CAPSL] = {
+		.trig = {
+			.name = "capslock",
+			.activate = trig_activate,
+		}
+	},
+	[LED_SCROLLL] = {
+		.trig = {
+			.name = "scrolllock",
+			.activate = trig_activate,
+		},
+	},
+};
+
+static void trig_event(struct input_handle *handle, unsigned int type,
+		      unsigned int code, int value)
+{
+	if (type == EV_LED && code < ARRAY_SIZE(trig)) {
+		if (value != trig[code].value) {
+			trig[code].value = value;
+			schedule_work(&trig[code].work);
+		}
+	}
+}
+
+static const struct input_device_id trig_ids[] = {
+	{
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT,
+		.evbit = { BIT_MASK(EV_LED) },
+	},
+	{ },			/* Terminating zero entry */
+};
+MODULE_DEVICE_TABLE(input, trig_ids);
+
+static struct input_handler trig_handler = {
+	.event		= trig_event,
+	.connect	= trig_connect,
+	.disconnect	= trig_disconnect,
+	.name		= "ledtrig-input",
+	.id_table	= trig_ids,
+};
+
+static void trig_work(struct work_struct *work)
+{
+	struct input_trig *input = container_of(work, struct input_trig, work);
+
+	led_trigger_event(&input->trig, input->value ? LED_FULL : LED_OFF);
+}
+
+static int __init trig_init(void)
+{
+	int i, ret;
+
+	for (i = 0; i < ARRAY_SIZE(trig); i++) {
+		INIT_WORK(&trig[i].work, trig_work);
+		ret = led_trigger_register(&trig[i].trig);
+		if (ret)
+			goto trig_reg_fail;
+	}
+
+	ret = input_register_handler(&trig_handler);
+	if (!ret)
+		return 0;
+
+ trig_reg_fail:
+	for (; i > 0; i--)
+		led_trigger_unregister(&trig[i-1].trig);
+
+	return ret;
+}
+module_init(trig_init);
+
+static void __exit trig_exit(void)
+{
+	int i;
+
+	input_unregister_handler(&trig_handler);
+
+	for (i = 0; i < ARRAY_SIZE(trig); i++) {
+		cancel_work_sync(&trig[i].work);
+		led_trigger_unregister(&trig[i].trig);
+	}
+}
+module_exit(trig_exit);
+
+MODULE_AUTHOR("Peter Korsgaard <peter.korsgaard@genesi-usa.com>");
+MODULE_DESCRIPTION("LED trigger for input subsystem LEDs");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from peter.korsgaard@genesi-usa.com are

leds-add-led-trigger-for-input-subsystem-led-events.patch

