From: akpm@linux-foundation.org
Subject: [merged] pci-pcie-portdrv-simplily-probe-callback-of-service-drivers-rev-2.patch removed from -mm tree
Date: Mon, 26 Jan 2009 11:04:31 -0800
Message-ID: <200901261904.n0QJ4VLZ030008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753637AbZAZTFX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 14:05:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     PCI PCIe portdrv: simplily probe callback of service drivers
has been removed from the -mm tree.  Its filename was
     pci-pcie-portdrv-simplily-probe-callback-of-service-drivers-rev-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PCI PCIe portdrv: simplily probe callback of service drivers
From: Rafael J. Wysocki <rjw@sisk.pl>

The second argument of the ->probe() callback in struct
pcie_port_service_driver is unnecessary and never used.  Remove it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/pciehp_acpi.c |    3 +--
 drivers/pci/hotplug/pciehp_core.c |    2 +-
 drivers/pci/pcie/aer/aerdrv.c     |    6 ++----
 drivers/pci/pcie/portdrv_core.c   |    2 +-
 include/linux/pcieport_if.h       |    3 +--
 5 files changed, 6 insertions(+), 10 deletions(-)

diff -puN drivers/pci/hotplug/pciehp_acpi.c~pci-pcie-portdrv-simplily-probe-callback-of-service-drivers-rev-2 drivers/pci/hotplug/pciehp_acpi.c
--- a/drivers/pci/hotplug/pciehp_acpi.c~pci-pcie-portdrv-simplily-probe-callback-of-service-drivers-rev-2
+++ a/drivers/pci/hotplug/pciehp_acpi.c
@@ -82,8 +82,7 @@ static int __initdata acpi_slot_detected
 static struct list_head __initdata dummy_slots = LIST_HEAD_INIT(dummy_slots);
 
 /* Dummy driver for dumplicate name detection */
-static int __init dummy_probe(struct pcie_device *dev,
-			      const struct pcie_port_service_id *id)
+static int __init dummy_probe(struct pcie_device *dev)
 {
 	int pos;
 	u32 slot_cap;
diff -puN drivers/pci/hotplug/pciehp_core.c~pci-pcie-portdrv-simplily-probe-callback-of-service-drivers-rev-2 drivers/pci/hotplug/pciehp_core.c
--- a/drivers/pci/hotplug/pciehp_core.c~pci-pcie-portdrv-simplily-probe-callback-of-service-drivers-rev-2
+++ a/drivers/pci/hotplug/pciehp_core.c
@@ -399,7 +399,7 @@ static int get_cur_bus_speed(struct hotp
 	return 0;
 }
 
-static int pciehp_probe(struct pcie_device *dev, const struct pcie_port_service_id *id)
+static int pciehp_probe(struct pcie_device *dev)
 {
 	int rc;
 	struct controller *ctrl;
diff -puN drivers/pci/pcie/aer/aerdrv.c~pci-pcie-portdrv-simplily-probe-callback-of-service-drivers-rev-2 drivers/pci/pcie/aer/aerdrv.c
--- a/drivers/pci/pcie/aer/aerdrv.c~pci-pcie-portdrv-simplily-probe-callback-of-service-drivers-rev-2
+++ a/drivers/pci/pcie/aer/aerdrv.c
@@ -38,8 +38,7 @@ MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
-static int __devinit aer_probe (struct pcie_device *dev,
-	const struct pcie_port_service_id *id );
+static int __devinit aer_probe (struct pcie_device *dev);
 static void aer_remove(struct pcie_device *dev);
 static int aer_suspend(struct pcie_device *dev, pm_message_t state)
 {return 0;}
@@ -207,8 +206,7 @@ static void aer_remove(struct pcie_devic
  *
  * Invoked when PCI Express bus loads AER service driver.
  **/
-static int __devinit aer_probe (struct pcie_device *dev,
-				const struct pcie_port_service_id *id )
+static int __devinit aer_probe (struct pcie_device *dev)
 {
 	int status;
 	struct aer_rpc *rpc;
diff -puN drivers/pci/pcie/portdrv_core.c~pci-pcie-portdrv-simplily-probe-callback-of-service-drivers-rev-2 drivers/pci/pcie/portdrv_core.c
--- a/drivers/pci/pcie/portdrv_core.c~pci-pcie-portdrv-simplily-probe-callback-of-service-drivers-rev-2
+++ a/drivers/pci/pcie/portdrv_core.c
@@ -402,7 +402,7 @@ static int pcie_port_probe_service(struc
 		return -ENODEV;
 
 	pciedev = to_pcie_device(dev);
-	status = driver->probe(pciedev, driver->id_table);
+	status = driver->probe(pciedev);
 	if (!status) {
 		dev_printk(KERN_DEBUG, dev, "service driver %s loaded\n",
 			driver->name);
diff -puN include/linux/pcieport_if.h~pci-pcie-portdrv-simplily-probe-callback-of-service-drivers-rev-2 include/linux/pcieport_if.h
--- a/include/linux/pcieport_if.h~pci-pcie-portdrv-simplily-probe-callback-of-service-drivers-rev-2
+++ a/include/linux/pcieport_if.h
@@ -56,8 +56,7 @@ static inline void* get_service_data(str
 
 struct pcie_port_service_driver {
 	const char *name;
-	int (*probe) (struct pcie_device *dev, 
-		const struct pcie_port_service_id *id);
+	int (*probe) (struct pcie_device *dev);
 	void (*remove) (struct pcie_device *dev);
 	int (*suspend) (struct pcie_device *dev, pm_message_t state);
 	int (*resume) (struct pcie_device *dev);
_

Patches currently in -mm which might be from rjw@sisk.pl are

linux-next.patch
drivers-consolidate-driver_probe_done-loops-into-one-place.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
resume-wait-for-device-probing-to-finish.patch
shrink_slab-handle-bad-shrinkers.patch

