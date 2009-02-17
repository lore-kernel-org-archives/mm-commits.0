From: akpm@linux-foundation.org
Subject: + jsm-additional-device-support.patch added to -mm tree
Date: Tue, 17 Feb 2009 13:31:30 -0800
Message-ID: <200902172131.n1HLVUFa022164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814AbZBQVf3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 16:35:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adam@os.inf.tu-dresden.de, Scott_Kilau@digi.com, alan@lxorguk.ukuu.org.uk, wendyx@us.ibm.com


The patch titled
     jsm: additional device support
has been added to the -mm tree.  Its filename is
     jsm-additional-device-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
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
@@ -1449,6 +1449,7 @@
 #define PCI_DEVICE_ID_DIGI_DF_M_E	0x0071
 #define PCI_DEVICE_ID_DIGI_DF_M_IOM2_A	0x0072
 #define PCI_DEVICE_ID_DIGI_DF_M_A	0x0073
+#define PCI_DEVICE_ID_DIGI_NEO_8	0x00B1
 #define PCI_DEVICE_ID_NEO_2DB9          0x00C8
 #define PCI_DEVICE_ID_NEO_2DB9PRI       0x00C9
 #define PCI_DEVICE_ID_NEO_2RJ45         0x00CA
_

Patches currently in -mm which might be from adam@os.inf.tu-dresden.de are

jsm-additional-device-support.patch

