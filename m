From: akpm@linux-foundation.org
Subject: - swiotlb-respect-the-segment-boundary-limits.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:28:52 -0800
Message-ID: <200802052228.m15MSXbm011895@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60085 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762841AbYBEWpD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:45:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomof@acm.org, James.Bottomley@steeleye.com, fujita.tomonori@lab.ntt.co.jp, greg@kroah.com, jeff@garzik.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     iommu sg merging: swiotlb: respect the segment boundary limits
has been removed from the -mm tree.  Its filename was
     swiotlb-respect-the-segment-boundary-limits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iommu sg merging: swiotlb: respect the segment boundary limits
From: FUJITA Tomonori <tomof@acm.org>

This patch makes swiotlb not allocate a memory area spanning LLD's segment
boundary.

is_span_boundary() judges whether a memory area spans LLD's segment boundary. 
If map_single finds such a area, map_single tries to find the next available
memory area.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Greg KH <greg@kroah.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/swiotlb.c |   41 +++++++++++++++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 6 deletions(-)

diff -puN lib/swiotlb.c~swiotlb-respect-the-segment-boundary-limits lib/swiotlb.c
--- a/lib/swiotlb.c~swiotlb-respect-the-segment-boundary-limits
+++ a/lib/swiotlb.c
@@ -282,6 +282,15 @@ address_needs_mapping(struct device *hwd
 	return (addr & ~mask) != 0;
 }
 
+static inline unsigned int is_span_boundary(unsigned int index,
+					    unsigned int nslots,
+					    unsigned long offset_slots,
+					    unsigned long max_slots)
+{
+	unsigned long offset = (offset_slots + index) & (max_slots - 1);
+	return offset + nslots > max_slots;
+}
+
 /*
  * Allocates bounce buffer and returns its kernel virtual address.
  */
@@ -292,6 +301,16 @@ map_single(struct device *hwdev, char *b
 	char *dma_addr;
 	unsigned int nslots, stride, index, wrap;
 	int i;
+	unsigned long start_dma_addr;
+	unsigned long mask;
+	unsigned long offset_slots;
+	unsigned long max_slots;
+
+	mask = dma_get_seg_boundary(hwdev);
+	start_dma_addr = virt_to_bus(io_tlb_start) & mask;
+
+	offset_slots = ALIGN(start_dma_addr, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
+	max_slots = ALIGN(mask + 1, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
 
 	/*
 	 * For mappings greater than a page, we limit the stride (and
@@ -311,10 +330,17 @@ map_single(struct device *hwdev, char *b
 	 */
 	spin_lock_irqsave(&io_tlb_lock, flags);
 	{
-		wrap = index = ALIGN(io_tlb_index, stride);
-
+		index = ALIGN(io_tlb_index, stride);
 		if (index >= io_tlb_nslabs)
-			wrap = index = 0;
+			index = 0;
+
+		while (is_span_boundary(index, nslots, offset_slots,
+					max_slots)) {
+			index += stride;
+			if (index >= io_tlb_nslabs)
+				index = 0;
+		}
+		wrap = index;
 
 		do {
 			/*
@@ -341,9 +367,12 @@ map_single(struct device *hwdev, char *b
 
 				goto found;
 			}
-			index += stride;
-			if (index >= io_tlb_nslabs)
-				index = 0;
+			do {
+				index += stride;
+				if (index >= io_tlb_nslabs)
+					index = 0;
+			} while (is_span_boundary(index, nslots, offset_slots,
+						  max_slots));
 		} while (index != wrap);
 
 		spin_unlock_irqrestore(&io_tlb_lock, flags);
_

Patches currently in -mm which might be from tomof@acm.org are

origin.patch
