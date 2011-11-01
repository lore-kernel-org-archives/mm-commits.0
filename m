From: akpm@linux-foundation.org
Subject: [merged] backlight-fix-broken-regulator-api-usage-in-l4f00242t03.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:14:51 -0700
Message-ID: <201111012114.pA1LEpKQ008572@hpaq3.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16408 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVO7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:14:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, fabio.estevam@freescale.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: fix broken regulator API usage in l4f00242t03
has been removed from the -mm tree.  Its filename was
     backlight-fix-broken-regulator-api-usage-in-l4f00242t03.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: backlight: fix broken regulator API usage in l4f00242t03

The regulator support in the l4f00242t03 is very non-idiomatic.  Rather
than requesting the regulators based on the device name and the supply
names used by the device the driver requires boards to pass system
specific supply names around through platform data.  The driver also
conditionally requests the regulators based on this platform data, adding
unneeded conditional code to the driver.

Fix this by removing the platform data and converting to the standard
idiom, also updating all in tree users of the driver.  As no datasheet
appears to be available for the LCD I'm guessing the names for the
supplies based on the existing users and I've no ability to do anything
more than compile test.

The use of regulator_set_voltage() in the driver is also problematic,
since fixed voltages are required the expectation would be that the
voltages would be fixed in the constraints set by the machines rather than
manually configured by the driver, but is less problematic.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Tested-by: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-imx/mach-mx27_3ds.c     |    6 --
 arch/arm/mach-imx/mach-mx31_3ds.c     |    6 --
 drivers/video/backlight/l4f00242t03.c |   57 ++++++++----------------
 include/linux/spi/l4f00242t03.h       |    2 
 4 files changed, 24 insertions(+), 47 deletions(-)

diff -puN arch/arm/mach-imx/mach-mx27_3ds.c~backlight-fix-broken-regulator-api-usage-in-l4f00242t03 arch/arm/mach-imx/mach-mx27_3ds.c
--- a/arch/arm/mach-imx/mach-mx27_3ds.c~backlight-fix-broken-regulator-api-usage-in-l4f00242t03
+++ a/arch/arm/mach-imx/mach-mx27_3ds.c
@@ -241,7 +241,7 @@ static struct regulator_init_data gpo_in
 };
 
 static struct regulator_consumer_supply vmmc1_consumers[] = {
-	REGULATOR_SUPPLY("lcd_2v8", NULL),
+	REGULATOR_SUPPLY("vcore", "spi0.0"),
 };
 
 static struct regulator_init_data vmmc1_init = {
@@ -257,7 +257,7 @@ static struct regulator_init_data vmmc1_
 };
 
 static struct regulator_consumer_supply vgen_consumers[] = {
-	REGULATOR_SUPPLY("vdd_lcdio", NULL),
+	REGULATOR_SUPPLY("vdd", "spi0.0"),
 };
 
 static struct regulator_init_data vgen_init = {
@@ -348,8 +348,6 @@ static const struct imx_fb_platform_data
 static struct l4f00242t03_pdata mx27_3ds_lcd_pdata = {
 	.reset_gpio		= LCD_RESET,
 	.data_enable_gpio	= LCD_ENABLE,
-	.core_supply		= "lcd_2v8",
-	.io_supply		= "vdd_lcdio",
 };
 
 static struct spi_board_info mx27_3ds_spi_devs[] __initdata = {
diff -puN arch/arm/mach-imx/mach-mx31_3ds.c~backlight-fix-broken-regulator-api-usage-in-l4f00242t03 arch/arm/mach-imx/mach-mx31_3ds.c
--- a/arch/arm/mach-imx/mach-mx31_3ds.c~backlight-fix-broken-regulator-api-usage-in-l4f00242t03
+++ a/arch/arm/mach-imx/mach-mx31_3ds.c
@@ -285,8 +285,6 @@ static struct mx3fb_platform_data mx3fb_
 static struct l4f00242t03_pdata mx31_3ds_l4f00242t03_pdata = {
 	.reset_gpio		= IOMUX_TO_GPIO(MX31_PIN_LCS1),
 	.data_enable_gpio	= IOMUX_TO_GPIO(MX31_PIN_SER_RS),
-	.core_supply		= "lcd_2v8",
-	.io_supply		= "vdd_lcdio",
 };
 
 /*
@@ -411,7 +409,7 @@ static struct regulator_init_data vmmc2_
 };
 
 static struct regulator_consumer_supply vmmc1_consumers[] = {
-	REGULATOR_SUPPLY("lcd_2v8", NULL),
+	REGULATOR_SUPPLY("vcore", "spi0.0"),
 	REGULATOR_SUPPLY("cmos_2v8", "soc-camera-pdrv.0"),
 };
 
@@ -428,7 +426,7 @@ static struct regulator_init_data vmmc1_
 };
 
 static struct regulator_consumer_supply vgen_consumers[] = {
-	REGULATOR_SUPPLY("vdd_lcdio", NULL),
+	REGULATOR_SUPPLY("vdd", "spi0.0"),
 };
 
 static struct regulator_init_data vgen_init = {
diff -puN drivers/video/backlight/l4f00242t03.c~backlight-fix-broken-regulator-api-usage-in-l4f00242t03 drivers/video/backlight/l4f00242t03.c
--- a/drivers/video/backlight/l4f00242t03.c~backlight-fix-broken-regulator-api-usage-in-l4f00242t03
+++ a/drivers/video/backlight/l4f00242t03.c
@@ -52,15 +52,11 @@ static void l4f00242t03_lcd_init(struct 
 
 	dev_dbg(&spi->dev, "initializing LCD\n");
 
-	if (priv->io_reg) {
-		regulator_set_voltage(priv->io_reg, 1800000, 1800000);
-		regulator_enable(priv->io_reg);
-	}
+	regulator_set_voltage(priv->io_reg, 1800000, 1800000);
+	regulator_enable(priv->io_reg);
 
-	if (priv->core_reg) {
-		regulator_set_voltage(priv->core_reg, 2800000, 2800000);
-		regulator_enable(priv->core_reg);
-	}
+	regulator_set_voltage(priv->core_reg, 2800000, 2800000);
+	regulator_enable(priv->core_reg);
 
 	l4f00242t03_reset(pdata->reset_gpio);
 
@@ -78,11 +74,8 @@ static void l4f00242t03_lcd_powerdown(st
 
 	gpio_set_value(pdata->data_enable_gpio, 0);
 
-	if (priv->io_reg)
-		regulator_disable(priv->io_reg);
-
-	if (priv->core_reg)
-		regulator_disable(priv->core_reg);
+	regulator_disable(priv->io_reg);
+	regulator_disable(priv->core_reg);
 }
 
 static int l4f00242t03_lcd_power_get(struct lcd_device *ld)
@@ -201,24 +194,18 @@ static int __devinit l4f00242t03_probe(s
 	if (ret)
 		goto err3;
 
-	if (pdata->io_supply) {
-		priv->io_reg = regulator_get(NULL, pdata->io_supply);
-
-		if (IS_ERR(priv->io_reg)) {
-			pr_err("%s: Unable to get the IO regulator\n",
-								__func__);
-			goto err3;
-		}
+	priv->io_reg = regulator_get(&spi->dev, "vdd");
+	if (IS_ERR(priv->io_reg)) {
+		dev_err(&spi->dev, "%s: Unable to get the IO regulator\n",
+		       __func__);
+		goto err3;
 	}
 
-	if (pdata->core_supply) {
-		priv->core_reg = regulator_get(NULL, pdata->core_supply);
-
-		if (IS_ERR(priv->core_reg)) {
-			pr_err("%s: Unable to get the core regulator\n",
-								__func__);
-			goto err4;
-		}
+	priv->core_reg = regulator_get(&spi->dev, "vcore");
+	if (IS_ERR(priv->core_reg)) {
+		dev_err(&spi->dev, "%s: Unable to get the core regulator\n",
+		       __func__);
+		goto err4;
 	}
 
 	priv->ld = lcd_device_register("l4f00242t03",
@@ -238,11 +225,9 @@ static int __devinit l4f00242t03_probe(s
 	return 0;
 
 err5:
-	if (priv->core_reg)
-		regulator_put(priv->core_reg);
+	regulator_put(priv->core_reg);
 err4:
-	if (priv->io_reg)
-		regulator_put(priv->io_reg);
+	regulator_put(priv->io_reg);
 err3:
 	gpio_free(pdata->data_enable_gpio);
 err2:
@@ -266,10 +251,8 @@ static int __devexit l4f00242t03_remove(
 	gpio_free(pdata->data_enable_gpio);
 	gpio_free(pdata->reset_gpio);
 
-	if (priv->io_reg)
-		regulator_put(priv->io_reg);
-	if (priv->core_reg)
-		regulator_put(priv->core_reg);
+	regulator_put(priv->io_reg);
+	regulator_put(priv->core_reg);
 
 	kfree(priv);
 
diff -puN include/linux/spi/l4f00242t03.h~backlight-fix-broken-regulator-api-usage-in-l4f00242t03 include/linux/spi/l4f00242t03.h
--- a/include/linux/spi/l4f00242t03.h~backlight-fix-broken-regulator-api-usage-in-l4f00242t03
+++ a/include/linux/spi/l4f00242t03.h
@@ -24,8 +24,6 @@
 struct l4f00242t03_pdata {
 	unsigned int	reset_gpio;
 	unsigned int	data_enable_gpio;
-	const char 	*io_supply;	/* will be set to 1.8 V */
-	const char 	*core_supply;	/* will be set to 2.8 V */
 };
 
 #endif /* _INCLUDE_LINUX_SPI_L4F00242T03_H_ */
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

origin.patch
linux-next.patch

