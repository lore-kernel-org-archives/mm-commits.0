From: akpm@linux-foundation.org
Subject: [merged] hpsa-fix-redefinition-of-pci_device_id_cissf.patch removed from -mm tree
Date: Fri, 10 Dec 2010 11:35:57 -0800
Message-ID: <201012101937.oBAJbvWh031721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756848Ab0LJTiK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Dec 2010 14:38:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.miller@hp.com, James.Bottomley@HansenPartnership.com, scameron@beardog.cce.hp.com, mm-commits@vger.kernel.org


The patch titled
     hpsa: fix redefinition of PCI_DEVICE_ID_CISSF
has been removed from the -mm tree.  Its filename was
     hpsa-fix-redefinition-of-pci_device_id_cissf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hpsa: fix redefinition of PCI_DEVICE_ID_CISSF
From: Mike Miller <mike.miller@hp.com>

drivers/scsi/hpsa.c:93:1: warning: "PCI_DEVICE_ID_HP_CISSF" redefined
In file included from include/linux/pci.h:58,
                 from drivers/scsi/hpsa.c:25:
include/linux/pci_ids.h:746:1: warning: this is the location of the previous definition

PCI_DEVICE_ID_CISSF is defined as 323b in pci_ids.h but redefined as 3fff in
hpsa.c. The ID of 3fff will _never_ ship as a standalone controller. It is
intended only as part a complete storage solution. As such, this patch
removes the redefinition and the StorageWorks P1210m from the product table.

At present 323b controllers will not be recognised due to this bug.

It also removes a duplicate line for the "unknown" controller support.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hpsa.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN drivers/scsi/hpsa.c~hpsa-fix-redefinition-of-pci_device_id_cissf drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c~hpsa-fix-redefinition-of-pci_device_id_cissf
+++ a/drivers/scsi/hpsa.c
@@ -90,11 +90,7 @@ static const struct pci_device_id hpsa_p
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3252},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3253},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3254},
-#define PCI_DEVICE_ID_HP_CISSF 0x333f
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x333F},
-	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,             PCI_ANY_ID, PCI_ANY_ID,
-		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
-	{PCI_VENDOR_ID_COMPAQ,     PCI_ANY_ID,             PCI_ANY_ID, PCI_ANY_ID,
+	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
 		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
 	{0,}
 };
@@ -113,8 +109,6 @@ static struct board_type products[] = {
 	{0x3249103C, "Smart Array P812", &SA5_access},
 	{0x324a103C, "Smart Array P712m", &SA5_access},
 	{0x324b103C, "Smart Array P711m", &SA5_access},
-	{0x3233103C, "StorageWorks P1210m", &SA5_access},
-	{0x333F103C, "StorageWorks P1210m", &SA5_access},
 	{0x3250103C, "Smart Array", &SA5_access},
 	{0x3250113C, "Smart Array", &SA5_access},
 	{0x3250123C, "Smart Array", &SA5_access},
_

Patches currently in -mm which might be from mike.miller@hp.com are

linux-next.patch

