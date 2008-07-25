From: akpm@linux-foundation.org
Subject: - sm501-add-gpiolib-support.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:55:38 -0700
Message-ID: <200807252255.m6PMtcBs002992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755687AbYGYXHj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:07:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, apatard@mandriva.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     sm501: add gpiolib support
has been removed from the -mm tree.  Its filename was
     sm501-add-gpiolib-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sm501: add gpiolib support
From: Ben Dooks <ben-linux@fluff.org>

Add support for exporting the GPIOs on the SM501 via gpiolib.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Arnaud Patard <apatard@mandriva.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/Kconfig   |    8 +
 drivers/mfd/sm501.c   |  299 +++++++++++++++++++++++++++++++++-------
 include/linux/sm501.h |   20 --
 3 files changed, 257 insertions(+), 70 deletions(-)

diff -puN drivers/mfd/Kconfig~sm501-add-gpiolib-support drivers/mfd/Kconfig
--- a/drivers/mfd/Kconfig~sm501-add-gpiolib-support
+++ a/drivers/mfd/Kconfig
@@ -19,6 +19,14 @@ config MFD_SM501
 	  interface. The device may be connected by PCI or local bus with
 	  varying functions enabled.
 
+config MFD_SM501_GPIO
+	bool "Export GPIO via GPIO layer"
+	depends on MFD_SM501 && HAVE_GPIO_LIB
+	 ---help---
+	 This option uses the gpio library layer to export the 64 GPIO
+	 lines on the SM501. The platform data is used to supply the
+	 base number for the first GPIO line to register.
+
 config MFD_ASIC3
 	bool "Support for Compaq ASIC3"
 	depends on GENERIC_HARDIRQS && HAVE_GPIO_LIB && ARM
diff -puN drivers/mfd/sm501.c~sm501-add-gpiolib-support drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~sm501-add-gpiolib-support
+++ a/drivers/mfd/sm501.c
@@ -19,6 +19,7 @@
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/pci.h>
+#include <linux/gpio.h>
 
 #include <linux/sm501.h>
 #include <linux/sm501-regs.h>
@@ -31,10 +32,29 @@ struct sm501_device {
 	struct platform_device		pdev;
 };
 
+struct sm501_gpio;
+
+struct sm501_gpio_chip {
+	struct gpio_chip	gpio;
+	struct sm501_gpio	*ourgpio;	/* to get back to parent. */
+	void __iomem		*regbase;
+};
+
+struct sm501_gpio {
+	struct sm501_gpio_chip	low;
+	struct sm501_gpio_chip	high;
+	spinlock_t		lock;
+
+	unsigned int		 registered : 1;
+	void __iomem		*regs;
+	struct resource		*regs_res;
+};
+
 struct sm501_devdata {
 	spinlock_t			 reg_lock;
 	struct mutex			 clock_lock;
 	struct list_head		 devices;
+	struct sm501_gpio		 gpio;
 
 	struct device			*dev;
 	struct resource			*io_res;
@@ -42,6 +62,7 @@ struct sm501_devdata {
 	struct resource			*regs_claim;
 	struct sm501_platdata		*platdata;
 
+
 	unsigned int			 in_suspend;
 	unsigned long			 pm_misc;
 
@@ -52,6 +73,7 @@ struct sm501_devdata {
 	unsigned int			 rev;
 };
 
+
 #define MHZ (1000 * 1000)
 
 #ifdef DEBUG
@@ -276,58 +298,6 @@ unsigned long sm501_modify_reg(struct de
 
 EXPORT_SYMBOL_GPL(sm501_modify_reg);
 
-unsigned long sm501_gpio_get(struct device *dev,
-			     unsigned long gpio)
-{
-	struct sm501_devdata *sm = dev_get_drvdata(dev);
-	unsigned long result;
-	unsigned long reg;
-
-	reg = (gpio > 32) ? SM501_GPIO_DATA_HIGH : SM501_GPIO_DATA_LOW;
-	result = readl(sm->regs + reg);
-
-	result >>= (gpio & 31);
-	return result & 1UL;
-}
-
-EXPORT_SYMBOL_GPL(sm501_gpio_get);
-
-void sm501_gpio_set(struct device *dev,
-		    unsigned long gpio,
-		    unsigned int to,
-		    unsigned int dir)
-{
-	struct sm501_devdata *sm = dev_get_drvdata(dev);
-
-	unsigned long bit = 1 << (gpio & 31);
-	unsigned long base;
-	unsigned long save;
-	unsigned long val;
-
-	base = (gpio > 32) ? SM501_GPIO_DATA_HIGH : SM501_GPIO_DATA_LOW;
-	base += SM501_GPIO;
-
-	spin_lock_irqsave(&sm->reg_lock, save);
-
-	val = readl(sm->regs + base) & ~bit;
-	if (to)
-		val |= bit;
-	writel(val, sm->regs + base);
-
-	val = readl(sm->regs + SM501_GPIO_DDR_LOW) & ~bit;
-	if (dir)
-		val |= bit;
-
-	writel(val, sm->regs + SM501_GPIO_DDR_LOW);
-	sm501_sync_regs(sm);
-
-	spin_unlock_irqrestore(&sm->reg_lock, save);
-
-}
-
-EXPORT_SYMBOL_GPL(sm501_gpio_set);
-
-
 /* sm501_unit_power
  *
  * alters the power active gate to set specific units on or off
@@ -906,6 +876,226 @@ static int sm501_register_display(struct
 	return sm501_register_device(sm, pdev);
 }
 
+#ifdef CONFIG_MFD_SM501_GPIO
+
+static inline struct sm501_gpio_chip *to_sm501_gpio(struct gpio_chip *gc)
+{
+	return container_of(gc, struct sm501_gpio_chip, gpio);
+}
+
+static inline struct sm501_devdata *sm501_gpio_to_dev(struct sm501_gpio *gpio)
+{
+	return container_of(gpio, struct sm501_devdata, gpio);
+}
+
+static int sm501_gpio_get(struct gpio_chip *chip, unsigned offset)
+
+{
+	struct sm501_gpio_chip *smgpio = to_sm501_gpio(chip);
+	unsigned long result;
+
+	result = readl(smgpio->regbase + SM501_GPIO_DATA_LOW);
+	result >>= offset;
+
+	return result & 1UL;
+}
+
+static void sm501_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+
+{
+	struct sm501_gpio_chip *smchip = to_sm501_gpio(chip);
+	struct sm501_gpio *smgpio = smchip->ourgpio;
+	unsigned long bit = 1 << offset;
+	void __iomem *regs = smchip->regbase;
+	unsigned long save;
+	unsigned long val;
+
+	dev_dbg(sm501_gpio_to_dev(smgpio)->dev, "%s(%p,%d)\n",
+		__func__, chip, offset);
+
+	spin_lock_irqsave(&smgpio->lock, save);
+
+	val = readl(regs + SM501_GPIO_DATA_LOW) & ~bit;
+	if (value)
+		val |= bit;
+	writel(val, regs);
+
+	sm501_sync_regs(sm501_gpio_to_dev(smgpio));
+	spin_unlock_irqrestore(&smgpio->lock, save);
+}
+
+static int sm501_gpio_input(struct gpio_chip *chip, unsigned offset)
+{
+	struct sm501_gpio_chip *smchip = to_sm501_gpio(chip);
+	struct sm501_gpio *smgpio = smchip->ourgpio;
+	void __iomem *regs = smchip->regbase;
+	unsigned long bit = 1 << offset;
+	unsigned long save;
+	unsigned long ddr;
+
+	dev_info(sm501_gpio_to_dev(smgpio)->dev, "%s(%p,%d)\n",
+		 __func__, chip, offset);
+
+	spin_lock_irqsave(&smgpio->lock, save);
+
+	ddr = readl(regs + SM501_GPIO_DDR_LOW);
+	writel(ddr & ~bit, regs + SM501_GPIO_DDR_LOW);
+
+	sm501_sync_regs(sm501_gpio_to_dev(smgpio));
+	spin_unlock_irqrestore(&smgpio->lock, save);
+
+	return 0;
+}
+
+static int sm501_gpio_output(struct gpio_chip *chip,
+			     unsigned offset, int value)
+{
+	struct sm501_gpio_chip *smchip = to_sm501_gpio(chip);
+	struct sm501_gpio *smgpio = smchip->ourgpio;
+	unsigned long bit = 1 << offset;
+	void __iomem *regs = smchip->regbase;
+	unsigned long save;
+	unsigned long val;
+	unsigned long ddr;
+
+	dev_dbg(sm501_gpio_to_dev(smgpio)->dev, "%s(%p,%d,%d)\n",
+		__func__, chip, offset, value);
+
+	spin_lock_irqsave(&smgpio->lock, save);
+
+	val = readl(regs + SM501_GPIO_DATA_LOW);
+	if (value)
+		val |= bit;
+	else
+		val &= ~bit;
+	writel(val, regs);
+
+	ddr = readl(regs + SM501_GPIO_DDR_LOW);
+	writel(ddr | bit, regs + SM501_GPIO_DDR_LOW);
+
+	sm501_sync_regs(sm501_gpio_to_dev(smgpio));
+	writel(val, regs + SM501_GPIO_DATA_LOW);
+
+	sm501_sync_regs(sm501_gpio_to_dev(smgpio));
+	spin_unlock_irqrestore(&smgpio->lock, save);
+
+	return 0;
+}
+
+static struct gpio_chip gpio_chip_template = {
+	.ngpio			= 32,
+	.direction_input	= sm501_gpio_input,
+	.direction_output	= sm501_gpio_output,
+	.set			= sm501_gpio_set,
+	.get			= sm501_gpio_get,
+};
+
+static int __devinit sm501_gpio_register_chip(struct sm501_devdata *sm,
+					      struct sm501_gpio *gpio,
+					      struct sm501_gpio_chip *chip)
+{
+	struct sm501_platdata *pdata = sm->platdata;
+	struct gpio_chip *gchip = &chip->gpio;
+	unsigned base = pdata->gpio_base;
+
+	memcpy(chip, &gpio_chip_template, sizeof(struct gpio_chip));
+
+	if (chip == &gpio->high) {
+		base += 32;
+		chip->regbase = gpio->regs + SM501_GPIO_DATA_HIGH;
+		gchip->label  = "SM501-HIGH";
+	} else {
+		chip->regbase = gpio->regs + SM501_GPIO_DATA_LOW;
+		gchip->label  = "SM501-LOW";
+	}
+
+	gchip->base   = base;
+	chip->ourgpio = gpio;
+
+	return gpiochip_add(gchip);
+}
+
+static int sm501_register_gpio(struct sm501_devdata *sm)
+{
+	struct sm501_gpio *gpio = &sm->gpio;
+	resource_size_t iobase = sm->io_res->start + SM501_GPIO;
+	int ret;
+	int tmp;
+
+	dev_dbg(sm->dev, "registering gpio block %08llx\n",
+		(unsigned long long)iobase);
+
+	spin_lock_init(&gpio->lock);
+
+	gpio->regs_res = request_mem_region(iobase, 0x20, "sm501-gpio");
+	if (gpio->regs_res == NULL) {
+		dev_err(sm->dev, "gpio: failed to request region\n");
+		return -ENXIO;
+	}
+
+	gpio->regs = ioremap(iobase, 0x20);
+	if (gpio->regs == NULL) {
+		dev_err(sm->dev, "gpio: failed to remap registers\n");
+		ret = -ENXIO;
+		goto err_mapped;
+	}
+
+	/* Register both our chips. */
+
+	ret = sm501_gpio_register_chip(sm, gpio, &gpio->low);
+	if (ret) {
+		dev_err(sm->dev, "failed to add low chip\n");
+		goto err_mapped;
+	}
+
+	ret = sm501_gpio_register_chip(sm, gpio, &gpio->high);
+	if (ret) {
+		dev_err(sm->dev, "failed to add high chip\n");
+		goto err_low_chip;
+	}
+
+	gpio->registered = 1;
+
+	return 0;
+
+ err_low_chip:
+	tmp = gpiochip_remove(&gpio->low.gpio);
+	if (tmp) {
+		dev_err(sm->dev, "cannot remove low chip, cannot tidy up\n");
+		return ret;
+	}
+
+ err_mapped:
+	release_resource(gpio->regs_res);
+	kfree(gpio->regs_res);
+
+	return ret;
+}
+
+static void sm501_gpio_remove(struct sm501_devdata *sm)
+{
+	int ret;
+
+	ret = gpiochip_remove(&sm->gpio.low.gpio);
+	if (ret)
+		dev_err(sm->dev, "cannot remove low chip, cannot tidy up\n");
+
+	ret = gpiochip_remove(&sm->gpio.high.gpio);
+	if (ret)
+		dev_err(sm->dev, "cannot remove high chip, cannot tidy up\n");
+}
+
+#else
+static int sm501_register_gpio(struct sm501_devdata *sm)
+{
+	return 0;
+}
+
+static void sm501_gpio_remove(struct sm501_devdata *sm)
+{
+}
+#endif
+
 /* sm501_dbg_regs
  *
  * Debug attribute to attach to parent device to show core registers
@@ -1059,6 +1249,8 @@ static int sm501_init_dev(struct sm501_d
 			sm501_register_usbhost(sm, &mem_avail);
 		if (idata->devices & (SM501_USE_UART0 | SM501_USE_UART1))
 			sm501_register_uart(sm, idata->devices);
+		if (idata->devices & SM501_USE_GPIO)
+			sm501_register_gpio(sm);
 	}
 
 	ret = sm501_check_clocks(sm);
@@ -1366,6 +1558,9 @@ static void sm501_dev_remove(struct sm50
 		sm501_remove_sub(sm, smdev);
 
 	device_remove_file(sm->dev, &dev_attr_dbg_regs);
+
+	if (sm->gpio.registered)
+		sm501_gpio_remove(sm);
 }
 
 static void sm501_pci_remove(struct pci_dev *dev)
diff -puN include/linux/sm501.h~sm501-add-gpiolib-support include/linux/sm501.h
--- a/include/linux/sm501.h~sm501-add-gpiolib-support
+++ a/include/linux/sm501.h
@@ -46,24 +46,6 @@ extern unsigned long sm501_modify_reg(st
 				      unsigned long set,
 				      unsigned long clear);
 
-/* sm501_gpio_set
- *
- * set the state of the given GPIO line
-*/
-
-extern void sm501_gpio_set(struct device *dev,
-			   unsigned long gpio,
-			   unsigned int to,
-			   unsigned int dir);
-
-/* sm501_gpio_get
- *
- * get the state of the given GPIO line
-*/
-
-extern unsigned long sm501_gpio_get(struct device *dev,
-				    unsigned long gpio);
-
 
 /* Platform data definitions */
 
@@ -131,6 +113,7 @@ struct sm501_reg_init {
 #define SM501_USE_FBACCEL	(1<<6)
 #define SM501_USE_AC97		(1<<7)
 #define SM501_USE_I2S		(1<<8)
+#define SM501_USE_GPIO		(1<<9)
 
 #define SM501_USE_ALL		(0xffffffff)
 
@@ -173,6 +156,7 @@ struct sm501_platdata {
 	struct sm501_platdata_fb	*fb;
 
 	int				 flags;
+	unsigned			 gpio_base;
 
 	int	(*get_power)(struct device *dev);
 	int	(*set_power)(struct device *dev, unsigned int on);
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
linux-next.patch
resource-add-resource_size.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

