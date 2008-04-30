From: akpm@linux-foundation.org
Subject: - rapidio-add-of-tree-support-to-rapidio-controller-driver.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:51:11 -0700
Message-ID: <200804300551.m3U5pBhW030200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759305AbYD3FvR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:51:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wei.zhang@freescale.com, mm-commits@vger.kernel.org


The patch titled
     rapidio: add OF-tree support to RapidIO controller driver
has been removed from the -mm tree.  Its filename was
     rapidio-add-of-tree-support-to-rapidio-controller-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: add OF-tree support to RapidIO controller driver
From: Zhang Wei <wei.zhang@freescale.com>

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/Makefile  |    1 
 arch/powerpc/kernel/rio.c     |   52 ---------------
 arch/powerpc/sysdev/fsl_rio.c |  110 +++++++++++++++++++++++++++++---
 arch/powerpc/sysdev/fsl_rio.h |   20 -----
 4 files changed, 102 insertions(+), 81 deletions(-)

diff -puN arch/powerpc/kernel/Makefile~rapidio-add-of-tree-support-to-rapidio-controller-driver arch/powerpc/kernel/Makefile
--- a/arch/powerpc/kernel/Makefile~rapidio-add-of-tree-support-to-rapidio-controller-driver
+++ a/arch/powerpc/kernel/Makefile
@@ -72,7 +72,6 @@ pci64-$(CONFIG_PPC64)		+= pci_dn.o isa-b
 obj-$(CONFIG_PCI)		+= pci_$(CONFIG_WORD_SIZE).o $(pci64-y) \
 				   pci-common.o
 obj-$(CONFIG_PCI_MSI)		+= msi.o
-obj-$(CONFIG_RAPIDIO)		+= rio.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o crash.o \
 				   machine_kexec_$(CONFIG_WORD_SIZE).o
 obj-$(CONFIG_AUDIT)		+= audit.o
diff -puN arch/powerpc/kernel/rio.c~rapidio-add-of-tree-support-to-rapidio-controller-driver /dev/null
--- a/arch/powerpc/kernel/rio.c
+++ /dev/null
@@ -1,52 +0,0 @@
-/*
- * RapidIO PPC32 support
- *
- * Copyright 2005 MontaVista Software, Inc.
- * Matt Porter <mporter@kernel.crashing.org>
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/rio.h>
-
-#include <asm/rio.h>
-
-/**
- * platform_rio_init - Do platform specific RIO init
- *
- * Any platform specific initialization of RapdIO
- * hardware is done here as well as registration
- * of any active master ports in the system.
- */
-void __attribute__ ((weak))
-    platform_rio_init(void)
-{
-	printk(KERN_WARNING "RIO: No platform_rio_init() present\n");
-}
-
-/**
- * ppc_rio_init - Do PPC32 RIO init
- *
- * Calls platform-specific RIO init code and then calls
- * rio_init_mports() to initialize any master ports that
- * have been registered with the RIO subsystem.
- */
-static int __init ppc_rio_init(void)
-{
-	printk(KERN_INFO "RIO: RapidIO init\n");
-
-	/* Platform specific initialization */
-	platform_rio_init();
-
-	/* Enumerate all registered ports */
-	rio_init_mports();
-
-	return 0;
-}
-
-subsys_initcall(ppc_rio_init);
diff -puN arch/powerpc/sysdev/fsl_rio.c~rapidio-add-of-tree-support-to-rapidio-controller-driver arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~rapidio-add-of-tree-support-to-rapidio-controller-driver
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -20,6 +20,7 @@
 #include <linux/interrupt.h>
 #include <linux/rio.h>
 #include <linux/rio_drv.h>
+#include <linux/of_platform.h>
 
 #include <asm/io.h>
 
@@ -28,7 +29,6 @@
 #define IRQ_RIO_TX(m)		(((struct rio_priv *)(m->priv))->txirq)
 #define IRQ_RIO_RX(m)		(((struct rio_priv *)(m->priv))->rxirq)
 
-#define RIO_REGS_BASE		(CCSRBAR + 0xc0000)
 #define RIO_ATMU_REGS_OFFSET	0x10c00
 #define RIO_MSG_REGS_OFFSET	0x11000
 #define RIO_MAINT_WIN_SIZE	0x400000
@@ -905,19 +905,66 @@ __setup("riohdid=", fsl_rio_get_cmdline)
 
 /**
  * fsl_rio_setup - Setup MPC85xx RapidIO interface
- * @law_start: Starting physical address of RapidIO LAW
- * @law_size: Size of RapidIO LAW
+ * @fsl_rio_setup - Setup Freescale PowerPC RapidIO interface
  *
  * Initializes MPC85xx RapidIO hardware interface, configures
  * master port with system-specific info, and registers the
  * master port with the RapidIO subsystem.
  */
-void fsl_rio_setup(int law_start, int law_size)
+int fsl_rio_setup(struct of_device *dev)
 {
 	struct rio_ops *ops;
 	struct rio_mport *port;
-	struct rio_priv *priv = NULL;
-	int rc;
+	struct rio_priv *priv;
+	int rc = 0;
+	const u32 *dt_range, *cell;
+	struct resource regs;
+	int rlen;
+	u64 law_start, law_size;
+	int paw, aw, sw;
+
+	if (!dev->node) {
+		dev_err(&dev->dev, "Device OF-Node is NULL");
+		return -EFAULT;
+	}
+
+	rc = of_address_to_resource(dev->node, 0, &regs);
+	if (rc) {
+		dev_err(&dev->dev, "Can't get %s property 'reg'\n",
+				dev->node->full_name);
+		return -EFAULT;
+	}
+	dev_info(&dev->dev, "Of-device full name %s\n", dev->node->full_name);
+	dev_info(&dev->dev, "Regs start 0x%08x size 0x%08x\n",	regs.start,
+						regs.end - regs.start + 1);
+
+	dt_range = of_get_property(dev->node, "ranges", &rlen);
+	if (!dt_range) {
+		dev_err(&dev->dev, "Can't get %s property 'ranges'\n",
+				dev->node->full_name);
+		return -EFAULT;
+	}
+
+	/* Get node address wide */
+	cell = of_get_property(dev->node, "#address-cells", NULL);
+	if (cell)
+		aw = *cell;
+	else
+		aw = of_n_addr_cells(dev->node);
+	/* Get node size wide */
+	cell = of_get_property(dev->node, "#size-cells", NULL);
+	if (cell)
+		sw = *cell;
+	else
+		sw = of_n_size_cells(dev->node);
+	/* Get parent address wide wide */
+	paw = of_n_addr_cells(dev->node);
+
+	law_start = of_read_number(dt_range + aw, paw);
+	law_size = of_read_number(dt_range + aw + paw, sw);
+
+	dev_info(&dev->dev, "LAW start 0x%016llx, size 0x%016llx.\n",
+			law_start, law_size);
 
 	ops = kmalloc(sizeof(struct rio_ops), GFP_KERNEL);
 	ops->lcread = fsl_local_config_read;
@@ -942,6 +989,12 @@ void fsl_rio_setup(int law_start, int la
 	port->iores.end = law_start + law_size;
 	port->iores.flags = IORESOURCE_MEM;
 
+	priv->bellirq = irq_of_parse_and_map(dev->node, 2);
+	priv->txirq = irq_of_parse_and_map(dev->node, 3);
+	priv->rxirq = irq_of_parse_and_map(dev->node, 4);
+	dev_info(&dev->dev, "bellirq: %d, txirq: %d, rxirq %d\n", priv->bellirq,
+				priv->txirq, priv->rxirq);
+
 	rio_init_dbell_res(&port->riores[RIO_DOORBELL_RESOURCE], 0, 0xffff);
 	rio_init_mbox_res(&port->riores[RIO_INB_MBOX_RESOURCE], 0, 0);
 	rio_init_mbox_res(&port->riores[RIO_OUTB_MBOX_RESOURCE], 0, 0);
@@ -953,7 +1006,7 @@ void fsl_rio_setup(int law_start, int la
 	port->priv = priv;
 	rio_register_mport(port);
 
-	priv->regs_win = ioremap(RIO_REGS_BASE, 0x20000);
+	priv->regs_win = ioremap(regs.start, regs.end - regs.start + 1);
 	priv->atmu_regs = (struct rio_atmu_regs *)(priv->regs_win
 					+ RIO_ATMU_REGS_OFFSET);
 	priv->maint_atmu_regs = priv->atmu_regs + 1;
@@ -972,10 +1025,51 @@ void fsl_rio_setup(int law_start, int la
 	out_be32(&priv->dbell_atmu_regs->rowar, 0x8004200b);
 	fsl_rio_doorbell_init(port);
 
-	return;
+	return 0;
 err:
 	if (priv)
 		iounmap(priv->regs_win);
+	kfree(ops);
 	kfree(priv);
 	kfree(port);
+	return rc;
+}
+
+/* The probe function for RapidIO peer-to-peer network.
+ */
+static int __devinit fsl_of_rio_rpn_probe(struct of_device *dev,
+				     const struct of_device_id *match)
+{
+	int rc;
+	printk(KERN_INFO "Setting up RapidIO peer-to-peer network %s\n",
+			dev->node->full_name);
+
+	rc = fsl_rio_setup(dev);
+	if (rc)
+		goto out;
+
+	/* Enumerate all registered ports */
+	rc = rio_init_mports();
+out:
+	return rc;
+};
+
+static const struct of_device_id fsl_of_rio_rpn_ids[] = {
+	{
+		.compatible = "fsl,rapidio-delta",
+	},
+	{},
+};
+
+static struct of_platform_driver fsl_of_rio_rpn_driver = {
+	.name = "fsl-of-rio",
+	.match_table = fsl_of_rio_rpn_ids,
+	.probe = fsl_of_rio_rpn_probe,
+};
+
+static __init int fsl_of_rio_rpn_init(void)
+{
+	return of_register_platform_driver(&fsl_of_rio_rpn_driver);
 }
+
+subsys_initcall(fsl_of_rio_rpn_init);
diff -puN arch/powerpc/sysdev/fsl_rio.h~rapidio-add-of-tree-support-to-rapidio-controller-driver /dev/null
--- a/arch/powerpc/sysdev/fsl_rio.h
+++ /dev/null
@@ -1,20 +0,0 @@
-/*
- * MPC85xx RapidIO definitions
- *
- * Copyright 2005 MontaVista Software, Inc.
- * Matt Porter <mporter@kernel.crashing.org>
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- */
-
-#ifndef __PPC_SYSLIB_PPC85XX_RIO_H
-#define __PPC_SYSLIB_PPC85XX_RIO_H
-
-#include <linux/init.h>
-
-extern void mpc85xx_rio_setup(int law_start, int law_size);
