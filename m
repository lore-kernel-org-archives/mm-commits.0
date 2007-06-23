From: akpm@linux-foundation.org
Subject: - i2c-tsl2550-support.patch removed from -mm tree
Date: Sat, 23 Jun 2007 12:28:08 -0700
Message-ID: <200706231928.l5NJS8Yw022117@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51805 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755586AbXFWTf0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 15:35:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: giometti@enneenne.com, mm-commits@vger.kernel.org


The patch titled
     I2C: TSL2550 support
has been removed from the -mm tree.  Its filename was
     i2c-tsl2550-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: I2C: TSL2550 support
From: Rodolfo Giometti <giometti@enneenne.com>

Add support for Taos TSL2550 ambient light sensors.
(http://www.taosinc.com/product_detail.asp?cateid=4&proid=18).

Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/chips/Kconfig   |   10 
 drivers/i2c/chips/Makefile  |    1 
 drivers/i2c/chips/tsl2550.c |  457 ++++++++++++++++++++++++++++++++++
 include/linux/i2c-id.h      |    1 
 4 files changed, 469 insertions(+)

diff -puN drivers/i2c/chips/Kconfig~i2c-tsl2550-support drivers/i2c/chips/Kconfig
--- a/drivers/i2c/chips/Kconfig~i2c-tsl2550-support
+++ a/drivers/i2c/chips/Kconfig
@@ -142,4 +142,14 @@ config SENSORS_MAX6875
 	  This driver can also be built as a module.  If so, the module
 	  will be called max6875.
 
+config SENSORS_TSL2550
+	tristate "Taos TSL2550 ambient light sensor"
+	depends on I2C && EXPERIMENTAL
+	help
+	  If you say yes here you get support for the Taos TSL2550
+	  ambient light sensor.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called tsl2550.
+
 endmenu
diff -puN drivers/i2c/chips/Makefile~i2c-tsl2550-support drivers/i2c/chips/Makefile
--- a/drivers/i2c/chips/Makefile~i2c-tsl2550-support
+++ a/drivers/i2c/chips/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_SENSORS_PCF8574)	+= pcf8574
 obj-$(CONFIG_SENSORS_PCF8591)	+= pcf8591.o
 obj-$(CONFIG_ISP1301_OMAP)	+= isp1301_omap.o
 obj-$(CONFIG_TPS65010)		+= tps65010.o
+obj-$(CONFIG_SENSORS_TSL2550)	+= tsl2550.o
 
 ifeq ($(CONFIG_I2C_DEBUG_CHIP),y)
 EXTRA_CFLAGS += -DDEBUG
diff -puN /dev/null drivers/i2c/chips/tsl2550.c
--- /dev/null
+++ a/drivers/i2c/chips/tsl2550.c
@@ -0,0 +1,457 @@
+/*
+ *  tsl2550.c - Linux kernel modules for ambient light sensor
+ *
+ *  Copyright (C) 2007 Rodolfo Giometti <giometti@linux.it>
+ *  Copyright (C) 2007 Eurotech S.p.A. <info@eurotech.it>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/mutex.h>
+#include <linux/delay.h>
+
+/* Address to scan */
+static unsigned short normal_i2c[] = { 0x39, I2C_CLIENT_END };
+
+/* Insmod parameters */
+I2C_CLIENT_INSMOD_1(tsl2550);
+
+static int operating_mode;
+module_param(operating_mode, int, 0);
+MODULE_PARM_DESC(operating_mode,
+	"Operating mode: 0 = standard (default), 1 = extended");
+
+#define DRIVER_NAME     (tsl2550_driver.driver.name)
+#define DRIVER_VERSION  "1.0.0"
+
+/* --- Defines ------------------------------------------------------------- */
+
+#define TSL2550_POWER_DOWN		0x00
+#define TSL2550_POWER_UP		0x03
+#define TSL2550_STANDARD_RANGE		0x18
+#define TSL2550_EXTENDED_RANGE		0x1d
+#define TSL2550_READ_ADC0		0x43
+#define TSL2550_READ_ADC1		0x83
+
+/* --- Structs ------------------------------------------------------------- */
+
+struct tsl2550_data {
+	struct i2c_client client;
+	struct mutex update_lock;
+
+	unsigned int power_state : 1;
+	unsigned int operating_mode : 1;
+};
+
+/* --- Management functions ------------------------------------------------ */
+
+static int tsl2550_set_operating_mode(struct i2c_client *client, int mode)
+{
+	struct tsl2550_data *data = i2c_get_clientdata(client);
+	int ret;
+
+	mode = !!mode;
+	if (mode == data->operating_mode)
+		return 0;
+
+	if (mode == 0)
+		ret = i2c_smbus_write_byte(client, TSL2550_STANDARD_RANGE);
+	else
+		ret = i2c_smbus_write_byte(client, TSL2550_EXTENDED_RANGE);
+
+	data->operating_mode = mode;
+
+	return ret;
+}
+
+static int tsl2550_set_power_state(struct i2c_client *client, int state)
+{
+	struct tsl2550_data *data = i2c_get_clientdata(client);
+	int ret;
+
+	state = !!state;
+	if (state == data->power_state)
+		return 0;
+
+	if (state == 0)
+		ret = i2c_smbus_write_byte(client, TSL2550_POWER_DOWN);
+	else {
+		ret = i2c_smbus_write_byte(client, TSL2550_POWER_UP);
+
+		/* On power up we should reset operating mode also... */
+		tsl2550_set_operating_mode(client, data->operating_mode);
+	}
+
+	data->power_state = state;
+
+	return ret;
+}
+
+static int tsl2550_get_adc_value(struct i2c_client *client, int channel)
+{
+	u8 cmd = channel == 0 ? TSL2550_READ_ADC0 : TSL2550_READ_ADC1;
+	unsigned long end;
+	int loop = 0, ret = 0;
+
+	/* Read ADC channel waiting at most 400ms (see data sheet for further
+         * info).
+	 * To avoid long busy wait we spin for few milliseconds then
+	 * start sleeping. */
+	end = jiffies + msecs_to_jiffies(400);
+	while (time_before(jiffies, end)) {
+		i2c_smbus_write_byte(client, cmd);
+
+		if (loop++ < 5)
+			mdelay(1);
+		else
+			msleep(1);
+
+		ret = i2c_smbus_read_byte(client);
+		if (ret < 0)
+			return ret;
+		else if (ret & 0x0080)
+			break;
+	}
+	if (!(ret & 0x0080))
+		return -EIO;
+	return ((u8) ret) & 0x7f;	/* remove the "valid" bit */
+}
+
+/* --- LUX calculation ----------------------------------------------------- */
+
+#define	TSL2550_MAX_LUX		1846
+
+static const u8 ratio_lut[] = {
+	100, 100, 100, 100, 100, 100, 100, 100,
+	100, 100, 100, 100, 100, 100, 99, 99,
+	99, 99, 99, 99, 99, 99, 99, 99,
+	99, 99, 99, 98, 98, 98, 98, 98,
+	98, 98, 97, 97, 97, 97, 97, 96,
+	96, 96, 96, 95, 95, 95, 94, 94,
+	93, 93, 93, 92, 92, 91, 91, 90,
+	89, 89, 88, 87, 87, 86, 85, 84,
+	83, 82, 81, 80, 79, 78, 77, 75,
+	74, 73, 71, 69, 68, 66, 64, 62,
+	60, 58, 56, 54, 52, 49, 47, 44,
+	42, 41, 40, 40, 39, 39, 38, 38,
+	37, 37, 37, 36, 36, 36, 35, 35,
+	35, 35, 34, 34, 34, 34, 33, 33,
+	33, 33, 32, 32, 32, 32, 32, 31,
+	31, 31, 31, 31, 30, 30, 30, 30,
+	30,
+};
+
+static const u16 count_lut[] = {
+	0, 1, 2, 3, 4, 5, 6, 7,
+	8, 9, 10, 11, 12, 13, 14, 15,
+	16, 18, 20, 22, 24, 26, 28, 30,
+	32, 34, 36, 38, 40, 42, 44, 46,
+	49, 53, 57, 61, 65, 69, 73, 77,
+	81, 85, 89, 93, 97, 101, 105, 109,
+	115, 123, 131, 139, 147, 155, 163, 171,
+	179, 187, 195, 203, 211, 219, 227, 235,
+	247, 263, 279, 295, 311, 327, 343, 359,
+	375,  391, 407, 423, 439, 455, 471, 487,
+	511, 543, 575, 607, 639, 671, 703, 735,
+	767, 799, 831, 863, 895, 927, 959, 991,
+	1039, 1103, 1167, 1231, 1295, 1359, 1423, 1487,
+	1551, 1615, 1679, 1743, 1807, 1871, 1935, 1999,
+	2095, 2223, 2351, 2479, 2607, 2735, 2863, 2991,
+	3119, 3247, 3375, 3503, 3631, 3759, 3887, 4015
+};
+
+/* This function is described into Taos TSL2550 Designer's Notebook
+ * pages 2, 3 */
+static int tsl2550_calculate_lux(u8 ch0, u8 ch1)
+{
+	unsigned int lux;
+
+	/* Look up count from channel values */
+	u16 c0 = count_lut[ch0];
+	u16 c1 = count_lut[ch1];
+
+	/* Calculate ratio.
+	 * Note: the "128" is a scaling factor */
+	u8 r = 128;
+
+	/* Avoid division by 0 and count 1 cannot be greater than count 0 */
+	if (c0 && (c1 <= c0))
+		r = c1 * 128 / c0;
+	else
+		return -1;
+
+	/* Calculare LUX */
+	lux = ((c0 - c1) * ratio_lut[r]) / 256;
+
+	/* LUX range check */
+	return lux > TSL2550_MAX_LUX ? TSL2550_MAX_LUX : lux;
+}
+
+/* --- SysFS support ------------------------------------------------------- */
+
+static ssize_t tsl2550_show_power_state(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct tsl2550_data *data = i2c_get_clientdata(to_i2c_client(dev));
+
+	return sprintf(buf, "%u\n", data->power_state);
+}
+
+static ssize_t tsl2550_store_power_state(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct tsl2550_data *data = i2c_get_clientdata(client);
+	unsigned long val = simple_strtoul(buf, NULL, 10);
+	int ret;
+
+	mutex_lock(&data->update_lock);
+	ret = tsl2550_set_power_state(client, val);
+	mutex_unlock(&data->update_lock);
+
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static DEVICE_ATTR(power_state, S_IWUSR | S_IRUGO,
+		   tsl2550_show_power_state, tsl2550_store_power_state);
+
+static ssize_t tsl2550_show_operating_mode(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct tsl2550_data *data = i2c_get_clientdata(to_i2c_client(dev));
+
+	return sprintf(buf, "%u\n", data->operating_mode);
+}
+
+static ssize_t tsl2550_store_operating_mode(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct tsl2550_data *data = i2c_get_clientdata(client);
+	unsigned long val = simple_strtoul(buf, NULL, 10);
+	int ret;
+
+	mutex_lock(&data->update_lock);
+	ret = tsl2550_set_operating_mode(client, val);
+	mutex_unlock(&data->update_lock);
+
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static DEVICE_ATTR(operating_mode, S_IWUSR | S_IRUGO,
+		   tsl2550_show_operating_mode, tsl2550_store_operating_mode);
+
+static ssize_t __tsl2550_show_lux(struct i2c_client *client, struct device_attribute *attr, char *buf)
+{
+	u8 ch0, ch1;
+	int ret;
+
+	ret = tsl2550_get_adc_value(client, 0);
+	if (ret < 0)
+		return ret;
+	ch0 = (u8) ret;
+
+	mdelay(1);
+
+	ret = tsl2550_get_adc_value(client, 1);
+	if (ret < 0)
+		return ret;
+	ch1 = (u8) ret;
+
+	/* Do the job */
+	ret = tsl2550_calculate_lux(ch0, ch1);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%u\n", ret);
+}
+
+static ssize_t tsl2550_show_lux(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct tsl2550_data *data = i2c_get_clientdata(client);
+	int ret;
+
+	/* No LUX data if not operational */
+	if (!data->power_state)
+		return -EBUSY;
+
+	mutex_lock(&data->update_lock);
+	ret = __tsl2550_show_lux(client, attr, buf);
+	mutex_unlock(&data->update_lock);
+
+	return ret;
+}
+
+static DEVICE_ATTR(lux, S_IRUGO,
+		   tsl2550_show_lux, NULL);
+
+static struct attribute *tsl2550_attributes[] = {
+	&dev_attr_power_state.attr,
+	&dev_attr_operating_mode.attr,
+	&dev_attr_lux.attr,
+	NULL
+};
+
+static const struct attribute_group tsl2550_attr_group = {
+	.attrs = tsl2550_attributes,
+};
+
+/* --- Initialization function --------------------------------------------- */
+
+static void tsl2550_init_client(struct i2c_client *client)
+{
+	/* Power up the device and set the default operating mode */
+	tsl2550_set_power_state(client, 1);
+	tsl2550_set_operating_mode(client, operating_mode);
+}
+
+/* --- I2C init/probing/exit functions ------------------------------------- */
+
+static struct i2c_driver tsl2550_driver;
+static int tsl2550_detect(struct i2c_adapter *adapter, int address, int kind)
+{
+	struct i2c_client *new_client;
+	struct tsl2550_data *data;
+	int err = 0;
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE
+				     | I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
+		goto exit;
+
+	/* OK. For now, we presume we have a valid client. We now create the
+	   client structure, even though we cannot fill it completely yet. */
+	data = kzalloc(sizeof(struct tsl2550_data), GFP_KERNEL);
+	if (!data) {
+		err = -ENOMEM;
+		goto exit;
+	}
+
+	new_client = &data->client;
+	i2c_set_clientdata(new_client, data);
+	new_client->addr = address;
+	new_client->adapter = adapter;
+	new_client->driver = &tsl2550_driver;
+	new_client->flags = 0;
+
+	/* Probe the chip. To do so we try to power up the device and then to
+	 * read back the 0x03 code */
+	err = i2c_smbus_write_byte(new_client, TSL2550_POWER_UP);
+	if (err < 0)
+		goto exit_kfree;
+	mdelay(1);
+	err = i2c_smbus_read_byte(new_client);
+	if (err != TSL2550_POWER_UP) {
+		err = -ENODEV;
+		goto exit_kfree;
+	}
+
+	/* Determine the chip type - only one kind supported! */
+	if (kind <= 0)
+		kind = tsl2550;
+
+	/* Fill in the remaining client fields and put it into the global
+	   list */
+	strlcpy(new_client->name, "tsl2550", I2C_NAME_SIZE);
+	mutex_init(&data->update_lock);
+
+	/* Tell the I2C layer a new client has arrived */
+	err = i2c_attach_client(new_client);
+	if (err)
+		goto exit_kfree;
+
+	/* Initialize the TSL2550 chip */
+	tsl2550_init_client(new_client);
+
+	/* Register sysfs hooks */
+	err = sysfs_create_group(&new_client->dev.kobj, &tsl2550_attr_group);
+	if (err)
+		goto exit_detach;
+
+	pr_info("%s: TSL2550 I2C support enabled - ver. %s\n",
+			DRIVER_NAME, DRIVER_VERSION);
+	pr_info("%s: Copyright (C) 2007 Rodolfo Giometti <giometti@linux.it>\n",
+			DRIVER_NAME);
+
+	return 0;
+
+exit_detach:
+	i2c_detach_client(new_client);
+exit_kfree:
+	kfree(data);
+exit:
+	return err;
+}
+
+static int tsl2550_attach_adapter(struct i2c_adapter *adapter)
+{
+	return i2c_probe(adapter, &addr_data, tsl2550_detect);
+}
+
+static int tsl2550_detach_client(struct i2c_client *client)
+{
+	int err;
+
+	sysfs_remove_group(&client->dev.kobj, &tsl2550_attr_group);
+
+	err = i2c_detach_client(client);
+	if (err)
+		return err;
+
+	kfree(i2c_get_clientdata(client));
+
+	/* Power doen the device */
+	tsl2550_set_power_state(client, 0);
+
+	return 0;
+}
+
+static struct i2c_driver tsl2550_driver = {
+	.driver = {
+		.name	= "tsl2550",
+	},
+	.id		= I2C_DRIVERID_TSL2550,
+	.attach_adapter	= tsl2550_attach_adapter,
+	.detach_client	= tsl2550_detach_client,
+};
+
+static int __init tsl2550_init(void)
+{
+	if (operating_mode < 0 || operating_mode > 1) {
+		printk(KERN_WARNING "tsl2550: invalid operating_mode (%d)\n",
+		       operating_mode);
+		return -EINVAL;
+	}
+
+	return i2c_add_driver(&tsl2550_driver);
+}
+
+static void __exit tsl2550_exit(void)
+{
+	i2c_del_driver(&tsl2550_driver);
+}
+
+MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
+MODULE_DESCRIPTION("TSL2550 ambient light sensor driver");
+MODULE_LICENSE("GPL");
+
+module_init(tsl2550_init);
+module_exit(tsl2550_exit);
diff -puN include/linux/i2c-id.h~i2c-tsl2550-support include/linux/i2c-id.h
--- a/include/linux/i2c-id.h~i2c-tsl2550-support
+++ a/include/linux/i2c-id.h
@@ -161,6 +161,7 @@
 #define I2C_DRIVERID_FSCHER 1046
 #define I2C_DRIVERID_W83L785TS 1047
 #define I2C_DRIVERID_OV7670 1048	/* Omnivision 7670 camera */
+#define I2C_DRIVERID_TSL2550 1049
 
 /*
  * ---- Adapter types ----------------------------------------------------
_

Patches currently in -mm which might be from giometti@enneenne.com are
