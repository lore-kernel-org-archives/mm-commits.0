From: akpm@linux-foundation.org
Subject: [merged] jsm-additional-device-support.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:17:07 -0800
Message-ID: <200902191917.n1JJH7JG016340@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32824 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751927AbZBSTRW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:17:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adam@os.inf.tu-dresden.de, Scott_Kilau@digi.com, alan@lxorguk.ukuu.org.uk, wendyx@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     jsm: additional device support
has been removed from the -mm tree.  Its filename was
     jsm-additional-device-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jsm: additional device support
From: Adam Lackorzynski <adam@os.inf.tu-dresden.de>

I have a Digi Neo 8 PCI card (114f:00b1) Serial controller: Digi
International Digi Neo 8 (rev 05)

that works with the jsm driver after using the following patch.

Signed-off-by: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
Cc: Scott H Kilau <Scott_Kilau@digi.com>
Cc: Wendy Xiong <wendyx@us.ibm.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/jsm/jsm_driver.c |    3 +++
 include/linux/pci_ids.h         |    1 +
 2 files changed, 4 insertions(+)

diff -puN drivers/serial/jsm/jsm_driver.c~jsm-additional-device-support drivers/serial/jsm/jsm_driver.c
--- a/drivers/serial/jsm/jsm_driver.c~jsm-additional-device-support
+++ a/drivers/serial/jsm/jsm_driver.c
@@ -84,6 +84,8 @@ static int jsm_probe_one(struct pci_dev 
 	brd->pci_dev = pdev;
 	if (pdev->device == PCIE_DEVICE_ID_NEO_4_IBM)
 		brd->maxports = 4;
+	else if (pdev->device == PCI_DEVICE_ID_DIGI_NEO_8)
+		brd->maxports = 8;
 	else
 		brd->maxports = 2;
 
@@ -212,6 +214,7 @@ static struct pci_device_id jsm_pci_tbl[
 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_NEO_2RJ45), 0, 0, 2 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_NEO_2RJ45PRI), 0, 0, 3 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCIE_DEVICE_ID_NEO_4_IBM), 0, 0, 4 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_DIGI_NEO_8), 0, 0, 5 },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, jsm_pci_tbl);
diff -puN include/linux/pci_ids.h~jsm-additional-device-support include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~jsm-additional-device-support
+++ a/include/linux/pci_ids.h
@@ -1445,6 +1445,7 @@
 #define PCI_DEVICE_ID_DIGI_DF_M_E	0x0071
 #define PCI_DEVICE_ID_DIGI_DF_M_IOM2_A	0x0072
 #define PCI_DEVICE_ID_DIGI_DF_M_A	0x0073
+#define PCI_DEVICE_ID_DIGI_NEO_8	0x00B1
 #define PCI_DEVICE_ID_NEO_2DB9          0x00C8
 #define PCI_DEVICE_ID_NEO_2DB9PRI       0x00C9
 #define PCI_DEVICE_ID_NEO_2RJ45         0x00CA
_

Patches currently in -mm which might be from adam@os.inf.tu-dresden.de are

origin.patch

