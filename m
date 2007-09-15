From: akpm@linux-foundation.org
Subject: + pci-fix-unterminated-pci_device_id-lists.patch added to -mm tree
Date: Sat, 15 Sep 2007 02:40:20 -0700
Message-ID: <200709150940.l8F9eKcx027603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40871 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751981AbXIOJko (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 15 Sep 2007 05:40:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kees@ubuntu.com, dwmw2@infradead.org, greg@kroah.com, jeff@garzik.org, minyard@acm.org


The patch titled
     pci: fix unterminated pci_device_id lists
has been added to the -mm tree.  Its filename is
     pci-fix-unterminated-pci_device_id-lists.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pci: fix unterminated pci_device_id lists
From: Kees Cook <kees@ubuntu.com>

Fix a couple drivers that do not correctly terminate their pci_device_id
lists.  This results in garbage being spewed into modules.pcimap when the
module happens to not have 28 NULL bytes following the table, and/or the
last PCI ID is actually truncated from the table when calculating the
modules.alias PCI aliases, cause those unfortunate device IDs to not
auto-load.

Signed-off-by: Kees Cook <kees@ubuntu.com>
Cc: Corey Minyard <minyard@acm.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Acked-by: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c |    3 ++-
 drivers/mtd/nand/cafe_nand.c     |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/char/ipmi/ipmi_si_intf.c~pci-fix-unterminated-pci_device_id-lists drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~pci-fix-unterminated-pci_device_id-lists
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -2215,7 +2215,8 @@ static int ipmi_pci_resume(struct pci_de
 
 static struct pci_device_id ipmi_pci_devices[] = {
 	{ PCI_DEVICE(PCI_HP_VENDOR_ID, PCI_MMC_DEVICE_ID) },
-	{ PCI_DEVICE_CLASS(PCI_ERMC_CLASSCODE, PCI_ERMC_CLASSCODE_MASK) }
+	{ PCI_DEVICE_CLASS(PCI_ERMC_CLASSCODE, PCI_ERMC_CLASSCODE_MASK) },
+	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, ipmi_pci_devices);
 
diff -puN drivers/mtd/nand/cafe_nand.c~pci-fix-unterminated-pci_device_id-lists drivers/mtd/nand/cafe_nand.c
--- a/drivers/mtd/nand/cafe_nand.c~pci-fix-unterminated-pci_device_id-lists
+++ a/drivers/mtd/nand/cafe_nand.c
@@ -816,7 +816,8 @@ static void __devexit cafe_nand_remove(s
 }
 
 static struct pci_device_id cafe_nand_tbl[] = {
-	{ 0x11ab, 0x4100, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_MEMORY_FLASH << 8, 0xFFFF0 }
+	{ 0x11ab, 0x4100, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_MEMORY_FLASH << 8, 0xFFFF0 },
+	{ 0, }
 };
 
 MODULE_DEVICE_TABLE(pci, cafe_nand_tbl);
_

Patches currently in -mm which might be from kees@ubuntu.com are

pci-fix-unterminated-pci_device_id-lists.patch
modpost-detect-unterminated-device-id-lists.patch
modpost-detect-unterminated-device-id-lists-fix.patch
