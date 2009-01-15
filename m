From: akpm@linux-foundation.org
Subject: + pci-pcie-portdrv-simplily-probe-callback-of-service-drivers-rev-2.patch added to -mm tree
Date: Thu, 15 Jan 2009 15:17:21 -0800
Message-ID: <200901152317.n0FNHLKT020817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763655AbZAOXR0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jan 2009 18:17:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, jbarnes@virtuousgeek.org


The patch titled
     PCI PCIe portdrv: simplily probe callback of service drivers
has been added to the -mm tree.  Its filename is
     pci-pcie-portdrv-simplily-probe-callback-of-service-drivers-rev-2.patch

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

