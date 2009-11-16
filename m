From: akpm@linux-foundation.org
Subject: + drivers-gpio-pca953xc-add-interrupt-handling-capability.patch added to -mm tree
Date: Mon, 16 Nov 2009 15:47:40 -0800
Message-ID: <200911162347.nAGNlelr008388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754564AbZKPXr4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Nov 2009 18:47:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maz@misterjones.org, david-b@pacbell.net, eric.y.miao@gmail.com


The patch titled
     drivers/gpio/pca953x.c: add interrupt handling capability
has been added to the -mm tree.  Its filename is
     drivers-gpio-pca953xc-add-interrupt-handling-capability.patch

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
Subject: drivers/gpio/pca953x.c: add interrupt handling capability
From: Marc Zyngier <maz@misterjones.org>

Most of the GPIO expanders controlled by the pca953x driver are able to
report changes on the input pins through an *INT pin.

This patch implements a very basic way for the platform code to be alerted
when some input changes (both edge detection).  It can be seen as a poor
man irq_chip.

Alternatively, this could be turned into a full-fledged irq_chip, though
I'm not sure it is worth the complexity.

The driver has been tested on an Arcom Zeus.

Signed-off-by: Marc Zyngier <maz@misterjones.org>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pca953x.c      |   96 +++++++++++++++++++++++++++++-----
 include/linux/i2c/pca953x.h |    7 ++
 2 files changed, 89 insertions(+), 14 deletions(-)

diff -puN drivers/gpio/pca953x.c~drivers-gpio-pca953xc-add-interrupt-handling-capability drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~drivers-gpio-pca953xc-add-interrupt-handling-capability
+++ a/drivers/gpio/pca953x.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/gpio.h>
+#include <linux/interrupt.h>
 #include <linux/i2c.h>
 #include <linux/i2c/pca953x.h>
 #ifdef CONFIG_OF_GPIO
@@ -26,23 +27,27 @@
 #define PCA953X_INVERT         2
 #define PCA953X_DIRECTION      3
 
+#define PCA953X_GPIOS	       0x00FF
+#define PCA953X_INT	       0x0100
+
 static const struct i2c_device_id pca953x_id[] = {
-	{ "pca9534", 8, },
-	{ "pca9535", 16, },
+	{ "pca9534", 8  | PCA953X_INT, },
+	{ "pca9535", 16 | PCA953X_INT, },
 	{ "pca9536", 4, },
-	{ "pca9537", 4, },
-	{ "pca9538", 8, },
-	{ "pca9539", 16, },
-	{ "pca9554", 8, },
-	{ "pca9555", 16, },
+	{ "pca9537", 4  | PCA953X_INT, },
+	{ "pca9538", 8  | PCA953X_INT, },
+	{ "pca9539", 16 | PCA953X_INT, },
+	{ "pca9554", 8  | PCA953X_INT, },
+	{ "pca9555", 16 | PCA953X_INT, },
 	{ "pca9556", 8, },
 	{ "pca9557", 8, },
 
 	{ "max7310", 8, },
-	{ "max7315", 8, },
-	{ "pca6107", 8, },
-	{ "tca6408", 8, },
-	{ "tca6416", 16, },
+	{ "max7313", 16 | PCA953X_INT, },
+	{ "max7315", 8  | PCA953X_INT, },
+	{ "pca6107", 8  | PCA953X_INT, },
+	{ "tca6408", 8  | PCA953X_INT, },
+	{ "tca6416", 16 | PCA953X_INT, },
 	/* NYET:  { "tca6424", 24, }, */
 	{ }
 };
@@ -53,6 +58,11 @@ struct pca953x_chip {
 	uint16_t reg_output;
 	uint16_t reg_direction;
 
+	uint16_t int_mask;
+	uint16_t int_prev_input;
+	void (*interrupt)(uint16_t, uint16_t, void *);
+	void *context;
+
 	struct i2c_client *client;
 	struct pca953x_platform_data *dyn_pdata;
 	struct gpio_chip gpio_chip;
@@ -202,6 +212,34 @@ static void pca953x_setup_gpio(struct pc
 	gc->names = chip->names;
 }
 
+static irqreturn_t pca953x_irq_quick_handler(int irq, void *devid)
+{
+	/* Always happy to serve... */
+	return IRQ_WAKE_THREAD;
+}
+
+static irqreturn_t pca953x_irq_handler(int irq, void *devid)
+{
+	struct pca953x_chip *chip = devid;
+	uint16_t reg_val;
+	uint16_t mask;
+	int ret;
+
+	ret = pca953x_read_reg(chip, PCA953X_INPUT, &reg_val);
+	if (ret)
+		return IRQ_HANDLED;
+
+	reg_val &= (chip->int_mask & chip->reg_direction);
+	mask = reg_val ^ chip->int_prev_input;
+
+	if (mask) {
+		chip->int_prev_input = reg_val;
+		chip->interrupt(reg_val, mask, chip->context);
+	}
+
+	return IRQ_HANDLED;
+}
+
 /*
  * Handlers for alternative sources of platform_data
  */
@@ -286,7 +324,7 @@ static int __devinit pca953x_probe(struc
 	/* initialize cached registers from their original values.
 	 * we can't share this chip with another i2c master.
 	 */
-	pca953x_setup_gpio(chip, id->driver_data);
+	pca953x_setup_gpio(chip, id->driver_data & PCA953X_GPIOS);
 
 	ret = pca953x_read_reg(chip, PCA953X_OUTPUT, &chip->reg_output);
 	if (ret)
@@ -301,10 +339,39 @@ static int __devinit pca953x_probe(struc
 	if (ret)
 		goto out_failed;
 
+	if (pdata->interrupt && (id->driver_data & PCA953X_INT)) {
+		ret = pca953x_read_reg(chip, PCA953X_INPUT,
+				       &chip->int_prev_input);
+		if (ret)
+			goto out_failed;
+
+		chip->interrupt = pdata->interrupt;
+		chip->int_mask = pdata->mask;
+
+		/*
+		 * There is no way to know which GPIO line generated the
+		 * interrupt.  We have to rely on the previous read for
+		 * this purpose.
+		 */
+		chip->int_prev_input &= chip->int_mask & chip->reg_direction;
+
+		ret = request_threaded_irq(client->irq,
+					   pca953x_irq_quick_handler,
+					   pca953x_irq_handler, 0,
+					   dev_name(&client->dev), chip);
+		if (ret) {
+			dev_err(&client->dev, "failed to request irq %d\n",
+				client->irq);
+			goto out_failed;
+		}
+	}
 
 	ret = gpiochip_add(&chip->gpio_chip);
-	if (ret)
+	if (ret) {
+		if (pdata->interrupt)
+			free_irq(client->irq, chip);
 		goto out_failed;
+	}
 
 	if (pdata->setup) {
 		ret = pdata->setup(client, chip->gpio_chip.base,
@@ -345,6 +412,9 @@ static int pca953x_remove(struct i2c_cli
 		return ret;
 	}
 
+	if (chip->interrupt)
+		free_irq(client->irq, chip);
+
 	kfree(chip->dyn_pdata);
 	kfree(chip);
 	return 0;
diff -puN include/linux/i2c/pca953x.h~drivers-gpio-pca953xc-add-interrupt-handling-capability include/linux/i2c/pca953x.h
--- a/include/linux/i2c/pca953x.h~drivers-gpio-pca953xc-add-interrupt-handling-capability
+++ a/include/linux/i2c/pca953x.h
@@ -7,7 +7,10 @@ struct pca953x_platform_data {
 	/* initial polarity inversion setting */
 	uint16_t	invert;
 
-	void		*context;	/* param to setup/teardown */
+	/* input bitmask to trigger the interrupt callback */
+	uint16_t	mask;
+
+	void		*context;	/* param to setup/teardown/interrupt */
 
 	int		(*setup)(struct i2c_client *client,
 				unsigned gpio, unsigned ngpio,
@@ -15,5 +18,7 @@ struct pca953x_platform_data {
 	int		(*teardown)(struct i2c_client *client,
 				unsigned gpio, unsigned ngpio,
 				void *context);
+	void		(*interrupt)(uint16_t val, uint16_t mask,
+				void *context);
 	char		**names;
 };
_

Patches currently in -mm which might be from maz@misterjones.org are

linux-next.patch
drivers-gpio-pca953xc-add-interrupt-handling-capability.patch

