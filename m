From: akpm@linux-foundation.org
Subject: [merged] backlight-move-lp855x-header-into-platform_data-directory.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:50:46 -0700
Message-ID: <20120731185047.1A25C5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:50136 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab2GaSut (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:50:49 -0400
Received: by bkcjc3 with SMTP id jc3so293431bkc.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:50:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Milo.Kim@ti.com, bryan.wu@canonical.com, milo.kim@ti.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: move lp855x header into platform_data directory
has been removed from the -mm tree.  Its filename was
     backlight-move-lp855x-header-into-platform_data-directory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: backlight: move lp855x header into platform_data directory

The lp855x header is used only in the platform side, so it can be moved
into platform_data directory

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Bryan Wu <bryan.wu@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lp855x_bl.c  |    2 
 include/linux/lp855x.h               |  125 -------------------------
 include/linux/platform_data/lp855x.h |  125 +++++++++++++++++++++++++
 3 files changed, 126 insertions(+), 126 deletions(-)

diff -puN drivers/video/backlight/lp855x_bl.c~backlight-move-lp855x-header-into-platform_data-directory drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~backlight-move-lp855x-header-into-platform_data-directory
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -14,7 +14,7 @@
 #include <linux/i2c.h>
 #include <linux/backlight.h>
 #include <linux/err.h>
-#include <linux/lp855x.h>
+#include <linux/platform_data/lp855x.h>
 
 /* Registers */
 #define BRIGHTNESS_CTRL		0x00
diff -puN include/linux/lp855x.h~backlight-move-lp855x-header-into-platform_data-directory /dev/null
--- a/include/linux/lp855x.h
+++ /dev/null
@@ -1,125 +0,0 @@
-/*
- * LP855x Backlight Driver
- *
- *			Copyright (C) 2011 Texas Instruments
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-
-#ifndef _LP855X_H
-#define _LP855X_H
-
-#define BL_CTL_SHFT	(0)
-#define BRT_MODE_SHFT	(1)
-#define BRT_MODE_MASK	(0x06)
-
-/* Enable backlight. Only valid when BRT_MODE=10(I2C only) */
-#define ENABLE_BL	(1)
-#define DISABLE_BL	(0)
-
-#define I2C_CONFIG(id)	id ## _I2C_CONFIG
-#define PWM_CONFIG(id)	id ## _PWM_CONFIG
-
-/* DEVICE CONTROL register - LP8550 */
-#define LP8550_PWM_CONFIG	(LP8550_PWM_ONLY << BRT_MODE_SHFT)
-#define LP8550_I2C_CONFIG	((ENABLE_BL << BL_CTL_SHFT) | \
-				(LP8550_I2C_ONLY << BRT_MODE_SHFT))
-
-/* DEVICE CONTROL register - LP8551 */
-#define LP8551_PWM_CONFIG	LP8550_PWM_CONFIG
-#define LP8551_I2C_CONFIG	LP8550_I2C_CONFIG
-
-/* DEVICE CONTROL register - LP8552 */
-#define LP8552_PWM_CONFIG	LP8550_PWM_CONFIG
-#define LP8552_I2C_CONFIG	LP8550_I2C_CONFIG
-
-/* DEVICE CONTROL register - LP8553 */
-#define LP8553_PWM_CONFIG	LP8550_PWM_CONFIG
-#define LP8553_I2C_CONFIG	LP8550_I2C_CONFIG
-
-/* DEVICE CONTROL register - LP8556 */
-#define LP8556_PWM_CONFIG	(LP8556_PWM_ONLY << BRT_MODE_SHFT)
-#define LP8556_COMB1_CONFIG	(LP8556_COMBINED1 << BRT_MODE_SHFT)
-#define LP8556_I2C_CONFIG	((ENABLE_BL << BL_CTL_SHFT) | \
-				(LP8556_I2C_ONLY << BRT_MODE_SHFT))
-#define LP8556_COMB2_CONFIG	(LP8556_COMBINED2 << BRT_MODE_SHFT)
-
-enum lp855x_chip_id {
-	LP8550,
-	LP8551,
-	LP8552,
-	LP8553,
-	LP8556,
-};
-
-enum lp855x_brightness_ctrl_mode {
-	PWM_BASED = 1,
-	REGISTER_BASED,
-};
-
-enum lp8550_brighntess_source {
-	LP8550_PWM_ONLY,
-	LP8550_I2C_ONLY = 2,
-};
-
-enum lp8551_brighntess_source {
-	LP8551_PWM_ONLY = LP8550_PWM_ONLY,
-	LP8551_I2C_ONLY = LP8550_I2C_ONLY,
-};
-
-enum lp8552_brighntess_source {
-	LP8552_PWM_ONLY = LP8550_PWM_ONLY,
-	LP8552_I2C_ONLY = LP8550_I2C_ONLY,
-};
-
-enum lp8553_brighntess_source {
-	LP8553_PWM_ONLY = LP8550_PWM_ONLY,
-	LP8553_I2C_ONLY = LP8550_I2C_ONLY,
-};
-
-enum lp8556_brightness_source {
-	LP8556_PWM_ONLY,
-	LP8556_COMBINED1,	/* pwm + i2c before the shaper block */
-	LP8556_I2C_ONLY,
-	LP8556_COMBINED2,	/* pwm + i2c after the shaper block */
-};
-
-struct lp855x_pwm_data {
-	void (*pwm_set_intensity) (int brightness, int max_brightness);
-	int (*pwm_get_intensity) (int max_brightness);
-};
-
-struct lp855x_rom_data {
-	u8 addr;
-	u8 val;
-};
-
-/**
- * struct lp855x_platform_data
- * @name : Backlight driver name. If it is not defined, default name is set.
- * @mode : brightness control by pwm or lp855x register
- * @device_control : value of DEVICE CONTROL register
- * @initial_brightness : initial value of backlight brightness
- * @pwm_data : platform specific pwm generation functions.
-		Only valid when mode is PWM_BASED.
- * @load_new_rom_data :
-	0 : use default configuration data
-	1 : update values of eeprom or eprom registers on loading driver
- * @size_program : total size of lp855x_rom_data
- * @rom_data : list of new eeprom/eprom registers
- */
-struct lp855x_platform_data {
-	char *name;
-	enum lp855x_brightness_ctrl_mode mode;
-	u8 device_control;
-	int initial_brightness;
-	struct lp855x_pwm_data pwm_data;
-	u8 load_new_rom_data;
-	int size_program;
-	struct lp855x_rom_data *rom_data;
-};
-
-#endif
diff -puN /dev/null include/linux/platform_data/lp855x.h
--- /dev/null
+++ a/include/linux/platform_data/lp855x.h
@@ -0,0 +1,125 @@
+/*
+ * LP855x Backlight Driver
+ *
+ *			Copyright (C) 2011 Texas Instruments
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
+#define BL_CTL_SHFT	(0)
+#define BRT_MODE_SHFT	(1)
+#define BRT_MODE_MASK	(0x06)
+
+/* Enable backlight. Only valid when BRT_MODE=10(I2C only) */
+#define ENABLE_BL	(1)
+#define DISABLE_BL	(0)
+
+#define I2C_CONFIG(id)	id ## _I2C_CONFIG
+#define PWM_CONFIG(id)	id ## _PWM_CONFIG
+
+/* DEVICE CONTROL register - LP8550 */
+#define LP8550_PWM_CONFIG	(LP8550_PWM_ONLY << BRT_MODE_SHFT)
+#define LP8550_I2C_CONFIG	((ENABLE_BL << BL_CTL_SHFT) | \
+				(LP8550_I2C_ONLY << BRT_MODE_SHFT))
+
+/* DEVICE CONTROL register - LP8551 */
+#define LP8551_PWM_CONFIG	LP8550_PWM_CONFIG
+#define LP8551_I2C_CONFIG	LP8550_I2C_CONFIG
+
+/* DEVICE CONTROL register - LP8552 */
+#define LP8552_PWM_CONFIG	LP8550_PWM_CONFIG
+#define LP8552_I2C_CONFIG	LP8550_I2C_CONFIG
+
+/* DEVICE CONTROL register - LP8553 */
+#define LP8553_PWM_CONFIG	LP8550_PWM_CONFIG
+#define LP8553_I2C_CONFIG	LP8550_I2C_CONFIG
+
+/* DEVICE CONTROL register - LP8556 */
+#define LP8556_PWM_CONFIG	(LP8556_PWM_ONLY << BRT_MODE_SHFT)
+#define LP8556_COMB1_CONFIG	(LP8556_COMBINED1 << BRT_MODE_SHFT)
+#define LP8556_I2C_CONFIG	((ENABLE_BL << BL_CTL_SHFT) | \
+				(LP8556_I2C_ONLY << BRT_MODE_SHFT))
+#define LP8556_COMB2_CONFIG	(LP8556_COMBINED2 << BRT_MODE_SHFT)
+
+enum lp855x_chip_id {
+	LP8550,
+	LP8551,
+	LP8552,
+	LP8553,
+	LP8556,
+};
+
+enum lp855x_brightness_ctrl_mode {
+	PWM_BASED = 1,
+	REGISTER_BASED,
+};
+
+enum lp8550_brighntess_source {
+	LP8550_PWM_ONLY,
+	LP8550_I2C_ONLY = 2,
+};
+
+enum lp8551_brighntess_source {
+	LP8551_PWM_ONLY = LP8550_PWM_ONLY,
+	LP8551_I2C_ONLY = LP8550_I2C_ONLY,
+};
+
+enum lp8552_brighntess_source {
+	LP8552_PWM_ONLY = LP8550_PWM_ONLY,
+	LP8552_I2C_ONLY = LP8550_I2C_ONLY,
+};
+
+enum lp8553_brighntess_source {
+	LP8553_PWM_ONLY = LP8550_PWM_ONLY,
+	LP8553_I2C_ONLY = LP8550_I2C_ONLY,
+};
+
+enum lp8556_brightness_source {
+	LP8556_PWM_ONLY,
+	LP8556_COMBINED1,	/* pwm + i2c before the shaper block */
+	LP8556_I2C_ONLY,
+	LP8556_COMBINED2,	/* pwm + i2c after the shaper block */
+};
+
+struct lp855x_pwm_data {
+	void (*pwm_set_intensity) (int brightness, int max_brightness);
+	int (*pwm_get_intensity) (int max_brightness);
+};
+
+struct lp855x_rom_data {
+	u8 addr;
+	u8 val;
+};
+
+/**
+ * struct lp855x_platform_data
+ * @name : Backlight driver name. If it is not defined, default name is set.
+ * @mode : brightness control by pwm or lp855x register
+ * @device_control : value of DEVICE CONTROL register
+ * @initial_brightness : initial value of backlight brightness
+ * @pwm_data : platform specific pwm generation functions.
+		Only valid when mode is PWM_BASED.
+ * @load_new_rom_data :
+	0 : use default configuration data
+	1 : update values of eeprom or eprom registers on loading driver
+ * @size_program : total size of lp855x_rom_data
+ * @rom_data : list of new eeprom/eprom registers
+ */
+struct lp855x_platform_data {
+	char *name;
+	enum lp855x_brightness_ctrl_mode mode;
+	u8 device_control;
+	int initial_brightness;
+	struct lp855x_pwm_data pwm_data;
+	u8 load_new_rom_data;
+	int size_program;
+	struct lp855x_rom_data *rom_data;
+};
+
+#endif
_

Patches currently in -mm which might be from Milo.Kim@ti.com are

origin.patch
linux-next.patch

