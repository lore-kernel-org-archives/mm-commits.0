From: akpm@linux-foundation.org
Subject: [merged] mach-ux500-add-lm3530-als-platform-data-for-u5500.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:55:52 -0700
Message-ID: <201107260754.p6Q7stUM003394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753117Ab1GZH4E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:56:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linus.walleij@stericsson.com, lee.jones@linaro.org, linus.walleij@linaro.org, linux@arm.linux.org.uk, rpurdie@rpsys.net, shreshthakumar.sahu@stericsson.com, mm-commits@vger.kernel.org


The patch titled
     mach-ux500: add lm3530 ALS platform data for U5500
has been removed from the -mm tree.  Its filename was
     mach-ux500-add-lm3530-als-platform-data-for-u5500.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mach-ux500: add lm3530 ALS platform data for U5500
From: Linus Walleij <linus.walleij@stericsson.com>


platform data for simple backlight driver for LM3530
in the u5500 platform

Signed-off-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-ux500/board-u5500.c |   84 +++++++++++++++++++++++++++-
 1 file changed, 83 insertions(+), 1 deletion(-)

diff -puN arch/arm/mach-ux500/board-u5500.c~mach-ux500-add-lm3530-als-platform-data-for-u5500 arch/arm/mach-ux500/board-u5500.c
--- a/arch/arm/mach-ux500/board-u5500.c~mach-ux500-add-lm3530-als-platform-data-for-u5500
+++ a/arch/arm/mach-ux500/board-u5500.c
@@ -10,16 +10,97 @@
 #include <linux/amba/bus.h>
 #include <linux/gpio.h>
 #include <linux/irq.h>
+#include <linux/i2c.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
 
+#include <plat/pincfg.h>
+#include <plat/i2c.h>
+
 #include <mach/hardware.h>
 #include <mach/devices.h>
 #include <mach/setup.h>
 
+#include "pins-db5500.h"
 #include "devices-db5500.h"
+#include <linux/led-lm3530.h>
+
+/*
+ * GPIO
+ */
+
+static pin_cfg_t u5500_pins[] = {
+	/* I2C */
+	GPIO218_I2C2_SCL        | PIN_INPUT_PULLUP,
+	GPIO219_I2C2_SDA        | PIN_INPUT_PULLUP,
+
+	/* DISPLAY_ENABLE */
+	GPIO226_GPIO        | PIN_OUTPUT_LOW,
+
+	/* Backlight Enbale */
+	GPIO224_GPIO        | PIN_OUTPUT_HIGH,
+};
+/*
+ * I2C
+ */
+
+#define U5500_I2C_CONTROLLER(id, _slsu, _tft, _rft, clk, _sm) \
+static struct nmk_i2c_controller u5500_i2c##id##_data = { \
+	/*				\
+	 * slave data setup time, which is	\
+	 * 250 ns,100ns,10ns which is 14,6,2	\
+	 * respectively for a 48 Mhz	\
+	 * i2c clock			\
+	 */				\
+	.slsu		= _slsu,	\
+	/* Tx FIFO threshold */		\
+	.tft		= _tft,		\
+	/* Rx FIFO threshold */		\
+	.rft		= _rft,		\
+	/* std. mode operation */	\
+	.clk_freq	= clk,		\
+	.sm		= _sm,		\
+}
+/*
+ * The board uses TODO <3> i2c controllers, initialize all of
+ * them with slave data setup time of 250 ns,
+ * Tx & Rx FIFO threshold values as 1 and standard
+ * mode of operation
+ */
+
+U5500_I2C_CONTROLLER(2,	0xe, 1, 1, 400000, I2C_FREQ_MODE_FAST);
+
+static struct lm3530_platform_data u5500_als_platform_data = {
+	.mode = LM3530_BL_MODE_MANUAL,
+	.als_input_mode = LM3530_INPUT_ALS1,
+	.max_current = LM3530_FS_CURR_26mA,
+	.pwm_pol_hi = true,
+	.als_avrg_time = LM3530_ALS_AVRG_TIME_512ms,
+	.brt_ramp_law = 1,      /* Linear */
+	.brt_ramp_fall = LM3530_RAMP_TIME_8s,
+	.brt_ramp_rise = LM3530_RAMP_TIME_8s,
+	.als1_resistor_sel = LM3530_ALS_IMPD_13_53kOhm,
+	.als2_resistor_sel = LM3530_ALS_IMPD_Z,
+	.als_vmin = 730,	/* mV */
+	.als_vmax = 1020,	/* mV */
+	.brt_val = 0x7F,	/* Max brightness */
+};
+
+
+static struct i2c_board_info __initdata u5500_i2c2_devices[] = {
+	{
+		/* Backlight */
+		I2C_BOARD_INFO("lm3530-led", 0x36),
+		.platform_data = &u5500_als_platform_data,
+	},
+};
 
+static void __init u5500_i2c_init(void)
+{
+	db5500_add_i2c2(&u5500_i2c2_data);
+	i2c_register_board_info(2, ARRAY_AND_SIZE(u5500_i2c2_devices));
+}
 static void __init u5500_uart_init(void)
 {
 	db5500_add_uart0(NULL);
@@ -30,7 +111,8 @@ static void __init u5500_uart_init(void)
 static void __init u5500_init_machine(void)
 {
 	u5500_init_devices();
