From: akpm@linux-foundation.org
Subject: + leds-lp5521-support-led-pattern-data.patch added to -mm tree
Date: Tue, 31 Jan 2012 12:13:29 -0800
Message-ID: <20120131201330.1395CA00B3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:44664 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab2AaUNc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2012 15:13:32 -0500
Received: by wgbds12 with SMTP id ds12so15796wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2012 12:13:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Milo.Kim@ti.com, arun.murthy@stericsson.com, linus.walleij@linaro.org, milo.kim@ti.com, rpurdie@rpsys.net, srinidhi.kasagar@stericsson.com


The patch titled
     Subject: drivers/leds/leds-lp5521.c: support led pattern data
has been added to the -mm tree.  Its filename is
     leds-lp5521-support-led-pattern-data.patch

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
Subject: drivers/leds/leds-lp5521.c: support led pattern data

The lp5521 has autonomous operation mode without external control.  Using
lp5521_platform_data, various led patterns can be configurable.  For
supporting this feature, new functions and device attribute are added.

Structure of lp5521_led_pattern: 3 channels are supported - red, green and
= blue.  Pattern(s) of each channel and numbers of pattern(s) are defined
in the pla= tform data.  Pattern data are hexa codes which include pattern
commands such like set pwm, wait, ramp up/down, branch and so on.

Pattern mode functions:
* lp5521_clear_program_memory
	Before running new led pattern, program memory should be cleared.
* lp5521_write_program_memory
	Pattern data updated in the program memory via the i2c.
* lp5521_get_pattern
	Get pattern from predefined in the platform data.
* lp5521_run_led_pattern
	Stop current pattern or run new pattern.
	Transition time is required between different operation mode.

Device attribute - 'led_pattern': To load specific led pattern, new device
attribute is added.

When the lp5521 driver is unloaded, stop current led pattern mode.

Documentation updated : description about how to define the led patterns
an= d example.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Arun MURTHY <arun.murthy@stericsson.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/leds/leds-lp5521.txt |   38 ++++++++++
 drivers/leds/leds-lp5521.c         |  100 +++++++++++++++++++++++++++
 include/linux/leds-lp5521.h        |   11 ++
 3 files changed, 149 insertions(+)

diff -puN Documentation/leds/leds-lp5521.txt~leds-lp5521-support-led-pattern-data Documentation/leds/leds-lp5521.txt
--- a/Documentation/leds/leds-lp5521.txt~leds-lp5521-support-led-pattern-data
+++ a/Documentation/leds/leds-lp5521.txt
@@ -111,3 +111,41 @@ static struct lp5521_platform_data lp552
 	.clock_mode = LP5521_CLOCK_INT,
 	.update_config = LP5521_CONFIGS,
 };
+
+LED patterns : LP5521 has autonomous operation without external control.
+Pattern data can be defined in the platform data.
+
+example of led pattern data :
+
+/* RGB(50,5,0) 500ms on, 500ms off, infinite loop */
+static u8 pattern_red[] = {
+		0x40, 0x32, 0x60, 0x00,	0x40, 0x00, 0x60, 0x00,
+		};
+
+static u8 pattern_green[] = {
+		0x40, 0x05, 0x60, 0x00, 0x40, 0x00, 0x60, 0x00,
+		};
+
+static struct lp5521_led_pattern board_led_patterns[] = {
+	{
+		.r = pattern_red,
+		.g = pattern_green,
+		.size_r = ARRAY_SIZE(pattern_red),
+		.size_g = ARRAY_SIZE(pattern_green),
+	},
+};
+
+static struct lp5521_platform_data lp5521_platform_data = {
+        .led_config     = lp5521_led_config,
+        .num_channels   = ARRAY_SIZE(lp5521_led_config),
+        .clock_mode     = LP5521_CLOCK_EXT,
+	.patterns = board_led_patterns,
+	.num_patterns = ARRAY_SIZE(board_led_patterns),
+};
+
+Then predefined led pattern(s) can be executed via the sysfs.
+To start the pattern #1,
+# echo 1 > /sys/bus/i2c/devices/xxxx/led_pattern
+(xxxx : i2c bus & slave address)
+To end the pattern,
+# echo 0 > /sys/bus/i2c/devices/xxxx/led_pattern
diff -puN drivers/leds/leds-lp5521.c~leds-lp5521-support-led-pattern-data drivers/leds/leds-lp5521.c
--- a/drivers/leds/leds-lp5521.c~leds-lp5521-support-led-pattern-data
+++ a/drivers/leds/leds-lp5521.c
@@ -88,6 +88,9 @@
 /* default R channel current register value */
 #define LP5521_REG_R_CURR_DEFAULT	0xAF
 
+/* Pattern Mode */
+#define PATTERN_OFF	0
+
 struct lp5521_engine {
 	int		id;
 	u8		mode;
@@ -525,6 +528,100 @@ static ssize_t lp5521_selftest(struct de
 	return sprintf(buf, "%s\n", ret ? "FAIL" : "OK");
 }
 
+static void lp5521_clear_program_memory(struct i2c_client *cl)
+{
+	int i;
+	u8 rgb_mem[] = {
+		LP5521_REG_R_PROG_MEM,
+		LP5521_REG_G_PROG_MEM,
+		LP5521_REG_B_PROG_MEM,
+	};
+
+	for (i = 0; i < ARRAY_SIZE(rgb_mem); i++) {
+		lp5521_write(cl, rgb_mem[i], 0);
+		lp5521_write(cl, rgb_mem[i] + 1, 0);
+	}
+}
+
+static void lp5521_write_program_memory(struct i2c_client *cl,
+				u8 base, u8 *rgb, int size)
+{
+	int i;
+
+	if (!rgb || size <= 0)
+		return;
+
+	for (i = 0; i < size; i++)
+		lp5521_write(cl, base + i, *(rgb + i));
+
+	lp5521_write(cl, base + i, 0);
+	lp5521_write(cl, base + i + 1, 0);
+}
+
+static inline struct lp5521_led_pattern *lp5521_get_pattern
+					(struct lp5521_chip *chip, u8 offset)
+{
+	struct lp5521_led_pattern *ptn;
+	ptn = chip->pdata->patterns + (offset - 1);
+	return ptn;
+}
+
+static void lp5521_run_led_pattern(int mode, struct lp5521_chip *chip)
+{
+	struct lp5521_led_pattern *ptn;
+	struct i2c_client *cl = chip->client;
+	int num_patterns = chip->pdata->num_patterns;
+
+	if (mode > num_patterns || !(chip->pdata->patterns))
+		return;
+
+	if (mode == PATTERN_OFF) {
+		lp5521_write(cl, LP5521_REG_ENABLE,
+			LP5521_MASTER_ENABLE | LP5521_LOGARITHMIC_PWM);
+		usleep_range(1000, 2000);
+		lp5521_write(cl, LP5521_REG_OP_MODE, LP5521_CMD_DIRECT);
+	} else {
+		ptn = lp5521_get_pattern(chip, mode);
+		if (!ptn)
+			return;
+
+		lp5521_write(cl, LP5521_REG_OP_MODE, LP5521_CMD_LOAD);
+		usleep_range(1000, 2000);
+
+		lp5521_clear_program_memory(cl);
+
+		lp5521_write_program_memory(cl, LP5521_REG_R_PROG_MEM,
+					ptn->r, ptn->size_r);
+		lp5521_write_program_memory(cl, LP5521_REG_G_PROG_MEM,
+					ptn->g, ptn->size_g);
+		lp5521_write_program_memory(cl, LP5521_REG_B_PROG_MEM,
+					ptn->b, ptn->size_b);
+
+		lp5521_write(cl, LP5521_REG_OP_MODE, LP5521_CMD_RUN);
+		usleep_range(1000, 2000);
+		lp5521_write(cl, LP5521_REG_ENABLE,
+			LP5521_MASTER_ENABLE | LP5521_LOGARITHMIC_PWM |
+			LP5521_EXEC_RUN);
+	}
+}
+
+static ssize_t store_led_pattern(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t len)
+{
+	struct lp5521_chip *chip = i2c_get_clientdata(to_i2c_client(dev));
+	unsigned long val;
+	int ret;
+
+	ret = strict_strtoul(buf, 16, &val);
+	if (ret)
+		return ret;
+
+	lp5521_run_led_pattern(val, chip);
+
+	return len;
+}
+
 /* led class device attributes */
 static DEVICE_ATTR(led_current, S_IRUGO | S_IWUSR, show_current, store_current);
 static DEVICE_ATTR(max_current, S_IRUGO , show_max_current, NULL);
@@ -550,6 +647,7 @@ static DEVICE_ATTR(engine1_load, S_IWUSR
 static DEVICE_ATTR(engine2_load, S_IWUSR, NULL, store_engine2_load);
 static DEVICE_ATTR(engine3_load, S_IWUSR, NULL, store_engine3_load);
 static DEVICE_ATTR(selftest, S_IRUGO, lp5521_selftest, NULL);
+static DEVICE_ATTR(led_pattern, S_IWUSR, NULL, store_led_pattern);
 
 static struct attribute *lp5521_attributes[] = {
 	&dev_attr_engine1_mode.attr,
@@ -559,6 +657,7 @@ static struct attribute *lp5521_attribut
 	&dev_attr_engine1_load.attr,
 	&dev_attr_engine2_load.attr,
 	&dev_attr_engine3_load.attr,
+	&dev_attr_led_pattern.attr,
 	NULL
 };
 
@@ -761,6 +860,7 @@ static int __devexit lp5521_remove(struc
 	struct lp5521_chip *chip = i2c_get_clientdata(client);
 	int i;
 
+	lp5521_run_led_pattern(PATTERN_OFF, chip);
 	lp5521_unregister_sysfs(client);
 
 	for (i = 0; i < chip->num_leds; i++) {
diff -puN include/linux/leds-lp5521.h~leds-lp5521-support-led-pattern-data include/linux/leds-lp5521.h
--- a/include/linux/leds-lp5521.h~leds-lp5521-support-led-pattern-data
+++ a/include/linux/leds-lp5521.h
@@ -32,6 +32,15 @@ struct lp5521_led_config {
 	u8		max_current;
 };
 
+struct lp5521_led_pattern {
+	u8 *r;
+	u8 *g;
+	u8 *b;
+	u8 size_r;
+	u8 size_g;
+	u8 size_b;
+};
+
 #define LP5521_CLOCK_AUTO	0
 #define LP5521_CLOCK_INT	1
 #define LP5521_CLOCK_EXT	2
@@ -57,6 +66,8 @@ struct lp5521_platform_data {
 	void	(*enable)(bool state);
 	const char *label;
 	u8	update_config;
+	struct lp5521_led_pattern *patterns;
+	int num_patterns;
 };
 
 #endif /* __LINUX_LP5521_H */
_
Subject: Subject: drivers/leds/leds-lp5521.c: support led pattern data

Patches currently in -mm which might be from Milo.Kim@ti.com are

backlight-new-backlight-driver-for-lp855x-devices.patch
leds-lp5521-add-name-in-the-lp5521_led_config.patch
leds-lp5521-add-update_config-in-the-lp5521_platform_data.patch
leds-lp5521-support-led-pattern-data.patch
leds-lp5521-redefinition-of-register-bits.patch

