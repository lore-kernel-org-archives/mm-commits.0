From: akpm@linux-foundation.org
Subject: [folded] gpio-driver-for-primecell-pl061-gpio-controller-v4.patch removed from -mm tree
Date: Wed, 17 Jun 2009 15:45:37 -0700
Message-ID: <200906172245.n5HMjbsF005924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33090 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761731AbZFQWrF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 18:47:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baruch@tkos.co.il, david-b@pacbell.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     gpio-driver-for-primecell-pl061-gpio-controller-v4
has been removed from the -mm tree.  Its filename was
     gpio-driver-for-primecell-pl061-gpio-controller-v4.patch

This patch was dropped because it was folded into gpio-driver-for-primecell-pl061-gpio-controller.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio-driver-for-primecell-pl061-gpio-controller-v4
From: Baruch Siach <baruch@tkos.co.il>

	- Depend on CONFIG_ARM_AMBA
	- Do not request the gpio for IRQ automatically, just warn if it's not
	  requested
	- Remove SZ_4K
	- Iterate through a linked list find the source of interrupt when
	  multiple PL061s are connected to the same IRQ trigger
	- Move hardware register defines into the .c file

Cc: David Brownell <david-b@pacbell.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig       |    1 
 drivers/gpio/pl061.c       |   92 ++++++++++++++++-------------------
 include/linux/amba/pl061.h |   19 +++----
 3 files changed, 54 insertions(+), 58 deletions(-)

diff -puN drivers/gpio/Kconfig~gpio-driver-for-primecell-pl061-gpio-controller-v4 drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-driver-for-primecell-pl061-gpio-controller-v4
+++ a/drivers/gpio/Kconfig
@@ -69,6 +69,7 @@ comment "Memory mapped GPIO expanders:"
 
 config GPIO_PL061
 	bool "PrimeCell PL061 GPIO support"
+	depends on ARM_AMBA
 	help
 	  Say yes here to support the PrimeCell PL061 GPIO device
 
diff -puN drivers/gpio/pl061.c~gpio-driver-for-primecell-pl061-gpio-controller-v4 drivers/gpio/pl061.c
--- a/drivers/gpio/pl061.c~gpio-driver-for-primecell-pl061-gpio-controller-v4
+++ a/drivers/gpio/pl061.c
@@ -14,6 +14,7 @@
 #include <linux/spinlock.h>
 #include <linux/errno.h>
 #include <linux/module.h>
+#include <linux/list.h>
 #include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/irq.h>
@@ -24,9 +25,22 @@
 #include <linux/amba/bus.h>
 #include <linux/amba/pl061.h>
 
+#define GPIODIR 0x400
+#define GPIOIS  0x404
+#define GPIOIBE 0x408
+#define GPIOIEV 0x40C
+#define GPIOIE  0x410
+#define GPIORIS 0x414
+#define GPIOMIS 0x418
+#define GPIOIC  0x41C
+
 #define PL061_GPIO_NR	8
 
+#define PL061_REG_SIZE	(4*1024)
+
 struct pl061_gpio {
+	struct list_head	list;
+
 	/* Each of the two spinlocks protects a different set of hardware
 	 * regiters and data structurs. This decouples the code of the IRQ from
 	 * the GPIO code. This also makes the case of a GPIO routine call from
@@ -37,12 +51,8 @@ struct pl061_gpio {
 
 	void __iomem		*base;
 	struct gpio_chip	gc;
-	struct work_struct	gpio_free_work;
-	DECLARE_BITMAP(gpios_to_free, PL061_GPIO_NR);
 };
 
-static u32 (*pl061_pending_irq)(int irq);
-
 static int pl061_direction_input(struct gpio_chip *gc, unsigned offset)
 {
 	struct pl061_gpio *chip = container_of(gc, struct pl061_gpio, gc);
@@ -112,16 +122,6 @@ static void pl061_irq_disable(unsigned i
 	spin_unlock_irqrestore(&chip->irq_lock, flags);
 }
 
-static void pl061_irq_shutdown(unsigned irq)
-{
-	struct pl061_gpio *chip = get_irq_chip_data(irq);
-	int offset = irq_to_gpio(irq) - chip->gc.base;
-
-	pl061_irq_disable(irq);
-	set_bit(offset, chip->gpios_to_free);
-	schedule_work(&chip->gpio_free_work);
-}
-
 static void pl061_irq_enable(unsigned irq)
 {
 	struct pl061_gpio *chip = get_irq_chip_data(irq);
@@ -138,16 +138,10 @@ static void pl061_irq_enable(unsigned ir
 
 static unsigned int pl061_irq_startup(unsigned irq)
 {
-	int ret;
-
-	ret = gpio_request(irq_to_gpio(irq), "IRQ");
-	if (ret < 0) {
-		pr_warning("%s: warning: gpio_request(%d) returned %d\n",
-				__func__, irq_to_gpio(irq), ret);
-		return 0;
-	}
+	if (gpio_request(irq_to_gpio(irq), "IRQ") == 0)
+		pr_warning("%s: warning: GPIO%d has not been requested\n",
+				__func__, irq_to_gpio(irq));
 
-	gpio_direction_input(irq_to_gpio(irq));
 	pl061_irq_enable(irq);
 
 	return 0;
@@ -202,45 +196,38 @@ static struct irq_chip pl061_irqchip = {
 	.startup	= pl061_irq_startup,
 	.enable		= pl061_irq_enable,
 	.disable	= pl061_irq_disable,
-	.shutdown	= pl061_irq_shutdown,
 	.set_type	= pl061_irq_type,
 };
 
 static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
 {
+	struct list_head *chip_list = get_irq_chip_data(irq);
+	struct list_head *ptr;
+	struct pl061_gpio *chip;
+
 	desc->chip->ack(irq);
-	while (1) {
+	list_for_each(ptr, chip_list) {
 		unsigned long pending;
 		int gpio;
 
-		pending = pl061_pending_irq(irq);
+		chip = list_entry(ptr, struct pl061_gpio, list);
+		pending = readb(chip->base + GPIOMIS);
+		writeb(pending, chip->base + GPIOIC);
+
 		if (pending == 0)
-			break;
+			continue;
 
-		for_each_bit(gpio, &pending, BITS_PER_LONG)
+		for_each_bit(gpio, &pending, PL061_GPIO_NR)
 			generic_handle_irq(gpio_to_irq(gpio));
 	}
 	desc->chip->unmask(irq);
 }
 
-static void pl061_gpio_free(struct work_struct *work)
-{
-	struct pl061_gpio *chip = container_of(work, struct pl061_gpio,
-			gpio_free_work);
-	int offset;
-
-	for_each_bit(offset, chip->gpios_to_free, PL061_GPIO_NR) {
-		int gpio = offset + chip->gc.base;
-
-		if (test_and_clear_bit(offset, chip->gpios_to_free))
-			gpio_free(gpio);
-	}
-}
-
 static int __init pl061_probe(struct amba_device *dev, struct amba_id *id)
 {
 	struct pl061_platform_data *pdata;
 	struct pl061_gpio *chip;
+	struct list_head *chip_list;
 	int ret, irq, i;
 
 	pdata = dev->dev.platform_data;
@@ -251,12 +238,12 @@ static int __init pl061_probe(struct amb
 	if (chip == NULL)
 		return -ENOMEM;
 
-	if (request_mem_region(dev->res.start, SZ_4K, "pl061") == NULL) {
+	if (!request_mem_region(dev->res.start, PL061_REG_SIZE, "pl061")) {
 		ret = -EBUSY;
 		goto free_mem;
 	}
 
-	chip->base = ioremap(dev->res.start, SZ_4K);
+	chip->base = ioremap(dev->res.start, PL061_REG_SIZE);
 	if (chip->base == NULL) {
 		ret = -ENOMEM;
 		goto release_region;
@@ -264,8 +251,7 @@ static int __init pl061_probe(struct amb
 
 	spin_lock_init(&chip->lock);
 	spin_lock_init(&chip->irq_lock);
-
-	INIT_WORK(&chip->gpio_free_work, pl061_gpio_free);
+	INIT_LIST_HEAD(&chip->list);
 
 	chip->gc.direction_input = pl061_direction_input;
 	chip->gc.direction_output = pl061_direction_output;
@@ -291,7 +277,17 @@ static int __init pl061_probe(struct amb
 		goto iounmap;
 	}
 	set_irq_chained_handler(irq, pl061_irq_handler);
-	pl061_pending_irq = pdata->pending_irqs;
+	if (!pdata->is_irq_initialized || !pdata->is_irq_initialized(irq)) {
+		chip_list = kmalloc(sizeof(*chip_list), GFP_KERNEL);
+		if (chip_list == NULL) {
+			ret = -ENOMEM;
+			goto iounmap;
+		}
+		INIT_LIST_HEAD(chip_list);
+		set_irq_chip_data(irq, chip_list);
+	} else
+		chip_list = get_irq_chip_data(irq);
+	list_add(&chip->list, chip_list);
 
 	for (i = 0; i < PL061_GPIO_NR; i++) {
 		if (pdata->directions & (1 << i))
@@ -312,7 +308,7 @@ static int __init pl061_probe(struct amb
 iounmap:
 	iounmap(chip->base);
 release_region:
-	release_mem_region(dev->res.start, SZ_4K);
+	release_mem_region(dev->res.start, PL061_REG_SIZE);
 free_mem:
 	kfree(chip);
 
diff -puN include/linux/amba/pl061.h~gpio-driver-for-primecell-pl061-gpio-controller-v4 include/linux/amba/pl061.h
--- a/include/linux/amba/pl061.h~gpio-driver-for-primecell-pl061-gpio-controller-v4
+++ a/include/linux/amba/pl061.h
@@ -1,18 +1,17 @@
 /* platform data for the PL061 GPIO driver */
 
-#define GPIODIR 0x400
-#define GPIOIS  0x404
-#define GPIOIBE 0x408
-#define GPIOIEV 0x40C
-#define GPIOIE  0x410
-#define GPIORIS 0x414
-#define GPIOMIS 0x418
-#define GPIOIC  0x41C
-
 struct pl061_platform_data {
 	/* number of the first GPIO */
 	unsigned	gpio_base;
-	u32		(*pending_irqs)(int irq);
+
 	u8		directions;	/* startup directions, 1: out, 0: in */
 	u8		values;		/* startup values */
+
+	/* This callback may be used when you have more than one PL061
+	 * connected to the same IRQ trigger. This callback must return 0 on
+	 * the first time it is called for each irq, and 1 on any other call.
+	 * In case you are not unfortunate enough to have this setup, this
+	 * pointer must be set to NULL.
+	 */
+	int		(*is_irq_initialized)(int irq);
 };
_

Patches currently in -mm which might be from baruch@tkos.co.il are

origin.patch
gpio-driver-for-primecell-pl061-gpio-controller.patch
gpio-driver-for-primecell-pl061-gpio-controller-v4.patch
gpio-driver-for-primecell-pl061-gpio-controller-v5.patch

