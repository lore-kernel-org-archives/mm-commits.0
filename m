From: akpm@linux-foundation.org
Subject: + backlight-lp855x-add-a-device-tree-structure.patch added to -mm tree
Date: Mon, 22 Apr 2013 15:47:22 -0700
Message-ID: <20130422224722.C970531C11E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:52644 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab3DVWrX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 18:47:23 -0400
Received: by mail-qe0-f73.google.com with SMTP id 1so753228qee.4
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 15:47:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Milo.Kim@ti.com, milo.kim@ti.com


The patch titled
     Subject: backlight: lp855x: add a device tree structure
has been added to the -mm tree.  Its filename is
     backlight-lp855x-add-a-device-tree-structure.patch

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
Subject: backlight: lp855x: add a device tree structure

Enable supporting the DT structure of LP855x family devices.  If the
platform data is NULL, the driver tries to parse a DT structure.  Then,
the platform data is copied from the DT.  Documentation is added as well.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/video/backlight/lp855x.txt |   41 +++++
 drivers/video/backlight/lp855x_bl.c                          |   73 +++++++++-
 2 files changed, 112 insertions(+), 2 deletions(-)

diff -puN /dev/null Documentation/devicetree/bindings/video/backlight/lp855x.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/video/backlight/lp855x.txt
@@ -0,0 +1,41 @@
+lp855x bindings
+
+Required properties:
+  - compatible: "ti,lp8550", "ti,lp8551", "ti,lp8552", "ti,lp8553",
+                "ti,lp8556", "ti,lp8557"
+  - reg: I2C slave address (u8)
+  - dev-ctrl: Value of DEVICE CONTROL register (u8). It depends on the device.
+
+Optional properties:
+  - bl-name: Backlight device name (string)
+  - init-brt: Initial value of backlight brightness (u8)
+  - pwm-period: PWM period value. Set only PWM input mode used (u32)
+  - rom-addr: Register address of ROM area to be updated (u8)
+  - rom-val: Register value to be updated (u8)
+
+Example:
+
+	/* LP8556 */
+	backlight@2c {
+		compatible = "ti,lp8556";
+		reg = <0x2c>;
+
+		bl-name = "lcd-bl";
+		dev-ctrl = /bits/ 8 <0x85>;
+		init-brt = /bits/ 8 <0x10>;
+	};
+
+	/* LP8557 */
+	backlight@2c {
+		compatible = "ti,lp8557";
+		reg = <0x2c>;
+
+		dev-ctrl = /bits/ 8 <0x41>;
+		init-brt = /bits/ 8 <0x0a>;
+
+		/* 4V OV, 4 output LED string enabled */
+		rom_14h {
+			rom-addr = /bits/ 8 <0x14>;
+			rom-val = /bits/ 8 <0xcf>;
+		};
+	};
diff -puN drivers/video/backlight/lp855x_bl.c~backlight-lp855x-add-a-device-tree-structure drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~backlight-lp855x-add-a-device-tree-structure
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -14,6 +14,7 @@
 #include <linux/i2c.h>
 #include <linux/backlight.h>
 #include <linux/err.h>
+#include <linux/of.h>
 #include <linux/platform_data/lp855x.h>
 #include <linux/pwm.h>
 
@@ -338,15 +339,71 @@ static const struct attribute_group lp85
 	.attrs = lp855x_attributes,
 };
 
+#ifdef CONFIG_OF
+static int lp855x_parse_dt(struct device *dev, struct device_node *node)
+{
+	struct lp855x_platform_data *pdata;
+	int rom_length;
+
+	if (!node) {
+		dev_err(dev, "no platform data\n");
+		return -EINVAL;
+	}
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+
+	of_property_read_string(node, "bl-name", &pdata->name);
+	of_property_read_u8(node, "dev-ctrl", &pdata->device_control);
+	of_property_read_u8(node, "init-brt", &pdata->initial_brightness);
+	of_property_read_u32(node, "pwm-period", &pdata->period_ns);
+
+	/* Fill ROM platform data if defined */
+	rom_length = of_get_child_count(node);
+	if (rom_length > 0) {
+		struct lp855x_rom_data *rom;
+		struct device_node *child;
+		int i = 0;
+
+		rom = devm_kzalloc(dev, sizeof(*rom) * rom_length, GFP_KERNEL);
+		if (!rom)
+			return -ENOMEM;
+
+		for_each_child_of_node(node, child) {
+			of_property_read_u8(child, "rom-addr", &rom[i].addr);
+			of_property_read_u8(child, "rom-val", &rom[i].val);
+			i++;
+		}
+
+		pdata->size_program = rom_length;
+		pdata->rom_data = &rom[0];
+	}
+
+	dev->platform_data = pdata;
+
+	return 0;
+}
+#else
+static int lp855x_parse_dt(struct device *dev, struct device_node *node)
+{
+	return -EINVAL;
+}
+#endif
+
 static int lp855x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 {
 	struct lp855x *lp;
 	struct lp855x_platform_data *pdata = cl->dev.platform_data;
+	struct device_node *node = cl->dev.of_node;
 	int ret;
 
 	if (!pdata) {
-		dev_err(&cl->dev, "no platform data supplied\n");
-		return -EINVAL;
+		ret = lp855x_parse_dt(&cl->dev, node);
+		if (ret < 0)
+			return ret;
+
+		pdata = cl->dev.platform_data;
 	}
 
 	if (!i2c_check_functionality(cl->adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
@@ -408,6 +465,17 @@ static int lp855x_remove(struct i2c_clie
 	return 0;
 }
 
+static const struct of_device_id lp855x_dt_ids[] = {
+	{ .compatible = "ti,lp8550", },
+	{ .compatible = "ti,lp8551", },
+	{ .compatible = "ti,lp8552", },
+	{ .compatible = "ti,lp8553", },
+	{ .compatible = "ti,lp8556", },
+	{ .compatible = "ti,lp8557", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, lp855x_dt_ids);
+
 static const struct i2c_device_id lp855x_ids[] = {
 	{"lp8550", LP8550},
 	{"lp8551", LP8551},
@@ -422,6 +490,7 @@ MODULE_DEVICE_TABLE(i2c, lp855x_ids);
 static struct i2c_driver lp855x_driver = {
 	.driver = {
 		   .name = "lp855x",
+		   .of_match_table = of_match_ptr(lp855x_dt_ids),
 		   },
 	.probe = lp855x_probe,
 	.remove = lp855x_remove,
_

Patches currently in -mm which might be from Milo.Kim@ti.com are

linux-next.patch
backlight-lp855x-use-page_size-for-the-sysfs-read-operation.patch
backlight-lp855x-convert-a-type-of-device-name.patch
backlight-lp855x-move-backlight-mode-platform-data.patch
backlight-lp855x-fix-initial-brightness-type.patch
backlight-lp855x-remove-duplicate-platform-data.patch
backlight-lp855x-add-a-device-tree-structure.patch

