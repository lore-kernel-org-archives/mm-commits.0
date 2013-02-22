From: akpm@linux-foundation.org
Subject: [merged] backlight-lp855x_bl-support-new-lp8557-device.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:42:27 -0800
Message-ID: <20130222204227.C7F3C5A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:48757 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab3BVUm2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:42:28 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so119633qah.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:42:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Milo.Kim@ti.com, jg1.han@samsung.com, milo.kim@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: lp855x_bl: support new LP8557 device
has been removed from the -mm tree.  Its filename was
     backlight-lp855x_bl-support-new-lp8557-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: backlight: lp855x_bl: support new LP8557 device

LP8557 is one of LP855x family device, but it has different register map
and initialization process.  To support this device, device specific
configuration is done through the lp855x_device_config structure.

Few register definitions are fixed for better readability.
  BRIGHTNESS_CTRL -> LP855X_BRIGHTNESS_CTRL
  DEVICE_CTRL     -> LP855X_DEVICE_CTRL
  EEPROM_START    -> LP855X_EEPROM_START
  EEPROM_END      -> LP855X_EEPROM_END
  EPROM_START     -> LP8556_EPROM_START
  EPROM_END       -> LP8556_EPROM_END

And LP8557 register definitions are added.  New register function,
lp855x_update_bit() is added.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/backlight/lp855x-driver.txt |    4 
 drivers/video/backlight/Kconfig           |    2 
 drivers/video/backlight/lp855x_bl.c       |   87 ++++++++++++++++----
 include/linux/platform_data/lp855x.h      |   19 ++++
 4 files changed, 94 insertions(+), 18 deletions(-)

diff -puN Documentation/backlight/lp855x-driver.txt~backlight-lp855x_bl-support-new-lp8557-device Documentation/backlight/lp855x-driver.txt
--- a/Documentation/backlight/lp855x-driver.txt~backlight-lp855x_bl-support-new-lp8557-device
+++ a/Documentation/backlight/lp855x-driver.txt
@@ -4,7 +4,7 @@ Kernel driver lp855x
 Backlight driver for LP855x ICs
 
 Supported chips:
-	Texas Instruments LP8550, LP8551, LP8552, LP8553 and LP8556
+	Texas Instruments LP8550, LP8551, LP8552, LP8553, LP8556 and LP8557
 
 Author: Milo(Woogyom) Kim <milo.kim@ti.com>
 
@@ -24,7 +24,7 @@ Value : pwm based or register based
 
 2) chip_id
 The lp855x chip id.
-Value : lp8550/lp8551/lp8552/lp8553/lp8556
+Value : lp8550/lp8551/lp8552/lp8553/lp8556/lp8557
 
 Platform data for lp855x
 ------------------------
diff -puN drivers/video/backlight/Kconfig~backlight-lp855x_bl-support-new-lp8557-device drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~backlight-lp855x_bl-support-new-lp8557-device
+++ a/drivers/video/backlight/Kconfig
@@ -381,7 +381,7 @@ config BACKLIGHT_LP855X
 	tristate "Backlight driver for TI LP855X"
 	depends on BACKLIGHT_CLASS_DEVICE && I2C
 	help
-	  This supports TI LP8550, LP8551, LP8552, LP8553 and LP8556
+	  This supports TI LP8550, LP8551, LP8552, LP8553, LP8556 and LP8557
 	  backlight driver.
 
 config BACKLIGHT_OT200
diff -puN drivers/video/backlight/lp855x_bl.c~backlight-lp855x_bl-support-new-lp8557-device drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~backlight-lp855x_bl-support-new-lp8557-device
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -17,13 +17,23 @@
 #include <linux/platform_data/lp855x.h>
 #include <linux/pwm.h>
 
-/* Registers */
-#define BRIGHTNESS_CTRL		0x00
-#define DEVICE_CTRL		0x01
-#define EEPROM_START		0xA0
-#define EEPROM_END		0xA7
-#define EPROM_START		0xA0
-#define EPROM_END		0xAF
+/* LP8550/1/2/3/6 Registers */
+#define LP855X_BRIGHTNESS_CTRL		0x00
+#define LP855X_DEVICE_CTRL		0x01
+#define LP855X_EEPROM_START		0xA0
+#define LP855X_EEPROM_END		0xA7
+#define LP8556_EPROM_START		0xA0
+#define LP8556_EPROM_END		0xAF
+
+/* LP8557 Registers */
+#define LP8557_BL_CMD			0x00
+#define LP8557_BL_MASK			0x01
+#define LP8557_BL_ON			0x01
+#define LP8557_BL_OFF			0x00
+#define LP8557_BRIGHTNESS_CTRL		0x04
+#define LP8557_CONFIG			0x10
+#define LP8557_EPROM_START		0x10
+#define LP8557_EPROM_END		0x1E
 
 #define BUF_SIZE		20
 #define DEFAULT_BL_NAME		"lcd-backlight"
@@ -75,6 +85,24 @@ static int lp855x_write_byte(struct lp85
 	return i2c_smbus_write_byte_data(lp->client, reg, data);
 }
 
+static int lp855x_update_bit(struct lp855x *lp, u8 reg, u8 mask, u8 data)
+{
+	int ret;
+	u8 tmp;
+
+	ret = i2c_smbus_read_byte_data(lp->client, reg);
+	if (ret < 0) {
+		dev_err(lp->dev, "failed to read 0x%.2x\n", reg);
+		return ret;
+	}
+
+	tmp = (u8)ret;
+	tmp &= ~mask;
+	tmp |= data & mask;
+
+	return lp855x_write_byte(lp, reg, tmp);
+}
+
 static bool lp855x_is_valid_rom_area(struct lp855x *lp, u8 addr)
 {
 	u8 start, end;
@@ -84,12 +112,16 @@ static bool lp855x_is_valid_rom_area(str
 	case LP8551:
 	case LP8552:
 	case LP8553:
-		start = EEPROM_START;
-		end = EEPROM_END;
+		start = LP855X_EEPROM_START;
+		end = LP855X_EEPROM_END;
 		break;
 	case LP8556:
-		start = EPROM_START;
-		end = EPROM_END;
+		start = LP8556_EPROM_START;
+		end = LP8556_EPROM_END;
+		break;
+	case LP8557:
+		start = LP8557_EPROM_START;
+		end = LP8557_EPROM_END;
 		break;
 	default:
 		return false;
@@ -98,9 +130,30 @@ static bool lp855x_is_valid_rom_area(str
 	return (addr >= start && addr <= end);
 }
 
+static int lp8557_bl_off(struct lp855x *lp)
+{
+	/* BL_ON = 0 before updating EPROM settings */
+	return lp855x_update_bit(lp, LP8557_BL_CMD, LP8557_BL_MASK,
+				LP8557_BL_OFF);
+}
+
+static int lp8557_bl_on(struct lp855x *lp)
+{
+	/* BL_ON = 1 after updating EPROM settings */
+	return lp855x_update_bit(lp, LP8557_BL_CMD, LP8557_BL_MASK,
+				LP8557_BL_ON);
+}
+
 static struct lp855x_device_config lp855x_dev_cfg = {
-	.reg_brightness = BRIGHTNESS_CTRL,
-	.reg_devicectrl = DEVICE_CTRL,
+	.reg_brightness = LP855X_BRIGHTNESS_CTRL,
+	.reg_devicectrl = LP855X_DEVICE_CTRL,
+};
+
+static struct lp855x_device_config lp8557_dev_cfg = {
+	.reg_brightness = LP8557_BRIGHTNESS_CTRL,
+	.reg_devicectrl = LP8557_CONFIG,
+	.pre_init_device = lp8557_bl_off,
+	.post_init_device = lp8557_bl_on,
 };
 
 /*
@@ -123,6 +176,9 @@ static int lp855x_configure(struct lp855
 	case LP8550 ... LP8556:
 		lp->cfg = &lp855x_dev_cfg;
 		break;
+	case LP8557:
+		lp->cfg = &lp8557_dev_cfg;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -210,7 +266,7 @@ static int lp855x_bl_update_status(struc
 
 	} else if (mode == REGISTER_BASED) {
 		u8 val = bl->props.brightness;
-		lp855x_write_byte(lp, BRIGHTNESS_CTRL, val);
+		lp855x_write_byte(lp, lp->cfg->reg_brightness, val);
 	}
 
 	return 0;
@@ -224,7 +280,7 @@ static int lp855x_bl_get_brightness(stru
 	if (mode == REGISTER_BASED) {
 		u8 val = 0;
 
-		lp855x_read_byte(lp, BRIGHTNESS_CTRL, &val);
+		lp855x_read_byte(lp, lp->cfg->reg_brightness, &val);
 		bl->props.brightness = val;
 	}
 
@@ -376,6 +432,7 @@ static const struct i2c_device_id lp855x
 	{"lp8552", LP8552},
 	{"lp8553", LP8553},
 	{"lp8556", LP8556},
+	{"lp8557", LP8557},
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, lp855x_ids);
diff -puN include/linux/platform_data/lp855x.h~backlight-lp855x_bl-support-new-lp8557-device include/linux/platform_data/lp855x.h
--- a/include/linux/platform_data/lp855x.h~backlight-lp855x_bl-support-new-lp8557-device
+++ a/include/linux/platform_data/lp855x.h
@@ -49,12 +49,24 @@
 #define LP8556_FAST_CONFIG	BIT(7) /* use it if EPROMs should be maintained
 					  when exiting the low power mode */
 
+/* CONFIG register - LP8557 */
+#define LP8557_PWM_STANDBY	BIT(7)
+#define LP8557_PWM_FILTER	BIT(6)
+#define LP8557_RELOAD_EPROM	BIT(3)	/* use it if EPROMs should be reset
+					   when the backlight turns on */
+#define LP8557_OFF_OPENLEDS	BIT(2)
+#define LP8557_PWM_CONFIG	LP8557_PWM_ONLY
+#define LP8557_I2C_CONFIG	LP8557_I2C_ONLY
+#define LP8557_COMB1_CONFIG	LP8557_COMBINED1
+#define LP8557_COMB2_CONFIG	LP8557_COMBINED2
+
 enum lp855x_chip_id {
 	LP8550,
 	LP8551,
 	LP8552,
 	LP8553,
 	LP8556,
+	LP8557,
 };
 
 enum lp855x_brightness_ctrl_mode {
@@ -89,6 +101,13 @@ enum lp8556_brightness_source {
 	LP8556_COMBINED2,	/* pwm + i2c after the shaper block */
 };
 
+enum lp8557_brightness_source {
+	LP8557_PWM_ONLY,
+	LP8557_I2C_ONLY,
+	LP8557_COMBINED1,	/* pwm + i2c after the shaper block */
+	LP8557_COMBINED2,	/* pwm + i2c before the shaper block */
+};
+
 struct lp855x_rom_data {
 	u8 addr;
 	u8 val;
_

Patches currently in -mm which might be from Milo.Kim@ti.com are

origin.patch
linux-next.patch
backlight-add-new-lp8788-backlight-driver.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch

