From: akpm@linux-foundation.org
Subject: - input-phantom-add-a-new-driver.patch removed from -mm tree
Date: Wed, 02 May 2007 23:25:58 -0700
Message-ID: <200705030625.l436PwH5006284@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030912AbXECG0f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 02:26:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, dtor@mail.ru, johann.deneux@gmail.com, stenyak@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Input: phantom, add a new driver
has been removed from the -mm tree.  Its filename was
     input-phantom-add-a-new-driver.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Input: phantom, add a new driver
From: Jiri Slaby <jirislaby@gmail.com>

Sensable Phantom is a up to 7DOF force feedback (up to 6DOF FF) device. 
It's atypical, so it's based on the newly added FF_RAW effect.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: johann deneux <johann.deneux@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: <stenyak@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                  |    5 
 drivers/input/misc/Kconfig   |    9 
 drivers/input/misc/Makefile  |    1 
 drivers/input/misc/phantom.c |  387 +++++++++++++++++++++++++++++++++
 4 files changed, 402 insertions(+)

diff -puN MAINTAINERS~input-phantom-add-a-new-driver MAINTAINERS
--- a/MAINTAINERS~input-phantom-add-a-new-driver
+++ a/MAINTAINERS
@@ -3093,6 +3093,11 @@ L: 	selinux@tycho.nsa.gov (subscribers-o
 W:	http://www.nsa.gov/selinux
 S:	Supported
 
+SENSABLE PHANTOM
+P:	Jiri Slaby
+M:	jirislaby@gmail.com
+S:	Maintained
+
 SERIAL ATA (SATA) SUBSYSTEM:
 P:	Jeff Garzik
 M:	jgarzik@pobox.com
diff -puN drivers/input/misc/Kconfig~input-phantom-add-a-new-driver drivers/input/misc/Kconfig
--- a/drivers/input/misc/Kconfig~input-phantom-add-a-new-driver
+++ a/drivers/input/misc/Kconfig
@@ -113,4 +113,13 @@ config HP_SDC_RTC
 	  Say Y here if you want to support the built-in real time clock
 	  of the HP SDC controller.
 
+config PHANTOM
+	tristate "Sensable PHANToM"
+	depends on PCI && INPUT_FF_MEMLESS
+	help
+	  Say Y here if you want to build a driver for Sensable PHANToM device.
+
+	  If you choose to build module, its name will be phantom. If unsure,
+	  say N here.
+
 endif
diff -puN drivers/input/misc/Makefile~input-phantom-add-a-new-driver drivers/input/misc/Makefile
--- a/drivers/input/misc/Makefile~input-phantom-add-a-new-driver
+++ a/drivers/input/misc/Makefile
@@ -14,3 +14,4 @@ obj-$(CONFIG_INPUT_WISTRON_BTNS)	+= wist
 obj-$(CONFIG_INPUT_ATLAS_BTNS)		+= atlas_btns.o
 obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
 obj-$(CONFIG_INPUT_IXP4XX_BEEPER)	+= ixp4xx-beeper.o
+obj-$(CONFIG_PHANTOM)			+= phantom.o
diff -puN /dev/null drivers/input/misc/phantom.c
--- /dev/null
+++ a/drivers/input/misc/phantom.c
@@ -0,0 +1,387 @@
+/*
+ *  Copyright (C) 2005-2007 Jiri Slaby <jirislaby@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  You need an userspace library to cooperate with this driver. It (and other
+ *  info) may be obtained here:
+ *  http://www.fi.muni.cz/~xslaby/phantom.html
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/pci.h>
+#include <linux/fs.h>
+#include <linux/poll.h>
+#include <linux/interrupt.h>
+#include <linux/input.h>
+
+#include <asm/io.h>
+
+#define PHANTOM_VERSION		"n0.9.4"
+
+#define PHM_MAX_TORQUES		3
+
+#define PHN_CONTROL		0x6
+#define PHN_CTL_AMP		0x1
+#define PHN_CTL_BUT		0x2
+#define PHN_CTL_IRQ		0x10
+
+#define PHN_IRQCTL		0x4c
+
+#define PHN_ZERO_FORCE		2048
+
+#define PCI_ENCODER(dev, axis) ((0 - (int)ioread32((dev)->iaddr + (axis))) & \
+									0xffff)
+
+#define PHB_RUNNING		1
+#define PHB_RESET		2
+
+static struct class *phantom_class;
+
+struct phantom_device {
+	void __iomem *caddr;
+	u32 __iomem *iaddr;
+	u32 __iomem *oaddr;
+	u32 amp_bit;
+	s16 torques[PHM_MAX_TORQUES];
+	unsigned long status;
+
+	struct input_dev *idev;
+};
+
+static int phantom_status(struct phantom_device *dev, unsigned long newstat)
+{
+	pr_debug("phantom_status %lx %lx\n", dev->status, newstat);
+
+	if (!(dev->status & PHB_RUNNING) && (newstat & PHB_RUNNING)) {
+		iowrite32(PHN_CTL_IRQ | PHN_CTL_AMP, dev->iaddr + PHN_CONTROL);
+		dev->amp_bit = PHN_CTL_IRQ;
+		iowrite32(0x43, dev->caddr + PHN_IRQCTL);
+	} else if ((dev->status & PHB_RUNNING) && !(newstat & PHB_RUNNING))
+		iowrite32(0, dev->caddr + PHN_IRQCTL);
+
+	dev->status = newstat;
+
+	return 0;
+}
+
+static void phantom_close(struct input_dev *idev)
+{
+	struct phantom_device *dev = idev->private;
+
+	phantom_status(dev, dev->status & ~PHB_RUNNING);
+}
+
+static void phantom_reset(struct phantom_device *dev)
+{
+	pr_debug("resetting\n");
+
+	iowrite32(~0x1f, dev->iaddr);
+	wmb();
+	iowrite32(0x1f, dev->iaddr);
+	dev->status |= PHB_RESET;
+}
+
+static void phantom_autocenter(struct input_dev *idev, u16 magnitude)
+{
+	struct phantom_device *dev = idev->private;
+
+	phantom_reset(dev);
+}
+
+static int phantom_play(struct input_dev *idev, void *data,
+		struct ff_effect *eff)
+{
+	struct phantom_device *dev = idev->private;
+	unsigned int a;
+	int retval;
+
+	pr_debug("playing\n");
+
+	if (unlikely(!(dev->status & PHB_RUNNING))) {
+		retval = phantom_status(dev, dev->status | PHB_RUNNING);
+		if (retval)
+			return retval;
+	}
+
+	if (unlikely(!(dev->status & PHB_RESET)))
+		printk(KERN_INFO "phantom: phantom is used, but the device was"
+				"not reset since last module load\n");
+
+	for (a = 0; a < PHM_MAX_TORQUES; a++)
+		dev->torques[a] = eff->u.ff_raw[a];
+
+	return 0;
+}
+
+static irqreturn_t phantom_isr(int irq, void *data)
+{
+	struct phantom_device *dev = data;
+	struct input_dev *idev = dev->idev;
+	unsigned int a, hw_status;
+
+	hw_status = ioread32(dev->iaddr + PHN_CONTROL);
+	if (!(hw_status & PHN_CTL_IRQ))
+		return IRQ_NONE;
+
+	iowrite32(0, dev->iaddr);
+	wmb();
+	iowrite32(0xc0, dev->iaddr);
+
+	if (unlikely(idev == NULL))
+		return IRQ_HANDLED;
+
+	input_report_abs(idev, ABS_X, PCI_ENCODER(dev, 0));
+	input_report_abs(idev, ABS_Y, PCI_ENCODER(dev, 1));
+	input_report_abs(idev, ABS_Z, PCI_ENCODER(dev, 2));
+	input_report_abs(idev, ABS_RX, PCI_ENCODER(dev, 3));
+	input_report_abs(idev, ABS_RY, PCI_ENCODER(dev, 4));
+	input_report_abs(idev, ABS_RZ, PCI_ENCODER(dev, 5));
+	input_report_key(idev, BTN_0, !!(hw_status & PHN_CTL_BUT));
+	input_sync(idev);
+	input_event(idev, EV_SYN, SYN_CONFIG, 0);
+
+	for (a = 0; a < PHM_MAX_TORQUES; a++)
+		iowrite32(dev->torques[a] + PHN_ZERO_FORCE, dev->oaddr + a);
+	iowrite32(dev->amp_bit, dev->iaddr + PHN_CONTROL);
+	dev->amp_bit ^= PHN_CTL_AMP;
+
+	return IRQ_HANDLED;
+}
+
+/******************************************************************************
+ * Init and deinit driver
+ */
+static void __devinit phantom_init_idev(const struct pci_dev *pdev,
+		struct phantom_device *dev)
+{
+	struct input_dev *idev = dev->idev;
+
+	idev->private = dev;
+	idev->name = "Sensable Phantom";
+	idev->id.bustype = BUS_PCI;
+	idev->id.vendor = pdev->vendor;
+	idev->id.product = pdev->device;
+	idev->id.version = 1;
+	idev->close = phantom_close;
+
+	set_bit(BTN_0, idev->keybit);
+	input_set_abs_params(idev, ABS_X, -0x8000, 0x7fff, 4, 0);
+	input_set_abs_params(idev, ABS_Y, -0x8000, 0x7fff, 4, 0);
+	input_set_abs_params(idev, ABS_Z, -0x8000, 0x7fff, 4, 0);
+	input_set_abs_params(idev, ABS_RX, -0x8000, 0x7fff, 4, 0);
+	input_set_abs_params(idev, ABS_RY, -0x8000, 0x7fff, 4, 0);
+	input_set_abs_params(idev, ABS_RZ, -0x8000, 0x7fff, 4, 0);
+	set_bit(FF_RAW, idev->ffbit);
+
+	set_bit(EV_KEY, idev->evbit);
+	set_bit(EV_ABS, idev->evbit);
+	set_bit(EV_FF, idev->evbit);
+	set_bit(FF_AUTOCENTER, idev->ffbit); /* reset phantom */
+}
+
+static int __devinit phantom_probe(struct pci_dev *pdev,
+	const struct pci_device_id *pci_id)
+{
+	struct phantom_device *pht;
+	int retval;
+
+	retval = pci_enable_device(pdev);
+	if (retval)
+		goto err;
+
+	retval = pci_request_regions(pdev, "phantom");
+	if (retval)
+		goto err;
+
+	retval = -ENOMEM;
+	pht = kzalloc(sizeof(*pht), GFP_KERNEL);
+	if (pht == NULL) {
+		dev_err(&pdev->dev, "unable to allocate device\n");
+		goto err_reg;
+	}
+
+	pht->caddr = pci_iomap(pdev, 0, 0);
+	if (pht->caddr == NULL) {
+		dev_err(&pdev->dev, "can't remap conf space\n");
+		goto err_fr;
+	}
+	pht->iaddr = pci_iomap(pdev, 2, 0);
+	if (pht->iaddr == NULL) {
+		dev_err(&pdev->dev, "can't remap input space\n");
+		goto err_unmc;
+	}
+	pht->oaddr = pci_iomap(pdev, 3, 0);
+	if (pht->oaddr == NULL) {
+		dev_err(&pdev->dev, "can't remap output space\n");
+		goto err_unmi;
+	}
+
+	iowrite32(0, pht->caddr + PHN_IRQCTL);
+	retval = request_irq(pdev->irq, phantom_isr,
+			IRQF_SHARED | IRQF_DISABLED, "phantom", pht);
+	if (retval) {
+		dev_err(&pdev->dev, "can't establish ISR\n");
+		goto err_unmo;
+	}
+
+	pht->idev = input_allocate_device();
+	if (pht->idev == NULL) {
+		dev_err(&pdev->dev, "can't create input device\n");
+		retval = -ENOMEM;
+		goto err_irq;
+	}
+
+	phantom_init_idev(pdev, pht);
+
+	retval = input_ff_create_memless(pht->idev, NULL, phantom_play);
+	if (retval) {
+		dev_err(&pdev->dev, "can't create FF device\n");
+		goto err_idev;
+	}
+
+	pht->idev->ff->set_autocenter = phantom_autocenter;
+
+	retval = input_register_device(pht->idev);
+	if (retval) {
+		dev_err(&pdev->dev, "can't register input device\n");
+		goto err_idev;
+	}
+
+	pci_set_drvdata(pdev, pht);
+
+	return 0;
+err_idev:
+	input_free_device(pht->idev);
+err_irq:
+	free_irq(pdev->irq, pht);
+err_unmo:
+	pci_iounmap(pdev, pht->oaddr);
+err_unmi:
+	pci_iounmap(pdev, pht->iaddr);
+err_unmc:
+	pci_iounmap(pdev, pht->caddr);
+err_fr:
+	kfree(pht);
+err_reg:
+	pci_release_regions(pdev);
+err:
+	return retval;
+}
+
+static void __devexit phantom_remove(struct pci_dev *pdev)
+{
+	struct phantom_device *pht = pci_get_drvdata(pdev);
+
+	iowrite32(0, pht->caddr + PHN_IRQCTL);
+
+	input_unregister_device(pht->idev);
+
+	free_irq(pdev->irq, pht);
+
+	pci_iounmap(pdev, pht->oaddr);
+	pci_iounmap(pdev, pht->iaddr);
+	pci_iounmap(pdev, pht->caddr);
+
+	kfree(pht);
+
+	pci_release_regions(pdev);
+}
+
+static int phantom_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct phantom_device *dev = pci_get_drvdata(pdev);
+
+	iowrite32(0, dev->caddr + PHN_IRQCTL);
+
+	return 0;
+}
+
+static int phantom_resume(struct pci_dev *pdev)
+{
+	struct phantom_device *dev = pci_get_drvdata(pdev);
+
+	iowrite32(0, dev->caddr + PHN_IRQCTL);
+
+	return 0;
+}
+
+static struct pci_device_id phantom_pci_tbl[] __devinitdata = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050),
+		.class = PCI_CLASS_BRIDGE_OTHER << 8, .class_mask = 0xffff00 },
+	{ 0, }
+};
+MODULE_DEVICE_TABLE(pci, phantom_pci_tbl);
+
+static struct pci_driver phantom_pci_driver = {
+	.name = "phantom",
+	.id_table = phantom_pci_tbl,
+	.probe = phantom_probe,
+	.remove = __devexit_p(phantom_remove),
+	.suspend = phantom_suspend,
+	.resume = phantom_resume
+};
+
+static ssize_t phantom_show_version(struct class *cls, char *buf)
+{
+	return sprintf(buf, PHANTOM_VERSION "\n");
+}
+
+static CLASS_ATTR(version, 0444, phantom_show_version, NULL);
+
+static int __init phantom_init(void)
+{
+	int retval;
+
+	phantom_class = class_create(THIS_MODULE, "phantom");
+	if (IS_ERR(phantom_class)) {
+		retval = PTR_ERR(phantom_class);
+		printk(KERN_ERR "phantom: can't register phantom class\n");
+		goto err;
+	}
+	retval = class_create_file(phantom_class, &class_attr_version);
+	if (retval) {
+		printk(KERN_ERR "phantom: can't create sysfs version file\n");
+		goto err_class;
+	}
+
+	retval = pci_register_driver(&phantom_pci_driver);
+	if (retval) {
+		printk(KERN_ERR "phantom: can't register pci driver\n");
+		goto err_attr;
+	}
+
+	printk(KERN_INFO "Phantom Linux Driver, version " PHANTOM_VERSION ", "
+			"init OK\n");
+
+	return 0;
+err_attr:
+	class_remove_file(phantom_class, &class_attr_version);
+err_class:
+	class_destroy(phantom_class);
+err:
+	return retval;
+}
+
+static void __exit phantom_exit(void)
+{
+	pci_unregister_driver(&phantom_pci_driver);
+
+	class_remove_file(phantom_class, &class_attr_version);
+	class_destroy(phantom_class);
+
+	pr_debug("phantom: module successfully removed\n");
+}
+
+module_init(phantom_init);
+module_exit(phantom_exit);
+
+MODULE_AUTHOR("Jiri Slaby <jirislaby@gmail.com>");
+MODULE_DESCRIPTION("Sensable Phantom driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(PHANTOM_VERSION);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

serial-serial_core-use-pr_debug.patch
input-phantom-add-a-new-driver.patch
misc-add-sensable-phantom-driver.patch
char-rocket-add-module_device_table.patch
char-cs5535_gpio-add-module_device_table.patch
drivers-char-use-__set_current_state.patch
unify-queue_delayed_work-and-queue_delayed_work_on.patch
char-cyclades-remove-pause.patch
char-cyclades-cy_readx-writex-cleanup.patch
char-cyclades-timer-cleanup.patch
char-cyclades-remove-volatiles.patch
char-cyclades-remove-useless-casts.patch
char-cyclades-create-cy_init_ze.patch
char-cyclades-use-pci_iomap-unmap.patch
char-cyclades-init-ze-immediately.patch
char-cyclades-create-cy_pci_probe.patch
char-cyclades-move-card-entries-init-into-function.patch
char-cyclades-init-card-struct-immediately.patch
char-cyclades-remove-some-global-vars.patch
char-cyclades-cy_init-error-handling.patch
char-cyclades-tty_register_device-separately-for-each-device.patch
char-cyclades-clear-interrupts-before-releasing.patch
char-cyclades-allow-debug_shirq.patch
char-mxser-schedule-for-removal.patch
char-isicom-use-pr_debug.patch
shrink_slab-handle-bad-shrinkers.patch
