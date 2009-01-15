From: akpm@linux-foundation.org
Subject: + pci-pcie-portdrv-use-driver-data-to-simplify-code.patch added to -mm tree
Date: Thu, 15 Jan 2009 15:17:12 -0800
Message-ID: <200901152317.n0FNHCP9020716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757053AbZAOXRS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jan 2009 18:17:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, jbarnes@virtuousgeek.org


The patch titled
     PCI PCIe portdrv: use driver data to simplify code
has been added to the -mm tree.  Its filename is
     pci-pcie-portdrv-use-driver-data-to-simplify-code.patch

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
Subject: PCI PCIe portdrv: use driver data to simplify code
From: Rafael J. Wysocki <rjw@sisk.pl>

PCI Express port driver extension, as defined by struct
pcie_port_device_ext in portdrv.h, is allocated and initialized, but never
used (it also is never freed).  Extend it to hold the PCI Express port
type as well as the port interrupt mode, change its name and use it to
simplify the code in portdrv_core.c .

Additionally, remove the redundant interrupt_mode member of struct
pcie_device defined in include/linux/pcieport_if.h .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pcie/portdrv.h      |    5 -
 drivers/pci/pcie/portdrv_core.c |   95 +++++++++++-------------------
 include/linux/pcieport_if.h     |    1 
 3 files changed, 39 insertions(+), 62 deletions(-)

diff -puN drivers/pci/pcie/portdrv.h~pci-pcie-portdrv-use-driver-data-to-simplify-code drivers/pci/pcie/portdrv.h
--- a/drivers/pci/pcie/portdrv.h~pci-pcie-portdrv-use-driver-data-to-simplify-code
+++ a/drivers/pci/pcie/portdrv.h
@@ -28,8 +28,9 @@
 
 #define get_descriptor_id(type, service) (((type - 4) << 4) | service)
 
-struct pcie_port_device_ext {
-	int interrupt_mode;	/* [0:INTx | 1:MSI | 2:MSI-X] */
+struct pcie_port_data {
+	int port_type;		/* Type of the port */
+	int port_irq_mode;	/* [0:INTx | 1:MSI | 2:MSI-X] */
 };
 
 extern struct bus_type pcie_port_bus_type;
diff -puN drivers/pci/pcie/portdrv_core.c~pci-pcie-portdrv-use-driver-data-to-simplify-code drivers/pci/pcie/portdrv_core.c
--- a/drivers/pci/pcie/portdrv_core.c~pci-pcie-portdrv-use-driver-data-to-simplify-code
+++ a/drivers/pci/pcie/portdrv_core.c
@@ -15,10 +15,9 @@
 #include <linux/slab.h>
 #include <linux/pcieport_if.h>
 
+#include "../pci.h"
 #include "portdrv.h"
 
-extern int pcie_mch_quirk;	/* MSI-quirk Indicator */
-
 /**
  * release_pcie_device - free PCI Express port service device structure
  * @dev: Port service device to release
@@ -31,28 +30,6 @@ static void release_pcie_device(struct d
 	kfree(to_pcie_device(dev));			
 }
 
-static int is_msi_quirked(struct pci_dev *dev)
-{
-	int port_type, quirk = 0;
-	u16 reg16;
-
-	pci_read_config_word(dev, 
-		pci_find_capability(dev, PCI_CAP_ID_EXP) + 
-		PCIE_CAPABILITIES_REG, &reg16);
-	port_type = (reg16 >> 4) & PORT_TYPE_MASK;
-	switch(port_type) {
-	case PCIE_RC_PORT:
-		if (pcie_mch_quirk == 1)
-			quirk = 1;
-		break;
-	case PCIE_SW_UPSTREAM_PORT:
-	case PCIE_SW_DOWNSTREAM_PORT:
-	default:
-		break;	
-	}
-	return quirk;
-}
-
 /**
  * assign_interrupt_mode - choose interrupt mode for PCI Express port services
  *                         (INTx, MSI-X, MSI) and set up vectors
@@ -64,6 +41,7 @@ static int is_msi_quirked(struct pci_dev
  */
 static int assign_interrupt_mode(struct pci_dev *dev, int *vectors, int mask)
 {
+	struct pcie_port_data *port_data = pci_get_drvdata(dev);
 	int i, pos, nvec, status = -EINVAL;
 	int interrupt_mode = PCIE_PORT_INTx_MODE;
 
@@ -75,7 +53,7 @@ static int assign_interrupt_mode(struct 
 	}
 	
 	/* Check MSI quirk */
-	if (is_msi_quirked(dev))
+	if (port_data->port_type == PCIE_RC_PORT && pcie_mch_quirk)
 		return interrupt_mode;
 
 	/* Select MSI-X over MSI if supported */		
@@ -132,13 +110,11 @@ static int get_port_device_capability(st
 			pos + PCIE_SLOT_CAPABILITIES_REG, &reg32);
 		if (reg32 & SLOT_HP_CAPABLE_MASK)
 			services |= PCIE_PORT_SERVICE_HP;
-	} 
-	/* PME Capable - root port capability */
-	if (((reg16 >> 4) & PORT_TYPE_MASK) == PCIE_RC_PORT)
-		services |= PCIE_PORT_SERVICE_PME;
-
+	}
+	/* AER capable */
 	if (pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR))
 		services |= PCIE_PORT_SERVICE_AER;
+	/* VC support */
 	if (pci_find_ext_capability(dev, PCI_EXT_CAP_ID_VC))
 		services |= PCIE_PORT_SERVICE_VC;
 
@@ -152,15 +128,15 @@ static int get_port_device_capability(st
  * @port_type: Type of the port
  * @service_type: Type of service to associate with the service device
  * @irq: Interrupt vector to associate with the service device
- * @irq_mode: Interrupt mode of the service (INTx, MSI-X, MSI)
  */
 static void pcie_device_init(struct pci_dev *parent, struct pcie_device *dev, 
-	int port_type, int service_type, int irq, int irq_mode)
+	int service_type, int irq)
 {
+	struct pcie_port_data *port_data = pci_get_drvdata(parent);
 	struct device *device;
+	int port_type = port_data->port_type;
 
 	dev->port = parent;
-	dev->interrupt_mode = irq_mode;
 	dev->irq = irq;
 	dev->id.vendor = parent->vendor;
 	dev->id.device = parent->device;
@@ -185,10 +161,9 @@ static void pcie_device_init(struct pci_
  * @port_type: Type of the port
  * @service_type: Type of service to associate with the service device
  * @irq: Interrupt vector to associate with the service device
- * @irq_mode: Interrupt mode of the service (INTx, MSI-X, MSI)
  */
 static struct pcie_device* alloc_pcie_device(struct pci_dev *parent,
-	int port_type, int service_type, int irq, int irq_mode)
+	int service_type, int irq)
 {
 	struct pcie_device *device;
 
@@ -196,7 +171,7 @@ static struct pcie_device* alloc_pcie_de
 	if (!device)
 		return NULL;
 
-	pcie_device_init(parent, device, port_type, service_type, irq,irq_mode);
+	pcie_device_init(parent, device, service_type, irq);
 	return device;
 }
 
@@ -230,39 +205,36 @@ int pcie_port_device_probe(struct pci_de
  */
 int pcie_port_device_register(struct pci_dev *dev)
 {
-	struct pcie_port_device_ext *p_ext;
-	int status, type, capabilities, irq_mode, i;
+	struct pcie_port_data *port_data;
+	int status, capabilities, irq_mode, i;
 	int vectors[PCIE_PORT_DEVICE_MAXSERVICES];
 	u16 reg16;
 
-	/* Allocate port device extension */
-	if (!(p_ext = kmalloc(sizeof(struct pcie_port_device_ext), GFP_KERNEL)))
+	port_data = kzalloc(sizeof(*port_data), GFP_KERNEL);
+	if (!port_data)
 		return -ENOMEM;
-
-	pci_set_drvdata(dev, p_ext);
+	pci_set_drvdata(dev, port_data);
 
 	/* Get port type */
 	pci_read_config_word(dev,
 		pci_find_capability(dev, PCI_CAP_ID_EXP) +
 		PCIE_CAPABILITIES_REG, &reg16);
-	type = (reg16 >> 4) & PORT_TYPE_MASK;
+	port_data->port_type = (reg16 >> 4) & PORT_TYPE_MASK;
 
-	/* Now get port services */
 	capabilities = get_port_device_capability(dev);
+	/* Root ports are capable of generating PME too */
+	if (port_data->port_type == PCIE_RC_PORT)
+		capabilities |= PCIE_PORT_SERVICE_PME;
+
 	irq_mode = assign_interrupt_mode(dev, vectors, capabilities);
-	p_ext->interrupt_mode = irq_mode;
+	port_data->port_irq_mode = irq_mode;
 
 	/* Allocate child services if any */
 	for (i = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++) {
 		struct pcie_device *child;
 
 		if (capabilities & (1 << i)) {
-			child = alloc_pcie_device(
-				dev, 		/* parent */
-				type,		/* port type */
-				i,		/* service type */
-				vectors[i],	/* irq */
-				irq_mode	/* interrupt mode */);
+			child = alloc_pcie_device(dev, i, vectors[i]);
 			if (child) {
 				status = device_register(&child->device);
 				if (status) {
@@ -349,25 +321,30 @@ static int remove_iter(struct device *de
  */
 void pcie_port_device_remove(struct pci_dev *dev)
 {
-	struct device *device;
-	unsigned long device_addr;
-	int interrupt_mode = PCIE_PORT_INTx_MODE;
+	struct pcie_port_data *port_data = pci_get_drvdata(dev);
 	int status;
 
 	do {
+		unsigned long device_addr;
+
 		status = device_for_each_child(&dev->dev, &device_addr, remove_iter);
 		if (status) {
-			device = (struct device*)device_addr;
-			interrupt_mode = (to_pcie_device(device))->interrupt_mode;
+			struct device *device = (struct device*)device_addr;
 			put_device(device);
 			device_unregister(device);
 		}
 	} while (status);
-	/* Switch to INTx by default if MSI enabled */
-	if (interrupt_mode == PCIE_PORT_MSIX_MODE)
+
+	switch (port_data->port_irq_mode) {
+	case PCIE_PORT_MSIX_MODE:
 		pci_disable_msix(dev);
-	else if (interrupt_mode == PCIE_PORT_MSI_MODE)
+		break;
+	case PCIE_PORT_MSI_MODE:
 		pci_disable_msi(dev);
+		break;
+	}
+
+	kfree(port_data);
 }
 
 /**
diff -puN include/linux/pcieport_if.h~pci-pcie-portdrv-use-driver-data-to-simplify-code include/linux/pcieport_if.h
--- a/include/linux/pcieport_if.h~pci-pcie-portdrv-use-driver-data-to-simplify-code
+++ a/include/linux/pcieport_if.h
@@ -36,7 +36,6 @@ struct pcie_port_service_id {
 
 struct pcie_device {
 	int 		irq;	    /* Service IRQ/MSI/MSI-X Vector */
-	int 		interrupt_mode;	/* [0:INTx | 1:MSI | 2:MSI-X] */	
 	struct pcie_port_service_id id;	/* Service ID */
 	struct pci_dev	*port;	    /* Root/Upstream/Downstream Port */
 	void		*priv_data; /* Service Private Data */
_

Patches currently in -mm which might be from rjw@sisk.pl are

maintainers-add-entry-for-freezer.patch
linux-next.patch
drivers-consolidate-driver_probe_done-loops-into-one-place.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
resume-wait-for-device-probing-to-finish.patch
pci-pcie-portdrv-use-driver-data-to-simplify-code.patch
pci-pcie-portdrv-aviod-using-service-devices-with-wrong-interrupts-rev-2.patch
pci-pcie-portdrv-do-not-enable-port-device-before-setting-up-interrupts-rev-2.patch
pci-pcie-portdrv-remove-unnecessary-function.patch
pci-pcie-portdrv-simplily-probe-callback-of-service-drivers-rev-2.patch
pci-pcie-portdrv-remove-struct-pcie_port_service_id-rev-3.patch
pci-pcie-portdrv-implement-pm-object.patch
pci-pcie-portdrv-fix-allocation-of-interrupts-rev-3.patch
shrink_slab-handle-bad-shrinkers.patch

