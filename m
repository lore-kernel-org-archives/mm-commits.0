From: akpm@linux-foundation.org
Subject: + allow-aer-to-build-for-config_acpi-=-n.patch added to -mm tree
Date: Tue, 29 May 2007 13:08:39 -0700
Message-ID: <200705292008.l4TK8dwj010326@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752071AbXE2UJS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 16:09:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael@ellerman.id.au, greg@kroah.com, kristen.c.accardi@intel.com, yanmin.zhang@intel.com


The patch titled
     Allow AER to build for CONFIG_ACPI = n
has been added to the -mm tree.  Its filename is
     allow-aer-to-build-for-config_acpi-=-n.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Allow AER to build for CONFIG_ACPI = n
From: Michael Ellerman <michael@ellerman.id.au>

This patch allows the PCIE AER driver to build for CONFIG_ACPI = n. To do
this we move all the ACPI specific code into aerdrv_acpi.c, and only build
that for CONFIG_ACPI = y.

Built for x86_64 ACPI=y/n, and for powerpc (ACPI=n).

Acked-by: "Zhang, Yanmin" <yanmin.zhang@intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pcie/aer/Kconfig       |    2 -
 drivers/pci/pcie/aer/Makefile      |    3 +-
 drivers/pci/pcie/aer/aerdrv.h      |   12 +++++++---
 drivers/pci/pcie/aer/aerdrv_acpi.c |   31 ++++++++++++++++-----------
 drivers/pci/pcie/aer/aerdrv_core.c |   18 +--------------
 5 files changed, 33 insertions(+), 33 deletions(-)

diff -puN drivers/pci/pcie/aer/Kconfig~allow-aer-to-build-for-config_acpi-=-n drivers/pci/pcie/aer/Kconfig
--- a/drivers/pci/pcie/aer/Kconfig~allow-aer-to-build-for-config_acpi-=-n
+++ a/drivers/pci/pcie/aer/Kconfig
@@ -4,7 +4,7 @@
 
 config PCIEAER
 	boolean "Root Port Advanced Error Reporting support"
-	depends on PCIEPORTBUS && ACPI
+	depends on PCIEPORTBUS
 	default y
 	help
 	  This enables PCI Express Root Port Advanced Error Reporting
diff -puN drivers/pci/pcie/aer/Makefile~allow-aer-to-build-for-config_acpi-=-n drivers/pci/pcie/aer/Makefile
--- a/drivers/pci/pcie/aer/Makefile~allow-aer-to-build-for-config_acpi-=-n
+++ a/drivers/pci/pcie/aer/Makefile
@@ -4,5 +4,6 @@
 
 obj-$(CONFIG_PCIEAER) += aerdriver.o
 
-aerdriver-objs := aerdrv_errprint.o aerdrv_core.o aerdrv.o aerdrv_acpi.o
+aerdriver-objs := aerdrv_errprint.o aerdrv_core.o aerdrv.o
+aerdriver-$(CONFIG_ACPI) += aerdrv_acpi.o
 
diff -puN drivers/pci/pcie/aer/aerdrv.h~allow-aer-to-build-for-config_acpi-=-n drivers/pci/pcie/aer/aerdrv.h
--- a/drivers/pci/pcie/aer/aerdrv.h~allow-aer-to-build-for-config_acpi-=-n
+++ a/drivers/pci/pcie/aer/aerdrv.h
@@ -10,8 +10,6 @@
 
 #include <linux/workqueue.h>
 #include <linux/pcieport_if.h>
-#include <linux/acpi.h>
-#include <linux/pci-acpi.h>
 #include <linux/aer.h>
 
 #define AER_NONFATAL			0
@@ -119,6 +117,14 @@ extern void aer_delete_rootport(struct a
 extern int aer_init(struct pcie_device *dev);
 extern void aer_isr(struct work_struct *work);
 extern void aer_print_error(struct pci_dev *dev, struct aer_err_info *info);
-extern acpi_status aer_osc_setup(struct pci_dev *dev);
+
+#ifdef CONFIG_ACPI
+extern int aer_osc_setup(struct pcie_device *pciedev);
+#else
+static inline int aer_osc_setup(struct pcie_device *pciedev)
+{
+	return 0;
+}
+#endif
 
 #endif //_AERDRV_H_
diff -puN drivers/pci/pcie/aer/aerdrv_acpi.c~allow-aer-to-build-for-config_acpi-=-n drivers/pci/pcie/aer/aerdrv_acpi.c
--- a/drivers/pci/pcie/aer/aerdrv_acpi.c~allow-aer-to-build-for-config_acpi-=-n
+++ a/drivers/pci/pcie/aer/aerdrv_acpi.c
@@ -20,18 +20,18 @@
 
 /**
  * aer_osc_setup - run ACPI _OSC method
+ * @pciedev: pcie_device which AER is being enabled on
  *
- * Return:
- *	Zero if success. Nonzero for otherwise.
+ * @return: Zero on success. Nonzero otherwise.
  *
  * Invoked when PCIE bus loads AER service driver. To avoid conflict with
  * BIOS AER support requires BIOS to yield AER control to OS native driver.
  **/
-acpi_status aer_osc_setup(struct pci_dev *dev)
+int aer_osc_setup(struct pcie_device *pciedev)
 {
 	acpi_status status = AE_NOT_FOUND;
-	acpi_handle handle = DEVICE_ACPI_HANDLE(&dev->dev);
-	struct pci_dev *pdev = dev;
+	struct pci_dev *pdev = pciedev->port;
+	acpi_handle handle = DEVICE_ACPI_HANDLE(&pdev->dev);
 	struct pci_bus *parent;
 
 	while (!handle) {
@@ -49,13 +49,20 @@ acpi_status aer_osc_setup(struct pci_dev
 		pdev = parent->self;
 	}
 
-	if (!handle)
-		return status;
+	if (handle) {
+		pci_osc_support_set(OSC_EXT_PCI_CONFIG_SUPPORT);
+		status = pci_osc_control_set(handle,
+					OSC_PCI_EXPRESS_AER_CONTROL |
+					OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL);
+	}
 
-	pci_osc_support_set(OSC_EXT_PCI_CONFIG_SUPPORT);
-	status = pci_osc_control_set(handle, OSC_PCI_EXPRESS_AER_CONTROL |
-		OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL);
+	if (ACPI_FAILURE(status)) {
+		printk(KERN_DEBUG "AER service couldn't init device %s - %s\n",
+		    pciedev->device.bus_id,
+		    (status == AE_SUPPORT || status == AE_NOT_FOUND) ?
+		    "no _OSC support" : "Run ACPI _OSC fails");
+		return -1;
+	}
 
-	return status;
+	return 0;
 }
-
diff -puN drivers/pci/pcie/aer/aerdrv_core.c~allow-aer-to-build-for-config_acpi-=-n drivers/pci/pcie/aer/aerdrv_core.c
--- a/drivers/pci/pcie/aer/aerdrv_core.c~allow-aer-to-build-for-config_acpi-=-n
+++ a/drivers/pci/pcie/aer/aerdrv_core.c
@@ -22,8 +22,6 @@
 #include <linux/errno.h>
 #include <linux/pm.h>
 #include <linux/suspend.h>
-#include <linux/acpi.h>
-#include <linux/pci-acpi.h>
 #include <linux/delay.h>
 #include "aerdrv.h"
 
@@ -733,20 +731,8 @@ void aer_delete_rootport(struct aer_rpc 
  **/
 int aer_init(struct pcie_device *dev)
 {
-	acpi_status	status;
-
-	/* Run _OSC Method */
-	status = aer_osc_setup(dev->port);
-
-	if (ACPI_FAILURE(status)) {
-		printk(KERN_DEBUG "AER service couldn't init device %s - %s\n",
-		    dev->device.bus_id,
-		    (status == AE_SUPPORT || status == AE_NOT_FOUND) ?
-		    "no _OSC support" : "Run ACPI _OSC fails");
-
-		if (!forceload)
-			return -ENXIO;
-	}
+	if (aer_osc_setup(dev) && !forceload)
+		return -ENXIO;
 
 	return AER_SUCCESS;
 }
_

Patches currently in -mm which might be from michael@ellerman.id.au are

allow-aer-to-build-for-config_acpi-=-n.patch
msi-fix-the-ordering-of-msix-irqs.patch
