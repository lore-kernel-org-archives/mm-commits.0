From: akpm@linux-foundation.org
Subject: [merged] dma-apitxt-add-dma_sync_single-sg-api-description.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:02:19 -0400
Message-ID: <201003150702.o2F72q79016889@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935896Ab0COHDC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:03:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@suse.de, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     DMA-API.txt: add dma_sync_single/sg API description
has been removed from the -mm tree.  Its filename was
     dma-apitxt-add-dma_sync_single-sg-api-description.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: DMA-API.txt: add dma_sync_single/sg API description
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This adds the description of the following eight function:

dma_sync_single_for_cpu
pci_dma_sync_single_for_cpu
dma_sync_single_for_device
pci_dma_sync_single_for_device
dma_sync_sg_for_cpu
pci_dma_sync_sg_for_cpu
dma_sync_sg_for_device
pci_dma_sync_sg_for_device

It was unclear that the API permits a partial sync (some network drivers
already do though).  I made it clear that the sync_single API can do a
partial sync but the sync_sg API can't.

We could do a partial sync with the sync_sg API too, however, it's
difficult for driver writers to correctly use the sync_sg API for a
partial sync since the scatterlists passed in to the mapping API can't be
modified.  It's unlikely that driver writers want to do a partial sync
with the sync_sg API (because the sync_sg API are usually used for block
drivers).  So I think that it's better to forbid a partial sync with the
sync_sg API.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: David Miller <davem@davemloft.net>
Acked-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API.txt |   42 ++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff -puN Documentation/DMA-API.txt~dma-apitxt-add-dma_sync_single-sg-api-description Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~dma-apitxt-add-dma_sync_single-sg-api-description
+++ a/Documentation/DMA-API.txt
@@ -364,6 +364,48 @@ API.
 Note: <nents> must be the number you passed in, *not* the number of
 physical entries returned.
 
+void
+dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
+			enum dma_data_direction direction)
+void
+pci_dma_sync_single_for_cpu(struct pci_dev *hwdev, dma_addr_t dma_handle,
+			    size_t size, int direction)
+void
+dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle, size_t size,
+			   enum dma_data_direction direction)
+void
+pci_dma_sync_single_for_device(struct pci_dev *hwdev, dma_addr_t dma_handle,
+			       size_t size, int direction)
+void
+dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
+		    enum dma_data_direction direction)
+void
+pci_dma_sync_sg_for_cpu(struct pci_dev *hwdev, struct scatterlist *sg,
+		        int nelems, int direction)
+void
+dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
+		       enum dma_data_direction direction)
+void
+pci_dma_sync_sg_for_device(struct pci_dev *hwdev, struct scatterlist *sg,
+		           int nelems, int direction)
+
+Synchronise a single contiguous or scatter/gather mapping for the cpu
+and device. With the sync_sg API, all the parameters must be the same
+as those passed into the single mapping API. With the sync_single API,
+you can use dma_handle and size parameters that aren't identical to
+those passed into the single mapping API to do a partial sync.
+
+Notes:  You must do this:
+
+- Before reading values that have been written by DMA from the device
+  (use the DMA_FROM_DEVICE direction)
+- After writing values that will be written to the device using DMA
+  (use the DMA_TO_DEVICE) direction
+- before *and* after handing memory to the device if the memory is
+  DMA_BIDIRECTIONAL
+
+See also dma_map_single().
+
 dma_addr_t
 dma_map_single_attrs(struct device *dev, void *cpu_addr, size_t size,
 		     enum dma_data_direction dir,
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch

