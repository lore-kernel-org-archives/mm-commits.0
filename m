From: akpm@linux-foundation.org
Subject: + pci-aer-fix-warnings-when-pcieaer=n.patch added to -mm tree
Date: Thu, 23 Aug 2007 17:05:12 -0700
Message-ID: <200708240005.l7O05CA4001348@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43450 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764573AbXHXAF0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 20:05:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, greg@kroah.com, kristen.c.accardi@intel.com, linas@austin.ibm.com


The patch titled
     PCI AER: fix warnings when PCIEAER=n
has been added to the -mm tree.  Its filename is
     pci-aer-fix-warnings-when-pcieaer=n.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PCI AER: fix warnings when PCIEAER=n
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix warnings when CONFIG_PCIEAER=n:

drivers/pci/pcie/portdrv_pci.c:105: warning: statement with no effect
drivers/pci/pcie/portdrv_pci.c:226: warning: statement with no effect
drivers/scsi/arcmsr/arcmsr_hba.c:352: warning: statement with no effect

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Greg KH <greg@kroah.com>
Acked-by: Linas Vepstas <linas@austin.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/aer.h |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff -puN include/linux/aer.h~pci-aer-fix-warnings-when-pcieaer=n include/linux/aer.h
--- a/include/linux/aer.h~pci-aer-fix-warnings-when-pcieaer=n
+++ a/include/linux/aer.h
@@ -15,11 +15,26 @@ extern int pci_disable_pcie_error_report
 extern int pci_cleanup_aer_uncorrect_error_status(struct pci_dev *dev);
 extern int pci_cleanup_aer_correct_error_status(struct pci_dev *dev);
 #else
-#define pci_enable_pcie_error_reporting(dev)		(-EINVAL)
-#define pci_find_aer_capability(dev)			(0)
-#define pci_disable_pcie_error_reporting(dev)		(-EINVAL)
-#define pci_cleanup_aer_uncorrect_error_status(dev)	(-EINVAL)
-#define pci_cleanup_aer_correct_error_status(dev)	(-EINVAL)
+static inline int pci_enable_pcie_error_reporting(struct pci_dev *dev)
+{
+	return -EINVAL;
+}
+static inline int pci_find_aer_capability(struct pci_dev *dev)
+{
+	return 0;
+}
+static inline int pci_disable_pcie_error_reporting(struct pci_dev *dev)
+{
+	return -EINVAL;
+}
+static inline int pci_cleanup_aer_uncorrect_error_status(struct pci_dev *dev)
+{
+	return -EINVAL;
+}
+static inline int pci_cleanup_aer_correct_error_status(struct pci_dev *dev)
+{
+	return -EINVAL;
+}
 #endif
 
 #endif //_AER_H_
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

maintainers-update-dco-info.patch
git-acpi.patch
fix-auditscc-kernel-doc.patch
git-mtd.patch
pci-aer-fix-warnings-when-pcieaer=n.patch
git-unionfs.patch
git-ipwireless_cs.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
profile-likely-unlikely-macros.patch
