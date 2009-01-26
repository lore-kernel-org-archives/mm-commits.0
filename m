From: akpm@linux-foundation.org
Subject: [merged] pci-pcie-portdrv-implement-pm-object.patch removed from -mm tree
Date: Mon, 26 Jan 2009 11:04:35 -0800
Message-ID: <200901261904.n0QJ4ZiX030154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37741 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753690AbZAZTFZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 14:05:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     PCI PCIe portdrv: implement pm object
has been removed from the -mm tree.  Its filename was
     pci-pcie-portdrv-implement-pm-object.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PCI PCIe portdrv: implement pm object
From: Rafael J. Wysocki <rjw@sisk.pl>

Implement pm object for the PCI Express port driver in order to use the
new power management framework and reduce the code size.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/pciehp_core.c |    4 +-
 drivers/pci/pcie/aer/aerdrv.c     |    6 ---
 drivers/pci/pcie/portdrv.h        |    4 +-
 drivers/pci/pcie/portdrv_core.c   |   14 +++------
 drivers/pci/pcie/portdrv_pci.c    |   43 +++++++++-------------------
 include/linux/pcieport_if.h       |    2 -
 6 files changed, 25 insertions(+), 48 deletions(-)

diff -puN drivers/pci/hotplug/pciehp_core.c~pci-pcie-portdrv-implement-pm-object drivers/pci/hotplug/pciehp_core.c
--- a/drivers/pci/hotplug/pciehp_core.c~pci-pcie-portdrv-implement-pm-object
+++ a/drivers/pci/hotplug/pciehp_core.c
@@ -466,7 +466,7 @@ static void pciehp_remove (struct pcie_d
 }
 
 #ifdef CONFIG_PM
-static int pciehp_suspend (struct pcie_device *dev, pm_message_t state)
+static int pciehp_suspend (struct pcie_device *dev)
 {
 	dev_info(&dev->device, "%s ENTRY\n", __func__);
 	return 0;
@@ -494,7 +494,7 @@ static int pciehp_resume (struct pcie_de
 	}
 	return 0;
 }
-#endif
+#endif /* PM */
 
 static struct pcie_port_service_driver hpdriver_portdrv = {
 	.name		= PCIE_MODULE_NAME,
diff -puN drivers/pci/pcie/aer/aerdrv.c~pci-pcie-portdrv-implement-pm-object drivers/pci/pcie/aer/aerdrv.c
--- a/drivers/pci/pcie/aer/aerdrv.c~pci-pcie-portdrv-implement-pm-object
+++ a/drivers/pci/pcie/aer/aerdrv.c
@@ -40,9 +40,6 @@ MODULE_LICENSE("GPL");
 
 static int __devinit aer_probe (struct pcie_device *dev);
 static void aer_remove(struct pcie_device *dev);
-static int aer_suspend(struct pcie_device *dev, pm_message_t state)
-{return 0;}
-static int aer_resume(struct pcie_device *dev) {return 0;}
 static pci_ers_result_t aer_error_detected(struct pci_dev *dev,
 	enum pci_channel_state error);
 static void aer_error_resume(struct pci_dev *dev);
@@ -61,9 +58,6 @@ static struct pcie_port_service_driver a
 	.probe		= aer_probe,
 	.remove		= aer_remove,
 
-	.suspend	= aer_suspend,
-	.resume		= aer_resume,
-
 	.err_handler	= &aer_error_handlers,
 
 	.reset_link	= aer_root_reset,
diff -puN drivers/pci/pcie/portdrv.h~pci-pcie-portdrv-implement-pm-object drivers/pci/pcie/portdrv.h
--- a/drivers/pci/pcie/portdrv.h~pci-pcie-portdrv-implement-pm-object
+++ a/drivers/pci/pcie/portdrv.h
@@ -32,8 +32,8 @@ extern struct bus_type pcie_port_bus_typ
 extern int pcie_port_device_probe(struct pci_dev *dev);
 extern int pcie_port_device_register(struct pci_dev *dev);
 #ifdef CONFIG_PM
-extern int pcie_port_device_suspend(struct pci_dev *dev, pm_message_t state);
-extern int pcie_port_device_resume(struct pci_dev *dev);
+extern int pcie_port_device_suspend(struct device *dev);
+extern int pcie_port_device_resume(struct device *dev);
 #endif
 extern void pcie_port_device_remove(struct pci_dev *dev);
 extern int __must_check pcie_port_bus_register(void);
diff -puN drivers/pci/pcie/portdrv_core.c~pci-pcie-portdrv-implement-pm-object drivers/pci/pcie/portdrv_core.c
--- a/drivers/pci/pcie/portdrv_core.c~pci-pcie-portdrv-implement-pm-object
+++ a/drivers/pci/pcie/portdrv_core.c
@@ -282,13 +282,12 @@ int pcie_port_device_register(struct pci
 static int suspend_iter(struct device *dev, void *data)
 {
 	struct pcie_port_service_driver *service_driver;
-	pm_message_t state = * (pm_message_t *) data;
 
  	if ((dev->bus == &pcie_port_bus_type) &&
  	    (dev->driver)) {
  		service_driver = to_service_driver(dev->driver);
  		if (service_driver->suspend)
- 			service_driver->suspend(to_pcie_device(dev), state);
+ 			service_driver->suspend(to_pcie_device(dev));
   	}
 	return 0;
 }
@@ -296,11 +295,10 @@ static int suspend_iter(struct device *d
 /**
  * pcie_port_device_suspend - suspend port services associated with a PCIe port
  * @dev: PCI Express port to handle
- * @state: Representation of system power management transition in progress
  */
-int pcie_port_device_suspend(struct pci_dev *dev, pm_message_t state)
+int pcie_port_device_suspend(struct device *dev)
 {
-	return device_for_each_child(&dev->dev, &state, suspend_iter);
+	return device_for_each_child(dev, NULL, suspend_iter);
 }
 
 static int resume_iter(struct device *dev, void *data)
@@ -320,11 +318,11 @@ static int resume_iter(struct device *de
  * pcie_port_device_suspend - resume port services associated with a PCIe port
  * @dev: PCI Express port to handle
  */
-int pcie_port_device_resume(struct pci_dev *dev)
+int pcie_port_device_resume(struct device *dev)
 {
-	return device_for_each_child(&dev->dev, NULL, resume_iter);
+	return device_for_each_child(dev, NULL, resume_iter);
 }
-#endif
+#endif /* PM */
 
 static int remove_iter(struct device *dev, void *data)
 {
diff -puN drivers/pci/pcie/portdrv_pci.c~pci-pcie-portdrv-implement-pm-object drivers/pci/pcie/portdrv_pci.c
--- a/drivers/pci/pcie/portdrv_pci.c~pci-pcie-portdrv-implement-pm-object
+++ a/drivers/pci/pcie/portdrv_pci.c
@@ -44,33 +44,21 @@ static int pcie_portdrv_restore_config(s
 }
 
 #ifdef CONFIG_PM
-static int pcie_portdrv_suspend(struct pci_dev *dev, pm_message_t state)
-{
-	return pcie_port_device_suspend(dev, state);
-
-}
+static struct dev_pm_ops pcie_portdrv_pm_ops = {
+	.suspend = pcie_port_device_suspend,
+	.resume = pcie_port_device_resume,
+	.freeze = pcie_port_device_suspend,
+	.thaw = pcie_port_device_resume,
+	.poweroff = pcie_port_device_suspend,
+	.restore = pcie_port_device_resume,
+};
 
-static int pcie_portdrv_suspend_late(struct pci_dev *dev, pm_message_t state)
-{
-	return pci_save_state(dev);
-}
+#define PCIE_PORTDRV_PM_OPS	(&pcie_portdrv_pm_ops)
 
-static int pcie_portdrv_resume_early(struct pci_dev *dev)
-{
-	return pci_restore_state(dev);
-}
+#else /* !PM */
 
-static int pcie_portdrv_resume(struct pci_dev *dev)
-{
-	pcie_portdrv_restore_config(dev);
-	return pcie_port_device_resume(dev);
-}
-#else
-#define pcie_portdrv_suspend NULL
-#define pcie_portdrv_suspend_late NULL
-#define pcie_portdrv_resume_early NULL
-#define pcie_portdrv_resume NULL
-#endif
+#define PCIE_PORTDRV_PM_OPS	NULL
+#endif /* !PM */
 
 /*
  * pcie_portdrv_probe - Probe PCI-Express port devices
@@ -281,12 +269,9 @@ static struct pci_driver pcie_portdriver
 	.probe		= pcie_portdrv_probe,
 	.remove		= pcie_portdrv_remove,
 
-	.suspend	= pcie_portdrv_suspend,
-	.suspend_late	= pcie_portdrv_suspend_late,
-	.resume_early	= pcie_portdrv_resume_early,
-	.resume		= pcie_portdrv_resume,
-
 	.err_handler 	= &pcie_portdrv_err_handler,
+
+	.driver.pm 	= PCIE_PORTDRV_PM_OPS,
 };
 
 static int __init pcie_portdrv_init(void)
diff -puN include/linux/pcieport_if.h~pci-pcie-portdrv-implement-pm-object include/linux/pcieport_if.h
--- a/include/linux/pcieport_if.h~pci-pcie-portdrv-implement-pm-object
+++ a/include/linux/pcieport_if.h
@@ -55,7 +55,7 @@ struct pcie_port_service_driver {
 	const char *name;
 	int (*probe) (struct pcie_device *dev);
 	void (*remove) (struct pcie_device *dev);
-	int (*suspend) (struct pcie_device *dev, pm_message_t state);
+	int (*suspend) (struct pcie_device *dev);
 	int (*resume) (struct pcie_device *dev);
 
 	/* Service Error Recovery Handler */
_

Patches currently in -mm which might be from rjw@sisk.pl are

linux-next.patch
drivers-consolidate-driver_probe_done-loops-into-one-place.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
resume-wait-for-device-probing-to-finish.patch
shrink_slab-handle-bad-shrinkers.patch

