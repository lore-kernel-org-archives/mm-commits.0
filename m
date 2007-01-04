From: akpm@osdl.org
Subject: - scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch removed from -mm tree
Date: Thu, 04 Jan 2007 15:43:11 -0800
Message-ID: <200701042343.l04NhBkX002881@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:36879 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030283AbXADXnb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 18:43:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, bobf@advansys.com, mm-commits@vger.kernel.org


The patch titled
     SCSI: advansys, wrap PCI table inside ifdef CONFIG_PCI
has been removed from the -mm tree.  Its filename was
     scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SCSI: advansys, wrap PCI table inside ifdef CONFIG_PCI
From: Randy Dunlap <randy.dunlap@oracle.com>

The Advansys ISA/EISA/PCI driver has a compile error when CONFIG_PCI=n, so
wrap the pci_device_id table inside ifdef CONFIG_PCI.

drivers/scsi/advansys.c: At top level:
drivers/scsi/advansys.c:18219: error: array type has incomplete element type
drivers/scsi/advansys.c:18221: error: 'PCI_ANY_ID' undeclared here (not in a function)
make[2]: *** [drivers/scsi/advansys.o] Error 1
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: <bobf@advansys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/advansys.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/advansys.c~scsi-advansys-wrap-pci-table-inside-ifdef-config_pci drivers/scsi/advansys.c
--- a/drivers/scsi/advansys.c~scsi-advansys-wrap-pci-table-inside-ifdef-config_pci
+++ a/drivers/scsi/advansys.c
@@ -18133,6 +18133,7 @@ AdvInquiryHandling(
 }
 MODULE_LICENSE("Dual BSD/GPL");
 
+#ifdef CONFIG_PCI
 /* PCI Devices supported by this driver */
 static struct pci_device_id advansys_pci_tbl[] __devinitdata = {
 	{ PCI_VENDOR_ID_ASP, PCI_DEVICE_ID_ASP_1200A,
@@ -18150,4 +18151,4 @@ static struct pci_device_id advansys_pci
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, advansys_pci_tbl);
-
+#endif /* CONFIG_PCI */
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-alsa.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display.patch
git-mtd.patch
parisc-fix-module_param-iommu-permission.patch
git-scsi-rc-fixes.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
profile_likely-export-do_check_likely.patch
