From: akpm@linux-foundation.org
Subject: + gpio-add-topcliff-pch-gpio-driver.patch added to -mm tree
Date: Thu, 21 Oct 2010 23:08:10 -0700
Message-ID: <201010220607.o9M67r1q030144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752521Ab0JVGIF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Oct 2010 02:08:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomoya-linux@dsn.okisemi.com, broonie@opensource.wolfsonmicro.com, joe@perches.com, linus.walleij@stericsson.com, morinaga526@dsn.okisemi.com, rabin.vincent@stericsson.com, sameo@linux.intel.com


The patch titled
     gpio: add Topcliff PCH GPIO driver
has been added to the -mm tree.  Its filename is
     gpio-add-topcliff-pch-gpio-driver.patch

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
Subject: gpio: add Topcliff PCH GPIO driver
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

Topcliff PCH is the platform controller hub that is going to be used in
Intel's upcoming general embedded platform.  All IO peripherals in
Topcliff PCH are actually devices sitting on AMBA bus.  Topcliff PCH has
GPIO I/F.  Using this I/F, it is able to access system devices connected
to GPIO.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Rabin Vincent <rabin.vincent@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Tomoya MORINAGA <morinaga526@dsn.okisemi.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/Kconfig    |    8 
 drivers/gpio/Makefile   |    1 
 drivers/gpio/pch_gpio.c |  312 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 321 insertions(+)

diff -puN drivers/gpio/Kconfig~gpio-add-topcliff-pch-gpio-driver drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~gpio-add-topcliff-pch-gpio-driver
+++ a/drivers/gpio/Kconfig
@@ -325,6 +325,14 @@ config GPIO_LANGWELL
 	help
 	  Say Y here to support Intel Langwell/Penwell GPIO.
 
+config GPIO_PCH
+	tristate "PCH GPIO of Intel Topcliff"
+	depends on PCI
+	help
+	  This driver is for PCH(Platform controller Hub) GPIO of Intel Topcliff
+	  which is an IOH(Input/Output Hub) for x86 embedded processor.
+	  This driver can access PCH GPIO device.
+
 config GPIO_TIMBERDALE
 	bool "Support for timberdale GPIO IP"
 	depends on MFD_TIMBERDALE && GPIOLIB && HAS_IOMEM
diff -puN drivers/gpio/Makefile~gpio-add-topcliff-pch-gpio-driver drivers/gpio/Makefile
--- a/drivers/gpio/Makefile~gpio-add-topcliff-pch-gpio-driver
+++ a/drivers/gpio/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.
 obj-$(CONFIG_GPIO_74X164)	+= 74x164.o
 obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
+obj-$(CONFIG_GPIO_PCH)		+= pch_gpio.o
 obj-$(CONFIG_GPIO_PL061)	+= pl061.o
 obj-$(CONFIG_GPIO_STMPE)	+= stmpe-gpio.o
 obj-$(CONFIG_GPIO_TC35892)	+= tc35892-gpio.o
diff -puN /dev/null drivers/gpio/pch_gpio.c
--- /dev/null
+++ a/drivers/gpio/pch_gpio.c
@@ -0,0 +1,312 @@
+/*
+ * Copyright (C) 2010 OKI SEMICONDUCTOR Co., LTD.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.
+ */
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/gpio.h>
+
+#define PCH_GPIO_ALL_PINS	0xfff /* Mask for GPIO pins 0 to 11 */
+#define GPIO_NUM_PINS	12	/* Specifies number of GPIO PINS GPIO0-GPIO11 */
+
+struct pch_regs {
+	u32	ien;
+	u32	istatus;
+	u32	idisp;
+	u32	iclr;
+	u32	imask;
+	u32	imaskclr;
+	u32	po;
+	u32	pi;
+	u32	pm;
+	u32	im0;
+	u32	im1;
+	u32	reserved[4];
+	u32	reset;
+};
+
+/**
+ * struct pch_gpio_reg_data - The register store data.
+ * @po_reg:	To store contents of PO register.
+ * @pm_reg:	To store contents of PM register.
+ */
+struct pch_gpio_reg_data {
+	u32 po_reg;
+	u32 pm_reg;
+};
+
+/**
+ * struct pch_gpio - GPIO private data structure.
+ * @base:			PCI base address of Memory mapped I/O register.
+ * @reg:			Memory mapped PCH GPIO register list.
+ * @dev:			Pointer to device structure.
+ * @gpio:			Data for GPIO infrastructure.
+ * @pch_gpio_reg:		Memory mapped Register data is saved here
+ *				when suspend.
+ */
+struct pch_gpio {
+	void __iomem *base;
+	struct pch_regs __iomem *reg;
+	struct device *dev;
+	struct gpio_chip gpio;
+	struct pch_gpio_reg_data pch_gpio_reg;
+	struct mutex lock;
+};
+
+static void pch_gpio_set(struct gpio_chip *gpio, unsigned nr, int val)
+{
+	u32 reg_val;
+	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);
+
+	mutex_lock(&chip->lock);
+	reg_val = ioread32(&chip->reg->po);
+	if (val)
+		reg_val |= (1 << nr);
+	else
+		reg_val &= ~(1 << nr);
+
+	iowrite32(reg_val, &chip->reg->po);
+	mutex_unlock(&chip->lock);
+}
+
+static int pch_gpio_get(struct gpio_chip *gpio, unsigned nr)
+{
+	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);
+
+	return ioread32(&chip->reg->pi) & (1 << nr);
+}
+
+static int pch_gpio_direction_output(struct gpio_chip *gpio, unsigned nr,
+				     int val)
+{
+	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);
+	u32 pm;
+	u32 reg_val;
+
+	mutex_lock(&chip->lock);
+	pm = ioread32(&chip->reg->pm) & PCH_GPIO_ALL_PINS;
+	pm |= (1 << nr);
+	iowrite32(pm, &chip->reg->pm);
+
+	reg_val = ioread32(&chip->reg->po);
+	if (val)
+		reg_val |= (1 << nr);
+	else
+		reg_val &= ~(1 << nr);
+
+	mutex_unlock(&chip->lock);
+
+	return 0;
+}
+
+static int pch_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
+{
+	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);
+	u32 pm;
+
+	mutex_lock(&chip->lock);
+	pm = ioread32(&chip->reg->pm) & PCH_GPIO_ALL_PINS; /*bits 0-11*/
+	pm &= ~(1 << nr);
+	iowrite32(pm, &chip->reg->pm);
+	mutex_unlock(&chip->lock);
+
+	return 0;
+}
+
+/*
+ * Save register configuration and disable interrupts.
+ */
+static void pch_gpio_save_reg_conf(struct pch_gpio *chip)
+{
+	chip->pch_gpio_reg.po_reg = ioread32(&chip->reg->po);
+	chip->pch_gpio_reg.pm_reg = ioread32(&chip->reg->pm);
+}
+
+/*
+ * This function restores the register configuration of the GPIO device.
+ */
+static void pch_gpio_restore_reg_conf(struct pch_gpio *chip)
+{
+	/* to store contents of PO register */
+	iowrite32(chip->pch_gpio_reg.po_reg, &chip->reg->po);
+	/* to store contents of PM register */
+	iowrite32(chip->pch_gpio_reg.pm_reg, &chip->reg->pm);
+}
+
+static void pch_gpio_setup(struct pch_gpio *chip)
+{
+	struct gpio_chip *gpio = &chip->gpio;
+
+	gpio->label = dev_name(chip->dev);
+	gpio->owner = THIS_MODULE;
+	gpio->direction_input = pch_gpio_direction_input;
+	gpio->get = pch_gpio_get;
+	gpio->direction_output = pch_gpio_direction_output;
+	gpio->set = pch_gpio_set;
+	gpio->dbg_show = NULL;
+	gpio->base = -1;
+	gpio->ngpio = GPIO_NUM_PINS;
+	gpio->can_sleep = 0;
+}
+
+static int __devinit pch_gpio_probe(struct pci_dev *pdev,
+				    const struct pci_device_id *id)
+{
+	s32 ret;
+	struct pch_gpio *chip;
+
+	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	if (chip == NULL)
+		return -ENOMEM;
+
+	chip->dev = &pdev->dev;
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		dev_err(&pdev->dev, "%s : pci_enable_device FAILED", __func__);
+		goto err_pci_enable;
+	}
+
+	ret = pci_request_regions(pdev, KBUILD_MODNAME);
+	if (ret) {
+		dev_err(&pdev->dev, "pci_request_regions FAILED-%d", ret);
+		goto err_request_regions;
+	}
+
+	chip->base = pci_iomap(pdev, 1, 0);
+	if (chip->base == 0) {
+		dev_err(&pdev->dev, "%s : pci_iomap FAILED", __func__);
+		ret = -ENOMEM;
+		goto err_iomap;
+	}
+
+	chip->reg = chip->base;
+	pci_set_drvdata(pdev, chip);
+	mutex_init(&chip->lock);
+	pch_gpio_setup(chip);
+	ret = gpiochip_add(&chip->gpio);
+	if (ret) {
+		dev_err(&pdev->dev, "PCH gpio: Failed to register GPIO\n");
+		goto err_gpiochip_add;
+	}
+
+	return 0;
+
+err_gpiochip_add:
+	pci_iounmap(pdev, chip->base);
+
+err_iomap:
+	pci_release_regions(pdev);
+
+err_request_regions:
+	pci_disable_device(pdev);
+
+err_pci_enable:
+	kfree(chip);
+	dev_err(&pdev->dev, "%s Failed returns %d\n", __func__, ret);
+	return ret;
+}
+
+static void __devexit pch_gpio_remove(struct pci_dev *pdev)
+{
+	int err;
+	struct pch_gpio *chip = pci_get_drvdata(pdev);
+
+	err = gpiochip_remove(&chip->gpio);
+	if (err)
+		dev_err(&pdev->dev, "Failed gpiochip_remove\n");
+
+	pci_iounmap(pdev, chip->base);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+	kfree(chip);
+}
+
+#ifdef CONFIG_PM
+static int pch_gpio_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	s32 ret;
+	struct pch_gpio *chip = pci_get_drvdata(pdev);
+
+	pch_gpio_save_reg_conf(chip);
+	pch_gpio_restore_reg_conf(chip);
+
+	ret = pci_save_state(pdev);
+	if (ret) {
+		dev_err(&pdev->dev, "pci_save_state Failed-%d\n", ret);
+		return ret;
+	}
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, PCI_D0);
+	ret = pci_enable_wake(pdev, PCI_D0, 1);
+	if (ret)
+		dev_err(&pdev->dev, "pci_enable_wake Failed -%d\n", ret);
+
+	return 0;
+}
+
+static int pch_gpio_resume(struct pci_dev *pdev)
+{
+	s32 ret;
+	struct pch_gpio *chip = pci_get_drvdata(pdev);
+
+	ret = pci_enable_wake(pdev, PCI_D0, 0);
+
+	pci_set_power_state(pdev, PCI_D0);
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		dev_err(&pdev->dev, "pci_enable_device Failed-%d ", ret);
+		return ret;
+	}
+	pci_restore_state(pdev);
+
+	iowrite32(0x01, &chip->reg->reset);
+	iowrite32(0x00, &chip->reg->reset);
+	pch_gpio_restore_reg_conf(chip);
+
+	return 0;
+}
+#else
+#define pch_gpio_suspend NULL
+#define pch_gpio_resume NULL
+#endif
+
+static const struct pci_device_id pch_gpio_pcidev_id[] = {
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8803)},
+	{0,}
+};
+
+static struct pci_driver pch_gpio_driver = {
+	.name = "pch_gpio",
+	.id_table = pch_gpio_pcidev_id,
+	.probe = pch_gpio_probe,
+	.remove = __devexit_p(pch_gpio_remove),
+	.suspend = pch_gpio_suspend,
+	.resume = pch_gpio_resume
+};
+
+static int __init pch_gpio_pci_init(void)
+{
+	return pci_register_driver(&pch_gpio_driver);
+}
+module_init(pch_gpio_pci_init);
+
+static void __exit pch_gpio_pci_exit(void)
+{
+	pci_unregister_driver(&pch_gpio_driver);
+}
+module_exit(pch_gpio_pci_exit);
+
+MODULE_DESCRIPTION("PCH GPIO PCI Driver");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from tomoya-linux@dsn.okisemi.com are

gpio-add-topcliff-pch-gpio-driver.patch
gpio-add-topcliff-pch-gpio-driver-fix.patch

