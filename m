From: akpm@linux-foundation.org
Subject: - pata-add-the-mcp73-77-support-to-pata-driver.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:58:03 -0700
Message-ID: <200706121858.l5CIw3fQ018513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34468 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980AbXFLTEI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:04:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peerchen@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     PATA: add the MCP73/77 support to PATA driver
has been removed from the -mm tree.  Its filename was
     pata-add-the-mcp73-77-support-to-pata-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PATA: add the MCP73/77 support to PATA driver
From: "Peer Chen" <peerchen@gmail.com>

Add the MCP73/MCP77 support to PATA driver.

Signed-off-by: Peer Chen <peerchen@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_amd.c    |    2 ++
 drivers/ide/pci/amd74xx.c |    2 ++
 include/linux/pci_ids.h   |    2 ++
 3 files changed, 6 insertions(+)

diff -puN drivers/ata/pata_amd.c~pata-add-the-mcp73-77-support-to-pata-driver drivers/ata/pata_amd.c
--- a/drivers/ata/pata_amd.c~pata-add-the-mcp73-77-support-to-pata-driver
+++ a/drivers/ata/pata_amd.c
@@ -693,6 +693,8 @@ static const struct pci_device_id amd[] 
 	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_IDE),	8 },
 	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP65_IDE),	8 },
 	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP67_IDE),	8 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_IDE),	8 },
+	{ PCI_VDEVICE(NVIDIA,	PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE),	8 },
 	{ PCI_VDEVICE(AMD,	PCI_DEVICE_ID_AMD_CS5536_IDE),		9 },
 
 	{ },
diff -puN drivers/ide/pci/amd74xx.c~pata-add-the-mcp73-77-support-to-pata-driver drivers/ide/pci/amd74xx.c
--- a/drivers/ide/pci/amd74xx.c~pata-add-the-mcp73-77-support-to-pata-driver
+++ a/drivers/ide/pci/amd74xx.c
@@ -76,6 +76,8 @@ static struct amd_ide_chip {
 	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_IDE,	0x50, AMD_UDMA_133 },
 	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP65_IDE,	0x50, AMD_UDMA_133 },
 	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP67_IDE,	0x50, AMD_UDMA_133 },
+	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_IDE,	0x50, AMD_UDMA_133 },
+	{ PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE,	0x50, AMD_UDMA_133 },
 	{ PCI_DEVICE_ID_AMD_CS5536_IDE,			0x40, AMD_UDMA_100 },
 	{ 0 }
 };
diff -puN include/linux/pci_ids.h~pata-add-the-mcp73-77-support-to-pata-driver include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~pata-add-the-mcp73-77-support-to-pata-driver
+++ a/include/linux/pci_ids.h
@@ -1234,6 +1234,8 @@
 #define PCI_DEVICE_ID_NVIDIA_NVENET_26              0x054E
 #define PCI_DEVICE_ID_NVIDIA_NVENET_27              0x054F
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP67_IDE       0x0560
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_IDE       0x056C
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE       0x0759
 
 #define PCI_VENDOR_ID_IMS		0x10e0
 #define PCI_DEVICE_ID_IMS_TT128		0x9128
_

Patches currently in -mm which might be from peerchen@gmail.com are

origin.patch
git-alsa.patch
