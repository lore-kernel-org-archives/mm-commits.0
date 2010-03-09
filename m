From: akpm@linux-foundation.org
Subject: [merged] gpio-pca953xc-add-interrupt-handling-capability.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:11:20 -0800
Message-ID: <201003091911.o29JBKpm031733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753902Ab0CITMb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:12:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maz@misterjones.org, david-b@pacbell.net, eric.y.miao@gmail.com, haojian.zhuang@gmail.com, ncase@xes-inc.com, mm-commits@vger.kernel.org


The patch titled
     gpio: pca953x.c: add interrupt handling capability
has been removed from the -mm tree.  Its filename was
     gpio-pca953xc-add-interrupt-handling-capability.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: pca953x.c: add interrupt handling capability
From: Marc Zyngier <maz@misterjones.org>

Most of the GPIO expanders controlled by the pca953x driver are able to
report changes on the input pins through an *INT pin.

This patch implements the irq_chip functionality (edge detection only).

The driver has been tested on an Arcom Zeus.

[akpm@linux-foundation.org: the compiler does inlining for us nowadays]
Signed-off-by: Marc Zyngier <maz@misterjones.org>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Nate Case <ncase@xes-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig        |    7 
 drivers/gpio/pca953x.c      |  249 ++++++++++++++++++++++++++++++++--
 include/linux/i2c/pca953x.h |    3 
 3 files changed, 247 insertions(+), 12 deletions(-)

diff -puN drivers/gpio/Kconfig~gpio-pca953xc-add-interrupt-handling-capability drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-pca953xc-add-interrupt-handling-capability
+++ a/drivers/gpio/Kconfig
@@ -134,6 +134,13 @@ config GPIO_PCA953X
 	  This driver can also be built as a module.  If so, the module
 	  will be called pca953x.
 
+config GPIO_PCA953X_IRQ
+	bool "Interrupt controller support for PCA953x"
+	depends on GPIO_PCA953X=y
+	help
+	  Say yes here to enable the pca953x to be used as an interrupt
+	  controller. It requires the driver to be built in the kernel.
+
 config GPIO_PCF857X
 	tristate "PCF857x, PCA{85,96}7x, and MAX732[89] I2C GPIO expanders"
 	depends on I2C
diff -puN drivers/gpio/pca953x.c~gpio-pca953xc-add-interrupt-handling-capability drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~gpio-pca953xc-add-interrupt-handling-capability
+++ a/drivers/gpio/pca953x.c
@@ -14,6 +14,8 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/i2c.h>
 #include <linux/i2c/pca953x.h>
 #ifdef CONFIG_OF_GPIO
@@ -26,23 +28,28 @@
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
+	{ "max7312", 16 | PCA953X_INT, },
+	{ "max7313", 16 | PCA953X_INT, },
+	{ "max7315", 8  | PCA953X_INT, },
+	{ "pca6107", 8  | PCA953X_INT, },
+	{ "tca6408", 8  | PCA953X_INT, },
+	{ "tca6416", 16 | PCA953X_INT, },
 	/* NYET:  { "tca6424", 24, }, */
 	{ }
 };
@@ -53,6 +60,15 @@ struct pca953x_chip {
 	uint16_t reg_output;
 	uint16_t reg_direction;
 
+#ifdef CONFIG_GPIO_PCA953X_IRQ
+	struct mutex irq_lock;
+	uint16_t irq_mask;
+	uint16_t irq_stat;
+	uint16_t irq_trig_raise;
+	uint16_t irq_trig_fall;
+	int	 irq_base;
+#endif
+
 	struct i2c_client *client;
 	struct pca953x_platform_data *dyn_pdata;
 	struct gpio_chip gpio_chip;
@@ -202,6 +218,210 @@ static void pca953x_setup_gpio(struct pc
 	gc->names = chip->names;
 }
 
+#ifdef CONFIG_GPIO_PCA953X_IRQ
+static int pca953x_gpio_to_irq(struct gpio_chip *gc, unsigned off)
+{
+	struct pca953x_chip *chip;
+
+	chip = container_of(gc, struct pca953x_chip, gpio_chip);
+	return chip->irq_base + off;
+}
+
+static void pca953x_irq_mask(unsigned int irq)
+{
+	struct pca953x_chip *chip = get_irq_chip_data(irq);
+
+	chip->irq_mask &= ~(1 << (irq - chip->irq_base));
+}
+
+static void pca953x_irq_unmask(unsigned int irq)
+{
+	struct pca953x_chip *chip = get_irq_chip_data(irq);
+
+	chip->irq_mask |= 1 << (irq - chip->irq_base);
+}
+
+static void pca953x_irq_bus_lock(unsigned int irq)
+{
+	struct pca953x_chip *chip = get_irq_chip_data(irq);
+
+	mutex_lock(&chip->irq_lock);
+}
+
+static void pca953x_irq_bus_sync_unlock(unsigned int irq)
+{
+	struct pca953x_chip *chip = get_irq_chip_data(irq);
+
+	mutex_unlock(&chip->irq_lock);
+}
+
+static int pca953x_irq_set_type(unsigned int irq, unsigned int type)
+{
+	struct pca953x_chip *chip = get_irq_chip_data(irq);
+	uint16_t level = irq - chip->irq_base;
+	uint16_t mask = 1 << level;
+
+	if (!(type & IRQ_TYPE_EDGE_BOTH)) {
+		dev_err(&chip->client->dev, "irq %d: unsupported type %d\n",
+			irq, type);
+		return -EINVAL;
+	}
+
+	if (type & IRQ_TYPE_EDGE_FALLING)
+		chip->irq_trig_fall |= mask;
+	else
+		chip->irq_trig_fall &= ~mask;
+
+	if (type & IRQ_TYPE_EDGE_RISING)
+		chip->irq_trig_raise |= mask;
+	else
+		chip->irq_trig_raise &= ~mask;
+
+	return pca953x_gpio_direction_input(&chip->gpio_chip, level);
+}
+
+static struct irq_chip pca953x_irq_chip = {
+	.name			= "pca953x",
+	.mask			= pca953x_irq_mask,
+	.unmask			= pca953x_irq_unmask,
+	.bus_lock		= pca953x_irq_bus_lock,
+	.bus_sync_unlock	= pca953x_irq_bus_sync_unlock,
+	.set_type		= pca953x_irq_set_type,
+};
+
+static uint16_t pca953x_irq_pending(struct pca953x_chip *chip)
+{
+	uint16_t cur_stat;
+	uint16_t old_stat;
+	uint16_t pending;
+	uint16_t trigger;
+	int ret;
+
+	ret = pca953x_read_reg(chip, PCA953X_INPUT, &cur_stat);
+	if (ret)
+		return 0;
+
+	/* Remove output pins from the equation */
+	cur_stat &= chip->reg_direction;
+
+	old_stat = chip->irq_stat;
+	trigger = (cur_stat ^ old_stat) & chip->irq_mask;
+
+	if (!trigger)
+		return 0;
+
+	chip->irq_stat = cur_stat;
+
+	pending = (old_stat & chip->irq_trig_fall) |
+		  (cur_stat & chip->irq_trig_raise);
+	pending &= trigger;
+
+	return pending;
+}
+
+static irqreturn_t pca953x_irq_handler(int irq, void *devid)
+{
+	struct pca953x_chip *chip = devid;
+	uint16_t pending;
+	uint16_t level;
+
+	pending = pca953x_irq_pending(chip);
+
+	if (!pending)
+		return IRQ_HANDLED;
+
+	do {
+		level = __ffs(pending);
+		handle_nested_irq(level + chip->irq_base);
+
+		pending &= ~(1 << level);
+	} while (pending);
+
+	return IRQ_HANDLED;
+}
+
+static int pca953x_irq_setup(struct pca953x_chip *chip,
+			     const struct i2c_device_id *id)
+{
+	struct i2c_client *client = chip->client;
+	struct pca953x_platform_data *pdata = client->dev.platform_data;
+	int ret;
+
+	if (pdata->irq_base && (id->driver_data & PCA953X_INT)) {
+		int lvl;
+
+		ret = pca953x_read_reg(chip, PCA953X_INPUT,
+				       &chip->irq_stat);
+		if (ret)
+			goto out_failed;
+
+		/*
+		 * There is no way to know which GPIO line generated the
+		 * interrupt.  We have to rely on the previous read for
+		 * this purpose.
+		 */
+		chip->irq_stat &= chip->reg_direction;
+		chip->irq_base = pdata->irq_base;
+		mutex_init(&chip->irq_lock);
+
+		for (lvl = 0; lvl < chip->gpio_chip.ngpio; lvl++) {
+			int irq = lvl + chip->irq_base;
+
+			set_irq_chip_data(irq, chip);
+			set_irq_chip_and_handler(irq, &pca953x_irq_chip,
+						 handle_edge_irq);
+			set_irq_nested_thread(irq, 1);
+#ifdef CONFIG_ARM
+			set_irq_flags(irq, IRQF_VALID);
+#else
+			set_irq_noprobe(irq);
+#endif
+		}
+
+		ret = request_threaded_irq(client->irq,
+					   NULL,
+					   pca953x_irq_handler,
+					   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+					   dev_name(&client->dev), chip);
+		if (ret) {
+			dev_err(&client->dev, "failed to request irq %d\n",
+				client->irq);
+			goto out_failed;
+		}
+
+		chip->gpio_chip.to_irq = pca953x_gpio_to_irq;
+	}
+
+	return 0;
+
+out_failed:
+	chip->irq_base = 0;
+	return ret;
+}
+
+static void pca953x_irq_teardown(struct pca953x_chip *chip)
+{
+	if (chip->irq_base)
+		free_irq(chip->client->irq, chip);
+}
+#else /* CONFIG_GPIO_PCA953X_IRQ */
+static int pca953x_irq_setup(struct pca953x_chip *chip,
+			     const struct i2c_device_id *id)
+{
+	struct i2c_client *client = chip->client;
+	struct pca953x_platform_data *pdata = client->dev.platform_data;
+
+	if (pdata->irq_base && (id->driver_data & PCA953X_INT))
+		dev_warn(&client->dev, "interrupt support not compiled in\n");
+
+	return 0;
+}
+
+static void pca953x_irq_teardown(struct pca953x_chip *chip)
+{
+}
+#endif
+
 /*
  * Handlers for alternative sources of platform_data
  */
@@ -286,7 +506,7 @@ static int __devinit pca953x_probe(struc
 	/* initialize cached registers from their original values.
 	 * we can't share this chip with another i2c master.
 	 */
-	pca953x_setup_gpio(chip, id->driver_data);
+	pca953x_setup_gpio(chip, id->driver_data & PCA953X_GPIOS);
 
 	ret = pca953x_read_reg(chip, PCA953X_OUTPUT, &chip->reg_output);
 	if (ret)
@@ -301,6 +521,9 @@ static int __devinit pca953x_probe(struc
 	if (ret)
 		goto out_failed;
 
+	ret = pca953x_irq_setup(chip, id);
+	if (ret)
+		goto out_failed;
 
 	ret = gpiochip_add(&chip->gpio_chip);
 	if (ret)
@@ -317,6 +540,7 @@ static int __devinit pca953x_probe(struc
 	return 0;
 
 out_failed:
+	pca953x_irq_teardown(chip);
 	kfree(chip->dyn_pdata);
 	kfree(chip);
 	return ret;
@@ -345,6 +569,7 @@ static int pca953x_remove(struct i2c_cli
 		return ret;
 	}
 
+	pca953x_irq_teardown(chip);
 	kfree(chip->dyn_pdata);
 	kfree(chip);
 	return 0;
diff -puN include/linux/i2c/pca953x.h~gpio-pca953xc-add-interrupt-handling-capability include/linux/i2c/pca953x.h
--- a/include/linux/i2c/pca953x.h~gpio-pca953xc-add-interrupt-handling-capability
+++ a/include/linux/i2c/pca953x.h
@@ -13,6 +13,9 @@ struct pca953x_platform_data {
 	/* initial polarity inversion setting */
 	uint16_t	invert;
 
+	/* interrupt base */
+	int		irq_base;
+
 	void		*context;	/* param to setup/teardown */
 
 	int		(*setup)(struct i2c_client *client,
_

Patches currently in -mm which might be from maz@misterjones.org are

linux-next.patch
genirq-introduce-irqf_allow_nested-flag-for-request_irq.patch

