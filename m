From: akpm@linux-foundation.org
Subject: - fix-gregkh-pci-pci-reduce-aer-init-error-information.patch removed from -mm tree
Date: Thu, 24 May 2007 19:23:24 -0700
Message-ID: <200705250223.l4P2NQ0Y009211@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752813AbXEYCXc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 22:23:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yanmin_zhang@linux.intel.com, greg@kroah.com, yanmin.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     fix gregkh-pci-pci-reduce-aer-init-error-information
has been removed from the -mm tree.  Its filename was
     fix-gregkh-pci-pci-reduce-aer-init-error-information.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: fix gregkh-pci-pci-reduce-aer-init-error-information
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>

On Sat, 2007-05-05 at 22:29 +0200, Olaf Hering wrote:
> On Sat, May 05, Andrew Morton wrote:
>
> > +gregkh-pci-pci-reduce-aer-init-error-information.patch
>
> include/linux/pci-acpi.h:57: error: expected ')' before 'handle'
> make[4]: *** [drivers/pci/pcie/portdrv_pci.o] Error 1
>
> acpi_handle is intel only.
Sorry. I didn't check CONFIG_ACPI=n. The acpi header file inclusion
is too complicated.

Below patch against 2.6.21+gregkh-pci-pci-reduce-aer-init-error-information.patch
fixes the compiling issue. I delete the acpi header file inclusion in aerdrv.h,
and move function aer_osc_setup to another file.

I tested it with both CONFIG_ACPI=y and CONFIG_ACPI=n.

Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pcie/aer/Makefile      |    2 
 drivers/pci/pcie/aer/aerdrv.h      |    3 -
 drivers/pci/pcie/aer/aerdrv_acpi.c |   61 ---------------------------
 drivers/pci/pcie/aer/aerdrv_core.c |   41 ++++++++++++++++++
 4 files changed, 42 insertions(+), 65 deletions(-)

diff -puN drivers/pci/pcie/aer/Makefile~fix-gregkh-pci-pci-reduce-aer-init-error-information drivers/pci/pcie/aer/Makefile
--- a/drivers/pci/pcie/aer/Makefile~fix-gregkh-pci-pci-reduce-aer-init-error-information
+++ a/drivers/pci/pcie/aer/Makefile
@@ -4,5 +4,5 @@
 
 obj-$(CONFIG_PCIEAER) += aerdriver.o
 
-aerdriver-objs := aerdrv_errprint.o aerdrv_core.o aerdrv.o aerdrv_acpi.o
+aerdriver-objs := aerdrv_errprint.o aerdrv_core.o aerdrv.o
 
diff -puN drivers/pci/pcie/aer/aerdrv.h~fix-gregkh-pci-pci-reduce-aer-init-error-information drivers/pci/pcie/aer/aerdrv.h
--- a/drivers/pci/pcie/aer/aerdrv.h~fix-gregkh-pci-pci-reduce-aer-init-error-information
+++ a/drivers/pci/pcie/aer/aerdrv.h
@@ -10,8 +10,6 @@
 
 #include <linux/workqueue.h>
 #include <linux/pcieport_if.h>
-#include <linux/acpi.h>
-#include <linux/pci-acpi.h>
 #include <linux/aer.h>
 
 #define AER_NONFATAL			0
@@ -119,6 +117,5 @@ extern void aer_delete_rootport(struct a
 extern int aer_init(struct pcie_device *dev);
 extern void aer_isr(struct work_struct *work);
 extern void aer_print_error(struct pci_dev *dev, struct aer_err_info *info);
-extern acpi_status aer_osc_setup(struct pci_dev *dev);
 
 #endif //_AERDRV_H_
diff -puN drivers/pci/pcie/aer/aerdrv_acpi.c~fix-gregkh-pci-pci-reduce-aer-init-error-information /dev/null
--- a/drivers/pci/pcie/aer/aerdrv_acpi.c
+++ /dev/null
@@ -1,61 +0,0 @@
-/*
- * Access ACPI _OSC method
- *
- * Copyright (C) 2006 Intel Corp.
- *	Tom Long Nguyen (tom.l.nguyen@intel.com)
- *	Zhang Yanmin (yanmin.zhang@intel.com)
- *
- */
-
-#include <linux/module.h>
-#include <linux/pci.h>
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/pm.h>
-#include <linux/suspend.h>
-#include <linux/acpi.h>
-#include <linux/pci-acpi.h>
-#include <linux/delay.h>
-#include "aerdrv.h"
-
-/**
- * aer_osc_setup - run ACPI _OSC method
- *
- * Return:
- *	Zero if success. Nonzero for otherwise.
- *
- * Invoked when PCIE bus loads AER service driver. To avoid conflict with
- * BIOS AER support requires BIOS to yield AER control to OS native driver.
- **/
-acpi_status aer_osc_setup(struct pci_dev *dev)
-{
-	acpi_status status = AE_NOT_FOUND;
-	acpi_handle handle = DEVICE_ACPI_HANDLE(&dev->dev);
-	struct pci_dev *pdev = dev;
-	struct pci_bus *parent;
-
-	while (!handle) {
-		if (!pdev || !pdev->bus->parent)
-			break;
-		parent = pdev->bus->parent;
-		if (!parent->self)
-			/* Parent must be a host bridge */
-			handle = acpi_get_pci_rootbridge_handle(
-					pci_domain_nr(parent),
-					parent->number);
-		else
-			handle = DEVICE_ACPI_HANDLE(
-					&(parent->self->dev));
-		pdev = parent->self;
-	}
-
-	if (!handle)
-		return status;
-
-	pci_osc_support_set(OSC_EXT_PCI_CONFIG_SUPPORT);
-	status = pci_osc_control_set(handle, OSC_PCI_EXPRESS_AER_CONTROL |
-		OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL);
-
-	return status;
-}
-
diff -puN drivers/pci/pcie/aer/aerdrv_core.c~fix-gregkh-pci-pci-reduce-aer-init-error-information drivers/pci/pcie/aer/aerdrv_core.c
--- a/drivers/pci/pcie/aer/aerdrv_core.c~fix-gregkh-pci-pci-reduce-aer-init-error-information
+++ a/drivers/pci/pcie/aer/aerdrv_core.c
@@ -726,6 +726,47 @@ void aer_delete_rootport(struct aer_rpc 
 }
 
 /**
+ * aer_osc_setup - run ACPI _OSC method
+ *
+ * Return:
+ *	Zero if success. Nonzero for otherwise.
+ *
+ * Invoked when PCIE bus loads AER service driver. To avoid conflict with
+ * BIOS AER support requires BIOS to yield AER control to OS native driver.
+ **/
+acpi_status aer_osc_setup(struct pci_dev *dev)
+{
+	acpi_status status = AE_NOT_FOUND;
+	acpi_handle handle = DEVICE_ACPI_HANDLE(&dev->dev);
+	struct pci_dev *pdev = dev;
+	struct pci_bus *parent;
+
+	while (!handle) {
+		if (!pdev || !pdev->bus->parent)
+			break;
+		parent = pdev->bus->parent;
+		if (!parent->self)
+			/* Parent must be a host bridge */
+			handle = acpi_get_pci_rootbridge_handle(
+					pci_domain_nr(parent),
+					parent->number);
+		else
+			handle = DEVICE_ACPI_HANDLE(
+					&(parent->self->dev));
+		pdev = parent->self;
+	}
+
+	if (!handle)
+		return status;
+
+	pci_osc_support_set(OSC_EXT_PCI_CONFIG_SUPPORT);
+	status = pci_osc_control_set(handle, OSC_PCI_EXPRESS_AER_CONTROL |
+		OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL);
+
+	return status;
+}
+
+/**
  * aer_init - provide AER initialization
  * @dev: pointer to AER pcie device
  *
_

Patches currently in -mm which might be from yanmin_zhang@linux.intel.com are

fix-gregkh-pci-pci-reduce-aer-init-error-information.patch
fix-jvc-cdrom-drive-lockup.patch
