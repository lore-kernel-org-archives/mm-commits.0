From: akpm@linux-foundation.org
Subject: [merged] drivers-gpio-pca953xc-add-a-mutex-to-fix-race-condition.patch removed from -mm tree
Date: Mon, 14 Feb 2011 12:19:22 -0800
Message-ID: <201102142019.p1EKJMbD022983@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751129Ab1BNUT5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Feb 2011 15:19:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stigge@antcom.de, bgardner@wabtec.com, eric.y.miao@gmail.com, grant.likely@secretlab.ca, maz@misterjones.org, mm-commits@vger.kernel.org


The patch titled
     drivers/gpio/pca953x.c: add a mutex to fix race condition
has been removed from the -mm tree.  Its filename was
     drivers-gpio-pca953xc-add-a-mutex-to-fix-race-condition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/gpio/pca953x.c: add a mutex to fix race condition
From: Roland Stigge <stigge@antcom.de>

Add a mutex to register communication and handling.  Without the mutex,
GPIOs didn't switch as expected when toggled in a fast sequence of status
changes of multiple outputs.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Marc Zyngier <maz@misterjones.org>
Cc: Ben Gardner <bgardner@wabtec.com>
Cc: eric miao <eric.y.miao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pca953x.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff -puN drivers/gpio/pca953x.c~drivers-gpio-pca953xc-add-a-mutex-to-fix-race-condition drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~drivers-gpio-pca953xc-add-a-mutex-to-fix-race-condition
+++ a/drivers/gpio/pca953x.c
@@ -60,6 +60,7 @@ struct pca953x_chip {
 	unsigned gpio_start;
 	uint16_t reg_output;
 	uint16_t reg_direction;
+	struct mutex i2c_lock;
 
 #ifdef CONFIG_GPIO_PCA953X_IRQ
 	struct mutex irq_lock;
@@ -119,13 +120,17 @@ static int pca953x_gpio_direction_input(
 
 	chip = container_of(gc, struct pca953x_chip, gpio_chip);
 
+	mutex_lock(&chip->i2c_lock);
 	reg_val = chip->reg_direction | (1u << off);
 	ret = pca953x_write_reg(chip, PCA953X_DIRECTION, reg_val);
 	if (ret)
-		return ret;
+		goto exit;
 
 	chip->reg_direction = reg_val;
-	return 0;
+	ret = 0;
+exit:
+	mutex_unlock(&chip->i2c_lock);
+	return ret;
 }
 
 static int pca953x_gpio_direction_output(struct gpio_chip *gc,
@@ -137,6 +142,7 @@ static int pca953x_gpio_direction_output
 
 	chip = container_of(gc, struct pca953x_chip, gpio_chip);
 
+	mutex_lock(&chip->i2c_lock);
 	/* set output level */
 	if (val)
 		reg_val = chip->reg_output | (1u << off);
@@ -145,7 +151,7 @@ static int pca953x_gpio_direction_output
 
 	ret = pca953x_write_reg(chip, PCA953X_OUTPUT, reg_val);
 	if (ret)
-		return ret;
+		goto exit;
 
 	chip->reg_output = reg_val;
 
@@ -153,10 +159,13 @@ static int pca953x_gpio_direction_output
 	reg_val = chip->reg_direction & ~(1u << off);
 	ret = pca953x_write_reg(chip, PCA953X_DIRECTION, reg_val);
 	if (ret)
-		return ret;
+		goto exit;
 
 	chip->reg_direction = reg_val;
-	return 0;
+	ret = 0;
+exit:
+	mutex_unlock(&chip->i2c_lock);
+	return ret;
 }
 
 static int pca953x_gpio_get_value(struct gpio_chip *gc, unsigned off)
@@ -167,7 +176,9 @@ static int pca953x_gpio_get_value(struct
 
 	chip = container_of(gc, struct pca953x_chip, gpio_chip);
 
+	mutex_lock(&chip->i2c_lock);
 	ret = pca953x_read_reg(chip, PCA953X_INPUT, &reg_val);
+	mutex_unlock(&chip->i2c_lock);
 	if (ret < 0) {
 		/* NOTE:  diagnostic already emitted; that's all we should
 		 * do unless gpio_*_value_cansleep() calls become different
@@ -187,6 +198,7 @@ static void pca953x_gpio_set_value(struc
 
 	chip = container_of(gc, struct pca953x_chip, gpio_chip);
 
+	mutex_lock(&chip->i2c_lock);
 	if (val)
 		reg_val = chip->reg_output | (1u << off);
 	else
@@ -194,9 +206,11 @@ static void pca953x_gpio_set_value(struc
 
 	ret = pca953x_write_reg(chip, PCA953X_OUTPUT, reg_val);
 	if (ret)
-		return;
+		goto exit;
 
 	chip->reg_output = reg_val;
+exit:
+	mutex_unlock(&chip->i2c_lock);
 }
 
 static void pca953x_setup_gpio(struct pca953x_chip *chip, int gpios)
@@ -517,6 +531,8 @@ static int __devinit pca953x_probe(struc
 
 	chip->names = pdata->names;
 
+	mutex_init(&chip->i2c_lock);
+
 	/* initialize cached registers from their original values.
 	 * we can't share this chip with another i2c master.
 	 */
_

Patches currently in -mm which might be from stigge@antcom.de are

origin.patch
linux-next.patch

