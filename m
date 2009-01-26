From: akpm@linux-foundation.org
Subject: [merged] pci-pcie-portdrv-aviod-using-service-devices-with-wrong-interrupts-rev-2.patch removed from -mm tree
Date: Mon, 26 Jan 2009 11:04:25 -0800
Message-ID: <200901261904.n0QJ4P3w029946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753370AbZAZTFP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 14:05:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     PCI PCIe portdrv: aviod using service devices with wrong interrupts
has been removed from the -mm tree.  Its filename was
     pci-pcie-portdrv-aviod-using-service-devices-with-wrong-interrupts-rev-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PCI PCIe portdrv: aviod using service devices with wrong interrupts
From: Rafael J. Wysocki <rjw@sisk.pl>

The PCI Express port driver should not attempt to register service devices
that require the ability to generate interrupts if generating interrupts
is not possible.  Namely, if the port has no interrupt pin configured and
we cannot set up MSI or MSI-X for it, there is no way it can generate
interrupts and in such a case the port services that rely on interrupts
(PME, PCIe HP, AER) should not be enabled for it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pcie/portdrv_core.c |   41 ++++++++++++++++++++----------
 include/linux/pcieport_if.h     |    1 
 2 files changed, 29 insertions(+), 13 deletions(-)

diff -puN drivers/pci/pcie/portdrv_core.c~pci-pcie-portdrv-aviod-using-service-devices-with-wrong-interrupts-rev-2 drivers/pci/pcie/portdrv_core.c
--- a/drivers/pci/pcie/portdrv_core.c~pci-pcie-portdrv-aviod-using-service-devices-with-wrong-interrupts-rev-2
+++ a/drivers/pci/pcie/portdrv_core.c
@@ -43,7 +43,7 @@ static int assign_interrupt_mode(struct 
 {
 	struct pcie_port_data *port_data = pci_get_drvdata(dev);
 	int i, pos, nvec, status = -EINVAL;
-	int interrupt_mode = PCIE_PORT_INTx_MODE;
+	int interrupt_mode = PCIE_PORT_NO_IRQ;
 
 	/* Set INTx as default */
 	for (i = 0, nvec = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++) {
@@ -51,7 +51,9 @@ static int assign_interrupt_mode(struct 
 			nvec++;
 		vectors[i] = dev->irq;
 	}
-	
+	if (dev->pin)
+		interrupt_mode = PCIE_PORT_INTx_MODE;
+
 	/* Check MSI quirk */
 	if (port_data->port_type == PCIE_RC_PORT && pcie_mch_quirk)
 		return interrupt_mode;
@@ -141,7 +143,7 @@ static void pcie_device_init(struct pci_
 	dev->id.vendor = parent->vendor;
 	dev->id.device = parent->device;
 	dev->id.port_type = port_type;
-	dev->id.service_type = (1 << service_type);
+	dev->id.service_type = service_type;
 
 	/* Initialize generic device interface */
 	device = &dev->device;
@@ -232,19 +234,32 @@ int pcie_port_device_register(struct pci
 	/* Allocate child services if any */
 	for (i = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++) {
 		struct pcie_device *child;
+		int service = 1 << i;
 
-		if (capabilities & (1 << i)) {
-			child = alloc_pcie_device(dev, i, vectors[i]);
-			if (child) {
-				status = device_register(&child->device);
-				if (status) {
-					kfree(child);
-					continue;
-				}
-				get_device(&child->device);
-			}
+		if (!(capabilities & service))
+			continue;
+
+		/*
+		 * Don't use service devices that require interrupts if there is
+		 * no way to generate them.
+		 */
+		if (irq_mode == PCIE_PORT_NO_IRQ
+		    && service != PCIE_PORT_SERVICE_VC)
+			continue;
+
+		child = alloc_pcie_device(dev, service, vectors[i]);
+		if (!child)
+			continue;
+
+		status = device_register(&child->device);
+		if (status) {
+			kfree(child);
+			continue;
 		}
+
+		get_device(&child->device);
 	}
+
 	return 0;
 }
 
diff -puN include/linux/pcieport_if.h~pci-pcie-portdrv-aviod-using-service-devices-with-wrong-interrupts-rev-2 include/linux/pcieport_if.h
--- a/include/linux/pcieport_if.h~pci-pcie-portdrv-aviod-using-service-devices-with-wrong-interrupts-rev-2
+++ a/include/linux/pcieport_if.h
@@ -22,6 +22,7 @@
 #define PCIE_PORT_SERVICE_VC		8	/* Virtual Channel */
 
 /* Root/Upstream/Downstream Port's Interrupt Mode */
+#define PCIE_PORT_NO_IRQ		(-1)
 #define PCIE_PORT_INTx_MODE		0
 #define PCIE_PORT_MSI_MODE		1
 #define PCIE_PORT_MSIX_MODE		2
_

Patches currently in -mm which might be from rjw@sisk.pl are

linux-next.patch
drivers-consolidate-driver_probe_done-loops-into-one-place.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
resume-wait-for-device-probing-to-finish.patch
shrink_slab-handle-bad-shrinkers.patch

