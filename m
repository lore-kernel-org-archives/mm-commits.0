From: akpm@linux-foundation.org
Subject: + spi-add-pci-interface-driver-for-designware-spi-core.patch added to -mm tree
Date: Mon, 12 Oct 2009 15:26:19 -0700
Message-ID: <200910122226.n9CMQJgI003434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933494AbZJLW1D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Oct 2009 18:27:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: feng.tang@intel.com, david-b@pacbell.net


The patch titled
     spi: add PCI interface driver for Designware SPI core
has been added to the -mm tree.  Its filename is
     spi-add-pci-interface-driver-for-designware-spi-core.patch

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
Subject: spi: add PCI interface driver for Designware SPI core
From: Feng Tang <feng.tang@intel.com>

Add the PCI interface driver for DW SPI core.  It has been tested on Intel
Moorestown platform

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/spi/Kconfig~spi-add-pci-interface-driver-for-designware-spi-core drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~spi-add-pci-interface-driver-for-designware-spi-core
+++ a/drivers/spi/Kconfig
@@ -265,6 +265,10 @@ config SPI_DESIGNWARE
 	help
 	  general driver for SPI controller core from DesignWare
 
+config SPI_DW_PCI
+	tristate "PCI interface driver for DW SPI core"
+	depends on SPI_DESIGNWARE && PCI
+
 #
 # Add new SPI master controllers in alphabetical order above this line
 #
diff -puN drivers/spi/Makefile~spi-add-pci-interface-driver-for-designware-spi-core drivers/spi/Makefile
--- a/drivers/spi/Makefile~spi-add-pci-interface-driver-for-designware-spi-core
+++ a/drivers/spi/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_SPI_XILINX_PLTFM)		+= xilin
 obj-$(CONFIG_SPI_SH_SCI)		+= spi_sh_sci.o
 obj-$(CONFIG_SPI_STMP3XXX)		+= spi_stmp.o
 obj-$(CONFIG_SPI_DESIGNWARE)		+= dw_spi.o
+obj-$(CONFIG_SPI_DW_PCI)		+= dw_spi_pci.o
 # 	... add above this line ...
 
 # SPI protocol drivers (device/link on bus)
diff -puN /dev/null drivers/spi/dw_spi_pci.c
--- /dev/null
+++ a/drivers/spi/dw_spi_pci.c
@@ -0,0 +1,169 @@
+/*
+ * mrst_spi_pci.c - PCI interface driver for DW SPI Core
+ *
+ * Copyright (c) 2009, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation,
+ * Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/pci.h>
+#include <linux/spi/dw_spi.h>
+#include <linux/spi/spi.h>
+
+#define DRIVER_NAME "dw_spi_pci"
+
+struct dw_spi_pci {
+	struct pci_dev		*pdev;
+	struct dw_spi		dws;
+};
+
+static int __devinit spi_pci_probe(struct pci_dev *pdev,
+	const struct pci_device_id *ent)
+{
+	struct dw_spi_pci *dwpci;
+	struct dw_spi *dws;
+	int pci_bar = 0;
+	int ret;
+
+	printk(KERN_INFO "DW: found PCI SPI controller(ID: %04x:%04x)\n",
+		pdev->vendor, pdev->device);
+
+	ret = pci_enable_device(pdev);
+	if (ret)
+		return ret;
+
+	dwpci = kzalloc(sizeof(struct dw_spi_pci), GFP_KERNEL);
+	if (!dwpci) {
+		ret = -ENOMEM;
+		goto err_disable;
+	}
+
+	dwpci->pdev = pdev;
+	dws = &dwpci->dws;
+
+	/* Get basic io resource and map it */
+	dws->paddr = pci_resource_start(pdev, pci_bar);
+	dws->iolen = pci_resource_len(pdev, pci_bar);
+
+	ret = pci_request_region(pdev, pci_bar, dev_name(&pdev->dev));
+	if (ret)
+		goto err_kfree;
+
+	dws->regs = ioremap_nocache((unsigned long)dws->paddr,
+				pci_resource_len(pdev, pci_bar));
+	if (!dws->regs) {
+		ret = -ENOMEM;
+		goto err_release_reg;
+	}
+
+	dws->parent_dev = &pdev->dev;
+	dws->bus_num = 0;
+	dws->num_cs = 4;
+	dws->max_freq = 25000000;	/* for Moorestwon */
+	dws->irq = pdev->irq;
+
+	ret = dw_spi_add_host(dws);
+	if (ret)
+		goto err_unmap;
+
+	/* PCI hook and SPI hook use the same drv data */
+	pci_set_drvdata(pdev, dwpci);
+	return 0;
+
+err_unmap:
+	iounmap(dws->regs);
+err_release_reg:
+	pci_release_region(pdev, pci_bar);
+err_kfree:
+	kfree(dwpci);
+err_disable:
+	pci_disable_device(pdev);
+	return ret;
+}
+
+static void __devexit spi_pci_remove(struct pci_dev *pdev)
+{
+	struct dw_spi_pci *dwpci = pci_get_drvdata(pdev);
+
+	pci_set_drvdata(pdev, NULL);
+	iounmap(dwpci->dws.regs);
+	pci_release_region(pdev, 0);
+	kfree(dwpci);
+	pci_disable_device(pdev);
+}
+
+#ifdef CONFIG_PM
+static int spi_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct dw_spi_pci *dwpci = pci_get_drvdata(pdev);
+	int ret;
+
+	ret = dw_spi_suspend_host(&dwpci->dws);
+	if (ret)
+		return ret;
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+	return ret;
+}
+
+static int spi_resume(struct pci_dev *pdev)
+{
+	struct dw_spi_pci *dwpci = pci_get_drvdata(pdev);
+	int ret;
+
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+	ret = pci_enable_device(pdev);
+	if (ret)
+		return ret;
+	return dw_spi_resume_host(&dwpci->dws);
+}
+#else
+#define mrst_spi_suspend	NULL
+#define mrst_spi_resume		NULL
+#endif
+
+static const struct pci_device_id pci_ids[] __devinitdata = {
+	/* Intel Moorestown platform SPI controller 0 */
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0800) },
+	{},
+};
+
+static struct pci_driver dw_spi_driver = {
+	.name =		DRIVER_NAME,
+	.id_table =	pci_ids,
+	.probe =	spi_pci_probe,
+	.remove =	__devexit_p(spi_pci_remove),
+	.suspend =	spi_suspend,
+	.resume	=	spi_resume,
+};
+
+static int __init mrst_spi_init(void)
+{
+	return pci_register_driver(&dw_spi_driver);
+}
+
+static void __exit mrst_spi_exit(void)
+{
+	pci_unregister_driver(&dw_spi_driver);
+}
+
+module_init(mrst_spi_init);
+module_exit(mrst_spi_exit);
+
+MODULE_AUTHOR("Feng Tang <feng.tang@intel.com>");
+MODULE_DESCRIPTION("PCI interface driver for DW SPI Core");
+MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from feng.tang@intel.com are

hrtimers-remove-the-timer_stats_active-check-when-setting-the-start-info.patch
spi-controller-driver-for-designware-spi-core.patch
spi-add-pci-interface-driver-for-designware-spi-core.patch
spi-dma-support-for-designware-core-on-moorestown-platform.patch

