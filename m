From: akpm@linux-foundation.org
Subject: - pci-fix-unterminated-pci_device_id-lists-fix.patch removed from -mm tree
Date: Tue, 18 Sep 2007 22:02:34 -0700
Message-ID: <200709190502.l8J52YRM007859@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56056 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751383AbXISFCk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Sep 2007 01:02:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kees@ubuntu.com, mm-commits@vger.kernel.org


The patch titled
     misc: fix unterminated *_device_id lists
has been removed from the -mm tree.  Its filename was
     pci-fix-unterminated-pci_device_id-lists-fix.patch

This patch was dropped because it was folded into pci-fix-unterminated-pci_device_id-lists.patch

------------------------------------------------------
Subject: misc: fix unterminated *_device_id lists
From: Kees Cook <kees@ubuntu.com>

Fixes drivers that do not correctly terminate their *_device_id lists. 
This results in garbage being spewed into modules.pcimap when the module
happens to not have 28 NULL bytes following the table, and/or the last PCI
ID is actually truncated from the table when calculating the modules.alias
PCI aliases, causing those unfortunate device IDs to not auto-load.

Signed-off-by: Kees Cook <kees@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/usbvision/usbvision-cards.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/media/video/usbvision/usbvision-cards.c~pci-fix-unterminated-pci_device_id-lists-fix drivers/media/video/usbvision/usbvision-cards.c
--- a/drivers/media/video/usbvision/usbvision-cards.c~pci-fix-unterminated-pci_device_id-lists-fix
+++ a/drivers/media/video/usbvision/usbvision-cards.c
@@ -1081,6 +1081,7 @@ struct usb_device_id usbvision_table [] 
 	{ USB_DEVICE(0x2304, 0x0301), .driver_info=PINNA_LINX_VD_IN_CAB_PAL },
 	{ USB_DEVICE(0x2304, 0x0419), .driver_info=PINNA_PCTV_BUNGEE_PAL_FM },
 	{ USB_DEVICE(0x2400, 0x4200), .driver_info=HPG_WINTV },
+	{ },    /* terminate list */
 };
 
 MODULE_DEVICE_TABLE (usb, usbvision_table);
_

Patches currently in -mm which might be from kees@ubuntu.com are

pci-fix-unterminated-pci_device_id-lists.patch
pci-fix-unterminated-pci_device_id-lists-fix.patch
git-kbuild.patch
pvrusb2-hdw-terminate-usb-device-id-table-differently.patch
