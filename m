From: akpm@linux-foundation.org
Subject: - iommu-sg-add-iommu-helper-functions-for-the-free-area-management-update.patch removed from -mm tree
Date: Mon, 04 Feb 2008 22:13:19 -0800
Message-ID: <200802050613.m156D0wv005868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38625 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751084AbYBEGNk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 01:13:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@steeleye.com, jeff@garzik.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     iommu-sg-add-iommu-helper-functions-for-the-free-area-management update
has been removed from the -mm tree.  Its filename was
     iommu-sg-add-iommu-helper-functions-for-the-free-area-management-update.patch

This patch was dropped because it was folded into iommu-sg-add-iommu-helper-functions-for-the-free-area-management.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iommu-sg-add-iommu-helper-functions-for-the-free-area-management update
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

An undocumented alteration :(

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/iommu-helper.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN lib/iommu-helper.c~iommu-sg-add-iommu-helper-functions-for-the-free-area-management-update lib/iommu-helper.c
--- a/lib/iommu-helper.c~iommu-sg-add-iommu-helper-functions-for-the-free-area-management-update
+++ a/lib/iommu-helper.c
@@ -8,15 +8,20 @@
 static unsigned long find_next_zero_area(unsigned long *map,
 					 unsigned long size,
 					 unsigned long start,
-					 unsigned int nr)
+					 unsigned int nr,
+					 unsigned long align_mask)
 {
 	unsigned long index, end, i;
 again:
 	index = find_next_zero_bit(map, size, start);
+
+	/* Align allocation */
+	index = (index + align_mask) & ~align_mask;
+
 	end = index + nr;
-	if (end > size)
+	if (end >= size)
 		return -1;
-	for (i = index + 1; i < end; i++) {
+	for (i = index; i < end; i++) {
 		if (test_bit(i, map)) {
 			start = i+1;
 			goto again;
@@ -50,9 +55,8 @@ unsigned long iommu_area_alloc(unsigned 
 {
 	unsigned long index;
 again:
-	index = find_next_zero_area(map, size, start, nr);
+	index = find_next_zero_area(map, size, start, nr, align_mask);
 	if (index != -1) {
-		index = (index + align_mask) & ~align_mask;
 		if (is_span_boundary(index, nr, shift, boundary_size)) {
 			/* we could do more effectively */
 			start = index + 1;
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
iommu-sg-merging-add-device_dma_parameters-structure.patch
iommu-sg-merging-pci-add-device_dma_parameters-support.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-ppc-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-ia64-make-sba_iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-alpha-make-pci_iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-sparc64-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-parisc-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-call-blk_queue_segment_boundary-in-__scsi_alloc_queue.patch
iommu-sg-merging-sata_inic162x-use-pci_set_dma_max_seg_size.patch
iommu-sg-merging-aacraid-use-pci_set_dma_max_seg_size.patch
iommu-sg-add-iommu-helper-functions-for-the-free-area-management.patch
iommu-sg-add-iommu-helper-functions-for-the-free-area-management-update.patch
iommu-sg-powerpc-convert-iommu-to-use-the-iommu-helper.patch
iommu-sg-powerpc-remove-dma-4gb-boundary-protection.patch
iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper.patch
iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper.patch
iommu-sg-kill-__clear_bit_string-and-find_next_zero_string.patch
add-accessors-for-segment_boundary_mask-in.patch
pci-add-dma-segment-boundary-support.patch
swiotlb-respect-the-segment-boundary-limits.patch
call-dma_set_seg_boundary-in-__scsi_alloc_queue.patch
alpha-kill-deprecated-virt_to_bus.patch
