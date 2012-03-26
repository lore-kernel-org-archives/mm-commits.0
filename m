From: akpm@linux-foundation.org
Subject: [merged] leds-lp5521-redefinition-of-register-bits.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:29:36 -0700
Message-ID: <20120326192936.71888A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:42005 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753120Ab2CZT3j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2012 15:29:39 -0400
Received: by laai8 with SMTP id i8so288256laa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:29:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Milo.Kim@ti.com, arun.murthy@stericsson.com, linus.walleij@linaro.org, milo.kim@ti.com, rpurdie@rpsys.net, srinidhi.kasagar@stericsson.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/leds/leds-lp5521.c: redefinition of register bits
has been removed from the -mm tree.  Its filename was
     leds-lp5521-redefinition-of-register-bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: drivers/leds/leds-lp5521.c: redefinition of register bits

For better readability, values of LP5521_REG_ENABLE register were
redefined= .  Additional definitions: LP5521_ENABLE_DEFAULT and
LP5521_ENABLE_RUN_PROGRAM= .

Use definition rather than hard code value.
: 0x3F -> 'LP5521_CMD_DIRECT'

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Arun MURTHY <arun.murthy@stericsson.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lp5521.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff -puN drivers/leds/leds-lp5521.c~leds-lp5521-redefinition-of-register-bits drivers/leds/leds-lp5521.c
--- a/drivers/leds/leds-lp5521.c~leds-lp5521-redefinition-of-register-bits
+++ a/drivers/leds/leds-lp5521.c
@@ -81,6 +81,10 @@
 #define LP5521_MASTER_ENABLE		0x40	/* Chip master enable */
 #define LP5521_LOGARITHMIC_PWM		0x80	/* Logarithmic PWM adjustment */
 #define LP5521_EXEC_RUN			0x2A
+#define LP5521_ENABLE_DEFAULT	\
+	(LP5521_MASTER_ENABLE | LP5521_LOGARITHMIC_PWM)
+#define LP5521_ENABLE_RUN_PROGRAM	\
+	(LP5521_ENABLE_DEFAULT | LP5521_EXEC_RUN)
 
 /* Status */
 #define LP5521_EXT_CLK_USED		0x08
@@ -237,7 +241,7 @@ static int lp5521_configure(struct i2c_c
 	lp5521_init_engine(chip);
 
 	/* Set all PWMs to direct control mode */
-	ret = lp5521_write(client, LP5521_REG_OP_MODE, 0x3F);
+	ret = lp5521_write(client, LP5521_REG_OP_MODE, LP5521_CMD_DIRECT);
 
 	cfg = chip->pdata->update_config ?
 		: (LP5521_PWRSAVE_EN | LP5521_CP_MODE_AUTO | LP5521_R_TO_BATT);
@@ -250,8 +254,7 @@ static int lp5521_configure(struct i2c_c
 
 	/* Set engines are set to run state when OP_MODE enables engines */
 	ret |= lp5521_write(client, LP5521_REG_ENABLE,
-			LP5521_MASTER_ENABLE | LP5521_LOGARITHMIC_PWM |
-			LP5521_EXEC_RUN);
+			LP5521_ENABLE_RUN_PROGRAM);
 	/* enable takes 500us. 1 - 2 ms leaves some margin */
 	usleep_range(1000, 2000);
 
@@ -302,8 +305,7 @@ static int lp5521_detect(struct i2c_clie
 	int ret;
 	u8 buf;
 
-	ret = lp5521_write(client, LP5521_REG_ENABLE,
-			LP5521_MASTER_ENABLE | LP5521_LOGARITHMIC_PWM);
+	ret = lp5521_write(client, LP5521_REG_ENABLE, LP5521_ENABLE_DEFAULT);
 	if (ret)
 		return ret;
 	/* enable takes 500us. 1 - 2 ms leaves some margin */
@@ -311,7 +313,7 @@ static int lp5521_detect(struct i2c_clie
 	ret = lp5521_read(client, LP5521_REG_ENABLE, &buf);
 	if (ret)
 		return ret;
-	if (buf != (LP5521_MASTER_ENABLE | LP5521_LOGARITHMIC_PWM))
+	if (buf != LP5521_ENABLE_DEFAULT)
 		return -ENODEV;
 
 	return 0;
@@ -576,8 +578,7 @@ static void lp5521_run_led_pattern(int m
 		return;
 
 	if (mode == PATTERN_OFF) {
-		lp5521_write(cl, LP5521_REG_ENABLE,
-			LP5521_MASTER_ENABLE | LP5521_LOGARITHMIC_PWM);
+		lp5521_write(cl, LP5521_REG_ENABLE, LP5521_ENABLE_DEFAULT);
 		usleep_range(1000, 2000);
 		lp5521_write(cl, LP5521_REG_OP_MODE, LP5521_CMD_DIRECT);
 	} else {
@@ -599,9 +600,7 @@ static void lp5521_run_led_pattern(int m
 
 		lp5521_write(cl, LP5521_REG_OP_MODE, LP5521_CMD_RUN);
 		usleep_range(1000, 2000);
-		lp5521_write(cl, LP5521_REG_ENABLE,
-			LP5521_MASTER_ENABLE | LP5521_LOGARITHMIC_PWM |
-			LP5521_EXEC_RUN);
+		lp5521_write(cl, LP5521_REG_ENABLE, LP5521_ENABLE_RUN_PROGRAM);
 	}
 }
 
_

Patches currently in -mm which might be from Milo.Kim@ti.com are

origin.patch

