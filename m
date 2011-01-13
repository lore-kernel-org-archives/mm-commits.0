From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-l4f00242t03c-full-implement-fb-power-states-for-this-lcd.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:03:32 -0800
Message-ID: <201101132006.p0DK6D5q029709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933646Ab1AMUTm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:19:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maramaopercheseimorto@gmail.com, axel.lin@gmail.com, marek.vasut@gmail.com, rpurdie@rpsys.net, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/video/backlight/l4f00242t03.c: full implement fb power states for this lcd
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-l4f00242t03c-full-implement-fb-power-states-for-this-lcd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/backlight/l4f00242t03.c: full implement fb power states for this lcd
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>

Complete the support of fb power states managing correctly the regulators
bound to this driver.

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Marek Vasut <marek.vasut@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/l4f00242t03.c |   97 ++++++++++++++++++------
 1 file changed, 75 insertions(+), 22 deletions(-)

diff -puN drivers/video/backlight/l4f00242t03.c~drivers-video-backlight-l4f00242t03c-full-implement-fb-power-states-for-this-lcd drivers/video/backlight/l4f00242t03.c
--- a/drivers/video/backlight/l4f00242t03.c~drivers-video-backlight-l4f00242t03c-full-implement-fb-power-states-for-this-lcd
+++ a/drivers/video/backlight/l4f00242t03.c
@@ -25,7 +25,7 @@
 struct l4f00242t03_priv {
 	struct spi_device	*spi;
 	struct lcd_device	*ld;
-	unsigned int lcd_on:1;
+	int lcd_state;
 	struct regulator *io_reg;
 	struct regulator *core_reg;
 };
@@ -67,6 +67,29 @@ static void l4f00242t03_lcd_init(struct 
 	spi_write(spi, (const u8 *)cmd, ARRAY_SIZE(cmd) * sizeof(u16));
 }
 
+static void l4f00242t03_lcd_powerdown(struct spi_device *spi)
+{
+	struct l4f00242t03_pdata *pdata = spi->dev.platform_data;
+	struct l4f00242t03_priv *priv = dev_get_drvdata(&spi->dev);
+
+	dev_dbg(&spi->dev, "Powering down LCD\n");
+
+	gpio_set_value(pdata->data_enable_gpio, 0);
+
+	if (priv->io_reg)
+		regulator_disable(priv->io_reg);
+
+	if (priv->core_reg)
+		regulator_disable(priv->core_reg);
+}
+
+static int l4f00242t03_lcd_power_get(struct lcd_device *ld)
+{
+	struct l4f00242t03_priv *priv = lcd_get_data(ld);
+
+	return priv->lcd_state;
+}
+
 static int l4f00242t03_lcd_power_set(struct lcd_device *ld, int power)
 {
 	struct l4f00242t03_priv *priv = lcd_get_data(ld);
@@ -79,35 +102,52 @@ static int l4f00242t03_lcd_power_set(str
 	const u16 disoff = 0x28;
 
 	if (power <= FB_BLANK_NORMAL) {
-		if (priv->lcd_on)
-			return 0;
-
-		dev_dbg(&spi->dev, "turning on LCD\n");
-
-		spi_write(spi, (const u8 *)&slpout, sizeof(u16));
-		msleep(60);
-		spi_write(spi, (const u8 *)&dison, sizeof(u16));
-
-		priv->lcd_on = 1;
+		if (priv->lcd_state <= FB_BLANK_NORMAL) {
+			/* Do nothing, the LCD is running */
+		} else if (priv->lcd_state < FB_BLANK_POWERDOWN) {
+			dev_dbg(&spi->dev, "Resuming LCD\n");
+
+			spi_write(spi, (const u8 *)&slpout, sizeof(u16));
+			msleep(60);
+			spi_write(spi, (const u8 *)&dison, sizeof(u16));
+		} else {
+			/* priv->lcd_state == FB_BLANK_POWERDOWN */
+			l4f00242t03_lcd_init(spi);
+			priv->lcd_state = FB_BLANK_VSYNC_SUSPEND;
+			l4f00242t03_lcd_power_set(priv->ld, power);
+		}
+	} else if (power < FB_BLANK_POWERDOWN) {
+		if (priv->lcd_state <= FB_BLANK_NORMAL) {
+			/* Send the display in standby */
+			dev_dbg(&spi->dev, "Standby the LCD\n");
+
+			spi_write(spi, (const u8 *)&disoff, sizeof(u16));
+			msleep(60);
+			spi_write(spi, (const u8 *)&slpin, sizeof(u16));
+		} else if (priv->lcd_state < FB_BLANK_POWERDOWN) {
+			/* Do nothing, the LCD is already in standby */
+		} else {
+			/* priv->lcd_state == FB_BLANK_POWERDOWN */
+			l4f00242t03_lcd_init(spi);
+			priv->lcd_state = FB_BLANK_UNBLANK;
+			l4f00242t03_lcd_power_set(ld, power);
+		}
 	} else {
-		if (!priv->lcd_on)
-			return 0;
-
-		dev_dbg(&spi->dev, "turning off LCD\n");
-
+		/* power == FB_BLANK_POWERDOWN */
+		/* Clear the screen before shutting down */
 		spi_write(spi, (const u8 *)&disoff, sizeof(u16));
 		msleep(60);
-		spi_write(spi, (const u8 *)&slpin, sizeof(u16));
-
-		priv->lcd_on = 0;
+		l4f00242t03_lcd_powerdown(spi);
 	}
 
+	priv->lcd_state = power;
+
 	return 0;
 }
 
 static struct lcd_ops l4f_ops = {
 	.set_power	= l4f00242t03_lcd_power_set,
-	.get_power	= NULL,
+	.get_power	= l4f00242t03_lcd_power_get,
 };
 
 static int __devinit l4f00242t03_probe(struct spi_device *spi)
@@ -187,7 +227,8 @@ static int __devinit l4f00242t03_probe(s
 	/* Init the LCD */
 	l4f00242t03_reset(pdata->reset_gpio);
 	l4f00242t03_lcd_init(spi);
-	l4f00242t03_lcd_power_set(priv->ld, 1);
+	priv->lcd_state = FB_BLANK_VSYNC_SUSPEND;
+	l4f00242t03_lcd_power_set(priv->ld, FB_BLANK_UNBLANK);
 
 	dev_info(&spi->dev, "Epson l4f00242t03 lcd probed.\n");
 
@@ -214,9 +255,11 @@ static int __devexit l4f00242t03_remove(
 	struct l4f00242t03_priv *priv = dev_get_drvdata(&spi->dev);
 	struct l4f00242t03_pdata *pdata = priv->spi->dev.platform_data;
 
-	l4f00242t03_lcd_power_set(priv->ld, 0);
+	l4f00242t03_lcd_power_set(priv->ld, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(priv->ld);
 
+	dev_set_drvdata(&spi->dev, NULL);
+
 	gpio_free(pdata->data_enable_gpio);
 	gpio_free(pdata->reset_gpio);
 
@@ -230,6 +273,15 @@ static int __devexit l4f00242t03_remove(
 	return 0;
 }
 
+static void l4f00242t03_shutdown(struct spi_device *spi)
+{
+	struct l4f00242t03_priv *priv = dev_get_drvdata(&spi->dev);
+
+	if (priv)
+		l4f00242t03_lcd_power_set(priv->ld, FB_BLANK_POWERDOWN);
+
+}
+
 static struct spi_driver l4f00242t03_driver = {
 	.driver = {
 		.name	= "l4f00242t03",
@@ -237,6 +289,7 @@ static struct spi_driver l4f00242t03_dri
 	},
 	.probe		= l4f00242t03_probe,
 	.remove		= __devexit_p(l4f00242t03_remove),
+	.shutdown	= l4f00242t03_shutdown,
 };
 
 static __init int l4f00242t03_init(void)
_

Patches currently in -mm which might be from maramaopercheseimorto@gmail.com are

origin.patch
linux-next.patch

