From: akpm@linux-foundation.org
Subject: + gpio-add-new-altera-pio-driver-update.patch added to -mm tree
Date: Tue, 08 Feb 2011 12:49:20 -0800
Message-ID: <201102082049.p18KnLes024667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755788Ab1BHUtZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Feb 2011 15:49:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thomas@wytron.com.tw, grant.likely@secretlab.ca


The patch titled
     gpio-add-new-altera-pio-driver-update
has been added to the -mm tree.  Its filename is
     gpio-add-new-altera-pio-driver-update.patch

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
Subject: gpio-add-new-altera-pio-driver-update
From: Thomas Chou <thomas@wytron.com.tw>

v3 remove subsys_initcall.
   add to_altera_gpio() macro.

Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/gpio/altera_gpio.txt |    7 +
 drivers/gpio/Makefile                                  |    2 
 drivers/gpio/altera_gpio.c                             |   40 ++++------
 3 files changed, 27 insertions(+), 22 deletions(-)

diff -puN /dev/null Documentation/devicetree/bindings/gpio/altera_gpio.txt
--- /dev/null
+++ a/Documentation/devicetree/bindings/gpio/altera_gpio.txt
@@ -0,0 +1,7 @@
+Altera GPIO
+
+Required properties:
+- compatible : should be "ALTR,pio-1.0".
+Optional properties:
+- resetvalue : the reset value of the output port.
+- width : the width of the port in number of bits.
diff -puN drivers/gpio/Makefile~gpio-add-new-altera-pio-driver-update drivers/gpio/Makefile
--- a/drivers/gpio/Makefile~gpio-add-new-altera-pio-driver-update
+++ a/drivers/gpio/Makefile
@@ -8,9 +8,9 @@ ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 
 obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
 
-obj-$(CONFIG_GPIO_ALTERA)	+= altera_gpio.o
 obj-$(CONFIG_GPIO_ADP5520)	+= adp5520-gpio.o
 obj-$(CONFIG_GPIO_ADP5588)	+= adp5588-gpio.o
+obj-$(CONFIG_GPIO_ALTERA)	+= altera_gpio.o
 obj-$(CONFIG_GPIO_BASIC_MMIO)	+= basic_mmio_gpio.o
 obj-$(CONFIG_GPIO_LANGWELL)	+= langwell_gpio.o
 obj-$(CONFIG_GPIO_MAX730X)	+= max730x.o
diff -puN drivers/gpio/altera_gpio.c~gpio-add-new-altera-pio-driver-update drivers/gpio/altera_gpio.c
--- a/drivers/gpio/altera_gpio.c~gpio-add-new-altera-pio-driver-update
+++ a/drivers/gpio/altera_gpio.c
@@ -37,6 +37,12 @@ struct altera_gpio_instance {
 	spinlock_t gpio_lock;	/* Lock used for synchronization */
 };
 
+static inline struct altera_gpio_instance *to_altera_gpio(
+	struct of_mm_gpio_chip *mm_gc)
+{
+	return container_of(mm_gc, struct altera_gpio_instance, mmchip);
+}
+
 /*
  * altera_gpio_get - Read the specified signal of the GPIO device.
  * @gc:     Pointer to gpio_chip device structure.
@@ -65,8 +71,7 @@ static void altera_gpio_set(struct gpio_
 {
 	unsigned long flags;
 	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
-	struct altera_gpio_instance *chip =
-	    container_of(mm_gc, struct altera_gpio_instance, mmchip);
+	struct altera_gpio_instance *chip = to_altera_gpio(mm_gc);
 
 	spin_lock_irqsave(&chip->gpio_lock, flags);
 
@@ -93,8 +98,7 @@ static int altera_gpio_dir_in(struct gpi
 {
 	unsigned long flags;
 	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
-	struct altera_gpio_instance *chip =
-	    container_of(mm_gc, struct altera_gpio_instance, mmchip);
+	struct altera_gpio_instance *chip = to_altera_gpio(mm_gc);
 
 	spin_lock_irqsave(&chip->gpio_lock, flags);
 
@@ -121,8 +125,7 @@ static int altera_gpio_dir_out(struct gp
 {
 	unsigned long flags;
 	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
-	struct altera_gpio_instance *chip =
-	    container_of(mm_gc, struct altera_gpio_instance, mmchip);
+	struct altera_gpio_instance *chip = to_altera_gpio(mm_gc);
 
 	spin_lock_irqsave(&chip->gpio_lock, flags);
 
@@ -148,8 +151,7 @@ static int altera_gpio_dir_out(struct gp
  */
 static void altera_gpio_save_regs(struct of_mm_gpio_chip *mm_gc)
 {
-	struct altera_gpio_instance *chip =
-	    container_of(mm_gc, struct altera_gpio_instance, mmchip);
+	struct altera_gpio_instance *chip = to_altera_gpio(mm_gc);
 
 	writel(chip->gpio_state, mm_gc->regs + ALTERA_GPIO_DATA_OFFSET);
 	writel(chip->gpio_dir, mm_gc->regs + ALTERA_GPIO_DIR_OFFSET);
@@ -167,15 +169,16 @@ static int __devinit altera_gpio_of_prob
 {
 	struct altera_gpio_instance *chip;
 	int status = 0;
-	const u32 *tree_info;
+	int len;
+	const __be32 *tree_info;
 
 	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
 	/* Update GPIO state shadow register with default value */
-	tree_info = of_get_property(np, "resetvalue", NULL);
-	if (tree_info)
+	tree_info = of_get_property(np, "resetvalue", &len);
+	if (tree_info && len >= sizeof(__be32))
 		chip->gpio_state = be32_to_cpup(tree_info);
 
 	/* Update GPIO direction shadow register with default value */
@@ -183,8 +186,8 @@ static int __devinit altera_gpio_of_prob
 
 	/* Check device node for device width */
 	chip->mmchip.gc.ngpio = 32; /* By default assume full GPIO controller */
-	tree_info = of_get_property(np, "width", NULL);
-	if (tree_info)
+	tree_info = of_get_property(np, "width", &len);
+	if (tree_info && len >= sizeof(__be32))
 		chip->mmchip.gc.ngpio = be32_to_cpup(tree_info);
 
 	spin_lock_init(&chip->gpio_lock);
@@ -209,24 +212,19 @@ static int __devinit altera_gpio_of_prob
 }
 
 static struct of_device_id altera_gpio_of_match[] __devinitdata = {
-	{ .compatible = "altr,pio-1.0", },
+	{ .compatible = "ALTR,pio-1.0", },
 	{},
 };
 
-static int __init altera_gpio_init(void)
+/* Make sure we get initialized before anyone else tries to use us */
+void __init altera_gpio_init(void)
 {
 	struct device_node *np;
 
 	for_each_matching_node(np, altera_gpio_of_match)
 		altera_gpio_of_probe(np);
-
-	return 0;
 }
 
-/* Make sure we get initialized before anyone else tries to use us */
-subsys_initcall(altera_gpio_init);
-/* No exit call at the moment as we cannot unregister of GPIO chips */
