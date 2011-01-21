From: akpm@linux-foundation.org
Subject: + backlight-new-driver-for-the-adp8870-backlight-devices.patch added to -mm tree
Date: Thu, 20 Jan 2011 16:48:34 -0800
Message-ID: <201101210048.p0L0mYn0012318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753873Ab1AUAss (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Jan 2011 19:48:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, rpurdie@rpsys.net, vapier@gentoo.org


The patch titled
     backlight: new driver for the ADP8870 backlight devices
has been added to the -mm tree.  Its filename is
     backlight-new-driver-for-the-adp8870-backlight-devices.patch

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
Subject: backlight: new driver for the ADP8870 backlight devices
From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig      |   12 
 drivers/video/backlight/Makefile     |    1 
 drivers/video/backlight/adp8870_bl.c |  917 +++++++++++++++++++++++++
 include/linux/i2c/adp8870.h          |  153 ++++
 4 files changed, 1083 insertions(+)

diff -puN drivers/video/backlight/Kconfig~backlight-new-driver-for-the-adp8870-backlight-devices drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~backlight-new-driver-for-the-adp8870-backlight-devices
+++ a/drivers/video/backlight/Kconfig
@@ -294,6 +294,18 @@ config BACKLIGHT_ADP8860
 	  To compile this driver as a module, choose M here: the module will
 	  be called adp8860_bl.
 
+config BACKLIGHT_ADP8870
+	tristate "Backlight Driver for ADP8870 using WLED"
+	depends on BACKLIGHT_CLASS_DEVICE && I2C
+	select NEW_LEDS
+	select LEDS_CLASS
+	help
+	  If you have a LCD backlight connected to the ADP8870,
+	  say Y here to enable this driver.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called adp8870_bl.
+
 config BACKLIGHT_88PM860X
 	tristate "Backlight Driver for 88PM8606 using WLED"
 	depends on MFD_88PM860X
diff -puN drivers/video/backlight/Makefile~backlight-new-driver-for-the-adp8870-backlight-devices drivers/video/backlight/Makefile
--- a/drivers/video/backlight/Makefile~backlight-new-driver-for-the-adp8870-backlight-devices
+++ a/drivers/video/backlight/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_BACKLIGHT_WM831X)	+= wm831x
 obj-$(CONFIG_BACKLIGHT_ADX)    += adx_bl.o
 obj-$(CONFIG_BACKLIGHT_ADP5520)	+= adp5520_bl.o
 obj-$(CONFIG_BACKLIGHT_ADP8860)	+= adp8860_bl.o
+obj-$(CONFIG_BACKLIGHT_ADP8870)	+= adp8870_bl.o
 obj-$(CONFIG_BACKLIGHT_88PM860X) += 88pm860x_bl.o
 obj-$(CONFIG_BACKLIGHT_PCF50633)	+= pcf50633-backlight.o
 
diff -puN /dev/null drivers/video/backlight/adp8870_bl.c
--- /dev/null
+++ a/drivers/video/backlight/adp8870_bl.c
@@ -0,0 +1,917 @@
+/*
+ * Backlight driver for Analog Devices ADP8870 Backlight Devices
+ *
+ * Copyright 2009-2010 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/pm.h>
+#include <linux/platform_device.h>
+#include <linux/i2c.h>
+#include <linux/fb.h>
+#include <linux/backlight.h>
+#include <linux/leds.h>
+#include <linux/workqueue.h>
+#include <linux/slab.h>
+
+#include <linux/i2c/adp8870.h>
+#define ADP8870_EXT_FEATURES
+#define ADP8870_USE_LEDS
+
+
+#define ADP8870_MFDVID	0x00  /* Manufacturer and device ID */
+#define ADP8870_MDCR	0x01  /* Device mode and status */
+#define ADP8870_INT_STAT 0x02  /* Interrupts status */
+#define ADP8870_INT_EN	0x03  /* Interrupts enable */
+#define ADP8870_CFGR	0x04  /* Configuration register */
+#define ADP8870_BLSEL	0x05  /* Sink enable backlight or independent */
+#define ADP8870_PWMLED	0x06  /* PWM Enable Selection Register */
+#define ADP8870_BLOFF	0x07  /* Backlight off timeout */
+#define ADP8870_BLDIM	0x08  /* Backlight dim timeout */
+#define ADP8870_BLFR	0x09  /* Backlight fade in and out rates */
+#define ADP8870_BLMX1	0x0A  /* Backlight (Brightness Level 1-daylight) maximum current */
+#define ADP8870_BLDM1	0x0B  /* Backlight (Brightness Level 1-daylight) dim current */
+#define ADP8870_BLMX2	0x0C  /* Backlight (Brightness Level 2-bright) maximum current */
+#define ADP8870_BLDM2	0x0D  /* Backlight (Brightness Level 2-bright) dim current */
+#define ADP8870_BLMX3	0x0E  /* Backlight (Brightness Level 3-office) maximum current */
+#define ADP8870_BLDM3	0x0F  /* Backlight (Brightness Level 3-office) dim current */
+#define ADP8870_BLMX4	0x10  /* Backlight (Brightness Level 4-indoor) maximum current */
+#define ADP8870_BLDM4	0x11  /* Backlight (Brightness Level 4-indoor) dim current */
+#define ADP8870_BLMX5	0x12  /* Backlight (Brightness Level 5-dark) maximum current */
+#define ADP8870_BLDM5	0x13  /* Backlight (Brightness Level 5-dark) dim current */
+#define ADP8870_ISCLAW	0x1A  /* Independent sink current fade law register */
+#define ADP8870_ISCC	0x1B  /* Independent sink current control register */
+#define ADP8870_ISCT1	0x1C  /* Independent Sink Current Timer Register LED[7:5] */
+#define ADP8870_ISCT2	0x1D  /* Independent Sink Current Timer Register LED[4:1] */
+#define ADP8870_ISCF	0x1E  /* Independent sink current fade register */
+#define ADP8870_ISC1	0x1F  /* Independent Sink Current LED1 */
+#define ADP8870_ISC2	0x20  /* Independent Sink Current LED2 */
+#define ADP8870_ISC3	0x21  /* Independent Sink Current LED3 */
+#define ADP8870_ISC4	0x22  /* Independent Sink Current LED4 */
+#define ADP8870_ISC5	0x23  /* Independent Sink Current LED5 */
+#define ADP8870_ISC6	0x24  /* Independent Sink Current LED6 */
+#define ADP8870_ISC7	0x25  /* Independent Sink Current LED7 (Brightness Level 1-daylight) */
+#define ADP8870_ISC7_L2	0x26  /* Independent Sink Current LED7 (Brightness Level 2-bright) */
+#define ADP8870_ISC7_L3	0x27  /* Independent Sink Current LED7 (Brightness Level 3-office) */
+#define ADP8870_ISC7_L4	0x28  /* Independent Sink Current LED7 (Brightness Level 4-indoor) */
+#define ADP8870_ISC7_L5	0x29  /* Independent Sink Current LED7 (Brightness Level 5-dark) */
+#define ADP8870_CMP_CTL	0x2D  /* ALS Comparator Control Register */
+#define ADP8870_ALS1_EN	0x2E  /* Main ALS comparator level enable */
+#define ADP8870_ALS2_EN	0x2F  /* Second ALS comparator level enable */
+#define ADP8870_ALS1_STAT 0x30  /* Main ALS Comparator Status Register */
+#define ADP8870_ALS2_STAT 0x31  /* Second ALS Comparator Status Register */
+#define ADP8870_L2TRP	0x32  /* L2 comparator reference */
+#define ADP8870_L2HYS	0x33  /* L2 hysteresis */
+#define ADP8870_L3TRP	0x34  /* L3 comparator reference */
+#define ADP8870_L3HYS	0x35  /* L3 hysteresis */
+#define ADP8870_L4TRP	0x36  /* L4 comparator reference */
+#define ADP8870_L4HYS	0x37  /* L4 hysteresis */
+#define ADP8870_L5TRP	0x38  /* L5 comparator reference */
+#define ADP8870_L5HYS	0x39  /* L5 hysteresis */
+#define ADP8870_PH1LEVL	0x40  /* First phototransistor ambient light level-low byte register */
+#define ADP8870_PH1LEVH	0x41  /* First phototransistor ambient light level-high byte register */
+#define ADP8870_PH2LEVL	0x42  /* Second phototransistor ambient light level-low byte register */
+#define ADP8870_PH2LEVH	0x43  /* Second phototransistor ambient light level-high byte register */
+
+#define ADP8870_MANUFID		0x3  /* Analog Devices AD8870 Manufacturer and device ID */
+#define ADP8870_DEVID(x)	((x) & 0xF)
+#define ADP8870_MANID(x)	((x) >> 4)
+
+/* MDCR Device mode and status */
+#define D7ALSEN			(1 << 7)
+#define INT_CFG			(1 << 6)
+#define NSTBY			(1 << 5)
+#define DIM_EN			(1 << 4)
+#define GDWN_DIS		(1 << 3)
+#define SIS_EN			(1 << 2)
+#define CMP_AUTOEN		(1 << 1)
+#define BLEN			(1 << 0)
+
+/* ADP8870_ALS1_EN Main ALS comparator level enable */
+#define L5_EN			(1 << 3)
+#define L4_EN			(1 << 2)
+#define L3_EN			(1 << 1)
+#define L2_EN			(1 << 0)
+
+#define CFGR_BLV_SHIFT		3
+#define CFGR_BLV_MASK		0x7
+#define ADP8870_FLAG_LED_MASK	0xFF
+
+#define FADE_VAL(in, out)	((0xF & (in)) | ((0xF & (out)) << 4))
+#define BL_CFGR_VAL(law, blv)	((((blv) & CFGR_BLV_MASK) << CFGR_BLV_SHIFT) | ((0x3 & (law)) << 1))
+#define ALS_CMPR_CFG_VAL(filt)	((0x7 & filt) << 1)
+
+struct adp8870_bl {
+	struct i2c_client *client;
+	struct backlight_device *bl;
+	struct adp8870_led *led;
+	struct adp8870_backlight_platform_data *pdata;
+	struct mutex lock;
+	unsigned long cached_daylight_max;
+	int id;
+	int revid;
+	int current_brightness;
+};
+
+struct adp8870_led {
+	struct led_classdev	cdev;
+	struct work_struct	work;
+	struct i2c_client	*client;
+	enum led_brightness	new_brightness;
+	int			id;
+	int			flags;
+};
+
+static int adp8870_read(struct i2c_client *client, int reg, uint8_t *val)
+{
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(client, reg);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed reading at 0x%02x\n", reg);
+		return ret;
+	}
+
+	*val = (uint8_t)ret;
+	return 0;
+}
+
+
+static int adp8870_write(struct i2c_client *client, u8 reg, u8 val)
+{
+	return i2c_smbus_write_byte_data(client, reg, val);
+}
+
+static int adp8870_set_bits(struct i2c_client *client, int reg, uint8_t bit_mask)
+{
+	struct adp8870_bl *data = i2c_get_clientdata(client);
+	uint8_t reg_val;
+	int ret;
+
+	mutex_lock(&data->lock);
+
+	ret = adp8870_read(client, reg, &reg_val);
+
+	if (!ret && ((reg_val & bit_mask) == 0)) {
+		reg_val |= bit_mask;
+		ret = adp8870_write(client, reg, reg_val);
+	}
+
+	mutex_unlock(&data->lock);
+	return ret;
+}
+
+static int adp8870_clr_bits(struct i2c_client *client, int reg, uint8_t bit_mask)
+{
+	struct adp8870_bl *data = i2c_get_clientdata(client);
+	uint8_t reg_val;
+	int ret;
+
+	mutex_lock(&data->lock);
+
+	ret = adp8870_read(client, reg, &reg_val);
+
+	if (!ret && (reg_val & bit_mask)) {
+		reg_val &= ~bit_mask;
+		ret = adp8870_write(client, reg, reg_val);
+	}
+
+	mutex_unlock(&data->lock);
+	return ret;
+}
+
+/*
+ * Independent sink / LED
+ */
+#if defined(ADP8870_USE_LEDS)
+static void adp8870_led_work(struct work_struct *work)
+{
+	struct adp8870_led *led = container_of(work, struct adp8870_led, work);
+	adp8870_write(led->client, ADP8870_ISC1 + led->id - 1,
+			 led->new_brightness >> 1);
+}
+
+static void adp8870_led_set(struct led_classdev *led_cdev,
+			   enum led_brightness value)
+{
+	struct adp8870_led *led;
+
+	led = container_of(led_cdev, struct adp8870_led, cdev);
+	led->new_brightness = value;
+	schedule_work(&led->work);
+}
+
+static int adp8870_led_setup(struct adp8870_led *led)
+{
+	struct i2c_client *client = led->client;
+	int ret = 0;
+
+	ret = adp8870_write(client, ADP8870_ISC1 + led->id - 1, 0);
+	ret |= adp8870_set_bits(client, ADP8870_ISCC, 1 << (led->id - 1));
+
+	if (led->id > 4)
+		ret |= adp8870_set_bits(client, ADP8870_ISCT1,
+				(led->flags & 0x3) << ((led->id - 5) * 2));
+	else
+		ret |= adp8870_set_bits(client, ADP8870_ISCT2,
+				(led->flags & 0x3) << ((led->id - 1) * 2));
+
+	return ret;
+}
+
+static int __devinit adp8870_led_probe(struct i2c_client *client)
+{
+	struct adp8870_backlight_platform_data *pdata =
+		client->dev.platform_data;
+	struct adp8870_bl *data = i2c_get_clientdata(client);
+	struct adp8870_led *led, *led_dat;
+	struct led_info *cur_led;
+	int ret, i;
+
+	led = kzalloc(sizeof(*led) * pdata->num_leds, GFP_KERNEL);
+	if (led == NULL) {
+		dev_err(&client->dev, "failed to alloc memory\n");
+		return -ENOMEM;
+	}
+
+	ret = adp8870_write(client, ADP8870_ISCLAW, pdata->led_fade_law);
+	ret = adp8870_write(client, ADP8870_ISCT1,
+			(pdata->led_on_time & 0x3) << 6);
+	ret |= adp8870_write(client, ADP8870_ISCF,
+			FADE_VAL(pdata->led_fade_in, pdata->led_fade_out));
+
+	if (ret) {
+		dev_err(&client->dev, "failed to write\n");
+		goto err_free;
+	}
+
+	for (i = 0; i < pdata->num_leds; ++i) {
+		cur_led = &pdata->leds[i];
+		led_dat = &led[i];
+
+		led_dat->id = cur_led->flags & ADP8870_FLAG_LED_MASK;
+
+		if (led_dat->id > 7 || led_dat->id < 1) {
+			dev_err(&client->dev, "Invalid LED ID %d\n",
+				led_dat->id);
+			goto err;
+		}
+
+		if (pdata->bl_led_assign & (1 << (led_dat->id - 1))) {
+			dev_err(&client->dev, "LED %d used by Backlight\n",
+				led_dat->id);
+			goto err;
+		}
+
+		led_dat->cdev.name = cur_led->name;
+		led_dat->cdev.default_trigger = cur_led->default_trigger;
+		led_dat->cdev.brightness_set = adp8870_led_set;
+		led_dat->cdev.brightness = LED_OFF;
+		led_dat->flags = cur_led->flags >> FLAG_OFFT_SHIFT;
+		led_dat->client = client;
+		led_dat->new_brightness = LED_OFF;
+		INIT_WORK(&led_dat->work, adp8870_led_work);
+
+		ret = led_classdev_register(&client->dev, &led_dat->cdev);
+		if (ret) {
+			dev_err(&client->dev, "failed to register LED %d\n",
+				led_dat->id);
+			goto err;
+		}
+
+		ret = adp8870_led_setup(led_dat);
+		if (ret) {
+			dev_err(&client->dev, "failed to write\n");
+			i++;
+			goto err;
+		}
+	}
+
+	data->led = led;
+
+	return 0;
+
+ err:
+	for (i = i - 1; i >= 0; --i) {
+		led_classdev_unregister(&led[i].cdev);
+		cancel_work_sync(&led[i].work);
+	}
+
+ err_free:
+	kfree(led);
+
+	return ret;
+}
+
+static int __devexit adp8870_led_remove(struct i2c_client *client)
+{
+	struct adp8870_backlight_platform_data *pdata =
+		client->dev.platform_data;
+	struct adp8870_bl *data = i2c_get_clientdata(client);
+	int i;
+
+	for (i = 0; i < pdata->num_leds; i++) {
+		led_classdev_unregister(&data->led[i].cdev);
+		cancel_work_sync(&data->led[i].work);
+	}
+
+	kfree(data->led);
+	return 0;
+}
+#else
+static int __devinit adp8870_led_probe(struct i2c_client *client)
+{
+	return 0;
+}
+
+static int __devexit adp8870_led_remove(struct i2c_client *client)
+{
+	return 0;
+}
+#endif
+
+static int adp8870_bl_set(struct backlight_device *bl, int brightness)
+{
+	struct adp8870_bl *data = bl_get_data(bl);
+	struct i2c_client *client = data->client;
+	int ret = 0;
+
+	if (data->pdata->en_ambl_sens) {
+		if ((brightness > 0) && (brightness < ADP8870_MAX_BRIGHTNESS)) {
+			/* Disable Ambient Light auto adjust */
+			ret |= adp8870_clr_bits(client, ADP8870_MDCR,
+					CMP_AUTOEN);
+			ret |= adp8870_write(client, ADP8870_BLMX1, brightness);
+		} else {
+			/*
+			 * MAX_BRIGHTNESS -> Enable Ambient Light auto adjust
+			 * restore daylight l1 sysfs brightness
+			 */
+			ret |= adp8870_write(client, ADP8870_BLMX1,
+					 data->cached_daylight_max);
+			ret |= adp8870_set_bits(client, ADP8870_MDCR,
+					 CMP_AUTOEN);
+		}
+	} else
+		ret |= adp8870_write(client, ADP8870_BLMX1, brightness);
+
+	if (data->current_brightness && brightness == 0)
+		ret |= adp8870_set_bits(client,
+				ADP8870_MDCR, DIM_EN);
+	else if (data->current_brightness == 0 && brightness)
+		ret |= adp8870_clr_bits(client,
+				ADP8870_MDCR, DIM_EN);
+
+	if (!ret)
+		data->current_brightness = brightness;
+
+	return ret;
+}
+
+static int adp8870_bl_update_status(struct backlight_device *bl)
+{
+	int brightness = bl->props.brightness;
+	if (bl->props.power != FB_BLANK_UNBLANK)
+		brightness = 0;
+
+	if (bl->props.fb_blank != FB_BLANK_UNBLANK)
+		brightness = 0;
+
+	return adp8870_bl_set(bl, brightness);
+}
+
+static int adp8870_bl_get_brightness(struct backlight_device *bl)
+{
+	struct adp8870_bl *data = bl_get_data(bl);
+
+	return data->current_brightness;
+}
+
+static const struct backlight_ops adp8870_bl_ops = {
+	.update_status	= adp8870_bl_update_status,
+	.get_brightness	= adp8870_bl_get_brightness,
+};
+
+static int adp8870_bl_setup(struct backlight_device *bl)
+{
+	struct adp8870_bl *data = bl_get_data(bl);
+	struct i2c_client *client = data->client;
+	struct adp8870_backlight_platform_data *pdata = data->pdata;
+	int ret = 0;
+
+	ret |= adp8870_write(client, ADP8870_BLSEL, ~pdata->bl_led_assign);
+	ret |= adp8870_write(client, ADP8870_PWMLED, pdata->pwm_assign);
+	ret |= adp8870_write(client, ADP8870_BLMX1, pdata->l1_daylight_max);
+	ret |= adp8870_write(client, ADP8870_BLDM1, pdata->l1_daylight_dim);
+
+	if (pdata->en_ambl_sens) {
+		data->cached_daylight_max = pdata->l1_daylight_max;
+		ret |= adp8870_write(client, ADP8870_BLMX2,
+						pdata->l2_bright_max);
+		ret |= adp8870_write(client, ADP8870_BLDM2,
+						pdata->l2_bright_dim);
+		ret |= adp8870_write(client, ADP8870_BLMX3,
+						pdata->l3_office_max);
+		ret |= adp8870_write(client, ADP8870_BLDM3,
+						pdata->l3_office_dim);
+		ret |= adp8870_write(client, ADP8870_BLMX4,
+						pdata->l4_indoor_max);
+		ret |= adp8870_write(client, ADP8870_BLDM4,
+						pdata->l4_indor_dim);
+		ret |= adp8870_write(client, ADP8870_BLMX5,
+						pdata->l5_dark_max);
+		ret |= adp8870_write(client, ADP8870_BLDM5,
+						pdata->l5_dark_dim);
+
+		ret |= adp8870_write(client, ADP8870_L2TRP, pdata->l2_trip);
+		ret |= adp8870_write(client, ADP8870_L2HYS, pdata->l2_hyst);
+		ret |= adp8870_write(client, ADP8870_L3TRP, pdata->l3_trip);
+		ret |= adp8870_write(client, ADP8870_L3HYS, pdata->l3_hyst);
+		ret |= adp8870_write(client, ADP8870_L4TRP, pdata->l4_trip);
+		ret |= adp8870_write(client, ADP8870_L4HYS, pdata->l4_hyst);
+		ret |= adp8870_write(client, ADP8870_L5TRP, pdata->l5_trip);
+		ret |= adp8870_write(client, ADP8870_L5HYS, pdata->l5_hyst);
+		ret |= adp8870_write(client, ADP8870_ALS1_EN, L5_EN | L4_EN |
+						L3_EN | L2_EN);
+
+		ret |= adp8870_write(client, ADP8870_CMP_CTL,
+			ALS_CMPR_CFG_VAL(pdata->abml_filt));
+
+	}
+
+	ret |= adp8870_write(client, ADP8870_CFGR,
+			BL_CFGR_VAL(pdata->bl_fade_law, 0));
+
+	ret |= adp8870_write(client, ADP8870_BLFR, FADE_VAL(pdata->bl_fade_in,
+			pdata->bl_fade_out));
+
+	/*
+	 * ADP8870 Rev0 requires GDWN_DIS bit set
+	 */
+
+	ret |= adp8870_set_bits(client, ADP8870_MDCR, BLEN | DIM_EN | NSTBY |
+			(data->revid == 0 ? GDWN_DIS : 0));
+
+	return ret;
+}
+
+static ssize_t adp8870_show(struct device *dev, char *buf, int reg)
+{
+	struct adp8870_bl *data = dev_get_drvdata(dev);
+	int error;
+	uint8_t reg_val;
+
+	mutex_lock(&data->lock);
+	error = adp8870_read(data->client, reg, &reg_val);
+	mutex_unlock(&data->lock);
+
+	if (error < 0)
+		return error;
+
+	return sprintf(buf, "%u\n", reg_val);
+}
+
+static ssize_t adp8870_store(struct device *dev, const char *buf,
+			 size_t count, int reg)
+{
+	struct adp8870_bl *data = dev_get_drvdata(dev);
+	unsigned long val;
+	int ret;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	mutex_lock(&data->lock);
+	adp8870_write(data->client, reg, val);
+	mutex_unlock(&data->lock);
+
+	return count;
+}
+
+static ssize_t adp8870_bl_l5_dark_max_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return adp8870_show(dev, buf, ADP8870_BLMX5);
+}
+
+static ssize_t adp8870_bl_l5_dark_max_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	return adp8870_store(dev, buf, count, ADP8870_BLMX5);
+}
+static DEVICE_ATTR(l5_dark_max, 0664, adp8870_bl_l5_dark_max_show,
+			adp8870_bl_l5_dark_max_store);
+
+
+static ssize_t adp8870_bl_l4_indoor_max_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return adp8870_show(dev, buf, ADP8870_BLMX4);
+}
+
+static ssize_t adp8870_bl_l4_indoor_max_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	return adp8870_store(dev, buf, count, ADP8870_BLMX4);
+}
+static DEVICE_ATTR(l4_indoor_max, 0664, adp8870_bl_l4_indoor_max_show,
+			adp8870_bl_l4_indoor_max_store);
+
+
+static ssize_t adp8870_bl_l3_office_max_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	return adp8870_show(dev, buf, ADP8870_BLMX3);
+}
+
+static ssize_t adp8870_bl_l3_office_max_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	return adp8870_store(dev, buf, count, ADP8870_BLMX3);
+}
+
+static DEVICE_ATTR(l3_office_max, 0664, adp8870_bl_l3_office_max_show,
+			adp8870_bl_l3_office_max_store);
+
+static ssize_t adp8870_bl_l2_bright_max_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return adp8870_show(dev, buf, ADP8870_BLMX2);
+}
+
+static ssize_t adp8870_bl_l2_bright_max_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	return adp8870_store(dev, buf, count, ADP8870_BLMX2);
+}
+static DEVICE_ATTR(l2_bright_max, 0664, adp8870_bl_l2_bright_max_show,
+			adp8870_bl_l2_bright_max_store);
+
+static ssize_t adp8870_bl_l1_daylight_max_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	return adp8870_show(dev, buf, ADP8870_BLMX1);
+}
+
+static ssize_t adp8870_bl_l1_daylight_max_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct adp8870_bl *data = dev_get_drvdata(dev);
+	int ret = strict_strtoul(buf, 10, &data->cached_daylight_max);
+	if (ret)
+		return ret;
+
+	return adp8870_store(dev, buf, count, ADP8870_BLMX1);
+}
+static DEVICE_ATTR(l1_daylight_max, 0664, adp8870_bl_l1_daylight_max_show,
+			adp8870_bl_l1_daylight_max_store);
+
+static ssize_t adp8870_bl_l5_dark_dim_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	return adp8870_show(dev, buf, ADP8870_BLDM5);
+}
+
+static ssize_t adp8870_bl_l5_dark_dim_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	return adp8870_store(dev, buf, count, ADP8870_BLDM5);
+}
+static DEVICE_ATTR(l5_dark_dim, 0664, adp8870_bl_l5_dark_dim_show,
+			adp8870_bl_l5_dark_dim_store);
+
+static ssize_t adp8870_bl_l4_indoor_dim_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	return adp8870_show(dev, buf, ADP8870_BLDM4);
+}
+
+static ssize_t adp8870_bl_l4_indoor_dim_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	return adp8870_store(dev, buf, count, ADP8870_BLDM4);
+}
+static DEVICE_ATTR(l4_indoor_dim, 0664, adp8870_bl_l4_indoor_dim_show,
+			adp8870_bl_l4_indoor_dim_store);
+
+
+static ssize_t adp8870_bl_l3_office_dim_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	return adp8870_show(dev, buf, ADP8870_BLDM3);
+}
+
+static ssize_t adp8870_bl_l3_office_dim_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	return adp8870_store(dev, buf, count, ADP8870_BLDM3);
+}
+static DEVICE_ATTR(l3_office_dim, 0664, adp8870_bl_l3_office_dim_show,
+			adp8870_bl_l3_office_dim_store);
+
+static ssize_t adp8870_bl_l2_bright_dim_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	return adp8870_show(dev, buf, ADP8870_BLDM2);
+}
+
+static ssize_t adp8870_bl_l2_bright_dim_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	return adp8870_store(dev, buf, count, ADP8870_BLDM2);
+}
+static DEVICE_ATTR(l2_bright_dim, 0664, adp8870_bl_l2_bright_dim_show,
+			adp8870_bl_l2_bright_dim_store);
+
+static ssize_t adp8870_bl_l1_daylight_dim_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	return adp8870_show(dev, buf, ADP8870_BLDM1);
+}
+
+static ssize_t adp8870_bl_l1_daylight_dim_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	return adp8870_store(dev, buf, count, ADP8870_BLDM1);
+}
+static DEVICE_ATTR(l1_daylight_dim, 0664, adp8870_bl_l1_daylight_dim_show,
+			adp8870_bl_l1_daylight_dim_store);
+
+#ifdef ADP8870_EXT_FEATURES
+static ssize_t adp8870_bl_ambient_light_level_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct adp8870_bl *data = dev_get_drvdata(dev);
+	int error;
+	uint8_t reg_val;
+	uint16_t ret_val;
+
+	mutex_lock(&data->lock);
+	error = adp8870_read(data->client, ADP8870_PH1LEVL, &reg_val);
+	ret_val = reg_val;
+	error |= adp8870_read(data->client, ADP8870_PH1LEVH, &reg_val);
+	mutex_unlock(&data->lock);
+
+	if (error < 0)
+		return error;
+
+	/* Return 13-bit conversion value for the first light sensor */
+	ret_val += (reg_val & 0x1F) << 8;
+
+	return sprintf(buf, "%u\n", ret_val);
+}
+static DEVICE_ATTR(ambient_light_level, 0444,
+		adp8870_bl_ambient_light_level_show, NULL);
+
+static ssize_t adp8870_bl_ambient_light_zone_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct adp8870_bl *data = dev_get_drvdata(dev);
+	int error;
+	uint8_t reg_val;
+
+	mutex_lock(&data->lock);
+	error = adp8870_read(data->client, ADP8870_CFGR, &reg_val);
+	mutex_unlock(&data->lock);
+
+	if (error < 0)
+		return error;
+
+	return sprintf(buf, "%u\n",
+		((reg_val >> CFGR_BLV_SHIFT) & CFGR_BLV_MASK) + 1);
+}
+
+static ssize_t adp8870_bl_ambient_light_zone_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct adp8870_bl *data = dev_get_drvdata(dev);
+	unsigned long val;
+	uint8_t reg_val;
+	int ret;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	if (val == 0) {
+		/* Enable automatic ambient light sensing */
+		adp8870_set_bits(data->client, ADP8870_MDCR, CMP_AUTOEN);
+	} else if ((val > 0) && (val < 6)) {
+		/* Disable automatic ambient light sensing */
+		adp8870_clr_bits(data->client, ADP8870_MDCR, CMP_AUTOEN);
+
+		/* Set user supplied ambient light zone */
+		mutex_lock(&data->lock);
+		adp8870_read(data->client, ADP8870_CFGR, &reg_val);
+		reg_val &= ~(CFGR_BLV_MASK << CFGR_BLV_SHIFT);
+		reg_val |= (val - 1) << CFGR_BLV_SHIFT;
+		adp8870_write(data->client, ADP8870_CFGR, reg_val);
+		mutex_unlock(&data->lock);
+	}
+
+	return count;
+}
+static DEVICE_ATTR(ambient_light_zone, 0664,
+		adp8870_bl_ambient_light_zone_show,
+		adp8870_bl_ambient_light_zone_store);
+#endif
+
+static struct attribute *adp8870_bl_attributes[] = {
+	&dev_attr_l5_dark_max.attr,
+	&dev_attr_l5_dark_dim.attr,
+	&dev_attr_l4_indoor_max.attr,
+	&dev_attr_l4_indoor_dim.attr,
+	&dev_attr_l3_office_max.attr,
+	&dev_attr_l3_office_dim.attr,
+	&dev_attr_l2_bright_max.attr,
+	&dev_attr_l2_bright_dim.attr,
+	&dev_attr_l1_daylight_max.attr,
+	&dev_attr_l1_daylight_dim.attr,
+#ifdef ADP8870_EXT_FEATURES
+	&dev_attr_ambient_light_level.attr,
+	&dev_attr_ambient_light_zone.attr,
+#endif
+	NULL
+};
+
+static const struct attribute_group adp8870_bl_attr_group = {
+	.attrs = adp8870_bl_attributes,
+};
+
+static int __devinit adp8870_probe(struct i2c_client *client,
+					const struct i2c_device_id *id)
+{
+	struct backlight_properties props;
+	struct backlight_device *bl;
+	struct adp8870_bl *data;
+	struct adp8870_backlight_platform_data *pdata =
+		client->dev.platform_data;
+	uint8_t reg_val;
+	int ret;
+
+	if (!i2c_check_functionality(client->adapter,
+					I2C_FUNC_SMBUS_BYTE_DATA)) {
+		dev_err(&client->dev, "SMBUS Byte Data not Supported\n");
+		return -EIO;
+	}
+
+	if (!pdata) {
+		dev_err(&client->dev, "no platform data?\n");
+		return -EINVAL;
+	}
+
+	ret = adp8870_read(client, ADP8870_MFDVID, &reg_val);
+	if (ret < 0)
+		return -EIO;
+
+	if (ADP8870_MANID(reg_val) != ADP8870_MANUFID) {
+		dev_err(&client->dev, "failed to probe\n");
+		return -ENODEV;
+	}
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	data->revid = ADP8870_DEVID(reg_val);
+	data->client = client;
+	data->pdata = pdata;
+	data->id = id->driver_data;
+	data->current_brightness = 0;
+	i2c_set_clientdata(client, data);
+
+	mutex_init(&data->lock);
+
+	memset(&props, 0, sizeof(props));
+	props.max_brightness = props.brightness = ADP8870_MAX_BRIGHTNESS;
+	bl = backlight_device_register(dev_driver_string(&client->dev),
+			&client->dev, data, &adp8870_bl_ops, &props);
+	if (IS_ERR(bl)) {
+		dev_err(&client->dev, "failed to register backlight\n");
+		ret = PTR_ERR(bl);
+		goto out2;
+	}
+
+	data->bl = bl;
+
+	if (pdata->en_ambl_sens)
+		ret = sysfs_create_group(&bl->dev.kobj,
+			&adp8870_bl_attr_group);
+
+	if (ret) {
+		dev_err(&client->dev, "failed to register sysfs\n");
+		goto out1;
+	}
+
+	ret = adp8870_bl_setup(bl);
+	if (ret) {
+		ret = -EIO;
+		goto out;
+	}
+
+	backlight_update_status(bl);
+
+	dev_info(&client->dev, "Rev.%d Backlight\n", data->revid);
+
+	if (pdata->num_leds)
+		adp8870_led_probe(client);
+
+	return 0;
+
+out:
+	if (data->pdata->en_ambl_sens)
+		sysfs_remove_group(&data->bl->dev.kobj,
+			&adp8870_bl_attr_group);
+out1:
+	backlight_device_unregister(bl);
+out2:
+	i2c_set_clientdata(client, NULL);
+	kfree(data);
+
+	return ret;
+}
+
+static int __devexit adp8870_remove(struct i2c_client *client)
+{
+	struct adp8870_bl *data = i2c_get_clientdata(client);
+
+	adp8870_clr_bits(client, ADP8870_MDCR, NSTBY);
+
+	if (data->led)
+		adp8870_led_remove(client);
+
+	if (data->pdata->en_ambl_sens)
+		sysfs_remove_group(&data->bl->dev.kobj,
+			&adp8870_bl_attr_group);
+
+	backlight_device_unregister(data->bl);
+	i2c_set_clientdata(client, NULL);
+	kfree(data);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int adp8870_i2c_suspend(struct i2c_client *client, pm_message_t message)
+{
+	adp8870_clr_bits(client, ADP8870_MDCR, NSTBY);
+
+	return 0;
+}
+
+static int adp8870_i2c_resume(struct i2c_client *client)
+{
+	adp8870_set_bits(client, ADP8870_MDCR, NSTBY);
+
+	return 0;
+}
+#else
+#define adp8870_i2c_suspend NULL
+#define adp8870_i2c_resume NULL
+#endif
+
+static const struct i2c_device_id adp8870_id[] = {
+	{ "adp8870", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, adp8870_id);
+
+static struct i2c_driver adp8870_driver = {
+	.driver = {
+		.name = KBUILD_MODNAME,
+	},
+	.probe    = adp8870_probe,
+	.remove   = __devexit_p(adp8870_remove),
+	.suspend = adp8870_i2c_suspend,
+	.resume  = adp8870_i2c_resume,
+	.id_table = adp8870_id,
+};
+
+static int __init adp8870_init(void)
+{
+	return i2c_add_driver(&adp8870_driver);
+}
+module_init(adp8870_init);
+
+static void __exit adp8870_exit(void)
+{
+	i2c_del_driver(&adp8870_driver);
+}
+module_exit(adp8870_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
+MODULE_DESCRIPTION("ADP8870 Backlight driver");
+MODULE_ALIAS("platform:adp8870-backlight");
diff -puN /dev/null include/linux/i2c/adp8870.h
--- /dev/null
+++ a/include/linux/i2c/adp8870.h
@@ -0,0 +1,153 @@
+/*
+ * Definitions and platform data for Analog Devices
+ * Backlight drivers ADP8870
+ *
+ * Copyright 2009-2010 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#ifndef __LINUX_I2C_ADP8870_H
+#define __LINUX_I2C_ADP8870_H
+
+#define ID_ADP8870		8870
+
+#define ADP8870_MAX_BRIGHTNESS	0x7F
+#define FLAG_OFFT_SHIFT 8
+
+/*
+ * LEDs subdevice platform data
+ */
+
+#define ADP8870_LED_DIS_BLINK	(0 << FLAG_OFFT_SHIFT)
+#define ADP8870_LED_OFFT_600ms	(1 << FLAG_OFFT_SHIFT)
+#define ADP8870_LED_OFFT_1200ms	(2 << FLAG_OFFT_SHIFT)
+#define ADP8870_LED_OFFT_1800ms	(3 << FLAG_OFFT_SHIFT)
+
+#define ADP8870_LED_ONT_200ms	0
+#define ADP8870_LED_ONT_600ms	1
+#define ADP8870_LED_ONT_800ms	2
+#define ADP8870_LED_ONT_1200ms	3
+
+#define ADP8870_LED_D7		(7)
+#define ADP8870_LED_D6		(6)
+#define ADP8870_LED_D5		(5)
+#define ADP8870_LED_D4		(4)
+#define ADP8870_LED_D3		(3)
+#define ADP8870_LED_D2		(2)
+#define ADP8870_LED_D1		(1)
+
+/*
+ * Backlight subdevice platform data
+ */
+
+#define ADP8870_BL_D7		(1 << 6)
+#define ADP8870_BL_D6		(1 << 5)
+#define ADP8870_BL_D5		(1 << 4)
+#define ADP8870_BL_D4		(1 << 3)
+#define ADP8870_BL_D3		(1 << 2)
+#define ADP8870_BL_D2		(1 << 1)
+#define ADP8870_BL_D1		(1 << 0)
+
+#define ADP8870_FADE_T_DIS	0	/* Fade Timer Disabled */
+#define ADP8870_FADE_T_300ms	1	/* 0.3 Sec */
+#define ADP8870_FADE_T_600ms	2
+#define ADP8870_FADE_T_900ms	3
+#define ADP8870_FADE_T_1200ms	4
+#define ADP8870_FADE_T_1500ms	5
+#define ADP8870_FADE_T_1800ms	6
+#define ADP8870_FADE_T_2100ms	7
+#define ADP8870_FADE_T_2400ms	8
+#define ADP8870_FADE_T_2700ms	9
+#define ADP8870_FADE_T_3000ms	10
+#define ADP8870_FADE_T_3500ms	11
+#define ADP8870_FADE_T_4000ms	12
+#define ADP8870_FADE_T_4500ms	13
+#define ADP8870_FADE_T_5000ms	14
+#define ADP8870_FADE_T_5500ms	15	/* 5.5 Sec */
+
+#define ADP8870_FADE_LAW_LINEAR	0
+#define ADP8870_FADE_LAW_SQUARE	1
+#define ADP8870_FADE_LAW_CUBIC1	2
+#define ADP8870_FADE_LAW_CUBIC2	3
+
+#define ADP8870_BL_AMBL_FILT_80ms	0	/* Light sensor filter time */
+#define ADP8870_BL_AMBL_FILT_160ms	1
+#define ADP8870_BL_AMBL_FILT_320ms	2
+#define ADP8870_BL_AMBL_FILT_640ms	3
+#define ADP8870_BL_AMBL_FILT_1280ms	4
+#define ADP8870_BL_AMBL_FILT_2560ms	5
+#define ADP8870_BL_AMBL_FILT_5120ms	6
+#define ADP8870_BL_AMBL_FILT_10240ms	7	/* 10.24 sec */
+
+/*
+ * Blacklight current 0..30mA
+ */
+#define ADP8870_BL_CUR_mA(I)		((I * 127) / 30)
+
+/*
+ * L2 comparator current 0..1106uA
+ */
+#define ADP8870_L2_COMP_CURR_uA(I)	((I * 255) / 1106)
+
+/*
+ * L3 comparator current 0..551uA
+ */
+#define ADP8870_L3_COMP_CURR_uA(I)	((I * 255) / 551)
+
+/*
+ * L4 comparator current 0..275uA
+ */
+#define ADP8870_L4_COMP_CURR_uA(I)	((I * 255) / 275)
+
+/*
+ * L5 comparator current 0..138uA
+ */
+#define ADP8870_L5_COMP_CURR_uA(I)	((I * 255) / 138)
+
+struct adp8870_backlight_platform_data {
+	u8 bl_led_assign;	/* 1 = Backlight 0 = Individual LED */
+	u8 pwm_assign;		/* 1 = Enables PWM mode */
+
+	u8 bl_fade_in;		/* Backlight Fade-In Timer */
+	u8 bl_fade_out;		/* Backlight Fade-Out Timer */
+	u8 bl_fade_law;		/* fade-on/fade-off transfer characteristic */
+
+	u8 en_ambl_sens;	/* 1 = enable ambient light sensor */
+	u8 abml_filt;		/* Light sensor filter time */
+
+	u8 l1_daylight_max;	/* use BL_CUR_mA(I) 0 <= I <= 30 mA */
+	u8 l1_daylight_dim;	/* typ = 0, use BL_CUR_mA(I) 0 <= I <= 30 mA */
+	u8 l2_bright_max;	/* use BL_CUR_mA(I) 0 <= I <= 30 mA */
+	u8 l2_bright_dim;	/* typ = 0, use BL_CUR_mA(I) 0 <= I <= 30 mA */
+	u8 l3_office_max;	/* use BL_CUR_mA(I) 0 <= I <= 30 mA */
+	u8 l3_office_dim;	/* typ = 0, use BL_CUR_mA(I) 0 <= I <= 30 mA */
+	u8 l4_indoor_max;	/* use BL_CUR_mA(I) 0 <= I <= 30 mA */
+	u8 l4_indor_dim;	/* typ = 0, use BL_CUR_mA(I) 0 <= I <= 30 mA */
+	u8 l5_dark_max;		/* use BL_CUR_mA(I) 0 <= I <= 30 mA */
+	u8 l5_dark_dim;		/* typ = 0, use BL_CUR_mA(I) 0 <= I <= 30 mA */
+
+	u8 l2_trip;		/* use L2_COMP_CURR_uA(I) 0 <= I <= 1106 uA */
+	u8 l2_hyst;		/* use L2_COMP_CURR_uA(I) 0 <= I <= 1106 uA */
+	u8 l3_trip;		/* use L3_COMP_CURR_uA(I) 0 <= I <= 551 uA */
+	u8 l3_hyst;		/* use L3_COMP_CURR_uA(I) 0 <= I <= 551 uA */
+	u8 l4_trip;		/* use L4_COMP_CURR_uA(I) 0 <= I <= 275 uA */
+	u8 l4_hyst;		/* use L4_COMP_CURR_uA(I) 0 <= I <= 275 uA */
+	u8 l5_trip;		/* use L5_COMP_CURR_uA(I) 0 <= I <= 138 uA */
+	u8 l5_hyst;		/* use L6_COMP_CURR_uA(I) 0 <= I <= 138 uA */
+
+	/**
+	 * Independent Current Sinks / LEDS
+	 * Sinks not assigned to the Backlight can be exposed to
+	 * user space using the LEDS CLASS interface
+	 */
+
+	int num_leds;
+	struct led_info	*leds;
+	u8 led_fade_in;		/* LED Fade-In Timer */
+	u8 led_fade_out;	/* LED Fade-Out Timer */
+	u8 led_fade_law;	/* fade-on/fade-off transfer characteristic */
+	u8 led_on_time;
+};
+
+#endif /* __LINUX_I2C_ADP8870_H */
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

backlight-new-driver-for-the-adp8870-backlight-devices.patch

