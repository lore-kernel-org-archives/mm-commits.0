From: akpm@linux-foundation.org
Subject: - mark-pci_module_init-deprecated.patch removed from -mm tree
Date: Thu, 19 Apr 2007 13:02:38 -0700
Message-ID: <200704192002.l3JK2csk029403@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767000AbXDSUCq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 16:02:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: henne@nachtwindheim.de, mm-commits@vger.kernel.org


The patch titled
     mark pci_module_init() deprecated
has been removed from the -mm tree.  Its filename was
     mark-pci_module_init-deprecated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mark pci_module_init() deprecated
From: Henrik Kretzschmar <henne@nachtwindheim.de>

This changes the pci_module_init macro into a static inline function,
which is marked as deprecated.

This should help developers of new drivers to use pci_register_driver().

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pci.h |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN include/linux/pci.h~mark-pci_module_init-deprecated include/linux/pci.h
--- a/include/linux/pci.h~mark-pci_module_init-deprecated
+++ a/include/linux/pci.h
@@ -410,12 +410,6 @@ struct pci_driver {
 	.vendor = PCI_ANY_ID, .device = PCI_ANY_ID, \
 	.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID
 
-/*
- * pci_module_init is obsolete, this stays here till we fix up all usages of it
- * in the tree.
- */
-#define pci_module_init	pci_register_driver
-
 /**
  * PCI_VDEVICE - macro used to describe a specific pci device in short form
  * @vend: the vendor name
@@ -611,6 +605,16 @@ static inline int __must_check pci_regis
 	return __pci_register_driver(driver, THIS_MODULE, KBUILD_MODNAME);
 }
 
+/*
+ * pci_module_init is obsolete, this stays here till we fix up all usages of it
+ * in the tree.
+ */
+
+static inline int __deprecated pci_module_init(struct pci_driver* drv)
+{
+	return pci_register_driver(drv);
+}
+
 void pci_unregister_driver(struct pci_driver *);
 void pci_remove_behind_bridge(struct pci_dev *);
 struct pci_driver *pci_dev_driver(const struct pci_dev *);
_

Patches currently in -mm which might be from henne@nachtwindheim.de are

git-scsi-misc.patch
pci_module_init-convertion-in-tmscsimc.patch
pci_module_init-convertion-for-k8_edacc.patch
