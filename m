From: akpm@linux-foundation.org
Subject: + backlight-new-backlight-driver-for-lp855x-devices.patch added to -mm tree
Date: Thu, 26 Jan 2012 15:41:28 -0800
Message-ID: <20120126234128.ABA0FA01C7@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:32903 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab2AZXla (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2012 18:41:30 -0500
Received: by yhjj52 with SMTP id j52so119563yhj.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2012 15:41:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Milo.Kim@ti.com, milo.kim@ti.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight: new backlight driver for LP855x devices
has been added to the -mm tree.  Its filename is
     backlight-new-backlight-driver-for-lp855x-devices.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: backlight: new backlight driver for LP855x devices

This driver supports TI LP8550/LP8551/LP8852/LP8553/LP8556 backlight
devices.

The brightness can be controlled by the I2C or PWM input.

The lp855x driver provides both modes.

For the PWM control, pwm-specific functions can be defined in the platform
data.  And some information can be read via the sysfs(lp855x device
attributes).

For details, please refer to 'Documentation/backlight/lp855x-driver.txt'.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/backlight/lp855x-driver.txt |   81 ++++
 drivers/video/backlight/Kconfig           |    7 
 drivers/video/backlight/Makefile          |    1 
 drivers/video/backlight/lp855x_bl.c       |  331 ++++++++++++++++++++
 include/linux/lp855x.h                    |  133 ++++++++
 5 files changed, 553 insertions(+)

diff -puN /dev/null Documentation/backlight/lp855x-driver.txt
--- /dev/null
+++ a/Documentation/backlight/lp855x-driver.txt
@@ -0,0 +1,81 @@
+Kernel driver lp855x
+====================
+
+Backlight driver for LP855x ICs
+
+Supported chips:
+       Texas Instruments LP8550, LP8551, LP8552, LP8553 and LP8556
+
+Author: Milo(Woogyom) Kim <milo.kim@ti.com>
+
+Description
+-----------
+
+* Brightness control
+
+Brightness can be controlled by the pwm input or the i2c command.
+The lp855x driver supports both cases.
+
+* Device attributes
+
+1) bl_ctl_mode
+Backlight control mode.
+Value : pwm based or register based
+
+2) chip_id
+The lp855x chip id.
+Value : lp8550/lp8551/lp8552/lp8553/lp8556
+
+Platform data for lp855x
+------------------------
+
+For supporting platform specific data, the lp855x platform data can be used.
+
+* name : Backlight driver name. If it is not defined, default name is set.
+* mode : Brightness control mode. PWM or register based.
+* device_control : Value of DEVICE CONTROL register.
+* initial_brightness : Initial value of backlight brightness.
+* max_brightness : Maximum value of backlight brightness.
+* pwm_data : Platform specific pwm generation functions.
+            Only valid when brightness is pwm input mode.
+            Functions should be implemented by PWM driver.
+            - pwm_set_intensity() : set duty of PWM
+            - pwm_get_intensity() : get current duty of PWM
+* load_new_rom_data :
+       0 : use default configuration data
+       1 : update values of eeprom or eprom registers on loading driver
+* size_program : Total size of lp855x_rom_data.
+* rom_data : List of new eeprom/eprom registers.
+
+example 1) lp8552 platform data : i2c register mode with new eeprom data
+
+#define EEPROM_A5_ADDR 0xA5
+#define EEPROM_A5_VAL  0x4f    /* EN_VSYNC=0 */
+
+static struct lp855x_rom_data lp8552_eeprom_arr[] = {
+       {EEPROM_A5_ADDR, EEPROM_A5_VAL},
+};
+
+static struct lp855x_platform_data lp8552_pdata = {
+       .name = "lcd-bl",
+       .mode = REGISTER_BASED,
+       .device_control = I2C_CONFIG(LP8552),
+       .initial_brightness = INITIAL_BRT,
+       .max_brightness = MAX_BRT,
+       .load_new_rom_data = 1,
+       .size_program = ARRAY_SIZE(lp8552_eeprom_arr),
+       .rom_data = lp8552_eeprom_arr,
+};
+
+example 2) lp8556 platform data : pwm input mode with default rom data
+
+static struct lp855x_platform_data lp8556_pdata = {
+       .mode = PWM_BASED,
+       .device_control = PWM_CONFIG(LP8556),
+       .initial_brightness = INITIAL_BRT,
+       .max_brightness = MAX_BRT,
+       .pwm_data = {
+                    .pwm_set_intensity = platform_pwm_set_intensity,
+                    .pwm_get_intensity = platform_pwm_get_intensity,
+                    },
+};
diff -puN drivers/video/backlight/Kconfig~backlight-new-backlight-driver-for-lp855x-devices drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~backlight-new-backlight-driver-for-lp855x-devices
+++ a/drivers/video/backlight/Kconfig
@@ -334,6 +334,13 @@ config BACKLIGHT_AAT2870
 	  If you have a AnalogicTech AAT2870 say Y to enable the
 	  backlight driver.
 
+config BACKLIGHT_LP855X
+       tristate "Backlight driver for TI LP855X"
+       depends on BACKLIGHT_CLASS_DEVICE && I2C
+       help
+         This supports TI LP8550, LP8551, LP8552, LP8553 and LP8556
+         backlight driver.
+
 endif # BACKLIGHT_CLASS_DEVICE
 
 endif # BACKLIGHT_LCD_SUPPORT
diff -puN drivers/video/backlight/Makefile~backlight-new-backlight-driver-for-lp855x-devices drivers/video/backlight/Makefile
--- a/drivers/video/backlight/Makefile~backlight-new-backlight-driver-for-lp855x-devices
+++ a/drivers/video/backlight/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_BACKLIGHT_GENERIC)	+= gener
 obj-$(CONFIG_BACKLIGHT_HP700)	+= jornada720_bl.o
 obj-$(CONFIG_BACKLIGHT_HP680)	+= hp680_bl.o
 obj-$(CONFIG_BACKLIGHT_LOCOMO)	+= locomolcd.o
+obj-$(CONFIG_BACKLIGHT_LP855X) += lp855x_bl.o
 obj-$(CONFIG_BACKLIGHT_OMAP1)	+= omap1_bl.o
 obj-$(CONFIG_BACKLIGHT_PROGEAR) += progear_bl.o
 obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH) += cr_bllcd.o
diff -puN /dev/null drivers/video/backlight/lp855x_bl.c
--- /dev/null
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -0,0 +1,331 @@
+/*
+ * TI LP855x Backlight Driver
+ *
+ *                     Copyright (C) 2011 Texas Instruments
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/backlight.h>
+#include <linux/err.h>
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+#include <linux/lp855x.h>
+
+/* Registers */
+#define BRIGHTNESS_CTRL                (0x00)
+#define DEVICE_CTRL            (0x01)
+
+#define BUF_SIZE               (20)
+#define DEFAULT_BL_NAME                "lcd-backlight"
+
+struct lp855x {
+       const char *chipid;
+       struct i2c_client *client;
+       struct backlight_device *bl;
+       struct device *dev;
+       struct mutex xfer_lock;
+       struct lp855x_platform_data *pdata;
+};
+
+static int lp855x_read_byte(struct lp855x *lp, u8 reg, u8 *data)
+{
+       int ret;
+
+       mutex_lock(&lp->xfer_lock);
+       ret = i2c_smbus_read_byte_data(lp->client, reg);
+       if (ret < 0) {
+               dev_err(lp->dev, "failed to read 0x%.2x\n", reg);
+               return ret;
+       }
+       mutex_unlock(&lp->xfer_lock);
+
+       *data = (u8)ret;
+       return 0;
+}
+
+static int lp855x_write_byte(struct lp855x *lp, u8 reg, u8 data)
+{
+       int ret;
+
+       mutex_lock(&lp->xfer_lock);
+       ret = i2c_smbus_write_byte_data(lp->client, reg, data);
+       mutex_unlock(&lp->xfer_lock);
+
+       return ret;
+}
+
+static int lp855x_is_valid_rom_area(struct lp855x *lp, u8 addr)
+{
+       const char *id = lp->chipid;
+       u8 start, end;
+
+       if (strstr(id, "lp8550") || strstr(id, "lp8551")
+           || strstr(id, "lp8552") || strstr(id, "lp8553")) {
+               start = EEPROM_START;
+               end = EEPROM_END;
+       } else if (strstr(id, "lp8556")) {
+               start = EPROM_START;
+               end = EPROM_END;
+       }
+
+       return (addr >= start && addr <= end) ? 1 : 0;
+}
+
+static int lp855x_init_registers(struct lp855x *lp)
+{
+       u8 val, addr;
+       int i, ret;
+       struct lp855x_platform_data *pd = lp->pdata;
+
+       val = pd->initial_brightness;
+       ret = lp855x_write_byte(lp, BRIGHTNESS_CTRL, val);
+       if (ret)
+               return ret;
+
+       val = pd->device_control;
+       ret = lp855x_write_byte(lp, DEVICE_CTRL, val);
+       if (ret)
+               return ret;
+
+       if (pd->load_new_rom_data && pd->size_program) {
+               for (i = 0; i < pd->size_program; i++) {
+                       addr = pd->rom_data[i].addr;
+                       val = pd->rom_data[i].val;
+                       if (!lp855x_is_valid_rom_area(lp, addr))
+                               continue;
+
+                       ret = lp855x_write_byte(lp, addr, val);
+                       if (ret)
+                               return ret;
+               }
+       }
+
+       return ret;
+}
+
+static int lp855x_bl_update_status(struct backlight_device *bl)
+{
+       struct lp855x *lp = bl_get_data(bl);
+       enum lp855x_brightness_ctrl_mode mode = lp->pdata->mode;
+
+       if (bl->props.state & BL_CORE_SUSPENDED)
+               bl->props.brightness = 0;
+
+       if (mode == PWM_BASED) {
+               struct lp855x_pwm_data *pd = &lp->pdata->pwm_data;
+               int br = bl->props.brightness;
+               int max_br = bl->props.max_brightness;
+
+               if (pd->pwm_set_intensity)
+                       pd->pwm_set_intensity(br, max_br);
+
+       } else if (mode == REGISTER_BASED) {
+               u8 val = bl->props.brightness;
+               lp855x_write_byte(lp, BRIGHTNESS_CTRL, val);
+       }
+
+       return (bl->props.brightness);
+}
+
+static int lp855x_bl_get_brightness(struct backlight_device *bl)
+{
+       struct lp855x *lp = bl_get_data(bl);
+       enum lp855x_brightness_ctrl_mode mode = lp->pdata->mode;
+
+       if (mode == PWM_BASED) {
+               struct lp855x_pwm_data *pd = &lp->pdata->pwm_data;
+               int max_br = bl->props.max_brightness;
+
+               if (pd->pwm_get_intensity)
+                       bl->props.brightness = pd->pwm_get_intensity(max_br);
+
+       } else if (mode == REGISTER_BASED) {
+               u8 val = 0;
+
+               lp855x_read_byte(lp, BRIGHTNESS_CTRL, &val);
+               bl->props.brightness = val;
+       }
+
+       return (bl->props.brightness);
+}
+
+static const struct backlight_ops lp855x_bl_ops = {
+       .options = BL_CORE_SUSPENDRESUME,
+       .update_status = lp855x_bl_update_status,
+       .get_brightness = lp855x_bl_get_brightness,
+};
+
+static int lp855x_backlight_register(struct lp855x *lp)
+{
+       struct backlight_device *bl;
+       struct backlight_properties props;
+       struct lp855x_platform_data *pdata = lp->pdata;
+       char *name = pdata->name ? : DEFAULT_BL_NAME;
+
+       props.type = BACKLIGHT_PLATFORM;
+       props.brightness = pdata->initial_brightness;
+       props.max_brightness =
+               (pdata->max_brightness < pdata->initial_brightness) ?
+               255 : pdata->max_brightness;
+
+       bl = backlight_device_register(name, lp->dev, lp,
+                                      &lp855x_bl_ops, &props);
+       if (IS_ERR(bl))
+               return PTR_ERR(bl);
+
+       lp->bl = bl;
+
+       return 0;
+}
+
+static void lp855x_backlight_unregister(struct lp855x *lp)
+{
+       if (lp->bl)
+               backlight_device_unregister(lp->bl);
+}
+
+static ssize_t lp855x_get_chip_id(struct device *dev,
+                               struct device_attribute *attr, char *buf)
+{
+       struct lp855x *lp = dev_get_drvdata(dev);
+       return scnprintf(buf, BUF_SIZE, "%s\n", lp->chipid);
+}
+
+static ssize_t lp855x_get_bl_ctl_mode(struct device *dev,
+                                    struct device_attribute *attr, char *buf)
+{
+       struct lp855x *lp = dev_get_drvdata(dev);
+       enum lp855x_brightness_ctrl_mode mode = lp->pdata->mode;
+       char *strmode = NULL;
+
+       if (mode == PWM_BASED)
+               strmode = "pwm based";
+       else if (mode == REGISTER_BASED)
+               strmode = "register based";
+
+       return scnprintf(buf, BUF_SIZE, "%s\n", strmode);
+}
+
+static DEVICE_ATTR(chip_id, S_IRUGO, lp855x_get_chip_id, NULL);
+static DEVICE_ATTR(bl_ctl_mode, S_IRUGO, lp855x_get_bl_ctl_mode, NULL);
+
+static struct attribute *lp855x_attributes[] = {
+       &dev_attr_chip_id.attr,
+       &dev_attr_bl_ctl_mode.attr,
+       NULL,
+};
+
+static const struct attribute_group lp855x_attr_group = {
+       .attrs = lp855x_attributes,
+};
+
+static int lp855x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
+{
+       struct lp855x *lp;
+       struct lp855x_platform_data *pdata = cl->dev.platform_data;
+       int ret;
+
+       if (!i2c_check_functionality(cl->adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
+               goto err_io;
+
+       lp = kzalloc(sizeof(struct lp855x), GFP_KERNEL);
+       if (!lp)
+               goto err_mem;
+
+       lp->client = cl;
+       lp->dev = &cl->dev;
+       lp->pdata = pdata;
+       lp->chipid = id->name;
+       i2c_set_clientdata(cl, lp);
+
+       mutex_init(&lp->xfer_lock);
+
+       ret = lp855x_init_registers(lp);
+       if (ret)
+               goto err_i2c;
+
+       ret = lp855x_backlight_register(lp);
+       if (ret)
+               goto err_bldev;
+
+       ret = sysfs_create_group(&lp->dev->kobj, &lp855x_attr_group);
+       if (ret)
+               goto err_sysfs;
+
+       backlight_update_status(lp->bl);
+       return ret;
+
+err_io:
+       return -EIO;
+err_mem:
+       return -ENOMEM;
+err_i2c:
+       dev_err(lp->dev, "i2c communication err: %d", ret);
+       kfree(lp);
+       return ret;
+err_bldev:
+       dev_err(lp->dev, "can not register backlight device. err: %d\n", ret);
+       kfree(lp);
+       return ret;
+err_sysfs:
+       dev_err(lp->dev, "can not register sysfs. err: %d\n", ret);
+       lp855x_backlight_unregister(lp);
+       kfree(lp);
+       return ret;
+}
+
+static int __devexit lp855x_remove(struct i2c_client *cl)
+{
+       struct lp855x *lp = i2c_get_clientdata(cl);
+
+       lp->bl->props.brightness = 0;
+       backlight_update_status(lp->bl);
+       sysfs_remove_group(&lp->dev->kobj, &lp855x_attr_group);
+       lp855x_backlight_unregister(lp);
+       kfree(lp);
+
+       return 0;
+}
+
+static const struct i2c_device_id lp855x_ids[] = {
+       {"lp8550", LP8550},
+       {"lp8551", LP8551},
+       {"lp8552", LP8552},
+       {"lp8553", LP8553},
+       {"lp8556", LP8556},
+       {},
+};
+MODULE_DEVICE_TABLE(i2c, lp855x_ids);
+
+static struct i2c_driver lp855x_driver = {
+       .driver = {
+                  .name = "lp855x",
+                  },
+       .probe = lp855x_probe,
+       .remove = __devexit_p(lp855x_remove),
+       .id_table = lp855x_ids,
+};
+
+static int __init lp855x_init(void)
+{
+       return i2c_add_driver(&lp855x_driver);
+}
+
+static void __exit lp855x_exit(void)
+{
+       i2c_del_driver(&lp855x_driver);
+}
+
+module_init(lp855x_init);
+module_exit(lp855x_exit);
+
+MODULE_DESCRIPTION("Texas Instruments LP855x Backlight driver");
+MODULE_AUTHOR("Milo Kim <milo.kim@ti.com>");
+MODULE_LICENSE("GPL");
diff -puN /dev/null include/linux/lp855x.h
--- /dev/null
+++ a/include/linux/lp855x.h
@@ -0,0 +1,133 @@
+/*
+ * LP855x Backlight Driver
+ *
+ *                     Copyright (C) 2011 Texas Instruments
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef _LP855X_H
+#define _LP855X_H
+
+#define BL_CTL_SHFT    (0)
+#define BRT_MODE_SHFT  (1)
+#define BRT_MODE_MASK  (0x06)
+
+/* Enable backlight. Only valid when BRT_MODE=10(I2C only) */
+#define ENABLE_BL      (1)
+#define DISABLE_BL     (0)
+
+#define I2C_CONFIG(id) id ## _I2C_CONFIG
+#define PWM_CONFIG(id) id ## _PWM_CONFIG
+
+/* DEVICE CONTROL register - LP8550 */
+#define LP8550_PWM_CONFIG      (LP8550_PWM_ONLY << BRT_MODE_SHFT)
+#define LP8550_I2C_CONFIG      ((ENABLE_BL << BL_CTL_SHFT) | \
+                               (LP8550_I2C_ONLY << BRT_MODE_SHFT))
+
+/* DEVICE CONTROL register - LP8551 */
+#define LP8551_PWM_CONFIG      LP8550_PWM_CONFIG
+#define LP8551_I2C_CONFIG      LP8550_I2C_CONFIG
+
+/* DEVICE CONTROL register - LP8552 */
+#define LP8552_PWM_CONFIG      LP8550_PWM_CONFIG
+#define LP8552_I2C_CONFIG      LP8550_I2C_CONFIG
+
+/* DEVICE CONTROL register - LP8553 */
+#define LP8553_PWM_CONFIG      LP8550_PWM_CONFIG
+#define LP8553_I2C_CONFIG      LP8550_I2C_CONFIG
+
+/* DEVICE CONTROL register - LP8556 */
+#define LP8556_PWM_CONFIG      (LP8556_PWM_ONLY << BRT_MODE_SHFT)
+#define LP8556_COMB1_CONFIG    (LP8556_COMBINED1 << BRT_MODE_SHFT)
+#define LP8556_I2C_CONFIG      ((ENABLE_BL << BL_CTL_SHFT) | \
+                               (LP8556_I2C_ONLY << BRT_MODE_SHFT))
+#define LP8556_COMB2_CONFIG    (LP8556_COMBINED2 << BRT_MODE_SHFT)
+
+/* ROM area boundary */
+#define EEPROM_START   (0xA0)
+#define EEPROM_END     (0xA7)
+#define EPROM_START    (0xA0)
+#define EPROM_END      (0xAF)
+
+enum lp855x_chip_id {
+       LP8550,
+       LP8551,
+       LP8552,
+       LP8553,
+       LP8556,
+};
+
+enum lp855x_brightness_ctrl_mode {
+       PWM_BASED = 1,
+       REGISTER_BASED,
+};
+
+enum lp8550_brighntess_source {
+       LP8550_PWM_ONLY,
+       LP8550_I2C_ONLY = 2,
+};
+
+enum lp8551_brighntess_source {
+       LP8551_PWM_ONLY = LP8550_PWM_ONLY,
+       LP8551_I2C_ONLY = LP8550_I2C_ONLY,
+};
+
+enum lp8552_brighntess_source {
+       LP8552_PWM_ONLY = LP8550_PWM_ONLY,
+       LP8552_I2C_ONLY = LP8550_I2C_ONLY,
+};
+
+enum lp8553_brighntess_source {
+       LP8553_PWM_ONLY = LP8550_PWM_ONLY,
+       LP8553_I2C_ONLY = LP8550_I2C_ONLY,
+};
+
+enum lp8556_brightness_source {
+       LP8556_PWM_ONLY,
+       LP8556_COMBINED1,       /* pwm + i2c before the shaper block */
+       LP8556_I2C_ONLY,
+       LP8556_COMBINED2,       /* pwm + i2c after the shaper block */
+};
+
+struct lp855x_pwm_data {
+       void (*pwm_set_intensity) (int brightness, int max_brightness);
+       int (*pwm_get_intensity) (int max_brightness);
+};
+
+struct lp855x_rom_data {
+       u8 addr;
+       u8 val;
+};
+
+/**
+ * struct lp855x_platform_data
+ * @name : Backlight driver name. If it is not defined, default name is set.
+ * @mode : brightness control by pwm or lp855x register
+ * @device_control : value of DEVICE CONTROL register
+ * @initial_brightness : initial value of backlight brightness
+ * @max_brightness : maximum value of backlight brightness
+ * @pwm_data : platform specific pwm generation functions.
+               Only valid when mode is PWM_BASED.
+ * @load_new_rom_data :
+       0 : use default configuration data
+       1 : update values of eeprom or eprom registers on loading driver
+ * @size_program : total size of lp855x_rom_data
+ * @rom_data : list of new eeprom/eprom registers
+ */
+struct lp855x_platform_data {
+       char *name;
+       enum lp855x_brightness_ctrl_mode mode;
+       u8 device_control;
+       int initial_brightness;
+       int max_brightness;
+       struct lp855x_pwm_data pwm_data;
+       u8 load_new_rom_data;
+       int size_program;
+       struct lp855x_rom_data *rom_data;
+};
+
+#endif
_
Subject: Subject: backlight: new backlight driver for LP855x devices

Patches currently in -mm which might be from Milo.Kim@ti.com are

backlight-new-backlight-driver-for-lp855x-devices.patch

