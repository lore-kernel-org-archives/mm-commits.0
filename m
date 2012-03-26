From: akpm@linux-foundation.org
Subject: [merged] leds-lp5521-add-update_config-in-the-lp5521_platform_data.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:29:32 -0700
Message-ID: <20120326192932.72A20A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:63241 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2CZT3e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:29:34 -0400
Received: by mail-we0-f202.google.com with SMTP id x9so290130wej.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:29:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Milo.Kim@ti.com, arun.murthy@stericsson.com, linus.walleij@linaro.org, milo.kim@ti.com, rpurdie@rpsys.net, srinidhi.kasagar@stericsson.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/leds/leds-lp5521.c: add 'update_config' in the lp5521_platform_data
has been removed from the -mm tree.  Its filename was
     leds-lp5521-add-update_config-in-the-lp5521_platform_data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from Milo.Kim@ti.com are

origin.patch

