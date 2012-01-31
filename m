From: akpm@linux-foundation.org
Subject: + leds-lp5521-add-update_config-in-the-lp5521_platform_data.patch added to -mm tree
Date: Tue, 31 Jan 2012 12:13:26 -0800
Message-ID: <20120131201327.09136A00B3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:51962 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab2AaUN2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2012 15:13:28 -0500
Received: by mail-ey0-f202.google.com with SMTP id f1so19735eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2012 12:13:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Milo.Kim@ti.com, arun.murthy@stericsson.com, linus.walleij@linaro.org, milo.kim@ti.com, rpurdie@rpsys.net, srinidhi.kasagar@stericsson.com


The patch titled
     Subject: drivers/leds/leds-lp5521.c: add 'update_config' in the lp5521_platform_data
has been added to the -mm tree.  Its filename is
     leds-lp5521-add-update_config-in-the-lp5521_platform_data.patch

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
Subject: drivers/leds/leds-lp5521.c: add 'update_config' in the lp5521_platform_data

The value of CONFIG register(Addr 08h) is configurable.  For supporting
this feature, update_config is added in the platform data.  If
'update_config' is not defined, the default value is 'LP5521_PWRSAVE_EN |
LP5521_CP_MODE_AUTO | LP5521_R_TO_BATT'.

To define CONFIG register in the platform data, the bit definitions were
mo= ved to the header file.

Documentation updated : description about 'update_config' and example.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Arun MURTHY <arun.murthy@stericsson.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/leds/leds-lp5521.txt |   19 +++++++++++++++++++
 drivers/leds/leds-lp5521.c         |   19 ++++---------------
 include/linux/leds-lp5521.h        |   13 +++++++++++++
 3 files changed, 36 insertions(+), 15 deletions(-)

diff -puN Documentation/leds/leds-lp5521.txt~leds-lp5521-add-update_config-in-the-lp5521_platform_data Documentation/leds/leds-lp5521.txt
--- a/Documentation/leds/leds-lp5521.txt~leds-lp5521-add-update_config-in-the-lp5521_platform_data
+++ a/Documentation/leds/leds-lp5521.txt
@@ -92,3 +92,22 @@ static struct lp5521_platform_data lp552
 
 If the current is set to 0 in the platform data, that channel is
 disabled and it is not visible in the sysfs.
+
+The 'update_config' : CONFIG register (ADDR 08h)
+This value is platform-specific data.
+If update_config is not defined, the CONFIG register is set with
+'LP5521_PWRSAVE_EN | LP5521_CP_MODE_AUTO | LP5521_R_TO_BATT'.
+(Enable auto-powersave, set charge pump to auto, red to battery)
+
+example of update_config :
+
+#define LP5521_CONFIGS	(LP5521_PWM_HF | LP5521_PWRSAVE_EN | \
+			LP5521_CP_MODE_AUTO | LP5521_R_TO_BATT | \
+			LP5521_CLK_INT)
+
+static struct lp5521_platform_data lp5521_pdata = {
+	.led_config = lp5521_led_config,
+	.num_channels = ARRAY_SIZE(lp5521_led_config),
+	.clock_mode = LP5521_CLOCK_INT,
+	.update_config = LP5521_CONFIGS,
+};
diff -puN drivers/leds/leds-lp5521.c~leds-lp5521-add-update_config-in-the-lp5521_platform_data drivers/leds/leds-lp5521.c
--- a/drivers/leds/leds-lp5521.c~leds-lp5521-add-update_config-in-the-lp5521_platform_data
+++ a/drivers/leds/leds-lp5521.c
@@ -82,18 +82,6 @@
 #define LP5521_LOGARITHMIC_PWM		0x80	/* Logarithmic PWM adjustment */
 #define LP5521_EXEC_RUN			0x2A
 
-/* Bits in CONFIG register */
-#define LP5521_PWM_HF			0x40	/* PWM: 0 = 256Hz, 1 = 558Hz */
-#define LP5521_PWRSAVE_EN		0x20	/* 1 = Power save mode */
-#define LP5521_CP_MODE_OFF		0	/* Charge pump (CP) off */
-#define LP5521_CP_MODE_BYPASS		8	/* CP forced to bypass mode */
-#define LP5521_CP_MODE_1X5		0x10	/* CP forced to 1.5x mode */
-#define LP5521_CP_MODE_AUTO		0x18	/* Automatic mode selection */
-#define LP5521_R_TO_BATT		4	/* R out: 0 = CP, 1 = Vbat */
-#define LP5521_CLK_SRC_EXT		0	/* Ext-clk source (CLK_32K) */
-#define LP5521_CLK_INT			1	/* Internal clock */
-#define LP5521_CLK_AUTO			2	/* Automatic clock selection */
-
 /* Status */
 #define LP5521_EXT_CLK_USED		0x08
 
@@ -241,15 +229,16 @@ static int lp5521_configure(struct i2c_c
 {
 	struct lp5521_chip *chip = i2c_get_clientdata(client);
 	int ret;
+	u8 cfg;
 
 	lp5521_init_engine(chip);
 
 	/* Set all PWMs to direct control mode */
 	ret = lp5521_write(client, LP5521_REG_OP_MODE, 0x3F);
 
-	/* Enable auto-powersave, set charge pump to auto, red to battery */
-	ret |= lp5521_write(client, LP5521_REG_CONFIG,
-		LP5521_PWRSAVE_EN | LP5521_CP_MODE_AUTO | LP5521_R_TO_BATT);
+	cfg = chip->pdata->update_config ?
+		: (LP5521_PWRSAVE_EN | LP5521_CP_MODE_AUTO | LP5521_R_TO_BATT);
+	ret |= lp5521_write(client, LP5521_REG_CONFIG, cfg);
 
 	/* Initialize all channels PWM to zero -> leds off */
 	ret |= lp5521_write(client, LP5521_REG_R_PWM, 0);
diff -puN include/linux/leds-lp5521.h~leds-lp5521-add-update_config-in-the-lp5521_platform_data include/linux/leds-lp5521.h
--- a/include/linux/leds-lp5521.h~leds-lp5521-add-update_config-in-the-lp5521_platform_data
+++ a/include/linux/leds-lp5521.h
@@ -36,6 +36,18 @@ struct lp5521_led_config {
 #define LP5521_CLOCK_INT	1
 #define LP5521_CLOCK_EXT	2
 
+/* Bits in CONFIG register */
+#define LP5521_PWM_HF			0x40	/* PWM: 0 = 256Hz, 1 = 558Hz */
+#define LP5521_PWRSAVE_EN		0x20	/* 1 = Power save mode */
+#define LP5521_CP_MODE_OFF		0	/* Charge pump (CP) off */
+#define LP5521_CP_MODE_BYPASS		8	/* CP forced to bypass mode */
+#define LP5521_CP_MODE_1X5		0x10	/* CP forced to 1.5x mode */
+#define LP5521_CP_MODE_AUTO		0x18	/* Automatic mode selection */
+#define LP5521_R_TO_BATT		4	/* R out: 0 = CP, 1 = Vbat */
+#define LP5521_CLK_SRC_EXT		0	/* Ext-clk source (CLK_32K) */
+#define LP5521_CLK_INT			1	/* Internal clock */
+#define LP5521_CLK_AUTO			2	/* Automatic clock selection */
+
 struct lp5521_platform_data {
 	struct lp5521_led_config *led_config;
 	u8	num_channels;
@@ -44,6 +56,7 @@ struct lp5521_platform_data {
 	void	(*release_resources)(void);
 	void	(*enable)(bool state);
 	const char *label;
+	u8	update_config;
 };
 
 #endif /* __LINUX_LP5521_H */
_
Subject: Subject: drivers/leds/leds-lp5521.c: add 'update_config' in the lp5521_platform_data

Patches currently in -mm which might be from Milo.Kim@ti.com are

backlight-new-backlight-driver-for-lp855x-devices.patch
leds-lp5521-add-name-in-the-lp5521_led_config.patch
leds-lp5521-add-update_config-in-the-lp5521_platform_data.patch
leds-lp5521-support-led-pattern-data.patch
leds-lp5521-redefinition-of-register-bits.patch

