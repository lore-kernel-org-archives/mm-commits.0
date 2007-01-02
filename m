From: akpm@osdl.org
Subject: - pci-probe-fix-macro-that-confuses-kernel-doc.patch removed from -mm tree
Date: Mon, 01 Jan 2007 23:24:01 -0800
Message-ID: <200701020724.l027O1rq012913@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37256 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932701AbXABHYG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 02:24:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     pci/probe: fix macro that confuses kernel-doc
has been removed from the -mm tree.  Its filename was
     pci-probe-fix-macro-that-confuses-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pci/probe: fix macro that confuses kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Don't have macros between a function's kernel-doc block and the function
definition.  This is not valid for kernel-doc.

Warning(/var/linsrc/linux-2.6.20-rc1-git8//drivers/pci/probe.c:653): No description found for parameter 'IORESOURCE_PCI_FIXED'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/pci/probe.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/pci/probe.c~pci-probe-fix-macro-that-confuses-kernel-doc drivers/pci/probe.c
--- a/drivers/pci/probe.c~pci-probe-fix-macro-that-confuses-kernel-doc
+++ a/drivers/pci/probe.c
@@ -639,6 +639,8 @@ static void pci_read_irq(struct pci_dev 
 	dev->irq = irq;
 }
 
+#define LEGACY_IO_RESOURCE	(IORESOURCE_IO | IORESOURCE_PCI_FIXED)
+
 /**
  * pci_setup_device - fill in class and map information of a device
  * @dev: the device structure to fill
@@ -649,9 +651,6 @@ static void pci_read_irq(struct pci_dev 
  * Returns 0 on success and -1 if unknown type of device (not normal, bridge
  * or CardBus).
  */
-
-#define LEGACY_IO_RESOURCE	(IORESOURCE_IO | IORESOURCE_PCI_FIXED)
-
 static int pci_setup_device(struct pci_dev * dev)
 {
 	u32 class;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-alsa.patch
git-cpufreq.patch
git-gfs2-nmw.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display.patch
git-mtd.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
profile_likely-export-do_check_likely.patch
