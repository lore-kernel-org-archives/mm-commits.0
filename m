From: akpm@linux-foundation.org
Subject: [merged] backlight-lp855x_bl-introduce-device-configuration-flow.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:42:24 -0800
Message-ID: <20130222204224.C1C3831C265@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:35581 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab3BVUm0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:42:26 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so103965ves.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:42:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Milo.Kim@ti.com, jg1.han@samsung.com, milo.kim@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: lp855x_bl: introduce device configuration flow
has been removed from the -mm tree.  Its filename was
     backlight-lp855x_bl-introduce-device-configuration-flow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: backlight: lp855x_bl: introduce device configuration flow

At this moment, LP855x device driver has fixed register configuration. 
For example, fixed register addresses and values are set on the device
initialization.  But new device of LP855x family, LP8557 has different
register map and initialization sequence.  To support new device
architecture, initialization process should be changed.

 Introduce new structure: lp855x_device_config
 =============================================
 With lp855x_device_config, device specific features are configurable.
 Use configurable function calls and register addresses rather than fixed values.

 Change on device initialization
 ===============================
 In old LP855x driver architecture, the device initialization was simple.
 - Just update the brightness/device control register/ROM area(optional).
 In new LP855x driver architecture, two more works are added - pre_init and
 post_init.
 Those init functions are optional, used for new device LP8557.

 New device initialization flow: generic sequence
 =================================================
 1) pre_init_device()
 2) update the brightness register
 3) update the device control register
 4) update ROM area if need
 5) post_init_device()

 Name change
 ===========
 Use generic name 'lp855x_configure()' instead of 'lp855x_init_registers()'.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lp855x_bl.c |   78 ++++++++++++++++++++++----
 1 file changed, 68 insertions(+), 10 deletions(-)

diff -puN drivers/video/backlight/lp855x_bl.c~backlight-lp855x_bl-introduce-device-configuration-flow drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~backlight-lp855x_bl-introduce-device-configuration-flow
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -29,9 +29,26 @@
 #define DEFAULT_BL_NAME		"lcd-backlight"
 #define MAX_BRIGHTNESS		255
 
+struct lp855x;
+
+/*
+ * struct lp855x_device_config
+ * @pre_init_device: init device function call before updating the brightness
+ * @reg_brightness: register address for brigthenss control
+ * @reg_devicectrl: register address for device control
+ * @post_init_device: late init device function call
+ */
+struct lp855x_device_config {
+	int (*pre_init_device)(struct lp855x *);
+	u8 reg_brightness;
+	u8 reg_devicectrl;
+	int (*post_init_device)(struct lp855x *);
+};
+
 struct lp855x {
 	const char *chipname;
 	enum lp855x_chip_id chip_id;
+	struct lp855x_device_config *cfg;
 	struct i2c_client *client;
 	struct backlight_device *bl;
 	struct device *dev;
@@ -81,21 +98,52 @@ static bool lp855x_is_valid_rom_area(str
 	return (addr >= start && addr <= end);
 }
 
-static int lp855x_init_registers(struct lp855x *lp)
+static struct lp855x_device_config lp855x_dev_cfg = {
+	.reg_brightness = BRIGHTNESS_CTRL,
+	.reg_devicectrl = DEVICE_CTRL,
+};
+
+/*
+ * Device specific configuration flow
+ *
+ *    a) pre_init_device(optional)
+ *    b) update the brightness register
+ *    c) update device control register
+ *    d) update ROM area(optional)
+ *    e) post_init_device(optional)
+ *
+ */
+static int lp855x_configure(struct lp855x *lp)
 {
 	u8 val, addr;
 	int i, ret;
 	struct lp855x_platform_data *pd = lp->pdata;
 
+	switch (lp->chip_id) {
+	case LP8550 ... LP8556:
+		lp->cfg = &lp855x_dev_cfg;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (lp->cfg->pre_init_device) {
+		ret = lp->cfg->pre_init_device(lp);
+		if (ret) {
+			dev_err(lp->dev, "pre init device err: %d\n", ret);
+			goto err;
+		}
+	}
+
 	val = pd->initial_brightness;
-	ret = lp855x_write_byte(lp, BRIGHTNESS_CTRL, val);
+	ret = lp855x_write_byte(lp, lp->cfg->reg_brightness, val);
 	if (ret)
-		return ret;
+		goto err;
 
 	val = pd->device_control;
-	ret = lp855x_write_byte(lp, DEVICE_CTRL, val);
+	ret = lp855x_write_byte(lp, lp->cfg->reg_devicectrl, val);
 	if (ret)
-		return ret;
+		goto err;
 
 	if (pd->load_new_rom_data && pd->size_program) {
 		for (i = 0; i < pd->size_program; i++) {
@@ -106,10 +154,21 @@ static int lp855x_init_registers(struct 
 
 			ret = lp855x_write_byte(lp, addr, val);
 			if (ret)
-				return ret;
+				goto err;
 		}
 	}
 
+	if (lp->cfg->post_init_device) {
+		ret = lp->cfg->post_init_device(lp);
+		if (ret) {
+			dev_err(lp->dev, "post init device err: %d\n", ret);
+			goto err;
+		}
+	}
+
+	return 0;
+
+err:
 	return ret;
 }
 
@@ -271,11 +330,10 @@ static int lp855x_probe(struct i2c_clien
 	lp->chip_id = id->driver_data;
 	i2c_set_clientdata(cl, lp);
 
-	ret = lp855x_init_registers(lp);
+	ret = lp855x_configure(lp);
 	if (ret) {
-		dev_err(lp->dev, "i2c communication err: %d", ret);
-		if (mode == REGISTER_BASED)
-			goto err_dev;
+		dev_err(lp->dev, "device config err: %d", ret);
+		goto err_dev;
 	}
 
 	ret = lp855x_backlight_register(lp);
_

Patches currently in -mm which might be from Milo.Kim@ti.com are

origin.patch
linux-next.patch
backlight-add-new-lp8788-backlight-driver.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch

