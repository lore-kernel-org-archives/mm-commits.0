From: akpm@linux-foundation.org
Subject: + iommu-sg-powerpc-remove-dma-4gb-boundary-protection.patch added to -mm tree
Date: Fri, 07 Dec 2007 14:12:25 -0800
Message-ID: <200712072212.lB7MCPIZ006202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42644 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754632AbXLGWOE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 17:14:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomof@acm.org, James.Bottomley@steeleye.com, benh@kernel.crashing.org, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, jens.axboe@oracle.com, paulus@samba.org


The patch titled
     iommu sg: powerpc: remove DMA 4GB boundary protection
has been added to the -mm tree.  Its filename is
     iommu-sg-powerpc-remove-dma-4gb-boundary-protection.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iommu sg: powerpc: remove DMA 4GB boundary protection
From: FUJITA Tomonori <tomof@acm.org>

Previously, during initialization of the IOMMU tables, the last entry
at each 4GB boundary is marked as used since there are many adapters
which cannot handle DMAing across any 4GB boundary.

The IOMMU doesn't allocate a memory area spanning LLD's segment
boundary anymore. The segment boundary of devices are set to 4GB by
default. So we can remove 4GB boundary protection now.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/iommu.c |   21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff -puN arch/powerpc/kernel/iommu.c~iommu-sg-powerpc-remove-dma-4gb-boundary-protection arch/powerpc/kernel/iommu.c
--- a/arch/powerpc/kernel/iommu.c~iommu-sg-powerpc-remove-dma-4gb-boundary-protection
+++ a/arch/powerpc/kernel/iommu.c
@@ -448,9 +448,6 @@ void iommu_unmap_sg(struct iommu_table *
 struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
 {
 	unsigned long sz;
-	unsigned long start_index, end_index;
-	unsigned long entries_per_4g;
-	unsigned long index;
 	static int welcomed = 0;
 	struct page *page;
 
@@ -472,6 +469,7 @@ struct iommu_table *iommu_init_table(str
 
 #ifdef CONFIG_CRASH_DUMP
 	if (ppc_md.tce_get) {
+		unsigned long index;
 		unsigned long tceval;
 		unsigned long tcecount = 0;
 
@@ -502,23 +500,6 @@ struct iommu_table *iommu_init_table(str
 	ppc_md.tce_free(tbl, tbl->it_offset, tbl->it_size);
 #endif
 
-	/*
-	 * DMA cannot cross 4 GB boundary.  Mark last entry of each 4
-	 * GB chunk as reserved.
-	 */
-	if (protect4gb) {
-		entries_per_4g = 0x100000000l >> IOMMU_PAGE_SHIFT;
-
-		/* Mark the last bit before a 4GB boundary as used */
-		start_index = tbl->it_offset | (entries_per_4g - 1);
-		start_index -= tbl->it_offset;
-
-		end_index = tbl->it_size;
-
-		for (index = start_index; index < end_index - 1; index += entries_per_4g)
-			__set_bit(index, tbl->it_map);
-	}
-
 	if (!welcomed) {
 		printk(KERN_INFO "IOMMU table initialized, virtual merging %s\n",
 		       novmerge ? "disabled" : "enabled");
_

Patches currently in -mm which might be from tomof@acm.org are

git-scsi-misc.patch
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
