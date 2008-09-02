From: akpm@linux-foundation.org
Subject: - power-support-for-texas-instruments-bq27x00-battery-managers.patch removed from -mm tree
Date: Tue, 02 Sep 2008 13:41:31 -0700
Message-ID: <200809022041.m82KfVID011643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752280AbYIBUlm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 16:41:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: giometti@linux.it, cbouatmailru@gmail.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     power: support for Texas Instruments BQ27x00 battery managers
has been removed from the -mm tree.  Its filename was
     power-support-for-texas-instruments-bq27x00-battery-managers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: power: support for Texas Instruments BQ27x00 battery managers
From: Rodolfo Giometti <giometti@linux.it>

These battery managers came in two different packages: one for I2C
busses (BQ27200) and one for HDQ busses (BQ27000).

This driver currently supports only the I2C chip version but the code
is designed in order to easily allow the HDQ chip version integration.

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: make things static, use kasprintf()]
Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/Kconfig           |   13 +
 drivers/power/Makefile          |    1 
 drivers/power/bq27x00_battery.c |  390 ++++++++++++++++++++++++++++++
 3 files changed, 404 insertions(+)

diff -puN drivers/power/Kconfig~power-support-for-texas-instruments-bq27x00-battery-managers drivers/power/Kconfig
--- a/drivers/power/Kconfig~power-support-for-texas-instruments-bq27x00-battery-managers
+++ a/drivers/power/Kconfig
@@ -62,4 +62,17 @@ config BATTERY_PALMTX
 	help
 	  Say Y to enable support for the battery in Palm T|X.
 
+config BATTERY_BQ27x00
+	tristate "BQ27x00 battery driver"
+	help
+	  Say Y here to enable support for batteries with BQ27000 or
+	  BQ27200 chip.
+
+config BATTERY_BQ27200
+	bool "BQ27200 battery driver"
+	depends on BATTERY_BQ27x00
+	select I2C
+	help
+	  Say Y here to enable support for batteries with BQ27200(I2C) chip.
+
 endif # POWER_SUPPLY
diff -puN drivers/power/Makefile~power-support-for-texas-instruments-bq27x00-battery-managers drivers/power/Makefile
--- a/drivers/power/Makefile~power-support-for-texas-instruments-bq27x00-battery-managers
+++ a/drivers/power/Makefile
@@ -22,3 +22,4 @@ obj-$(CONFIG_BATTERY_PMU)	+= pmu_battery
 obj-$(CONFIG_BATTERY_OLPC)	+= olpc_battery.o
 obj-$(CONFIG_BATTERY_TOSA)	+= tosa_battery.o
 obj-$(CONFIG_BATTERY_PALMTX)	+= palmtx_battery.o
+obj-$(CONFIG_BATTERY_BQ27x00)	+= bq27x00_battery.o
diff -puN /dev/null drivers/power/bq27x00_battery.c
--- /dev/null
+++ a/drivers/power/bq27x00_battery.c
@@ -0,0 +1,390 @@
+/*
+ * linux/drivers/power/bq27x00_battery.c
+ *
+ * BQ27x00 battery driver
+ *
+ * Copyright (C) 2008 Rodolfo Giometti <giometti@linux.it>
+ * Copyright (C) 2008 Eurotech S.p.A. <info@eurotech.it>
+ *
+ * Based on a previous work by Copyright (C) 2008 Texas Instruments, Inc.
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ */
+#include <linux/module.h>
+#include <linux/param.h>
+#include <linux/jiffies.h>
+#include <linux/workqueue.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/power_supply.h>
+#include <linux/idr.h>
+
+#include <linux/i2c.h>
+
+#define DRIVER_VERSION			"1.0.0"
+
+#define BQ27x00_REG_TEMP		0x06
+#define BQ27x00_REG_VOLT		0x08
+#define BQ27x00_REG_RSOC		0x0B /* Relative State-of-Charge */
+#define BQ27x00_REG_AI			0x14
+#define BQ27x00_REG_FLAGS		0x0A
+#define HIGH_BYTE(A)			((A) << 8)
+
+/* If the system has several batteries we need a different name for each
+ * of them...
+ */
+static DEFINE_IDR(battery_id);
+static DEFINE_MUTEX(battery_mutex);
+
+struct bq27x00_device_info;
+struct bq27x00_access_methods {
+	int (*read)(u8 reg, int *rt_value, int b_single,
+		struct bq27x00_device_info *di);
+};
+
+struct bq27x00_device_info {
+	struct device 		*dev;
+	int			id;
+	int			voltage_uV;
+	int			current_uA;
+	int			temp_C;
+	int			charge_rsoc;
+	struct bq27x00_access_methods	*bus;
+	struct power_supply	bat;
+
+	struct i2c_client	*client;
+};
+
+static enum power_supply_property bq27x00_battery_props[] = {
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_CURRENT_NOW,
+	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_TEMP,
+};
+
+/*
+ * Common code for BQ27x00 devices
+ */
+
+static int bq27x00_read(u8 reg, int *rt_value, int b_single,
+	struct bq27x00_device_info *di)
+{
+	int ret;
+
+	ret = di->bus->read(reg, rt_value, b_single, di);
+	*rt_value = be16_to_cpu(*rt_value);
+
+	return ret;
+}
+
+/*
+ * Return the battery temperature in Celcius degrees
+ * Or < 0 if something fails.
+ */
+static int bq27x00_battery_temperature(struct bq27x00_device_info *di)
+{
+	int ret, temp = 0;
+
+	ret = bq27x00_read(BQ27x00_REG_TEMP, &temp, 0, di);
+	if (ret) {
+		dev_err(di->dev, "error reading temperature\n");
+		return ret;
+	}
+
+	return (temp >> 2) - 273;
+}
+
+/*
+ * Return the battery Voltage in milivolts
+ * Or < 0 if something fails.
+ */
+static int bq27x00_battery_voltage(struct bq27x00_device_info *di)
+{
+	int ret, volt = 0;
+
+	ret = bq27x00_read(BQ27x00_REG_VOLT, &volt, 0, di);
+	if (ret) {
+		dev_err(di->dev, "error reading voltage\n");
+		return ret;
+	}
+
+	return volt;
+}
+
+/*
+ * Return the battery average current
+ * Note that current can be negative signed as well
+ * Or 0 if something fails.
+ */
+static int bq27x00_battery_current(struct bq27x00_device_info *di)
+{
+	int ret, curr = 0, flags = 0;
+
+	ret = bq27x00_read(BQ27x00_REG_AI, &curr, 0, di);
+	if (ret) {
+		dev_err(di->dev, "error reading current\n");
+		return 0;
+	}
+	ret = bq27x00_read(BQ27x00_REG_FLAGS, &flags, 0, di);
+	if (ret < 0) {
+		dev_err(di->dev, "error reading flags\n");
+		return 0;
+	}
+	if ((flags & (1 << 7)) != 0) {
+		dev_dbg(di->dev, "negative current!\n");
+		return -curr;
+	} else
+		return curr;
+}
+
+/*
+ * Return the battery Relative State-of-Charge
+ * Or < 0 if something fails.
+ */
+static int bq27x00_battery_rsoc(struct bq27x00_device_info *di)
+{
+	int ret, rsoc = 0;
+
+	ret = bq27x00_read(BQ27x00_REG_RSOC, &rsoc, 1, di);
+	if (ret) {
+		dev_err(di->dev, "error reading relative State-of-Charge\n");
+		return ret;
+	}
+
+	return rsoc >> 8;
+}
+
+#define to_bq27x00_device_info(x) container_of((x), \
+				struct bq27x00_device_info, bat);
+
+static int bq27x00_battery_get_property(struct power_supply *psy,
+					enum power_supply_property psp,
+					union power_supply_propval *val)
+{
+	struct bq27x00_device_info *di = to_bq27x00_device_info(psy);
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+	case POWER_SUPPLY_PROP_PRESENT:
+		val->intval = bq27x00_battery_voltage(di);
+		if (psp == POWER_SUPPLY_PROP_PRESENT)
+			val->intval = val->intval <= 0 ? 0 : 1;
+
+		break;
+
+	case POWER_SUPPLY_PROP_CURRENT_NOW:
+		val->intval = bq27x00_battery_current(di);
+
+		break;
+
+	case POWER_SUPPLY_PROP_CAPACITY:
+		val->intval = bq27x00_battery_rsoc(di);
+
+		break;
+
+	case POWER_SUPPLY_PROP_TEMP:
+		val->intval = bq27x00_battery_temperature(di);
+
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void bq27x00_powersupply_init(struct bq27x00_device_info *di)
+{
+	di->bat.type = POWER_SUPPLY_TYPE_BATTERY;
+	di->bat.properties = bq27x00_battery_props;
+	di->bat.num_properties = ARRAY_SIZE(bq27x00_battery_props);
+	di->bat.get_property = bq27x00_battery_get_property;
+	di->bat.external_power_changed = NULL;
+
+	return;
+}
+
+/*
+ * BQ27200 specific code
+ */
+
+static int bq27200_read(u8 reg, int *rt_value, int b_single,
+	struct bq27x00_device_info *di)
+{
+	struct i2c_client *client = di->client;
+	struct i2c_msg msg[1];
+	unsigned char data[2];
+	int err;
+
+	if (!client->adapter)
+		return -ENODEV;
+
+	msg->addr = client->addr;
+	msg->flags = 0;
+	msg->len = 1;
+	msg->buf = data;
+
+	data[0] = reg;
+	err = i2c_transfer(client->adapter, msg, 1);
+
+	if (err >= 0) {
+		if (!b_single)
+			msg->len = 2;
+		else
+			msg->len = 1;
+
+		msg->flags = I2C_M_RD;
+		err = i2c_transfer(client->adapter, msg, 1);
+		if (err >= 0) {
+			if (!b_single)
+				*rt_value = data[1] | HIGH_BYTE(data[0]);
+			else
+				*rt_value = data[0];
+
+			return 0;
+		} else
+			return err;
+	} else
+		return err;
+}
+
+static int bq27200_battery_probe(struct i2c_client *client,
+					const struct i2c_device_id *id)
+{
+	char *name;
+	struct bq27x00_device_info *di;
+	struct bq27x00_access_methods *bus;
+	int num, retval = 0;
+
+	/* Get new ID for the new battery device */
+	retval = idr_pre_get(&battery_id, GFP_KERNEL);
+	if (retval == 0)
+		return -ENOMEM;
+	mutex_lock(&battery_mutex);
+	retval = idr_get_new(&battery_id, client, &num);
+	mutex_unlock(&battery_mutex);
+	if (retval < 0)
+		return retval;
+
+	name = kasprintf(GFP_KERNEL, "bq27200-%d", num);
+	if (!name) {
+		dev_err(&client->dev, "failed to allocate device name\n");
+		retval = -ENOMEM;
+		goto batt_failed_1;
+	}
+
+	di = kzalloc(sizeof(*di), GFP_KERNEL);
+	if (!di) {
+		dev_err(&client->dev, "failed to allocate device info data\n");
+		retval = -ENOMEM;
+		goto batt_failed_2;
+	}
+	di->id = num;
+
+	bus = kzalloc(sizeof(*bus), GFP_KERNEL);
+	if (!bus) {
+		dev_err(&client->dev, "failed to allocate access method "
+					"data\n");
+		retval = -ENOMEM;
+		goto batt_failed_3;
+	}
+
+	i2c_set_clientdata(client, di);
+	di->dev = &client->dev;
+	di->bat.name = name;
+	bus->read = &bq27200_read;
+	di->bus = bus;
+	di->client = client;
+
+	bq27x00_powersupply_init(di);
+
+	retval = power_supply_register(&client->dev, &di->bat);
+	if (retval) {
+		dev_err(&client->dev, "failed to register battery\n");
+		goto batt_failed_4;
+	}
+
+	dev_info(&client->dev, "support ver. %s enabled\n", DRIVER_VERSION);
+
+	return 0;
+
+batt_failed_4:
+	kfree(bus);
+batt_failed_3:
+	kfree(di);
+batt_failed_2:
+	kfree(name);
+batt_failed_1:
+	mutex_lock(&battery_mutex);
+	idr_remove(&battery_id, num);
+	mutex_unlock(&battery_mutex);
+
+	return retval;
+}
+
+static int bq27200_battery_remove(struct i2c_client *client)
+{
+	struct bq27x00_device_info *di  = i2c_get_clientdata(client);
+
+	power_supply_unregister(&di->bat);
+
+	kfree(di->bat.name);
+
+	mutex_lock(&battery_mutex);
+	idr_remove(&battery_id, di->id);
+	mutex_unlock(&battery_mutex);
+
+	kfree(di);
+
+	return 0;
+}
+
+/*
+ * Module stuff
+ */
+
+static const struct i2c_device_id bq27200_id[] = {
+	{ "bq27200", 0 },
+};
+
+static struct i2c_driver bq27200_battery_driver = {
+	.probe  = bq27200_battery_probe,
+	.remove = __devexit_p(bq27200_battery_remove),
+
+	.driver = {
+		.name   = "bq27200-battery",
+	},
+	.id_table = bq27200_id,
+};
+
+static int __init bq27x00_battery_init(void)
+{
+	int ret;
+
+	ret = i2c_add_driver(&bq27200_battery_driver);
+	if (ret)
+		printk(KERN_ERR "Unable to register BQ27200 driver\n");
+
+	return ret;
+}
+
+static void __exit bq27x00_battery_exit(void)
+{
+	i2c_del_driver(&bq27200_battery_driver);
+}
+
+module_init(bq27x00_battery_init);
+module_exit(bq27x00_battery_exit);
+
+MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
+MODULE_DESCRIPTION("BQ27x00 battery monitor driver");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from giometti@linux.it are

linux-next.patch
rtc-ds1307-alarm-support-for-ds1337-ds1339.patch

