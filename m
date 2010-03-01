From: akpm@linux-foundation.org
Subject: [merged] leds-add-dell-business-class-netbook-led-driver.patch removed from -mm tree
Date: Mon, 01 Mar 2010 11:46:39 -0800
Message-ID: <201003011946.o21JkdlU028690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751546Ab0CATrl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Mar 2010 14:47:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Robert_Rodgers@dell.com, Jim_Dailey@dell.com, Louis_Davis@dell.com, dtor@mail.ru, mjg@redhat.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     leds: add Dell Business Class Netbook LED driver
has been removed from the -mm tree.  Its filename was
     leds-add-dell-business-class-netbook-led-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: leds: add Dell Business Class Netbook LED driver
From: Bob Rodgers <Robert_Rodgers@dell.com>

Add an LED driver to support the Dell Activity LED on the Dell Latitude
2100 netbook and future products to come.  The Activity LED is visible
externally in the lid so classroom instructors can observe it from a
distance.  The driver uses the sysfs led_class and provides a standard LED
interface.  This driver is ready for submission upstream.

Signed-off by: Bob Rodgers <Robert_Rodgers@dell.com>
Signed-off-by: Louis Davis <Louis_Davis@dell.com>
Signed-off-by: Jim Dailey <Jim_Dailey@dell.com>, Developers
Acked-by: Matthew Garrett <mjg@redhat.com>
Acked-by: Dmitry Torokhov <dtor@mail.ru>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig    |    7 +
 drivers/leds/Makefile   |    1 
 drivers/leds/dell-led.c |  200 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 208 insertions(+)

diff -puN drivers/leds/Kconfig~leds-add-dell-business-class-netbook-led-driver drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~leds-add-dell-business-class-netbook-led-driver
+++ a/drivers/leds/Kconfig
@@ -287,6 +287,13 @@ config LEDS_TRIGGERS
 
 if LEDS_TRIGGERS
 
+config LEDS_DELL_NETBOOKS
+	tristate "External LED on Dell Business Netbooks"
+	depends on LEDS_CLASS && X86 && ACPI_WMI
+	help
+	  This adds support for the Latitude 2100 and similar
+	  notebooks that have an external LED.
+
 comment "LED Triggers"
 
 config LEDS_TRIGGER_TIMER
diff -puN drivers/leds/Makefile~leds-add-dell-business-class-netbook-led-driver drivers/leds/Makefile
--- a/drivers/leds/Makefile~leds-add-dell-business-class-netbook-led-driver
+++ a/drivers/leds/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_LEDS_REGULATOR)		+= leds-re
 obj-$(CONFIG_LEDS_INTEL_SS4200)		+= leds-ss4200.o
 obj-$(CONFIG_LEDS_LT3593)		+= leds-lt3593.o
 obj-$(CONFIG_LEDS_ADP5520)		+= leds-adp5520.o
+obj-$(CONFIG_LEDS_DELL_NETBOOKS)	+= dell-led.o
 
 # LED SPI Drivers
 obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
diff -puN /dev/null drivers/leds/dell-led.c
--- /dev/null
+++ a/drivers/leds/dell-led.c
@@ -0,0 +1,200 @@
+/*
+ * dell_led.c - Dell LED Driver
+ *
+ * Copyright (C) 2010 Dell Inc.
+ * Louis Davis <louis_davis@dell.com>
+ * Jim Dailey <jim_dailey@dell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/acpi.h>
+#include <linux/leds.h>
+
+MODULE_AUTHOR("Louis Davis/Jim Dailey");
+MODULE_DESCRIPTION("Dell LED Control Driver");
+MODULE_LICENSE("GPL");
+
+#define DELL_LED_BIOS_GUID "F6E4FE6E-909D-47cb-8BAB-C9F6F2F8D396"
+MODULE_ALIAS("wmi:" DELL_LED_BIOS_GUID);
+
+/* Error Result Codes: */
+#define INVALID_DEVICE_ID	250
+#define INVALID_PARAMETER	251
+#define INVALID_BUFFER		252
+#define INTERFACE_ERROR		253
+#define UNSUPPORTED_COMMAND	254
+#define UNSPECIFIED_ERROR	255
+
+/* Device ID */
+#define DEVICE_ID_PANEL_BACK	1
+
+/* LED Commands */
+#define CMD_LED_ON	16
+#define CMD_LED_OFF	17
+#define CMD_LED_BLINK	18
+
+struct bios_args {
+	unsigned char length;
+	unsigned char result_code;
+	unsigned char device_id;
+	unsigned char command;
+	unsigned char on_time;
+	unsigned char off_time;
+};
+
+static int dell_led_perform_fn(u8 length,
+		u8 result_code,
+		u8 device_id,
+		u8 command,
+		u8 on_time,
+		u8 off_time)
+{
+	struct bios_args *bios_return;
+	u8 return_code;
+	union acpi_object *obj;
+	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	struct acpi_buffer input;
+	acpi_status status;
+
+	struct bios_args args;
+	args.length = length;
+	args.result_code = result_code;
+	args.device_id = device_id;
+	args.command = command;
+	args.on_time = on_time;
+	args.off_time = off_time;
+
+	input.length = sizeof(struct bios_args);
+	input.pointer = &args;
+
+	status = wmi_evaluate_method(DELL_LED_BIOS_GUID,
+		1,
+		1,
+		&input,
+		&output);
+
+	if (ACPI_FAILURE(status))
+		return status;
+
+	obj = output.pointer;
+
+	if (!obj)
+		return -EINVAL;
+	else if (obj->type != ACPI_TYPE_BUFFER) {
+		kfree(obj);
+		return -EINVAL;
+	}
+
+	bios_return = ((struct bios_args *)obj->buffer.pointer);
+	return_code = bios_return->result_code;
+
+	kfree(obj);
+
+	return return_code;
+}
+
+static int led_on(void)
+{
+	return dell_led_perform_fn(3,	/* Length of command */
+		INTERFACE_ERROR,	/* Init to  INTERFACE_ERROR */
+		DEVICE_ID_PANEL_BACK,	/* Device ID */
+		CMD_LED_ON,		/* Command */
+		0,			/* not used */
+		0);			/* not used */
+}
+
+static int led_off(void)
+{
+	return dell_led_perform_fn(3,	/* Length of command */
+		INTERFACE_ERROR,	/* Init to  INTERFACE_ERROR */
+		DEVICE_ID_PANEL_BACK,	/* Device ID */
+		CMD_LED_OFF,		/* Command */
+		0,			/* not used */
+		0);			/* not used */
+}
+
+static int led_blink(unsigned char on_eighths,
+		unsigned char off_eighths)
+{
+	return dell_led_perform_fn(5,	/* Length of command */
+		INTERFACE_ERROR,	/* Init to  INTERFACE_ERROR */
+		DEVICE_ID_PANEL_BACK,	/* Device ID */
+		CMD_LED_BLINK,		/* Command */
+		on_eighths,		/* blink on in eigths of a second */
+		off_eighths);		/* blink off in eights of a second */
+}
+
+static void dell_led_set(struct led_classdev *led_cdev,
+		enum led_brightness value)
+{
+	if (value == LED_OFF)
+		led_off();
+	else
+		led_on();
+}
+
+static int dell_led_blink(struct led_classdev *led_cdev,
+		unsigned long *delay_on,
+		unsigned long *delay_off)
+{
+	unsigned long on_eighths;
+	unsigned long off_eighths;
+
+	/* The Dell LED delay is based on 125ms intervals.
+	   Need to round up to next interval. */
+
+	on_eighths = (*delay_on + 124) / 125;
+	if (0 == on_eighths)
+		on_eighths = 1;
+	if (on_eighths > 255)
+		on_eighths = 255;
+	*delay_on = on_eighths * 125;
+
+	off_eighths = (*delay_off + 124) / 125;
+	if (0 == off_eighths)
+		off_eighths = 1;
+	if (off_eighths > 255)
+		off_eighths = 255;
+	*delay_off = off_eighths * 125;
+
+	led_blink(on_eighths, off_eighths);
+
+	return 0;
+}
+
+static struct led_classdev dell_led = {
+	.name		= "dell::lid",
+	.brightness	= LED_OFF,
+	.max_brightness = 1,
+	.brightness_set = dell_led_set,
+	.blink_set	= dell_led_blink,
+	.flags		= LED_CORE_SUSPENDRESUME,
+};
+
+static int __init dell_led_init(void)
+{
+	int error = 0;
+
+	if (!wmi_has_guid(DELL_LED_BIOS_GUID))
+		return -ENODEV;
+
+	error = led_off();
+	if (error != 0)
+		return -ENODEV;
+
+	return led_classdev_register(NULL, &dell_led);
+}
+
+static void __exit dell_led_exit(void)
+{
+	led_classdev_unregister(&dell_led);
+
+	led_off();
+}
+
+module_init(dell_led_init);
+module_exit(dell_led_exit);
_

Patches currently in -mm which might be from Robert_Rodgers@dell.com are

linux-next.patch

