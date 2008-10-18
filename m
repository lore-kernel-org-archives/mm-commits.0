From: akpm@linux-foundation.org
Subject: - omap-drivers-switch-to-standard-gpio-calls.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:16:04 -0700
Message-ID: <200810182316.m9ING4tx028742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751645AbYJRXQS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:16:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, adaplas@gmail.com, dmitry.torokhov@gmail.com, dwmw2@infradead.org, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     omap drivers: switch to standard GPIO calls
has been removed from the -mm tree.  Its filename was
     omap-drivers-switch-to-standard-gpio-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omap drivers: switch to standard GPIO calls
From: David Brownell <dbrownell@users.sourceforge.net>

This updates most of the OMAP drivers which are in mainline to switch to
using the cross-platform GPIO calls instead of the older OMAP-specific
ones.

This is all fairly brainless/obvious stuff.  Probably the most interesting
bit is to observe that the omap-keypad code seems to now have a portable
core that could work with non-OMAP matrix keypads.  (That would improve
with hardware IRQ debouncing enabled, of course...)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Antonino Daplas <adaplas@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/keyboard/omap-keypad.c |   27 +++---
 drivers/mtd/nand/ams-delta.c         |    4 -
 drivers/video/omap/lcd_inn1610.c     |   22 ++---
 drivers/video/omap/lcd_osk.c         |   10 +-
 drivers/video/omap/lcd_sx1.c         |   99 +++++++++++--------------
 5 files changed, 75 insertions(+), 87 deletions(-)

diff -puN drivers/input/keyboard/omap-keypad.c~omap-drivers-switch-to-standard-gpio-calls drivers/input/keyboard/omap-keypad.c
--- a/drivers/input/keyboard/omap-keypad.c~omap-drivers-switch-to-standard-gpio-calls
+++ a/drivers/input/keyboard/omap-keypad.c
@@ -72,12 +72,9 @@ static unsigned int *col_gpios;
 static void set_col_gpio_val(struct omap_kp *omap_kp, u8 value)
 {
 	int col;
-	for (col = 0; col < omap_kp->cols; col++) {
-		if (value & (1 << col))
-			omap_set_gpio_dataout(col_gpios[col], 1);
-		else
-			omap_set_gpio_dataout(col_gpios[col], 0);
-	}
+
+	for (col = 0; col < omap_kp->cols; col++)
+		gpio_set_value(col_gpios[col], value & (1 << col));
 }
 
 static u8 get_row_gpio_val(struct omap_kp *omap_kp)
@@ -86,7 +83,7 @@ static u8 get_row_gpio_val(struct omap_k
 	u8 value = 0;
 
 	for (row = 0; row < omap_kp->rows; row++) {
-		if (omap_get_gpio_datain(row_gpios[row]))
+		if (gpio_get_value(row_gpios[row]))
 			value |= (1 << row);
 	}
 	return value;
@@ -333,23 +330,23 @@ static int __init omap_kp_probe(struct p
 	if (cpu_is_omap24xx()) {
 		/* Cols: outputs */
 		for (col_idx = 0; col_idx < omap_kp->cols; col_idx++) {
-			if (omap_request_gpio(col_gpios[col_idx]) < 0) {
+			if (gpio_request(col_gpios[col_idx], "omap_kp_col") < 0) {
 				printk(KERN_ERR "Failed to request"
 				       "GPIO%d for keypad\n",
 				       col_gpios[col_idx]);
 				goto err1;
 			}
-			omap_set_gpio_direction(col_gpios[col_idx], 0);
+			gpio_direction_output(col_gpios[col_idx], 0);
 		}
 		/* Rows: inputs */
 		for (row_idx = 0; row_idx < omap_kp->rows; row_idx++) {
-			if (omap_request_gpio(row_gpios[row_idx]) < 0) {
+			if (gpio_request(row_gpios[row_idx], "omap_kp_row") < 0) {
 				printk(KERN_ERR "Failed to request"
 				       "GPIO%d for keypad\n",
 				       row_gpios[row_idx]);
 				goto err2;
 			}
-			omap_set_gpio_direction(row_gpios[row_idx], 1);
+			gpio_direction_input(row_gpios[row_idx]);
 		}
 	} else {
 		col_idx = 0;
@@ -418,10 +415,10 @@ err3:
 	device_remove_file(&pdev->dev, &dev_attr_enable);
 err2:
 	for (i = row_idx - 1; i >=0; i--)
-		omap_free_gpio(row_gpios[i]);
+		gpio_free(row_gpios[i]);
 err1:
 	for (i = col_idx - 1; i >=0; i--)
-		omap_free_gpio(col_gpios[i]);
+		gpio_free(col_gpios[i]);
 
 	kfree(omap_kp);
 	input_free_device(input_dev);
@@ -438,9 +435,9 @@ static int omap_kp_remove(struct platfor
 	if (cpu_is_omap24xx()) {
 		int i;
 		for (i = 0; i < omap_kp->cols; i++)
-			omap_free_gpio(col_gpios[i]);
+			gpio_free(col_gpios[i]);
 		for (i = 0; i < omap_kp->rows; i++) {
-			omap_free_gpio(row_gpios[i]);
+			gpio_free(row_gpios[i]);
 			free_irq(OMAP_GPIO_IRQ(row_gpios[i]), 0);
 		}
 	} else {
diff -puN drivers/mtd/nand/ams-delta.c~omap-drivers-switch-to-standard-gpio-calls drivers/mtd/nand/ams-delta.c
--- a/drivers/mtd/nand/ams-delta.c~omap-drivers-switch-to-standard-gpio-calls
+++ a/drivers/mtd/nand/ams-delta.c
@@ -145,7 +145,7 @@ static void ams_delta_hwcontrol(struct m
 
 static int ams_delta_nand_ready(struct mtd_info *mtd)
 {
-	return omap_get_gpio_datain(AMS_DELTA_GPIO_PIN_NAND_RB);
+	return gpio_get_value(AMS_DELTA_GPIO_PIN_NAND_RB);
 }
 
 /*
@@ -185,7 +185,7 @@ static int __init ams_delta_init(void)
 	this->read_buf = ams_delta_read_buf;
 	this->verify_buf = ams_delta_verify_buf;
 	this->cmd_ctrl = ams_delta_hwcontrol;
-	if (!omap_request_gpio(AMS_DELTA_GPIO_PIN_NAND_RB)) {
+	if (gpio_request(AMS_DELTA_GPIO_PIN_NAND_RB, "nand_rdy") == 0) {
 		this->dev_ready = ams_delta_nand_ready;
 	} else {
 		this->dev_ready = NULL;
diff -puN drivers/video/omap/lcd_inn1610.c~omap-drivers-switch-to-standard-gpio-calls drivers/video/omap/lcd_inn1610.c
--- a/drivers/video/omap/lcd_inn1610.c~omap-drivers-switch-to-standard-gpio-calls
+++ a/drivers/video/omap/lcd_inn1610.c
@@ -32,43 +32,43 @@ static int innovator1610_panel_init(stru
 {
 	int r = 0;
 
-	if (omap_request_gpio(14)) {
+	if (gpio_request(14, "lcd_en0")) {
 		pr_err(MODULE_NAME ": can't request GPIO 14\n");
 		r = -1;
 		goto exit;
 	}
-	if (omap_request_gpio(15)) {
+	if (gpio_request(15, "lcd_en1")) {
 		pr_err(MODULE_NAME ": can't request GPIO 15\n");
-		omap_free_gpio(14);
+		gpio_free(14);
 		r = -1;
 		goto exit;
 	}
 	/* configure GPIO(14, 15) as outputs */
-	omap_set_gpio_direction(14, 0);
-	omap_set_gpio_direction(15, 0);
+	gpio_direction_output(14, 0);
+	gpio_direction_output(15, 0);
 exit:
 	return r;
 }
 
 static void innovator1610_panel_cleanup(struct lcd_panel *panel)
 {
-	omap_free_gpio(15);
-	omap_free_gpio(14);
+	gpio_free(15);
+	gpio_free(14);
 }
 
 static int innovator1610_panel_enable(struct lcd_panel *panel)
 {
 	/* set GPIO14 and GPIO15 high */
-	omap_set_gpio_dataout(14, 1);
-	omap_set_gpio_dataout(15, 1);
+	gpio_set_value(14, 1);
+	gpio_set_value(15, 1);
 	return 0;
 }
 
 static void innovator1610_panel_disable(struct lcd_panel *panel)
 {
 	/* set GPIO13, GPIO14 and GPIO15 low */
-	omap_set_gpio_dataout(14, 0);
-	omap_set_gpio_dataout(15, 0);
+	gpio_set_value(14, 0);
+	gpio_set_value(15, 0);
 }
 
 static unsigned long innovator1610_panel_get_caps(struct lcd_panel *panel)
diff -puN drivers/video/omap/lcd_osk.c~omap-drivers-switch-to-standard-gpio-calls drivers/video/omap/lcd_osk.c
--- a/drivers/video/omap/lcd_osk.c~omap-drivers-switch-to-standard-gpio-calls
+++ a/drivers/video/omap/lcd_osk.c
@@ -29,6 +29,7 @@
 
 static int osk_panel_init(struct lcd_panel *panel, struct omapfb_device *fbdev)
 {
+	/* gpio2 was allocated in board init */
 	return 0;
 }
 
@@ -47,11 +48,8 @@ static int osk_panel_enable(struct lcd_p
 	/* Set PWL level */
 	omap_writeb(0xFF, OMAP_PWL_ENABLE);
 
-	/* configure GPIO2 as output */
-	omap_set_gpio_direction(2, 0);
-
-	/* set GPIO2 high */
-	omap_set_gpio_dataout(2, 1);
+	/* set GPIO2 high (lcd power enabled) */
+	gpio_set_value(2, 1);
 
 	return 0;
 }
@@ -65,7 +63,7 @@ static void osk_panel_disable(struct lcd
 	omap_writeb(0x00, OMAP_PWL_CLK_ENABLE);
 
 	/* set GPIO2 low */
-	omap_set_gpio_dataout(2, 0);
+	gpio_set_value(2, 0);
 }
 
 static unsigned long osk_panel_get_caps(struct lcd_panel *panel)
diff -puN drivers/video/omap/lcd_sx1.c~omap-drivers-switch-to-standard-gpio-calls drivers/video/omap/lcd_sx1.c
--- a/drivers/video/omap/lcd_sx1.c~omap-drivers-switch-to-standard-gpio-calls
+++ a/drivers/video/omap/lcd_sx1.c
@@ -81,21 +81,21 @@ static void epson_sendbyte(int flag, uns
 	int i, shifter = 0x80;
 
 	if (!flag)
-		omap_set_gpio_dataout(_A_LCD_SSC_A0, 0);
+		gpio_set_value(_A_LCD_SSC_A0, 0);
 	mdelay(2);
-	omap_set_gpio_dataout(A_LCD_SSC_RD, 1);
+	gpio_set_value(A_LCD_SSC_RD, 1);
 
-	omap_set_gpio_dataout(A_LCD_SSC_SD, flag);
+	gpio_set_value(A_LCD_SSC_SD, flag);
 
 	OMAP_MCBSP_WRITE(OMAP1510_MCBSP3_BASE, PCR0, 0x2200);
 	OMAP_MCBSP_WRITE(OMAP1510_MCBSP3_BASE, PCR0, 0x2202);
 	for (i = 0; i < 8; i++) {
 		OMAP_MCBSP_WRITE(OMAP1510_MCBSP3_BASE, PCR0, 0x2200);
-		omap_set_gpio_dataout(A_LCD_SSC_SD, shifter & byte);
+		gpio_set_value(A_LCD_SSC_SD, shifter & byte);
 		OMAP_MCBSP_WRITE(OMAP1510_MCBSP3_BASE, PCR0, 0x2202);
 		shifter >>= 1;
 	}
-	omap_set_gpio_dataout(_A_LCD_SSC_A0, 1);
+	gpio_set_value(_A_LCD_SSC_A0, 1);
 }
 
 static void init_system(void)
@@ -107,25 +107,18 @@ static void init_system(void)
 static void setup_GPIO(void)
 {
 	/* new wave */
-	omap_request_gpio(A_LCD_SSC_RD);
-	omap_request_gpio(A_LCD_SSC_SD);
-	omap_request_gpio(_A_LCD_RESET);
-	omap_request_gpio(_A_LCD_SSC_CS);
-	omap_request_gpio(_A_LCD_SSC_A0);
-
-	/* set all GPIOs to output */
-	omap_set_gpio_direction(A_LCD_SSC_RD, 0);
-	omap_set_gpio_direction(A_LCD_SSC_SD, 0);
-	omap_set_gpio_direction(_A_LCD_RESET, 0);
-	omap_set_gpio_direction(_A_LCD_SSC_CS, 0);
-	omap_set_gpio_direction(_A_LCD_SSC_A0, 0);
-
-	/* set GPIO data */
-	omap_set_gpio_dataout(A_LCD_SSC_RD, 1);
-	omap_set_gpio_dataout(A_LCD_SSC_SD, 0);
-	omap_set_gpio_dataout(_A_LCD_RESET, 0);
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 1);
-	omap_set_gpio_dataout(_A_LCD_SSC_A0, 1);
+	gpio_request(A_LCD_SSC_RD, "lcd_ssc_rd");
+	gpio_request(A_LCD_SSC_SD, "lcd_ssc_sd");
+	gpio_request(_A_LCD_RESET, "lcd_reset");
+	gpio_request(_A_LCD_SSC_CS, "lcd_ssc_cs");
+	gpio_request(_A_LCD_SSC_A0, "lcd_ssc_a0");
+
+	/* set GPIOs to output, with initial data */
+	gpio_direction_output(A_LCD_SSC_RD, 1);
+	gpio_direction_output(A_LCD_SSC_SD, 0);
+	gpio_direction_output(_A_LCD_RESET, 0);
+	gpio_direction_output(_A_LCD_SSC_CS, 1);
+	gpio_direction_output(_A_LCD_SSC_A0, 1);
 }
 
 static void display_init(void)
@@ -139,61 +132,61 @@ static void display_init(void)
 	mdelay(2);
 
 	/* reset LCD */
-	omap_set_gpio_dataout(A_LCD_SSC_SD, 1);
+	gpio_set_value(A_LCD_SSC_SD, 1);
 	epson_sendbyte(0, 0x25);
 
-	omap_set_gpio_dataout(_A_LCD_RESET, 0);
+	gpio_set_value(_A_LCD_RESET, 0);
 	mdelay(10);
-	omap_set_gpio_dataout(_A_LCD_RESET, 1);
+	gpio_set_value(_A_LCD_RESET, 1);
 
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 1);
+	gpio_set_value(_A_LCD_SSC_CS, 1);
 	mdelay(2);
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 0);
+	gpio_set_value(_A_LCD_SSC_CS, 0);
 
 	/* init LCD, phase 1 */
 	epson_sendbyte(0, 0xCA);
 	for (i = 0; i < 10; i++)
 		epson_sendbyte(1, INIT_1[i]);
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 1);
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 0);
+	gpio_set_value(_A_LCD_SSC_CS, 1);
+	gpio_set_value(_A_LCD_SSC_CS, 0);
 
 	/* init LCD phase 2 */
 	epson_sendbyte(0, 0xCB);
 	for (i = 0; i < 125; i++)
 		epson_sendbyte(1, INIT_2[i]);
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 1);
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 0);
+	gpio_set_value(_A_LCD_SSC_CS, 1);
+	gpio_set_value(_A_LCD_SSC_CS, 0);
 
 	/* init LCD phase 2a */
 	epson_sendbyte(0, 0xCC);
 	for (i = 0; i < 14; i++)
 		epson_sendbyte(1, INIT_3[i]);
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 1);
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 0);
+	gpio_set_value(_A_LCD_SSC_CS, 1);
+	gpio_set_value(_A_LCD_SSC_CS, 0);
 
 	/* init LCD phase 3 */
 	epson_sendbyte(0, 0xBC);
 	epson_sendbyte(1, 0x08);
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 1);
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 0);
+	gpio_set_value(_A_LCD_SSC_CS, 1);
+	gpio_set_value(_A_LCD_SSC_CS, 0);
 
 	/* init LCD phase 4 */
 	epson_sendbyte(0, 0x07);
 	epson_sendbyte(1, 0x05);
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 1);
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 0);
+	gpio_set_value(_A_LCD_SSC_CS, 1);
+	gpio_set_value(_A_LCD_SSC_CS, 0);
 
 	/* init LCD phase 5 */
 	epson_sendbyte(0, 0x94);
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 1);
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 0);
+	gpio_set_value(_A_LCD_SSC_CS, 1);
+	gpio_set_value(_A_LCD_SSC_CS, 0);
 
 	/* init LCD phase 6 */
 	epson_sendbyte(0, 0xC6);
 	epson_sendbyte(1, 0x80);
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 1);
+	gpio_set_value(_A_LCD_SSC_CS, 1);
 	mdelay(100); /* used to be 1000 */
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 0);
+	gpio_set_value(_A_LCD_SSC_CS, 0);
 
 	/* init LCD phase 7 */
 	epson_sendbyte(0, 0x16);
@@ -201,8 +194,8 @@ static void display_init(void)
 	epson_sendbyte(1, 0x00);
 	epson_sendbyte(1, 0xB1);
 	epson_sendbyte(1, 0x00);
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 1);
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 0);
+	gpio_set_value(_A_LCD_SSC_CS, 1);
+	gpio_set_value(_A_LCD_SSC_CS, 0);
 
 	/* init LCD phase 8 */
 	epson_sendbyte(0, 0x76);
@@ -210,12 +203,12 @@ static void display_init(void)
 	epson_sendbyte(1, 0x00);
 	epson_sendbyte(1, 0xDB);
 	epson_sendbyte(1, 0x00);
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 1);
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 0);
+	gpio_set_value(_A_LCD_SSC_CS, 1);
+	gpio_set_value(_A_LCD_SSC_CS, 0);
 
 	/* init LCD phase 9 */
 	epson_sendbyte(0, 0xAF);
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 1);
+	gpio_set_value(_A_LCD_SSC_CS, 1);
 }
 
 static int sx1_panel_init(struct lcd_panel *panel, struct omapfb_device *fbdev)
@@ -231,18 +224,18 @@ static void sx1_panel_disable(struct lcd
 {
 	printk(KERN_INFO "SX1: LCD panel disable\n");
 	sx1_setmmipower(0);
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 1);
+	gpio_set_value(_A_LCD_SSC_CS, 1);
 
 	epson_sendbyte(0, 0x25);
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 0);
+	gpio_set_value(_A_LCD_SSC_CS, 0);
 
 	epson_sendbyte(0, 0xAE);
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 1);
+	gpio_set_value(_A_LCD_SSC_CS, 1);
 	mdelay(100);
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 0);
+	gpio_set_value(_A_LCD_SSC_CS, 0);
 
 	epson_sendbyte(0, 0x95);
-	omap_set_gpio_dataout(_A_LCD_SSC_CS, 1);
+	gpio_set_value(_A_LCD_SSC_CS, 1);
 }
 
 static int sx1_panel_enable(struct lcd_panel *panel)
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
rtc-cmos-export-second-nvram-bank.patch
gpio-modify-sysfs-gpio-export-so-that-value-displays-as-0-or-1.patch
gpiolib-fix-oops-in-gpio_get_value_cansleep.patch

