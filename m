From: akpm@linux-foundation.org
Subject: [merged] pci-shut-off-pci_find_device-warnings-when-the-deprecated-pci-functions-are-enabled.patch removed from -mm tree
Date: Wed, 29 Jul 2009 12:35:17 -0700
Message-ID: <200907291935.n6TJZH0r003409@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750977AbZG2TfY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 15:35:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     pci: shut off pci_find_device warnings when the deprecated pci functions are enabled.
has been removed from the -mm tree.  Its filename was
     pci-shut-off-pci_find_device-warnings-when-the-deprecated-pci-functions-are-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: shut off pci_find_device warnings when the deprecated pci functions are enabled.
From: Andi Kleen <andi@firstfloor.org>

Shut off the long standing

linux/drivers/pci/search.c:144: warning: 'pci_find_device' is deprecated (declared at linux/drivers/pci/search.c:136)
linux/drivers/pci/search.c:144: warning: 'pci_find_device' is deprecated (declared at linux/drivers/pci/search.c:136)

warnings that appear on every build when CONFIG_PCI_LEGACY is enabled.

gcc warns for the use in EXPORT_SYMBOL

I moved these to a separate file and disabled the warning in the Makefile
for that file.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/Makefile |    3 +++
 drivers/pci/legacy.c |   34 ++++++++++++++++++++++++++++++++++
 drivers/pci/search.c |   31 -------------------------------
 3 files changed, 37 insertions(+), 31 deletions(-)

diff -puN drivers/pci/Makefile~pci-shut-off-pci_find_device-warnings-when-the-deprecated-pci-functions-are-enabled drivers/pci/Makefile
--- a/drivers/pci/Makefile~pci-shut-off-pci_find_device-warnings-when-the-deprecated-pci-functions-are-enabled
+++ a/drivers/pci/Makefile
@@ -8,6 +8,9 @@ obj-y		+= access.o bus.o probe.o remove.
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_SYSFS) += slot.o
 
+obj-$(CONFIG_PCI_LEGACY) += legacy.o
+CFLAGS_legacy.o += -Wno-deprecated-declarations
+
 # Build PCI Express stuff if needed
 obj-$(CONFIG_PCIEPORTBUS) += pcie/
 
diff -puN /dev/null drivers/pci/legacy.c
--- /dev/null
+++ a/drivers/pci/legacy.c
@@ -0,0 +1,34 @@
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include "pci.h"
+
+/**
+ * pci_find_device - begin or continue searching for a PCI device by vendor/device id
+ * @vendor: PCI vendor id to match, or %PCI_ANY_ID to match all vendor ids
+ * @device: PCI device id to match, or %PCI_ANY_ID to match all device ids
+ * @from: Previous PCI device found in search, or %NULL for new search.
+ *
+ * Iterates through the list of known PCI devices.  If a PCI device is found
+ * with a matching @vendor and @device, a pointer to its device structure is
+ * returned.  Otherwise, %NULL is returned.
+ * A new search is initiated by passing %NULL as the @from argument.
+ * Otherwise if @from is not %NULL, searches continue from next device
+ * on the global list.
+ *
+ * NOTE: Do not use this function any more; use pci_get_device() instead, as
+ * the PCI device returned by this function can disappear at any moment in
+ * time.
+ */
+struct pci_dev *pci_find_device(unsigned int vendor, unsigned int device,
+				struct pci_dev *from)
+{
+	struct pci_dev *pdev;
+
+	pci_dev_get(from);
+	pdev = pci_get_subsys(vendor, device, PCI_ANY_ID, PCI_ANY_ID, from);
+	pci_dev_put(pdev);
+	return pdev;
+}
+EXPORT_SYMBOL(pci_find_device);
diff -puN drivers/pci/search.c~pci-shut-off-pci_find_device-warnings-when-the-deprecated-pci-functions-are-enabled drivers/pci/search.c
--- a/drivers/pci/search.c~pci-shut-off-pci_find_device-warnings-when-the-deprecated-pci-functions-are-enabled
+++ a/drivers/pci/search.c
@@ -113,37 +113,6 @@ pci_find_next_bus(const struct pci_bus *
 	return b;
 }
 
-#ifdef CONFIG_PCI_LEGACY
-/**
- * pci_find_device - begin or continue searching for a PCI device by vendor/device id
- * @vendor: PCI vendor id to match, or %PCI_ANY_ID to match all vendor ids
- * @device: PCI device id to match, or %PCI_ANY_ID to match all device ids
- * @from: Previous PCI device found in search, or %NULL for new search.
- *
- * Iterates through the list of known PCI devices.  If a PCI device is found
- * with a matching @vendor and @device, a pointer to its device structure is
- * returned.  Otherwise, %NULL is returned.
- * A new search is initiated by passing %NULL as the @from argument.
- * Otherwise if @from is not %NULL, searches continue from next device
- * on the global list.
- *
- * NOTE: Do not use this function any more; use pci_get_device() instead, as
- * the PCI device returned by this function can disappear at any moment in
- * time.
- */
-struct pci_dev *pci_find_device(unsigned int vendor, unsigned int device,
-				struct pci_dev *from)
-{
-	struct pci_dev *pdev;
-
-	pci_dev_get(from);
-	pdev = pci_get_subsys(vendor, device, PCI_ANY_ID, PCI_ANY_ID, from);
-	pci_dev_put(pdev);
-	return pdev;
-}
-EXPORT_SYMBOL(pci_find_device);
-#endif /* CONFIG_PCI_LEGACY */
