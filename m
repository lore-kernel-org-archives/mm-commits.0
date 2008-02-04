From: akpm@linux-foundation.org
Subject: + gpio-handle-pca95345678-too.patch added to -mm tree
Date: Mon, 04 Feb 2008 14:45:20 -0800
Message-ID: <200802042245.m14MjKsH021663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45356 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755892AbYBDWpo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 17:45:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@pengutronix.de, dbrownell@users.sourceforge.net


The patch titled
     gpio: handle pca953{4,5,6,7,8} too
has been added to the -mm tree.  Its filename is
     gpio-handle-pca95345678-too.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: handle pca953{4,5,6,7,8} too
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

This third part of an extension to support more pca953x chips updates the
logic to handle the smaller register widths used by the 4-bit and 8-bit parts,
and to use the chip type to determine how many GPIOs it provides.

As long as we don't support interrupt and reset capabilities, those size
issues are the only software-visible differences between these parts.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pca953x.c |   73 +++++++++++++++++++++++++++++----------
 1 file changed, 55 insertions(+), 18 deletions(-)

diff -puN drivers/gpio/pca953x.c~gpio-handle-pca95345678-too drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~gpio-handle-pca95345678-too
+++ a/drivers/gpio/pca953x.c
@@ -1,5 +1,5 @@
 /*
- *  pca953x.c - 16-bit I/O port with interrupt and reset
+ *  pca953x.c - 4/8/16 bit I/O ports
  *
  *  Copyright (C) 2005 Ben Gardner <bgardner@wabtec.com>
  *  Copyright (C) 2007 Marvell International Ltd.
@@ -18,13 +18,26 @@
 
 #include <asm/gpio.h>
 
+#define PCA953X_INPUT          0
+#define PCA953X_OUTPUT         1
+#define PCA953X_INVERT         2
+#define PCA953X_DIRECTION      3
+
+/* This is temporary - in 2.6.26 i2c_driver_data should replace it. */
+struct pca953x_desc {
+	char		name[I2C_NAME_SIZE];
+	unsigned long	driver_data;
+};
 
-#define NR_PCA953X_GPIOS	16
-
-#define PCA953X_INPUT		0
-#define PCA953X_OUTPUT		2
-#define PCA953X_INVERT		4
-#define PCA953X_DIRECTION	6
+static const struct pca953x_desc pca953x_descs[] = {
+	{ "pca9534", 8, },
+	{ "pca9535", 16, },
+	{ "pca9536", 4, },
+	{ "pca9537", 4, },
+	{ "pca9538", 8, },
+	{ "pca9539", 16, },
+	/* REVISIT several pca955x parts should work here too */
+};
 
 struct pca953x_chip {
 	unsigned gpio_start;
@@ -40,17 +53,30 @@ struct pca953x_chip {
  */
 static int pca953x_write_reg(struct pca953x_chip *chip, int reg, uint16_t val)
 {
-	if (i2c_smbus_write_word_data(chip->client, reg, val) < 0)
-		return -EIO;
+	int ret;
+
+	if (chip->gpio_chip.ngpio <= 8)
+		ret = i2c_smbus_write_byte_data(chip->client, reg, val);
 	else
-		return 0;
+		ret = i2c_smbus_write_word_data(chip->client, reg << 1, val);
+
+	if (ret < 0) {
+		dev_err(&chip->client->dev, "failed writing register\n");
+		return -EIO;
+	}
+
+	return 0;
 }
 
 static int pca953x_read_reg(struct pca953x_chip *chip, int reg, uint16_t *val)
 {
 	int ret;
 
-	ret = i2c_smbus_read_word_data(chip->client, reg);
+	if (chip->gpio_chip.ngpio <= 8)
+		ret = i2c_smbus_read_byte_data(chip->client, reg);
+	else
+		ret = i2c_smbus_read_word_data(chip->client, reg << 1);
+
 	if (ret < 0) {
 		dev_err(&chip->client->dev, "failed reading register\n");
 		return -EIO;
@@ -148,7 +174,7 @@ static void pca953x_gpio_set_value(struc
 	chip->reg_output = reg_val;
 }
 
-static int pca953x_init_gpio(struct pca953x_chip *chip)
+static void pca953x_setup_gpio(struct pca953x_chip *chip, int gpios)
 {
 	struct gpio_chip *gc;
 
@@ -160,22 +186,30 @@ static int pca953x_init_gpio(struct pca9
 	gc->set = pca953x_gpio_set_value;
 
 	gc->base = chip->gpio_start;
-	gc->ngpio = NR_PCA953X_GPIOS;
-	gc->label = "pca953x";
-
-	return gpiochip_add(gc);
+	gc->ngpio = gpios;
+	gc->label = chip->client->name;
 }
 
 static int __devinit pca953x_probe(struct i2c_client *client)
 {
 	struct pca953x_platform_data *pdata;
 	struct pca953x_chip *chip;
-	int ret;
+	int ret, i;
+	const struct pca953x_desc *id = NULL;
 
 	pdata = client->dev.platform_data;
 	if (pdata == NULL)
 		return -ENODEV;
 
+	/* this loop vanishes when we get i2c_device_id */
+	for (i = 0; i < ARRAY_SIZE(pca953x_descs); i++)
+		if (!strcmp(pca953x_descs[i].name, client->name)) {
+			id = pca953x_descs + i;
+			break;
+		}
+	if (!id)
+		return -ENODEV;
+
 	chip = kzalloc(sizeof(struct pca953x_chip), GFP_KERNEL);
 	if (chip == NULL)
 		return -ENOMEM;
@@ -187,6 +221,8 @@ static int __devinit pca953x_probe(struc
 	/* initialize cached registers from their original values.
 	 * we can't share this chip with another i2c master.
 	 */
+	pca953x_setup_gpio(chip, id->driver_data);
+
 	ret = pca953x_read_reg(chip, PCA953X_OUTPUT, &chip->reg_output);
 	if (ret)
 		goto out_failed;
@@ -200,7 +236,8 @@ static int __devinit pca953x_probe(struc
 	if (ret)
 		goto out_failed;
 
-	ret = pca953x_init_gpio(chip);
+
+	ret = gpiochip_add(&chip->gpio_chip);
 	if (ret)
 		goto out_failed;
 
_

Patches currently in -mm which might be from g.liakhovetski@pengutronix.de are

git-dvb.patch
gpio-rename-pca9539-driver.patch
gpio-rename-pca953x-symbols.patch
gpio-handle-pca95345678-too.patch
