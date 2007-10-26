From: akpm@linux-foundation.org
Subject: - ata-sata_nv-mcp61-using-generic-instead-of-swncq.patch removed from -mm tree
Date: Fri, 26 Oct 2007 11:48:15 -0700
Message-ID: <200710261848.l9QImFPZ009123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43349 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699AbXJZSsR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Oct 2007 14:48:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kluo@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     ata: sata_nv MCP61 using GENERIC instead of SWNCQ
has been removed from the -mm tree.  Its filename was
     ata-sata_nv-mcp61-using-generic-instead-of-swncq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ata: sata_nv MCP61 using GENERIC instead of SWNCQ
From: "Kuan Luo" <kluo@nvidia.com>

The mcp61 has bug with ncq.  The patch only changes SWNCQ to GENERIC on MCP61
in nv_pci_tbl structure.  

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_nv.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/ata/sata_nv.c~ata-sata_nv-mcp61-using-generic-instead-of-swncq drivers/ata/sata_nv.c
--- a/drivers/ata/sata_nv.c~ata-sata_nv-mcp61-using-generic-instead-of-swncq
+++ a/drivers/ata/sata_nv.c
@@ -365,9 +365,9 @@ static const struct pci_device_id nv_pci
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SATA2), SWNCQ },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA), SWNCQ },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SATA2), SWNCQ },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA), SWNCQ },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA2), SWNCQ },
-	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA3), SWNCQ },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA), GENERIC },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA2), GENERIC },
+	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA3), GENERIC },
 
 	{ } /* terminate list */
 };
_

Patches currently in -mm which might be from kluo@nvidia.com are

origin.patch
