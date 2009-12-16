From: akpm@linux-foundation.org
Subject: + serial-add-support-for-korenix-jetcard.patch added to -mm tree
Date: Wed, 16 Dec 2009 14:34:11 -0800
Message-ID: <200912162234.nBGMYBmN018875@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752898AbZLPWeq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 17:34:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kiros@korenix.com, alan@linux.intel.com, greg@kroah.com


The patch titled
     serial: add support for Korenix JetCard
has been added to the -mm tree.  Its filename is
     serial-add-support-for-korenix-jetcard.patch

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
Subject: serial: add support for Korenix JetCard
From: Kiros Yeh <kiros@korenix.com>

Add different model (with a different PCI ID) to support Korenix JetCard.

Signed-off-by: Kiros Yeh <kiros@korenix.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pci.c |    9 +++++++++
 include/linux/pci_ids.h   |    2 ++
 2 files changed, 11 insertions(+)

diff -puN drivers/serial/8250_pci.c~serial-add-support-for-korenix-jetcard drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~serial-add-support-for-korenix-jetcard
+++ a/drivers/serial/8250_pci.c
@@ -3199,6 +3199,15 @@ static struct pci_device_id serial_pci_t
 		0x1208, 0x0004, 0, 0,
 		pbn_b0_4_921600 },
 
+	{	PCI_VENDOR_ID_KORENIX, PCI_DEVICE_ID_KORENIX_JETCARDF2,
+		0x1204, 0x0004, 0, 0,
+		pbn_b0_4_921600 },
+	{	PCI_VENDOR_ID_KORENIX, PCI_DEVICE_ID_KORENIX_JETCARDF2,
+		0x1208, 0x0004, 0, 0,
+		pbn_b0_4_921600 },
+	{	PCI_VENDOR_ID_KORENIX, PCI_DEVICE_ID_KORENIX_JETCARDF3,
+		0x1208, 0x0004, 0, 0,
+		pbn_b0_4_921600 },
 	/*
 	 * Dell Remote Access Card 4 - Tim_T_Murphy@Dell.com
 	 */
diff -puN include/linux/pci_ids.h~serial-add-support-for-korenix-jetcard include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~serial-add-support-for-korenix-jetcard
+++ a/include/linux/pci_ids.h
@@ -2333,6 +2333,8 @@
 #define PCI_VENDOR_ID_KORENIX		0x1982
 #define PCI_DEVICE_ID_KORENIX_JETCARDF0	0x1600
 #define PCI_DEVICE_ID_KORENIX_JETCARDF1	0x16ff
+#define PCI_DEVICE_ID_KORENIX_JETCARDF2	0x1700
+#define PCI_DEVICE_ID_KORENIX_JETCARDF3	0x17ff
 
 #define PCI_VENDOR_ID_QMI		0x1a32
 
_

Patches currently in -mm which might be from kiros@korenix.com are

serial-add-support-for-korenix-jetcard.patch

