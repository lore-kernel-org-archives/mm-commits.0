From: akpm@linux-foundation.org
Subject: + iommu-sg-merging-ia64-make-sba_iommu-respect-the-segment-size-limits.patch added to -mm tree
Date: Thu, 15 Nov 2007 14:05:25 -0800
Message-ID: <200711152205.lAFM5PkR018094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37984 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754841AbXKOWcq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 17:32:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomof@acm.org, James.Bottomley@steeleye.com, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, jens.axboe@oracle.com, tony.luck@intel.com


The patch titled
     iommu sg merging: IA64: make sba_iommu respect the segment size limits
has been added to the -mm tree.  Its filename is
     iommu-sg-merging-ia64-make-sba_iommu-respect-the-segment-size-limits.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iommu sg merging: IA64: make sba_iommu respect the segment size limits
From: FUJITA Tomonori <tomof@acm.org>

This patch makes sba iommu respect segment size limits when merging sg
lists.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/hp/common/sba_iommu.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN arch/ia64/hp/common/sba_iommu.c~iommu-sg-merging-ia64-make-sba_iommu-respect-the-segment-size-limits arch/ia64/hp/common/sba_iommu.c
--- a/arch/ia64/hp/common/sba_iommu.c~iommu-sg-merging-ia64-make-sba_iommu-respect-the-segment-size-limits
+++ a/arch/ia64/hp/common/sba_iommu.c
@@ -1265,7 +1265,7 @@ sba_fill_pdir(
  * the sglist do both.
  */
 static SBA_INLINE int
-sba_coalesce_chunks( struct ioc *ioc,
+sba_coalesce_chunks(struct ioc *ioc, struct device *dev,
 	struct scatterlist *startsg,
 	int nents)
 {
@@ -1275,6 +1275,7 @@ sba_coalesce_chunks( struct ioc *ioc,
 	struct scatterlist *dma_sg;        /* next DMA stream head */
 	unsigned long dma_offset, dma_len; /* start/len of DMA stream */
 	int n_mappings = 0;
+	unsigned int max_seg_size = dma_get_max_seg_size(dev);
 
 	while (nents > 0) {
 		unsigned long vaddr = (unsigned long) sba_sg_address(startsg);
@@ -1314,6 +1315,9 @@ sba_coalesce_chunks( struct ioc *ioc,
 			    > DMA_CHUNK_SIZE)
 				break;
 
+			if (dma_len + startsg->length > max_seg_size)
+				break;
+
 			/*
 			** Then look for virtually contiguous blocks.
 			**
@@ -1441,7 +1445,7 @@ int sba_map_sg(struct device *dev, struc
 	** w/o this association, we wouldn't have coherent DMA!
 	** Access to the virtual address is what forces a two pass algorithm.
 	*/
-	coalesced = sba_coalesce_chunks(ioc, sglist, nents);
+	coalesced = sba_coalesce_chunks(ioc, dev, sglist, nents);
 
 	/*
 	** Program the I/O Pdir
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
