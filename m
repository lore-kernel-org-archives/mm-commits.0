From: akpm@linux-foundation.org
Subject: - 8250-serial-add-oxcb950-chip.patch removed from -mm tree
Date: Thu, 16 Oct 2008 15:58:54 -0700
Message-ID: <200810162258.m9GMwsV0002205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756450AbYJPW7Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 18:59:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre.przywara@amd.com, robert.richter@amd.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     8250 serial: add OXCB950 chip
has been removed from the -mm tree.  Its filename was
     8250-serial-add-oxcb950-chip.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 8250 serial: add OXCB950 chip
From: Andre Przywara <andre.przywara@amd.com>

Add the OXCB950 chip to the 8250 PCI driver.

Chip: Oxford Semiconductor OXCB950 for PCI Cardbus interface
http://www.transdimension.com/products/serial/OXCB950.html

on this card:
ExSys EX-1370 1 port high-speed serial card for ExpressCard/34 slot

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pci.c |    3 +++
 include/linux/pci_ids.h   |    1 +
 2 files changed, 4 insertions(+)

diff -puN drivers/serial/8250_pci.c~8250-serial-add-oxcb950-chip drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~8250-serial-add-oxcb950-chip
+++ a/drivers/serial/8250_pci.c
@@ -2293,6 +2293,9 @@ static struct pci_device_id serial_pci_t
 	{	PCI_VENDOR_ID_OXSEMI, 0x950a,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_2_1130000 },
+	{	PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_C950,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b0_1_921600 },
 	{	PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_16PCI954,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_4_115200 },
diff -puN include/linux/pci_ids.h~8250-serial-add-oxcb950-chip include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~8250-serial-add-oxcb950-chip
+++ a/include/linux/pci_ids.h
@@ -1945,6 +1945,7 @@
 #define PCI_VENDOR_ID_OXSEMI		0x1415
 #define PCI_DEVICE_ID_OXSEMI_12PCI840	0x8403
 #define PCI_DEVICE_ID_OXSEMI_16PCI954	0x9501
+#define PCI_DEVICE_ID_OXSEMI_C950	0x950B
 #define PCI_DEVICE_ID_OXSEMI_16PCI95N	0x9511
 #define PCI_DEVICE_ID_OXSEMI_16PCI954PP	0x9513
 #define PCI_DEVICE_ID_OXSEMI_16PCI952	0x9521
_

Patches currently in -mm which might be from andre.przywara@amd.com are

8250-serial-add-oxcb950-chip.patch

