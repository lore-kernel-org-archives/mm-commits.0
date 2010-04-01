From: akpm@linux-foundation.org
Subject: + mfd-add-support-for-janz-cmod-io-pci-modulbus-carrier-board.patch added to -mm tree
Date: Thu, 01 Apr 2010 13:06:53 -0700
Message-ID: <201004012006.o31K6rGW006284@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758814Ab0DAUHD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Apr 2010 16:07:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: iws@ovro.caltech.edu, sameo@linux.intel.com, wg@grandegger.com


The patch titled
     mfd: add support for Janz CMOD-IO PCI MODULbus Carrier Board
has been added to the -mm tree.  Its filename is
     mfd-add-support-for-janz-cmod-io-pci-modulbus-carrier-board.patch

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
Subject: mfd: add support for Janz CMOD-IO PCI MODULbus Carrier Board
From: "Ira W. Snyder" <iws@ovro.caltech.edu>

The Janz CMOD-IO PCI MODULbus carrier board is a PCI to MODULbus bridge,
which may host many different types of MODULbus daughterboards, including
CAN and GPIO controllers.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
Reviewed-by: Wolfgang Grandegger <wg@grandegger.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/Kconfig       |   10 +
 drivers/mfd/Makefile      |    1 
 drivers/mfd/janz-cmodio.c |  302 ++++++++++++++++++++++++++++++++++++
 include/linux/mfd/janz.h  |   54 ++++++
 include/linux/pci_ids.h   |    2 
 5 files changed, 369 insertions(+)

diff -puN drivers/mfd/Kconfig~mfd-add-support-for-janz-cmod-io-pci-modulbus-carrier-board drivers/mfd/Kconfig
--- a/drivers/mfd/Kconfig~mfd-add-support-for-janz-cmod-io-pci-modulbus-carrier-board
+++ a/drivers/mfd/Kconfig
@@ -412,6 +412,16 @@ config MFD_RDC321X
 	  southbridge which provides access to GPIOs and Watchdog using the
 	  southbridge PCI device configuration space.
 
+config MFD_JANZ_CMODIO
+	tristate "Support for Janz CMOD-IO PCI MODULbus Carrier Board"
+	select MFD_CORE
+	depends on PCI
+	help
+	  This is the core driver for the Janz CMOD-IO PCI MODULbus
+	  carrier board. This device is a PCI to MODULbus bridge which may
+	  host many different types of MODULbus daughterboards, including
+	  CAN and GPIO controllers.
+
 endmenu
 
 menu "Multimedia Capabilities Port drivers"
diff -puN drivers/mfd/Makefile~mfd-add-support-for-janz-cmod-io-pci-modulbus-carrier-board drivers/mfd/Makefile
--- a/drivers/mfd/Makefile~mfd-add-support-for-janz-cmod-io-pci-modulbus-carrier-board
+++ a/drivers/mfd/Makefile
@@ -65,3 +65,4 @@ obj-$(CONFIG_MFD_TIMBERDALE)    += timbe
 obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
 obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
 obj-$(CONFIG_MFD_RDC321X)	+= rdc321x-southbridge.o
+obj-$(CONFIG_MFD_JANZ_CMODIO)	+= janz-cmodio.o
diff -puN /dev/null drivers/mfd/janz-cmodio.c
--- /dev/null
+++ a/drivers/mfd/janz-cmodio.c
@@ -0,0 +1,302 @@
+/*
+ * Janz CMOD-IO MODULbus Carrier Board PCI Driver
+ *
+ * Copyright (c) 2010 Ira W. Snyder <iws@ovro.caltech.edu>
+ *
+ * Lots of inspiration and code was copied from drivers/mfd/sm501.c
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/core.h>
+
+#include <linux/mfd/janz.h>
+
+#define DRV_NAME "janz-cmodio"
+
+/* Size of each MODULbus module in PCI BAR4 */
+#define CMODIO_MODULBUS_SIZE	0x200
+
+/* Maximum number of MODULbus modules on a CMOD-IO carrier board */
+#define CMODIO_MAX_MODULES	4
+
+/* Module Parameters */
+static unsigned int num_modules = CMODIO_MAX_MODULES;
+static unsigned char *modules[CMODIO_MAX_MODULES] = {
+	"empty", "empty", "empty", "empty",
+};
+
+module_param_array(modules, charp, &num_modules, S_IRUGO);
+MODULE_PARM_DESC(modules, "MODULbus modules attached to the carrier board");
+
+/* Unique Device Id */
+static unsigned int cmodio_id;
+
+struct cmodio_device {
+	/* Parent PCI device */
+	struct pci_dev *pdev;
+
+	/* PLX control registers */
+	struct janz_cmodio_onboard_regs __iomem *ctrl;
+
+	/* hex switch position */
+	u8 hex;
+
+	/* mfd-core API */
+	struct mfd_cell cells[CMODIO_MAX_MODULES];
+	struct resource resources[3 * CMODIO_MAX_MODULES];
+	struct janz_platform_data pdata[CMODIO_MAX_MODULES];
+};
+
+/*
+ * Subdevices using the mfd-core API
+ */
+
+static int __devinit cmodio_setup_subdevice(struct cmodio_device *priv,
+					    char *name, unsigned int devno,
+					    unsigned int modno)
+{
+	struct janz_platform_data *pdata;
+	struct mfd_cell *cell;
+	struct resource *res;
+	struct pci_dev *pci;
+
+	pci = priv->pdev;
+	cell = &priv->cells[devno];
+	res = &priv->resources[devno * 3];
+	pdata = &priv->pdata[devno];
+
+	cell->name = name;
+	cell->resources = res;
+	cell->num_resources = 3;
+
+	/* Setup the subdevice ID -- must be unique */
+	cell->id = cmodio_id++;
+
+	/* Add platform data */
+	pdata->modno = modno;
+	cell->platform_data = pdata;
+	cell->data_size = sizeof(*pdata);
+
+	/* MODULbus registers -- PCI BAR3 is big-endian MODULbus access */
+	res->flags = IORESOURCE_MEM;
+	res->parent = &pci->resource[3];
+	res->start = pci->resource[3].start + (CMODIO_MODULBUS_SIZE * modno);
+	res->end = res->start + CMODIO_MODULBUS_SIZE - 1;
+	res++;
+
+	/* PLX Control Registers -- PCI BAR4 is interrupt and other registers */
+	res->flags = IORESOURCE_MEM;
+	res->parent = &pci->resource[4];
+	res->start = pci->resource[4].start;
+	res->end = pci->resource[4].end;
+	res++;
+
+	/*
+	 * IRQ
+	 *
+	 * The start and end fields are used as an offset to the irq_base
+	 * parameter passed into the mfd_add_devices() function call. All
+	 * devices share the same IRQ.
+	 */
+	res->flags = IORESOURCE_IRQ;
+	res->parent = NULL;
+	res->start = 0;
+	res->end = 0;
+	res++;
+
+	return 0;
+}
+
+/* Probe each submodule using kernel parameters */
+static int __devinit cmodio_probe_submodules(struct cmodio_device *priv)
+{
+	struct pci_dev *pdev = priv->pdev;
+	unsigned int num_probed = 0;
+	char *name;
+	int i;
+
+	for (i = 0; i < num_modules; i++) {
+		name = modules[i];
+		if (!strcmp(name, "") || !strcmp(name, "empty"))
+			continue;
+
+		dev_dbg(&priv->pdev->dev, "MODULbus %d: name %s\n", i, name);
+		cmodio_setup_subdevice(priv, name, num_probed, i);
+		num_probed++;
+	}
+
+	/* print an error message if no modules were probed */
+	if (num_probed == 0) {
+		dev_err(&priv->pdev->dev, "no MODULbus modules specified, "
+					  "please set the ``modules'' kernel "
+					  "parameter according to your "
+					  "hardware configuration\n");
+		return -ENODEV;
+	}
+
+	return mfd_add_devices(&pdev->dev, 0, priv->cells,
+			       num_probed, NULL, pdev->irq);
+}
+
+/*
+ * SYSFS Attributes
+ */
+
+static ssize_t mbus_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct cmodio_device *priv = dev_get_drvdata(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%x\n", priv->hex);
+}
+
+static DEVICE_ATTR(modulbus_number, S_IRUGO, mbus_show, NULL);
+
+static struct attribute *cmodio_sysfs_attrs[] = {
+	&dev_attr_modulbus_number.attr,
+	NULL,
+};
+
+static const struct attribute_group cmodio_sysfs_attr_group = {
+	.attrs = cmodio_sysfs_attrs,
+};
+
+/*
+ * PCI Driver
+ */
+
+static int __devinit cmodio_pci_probe(struct pci_dev *dev,
+				      const struct pci_device_id *id)
+{
+	struct cmodio_device *priv;
+	int ret;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		dev_err(&dev->dev, "unable to allocate private data\n");
+		ret = -ENOMEM;
+		goto out_return;
+	}
+
+	pci_set_drvdata(dev, priv);
+	priv->pdev = dev;
+
+	/* Hardware Initialization */
+	ret = pci_enable_device(dev);
+	if (ret) {
+		dev_err(&dev->dev, "unable to enable device\n");
+		goto out_free_priv;
+	}
+
+	pci_set_master(dev);
+	ret = pci_request_regions(dev, DRV_NAME);
+	if (ret) {
+		dev_err(&dev->dev, "unable to request regions\n");
+		goto out_pci_disable_device;
+	}
+
+	/* Onboard configuration registers */
+	priv->ctrl = pci_ioremap_bar(dev, 4);
+	if (!priv->ctrl) {
+		dev_err(&dev->dev, "unable to remap onboard regs\n");
+		ret = -ENOMEM;
+		goto out_pci_release_regions;
+	}
+
+	/* Read the hex switch on the carrier board */
+	priv->hex = ioread8(&priv->ctrl->int_enable);
+
+	/* Add the MODULbus number (hex switch value) to the device's sysfs */
+	ret = sysfs_create_group(&dev->dev.kobj, &cmodio_sysfs_attr_group);
+	if (ret) {
+		dev_err(&dev->dev, "unable to create sysfs attributes\n");
+		goto out_unmap_ctrl;
+	}
+
+	/*
+	 * Disable all interrupt lines, each submodule will enable its
+	 * own interrupt line if needed
+	 */
+	iowrite8(0xf, &priv->ctrl->int_disable);
+
+	/* Register drivers for all submodules */
+	ret = cmodio_probe_submodules(priv);
+	if (ret) {
+		dev_err(&dev->dev, "unable to probe submodules\n");
+		goto out_sysfs_remove_group;
+	}
+
+	return 0;
+
+out_sysfs_remove_group:
+	sysfs_remove_group(&dev->dev.kobj, &cmodio_sysfs_attr_group);
+out_unmap_ctrl:
+	iounmap(priv->ctrl);
+out_pci_release_regions:
+	pci_release_regions(dev);
+out_pci_disable_device:
+	pci_disable_device(dev);
+out_free_priv:
+	kfree(priv);
+out_return:
+	return ret;
+}
+
+static void __devexit cmodio_pci_remove(struct pci_dev *dev)
+{
+	struct cmodio_device *priv = pci_get_drvdata(dev);
+
+	mfd_remove_devices(&dev->dev);
+	sysfs_remove_group(&dev->dev.kobj, &cmodio_sysfs_attr_group);
+	iounmap(priv->ctrl);
+	pci_release_regions(dev);
+	pci_disable_device(dev);
+	kfree(priv);
+}
+
+/* The list of devices that this module will support */
+static DEFINE_PCI_DEVICE_TABLE(cmodio_pci_ids) = {
+	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9030, PCI_VENDOR_ID_JANZ, 0x0101 },
+	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050, PCI_VENDOR_ID_JANZ, 0x0100 },
+	{ 0, }
+};
+MODULE_DEVICE_TABLE(pci, cmodio_pci_ids);
+
+static struct pci_driver cmodio_pci_driver = {
+	.name     = DRV_NAME,
+	.id_table = cmodio_pci_ids,
+	.probe    = cmodio_pci_probe,
+	.remove   = __devexit_p(cmodio_pci_remove),
+};
+
+/*
+ * Module Init / Exit
+ */
+
+static int __init cmodio_init(void)
+{
+	return pci_register_driver(&cmodio_pci_driver);
+}
+
+static void __exit cmodio_exit(void)
+{
+	pci_unregister_driver(&cmodio_pci_driver);
+}
+
+MODULE_AUTHOR("Ira W. Snyder <iws@ovro.caltech.edu>");
+MODULE_DESCRIPTION("Janz CMOD-IO PCI MODULbus Carrier Board Driver");
+MODULE_LICENSE("GPL");
+
+module_init(cmodio_init);
+module_exit(cmodio_exit);
diff -puN /dev/null include/linux/mfd/janz.h
--- /dev/null
+++ a/include/linux/mfd/janz.h
@@ -0,0 +1,54 @@
+/*
+ * Common Definitions for Janz MODULbus devices
+ *
+ * Copyright (c) 2010 Ira W. Snyder <iws@ovro.caltech.edu>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ */
+
+#ifndef JANZ_H
+#define JANZ_H
+
+struct janz_platform_data {
+	/* MODULbus Module Number */
+	unsigned int modno;
+};
+
+/* PLX bridge chip onboard registers */
+struct janz_cmodio_onboard_regs {
+	u8 unused1;
+
+	/*
+	 * Read access: interrupt status
+	 * Write access: interrupt disable
+	 */
+	u8 int_disable;
+	u8 unused2;
+
+	/*
+	 * Read access: MODULbus number (hex switch)
+	 * Write access: interrupt enable
+	 */
+	u8 int_enable;
+	u8 unused3;
+
+	/* write-only */
+	u8 reset_assert;
+	u8 unused4;
+
+	/* write-only */
+	u8 reset_deassert;
+	u8 unused5;
+
+	/* read-write access to serial EEPROM */
+	u8 eep;
+	u8 unused6;
+
+	/* write-only access to EEPROM chip select */
+	u8 enid;
+};
+
+#endif /* JANZ_H */
diff -puN include/linux/pci_ids.h~mfd-add-support-for-janz-cmod-io-pci-modulbus-carrier-board include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~mfd-add-support-for-janz-cmod-io-pci-modulbus-carrier-board
+++ a/include/linux/pci_ids.h
@@ -2737,3 +2737,5 @@
 #define PCI_DEVICE_ID_RME_DIGI32	0x9896
 #define PCI_DEVICE_ID_RME_DIGI32_PRO	0x9897
 #define PCI_DEVICE_ID_RME_DIGI32_8	0x9898
+
+#define PCI_VENDOR_ID_JANZ		0x13c3
_

Patches currently in -mm which might be from iws@ovro.caltech.edu are

linux-next.patch
mfd-add-support-for-janz-cmod-io-pci-modulbus-carrier-board.patch
can-add-support-for-janz-vmod-ican3-intelligent-can-module.patch
gpio-add-support-for-janz-vmod-ttl-digital-io-module.patch

