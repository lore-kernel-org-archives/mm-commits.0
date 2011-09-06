From: akpm@linux-foundation.org
Subject: + backlight-fix-broken-regulator-api-usage-in-l4f00242t03.patch added to -mm tree
Date: Tue, 06 Sep 2011 15:52:46 -0700
Message-ID: <201109062252.p86Mqknd009239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754868Ab1IFWxC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 18:53:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, fabio.estevam@freescale.com, rpurdie@rpsys.net


The patch titled
     backlight: fix broken regulator API usage in l4f00242t03
has been added to the -mm tree.  Its filename is
     backlight-fix-broken-regulator-api-usage-in-l4f00242t03.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: backlight: fix broken regulator API usage in l4f00242t03
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

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
@@ -53,15 +53,11 @@ static void l4f00242t03_lcd_init(struct 
 
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
 
@@ -79,11 +75,8 @@ static void l4f00242t03_lcd_powerdown(st
 
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
@@ -202,24 +195,18 @@ static int __devinit l4f00242t03_probe(s
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
@@ -239,11 +226,9 @@ static int __devinit l4f00242t03_probe(s
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
@@ -267,10 +252,8 @@ static int __devexit l4f00242t03_remove(
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

alpha-gpio-generic_gpio-default-must-be-n.patch
linux-next.patch
backlight-fix-broken-regulator-api-usage-in-l4f00242t03.patch
lis3lv02d-make-regulator-api-usage-unconditional.patch

