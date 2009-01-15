From: akpm@linux-foundation.org
Subject: + pci-pcie-portdrv-remove-struct-pcie_port_service_id-rev-3.patch added to -mm tree
Date: Thu, 15 Jan 2009 15:17:23 -0800
Message-ID: <200901152317.n0FNHOmx020899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758872AbZAOXR3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jan 2009 18:17:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, jbarnes@virtuousgeek.org


The patch titled
     PCI PCIe portdrv: remove struct pcie_port_service_id
has been added to the -mm tree.  Its filename is
     pci-pcie-portdrv-remove-struct-pcie_port_service_id-rev-3.patch

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
Subject: PCI PCIe portdrv: remove struct pcie_port_service_id
From: Rafael J. Wysocki <rjw@sisk.pl>

The PCI Express port driver uses 'struct pcie_port_service_id' for
matching port service devices and drivers, but this structure contains
fields that duplicate information from the port device itself (vendor,
device, subvendor, subdevice) and fields that are not used by any existing
port service driver (class, class_mask, drvier_data).  Also, both existing
port service drivers (AER and PCIe HP) don't even use the vendor and
device fields for device matching.  Therefore 'struct
pcie_port_service_id' can be removed altogether and the only useful
members of it (port_type, service) can be introduced directly into the
port service device and port service driver structures.  That simplifies
the code quite a bit and reduces its size.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/pciehp_acpi.c  |   13 ++-----------
 drivers/pci/hotplug/pciehp_core.c  |   12 ++----------
 drivers/pci/pcie/aer/aerdrv.c      |   16 ++--------------
 drivers/pci/pcie/aer/aerdrv_core.c |   10 +++++-----
 drivers/pci/pcie/portdrv.h         |    5 -----
 drivers/pci/pcie/portdrv_bus.c     |   18 ++++++++++--------
 drivers/pci/pcie/portdrv_core.c    |    5 +----
 include/linux/pcieport_if.h        |   17 ++++++++---------
 8 files changed, 30 insertions(+), 66 deletions(-)

diff -puN drivers/pci/hotplug/pciehp_acpi.c~pci-pcie-portdrv-remove-struct-pcie_port_service_id-rev-3 drivers/pci/hotplug/pciehp_acpi.c
--- a/drivers/pci/hotplug/pciehp_acpi.c~pci-pcie-portdrv-remove-struct-pcie_port_service_id-rev-3
+++ a/drivers/pci/hotplug/pciehp_acpi.c
@@ -67,16 +67,6 @@ static int __init parse_detect_mode(void
 	return PCIEHP_DETECT_DEFAULT;
 }
 
-static struct pcie_port_service_id __initdata port_pci_ids[] = {
-	{
-		.vendor = PCI_ANY_ID,
-		.device = PCI_ANY_ID,
-		.port_type = PCIE_ANY_PORT,
-		.service_type = PCIE_PORT_SERVICE_HP,
-		.driver_data =  0,
-        }, { /* end: all zeroes */ }
-};
-
 static int __initdata dup_slot_id;
 static int __initdata acpi_slot_detected;
 static struct list_head __initdata dummy_slots = LIST_HEAD_INIT(dummy_slots);
@@ -110,7 +100,8 @@ static int __init dummy_probe(struct pci
 
 static struct pcie_port_service_driver __initdata dummy_driver = {
         .name           = "pciehp_dummy",
-        .id_table       = port_pci_ids,
+	.port_type	= PCIE_ANY_PORT,
+	.service	= PCIE_PORT_SERVICE_HP,
         .probe          = dummy_probe,
 };
 
diff -puN drivers/pci/hotplug/pciehp_core.c~pci-pcie-portdrv-remove-struct-pcie_port_service_id-rev-3 drivers/pci/hotplug/pciehp_core.c
--- a/drivers/pci/hotplug/pciehp_core.c~pci-pcie-portdrv-remove-struct-pcie_port_service_id-rev-3
+++ a/drivers/pci/hotplug/pciehp_core.c
@@ -496,18 +496,10 @@ static int pciehp_resume (struct pcie_de
 }
 #endif
 
-static struct pcie_port_service_id port_pci_ids[] = { {
-	.vendor = PCI_ANY_ID,
-	.device = PCI_ANY_ID,
-	.port_type = PCIE_ANY_PORT,
-	.service_type = PCIE_PORT_SERVICE_HP,
-	.driver_data =	0,
-	}, { /* end: all zeroes */ }
-};
-
 static struct pcie_port_service_driver hpdriver_portdrv = {
 	.name		= PCIE_MODULE_NAME,
-	.id_table	= &port_pci_ids[0],
+	.port_type	= PCIE_ANY_PORT,
+	.service	= PCIE_PORT_SERVICE_HP,
 
 	.probe		= pciehp_probe,
 	.remove		= pciehp_remove,
diff -puN drivers/pci/pcie/aer/aerdrv.c~pci-pcie-portdrv-remove-struct-pcie_port_service_id-rev-3 drivers/pci/pcie/aer/aerdrv.c
--- a/drivers/pci/pcie/aer/aerdrv.c~pci-pcie-portdrv-remove-struct-pcie_port_service_id-rev-3
+++ a/drivers/pci/pcie/aer/aerdrv.c
@@ -48,19 +48,6 @@ static pci_ers_result_t aer_error_detect
 static void aer_error_resume(struct pci_dev *dev);
 static pci_ers_result_t aer_root_reset(struct pci_dev *dev);
 
-/*
- * PCI Express bus's AER Root service driver data structure
- */
-static struct pcie_port_service_id aer_id[] = {
-	{
-	.vendor 	= PCI_ANY_ID,
-	.device 	= PCI_ANY_ID,
-	.port_type 	= PCIE_RC_PORT,
-	.service_type 	= PCIE_PORT_SERVICE_AER,
-	},
-	{ /* end: all zeroes */ }
-};
-
 static struct pci_error_handlers aer_error_handlers = {
 	.error_detected = aer_error_detected,
 	.resume = aer_error_resume,
@@ -68,7 +55,8 @@ static struct pci_error_handlers aer_err
 
 static struct pcie_port_service_driver aerdriver = {
 	.name		= "aer",
-	.id_table	= &aer_id[0],
+	.port_type	= PCIE_ANY_PORT,
+	.service	= PCIE_PORT_SERVICE_AER,
 
 	.probe		= aer_probe,
 	.remove		= aer_remove,
diff -puN drivers/pci/pcie/aer/aerdrv_core.c~pci-pcie-portdrv-remove-struct-pcie_port_service_id-rev-3 drivers/pci/pcie/aer/aerdrv_core.c
--- a/drivers/pci/pcie/aer/aerdrv_core.c~pci-pcie-portdrv-remove-struct-pcie_port_service_id-rev-3
+++ a/drivers/pci/pcie/aer/aerdrv_core.c
@@ -320,21 +320,21 @@ static int find_aer_service_iter(struct 
 {
 	struct device_driver *driver;
 	struct pcie_port_service_driver *service_driver;
-	struct pcie_device *pcie_dev;
 	struct find_aer_service_data *result;
 
 	result = (struct find_aer_service_data *) data;
 
 	if (device->bus == &pcie_port_bus_type) {
-		pcie_dev = to_pcie_device(device);
-		if (pcie_dev->id.port_type == PCIE_SW_DOWNSTREAM_PORT)
+		struct pcie_port_data *port_data;
+
+		port_data = pci_get_drvdata(to_pcie_device(device)->port);
+		if (port_data->port_type == PCIE_SW_DOWNSTREAM_PORT)
 			result->is_downstream = 1;
 
 		driver = device->driver;
 		if (driver) {
 			service_driver = to_service_driver(driver);
-			if (service_driver->id_table->service_type ==
-					PCIE_PORT_SERVICE_AER) {
+			if (service_driver->service == PCIE_PORT_SERVICE_AER) {
 				result->aer_driver = service_driver;
 				return 1;
 			}
diff -puN drivers/pci/pcie/portdrv.h~pci-pcie-portdrv-remove-struct-pcie_port_service_id-rev-3 drivers/pci/pcie/portdrv.h
--- a/drivers/pci/pcie/portdrv.h~pci-pcie-portdrv-remove-struct-pcie_port_service_id-rev-3
+++ a/drivers/pci/pcie/portdrv.h
@@ -28,11 +28,6 @@
 
 #define get_descriptor_id(type, service) (((type - 4) << 4) | service)
 
-struct pcie_port_data {
-	int port_type;		/* Type of the port */
-	int port_irq_mode;	/* [0:INTx | 1:MSI | 2:MSI-X] */
-};
-
 extern struct bus_type pcie_port_bus_type;
 extern int pcie_port_device_probe(struct pci_dev *dev);
 extern int pcie_port_device_register(struct pci_dev *dev);
diff -puN drivers/pci/pcie/portdrv_bus.c~pci-pcie-portdrv-remove-struct-pcie_port_service_id-rev-3 drivers/pci/pcie/portdrv_bus.c
--- a/drivers/pci/pcie/portdrv_bus.c~pci-pcie-portdrv-remove-struct-pcie_port_service_id-rev-3
+++ a/drivers/pci/pcie/portdrv_bus.c
@@ -26,20 +26,22 @@ EXPORT_SYMBOL_GPL(pcie_port_bus_type);
 static int pcie_port_bus_match(struct device *dev, struct device_driver *drv)
 {
 	struct pcie_device *pciedev;
+	struct pcie_port_data *port_data;
 	struct pcie_port_service_driver *driver;
 
 	if (drv->bus != &pcie_port_bus_type || dev->bus != &pcie_port_bus_type)
 		return 0;
-	
+
 	pciedev = to_pcie_device(dev);
 	driver = to_service_driver(drv);
-	if (   (driver->id_table->vendor != PCI_ANY_ID && 
-		driver->id_table->vendor != pciedev->id.vendor) ||
-	       (driver->id_table->device != PCI_ANY_ID &&
-		driver->id_table->device != pciedev->id.device) ||	
-	       (driver->id_table->port_type != PCIE_ANY_PORT &&
-		driver->id_table->port_type != pciedev->id.port_type) ||
-		driver->id_table->service_type != pciedev->id.service_type )
+
+	if (driver->service != pciedev->service)
+		return 0;
+
+	port_data = pci_get_drvdata(pciedev->port);
+
+	if (driver->port_type != PCIE_ANY_PORT
+	     && driver->port_type != port_data->port_type)
 		return 0;
 
 	return 1;
diff -puN drivers/pci/pcie/portdrv_core.c~pci-pcie-portdrv-remove-struct-pcie_port_service_id-rev-3 drivers/pci/pcie/portdrv_core.c
--- a/drivers/pci/pcie/portdrv_core.c~pci-pcie-portdrv-remove-struct-pcie_port_service_id-rev-3
+++ a/drivers/pci/pcie/portdrv_core.c
@@ -140,10 +140,7 @@ static void pcie_device_init(struct pci_
 
 	dev->port = parent;
 	dev->irq = irq;
-	dev->id.vendor = parent->vendor;
-	dev->id.device = parent->device;
-	dev->id.port_type = port_type;
-	dev->id.service_type = service_type;
+	dev->service = service_type;
 
 	/* Initialize generic device interface */
 	device = &dev->device;
diff -puN include/linux/pcieport_if.h~pci-pcie-portdrv-remove-struct-pcie_port_service_id-rev-3 include/linux/pcieport_if.h
--- a/include/linux/pcieport_if.h~pci-pcie-portdrv-remove-struct-pcie_port_service_id-rev-3
+++ a/include/linux/pcieport_if.h
@@ -27,18 +27,15 @@
 #define PCIE_PORT_MSI_MODE		1
 #define PCIE_PORT_MSIX_MODE		2
 
-struct pcie_port_service_id {
-	__u32 vendor, device;		/* Vendor and device ID or PCI_ANY_ID*/
-	__u32 subvendor, subdevice;	/* Subsystem ID's or PCI_ANY_ID */
-	__u32 class, class_mask;	/* (class,subclass,prog-if) triplet */
-	__u32 port_type, service_type;	/* Port Entity */
-	kernel_ulong_t driver_data;
+struct pcie_port_data {
+	int port_type;		/* Type of the port */
+	int port_irq_mode;	/* [0:INTx | 1:MSI | 2:MSI-X] */
 };
 
 struct pcie_device {
 	int 		irq;	    /* Service IRQ/MSI/MSI-X Vector */
-	struct pcie_port_service_id id;	/* Service ID */
-	struct pci_dev	*port;	    /* Root/Upstream/Downstream Port */
+	struct pci_dev *port;	    /* Root/Upstream/Downstream Port */
+	u32		service;    /* Port service this device represents */
 	void		*priv_data; /* Service Private Data */
 	struct device	device;     /* Generic Device Interface */
 };
@@ -67,7 +64,9 @@ struct pcie_port_service_driver {
 	/* Link Reset Capability - AER service driver specific */
 	pci_ers_result_t (*reset_link) (struct pci_dev *dev);
 
-	const struct pcie_port_service_id *id_table;
+	int port_type;  /* Type of the port this driver can handle */
+	u32 service;    /* Port service this device represents */
+
 	struct device_driver driver;
 };
 #define to_service_driver(d) \
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

