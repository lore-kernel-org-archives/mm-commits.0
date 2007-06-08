From: akpm@linux-foundation.org
Subject: + pata-add-the-mcp73-77-support-to-pata-driver.patch added to -mm tree
Date: Thu, 07 Jun 2007 22:24:53 -0700
Message-ID: <200706080524.l585Or0b019831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36803 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757265AbXFHFZK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 01:25:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peerchen@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     PATA: add the MCP73/77 support to PATA driver
has been added to the -mm tree.  Its filename is
     pata-add-the-mcp73-77-support-to-pata-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PATA: add the MCP73/77 support to PATA driver
From: "Peer Chen" <peerchen@gmail.com>

Add the MCP73/MCP77 support to PATA driver.

Signed-off-by: Peer Chen <peerchen@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_amd.c       |    2 ++
 drivers/ide/pci/amd74xx.c    |    2 ++
 include/linux/pci_ids.h      |    2 ++
 include/linux/pci_ids.h.orig |    2 --
 4 files changed, 6 insertions(+), 2 deletions(-)

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
diff -puN /dev/null /dev/null
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
diff -puN /dev/null /dev/null
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
diff -puN include/linux/pci_ids.h.orig~pata-add-the-mcp73-77-support-to-pata-driver include/linux/pci_ids.h.orig
--- a/include/linux/pci_ids.h.orig~pata-add-the-mcp73-77-support-to-pata-driver
+++ a/include/linux/pci_ids.h.orig
@@ -1234,8 +1234,6 @@
 #define PCI_DEVICE_ID_NVIDIA_NVENET_26              0x054E
 #define PCI_DEVICE_ID_NVIDIA_NVENET_27              0x054F
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP67_IDE       0x0560
-#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_IDE       0x056C
-#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE       0x0759
 
 #define PCI_VENDOR_ID_IMS		0x10e0
 #define PCI_DEVICE_ID_IMS_TT128		0x9128
_

Patches currently in -mm which might be from peerchen@gmail.com are

ahci-add-mcp73-mcp77-support-to-ahci-driver.patch
pata-add-the-mcp73-77-support-to-pata-driver.patch
