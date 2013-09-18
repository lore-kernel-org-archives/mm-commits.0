From: akpm@linux-foundation.org
Subject: + backlight-lp855x_bl-support-new-lp8555-device.patch added to
 -mm tree
Date: Wed, 18 Sep 2013 15:41:23 -0700
Message-ID: <523a2c13.Wtete8acFD53E/h/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47559 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab3IRWlY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 18:41:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com, milo.kim@ti.com

Subject: + backlight-lp855x_bl-support-new-lp8555-device.patch added to -mm tree
To: milo.kim@ti.com,jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 15:41:23 -0700


The patch titled
     Subject: backlight: lp855x_bl: support new LP8555 device
has been added to the -mm tree.  Its filename is
     backlight-lp855x_bl-support-new-lp8555-device.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-lp855x_bl-support-new-lp8555-device.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-lp855x_bl-support-new-lp8555-device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Milo Kim <milo.kim@ti.com>
Subject: backlight: lp855x_bl: support new LP8555 device

LP8555 is one of the LP855x family devices.

This device needs pre_init_device() and post_init_device() driver
structure.  It's same as LP8557, so the device configuration code is
shared with LP8557.  Backlight outputs are generated from dual DC-DC boost
converters.  It's configurable EPROM settings which are defined in the
platform data.

Driver documentation and device tree bindings are updated.

Signed-off-by: Milo Kim <milo.kim@ti.com>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/backlight/lp855x-driver.txt                    |    5 +
 Documentation/devicetree/bindings/video/backlight/lp855x.txt |   29 +++++++++-
 drivers/video/backlight/Kconfig                              |    4 -
 drivers/video/backlight/lp855x_bl.c                          |   17 +++++
 include/linux/platform_data/lp855x.h                         |   19 ++++++
 5 files changed, 67 insertions(+), 7 deletions(-)

diff -puN Documentation/backlight/lp855x-driver.txt~backlight-lp855x_bl-support-new-lp8555-device Documentation/backlight/lp855x-driver.txt
--- a/Documentation/backlight/lp855x-driver.txt~backlight-lp855x_bl-support-new-lp8555-device
+++ a/Documentation/backlight/lp855x-driver.txt
@@ -4,7 +4,8 @@ Kernel driver lp855x
 Backlight driver for LP855x ICs
 
 Supported chips:
-	Texas Instruments LP8550, LP8551, LP8552, LP8553, LP8556 and LP8557
+	Texas Instruments LP8550, LP8551, LP8552, LP8553, LP8555, LP8556 and
+	LP8557
 
 Author: Milo(Woogyom) Kim <milo.kim@ti.com>
 
@@ -24,7 +25,7 @@ Value : pwm based or register based
 
 2) chip_id
 The lp855x chip id.
-Value : lp8550/lp8551/lp8552/lp8553/lp8556/lp8557
+Value : lp8550/lp8551/lp8552/lp8553/lp8555/lp8556/lp8557
 
 Platform data for lp855x
 ------------------------
diff -puN Documentation/devicetree/bindings/video/backlight/lp855x.txt~backlight-lp855x_bl-support-new-lp8555-device Documentation/devicetree/bindings/video/backlight/lp855x.txt
--- a/Documentation/devicetree/bindings/video/backlight/lp855x.txt~backlight-lp855x_bl-support-new-lp8555-device
+++ a/Documentation/devicetree/bindings/video/backlight/lp855x.txt
@@ -2,7 +2,7 @@ lp855x bindings
 
 Required properties:
   - compatible: "ti,lp8550", "ti,lp8551", "ti,lp8552", "ti,lp8553",
-                "ti,lp8556", "ti,lp8557"
+                "ti,lp8555", "ti,lp8556", "ti,lp8557"
   - reg: I2C slave address (u8)
   - dev-ctrl: Value of DEVICE CONTROL register (u8). It depends on the device.
 
@@ -15,6 +15,33 @@ Optional properties:
 
 Example:
 
+	/* LP8555 */
+	backlight@2c {
+		compatible = "ti,lp8555";
+		reg = <0x2c>;
+
+		dev-ctrl = /bits/ 8 <0x00>;
+		pwm-period = <10000>;
+
+		/* 4V OV, 4 output LED0 string enabled */
+		rom_14h {
+			rom-addr = /bits/ 8 <0x14>;
+			rom-val = /bits/ 8 <0xcf>;
+		};
+
+		/* Heavy smoothing, 24ms ramp time step */
+		rom_15h {
+			rom-addr = /bits/ 8 <0x15>;
+			rom-val = /bits/ 8 <0xc7>;
+		};
+
+		/* 4 output LED1 string enabled */
+		rom_19h {
+			rom-addr = /bits/ 8 <0x19>;
+			rom-val = /bits/ 8 <0x0f>;
+		};
+	};
+
 	/* LP8556 */
 	backlight@2c {
 		compatible = "ti,lp8556";
diff -puN drivers/video/backlight/Kconfig~backlight-lp855x_bl-support-new-lp8555-device drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~backlight-lp855x_bl-support-new-lp8555-device
+++ a/drivers/video/backlight/Kconfig
@@ -388,8 +388,8 @@ config BACKLIGHT_LP855X
 	tristate "Backlight driver for TI LP855X"
 	depends on BACKLIGHT_CLASS_DEVICE && I2C
 	help
-	  This supports TI LP8550, LP8551, LP8552, LP8553, LP8556 and LP8557
-	  backlight driver.
+	  This supports TI LP8550, LP8551, LP8552, LP8553, LP8555, LP8556 and
+	  LP8557 backlight driver.
 
 config BACKLIGHT_LP8788
 	tristate "Backlight driver for TI LP8788 MFD"
diff -puN drivers/video/backlight/lp855x_bl.c~backlight-lp855x_bl-support-new-lp8555-device drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~backlight-lp855x_bl-support-new-lp8555-device
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -26,13 +26,15 @@
 #define LP8556_EPROM_START		0xA0
 #define LP8556_EPROM_END		0xAF
 
-/* LP8557 Registers */
+/* LP8555/7 Registers */
 #define LP8557_BL_CMD			0x00
 #define LP8557_BL_MASK			0x01
 #define LP8557_BL_ON			0x01
 #define LP8557_BL_OFF			0x00
 #define LP8557_BRIGHTNESS_CTRL		0x04
 #define LP8557_CONFIG			0x10
+#define LP8555_EPROM_START		0x10
+#define LP8555_EPROM_END		0x7A
 #define LP8557_EPROM_START		0x10
 #define LP8557_EPROM_END		0x1E
 
@@ -111,6 +113,10 @@ static bool lp855x_is_valid_rom_area(str
 		start = LP8556_EPROM_START;
 		end = LP8556_EPROM_END;
 		break;
+	case LP8555:
+		start = LP8555_EPROM_START;
+		end = LP8555_EPROM_END;
+		break;
 	case LP8557:
 		start = LP8557_EPROM_START;
 		end = LP8557_EPROM_END;
@@ -165,9 +171,14 @@ static int lp855x_configure(struct lp855
 	struct lp855x_platform_data *pd = lp->pdata;
 
 	switch (lp->chip_id) {
-	case LP8550 ... LP8556:
+	case LP8550:
+	case LP8551:
+	case LP8552:
+	case LP8553:
+	case LP8556:
 		lp->cfg = &lp855x_dev_cfg;
 		break;
+	case LP8555:
 	case LP8557:
 		lp->cfg = &lp8557_dev_cfg;
 		break;
@@ -470,6 +481,7 @@ static const struct of_device_id lp855x_
 	{ .compatible = "ti,lp8551", },
 	{ .compatible = "ti,lp8552", },
 	{ .compatible = "ti,lp8553", },
+	{ .compatible = "ti,lp8555", },
 	{ .compatible = "ti,lp8556", },
 	{ .compatible = "ti,lp8557", },
 	{ }
@@ -481,6 +493,7 @@ static const struct i2c_device_id lp855x
 	{"lp8551", LP8551},
 	{"lp8552", LP8552},
 	{"lp8553", LP8553},
+	{"lp8555", LP8555},
 	{"lp8556", LP8556},
 	{"lp8557", LP8557},
 	{ }
diff -puN include/linux/platform_data/lp855x.h~backlight-lp855x_bl-support-new-lp8555-device include/linux/platform_data/lp855x.h
--- a/include/linux/platform_data/lp855x.h~backlight-lp855x_bl-support-new-lp8555-device
+++ a/include/linux/platform_data/lp855x.h
@@ -40,6 +40,17 @@
 #define LP8553_PWM_CONFIG	LP8550_PWM_CONFIG
 #define LP8553_I2C_CONFIG	LP8550_I2C_CONFIG
 
+/* CONFIG register - LP8555 */
+#define LP8555_PWM_STANDBY	BIT(7)
+#define LP8555_PWM_FILTER	BIT(6)
+#define LP8555_RELOAD_EPROM	BIT(3)	/* use it if EPROMs should be reset
+					   when the backlight turns on */
+#define LP8555_OFF_OPENLEDS	BIT(2)
+#define LP8555_PWM_CONFIG	LP8555_PWM_ONLY
+#define LP8555_I2C_CONFIG	LP8555_I2C_ONLY
+#define LP8555_COMB1_CONFIG	LP8555_COMBINED1
+#define LP8555_COMB2_CONFIG	LP8555_COMBINED2
+
 /* DEVICE CONTROL register - LP8556 */
 #define LP8556_PWM_CONFIG	(LP8556_PWM_ONLY << BRT_MODE_SHFT)
 #define LP8556_COMB1_CONFIG	(LP8556_COMBINED1 << BRT_MODE_SHFT)
@@ -65,6 +76,7 @@ enum lp855x_chip_id {
 	LP8551,
 	LP8552,
 	LP8553,
+	LP8555,
 	LP8556,
 	LP8557,
 };
@@ -89,6 +101,13 @@ enum lp8553_brighntess_source {
 	LP8553_I2C_ONLY = LP8550_I2C_ONLY,
 };
 
+enum lp8555_brightness_source {
+	LP8555_PWM_ONLY,
+	LP8555_I2C_ONLY,
+	LP8555_COMBINED1,	/* Brightness register with shaped PWM */
+	LP8555_COMBINED2,	/* PWM with shaped brightness register */
+};
+
 enum lp8556_brightness_source {
 	LP8556_PWM_ONLY,
 	LP8556_COMBINED1,	/* pwm + i2c before the shaper block */
_

Patches currently in -mm which might be from milo.kim@ti.com are

linux-next.patch
backlight-lp855x_bl-support-new-lp8555-device.patch

