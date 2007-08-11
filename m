From: akpm@linux-foundation.org
Subject: - megaraid-add-cerc_ata100-support.patch removed from -mm tree
Date: Fri, 10 Aug 2007 17:11:28 -0700
Message-ID: <200708110011.l7B0BStN016928@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59857 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754650AbXHKALl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Aug 2007 20:11:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tkrah@fachschaft.imn.htwk-leipzig.de, Sumant.Patro@lsi.com, protasnb@gmail.com, mm-commits@vger.kernel.org


The patch titled
     megaraid: add CERC_ATA100 support
has been removed from the -mm tree.  Its filename was
     megaraid-add-cerc_ata100-support.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: megaraid: add CERC_ATA100 support
From: Torsten Krah <tkrah@fachschaft.imn.htwk-leipzig.de>

Taken from http://bugzilla.kernel.org/show_bug.cgi?id=6695

Add support for this device to the old megaraid driver.

Cc: Natalie Protasevich <protasnb@gmail.com>
Cc: "Patro, Sumant" <Sumant.Patro@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid.c |    2 ++
 drivers/scsi/megaraid.h |    2 ++
 2 files changed, 4 insertions(+)

diff -puN drivers/scsi/megaraid.c~megaraid-add-cerc_ata100-support drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~megaraid-add-cerc_ata100-support
+++ a/drivers/scsi/megaraid.c
@@ -4967,6 +4967,8 @@ static struct pci_device_id megaraid_pci
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID2,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID3,
+		PCI_VENDOR_ID_DELL, PCI_SUBSYS_ID_CERC_ATA100, 0, 0, 0},
 	{PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_AMI_MEGARAID3,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0,}
diff -puN drivers/scsi/megaraid.h~megaraid-add-cerc_ata100-support drivers/scsi/megaraid.h
--- a/drivers/scsi/megaraid.h~megaraid-add-cerc_ata100-support
+++ a/drivers/scsi/megaraid.h
@@ -84,6 +84,8 @@
 #define LSI_SUBSYS_VID			0x1000
 #define INTEL_SUBSYS_VID		0x8086
 
+#define PCI_SUBSYS_ID_CERC_ATA100	0x0511
+
 #define HBA_SIGNATURE	      		0x3344
 #define HBA_SIGNATURE_471	  	0xCCCC
 #define HBA_SIGNATURE_64BIT		0x0299
_

Patches currently in -mm which might be from tkrah@fachschaft.imn.htwk-leipzig.de are

megaraid-add-cerc_ata100-support.patch
