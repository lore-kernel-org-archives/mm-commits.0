From: akpm@linux-foundation.org
Subject: - pci-fix-unterminated-pci_device_id-lists.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:15:32 -0700
Message-ID: <200709202115.l8KLFW6i002918@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48953 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752396AbXITVQS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:16:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kees@ubuntu.com, dwmw2@infradead.org, greg@kroah.com, jeff@garzik.org, minyard@acm.org, mm-commits@vger.kernel.org


The patch titled
     pci: fix unterminated pci_device_id lists
has been removed from the -mm tree.  Its filename was
     pci-fix-unterminated-pci_device_id-lists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Corey Minyard <minyard@acm.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Acked-by: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ipmi/ipmi_si_intf.c                |    3 ++-
 drivers/media/video/usbvision/usbvision-cards.c |    1 +
 drivers/mtd/nand/cafe_nand.c                    |    3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)

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
 
diff -puN drivers/media/video/usbvision/usbvision-cards.c~pci-fix-unterminated-pci_device_id-lists drivers/media/video/usbvision/usbvision-cards.c
--- a/drivers/media/video/usbvision/usbvision-cards.c~pci-fix-unterminated-pci_device_id-lists
+++ a/drivers/media/video/usbvision/usbvision-cards.c
@@ -1081,6 +1081,7 @@ struct usb_device_id usbvision_table [] 
 	{ USB_DEVICE(0x2304, 0x0301), .driver_info=PINNA_LINX_VD_IN_CAB_PAL },
 	{ USB_DEVICE(0x2304, 0x0419), .driver_info=PINNA_PCTV_BUNGEE_PAL_FM },
 	{ USB_DEVICE(0x2400, 0x4200), .driver_info=HPG_WINTV },
+	{ },    /* terminate list */
 };
 
 MODULE_DEVICE_TABLE (usb, usbvision_table);
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

git-kbuild.patch
