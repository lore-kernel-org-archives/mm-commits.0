From: akpm@linux-foundation.org
Subject: - fix-dac960-driver-on-machines-which-dont-support-64-bit-dma.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:25:38 -0700
Message-ID: <200709160925.l8G9PcVc009124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51660 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751822AbXIPJ0T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:26:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew@wil.cx, alex@nibbles.it, dac@conglom-o.org, jeff@garzik.org, polynomial-c@gmx.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Fix DAC960 driver on machines which don't support 64-bit DMA
has been removed from the -mm tree.  Its filename was
     fix-dac960-driver-on-machines-which-dont-support-64-bit-dma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix DAC960 driver on machines which don't support 64-bit DMA
From: Matthew Wilcox <matthew@wil.cx>

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=8942

Use PCI_DMA_* constants instead of own private definitions Fall back to
32-bit DMA mask if a 64-bit one fails

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
Acked-by: Jeff Garzik <jeff@garzik.org>
Tested-by: Lars <polynomial-c@gmx.de>
Cc: Alessandro Polverini <alex@nibbles.it>
Cc: <dac@conglom-o.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/DAC960.c |   17 ++++++++++-------
 drivers/block/DAC960.h |    7 -------
 2 files changed, 10 insertions(+), 14 deletions(-)

diff -puN drivers/block/DAC960.c~fix-dac960-driver-on-machines-which-dont-support-64-bit-dma drivers/block/DAC960.c
--- a/drivers/block/DAC960.c~fix-dac960-driver-on-machines-which-dont-support-64-bit-dma
+++ a/drivers/block/DAC960.c
@@ -17,8 +17,8 @@
 */
 
 
-#define DAC960_DriverVersion			"2.5.48"
-#define DAC960_DriverDate			"14 May 2006"
+#define DAC960_DriverVersion			"2.5.49"
+#define DAC960_DriverDate			"21 Aug 2007"
 
 
 #include <linux/module.h>
@@ -1165,9 +1165,9 @@ static bool DAC960_V1_EnableMemoryMailbo
   int i;
 
   
-  if (pci_set_dma_mask(Controller->PCIDevice, DAC690_V1_PciDmaMask))
+  if (pci_set_dma_mask(Controller->PCIDevice, DMA_32BIT_MASK))
 	return DAC960_Failure(Controller, "DMA mask out of range");
-  Controller->BounceBufferLimit = DAC690_V1_PciDmaMask;
+  Controller->BounceBufferLimit = DMA_32BIT_MASK;
 
   if ((hw_type == DAC960_PD_Controller) || (hw_type == DAC960_P_Controller)) {
     CommandMailboxesSize =  0;
@@ -1368,9 +1368,12 @@ static bool DAC960_V2_EnableMemoryMailbo
   dma_addr_t	CommandMailboxDMA;
   DAC960_V2_CommandStatus_T CommandStatus;
 
-  if (pci_set_dma_mask(Controller->PCIDevice, DAC690_V2_PciDmaMask))
-	return DAC960_Failure(Controller, "DMA mask out of range");
-  Controller->BounceBufferLimit = DAC690_V2_PciDmaMask;
+	if (!pci_set_dma_mask(Controller->PCIDevice, DMA_64BIT_MASK))
+		Controller->BounceBufferLimit = DMA_64BIT_MASK;
+	else if (!pci_set_dma_mask(Controller->PCIDevice, DMA_32BIT_MASK))
+		Controller->BounceBufferLimit = DMA_32BIT_MASK;
+	else
+		return DAC960_Failure(Controller, "DMA mask out of range");
 
   /* This is a temporary dma mapping, used only in the scope of this function */
   CommandMailbox = pci_alloc_consistent(PCI_Device,
diff -puN drivers/block/DAC960.h~fix-dac960-driver-on-machines-which-dont-support-64-bit-dma drivers/block/DAC960.h
--- a/drivers/block/DAC960.h~fix-dac960-driver-on-machines-which-dont-support-64-bit-dma
+++ a/drivers/block/DAC960.h
@@ -61,13 +61,6 @@
 #define DAC960_V2_MaxPhysicalDevices		272
 
 /*
-  Define the pci dma mask supported by DAC960 V1 and V2 Firmware Controlers
- */
-
-#define DAC690_V1_PciDmaMask	0xffffffff
-#define DAC690_V2_PciDmaMask	0xffffffffffffffffULL
-
-/*
   Define a 32/64 bit I/O Address data type.
 */
 
_

Patches currently in -mm which might be from matthew@wil.cx are

origin.patch
fix-dac960-driver-on-machines-which-dont-support-64-bit-dma-fix.patch
git-scsi-misc.patch
drivers-scsi-advansysc-ld-error-re-2623-rc3-mm1.patch
make-sure-nobodys-leaking-resources.patch
