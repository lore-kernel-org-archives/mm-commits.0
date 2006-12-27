From: akpm@osdl.org
Subject: + pci-probe-fix-macro-that-confuses-kernel-doc.patch added to -mm tree
Date: Tue, 26 Dec 2006 23:40:49 -0800
Message-ID: <200612270740.kBR7enED004602@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37105 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932971AbWL0Hky (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 02:40:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, greg@kroah.com


The patch titled
     pci/probe: fix macro that confuses kernel-doc
has been added to the -mm tree.  Its filename is
     pci-probe-fix-macro-that-confuses-kernel-doc.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -682,6 +682,8 @@ static void pci_read_irq(struct pci_dev 
 	dev->irq = irq;
 }
 
+#define LEGACY_IO_RESOURCE	(IORESOURCE_IO | IORESOURCE_PCI_FIXED)
+
 /**
  * pci_setup_device - fill in class and map information of a device
  * @dev: the device structure to fill
@@ -692,9 +694,6 @@ static void pci_read_irq(struct pci_dev 
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

pci-probe-fix-macro-that-confuses-kernel-doc.patch
git-alsa.patch
git-cpufreq.patch
git-gfs2-nmw.patch
git-mtd.patch
git-netdev-all.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
profile_likely-export-do_check_likely.patch

