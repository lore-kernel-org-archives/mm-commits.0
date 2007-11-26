From: akpm@linux-foundation.org
Subject: + oz99x-i2c-button-and-led-support-driver.patch added to -mm tree
Date: Mon, 26 Nov 2007 15:08:38 -0800
Message-ID: <200711262308.lAQN8cF8027763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36832 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753836AbXKZXJY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 18:09:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: post@hendrik-sattler.de


The patch titled
     OZ99x I2C button and led support driver
has been added to the -mm tree.  Its filename is
     oz99x-i2c-button-and-led-support-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: OZ99x I2C button and led support driver
From: Hendrik Sattler <post@hendrik-sattler.de>

This adds new-style I2c device driver for O2 Micro/ETC OZ990 devices.
Button support was tested with a ETC OZ992S in a Fujitsu-Siemens C-6637.

Signed-off-by: Hendrik Sattler <post@hendrik-sattler.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/chips/Kconfig  |   13 
 drivers/i2c/chips/Makefile |    1 
 drivers/i2c/chips/oz99x.c  |  694 +++++++++++++++++++++++++++++++++++
 include/linux/oz99x.h      |   31 +
 4 files changed, 739 insertions(+)

diff -puN drivers/i2c/chips/Kconfig~oz99x-i2c-button-and-led-support-driver drivers/i2c/chips/Kconfig
--- a/drivers/i2c/chips/Kconfig~oz99x-i2c-button-and-led-support-driver
+++ a/drivers/i2c/chips/Kconfig
@@ -139,4 +139,17 @@ config MENELAUS
 	  and other features that are often used in portable devices like
 	  cell phones and PDAs.
 
+config OZ99X
+	tristate "O2 Micro/ETC OZ990/OZ992 SMBus chip"
+	depends on I2C
+	select INPUT_POLLDEV
+	select LEDS_CLASS
+	help
+	  If you say Y here, you get support for the OZ990 and OZ992 chip
+	  from O2 Micro. This driver provides support for buttons and
+	  LEDs according to the preconfigured GPIO setup.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called oz99x.
+
 endmenu
diff -puN drivers/i2c/chips/Makefile~oz99x-i2c-button-and-led-support-driver drivers/i2c/chips/Makefile
--- a/drivers/i2c/chips/Makefile~oz99x-i2c-button-and-led-support-driver
+++ a/drivers/i2c/chips/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_ISP1301_OMAP)	+= isp1301_om
 obj-$(CONFIG_TPS65010)		+= tps65010.o
 obj-$(CONFIG_MENELAUS)		+= menelaus.o
 obj-$(CONFIG_SENSORS_TSL2550)	+= tsl2550.o
+obj-$(CONFIG_OZ99X)		+= oz99x.o
 
 ifeq ($(CONFIG_I2C_DEBUG_CHIP),y)
 EXTRA_CFLAGS += -DDEBUG
diff -puN /dev/null drivers/i2c/chips/oz99x.c
--- /dev/null
+++ a/drivers/i2c/chips/oz99x.c
@@ -0,0 +1,694 @@
+/*
+    oz99x.c - O2 Micro/ETC OZ990/OZ992 driver
+
+    Copyright (C) 2006-2007 Hendrik Sattler <post@hendrik-sattler.de>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License along
+    with this program; if not, write to the Free Software Foundation, Inc.,
+    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+*/
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/kernel.h>
+#include <linux/version.h>
+
+#include <linux/i2c.h>
+#include <linux/input.h>
+#include <linux/input-polldev.h>
+#include <linux/leds.h>
+#include <linux/list.h>
+#include <asm/bitops.h>
+
+#include <linux/oz99x.h>
+
+/* How often we poll keys - msecs */
+static unsigned int oz99x_poll = 1000;
+module_param(oz99x_poll, uint, 0444);
+MODULE_PARM_DESC(oz99x_poll, "poll interval in miliseconds [1000]");
+
+/* enable reading registers via SysFS */
+static int oz99x_debug;
+module_param(oz99x_debug, bool, 0444);
+MODULE_PARM_DESC(oz99x_debug, "add debug features [0]");
+
+struct oz99x_data {
+	struct i2c_client *client;
+	struct input_polled_dev *ipdev;
+
+	unsigned int keymap[OZ99X_KEYMAP_ENTRIES];
+	struct list_head leds;
+
+	struct {
+		u8 min;
+		u8 max;
+	} range;
+};
+
+struct oz99x_led_data {
+	struct oz99x_data *data;
+
+	int gpio;
+	char name[8];
+	struct led_classdev cdev;
+
+	struct list_head list;
+};
+#define oz99x_from_led_cdev(c) container_of(c, struct oz99x_led_data, cdev)
+
+#define oz99x_reg_write(client, reg, value) \
+	i2c_smbus_write_word_data(client, reg, value)
+#define oz99x_reg_read(client, reg) i2c_smbus_read_word_data(client, reg)
+
+static
+ssize_t reg_minmax_store(const char *buf,
+			 size_t count,
+			 u8 *minmax)
+{
+	long val = simple_strtol(buf, NULL, 16);
+	if (val > 0xFF)
+		val = 0xFF;
+	else if (val < 0x00)
+		val = 0x00;
+	*minmax = val & 0xFF;
+	return count;
+}
+
+static
+ssize_t reg_min_show(struct device *dev,
+		     struct device_attribute *attr,
+		      char *buf)
+{
+	struct oz99x_data *data = i2c_get_clientdata(to_i2c_client(dev));
+	return snprintf(buf, PAGE_SIZE, "%02x\n", (int)data->range.min);
+}
+
+static
+ssize_t reg_min_store(struct device *dev,
+		      struct device_attribute *attr,
+		      const char *buf,
+		      size_t count)
+{
+	struct oz99x_data *data = i2c_get_clientdata(to_i2c_client(dev));
+	return reg_minmax_store(buf, count, &data->range.min);
+}
+
+static
+ssize_t reg_max_show(struct device *dev,
+		     struct device_attribute *attr,
+		     char *buf)
+{
+	struct oz99x_data *data = i2c_get_clientdata(to_i2c_client(dev));
+	return snprintf(buf, PAGE_SIZE, "%02x\n", (int)data->range.max);
+}
+
+static
+ssize_t reg_max_store(struct device *dev,
+		      struct device_attribute *attr,
+		      const char *buf,
+		      size_t count)
+{
+	struct oz99x_data *data = i2c_get_clientdata(to_i2c_client(dev));
+	return reg_minmax_store(buf, count, &data->range.max);
+}
+
+static
+ssize_t regs_show(struct device *dev,
+		  struct device_attribute *attr,
+		  char *buf)
+{
+	struct oz99x_data *data = i2c_get_clientdata(to_i2c_client(dev));
+	u16 i = data->range.min;
+	u8 max = data->range.max;
+	size_t count = 0;
+	int reg;
+
+	for (; i <= max; ++i) {
+		if (i) {
+			if ((i%8) == 0)
+				count += snprintf(buf+count, PAGE_SIZE-count,
+						  "\n");
+			else if ((i%4) == 0)
+				count += snprintf(buf+count, PAGE_SIZE-count,
+						  "  ");
+			else
+				count += snprintf(buf+count, PAGE_SIZE-count,
+						  " ");
+		}
+		if ((i%8) == 0)
+			count += snprintf(buf+count, PAGE_SIZE-count,
+					  "0x%02x: ", i);
+
+		reg = oz99x_reg_read(data->client, i);
+		if (reg < 0)
+			count += snprintf(buf+count, PAGE_SIZE-count, "____");
+		else
+			count += snprintf(buf+count, PAGE_SIZE-count, "%04x",
+					  reg);
+	}
+	count += snprintf(buf+count, PAGE_SIZE-count, "\n");
+	return count;
+}
+
+static DEVICE_ATTR(regs_min, 0644, reg_min_show, reg_min_store);
+static DEVICE_ATTR(regs_max, 0644, reg_max_show, reg_max_store);
+static DEVICE_ATTR(regs, 0444, regs_show, NULL);
+
+#define OZ99X_GPC_IN     0 /* input */
+#define OZ99X_GPC_IN_DEB 1 /* debounced input (buttons) */
+#define OZ99X_GPC_OUT    2 /* output */
+#define OZ99X_GPC_ALF    3 /* auto led flash */
+
+#define OZ99X_GPC_MASK        0x3
+#define OZ99X_GPC_SHIFT(gpio) (((gpio) % 8) << 1)
+#define OZ99X_GPC(gpio, gpc) \
+	(((gpc) >> OZ99X_GPC_SHIFT(gpio)) & OZ99X_GPC_MASK)
+
+#define OZ99X_REG_INPUT     0x00
+#define OZ99X_REG_OUTPUT    0x01
+#define OZ99X_REG_GPC_LOW   0x02 /* GPIO port control GPIO[0..7] */
+#define OZ99X_REG_GPC_HIGH  0x03 /* GPIO port control GPIO[8..15] */
+#define OZ99X_REG_SUSP_TRI  0x04 /* suspend tri-state */
+#define OZ99X_REG_INT_EN    0x05 /* interrupt trigger enable */
+#define OZ99X_REG_WAKE_EN   0x06 /* wakeup enable */
+#define OZ99X_REG_SUSP_EN   0x07 /* suspend enable GPIO[8..15] */
+#define OZ99X_REG_STATUS    0x08 /* interrupt/wakeup status */
+#define OZ99X_REG_SUSP_ST   0x09 /* suspend status */
+#define OZ99X_REG_SMICFG    0x0a /* SMI configuration */
+#define OZ99X_REG_SUSP_WAKE 0x0b /* suspend/wake */
+#define OZ99X_REG_PCC       0x0c /* power control */
+#define OZ99X_REG_WAKE_DIS  0x0d /* wakeup disable */
+#define OZ99X_REG_PWRON     0x0e /* power-on */
+#define OZ99X_REG_ALF       0x0f /* auto led flash */
+#define OZ99X_REG_ALF_DATA  0x10 /* ALF data */
+#define OZ99X_REG_ALF_FREQH 0x11 /* ALF frequency control GPIO[4..7] */
+#define OZ99X_REG_ALF_FREQL 0x12 /* ALF frequency control GPIO[0..3] */
+#define OZ99X_REG_ID        0x13 /* bus ID */
+#define OZ99X_REG_CHIPID    0x14 /* chip ID */
+/* OZ992 also has registers 0x15..0x1F */
+
+/* for wakeup and interrupt trigger enable
+ * gpio defines the bit positions for each GPIO
+ * (only 8-15 are used)
+ */
+#define OZ99X_EN_RE(gpio) (((gpio) >> 8) & 0x00FF) /* rising edge */
+#define OZ99X_EN_FE(gpio) ((gpio) & 0xFF00) /* falling edge */
+
+/* these return GPIOs as bit positions */
+#define OZ99X_STATUS_INT(status)  (((status) & 0x00FF) << 8)
+#define OZ99X_STATUS_WAKE(status) ((status) & 0xFF00)
+#define OZ99X_STATUS_SUSP(status)  (((status) & 0x00FF) << 8)
+
+/* special GPIO alternate functions:
+ * GPIO<0>: SMIEVENT
+ * GPIO<1>: WAKE output
+ * GPIO<2>: SMBALERT#
+ */
+#define OZ99X_SMICFG_WAKE_LEVEL (1 << 10)
+#define OZ99X_SMICFG_SMI_LEVEL  (1 <<  8)
+#define OZ99X_SMICFG_WAKE2PWR   (1 <<  7)
+#define OZ99X_SMICFG_WAKE2WAKE  (1 <<  6)
+#define OZ99X_SMICFG_WAKE2SMB   (1 <<  5)
+#define OZ99X_SMICFG_WAKE2SMI   (1 <<  4)
+#define OZ99X_SMICFG_INT2SMB    (1 <<  1)
+#define OZ99X_SMICFG_INT2SMI    (1 <<  0)
+
+#define OZ99X_ALF_DISABLE   (1 << 8)
+#define OZ99X_ALF_DATA_A(n) (((n) & 0xFF) << 8)
+#define OZ99X_ALF_DATA_B(n) ((n) & 0xFF)
+
+#define OZ99X_ID_SMBADDR(n) (((n) >> 9) & 0x007F)
+#define OZ99X_ID_ID(n)      ((n) & 0x00FF)
+#define OZ99X_CHIPID_ID(n)  (((n) >> 8) & 0x00FF)
+#define OZ99X_CHIPID_REV(n) ((n) & 0x00FF)
+
+static
+int oz99x_find_leds(struct i2c_client *client)
+{
+	int i;
+	int leds = 0;
+	int gpc = oz99x_reg_read(client, OZ99X_REG_GPC_LOW);
+
+	if (gpc <= 0)
+		return gpc;
+
+	for (i = OZ99X_LED_MIN; i <= OZ99X_LED_MAX; ++i)
+		if (OZ99X_GPC(i, gpc) == OZ99X_GPC_ALF)
+			leds |= (1 << i);
+	return leds;
+}
+
+static
+void oz99x_leds_on(struct i2c_client *client, int leds)
+{
+	int data;
+
+	if (!leds)
+		return;
+
+	data = oz99x_reg_read(client, OZ99X_REG_ALF_DATA);
+	/* blinks if A != B but we want A == B */
+	data |= (OZ99X_ALF_DATA_A(leds) | OZ99X_ALF_DATA_B(leds));
+	oz99x_reg_write(client, OZ99X_REG_ALF_DATA, data);
+
+	data = oz99x_reg_read(client, OZ99X_REG_ALF);
+	data &= ~OZ99X_ALF_DISABLE;
+	oz99x_reg_write(client, OZ99X_REG_ALF, data);
+}
+
+static
+void oz99x_leds_off(struct i2c_client *client, int leds)
+{
+	int data;
+
+	if (!leds) {
+		data = oz99x_reg_read(client, OZ99X_REG_ALF_DATA);
+		data &= ~(OZ99X_ALF_DATA_A(leds) | OZ99X_ALF_DATA_B(leds));
+		oz99x_reg_write(client, OZ99X_REG_ALF_DATA, data);
+	}
+
+	data = oz99x_reg_read(client, OZ99X_REG_ALF);
+	if (!(data & OZ99X_ALF_DISABLE)) {
+		data |= OZ99X_ALF_DISABLE;
+		oz99x_reg_write(client, OZ99X_REG_ALF, data);
+	}
+}
+
+static
+void oz99x_led_brightness_set(struct led_classdev *led_cdev,
+			      enum led_brightness brightness)
+{
+	struct oz99x_led_data *ldata = oz99x_from_led_cdev(led_cdev);
+	if (brightness)
+		oz99x_leds_on(ldata->data->client, ldata->gpio);
+	else
+		oz99x_leds_off(ldata->data->client, ldata->gpio);
+}
+
+static
+void oz99x_configure_leds(struct oz99x_data *data, int leds)
+{
+	int i = OZ99X_LED_MIN;
+	for (; i <= OZ99X_LED_MAX; ++i)
+		if (leds & (1 << i)) {
+			struct oz99x_led_data *ldata = kzalloc(sizeof(*ldata),
+							       GFP_KERNEL);
+			if (ldata) {
+				ldata->data = data;
+				ldata->gpio = i;
+				snprintf(ldata->name, sizeof(ldata->name),
+					 "oz99x:%d", i);
+				ldata->cdev.name = ldata->name;
+				ldata->cdev.brightness_set =
+					oz99x_led_brightness_set;
+				list_add(&ldata->list, &data->leds);
+				led_classdev_register(&data->client->dev,
+						      &ldata->cdev);
+			}
+		}
+}
+
+static
+int oz99x_find_buttons(struct i2c_client *client)
+{
+	int i;
+	int buttons = 0;
+	int gpc = oz99x_reg_read(client, OZ99X_REG_GPC_HIGH);
+
+	if (gpc <= 0)
+		return gpc;
+
+	for (i = OZ99X_BUTTON_MIN; i <= OZ99X_BUTTON_MAX; ++i)
+		if (OZ99X_GPC(i, gpc) == OZ99X_GPC_IN_DEB)
+			buttons |= (1 << i);
+	return buttons;
+}
+
+static
+int oz99x_configure_buttons(struct i2c_client *client, int buttons)
+{
+	int status;
+	u16 wake_en = OZ99X_EN_FE(buttons);
+	u16 susp_en = OZ99X_EN_RE(buttons);
+	u16 int_en = susp_en;
+	u16 smicfg = 0;
+
+#if 0 /* not sure how this could be used */
+	smicfg |= (OZ99X_SMICFG_WAKE2SMI | OZ99X_SMICFG_INT2SMI);
+#endif
+#if 0 /* I2C framework doesn't support SMB-ALERT */
+	/* route all events to SMBALERTs */
+	smicfg |= (OZ99X_SMICFG_WAKE2SMB | OZ99X_SMICFG_INT2SMB);
+#endif
+
+	/* suspend on rising edge: button up event */
+	status = oz99x_reg_write(client, OZ99X_REG_SUSP_EN, susp_en);
+	if (status < 0)
+		return status;
+	status = oz99x_reg_read(client, OZ99X_REG_SUSP_EN);
+	if (status < 0)
+		return status;
+	if (status != susp_en) {
+		if (oz99x_debug)
+			dev_err(&client->dev,
+				"SUSP_EN register is write-protected\n");
+		susp_en = 0;
+	}
+
+	/* wakeup on falling edge: button down event */
+	status = oz99x_reg_write(client, OZ99X_REG_WAKE_EN, wake_en);
+	if (status < 0)
+		return status;
+	status = oz99x_reg_read(client, OZ99X_REG_WAKE_EN);
+	if (status < 0)
+		return status;
+	if (status != wake_en) {
+		if (oz99x_debug)
+			dev_err(&client->dev,
+				"WAKE_EN register is write-protected\n");
+		smicfg &= ~(OZ99X_SMICFG_WAKE2SMI | OZ99X_SMICFG_WAKE2SMB);
+		wake_en = 0;
+	}
+
+	status = oz99x_reg_write(client, OZ99X_REG_INT_EN, int_en);
+	if (status < 0)
+		return status;
+	status = oz99x_reg_read(client, OZ99X_REG_INT_EN);
+	if (status < 0)
+		return status;
+	if (status != int_en) {
+		if (oz99x_debug)
+			dev_err(&client->dev,
+				"INT_EN register is write-protected\n");
+		smicfg &= ~(OZ99X_SMICFG_INT2SMI | OZ99X_SMICFG_INT2SMB);
+	}
+
+	status = oz99x_reg_write(client, OZ99X_REG_SMICFG, smicfg);
+	if (status < 0) {
+		dev_err(&client->dev,
+			"Writing to SMI configuration register failed\n");
+		return status;
+	}
+	status = oz99x_reg_read(client, OZ99X_REG_SMICFG);
+	if (status < 0)
+		return status;
+	if (status != smicfg)
+		dev_err(&client->dev,
+			"SMI configuration register is write-protected\n");
+
+	return 0;
+}
+
+static
+int oz99x_get_button_states(struct i2c_client *client,
+			    int *pressed,
+			    int *released)
+{
+	int status = oz99x_reg_read(client, OZ99X_REG_STATUS);
+	if (status < 0)
+		return status;
+	if (pressed)
+		*pressed = OZ99X_STATUS_WAKE(status);
+	if (released)
+		*released = OZ99X_STATUS_INT(status);
+	status = oz99x_reg_read(client, OZ99X_REG_SUSP_ST);
+	if (released)
+		*released |= OZ99X_STATUS_SUSP(status);
+	return 0;
+}
+
+static
+void oz99x_buttons_report(struct input_polled_dev *ipdev)
+{
+	struct oz99x_data *data = ipdev->private;
+	int i = 0;
+	int pressed = 0;
+	int released = 0;
+
+	if (oz99x_get_button_states(data->client, &pressed, &released))
+		return;
+	for (; i < ipdev->input->keycodemax; ++i) {
+		if ((pressed | released) & (1 << (i+8))) {
+			input_report_key(ipdev->input, data->keymap[i], 1);
+			input_sync(ipdev->input);
+		}
+		if (released & (1 << (i+8))) {
+			input_report_key(ipdev->input, data->keymap[i], 0);
+			input_sync(ipdev->input);
+		}
+	}
+}
+
+static
+int oz99x_buttons_keycode_get(struct input_dev *idev, int scancode,
+			      int *keycode)
+{
+	struct oz99x_data *data = idev->private;
+	if (scancode < 0 || scancode >= ARRAY_SIZE(data->keymap))
+		return -EINVAL;
+
+	*keycode = data->keymap[scancode];
+	return 0;
+}
+
+static
+int oz99x_buttons_keycode_set(struct input_dev *idev, int scancode, int keycode)
+{
+	struct oz99x_data *data = idev->private;
+
+	if (keycode < 0 || keycode > KEY_MAX)
+		return -EINVAL;
+
+	if (scancode < 0 || scancode >= ARRAY_SIZE(data->keymap))
+		return -EINVAL;
+
+	clear_bit(data->keymap[scancode], idev->keybit);
+	data->keymap[scancode] = keycode;
+	set_bit(keycode, idev->keybit);
+	return 0;
+}
+
+static
+int oz99x_buttons_poll_setup(struct oz99x_data *data, int buttons)
+{
+	static unsigned int keycodes[sizeof(data->keymap)] = {
+		KEY_PROG1, KEY_PROG2, KEY_PROG3, KEY_PROG4,
+		KEY_MAIL, KEY_WWW, KEY_CALC, KEY_MSDOS
+	};
+	struct input_polled_dev *ipdev;
+	struct input_dev *input;
+	int i = 0;
+	int n = 0;
+	struct oz99x_platform_data *pdata = data->client->dev.platform_data;
+
+	if (buttons == 0)
+		return -ENODEV;
+
+	buttons >>= 8;
+	ipdev = input_allocate_polled_device();
+	if (!ipdev)
+		return -ENOMEM;
+
+	ipdev->poll = oz99x_buttons_report;
+	ipdev->poll_interval = oz99x_poll;
+	ipdev->private = data;
+
+	input = ipdev->input;
+	input->name = "oz99x buttons";
+	input->phys = "oz99x/input0";
+	input->private = data;
+	input->id.bustype = BUS_HOST;
+	input->dev.parent = &data->client->dev;
+	input->getkeycode = oz99x_buttons_keycode_get;
+	input->setkeycode = oz99x_buttons_keycode_set;
+	input->keycodemax = fls(buttons);
+
+	if (!pdata) {
+		for (i = 0; i < input->keycodemax; ++i)
+			if (buttons & (1 << i))
+				data->keymap[i] = keycodes[n++];
+	} else {
+		for (i = 0; i < input->keycodemax; ++i)
+			if (buttons & (1 << i))
+				data->keymap[i] = pdata->keymap[n++];
+	}
+
+	set_bit(EV_KEY, input->evbit);
+	for (i = 0; i < input->keycodemax; ++i)
+		if ((buttons & (1 << i)) && data->keymap[i])
+			set_bit(data->keymap[i], input->keybit);
+
+	i = input_register_polled_device(ipdev);
+	if (!i)
+		data->ipdev = ipdev;
+	return i;
+}
+
+static
+int oz99x_i2c_addr_check(struct i2c_client *client)
+{
+	int status = oz99x_reg_read(client, OZ99X_REG_ID);
+
+	if (status < 0)
+	     return status;
+	return (OZ99X_ID_SMBADDR(status) == client->addr);
+}
+
+static
+int oz99x_check(struct i2c_client *client)
+{
+	int id;
+	int rev;
+	int status = oz99x_i2c_addr_check(client);
+
+	if (status <= 0)
+		return status;
+
+	status = oz99x_reg_read(client, OZ99X_REG_CHIPID);
+	if (status < 0)
+		return status;
+
+	id = OZ99X_CHIPID_ID(status);
+	rev = OZ99X_CHIPID_REV(status);
+	switch (id) {
+	case 0x90:
+	case 0x92:
+		dev_info(&client->dev,
+			 "found OZ9%02X (revision %d) @ I2C address 0x%02x\n",
+			 id, rev, client->addr);
+		return id;
+
+	default:
+		return 0;
+	}
+}
+
+static
+int __devinit oz99x_probe(struct i2c_client *client)
+{
+	struct oz99x_data *data;
+	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
+	int id;
+	int buttons;
+	int leds;
+	int status = 0;
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA))
+		return -EIO;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->client = client;
+	INIT_LIST_HEAD(&data->leds);
+
+	id = oz99x_check(client);
+	if (!id) {
+		status = -ENODEV;
+		goto out;
+	}
+
+	buttons = oz99x_find_buttons(client);
+	if (!buttons) {
+		dev_info(&client->dev, "no buttons configured.\n");
+	} else {
+		status = oz99x_configure_buttons(client, buttons);
+		if (!status)
+			status = oz99x_buttons_poll_setup(data, buttons);
+		if (status)
+			goto out;
+	}
+
+	leds = oz99x_find_leds(client);
+	if (!leds)
+		dev_info(&client->dev, "no LEDs configured.\n");
+	else
+		oz99x_configure_leds(data, leds);
+
+	switch (id) {
+	case 0x90:
+		data->range.max = 0x14;
+		break;
+
+	case 0x92:
+		data->range.max = 0x1F;
+		break;
+	}
+	if (oz99x_debug) {
+		device_create_file(&client->dev, &dev_attr_regs_max);
+		device_create_file(&client->dev, &dev_attr_regs_min);
+		device_create_file(&client->dev, &dev_attr_regs);
+	}
+
+	i2c_set_clientdata(client, data);
+	return 0;
+
+out:
+	kfree(data);
+	data = NULL;
+	return status;
+}
+
+static
+int __devexit oz99x_remove(struct i2c_client *client)
+{
+	struct list_head *pos;
+	struct oz99x_data *data = i2c_get_clientdata(client);
+
+	if (data->ipdev)
+		input_unregister_polled_device(data->ipdev);
+
+	if (oz99x_debug) {
+		device_remove_file(&client->dev, &dev_attr_regs);
+		device_remove_file(&client->dev, &dev_attr_regs_min);
+		device_remove_file(&client->dev, &dev_attr_regs_max);
+	}
+
+	list_for_each(pos, &data->leds) {
+		struct oz99x_led_data *ldata =
+			list_entry(pos, struct oz99x_led_data, list);
+		led_classdev_unregister(&ldata->cdev);
+		kfree(ldata);
+	}
+
+	kfree(data);
+	return 0;
+}
+
+static
+struct i2c_driver oz99x_driver = {
+	.driver = {
+		.name	= "oz99x",
+	},
+	.probe	= oz99x_probe,
+	.remove	= __devexit_p(oz99x_remove),
+};
+
+static
+int __init oz99x_module_init(void)
+{
+	return i2c_add_driver(&oz99x_driver);
+}
+
+static
+void __exit oz99x_module_exit(void)
+{
+	i2c_del_driver(&oz99x_driver);
+}
+
+module_init(oz99x_module_init);
+module_exit(oz99x_module_exit);
+
+MODULE_DESCRIPTION("O2 Micro OZ99x SMBus devices");
+MODULE_AUTHOR("Hendrik Sattler");
+MODULE_LICENSE("GPL");
diff -puN /dev/null include/linux/oz99x.h
--- /dev/null
+++ a/include/linux/oz99x.h
@@ -0,0 +1,31 @@
+/*
+    oz99x.h - O2 Micro/ETC OZ990/OZ992 driver
+
+    Copyright (C) 2006-2007 Hendrik Sattler <post@hendrik-sattler.de>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License along
+    with this program; if not, write to the Free Software Foundation, Inc.,
+    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+*/
+
+#define OZ99X_BUTTON_MAX 15
+#define OZ99X_BUTTON_MIN 8
+#define OZ99X_KEYMAP_ENTRIES (OZ99X_BUTTON_MAX-OZ99X_BUTTON_MIN+1)
+
+#define OZ99X_LED_MAX 7
+#define OZ99X_LED_MIN 0
+#define OZ99X_LED_COUNT (OZ99X_LED_MAX-OZ99X_LED_MIN+1)
+
+struct oz99x_platform_data {
+	int keymap[OZ99X_KEYMAP_ENTRIES];
+};
_

Patches currently in -mm which might be from post@hendrik-sattler.de are

oz99x-i2c-button-and-led-support-driver.patch
fjkeyinf-driver-for-fsc-lifebook-laptops.patch
