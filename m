From: akpm@linux-foundation.org
Subject: - drivers-ata-remove-the-wildcard-from-sata_nv-driver.patch removed from -mm tree
Date: Fri, 18 May 2007 00:07:01 -0700
Message-ID: <200705180707.l4I770NQ010236@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56424 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758578AbXERHJo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 03:09:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pchen@nvidia.com, htejun@gmail.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     drivers/ata: remove the wildcard from sata_nv driver
has been removed from the -mm tree.  Its filename was
     drivers-ata-remove-the-wildcard-from-sata_nv-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -288,12 +288,6 @@ static const struct pci_device_id nv_pci
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

origin.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61-fix-tidy.patch
