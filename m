From: akpm@linux-foundation.org
Subject: [merged] pci-pcie-portdrv-do-not-enable-port-device-before-setting-up-interrupts-rev-2.patch removed from -mm tree
Date: Mon, 26 Jan 2009 11:04:27 -0800
Message-ID: <200901261904.n0QJ4RPr029963@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751601AbZAZTIw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 14:08:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     PCI PCIe portdrv: do not enable port device before setting up interrupts
has been removed from the -mm tree.  Its filename was
     pci-pcie-portdrv-do-not-enable-port-device-before-setting-up-interrupts-rev-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PCI PCIe portdrv: do not enable port device before setting up interrupts
From: Rafael J. Wysocki <rjw@sisk.pl>

The PCI Express port driver calls pci_enable_device() before setting up
interrupts, which is wrong, because if there is an interrupt pin
configured for the port, pci_enable_device() will likely set up an
interrupt link for it.  However, this shouldn't be done if either MSI or
MSI-X interrupt mode is chosen for the port.

The solution is to call pci_enable_device() after setting up interrupts,
because in that case the interrupt link won't be set up if MSI or MSI-X
are enabled.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pcie/portdrv_core.c |   38 ++++++++++++++++++++++--------
 drivers/pci/pcie/portdrv_pci.c  |   11 ++------
 2 files changed, 31 insertions(+), 18 deletions(-)

diff -puN drivers/pci/pcie/portdrv_core.c~pci-pcie-portdrv-do-not-enable-port-device-before-setting-up-interrupts-rev-2 drivers/pci/pcie/portdrv_core.c
--- a/drivers/pci/pcie/portdrv_core.c~pci-pcie-portdrv-do-not-enable-port-device-before-setting-up-interrupts-rev-2
+++ a/drivers/pci/pcie/portdrv_core.c
@@ -208,7 +208,7 @@ int pcie_port_device_probe(struct pci_de
 int pcie_port_device_register(struct pci_dev *dev)
 {
 	struct pcie_port_data *port_data;
-	int status, capabilities, irq_mode, i;
+	int status, capabilities, irq_mode, i, nr_serv;
 	int vectors[PCIE_PORT_DEVICE_MAXSERVICES];
 	u16 reg16;
 
@@ -229,24 +229,32 @@ int pcie_port_device_register(struct pci
 		capabilities |= PCIE_PORT_SERVICE_PME;
 
 	irq_mode = assign_interrupt_mode(dev, vectors, capabilities);
+	if (irq_mode == PCIE_PORT_NO_IRQ) {
+		/*
+		 * Don't use service devices that require interrupts if there is
+		 * no way to generate them.
+		 */
+		if (!(capabilities & PCIE_PORT_SERVICE_VC)) {
+			status = -ENODEV;
+			goto Error;
+		}
+		capabilities = PCIE_PORT_SERVICE_VC;
+	}
 	port_data->port_irq_mode = irq_mode;
 
+	status = pci_enable_device(dev);
+	if (status)
+		goto Error;
+	pci_set_master(dev);
+
 	/* Allocate child services if any */
-	for (i = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++) {
+	for (i = 0, nr_serv = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++) {
 		struct pcie_device *child;
 		int service = 1 << i;
 
 		if (!(capabilities & service))
 			continue;
 
-		/*
-		 * Don't use service devices that require interrupts if there is
-		 * no way to generate them.
-		 */
-		if (irq_mode == PCIE_PORT_NO_IRQ
-		    && service != PCIE_PORT_SERVICE_VC)
-			continue;
-
 		child = alloc_pcie_device(dev, service, vectors[i]);
 		if (!child)
 			continue;
@@ -258,9 +266,19 @@ int pcie_port_device_register(struct pci
 		}
 
 		get_device(&child->device);
+		nr_serv++;
+	}
+	if (!nr_serv) {
+		pci_disable_device(dev);
+		status = -ENODEV;
+		goto Error;
 	}
 
 	return 0;
+
+ Error:
+	kfree(port_data);
+	return status;
 }
 
 #ifdef CONFIG_PM
diff -puN drivers/pci/pcie/portdrv_pci.c~pci-pcie-portdrv-do-not-enable-port-device-before-setting-up-interrupts-rev-2 drivers/pci/pcie/portdrv_pci.c
--- a/drivers/pci/pcie/portdrv_pci.c~pci-pcie-portdrv-do-not-enable-port-device-before-setting-up-interrupts-rev-2
+++ a/drivers/pci/pcie/portdrv_pci.c
@@ -94,18 +94,13 @@ static int __devinit pcie_portdrv_probe 
 	if (status)
 		return status;
 
-	if (pci_enable_device(dev) < 0) 
-		return -ENODEV;
-	
-	pci_set_master(dev);
         if (!dev->irq && dev->pin) {
 		dev_warn(&dev->dev, "device [%04x:%04x] has invalid IRQ; "
 			 "check vendor BIOS\n", dev->vendor, dev->device);
 	}
-	if (pcie_port_device_register(dev)) {
-		pci_disable_device(dev);
-		return -ENOMEM;
-	}
+	status = pcie_port_device_register(dev);
+	if (status)
+		return status;
 
 	pcie_portdrv_save_config(dev);
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

linux-next.patch
drivers-consolidate-driver_probe_done-loops-into-one-place.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
resume-wait-for-device-probing-to-finish.patch
shrink_slab-handle-bad-shrinkers.patch

