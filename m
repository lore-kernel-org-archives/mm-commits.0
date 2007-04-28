From: akpm@linux-foundation.org
Subject: + drivers-ata-remove-the-wildcard-from-sata_nv-driver.patch added to -mm tree
Date: Sat, 28 Apr 2007 00:34:29 -0700
Message-ID: <200704280734.l3S7YTpb017287@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161579AbXD1Heg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 03:34:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pchen@nvidia.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     drivers/ata: remove the wildcard from sata_nv driver
has been added to the -mm tree.  Its filename is
     drivers-ata-remove-the-wildcard-from-sata_nv-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/ata: remove the wildcard from sata_nv driver
From: "Peer Chen" <pchen@nvidia.com>

Because nvidia SATA controllers onward base on AHCI, so wildcard in sata_nv
driver is unnecessary.  Also the wildcard sometimes cause sata_nv driver to
be loaded for AHCI controllers,which is not as expected.

Signed-off-by: Peer Chen <pchen@nvidia.com>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_nv.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/ata/sata_nv.c~drivers-ata-remove-the-wildcard-from-sata_nv-driver drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~drivers-ata-remove-the-wildcard-from-sata_nv-driver
+++ a/drivers/ata/sata_nv.c
@@ -286,12 +286,6 @@ static const struct pci_device_id nv_pci
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA), GENERIC },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA2), GENERIC },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA3), GENERIC },
-	{ PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
-		PCI_ANY_ID, PCI_ANY_ID,
-		PCI_CLASS_STORAGE_IDE<<8, 0xffff00, GENERIC },
-	{ PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
-		PCI_ANY_ID, PCI_ANY_ID,
-		PCI_CLASS_STORAGE_RAID<<8, 0xffff00, GENERIC },
 
 	{ } /* terminate list */
 };
_

Patches currently in -mm which might be from pchen@nvidia.com are

drivers-ata-remove-the-wildcard-from-sata_nv-driver.patch
