From: akpm@linux-foundation.org
Subject: + gpio-add-penwell-gpio-support.patch added to -mm tree
Date: Thu, 20 May 2010 14:28:27 -0700
Message-ID: <201005202128.o4KLSR1S006220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754546Ab0ETV2c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 May 2010 17:28:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alek.du@intel.com, david-b@pacbell.net


The patch titled
     gpio: add Penwell gpio support
has been added to the -mm tree.  Its filename is
     gpio-add-penwell-gpio-support.patch

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
Subject: gpio: add Penwell gpio support
From: Alek Du <alek.du@intel.com>

Intel Penwell chip has two 96 pins GPIO blocks, which are very similiar as
Intel Langwell chip GPIO block, except for pin number difference. This
patch expends the original Langwell GPIO driver to support Penwell's.

Signed-off-by: Alek Du <alek.du@intel.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig         |    4 -
 drivers/gpio/langwell_gpio.c |   83 ++++++++++++++++++++-------------
 2 files changed, 53 insertions(+), 34 deletions(-)

diff -puN drivers/gpio/Kconfig~gpio-add-penwell-gpio-support drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-add-penwell-gpio-support
+++ a/drivers/gpio/Kconfig
@@ -278,10 +278,10 @@ config GPIO_BT8XX
 	  If unsure, say N.
 
 config GPIO_LANGWELL
-	bool "Intel Moorestown Platform Langwell GPIO support"
+	bool "Intel Langwell/Penwell GPIO support"
 	depends on PCI
 	help
-	  Say Y here to support Intel Moorestown platform GPIO.
+	  Say Y here to support Intel Langwell/Penwell GPIO.
 
 config GPIO_TIMBERDALE
 	bool "Support for timberdale GPIO IP"
diff -puN drivers/gpio/langwell_gpio.c~gpio-add-penwell-gpio-support drivers/gpio/langwell_gpio.c
--- a/drivers/gpio/langwell_gpio.c~gpio-add-penwell-gpio-support
+++ a/drivers/gpio/langwell_gpio.c
@@ -17,6 +17,7 @@
 
 /* Supports:
  * Moorestown platform Langwell chip.
+ * Medfield platform Penwell chip.
  */
 
 #include <linux/module.h>
@@ -31,44 +32,65 @@
 #include <linux/gpio.h>
 #include <linux/slab.h>
 
-struct lnw_gpio_register {
-	u32	GPLR[2];
-	u32	GPDR[2];
-	u32	GPSR[2];
-	u32	GPCR[2];
-	u32	GRER[2];
-	u32	GFER[2];
-	u32	GEDR[2];
+/*
+ * Langwell chip has 64 pins and thus there are 2 32bit registers to control
+ * each feature, while Penwell chip has 96 pins for each block, and need 3 32bit
+ * registers to control them, so we only define the order here instead of a
+ * structure, to get a bit offset for a pin (use GPDR as an example):
+ *
+ * nreg = ngpio / 32;
+ * reg = offset / 32;
+ * bit = offset % 32;
+ * reg_addr = reg_base + GPDR * nreg * 4 + reg * 4;
+ *
+ * so the bit of reg_addr is to control pin offset's GPDR feature
+*/
+
+enum GPIO_REG {
+	GPLR = 0,	/* pin level read-only */
+	GPDR,		/* pin direction */
+	GPSR,		/* pin set */
+	GPCR,		/* pin clear */
+	GRER,		/* rising edge detect */
+	GFER,		/* falling edge detect */
+	GEDR,		/* edge detect result */
 };
 
 struct lnw_gpio {
 	struct gpio_chip		chip;
-	struct lnw_gpio_register 	*reg_base;
+	void				*reg_base;
 	spinlock_t			lock;
 	unsigned			irq_base;
 };
 
-static int lnw_gpio_get(struct gpio_chip *chip, unsigned offset)
+static inline void __iomem *gpio_reg(struct gpio_chip *chip, unsigned offset,
+			enum GPIO_REG reg_type)
 {
 	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
+	unsigned nreg = chip->ngpio / 32;
 	u8 reg = offset / 32;
-	void __iomem *gplr;
+	void __iomem *ptr;
+
+	ptr = (void __iomem *)(lnw->reg_base + reg_type * nreg * 4 + reg * 4);
+	return ptr;
+}
+
+static int lnw_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	void __iomem *gplr = gpio_reg(chip, offset, GPLR);
 
-	gplr = (void __iomem *)(&lnw->reg_base->GPLR[reg]);
 	return readl(gplr) & BIT(offset % 32);
 }
 
 static void lnw_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 {
-	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
-	u8 reg = offset / 32;
 	void __iomem *gpsr, *gpcr;
 
 	if (value) {
-		gpsr = (void __iomem *)(&lnw->reg_base->GPSR[reg]);
+		gpsr = gpio_reg(chip, offset, GPSR);
 		writel(BIT(offset % 32), gpsr);
 	} else {
-		gpcr = (void __iomem *)(&lnw->reg_base->GPCR[reg]);
+		gpcr = gpio_reg(chip, offset, GPCR);
 		writel(BIT(offset % 32), gpcr);
 	}
 }
@@ -76,12 +98,10 @@ static void lnw_gpio_set(struct gpio_chi
 static int lnw_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 {
 	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
-	u8 reg = offset / 32;
+	void __iomem *gpdr = gpio_reg(chip, offset, GPDR);
 	u32 value;
 	unsigned long flags;
-	void __iomem *gpdr;
 
-	gpdr = (void __iomem *)(&lnw->reg_base->GPDR[reg]);
 	spin_lock_irqsave(&lnw->lock, flags);
 	value = readl(gpdr);
 	value &= ~BIT(offset % 32);
@@ -94,12 +114,10 @@ static int lnw_gpio_direction_output(str
 			unsigned offset, int value)
 {
 	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
-	u8 reg = offset / 32;
+	void __iomem *gpdr = gpio_reg(chip, offset, GPDR);
 	unsigned long flags;
-	void __iomem *gpdr;
 
 	lnw_gpio_set(chip, offset, value);
-	gpdr = (void __iomem *)(&lnw->reg_base->GPDR[reg]);
 	spin_lock_irqsave(&lnw->lock, flags);
 	value = readl(gpdr);
 	value |= BIT(offset % 32);;
@@ -118,11 +136,10 @@ static int lnw_irq_type(unsigned irq, un
 {
 	struct lnw_gpio *lnw = get_irq_chip_data(irq);
 	u32 gpio = irq - lnw->irq_base;
-	u8 reg = gpio / 32;
 	unsigned long flags;
 	u32 value;
-	void __iomem *grer = (void __iomem *)(&lnw->reg_base->GRER[reg]);
-	void __iomem *gfer = (void __iomem *)(&lnw->reg_base->GFER[reg]);
+	void __iomem *grer = gpio_reg(&lnw->chip, gpio, GRER);
+	void __iomem *gfer = gpio_reg(&lnw->chip, gpio, GFER);
 
 	if (gpio >= lnw->chip.ngpio)
 		return -EINVAL;
@@ -158,8 +175,10 @@ static struct irq_chip lnw_irqchip = {
 	.set_type	= lnw_irq_type,
 };
 
-static struct pci_device_id lnw_gpio_ids[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080f) },
+static struct pci_device_id lnw_gpio_ids[] = {      /* pin number */
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080f), .driver_data = 64 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x081f), .driver_data = 96 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x081a), .driver_data = 96 },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, lnw_gpio_ids);
@@ -167,17 +186,17 @@ MODULE_DEVICE_TABLE(pci, lnw_gpio_ids);
 static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
 {
 	struct lnw_gpio *lnw = (struct lnw_gpio *)get_irq_data(irq);
-	u32 reg, gpio;
+	u32 base, gpio;
 	void __iomem *gedr;
 	u32 gedr_v;
 
 	/* check GPIO controller to check which pin triggered the interrupt */
-	for (reg = 0; reg < lnw->chip.ngpio / 32; reg++) {
-		gedr = (void __iomem *)(&lnw->reg_base->GEDR[reg]);
+	for (base = 0; base < lnw->chip.ngpio; base += 32) {
+		gedr = gpio_reg(&lnw->chip, base, GEDR);
 		gedr_v = readl(gedr);
 		if (!gedr_v)
 			continue;
-		for (gpio = reg*32; gpio < reg*32+32; gpio++)
+		for (gpio = base; gpio < base + 32; gpio++)
 			if (gedr_v & BIT(gpio % 32)) {
 				pr_debug("pin %d triggered\n", gpio);
 				generic_handle_irq(lnw->irq_base + gpio);
@@ -245,7 +264,7 @@ static int __devinit lnw_gpio_probe(stru
 	lnw->chip.set = lnw_gpio_set;
 	lnw->chip.to_irq = lnw_gpio_to_irq;
 	lnw->chip.base = gpio_base;
-	lnw->chip.ngpio = 64;
+	lnw->chip.ngpio = id->driver_data;
 	lnw->chip.can_sleep = 0;
 	pci_set_drvdata(pdev, lnw);
 	retval = gpiochip_add(&lnw->chip);
_

Patches currently in -mm which might be from alek.du@intel.com are

linux-next.patch
gpio-add-penwell-gpio-support.patch

