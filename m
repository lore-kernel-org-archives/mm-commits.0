From: akpm@linux-foundation.org
Subject: + misc-add-dell-laptop-driver.patch added to -mm tree
Date: Tue, 30 Dec 2008 15:47:09 -0800
Message-ID: <200812302347.mBUNl9AD015269@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752298AbYL3Xrv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 18:47:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg59@srcf.ucam.org, Matt_Domsch@dell.com, hmh@hmh.eng.br, ivdoorn@gmail.com, lenb@kernel.org, mjg@redhat.com, rpurdie@rpsys.net


The patch titled
     misc: add dell-laptop driver
has been added to the -mm tree.  Its filename is
     misc-add-dell-laptop-driver.patch

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
Subject: misc: add dell-laptop driver
From: Matthew Garrett <mjg59@srcf.ucam.org>

Add a driver for controlling Dell-specific backlight and rfkill interfaces.
This driver makes use of the dcdbas interface to the Dell firmware to
allow the backlight and rfkill interfaces on Dell systems to be driven
through the standardised sysfs interfaces.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                |    5 
 drivers/misc/Kconfig       |   12 
 drivers/misc/Makefile      |    1 
 drivers/misc/dell-laptop.c |  436 +++++++++++++++++++++++++++++++++++
 4 files changed, 454 insertions(+)

diff -puN MAINTAINERS~misc-add-dell-laptop-driver MAINTAINERS
--- a/MAINTAINERS~misc-add-dell-laptop-driver
+++ a/MAINTAINERS
@@ -1361,6 +1361,11 @@ P:	Maciej W. Rozycki
 M:	macro@linux-mips.org
 S:	Maintained
 
+DELL LAPTOP DRIVER
+P:	Matthew Garrett
+M:	mjg59@srcf.ucam.org
+S:	Maintained
+
 DELL LAPTOP SMM DRIVER
 P:	Massimo Dal Zotto
 M:	dz@debian.org
diff -puN drivers/misc/Kconfig~misc-add-dell-laptop-driver drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~misc-add-dell-laptop-driver
+++ a/drivers/misc/Kconfig
@@ -218,6 +218,18 @@ config SGI_GRU_DEBUG
 	This option enables addition debugging code for the SGI GRU driver. If
 	you are unsure, say N.
 
+config DELL_LAPTOP
+	tristate "Dell Laptop Extras (EXPERIMENTAL)"
+	depends on X86
+	depends on DCDBAS
+	depends on EXPERIMENTAL
+	depends on BACKLIGHT_CLASS_DEVICE
+	depends on RFKILL
+	default n
+	---help---
+	This driver adds support for rfkill and backlight control to Dell
+	laptops.
+
 source "drivers/misc/c2port/Kconfig"
 
 endif # MISC_DEVICES
diff -puN drivers/misc/Makefile~misc-add-dell-laptop-driver drivers/misc/Makefile
--- a/drivers/misc/Makefile~misc-add-dell-laptop-driver
+++ a/drivers/misc/Makefile
@@ -19,4 +19,5 @@ obj-$(CONFIG_KGDB_TESTS)	+= kgdbts.o
 obj-$(CONFIG_SGI_XP)		+= sgi-xp/
 obj-$(CONFIG_SGI_GRU)		+= sgi-gru/
 obj-$(CONFIG_HP_ILO)		+= hpilo.o
+obj-$(CONFIG_DELL_LAPTOP)	+= dell-laptop.o
 obj-$(CONFIG_C2PORT)		+= c2port/
diff -puN /dev/null drivers/misc/dell-laptop.c
--- /dev/null
+++ a/drivers/misc/dell-laptop.c
@@ -0,0 +1,436 @@
+/*
+ *  Driver for Dell laptop extras
+ *
+ *  Copyright (c) Red Hat <mjg@redhat.com>
+ *
+ *  Based on documentation in the libsmbios package, Copyright (C) 2005 Dell
+ *  Inc.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/backlight.h>
+#include <linux/err.h>
+#include <linux/dmi.h>
+#include <linux/io.h>
+#include <linux/rfkill.h>
+#include <linux/power_supply.h>
+#include <linux/acpi.h>
+#include "../firmware/dcdbas.h"
+
+#define BRIGHTNESS_TOKEN 0x7d
+
+/* This structure will be modified by the firmware when we enter
+ * system management mode, hence the volatiles */
+
+struct calling_interface_buffer {
+	u16 class;
+	u16 select;
+	volatile u32 input[4];
+	volatile u32 output[4];
+} __packed;
+
+struct calling_interface_token {
+	u16 tokenID;
+	u16 location;
+	union {
+		u16 value;
+		u16 stringlength;
+	};
+};
+
+struct calling_interface_structure {
+	struct dmi_header header;
+	u16 cmdIOAddress;
+	u8 cmdIOCode;
+	u32 supportedCmds;
+	struct calling_interface_token tokens[];
+} __packed;
+
+static int da_command_address;
+static int da_command_code;
+static int da_num_tokens;
+static struct calling_interface_token *da_tokens;
+
+static struct backlight_device *dell_backlight_device;
+static struct rfkill *wifi_rfkill;
+static struct rfkill *bluetooth_rfkill;
+static struct rfkill *wwan_rfkill;
+
+static const struct dmi_system_id __initdata dell_device_table[] = {
+	{
+		.ident = "Dell laptop",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_CHASSIS_TYPE, "8"),
+		},
+	},
+	{ }
+};
+
+static void parse_da_table(const struct dmi_header *dm)
+{
+	/* Final token is a terminator, so we don't want to copy it */
+	int tokens = (dm->length-11)/sizeof(struct calling_interface_token)-1;
+	struct calling_interface_structure *table =
+		container_of(dm, struct calling_interface_structure, header);
+
+	/* 4 bytes of table header, plus 7 bytes of Dell header, plus at least
+	   6 bytes of entry */
+
+	if (dm->length < 17)
+		return;
+
+	da_command_address = table->cmdIOAddress;
+	da_command_code = table->cmdIOCode;
+
+	da_tokens = krealloc(da_tokens, (da_num_tokens + tokens) *
+			     sizeof(struct calling_interface_token),
+			     GFP_KERNEL);
+
+	if (!da_tokens)
+		return;
+
+	memcpy(da_tokens+da_num_tokens, table->tokens,
+	       sizeof(struct calling_interface_token) * tokens);
+
+	da_num_tokens += tokens;
+}
+
+static void find_tokens(const struct dmi_header *dm)
+{
+	switch (dm->type) {
+	case 0xd4: /* Indexed IO */
+		break;
+	case 0xd5: /* Protected Area Type 1 */
+		break;
+	case 0xd6: /* Protected Area Type 2 */
+		break;
+	case 0xda: /* Calling interface */
+		parse_da_table(dm);
+		break;
+	}
+}
+
+static int find_token_location(int tokenid)
+{
+	int i;
+	for (i = 0; i < da_num_tokens; i++) {
+		if (da_tokens[i].tokenID == tokenid)
+			return da_tokens[i].location;
+	}
+
+	return -1;
+}
+
+static struct calling_interface_buffer *
+dell_send_request(struct calling_interface_buffer *buffer, int class,
+		  int select)
+{
+	struct smi_cmd command;
+
+	command.magic = SMI_CMD_MAGIC;
+	command.command_address = da_command_address;
+	command.command_code = da_command_code;
+	command.ebx = virt_to_phys(buffer);
+	command.ecx = 0x42534931;
+
+	buffer->class = class;
+	buffer->select = select;
+
+	dcdbas_smi_request(&command);
+
+	return buffer;
+}
+
+/* Derived from information in DellWirelessCtl.cpp:
+   Class 17, select 11 is radio control. It returns an array of 32-bit values.
+
+   result[0]: return code
+   result[1]:
+     Bit 0:      Hardware switch supported
+     Bit 1:      Wifi locator supported
+     Bit 2:      Wifi is supported
+     Bit 3:      Bluetooth is supported
+     Bit 4:      WWAN is supported
+     Bit 5:      Wireless keyboard supported
+     Bits 6-7:   Reserved
+     Bit 8:      Wifi is installed
+     Bit 9:      Bluetooth is installed
+     Bit 10:     WWAN is installed
+     Bits 11-15: Reserved
+     Bit 16:     Hardware switch is on
+     Bit 17:     Wifi is blocked
+     Bit 18:     Bluetooth is blocked
+     Bit 19:     WWAN is blocked
+     Bits 20-31: Reserved
+   result[2]: NVRAM size in bytes
+   result[3]: NVRAM format version number
+*/
+
+static int dell_rfkill_set(int radio, enum rfkill_state state)
+{
+	struct calling_interface_buffer buffer;
+	int disable = (state == RFKILL_STATE_UNBLOCKED) ? 0 : 1;
+
+	memset(&buffer, 0, sizeof(struct calling_interface_buffer));
+	buffer.input[0] = (1 | (radio<<8) | (disable << 16));
+	dell_send_request(&buffer, 17, 11);
+
+	return 0;
+}
+
+static int dell_wifi_set(void *data, enum rfkill_state state)
+{
+	return dell_rfkill_set(1, state);
+}
+
+static int dell_bluetooth_set(void *data, enum rfkill_state state)
+{
+	return dell_rfkill_set(2, state);
+}
+
+static int dell_wwan_set(void *data, enum rfkill_state state)
+{
+	return dell_rfkill_set(3, state);
+}
+
+static int dell_rfkill_get(int bit, enum rfkill_state *state)
+{
+	struct calling_interface_buffer buffer;
+	int status;
+	int new_state = RFKILL_STATE_HARD_BLOCKED;
+
+	memset(&buffer, 0, sizeof(struct calling_interface_buffer));
+	dell_send_request(&buffer, 17, 11);
+	status = buffer.output[1];
+
+	if (status & (1<<16))
+		new_state = RFKILL_STATE_SOFT_BLOCKED;
+
+	if (status & (1<<bit))
+		*state = new_state;
+	else
+		*state = RFKILL_STATE_UNBLOCKED;
+
+	return 0;
+}
+
+static int dell_wifi_get(void *data, enum rfkill_state *state)
+{
+	return dell_rfkill_get(17, state);
+}
+
+static int dell_bluetooth_get(void *data, enum rfkill_state *state)
+{
+	return dell_rfkill_get(18, state);
+}
+
+static int dell_wwan_get(void *data, enum rfkill_state *state)
+{
+	return dell_rfkill_get(19, state);
+}
+
+static int dell_setup_rfkill(void)
+{
+	struct calling_interface_buffer buffer;
+	int status;
+	int ret;
+
+	memset(&buffer, 0, sizeof(struct calling_interface_buffer));
+	dell_send_request(&buffer, 17, 11);
+	status = buffer.output[1];
+
+	if ((status & (1<<2|1<<8)) == (1<<2|1<<8)) {
+		wifi_rfkill = rfkill_allocate(NULL, RFKILL_TYPE_WLAN);
+		if (!wifi_rfkill)
+			goto err_wifi;
+		wifi_rfkill->name = "dell-wifi";
+		wifi_rfkill->toggle_radio = dell_wifi_set;
+		wifi_rfkill->get_state = dell_wifi_get;
+		ret = rfkill_register(wifi_rfkill);
+		if (ret)
+			goto err_wifi;
+	}
+
+	if ((status & (1<<3|1<<9)) == (1<<3|1<<9)) {
+		bluetooth_rfkill = rfkill_allocate(NULL, RFKILL_TYPE_BLUETOOTH);
+		if (!bluetooth_rfkill)
+			goto err_bluetooth;
+		bluetooth_rfkill->name = "dell-bluetooth";
+		bluetooth_rfkill->toggle_radio = dell_bluetooth_set;
+		bluetooth_rfkill->get_state = dell_bluetooth_get;
+		ret = rfkill_register(bluetooth_rfkill);
+		if (ret)
+			goto err_bluetooth;
+	}
+
+	if ((status & (1<<4|1<<10)) == (1<<4|1<<10)) {
+		wwan_rfkill = rfkill_allocate(NULL, RFKILL_TYPE_WWAN);
+		if (!wwan_rfkill)
+			goto err_wwan;
+		wwan_rfkill->name = "dell-wwan";
+		wwan_rfkill->toggle_radio = dell_wwan_set;
+		wwan_rfkill->get_state = dell_wwan_get;
+		ret = rfkill_register(wwan_rfkill);
+		if (ret)
+			goto err_wwan;
+	}
+
+	return 0;
+err_wwan:
+	if (wwan_rfkill)
+		rfkill_free(wwan_rfkill);
+	if (bluetooth_rfkill) {
+		rfkill_unregister(bluetooth_rfkill);
+		bluetooth_rfkill = NULL;
+	}
+err_bluetooth:
+	if (bluetooth_rfkill)
+		rfkill_free(bluetooth_rfkill);
+	if (wifi_rfkill) {
+		rfkill_unregister(wifi_rfkill);
+		wifi_rfkill = NULL;
+	}
+err_wifi:
+	if (wifi_rfkill)
+		rfkill_free(wifi_rfkill);
+
+	return ret;
+}
+
+static int dell_send_intensity(struct backlight_device *bd)
+{
+	struct calling_interface_buffer buffer;
+
+	memset(&buffer, 0, sizeof(struct calling_interface_buffer));
+	buffer.input[0] = find_token_location(BRIGHTNESS_TOKEN);
+	buffer.input[1] = bd->props.brightness;
+
+	if (buffer.input[0] == -1)
+		return -ENODEV;
+
+	if (power_supply_is_system_supplied() > 0)
+		dell_send_request(&buffer, 1, 2);
+	else
+		dell_send_request(&buffer, 1, 1);
+
+	return 0;
+}
+
+static int dell_get_intensity(struct backlight_device *bd)
+{
+	struct calling_interface_buffer buffer;
+
+	memset(&buffer, 0, sizeof(struct calling_interface_buffer));
+	buffer.input[0] = find_token_location(BRIGHTNESS_TOKEN);
+
+	if (buffer.input[0] == -1)
+		return -ENODEV;
+
+	if (power_supply_is_system_supplied() > 0)
+		dell_send_request(&buffer, 0, 2);
+	else
+		dell_send_request(&buffer, 0, 1);
+
+	return buffer.output[1];
+}
+
+static struct backlight_ops dell_ops = {
+	.get_brightness = dell_get_intensity,
+	.update_status  = dell_send_intensity,
+};
+
+static int __init dell_init(void)
+{
+	struct calling_interface_buffer buffer;
+	int max_intensity = 0;
+	int ret;
+
+	if (!dmi_check_system(dell_device_table))
+		return -ENODEV;
+
+	dmi_walk(find_tokens);
+
+	if (!da_tokens)  {
+		printk(KERN_INFO "dell-laptop: Unable to find dmi tokens\n");
+		return -ENODEV;
+	}
+
+	ret = dell_setup_rfkill();
+
+	if (ret) {
+		printk(KERN_WARNING "dell-laptop: Unable to setup rfkill\n");
+		goto out;
+	}
+
+#ifdef CONFIG_ACPI
+	/* In the event of an ACPI backlight being available, don't
+	 * register the platform controller.
+	 */
+	if (acpi_video_backlight_support())
+		return 0;
+#endif
+
+	memset(&buffer, 0, sizeof(struct calling_interface_buffer));
+	buffer.input[0] = find_token_location(BRIGHTNESS_TOKEN);
+
+	if (buffer.input[0] != -1) {
+		dell_send_request(&buffer, 0, 2);
+		max_intensity = buffer.output[3];
+	}
+
+	if (max_intensity) {
+		dell_backlight_device = backlight_device_register(
+			"dell_backlight",
+			NULL, NULL,
+			&dell_ops);
+
+		if (IS_ERR(dell_backlight_device)) {
+			ret = PTR_ERR(dell_backlight_device);
+			dell_backlight_device = NULL;
+			goto out;
+		}
+
+		dell_backlight_device->props.max_brightness = max_intensity;
+		dell_backlight_device->props.brightness =
+			dell_get_intensity(dell_backlight_device);
+		backlight_update_status(dell_backlight_device);
+	}
+
+	return 0;
+out:
+	if (wifi_rfkill)
+		rfkill_unregister(wifi_rfkill);
+	if (bluetooth_rfkill)
+		rfkill_unregister(bluetooth_rfkill);
+	if (wwan_rfkill)
+		rfkill_unregister(wwan_rfkill);
+	kfree(da_tokens);
+	return ret;
+}
+
+static void __exit dell_exit(void)
+{
+	backlight_device_unregister(dell_backlight_device);
+	if (wifi_rfkill)
+		rfkill_unregister(wifi_rfkill);
+	if (bluetooth_rfkill)
+		rfkill_unregister(bluetooth_rfkill);
+	if (wwan_rfkill)
+		rfkill_unregister(wwan_rfkill);
+}
+
+module_init(dell_init);
+module_exit(dell_exit);
+
+MODULE_AUTHOR("Matthew Garrett <mjg@redhat.com>");
+MODULE_DESCRIPTION("Dell laptop driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("dmi:*svnDellInc.:*:ct8:*");
_

Patches currently in -mm which might be from mjg59@srcf.ucam.org are

origin.patch
linux-next.patch
eeepc-laptop-enable-bluetooth-for-asus-eee-901.patch
video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5.patch
video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5-fix.patch
video-mbp_nvidia_bl-add-a-debug-switch.patch
hp-wmi-handle-rfkill_register-failure.patch
misc-add-dell-laptop-driver.patch
misc-add-dell-wmi-driver-for-hotkey-control.patch
dcdbas-export-functionality-for-use-in-other-drivers.patch

