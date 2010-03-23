From: akpm@linux-foundation.org
Subject: + mfd-add-support-for-the-rdc321x-southbridge.patch added to -mm tree
Date: Mon, 22 Mar 2010 22:56:16 -0400
Message-ID: <201003230557.o2N5v77r017022@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752022Ab0CWF6N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 01:58:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: florian@openwrt.org, david-b@pacbell.net, hpa@zytor.com, mingo@elte.hu, sameo@linux.intel.com, tglx@linutronix.de, wim@iguana.be


The patch titled
     mfd: add support for the RDC321x southbridge
has been added to the -mm tree.  Its filename is
     mfd-add-support-for-the-rdc321x-southbridge.patch

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
Subject: mfd: add support for the RDC321x southbridge
From: Florian Fainelli <florian@openwrt.org>

Add a new MFD driver for the RDC321x southbridge.  This southbridge is
always present in the RDC321x System-on-a-Chip and provides access to some
GPIOs as well as a watchdog.  Access to these two functions is done using
the southbridge PCI device configuration space.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/Kconfig               |    9 ++
 drivers/mfd/Makefile              |    3 
 drivers/mfd/rdc321x-southbridge.c |  123 ++++++++++++++++++++++++++++
 include/linux/mfd/rdc321x.h       |   26 +++++
 4 files changed, 160 insertions(+), 1 deletion(-)

diff -puN drivers/mfd/Kconfig~mfd-add-support-for-the-rdc321x-southbridge drivers/mfd/Kconfig
--- a/drivers/mfd/Kconfig~mfd-add-support-for-the-rdc321x-southbridge
+++ a/drivers/mfd/Kconfig
@@ -403,6 +403,15 @@ config LPC_SCH
 	  LPC bridge function of the Intel SCH provides support for
 	  System Management Bus and General Purpose I/O.
 
+config MFD_RDC321X
+	tristate "Support for RDC-R321x southbridge"
+	select MFD_CORE
+	depends on PCI
+	help
+	  Say yes here if you want to have support for the RDC R-321x SoC
+	  southbridge which provides access to GPIOs and Watchdog using the
+	  southbridge PCI device configuration space.
+
 endmenu
 
 menu "Multimedia Capabilities Port drivers"
diff -puN drivers/mfd/Makefile~mfd-add-support-for-the-rdc321x-southbridge drivers/mfd/Makefile
--- a/drivers/mfd/Makefile~mfd-add-support-for-the-rdc321x-southbridge
+++ a/drivers/mfd/Makefile
@@ -63,4 +63,5 @@ obj-$(CONFIG_AB3100_OTP)	+= ab3100-otp.o
 obj-$(CONFIG_AB4500_CORE)	+= ab4500-core.o
 obj-$(CONFIG_MFD_TIMBERDALE)    += timberdale.o
 obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
-obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
\ No newline at end of file
+obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
+obj-$(CONFIG_MFD_RDC321X)	+= rdc321x-southbridge.o
diff -puN /dev/null drivers/mfd/rdc321x-southbridge.c
--- /dev/null
+++ a/drivers/mfd/rdc321x-southbridge.c
@@ -0,0 +1,123 @@
+/*
+ * RDC321x MFD southbrige driver
+ *
+ * Copyright (C) 2007-2010 Florian Fainelli <florian@openwrt.org>
+ * Copyright (C) 2010 Bernhard Loos <bernhardloos@googlemail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/pci.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/rdc321x.h>
+
+static struct rdc321x_wdt_pdata rdc321x_wdt_pdata;
+
+static struct resource rdc321x_wdt_resource[] = {
+	{
+		.name	= "wdt-reg",
+		.start	= RDC321X_WDT_CTRL,
+		.end	= RDC321X_WDT_CTRL + 0x3,
+		.flags	= IORESOURCE_MEM,
+	}
+};
+
+static struct rdc321x_gpio_pdata rdc321x_gpio_pdata = {
+	.max_gpios	= RDC321X_MAX_GPIO,
+};
+
+static struct resource rdc321x_gpio_resources[] = {
+	{
+		.name	= "gpio-reg1",
+		.start	= RDC321X_GPIO_CTRL_REG1,
+		.end	= RDC321X_GPIO_CTRL_REG1 + 0x7,
+		.flags	= IORESOURCE_MEM,
+	}, {
+		.name	= "gpio-reg2",
+		.start	= RDC321X_GPIO_CTRL_REG2,
+		.end	= RDC321X_GPIO_CTRL_REG2 + 0x7,
+		.flags	= IORESOURCE_MEM,
+	}
+};
+
+static struct mfd_cell rdc321x_sb_cells[] = {
+	{
+		.name		= "rdc321x-wdt",
+		.resources	= rdc321x_wdt_resource,
+		.num_resources	= ARRAY_SIZE(rdc321x_wdt_resource),
+		.driver_data	= &rdc321x_wdt_pdata,
+	}, {
+		.name		= "rdc321x-gpio",
+		.resources	= rdc321x_gpio_resources,
+		.num_resources	= ARRAY_SIZE(rdc321x_gpio_resources),
+		.driver_data	= &rdc321x_gpio_pdata,
+	},
+};
+
+static int __devinit rdc321x_sb_probe(struct pci_dev *pdev,
+					const struct pci_device_id *ent)
+{
+	int err;
+
+	err = pci_enable_device(pdev);
+	if (err) {
+		dev_err(&pdev->dev, "failed to enable device\n");
+		return err;
+	}
+
+	rdc321x_gpio_pdata.sb_pdev = pdev;
+	rdc321x_wdt_pdata.sb_pdev = pdev;
+
+	return mfd_add_devices(&pdev->dev, -1,
+		rdc321x_sb_cells, ARRAY_SIZE(rdc321x_sb_cells), NULL, 0);
+}
+
+static void __devexit rdc321x_sb_remove(struct pci_dev *pdev)
+{
+	mfd_remove_devices(&pdev->dev);
+}
+
+static DEFINE_PCI_DEVICE_TABLE(rdc321x_sb_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_RDC, PCI_DEVICE_ID_RDC_R6030) },
+	{}
+};
+
+static struct pci_driver rdc321x_sb_driver = {
+	.name		= "RDC321x Southbridge",
+	.id_table	= rdc321x_sb_table,
+	.probe		= rdc321x_sb_probe,
+	.remove		= __devexit_p(rdc321x_sb_remove),
+};
+
+static int __init rdc321x_sb_init(void)
+{
+	return pci_register_driver(&rdc321x_sb_driver);
+}
+
+static void __exit rdc321x_sb_exit(void)
+{
+	pci_unregister_driver(&rdc321x_sb_driver);
+}
+
+module_init(rdc321x_sb_init);
+module_exit(rdc321x_sb_exit);
+
+MODULE_AUTHOR("Florian Fainelli <florian@openwrt.org>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("RDC R-321x MFD southbridge driver");
diff -puN /dev/null include/linux/mfd/rdc321x.h
--- /dev/null
+++ a/include/linux/mfd/rdc321x.h
@@ -0,0 +1,26 @@
+#ifndef __RDC321X_MFD_H
+#define __RDC321X_MFD_H
+
+#include <linux/types.h>
+#include <linux/pci.h>
+
+/* Offsets to be accessed in the southbridge PCI
+ * device configuration register */
+#define RDC321X_WDT_CTRL	0x44
+#define RDC321X_GPIO_CTRL_REG1	0x48
+#define RDC321X_GPIO_DATA_REG1	0x4c
+#define RDC321X_GPIO_CTRL_REG2	0x84
+#define RDC321X_GPIO_DATA_REG2	0x88
+
+#define RDC321X_MAX_GPIO	58
+
+struct rdc321x_gpio_pdata {
+	struct pci_dev *sb_pdev;
+	unsigned max_gpios;
+};
+
+struct rdc321x_wdt_pdata {
+	struct pci_dev *sb_pdev;
+};
+
+#endif /* __RDC321X_MFD_H */
_

Patches currently in -mm which might be from florian@openwrt.org are

mfd-add-support-for-the-rdc321x-southbridge.patch
gpio-add-support-for-rdc321x-gpio-controller.patch
watchdog-convert-rdc321x_wdt-to-use-southbridge-pci-device.patch
x86-remove-rdc321x_defsh.patch

