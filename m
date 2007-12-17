From: akpm@linux-foundation.org
Subject: - fujitsu-application-panel-driver.patch removed from -mm tree
Date: Mon, 17 Dec 2007 15:39:13 -0800
Message-ID: <200712172339.lBHNdDJS008109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50282 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758937AbXLQXkF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 18:40:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, dtor@mail.ru, jkosina@suse.cz, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Fujitsu application panel driver
has been removed from the -mm tree.  Its filename was
     fujitsu-application-panel-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fujitsu application panel driver
From: Stephen Hemminger <shemminger@linux-foundation.org>

This driver supports the application buttons on some Fujitsu Lifebook
laptops.  It is based on the earlier apanel driver done by Jochen Eisenger,
but with many changes.  The original driver used ioctl's and a separate
user space program (see http://apanel.sourceforge.net).  This driver hooks
into the input subsystem so that the normal keys act as expected without a
daemon.  In addition to buttons, the Mail Led is handled via LEDs class
device.

The driver now supports redefinable keymaps and no longer has to have a DMI
table for all Fujitsu laptops.

I thought about mixing this driver should be integrated into the Fujitsu
laptop extras driver that handles backlight, but rejected the idea because
it wasn't clear if all the Fujitsu laptops supported both.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/Kconfig  |   14 +
 drivers/input/misc/Makefile |    1 
 drivers/input/misc/apanel.c |  377 ++++++++++++++++++++++++++++++++++
 3 files changed, 392 insertions(+)

diff -puN drivers/input/misc/Kconfig~fujitsu-application-panel-driver drivers/input/misc/Kconfig
--- a/drivers/input/misc/Kconfig~fujitsu-application-panel-driver
+++ a/drivers/input/misc/Kconfig
@@ -40,6 +40,20 @@ config INPUT_M68K_BEEP
 	tristate "M68k Beeper support"
 	depends on M68K
 
+config INPUT_APANEL
+	tristate "Fujitsu Lifebook Application Panel buttons"
+	depends on X86
+	select I2C_I801
+	select INPUT_POLLDEV
+	select CHECK_SIGNATURE
+	help
+	 Say Y here for support of the Application Panel buttons, used on
+	 Fujitsu Lifebook. These are attached to the mainboard through
+	 an SMBus interface managed by the I2C Intel ICH (i801) driver.
+
+	 To compile this driver as a module, choose M here: the module will
+	 be called apanel.
+
 config INPUT_IXP4XX_BEEPER
 	tristate "IXP4XX Beeper support"
 	depends on ARCH_IXP4XX
diff -puN drivers/input/misc/Makefile~fujitsu-application-panel-driver drivers/input/misc/Makefile
--- a/drivers/input/misc/Makefile~fujitsu-application-panel-driver
+++ a/drivers/input/misc/Makefile
@@ -18,3 +18,4 @@ obj-$(CONFIG_INPUT_POWERMATE)		+= powerm
 obj-$(CONFIG_INPUT_YEALINK)		+= yealink.o
 obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
 obj-$(CONFIG_INPUT_UINPUT)		+= uinput.o
+obj-$(CONFIG_INPUT_APANEL)		+= apanel.o
diff -puN /dev/null drivers/input/misc/apanel.c
--- /dev/null
+++ a/drivers/input/misc/apanel.c
@@ -0,0 +1,377 @@
+/*
+ *  Fujitsu Lifebook Application Panel button drive
+ *
+ *  Copyright (C) 2007 Stephen Hemminger <shemminger@linux-foundation.org>
+ *  Copyright (C) 2001-2003 Jochen Eisinger <jochen@penguin-breeder.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * Many Fujitsu Lifebook laptops have a small panel of buttons that are
+ * accessible via the i2c/smbus interface. This driver polls those
+ * buttons and generates input events.
+ *
+ * For more details see:
+ * 	http://apanel.sourceforge.net/tech.php
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/ioport.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/input-polldev.h>
+#include <linux/i2c.h>
+#include <linux/workqueue.h>
+#include <linux/leds.h>
+
+#define APANEL_NAME	"Fujitsu Application Panel"
+#define APANEL_VERSION	"1.3.1"
+#define APANEL		"apanel"
+
+/* How often we poll keys - msecs */
+#define POLL_INTERVAL_DEFAULT	1000
+
+/* Magic constants in BIOS that tell about buttons */
+enum apanel_devid {
+	APANEL_DEV_NONE	  = 0,
+	APANEL_DEV_APPBTN = 1,
+	APANEL_DEV_CDBTN  = 2,
+	APANEL_DEV_LCD	  = 3,
+	APANEL_DEV_LED	  = 4,
+
+	APANEL_DEV_MAX,
+};
+
+enum apanel_chip {
+	CHIP_NONE    = 0,
+	CHIP_OZ992C  = 1,
+	CHIP_OZ163T  = 2,
+	CHIP_OZ711M3 = 4,
+};
+
+/* Result of BIOS snooping/probing -- what features are supported */
+static enum apanel_chip device_chip[APANEL_DEV_MAX];
+
+#define MAX_PANEL_KEYS	12
+
+struct apanel {
+	struct input_polled_dev *ipdev;
+	struct i2c_client client;
+	unsigned keymap[MAX_PANEL_KEYS];
+	u16    nkeys;
+	u16    led_bits;
+	struct work_struct led_work;
+	struct led_classdev mail_led;
+};
+
+
+static int apanel_probe(struct i2c_adapter *, int, int);
+
+/* for now, we only support one address */
+static unsigned short normal_i2c[] = {0, I2C_CLIENT_END};
+static unsigned short ignore = I2C_CLIENT_END;
+static struct i2c_client_address_data addr_data = {
+	.normal_i2c	= normal_i2c,
+	.probe		= &ignore,
+	.ignore		= &ignore,
+};
+
+static void report_key(struct input_dev *input, unsigned keycode)
+{
+	pr_debug(APANEL ": report key %#x\n", keycode);
+	input_report_key(input, keycode, 1);
+	input_sync(input);
+
+	input_report_key(input, keycode, 0);
+	input_sync(input);
+}
+
+/* Poll for key changes
+ *
+ * Read Application keys via SMI
+ *  A (0x4), B (0x8), Internet (0x2), Email (0x1).
+ *
+ * CD keys:
+ * Forward (0x100), Rewind (0x200), Stop (0x400), Pause (0x800)
+ */
+static void apanel_poll(struct input_polled_dev *ipdev)
+{
+	struct apanel *ap = ipdev->private;
+	struct input_dev *idev = ipdev->input;
+	u8 cmd = device_chip[APANEL_DEV_APPBTN] == CHIP_OZ992C ? 0 : 8;
+	s32 data;
+	int i;
+
+	data = i2c_smbus_read_word_data(&ap->client, cmd);
+	if (data < 0)
+		return;	/* ignore errors (due to ACPI??) */
+
+	/* write back to clear latch */
+	i2c_smbus_write_word_data(&ap->client, cmd, 0);
+
+	if (!data)
+		return;
+
+	dev_dbg(&ipdev->input->dev, APANEL ": data %#x\n", data);
+	for (i = 0; i < ipdev->input->keycodemax; i++)
+		if ((1u << i) & data)
+			report_key(idev, ap->keymap[i]);
+}
+
+/* Track state changes of LED */
+static void led_update(struct work_struct *work)
+{
+	struct apanel *ap = container_of(work, struct apanel, led_work);
+
+	i2c_smbus_write_word_data(&ap->client, 0x10, ap->led_bits);
+}
+
+static void mail_led_set(struct led_classdev *led,
+			 enum led_brightness value)
+{
+	struct apanel *ap = container_of(led, struct apanel, mail_led);
+
+	if (value != LED_OFF)
+		ap->led_bits |= 0x8000;
+	else
+		ap->led_bits &= ~0x8000;
+	schedule_work(&ap->led_work);
+}
+
+static int apanel_detach_client(struct i2c_client *client)
+{
+	struct apanel *ap = i2c_get_clientdata(client);
+
+	if (device_chip[APANEL_DEV_LED] != CHIP_NONE)
+		led_classdev_unregister(&ap->mail_led);
+
+	input_unregister_polled_device(ap->ipdev);
+	i2c_detach_client(&ap->client);
+	input_free_polled_device(ap->ipdev);
+
+	return 0;
+}
+
+/* Function is invoked for every i2c adapter. */
+static int apanel_attach_adapter(struct i2c_adapter *adap)
+{
+	dev_dbg(&adap->dev, APANEL ": attach adapter id=%d\n", adap->id);
+
+	/* Our device is connected only to i801 on laptop */
+	if (adap->id != I2C_HW_SMBUS_I801)
+		return -ENODEV;
+
+	return i2c_probe(adap, &addr_data, apanel_probe);
+}
+
+static void apanel_shutdown(struct i2c_client *client)
+{
+	apanel_detach_client(client);
+}
+
+static struct i2c_driver apanel_driver = {
+	.driver = {
+		.name = APANEL,
+	},
+	.attach_adapter = &apanel_attach_adapter,
+	.detach_client  = &apanel_detach_client,
+	.shutdown	= &apanel_shutdown,
+};
+
+static struct apanel apanel = {
+	.client = {
+		.driver = &apanel_driver,
+		.name   = APANEL,
+	},
+	.keymap = {
+		[0] = KEY_MAIL,
+		[1] = KEY_WWW,
+		[2] = KEY_PROG2,
+		[3] = KEY_PROG1,
+
+		[8] = KEY_FORWARD,
+		[9] = KEY_REWIND,
+		[10] = KEY_STOPCD,
+		[11] = KEY_PLAYPAUSE,
+
+	},
+	.mail_led = {
+		.name = "mail:blue",
+		.brightness_set = mail_led_set,
+	},
+};
+
+/* NB: Only one panel on the i2c. */
+static int apanel_probe(struct i2c_adapter *bus, int address, int kind)
+{
+	struct apanel *ap;
+	struct input_polled_dev *ipdev;
+	struct input_dev *idev;
+	u8 cmd = device_chip[APANEL_DEV_APPBTN] == CHIP_OZ992C ? 0 : 8;
+	int i, err = -ENOMEM;
+
+	dev_dbg(&bus->dev, APANEL ": probe adapter %p addr %d kind %d\n",
+		bus, address, kind);
+
+	ap = &apanel;
+
+	ipdev = input_allocate_polled_device();
+	if (!ipdev)
+		goto out1;
+
+	ap->ipdev = ipdev;
+	ap->client.adapter = bus;
+	ap->client.addr = address;
+
+	i2c_set_clientdata(&ap->client, ap);
+
+	err = i2c_attach_client(&ap->client);
+	if (err)
+		goto out2;
+
+	err = i2c_smbus_write_word_data(&ap->client, cmd, 0);
+	if (err) {
+		dev_warn(&ap->client.dev, APANEL ": smbus write error %d\n",
+			 err);
+		goto out3;
+	}
+
+	ipdev->poll = apanel_poll;
+	ipdev->poll_interval = POLL_INTERVAL_DEFAULT;
+	ipdev->private = ap;
+
+	idev = ipdev->input;
+	idev->name = APANEL_NAME " buttons";
+	idev->phys = "apanel/input0";
+	idev->id.bustype = BUS_HOST;
+	idev->dev.parent = &ap->client.dev;
+
+	set_bit(EV_KEY, idev->evbit);
+
+	idev->keycode = ap->keymap;
+	idev->keycodesize = sizeof(ap->keymap[0]);
+	idev->keycodemax = (device_chip[APANEL_DEV_CDBTN] != CHIP_NONE) ? 12 : 4;
+
+	for (i = 0; i < idev->keycodemax; i++)
+		if (ap->keymap[i])
+			set_bit(ap->keymap[i], idev->keybit);
+
+	err = input_register_polled_device(ipdev);
+	if (err)
+		goto out3;
+
+	INIT_WORK(&ap->led_work, led_update);
+	if (device_chip[APANEL_DEV_LED] != CHIP_NONE) {
+		err = led_classdev_register(&ap->client.dev, &ap->mail_led);
+		if (err)
+			goto out4;
+	}
+
+	return 0;
+out4:
+	input_unregister_polled_device(ipdev);
+out3:
+	i2c_detach_client(&ap->client);
+out2:
+	input_free_polled_device(ipdev);
+out1:
+	return err;
+}
+
+/* Scan the system ROM for the signature "FJKEYINF" */
+static __init const void __iomem *bios_signature(const void __iomem *bios)
+{
+	ssize_t offset;
+	const unsigned char signature[] = "FJKEYINF";
+
+	for (offset = 0; offset < 0x10000; offset += 0x10) {
+		if (check_signature(bios + offset, signature,
+				    sizeof(signature)-1))
+			return bios + offset;
+	}
+	pr_notice(APANEL ": Fujitsu BIOS signature '%s' not found...\n",
+		  signature);
+	return NULL;
+}
+
+static int __init apanel_init(void)
+{
+	void __iomem *bios;
+	const void __iomem *p;
+	u8 devno;
+	int found = 0;
+
+	bios = ioremap(0xF0000, 0x10000); /* Can't fail */
+
+	p = bios_signature(bios);
+	if (!p) {
+		iounmap(bios);
+		return -ENODEV;
+	}
+
+	/* just use the first address */
+	p += 8;
+	normal_i2c[0] = readb(p+3) >> 1;
+
+	for ( ; (devno = readb(p)) & 0x7f; p += 4) {
+		unsigned char method, slave, chip;
+
+		method = readb(p + 1);
+		chip = readb(p + 2);
+		slave = readb(p + 3) >> 1;
+
+		if (slave != normal_i2c[0]) {
+			pr_notice(APANEL ": only one SMBus slave "
+				  "address supported, skiping device...\n");
+			continue;
+		}
+
+		/* translate alternative device numbers */
+		switch (devno) {
+		case 6:
+			devno = APANEL_DEV_APPBTN;
+			break;
+		case 7:
+			devno = APANEL_DEV_LED;
+			break;
+		}
+
+		if (devno >= APANEL_DEV_MAX)
+			pr_notice(APANEL ": unknown device %u found\n", devno);
+		else if (device_chip[devno] != CHIP_NONE)
+			pr_warning(APANEL ": duplicate entry for devno %u\n", devno);
+
+		else if (method != 1 && method != 2 && method != 4) {
+			pr_notice(APANEL ": unknown method %u for devno %u\n",
+				  method, devno);
+		} else {
+			device_chip[devno] = (enum apanel_chip) chip;
+			++found;
+		}
+	}
+	iounmap(bios);
+
+	if (found == 0) {
+		pr_info(APANEL ": no input devices reported by BIOS\n");
+		return -EIO;
+	}
+
+	return i2c_add_driver(&apanel_driver);
+}
+module_init(apanel_init);
+
+static void __exit apanel_cleanup(void)
+{
+	i2c_del_driver(&apanel_driver);
+}
+module_exit(apanel_cleanup);
+
+MODULE_AUTHOR("Stephen Hemminger <shemminger@linux-foundation.org>");
+MODULE_DESCRIPTION(APANEL_NAME " driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(APANEL_VERSION);
+
+MODULE_ALIAS("dmi:*:svnFUJITSU:pnLifeBook*:pvr*:rvnFUJITSU:*");
+MODULE_ALIAS("dmi:*:svnFUJITSU:pnLifebook*:pvr*:rvnFUJITSU:*");
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

origin.patch
git-input.patch
git-net.patch
git-netdev-all.patch
git-wireless.patch
bonding-locking-fix.patch
