From: akpm@linux-foundation.org
Subject: + gpio-add-interrupt-handling-capability-to-max732x.patch added to -mm tree
Date: Fri, 19 Mar 2010 16:42:04 -0700
Message-ID: <201003192342.o2JNg4HO018932@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752301Ab0CSXmY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 19:42:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maz@misterjones.org, david-b@pacbell.net, eric.y.miao@gmail.com, jebediah.huang@gmail.com


The patch titled
     gpio: add interrupt handling capability to max732x
has been added to the -mm tree.  Its filename is
     gpio-add-interrupt-handling-capability-to-max732x.patch

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
Subject: gpio: add interrupt handling capability to max732x
From: Marc Zyngier <maz@misterjones.org>

Most of the GPIO expanders supported by the max732x driver have interrupt
generation capability by reporting changes on input pins through an INT#
pin.  This patch implements the irq_chip functionnality (edge detection
only).

Signed-off-by: Marc Zyngier <maz@misterjones.org>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Jebediah Huang <jebediah.huang@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig        |    7 
 drivers/gpio/max732x.c      |  355 ++++++++++++++++++++++++++++++++--
 include/linux/i2c/max732x.h |    3 
 3 files changed, 346 insertions(+), 19 deletions(-)

diff -puN drivers/gpio/Kconfig~gpio-add-interrupt-handling-capability-to-max732x drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-add-interrupt-handling-capability-to-max732x
+++ a/drivers/gpio/Kconfig
@@ -139,6 +139,13 @@ config GPIO_MAX732X
 	  Board setup code must specify the model to use, and the start
 	  number for these GPIOs.
 
+config GPIO_MAX732X_IRQ
+	bool "Interrupt controller support for MAX732x"
+	depends on GPIO_MAX732X=y && GENERIC_HARDIRQS
+	help
+	  Say yes here to enable the max732x to be used as an interrupt
+	  controller. It requires the driver to be built in the kernel.
+
 config GPIO_PCA953X
 	tristate "PCA953x, PCA955x, TCA64xx, and MAX7310 I/O ports"
 	depends on I2C
diff -puN drivers/gpio/max732x.c~gpio-add-interrupt-handling-capability-to-max732x drivers/gpio/max732x.c
--- a/drivers/gpio/max732x.c~gpio-add-interrupt-handling-capability-to-max732x
+++ a/drivers/gpio/max732x.c
@@ -17,7 +17,8 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/gpio.h>
-
+#include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/i2c.h>
 #include <linux/i2c/max732x.h>
 
@@ -31,7 +32,8 @@
  *   - Open Drain I/O
  *
  * designated by 'O', 'I' and 'P' individually according to MAXIM's
- * datasheets.
+ * datasheets. 'I' and 'P' ports are interrupt capables, some with
+ * a dedicated interrupt mask.
  *
  * There are two groups of I/O ports, each group usually includes
  * up to 8 I/O ports, and is accessed by a specific I2C address:
@@ -44,7 +46,8 @@
  *
  * Within each group of ports, there are five known combinations of
  * I/O ports: 4I4O, 4P4O, 8I, 8P, 8O, see the definitions below for
- * the detailed organization of these ports.
+ * the detailed organization of these ports. Only Goup A is interrupt
+ * capable.
  *
  * GPIO numbers start from 'gpio_base + 0' to 'gpio_base + 8/16',
  * and GPIOs from GROUP_A are numbered before those from GROUP_B
@@ -68,16 +71,47 @@
 #define GROUP_A(x)	((x) & 0xffff)	/* I2C Addr: 0b'110xxxx */
 #define GROUP_B(x)	((x) << 16)	/* I2C Addr: 0b'101xxxx */
 
+#define INT_NONE	0x0	/* No interrupt capability */
+#define INT_NO_MASK	0x1	/* Has interrupts, no mask */
+#define INT_INDEP_MASK	0x2	/* Has interrupts, independent mask */
+#define INT_MERGED_MASK 0x3	/* Has interrupts, merged mask */
+
+#define INT_CAPS(x)	(((uint64_t)(x)) << 32)
+
+enum {
+	MAX7319,
+	MAX7320,
+	MAX7321,
+	MAX7322,
+	MAX7323,
+	MAX7324,
+	MAX7325,
+	MAX7326,
+	MAX7327,
+};
+
+static uint64_t max732x_features[] = {
+	[MAX7319] = GROUP_A(IO_8I) | INT_CAPS(INT_MERGED_MASK),
+	[MAX7320] = GROUP_B(IO_8O),
+	[MAX7321] = GROUP_A(IO_8P) | INT_CAPS(INT_NO_MASK),
+	[MAX7322] = GROUP_A(IO_4I4O) | INT_CAPS(INT_MERGED_MASK),
+	[MAX7323] = GROUP_A(IO_4P4O) | INT_CAPS(INT_INDEP_MASK),
+	[MAX7324] = GROUP_A(IO_8I) | GROUP_B(IO_8O) | INT_CAPS(INT_MERGED_MASK),
+	[MAX7325] = GROUP_A(IO_8P) | GROUP_B(IO_8O) | INT_CAPS(INT_NO_MASK),
+	[MAX7326] = GROUP_A(IO_4I4O) | GROUP_B(IO_8O) | INT_CAPS(INT_MERGED_MASK),
+	[MAX7327] = GROUP_A(IO_4P4O) | GROUP_B(IO_8O) | INT_CAPS(INT_NO_MASK),
+};
+
 static const struct i2c_device_id max732x_id[] = {
-	{ "max7319", GROUP_A(IO_8I) },
-	{ "max7320", GROUP_B(IO_8O) },
-	{ "max7321", GROUP_A(IO_8P) },
-	{ "max7322", GROUP_A(IO_4I4O) },
-	{ "max7323", GROUP_A(IO_4P4O) },
-	{ "max7324", GROUP_A(IO_8I) | GROUP_B(IO_8O) },
-	{ "max7325", GROUP_A(IO_8P) | GROUP_B(IO_8O) },
-	{ "max7326", GROUP_A(IO_4I4O) | GROUP_B(IO_8O) },
-	{ "max7327", GROUP_A(IO_4P4O) | GROUP_B(IO_8O) },
+	{ "max7319", MAX7319 },
+	{ "max7320", MAX7320 },
+	{ "max7321", MAX7321 },
+	{ "max7322", MAX7322 },
+	{ "max7323", MAX7323 },
+	{ "max7324", MAX7324 },
+	{ "max7325", MAX7325 },
+	{ "max7326", MAX7326 },
+	{ "max7327", MAX7327 },
 	{ },
 };
 MODULE_DEVICE_TABLE(i2c, max732x_id);
@@ -96,9 +130,19 @@ struct max732x_chip {
 
 	struct mutex	lock;
 	uint8_t		reg_out[2];
+
+#ifdef CONFIG_GPIO_MAX732X_IRQ
+	struct mutex	irq_lock;
+	int		irq_base;
+	uint8_t		irq_mask;
+	uint8_t		irq_mask_cur;
+	uint8_t		irq_trig_raise;
+	uint8_t		irq_trig_fall;
+	uint8_t		irq_features;
+#endif
 };
 
-static int max732x_write(struct max732x_chip *chip, int group_a, uint8_t val)
+static int max732x_writeb(struct max732x_chip *chip, int group_a, uint8_t val)
 {
 	struct i2c_client *client;
 	int ret;
@@ -113,7 +157,7 @@ static int max732x_write(struct max732x_
 	return 0;
 }
 
-static int max732x_read(struct max732x_chip *chip, int group_a, uint8_t *val)
+static int max732x_readb(struct max732x_chip *chip, int group_a, uint8_t *val)
 {
 	struct i2c_client *client;
 	int ret;
@@ -142,7 +186,7 @@ static int max732x_gpio_get_value(struct
 
 	chip = container_of(gc, struct max732x_chip, gpio_chip);
 
-	ret = max732x_read(chip, is_group_a(chip, off), &reg_val);
+	ret = max732x_readb(chip, is_group_a(chip, off), &reg_val);
 	if (ret < 0)
 		return 0;
 
@@ -162,7 +206,7 @@ static void max732x_gpio_set_value(struc
 	reg_out = (off > 7) ? chip->reg_out[1] : chip->reg_out[0];
 	reg_out = (val) ? reg_out | mask : reg_out & ~mask;
 
-	ret = max732x_write(chip, is_group_a(chip, off), reg_out);
+	ret = max732x_writeb(chip, is_group_a(chip, off), reg_out);
 	if (ret < 0)
 		goto out;
 
@@ -209,12 +253,278 @@ static int max732x_gpio_direction_output
 	return 0;
 }
 
+#ifdef CONFIG_GPIO_MAX732X_IRQ
+static int max732x_writew(struct max732x_chip *chip, uint16_t val)
+{
+	int ret;
+
+	val = cpu_to_le16(val);
+
+	ret = i2c_master_send(chip->client_group_a, (char *)&val, 2);
+	if (ret < 0) {
+		dev_err(&chip->client_group_a->dev, "failed writing\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int max732x_readw(struct max732x_chip *chip, uint16_t *val)
+{
+	int ret;
+
+	ret = i2c_master_recv(chip->client_group_a, (char *)val, 2);
+	if (ret < 0) {
+		dev_err(&chip->client_group_a->dev, "failed reading\n");
+		return ret;
+	}
+
+	*val = le16_to_cpu(*val);
+	return 0;
+}
+
+static void max732x_irq_update_mask(struct max732x_chip *chip)
+{
+	uint16_t msg;
+
+	if (chip->irq_mask == chip->irq_mask_cur)
+		return;
+
+	chip->irq_mask = chip->irq_mask_cur;
+
+	if (chip->irq_features == INT_NO_MASK)
+		return;
+
+	mutex_lock(&chip->lock);
+
+	switch (chip->irq_features) {
+	case INT_INDEP_MASK:
+		msg = (chip->irq_mask << 8) | chip->reg_out[0];
+		max732x_writew(chip, msg);
+		break;
+
+	case INT_MERGED_MASK:
+		msg = chip->irq_mask | chip->reg_out[0];
+		max732x_writeb(chip, 1, (uint8_t)msg);
+		break;
+	}
+
+	mutex_unlock(&chip->lock);
+}
+
+static int max732x_gpio_to_irq(struct gpio_chip *gc, unsigned off)
+{
+	struct max732x_chip *chip;
+
+	chip = container_of(gc, struct max732x_chip, gpio_chip);
+	return chip->irq_base + off;
+}
+
+static void max732x_irq_mask(unsigned int irq)
+{
+	struct max732x_chip *chip = get_irq_chip_data(irq);
+
+	chip->irq_mask_cur &= ~(1 << (irq - chip->irq_base));
+}
+
+static void max732x_irq_unmask(unsigned int irq)
+{
+	struct max732x_chip *chip = get_irq_chip_data(irq);
+
+	chip->irq_mask_cur |= 1 << (irq - chip->irq_base);
+}
+
+static void max732x_irq_bus_lock(unsigned int irq)
+{
+	struct max732x_chip *chip = get_irq_chip_data(irq);
+
+	mutex_lock(&chip->irq_lock);
+	chip->irq_mask_cur = chip->irq_mask;
+}
+
+static void max732x_irq_bus_sync_unlock(unsigned int irq)
+{
+	struct max732x_chip *chip = get_irq_chip_data(irq);
+
+	max732x_irq_update_mask(chip);
+	mutex_unlock(&chip->irq_lock);
+}
+
+static int max732x_irq_set_type(unsigned int irq, unsigned int type)
+{
+	struct max732x_chip *chip = get_irq_chip_data(irq);
+	uint16_t off = irq - chip->irq_base;
+	uint16_t mask = 1 << off;
+
+	if (!(mask & chip->dir_input)) {
+		dev_dbg(&chip->client->dev, "%s port %d is output only\n",
+			chip->client->name, off);
+		return -EACCES;
+	}
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
+	return max732x_gpio_direction_input(&chip->gpio_chip, off);
+}
+
+static struct irq_chip max732x_irq_chip = {
+	.name			= "max732x",
+	.mask			= max732x_irq_mask,
+	.unmask			= max732x_irq_unmask,
+	.bus_lock		= max732x_irq_bus_lock,
+	.bus_sync_unlock	= max732x_irq_bus_sync_unlock,
+	.set_type		= max732x_irq_set_type,
+};
+
+static uint8_t max732x_irq_pending(struct max732x_chip *chip)
+{
+	uint8_t cur_stat;
+	uint8_t old_stat;
+	uint8_t trigger;
+	uint8_t pending;
+	uint16_t status;
+	int ret;
+
+	ret = max732x_readw(chip, &status);
+	if (ret)
+		return 0;
+
+	trigger = status >> 8;
+	trigger &= chip->irq_mask;
+
+	if (!trigger)
+		return 0;
+
+	cur_stat = status & 0xFF;
+	cur_stat &= chip->irq_mask;
+
+	old_stat = cur_stat ^ trigger;
+
+	pending = (old_stat & chip->irq_trig_fall) |
+		  (cur_stat & chip->irq_trig_raise);
+	pending &= trigger;
+
+	return pending;
+}
+
+static irqreturn_t max732x_irq_handler(int irq, void *devid)
+{
+	struct max732x_chip *chip = devid;
+	uint8_t pending;
+	uint8_t level;
+
+	pending = max732x_irq_pending(chip);
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
+static int max732x_irq_setup(struct max732x_chip *chip,
+			     const struct i2c_device_id *id)
+{
+	struct i2c_client *client = chip->client;
+	struct max732x_platform_data *pdata = client->dev.platform_data;
+	int has_irq = max732x_features[id->driver_data] >> 32;
+	int ret;
+
+	if (pdata->irq_base && has_irq != INT_NONE) {
+		int lvl;
+
+		chip->irq_base = pdata->irq_base;
+		chip->irq_features = has_irq;
+		mutex_init(&chip->irq_lock);
+
+		for (lvl = 0; lvl < chip->gpio_chip.ngpio; lvl++) {
+			int irq = lvl + chip->irq_base;
+
+			if (!(chip->dir_input & (1 << lvl)))
+				continue;
+
+			set_irq_chip_data(irq, chip);
+			set_irq_chip_and_handler(irq, &max732x_irq_chip,
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
+					   max732x_irq_handler,
+					   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+					   dev_name(&client->dev), chip);
+		if (ret) {
+			dev_err(&client->dev, "failed to request irq %d\n",
+				client->irq);
+			goto out_failed;
+		}
+
+		chip->gpio_chip.to_irq = max732x_gpio_to_irq;
+	}
+
+	return 0;
+
+out_failed:
+	chip->irq_base = 0;
+	return ret;
+}
+
+static void max732x_irq_teardown(struct max732x_chip *chip)
+{
+	if (chip->irq_base)
+		free_irq(chip->client->irq, chip);
+}
+#else /* CONFIG_GPIO_MAX732X_IRQ */
+static int max732x_irq_setup(struct max732x_chip *chip,
+			     const struct i2c_device_id *id)
+{
+	struct i2c_client *client = chip->client;
+	struct max732x_platform_data *pdata = client->dev.platform_data;
+	int has_irq = max732x_features[id->driver_data] >> 32;
+
+	if (pdata->irq_base && has_irq != INT_NONE)
+		dev_warn(&client->dev, "interrupt support not compiled in\n");
+
+	return 0;
+}
+
+static void max732x_irq_teardown(struct max732x_chip *chip)
+{
+}
+#endif
+
 static int __devinit max732x_setup_gpio(struct max732x_chip *chip,
 					const struct i2c_device_id *id,
 					unsigned gpio_start)
 {
 	struct gpio_chip *gc = &chip->gpio_chip;
-	uint32_t id_data = id->driver_data;
+	uint32_t id_data = (uint32_t)max732x_features[id->driver_data];
 	int i, port = 0;
 
 	for (i = 0; i < 16; i++, id_data >>= 2) {
@@ -306,9 +616,13 @@ static int __devinit max732x_probe(struc
 
 	mutex_init(&chip->lock);
 
-	max732x_read(chip, is_group_a(chip, 0), &chip->reg_out[0]);
+	max732x_readb(chip, is_group_a(chip, 0), &chip->reg_out[0]);
 	if (nr_port > 7)
-		max732x_read(chip, is_group_a(chip, 8), &chip->reg_out[1]);
+		max732x_readb(chip, is_group_a(chip, 8), &chip->reg_out[1]);
+
+	ret = max732x_irq_setup(chip, id);
+	if (ret)
+		goto out_failed;
 
 	ret = gpiochip_add(&chip->gpio_chip);
 	if (ret)
@@ -325,6 +639,7 @@ static int __devinit max732x_probe(struc
 	return 0;
 
 out_failed:
+	max732x_irq_teardown(chip);
 	kfree(chip);
 	return ret;
 }
@@ -352,6 +667,8 @@ static int __devexit max732x_remove(stru
 		return ret;
 	}
 
+	max732x_irq_teardown(chip);
+
 	/* unregister any dummy i2c_client */
 	if (chip->client_dummy)
 		i2c_unregister_device(chip->client_dummy);
diff -puN include/linux/i2c/max732x.h~gpio-add-interrupt-handling-capability-to-max732x include/linux/i2c/max732x.h
--- a/include/linux/i2c/max732x.h~gpio-add-interrupt-handling-capability-to-max732x
+++ a/include/linux/i2c/max732x.h
@@ -7,6 +7,9 @@ struct max732x_platform_data {
 	/* number of the first GPIO */
 	unsigned	gpio_base;
 
+	/* interrupt base */
+	int		irq_base;
+
 	void		*context;	/* param to setup/teardown */
 
 	int		(*setup)(struct i2c_client *client,
_

Patches currently in -mm which might be from maz@misterjones.org are

origin.patch
gpio-add-interrupt-handling-capability-to-max732x.patch

