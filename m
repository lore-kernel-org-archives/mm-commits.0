From: akpm@linux-foundation.org
Subject: [folded] gpio-driver-for-primecell-pl061-gpio-controller-v6.patch removed from -mm tree
Date: Thu, 18 Jun 2009 16:43:46 -0700
Message-ID: <200906182343.n5INhlAo026661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754003AbZFRXpl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 19:45:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baruch@tkos.co.il, david-b@pacbell.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     gpio-driver-for-primecell-pl061-gpio-controller v6
has been removed from the -mm tree.  Its filename was
     gpio-driver-for-primecell-pl061-gpio-controller-v6.patch

This patch was dropped because it was folded into gpio-driver-for-primecell-pl061-gpio-controller.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio-driver-for-primecell-pl061-gpio-controller v6
From: Baruch Siach <baruch@tkos.co.il>

	- Address the comments of David Brownell:
	  * remove gpio_request() from the IRQ code
	  * remove irq_to_gpio() from the IRQ code
	- Use a bitmap to track initialized trigger IRQ

Cc: David Brownell <david-b@pacbell.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pl061.c       |   39 +++++++++++++++--------------------
 include/linux/amba/pl061.h |   14 +++++-------
 2 files changed, 23 insertions(+), 30 deletions(-)

diff -puN drivers/gpio/pl061.c~gpio-driver-for-primecell-pl061-gpio-controller-v6 drivers/gpio/pl061.c
--- a/drivers/gpio/pl061.c~gpio-driver-for-primecell-pl061-gpio-controller-v6
+++ a/drivers/gpio/pl061.c
@@ -53,6 +53,7 @@ struct pl061_gpio {
 	spinlock_t		irq_lock;	/* IRQ registers */
 
 	void __iomem		*base;
+	unsigned		irq_base;
 	struct gpio_chip	gc;
 };
 
@@ -114,7 +115,7 @@ static void pl061_set_value(struct gpio_
 static void pl061_irq_disable(unsigned irq)
 {
 	struct pl061_gpio *chip = get_irq_chip_data(irq);
-	int offset = irq_to_gpio(irq) - chip->gc.base;
+	int offset = irq - chip->irq_base;
 	unsigned long flags;
 	u8 gpioie;
 
@@ -128,7 +129,7 @@ static void pl061_irq_disable(unsigned i
 static void pl061_irq_enable(unsigned irq)
 {
 	struct pl061_gpio *chip = get_irq_chip_data(irq);
-	int offset = irq_to_gpio(irq) - chip->gc.base;
+	int offset = irq - chip->irq_base;
 	unsigned long flags;
 	u8 gpioie;
 
@@ -139,25 +140,14 @@ static void pl061_irq_enable(unsigned ir
 	spin_unlock_irqrestore(&chip->irq_lock, flags);
 }
 
-static unsigned int pl061_irq_startup(unsigned irq)
-{
-	if (gpio_request(irq_to_gpio(irq), "IRQ") == 0)
-		pr_warning("%s: warning: GPIO%d has not been requested\n",
-				__func__, irq_to_gpio(irq));
-
-	pl061_irq_enable(irq);
-
-	return 0;
-}
-
 static int pl061_irq_type(unsigned irq, unsigned trigger)
 {
 	struct pl061_gpio *chip = get_irq_chip_data(irq);
-	int offset = irq_to_gpio(irq) - chip->gc.base;
+	int offset = irq - chip->irq_base;
 	unsigned long flags;
 	u8 gpiois, gpioibe, gpioiev;
 
-	if (irq_to_gpio(irq) < 0)
+	if (offset < 0 || offset > PL061_GPIO_NR)
 		return -EINVAL;
 
 	spin_lock_irqsave(&chip->irq_lock, flags);
@@ -196,7 +186,6 @@ static int pl061_irq_type(unsigned irq, 
 
 static struct irq_chip pl061_irqchip = {
 	.name		= "GPIO",
-	.startup	= pl061_irq_startup,
 	.enable		= pl061_irq_enable,
 	.disable	= pl061_irq_disable,
 	.set_type	= pl061_irq_type,
@@ -232,6 +221,7 @@ static int __init pl061_probe(struct amb
 	struct pl061_gpio *chip;
 	struct list_head *chip_list;
 	int ret, irq, i;
+	static unsigned long init_irq[BITS_TO_LONGS(NR_IRQS)];
 
 	pdata = dev->dev.platform_data;
 	if (pdata == NULL)
@@ -267,6 +257,8 @@ static int __init pl061_probe(struct amb
 	chip->gc.dev = &dev->dev;
 	chip->gc.owner = THIS_MODULE;
 
+	chip->irq_base = pdata->irq_base;
+
 	ret = gpiochip_add(&chip->gc);
 	if (ret)
 		goto iounmap;
@@ -274,6 +266,10 @@ static int __init pl061_probe(struct amb
 	/*
 	 * irq_chip support
 	 */
+
+	if (chip->irq_base == (unsigned) -1)
+		return 0;
+
 	writeb(0, chip->base + GPIOIE); /* disable irqs */
 	irq = dev->irq[0];
 	if (irq < 0) {
@@ -281,7 +277,7 @@ static int __init pl061_probe(struct amb
 		goto iounmap;
 	}
 	set_irq_chained_handler(irq, pl061_irq_handler);
-	if (!pdata->is_irq_initialized || !pdata->is_irq_initialized(irq)) {
+	if (!test_and_set_bit(irq, init_irq)) { /* list initialized? */
 		chip_list = kmalloc(sizeof(*chip_list), GFP_KERNEL);
 		if (chip_list == NULL) {
 			ret = -ENOMEM;
@@ -300,11 +296,10 @@ static int __init pl061_probe(struct amb
 		else
 			pl061_direction_input(&chip->gc, i);
 
-		set_irq_chip(gpio_to_irq(i+pdata->gpio_base), &pl061_irqchip);
-		set_irq_handler(gpio_to_irq(i+pdata->gpio_base),
-				handle_simple_irq);
-		set_irq_flags(gpio_to_irq(i+pdata->gpio_base), IRQF_VALID);
-		set_irq_chip_data(gpio_to_irq(i+pdata->gpio_base), chip);
+		set_irq_chip(i+chip->irq_base, &pl061_irqchip);
+		set_irq_handler(i+chip->irq_base, handle_simple_irq);
+		set_irq_flags(i+chip->irq_base, IRQF_VALID);
+		set_irq_chip_data(i+chip->irq_base, chip);
 	}
 
 	return 0;
diff -puN include/linux/amba/pl061.h~gpio-driver-for-primecell-pl061-gpio-controller-v6 include/linux/amba/pl061.h
--- a/include/linux/amba/pl061.h~gpio-driver-for-primecell-pl061-gpio-controller-v6
+++ a/include/linux/amba/pl061.h
@@ -4,14 +4,12 @@ struct pl061_platform_data {
 	/* number of the first GPIO */
 	unsigned	gpio_base;
 
+	/* number of the first IRQ.
+	 * If the IRQ functionality in not desired this must be set to
+	 * (unsigned) -1.
+	 */
+	unsigned	irq_base;
+
 	u8		directions;	/* startup directions, 1: out, 0: in */
 	u8		values;		/* startup values */
