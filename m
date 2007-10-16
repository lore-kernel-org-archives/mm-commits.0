From: akpm@linux-foundation.org
Subject: - i-oat-new-device-ids.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:39:18 -0700
Message-ID: <200710162039.l9GKdI6D015535@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39284 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935871AbXJPVHf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:07:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shannon.nelson@intel.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     I/OAT: New device ids
has been removed from the -mm tree.  Its filename was
     i-oat-new-device-ids.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: I/OAT: New device ids
From: Shannon Nelson <shannon.nelson@intel.com>

Add device ids for new revs of the Intel I/OAT DMA engine

Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ioatdma.c   |    5 +++--
 include/linux/pci_ids.h |    2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/dma/ioatdma.c~i-oat-new-device-ids drivers/dma/ioatdma.c
--- a/drivers/dma/ioatdma.c~i-oat-new-device-ids
+++ a/drivers/dma/ioatdma.c
@@ -506,8 +506,9 @@ static enum dma_status ioat_dma_is_compl
 
 static struct pci_device_id ioat_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_UNISYS,
-		     PCI_DEVICE_ID_UNISYS_DMA_DIRECTOR) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_CNB)  },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_SCNB) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_UNISYS, PCI_DEVICE_ID_UNISYS_DMA_DIRECTOR) },
 	{ 0, }
 };
 
diff -puN include/linux/pci_ids.h~i-oat-new-device-ids include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~i-oat-new-device-ids
+++ a/include/linux/pci_ids.h
@@ -2326,6 +2326,8 @@
 #define PCI_DEVICE_ID_INTEL_MCH_PC	0x3599
 #define PCI_DEVICE_ID_INTEL_MCH_PC1	0x359a
 #define PCI_DEVICE_ID_INTEL_E7525_MCH	0x359e
+#define PCI_DEVICE_ID_INTEL_IOAT_CNB	0x360b
+#define PCI_DEVICE_ID_INTEL_IOAT_SCNB	0x65ff
 #define PCI_DEVICE_ID_INTEL_TOLAPAI_0	0x5031
 #define PCI_DEVICE_ID_INTEL_TOLAPAI_1	0x5032
 #define PCI_DEVICE_ID_INTEL_82371SB_0	0x7000
_

Patches currently in -mm which might be from shannon.nelson@intel.com are

origin.patch
remove-unsafe-from-module-struct.patch
