From: akpm@linux-foundation.org
Subject: + iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch added to -mm tree
Date: Thu, 15 Nov 2007 14:05:21 -0800
Message-ID: <200711152205.lAFM5L0V018088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59861 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762603AbXKOWHH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 17:07:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomof@acm.org, James.Bottomley@steeleye.com, airlied@linux.ie, ak@suse.de, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, jens.axboe@oracle.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     iommu sg merging: x86: make pci-gart iommu respect the segment size limits
has been added to the -mm tree.  Its filename is
     iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iommu sg merging: x86: make pci-gart iommu respect the segment size limits
From: FUJITA Tomonori <tomof@acm.org>

This patch makes pci-gart iommu respect segment size limits when
merging sg lists.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/pci-gart_64.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN arch/x86/kernel/pci-gart_64.c~iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits arch/x86/kernel/pci-gart_64.c
--- a/arch/x86/kernel/pci-gart_64.c~iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits
+++ a/arch/x86/kernel/pci-gart_64.c
@@ -383,6 +383,8 @@ static int gart_map_sg(struct device *de
 	int start;
 	unsigned long pages = 0;
 	int need = 0, nextneed;
+	unsigned int seg_size;
+	unsigned int max_seg_size;
 	struct scatterlist *s, *ps, *start_sg, *sgmap;
 
 	if (nents == 0) 
@@ -394,6 +396,8 @@ static int gart_map_sg(struct device *de
 	out = 0;
 	start = 0;
 	start_sg = sgmap = sg;
+	seg_size = 0;
+	max_seg_size = dma_get_max_seg_size(dev);
 	ps = NULL; /* shut up gcc */
 	for_each_sg(sg, s, nents, i) {
 		dma_addr_t addr = sg_phys(s);
@@ -407,11 +411,13 @@ static int gart_map_sg(struct device *de
 			/* Can only merge when the last chunk ends on a page 
 			   boundary and the new one doesn't have an offset. */
 			if (!iommu_merge || !nextneed || !need || s->offset ||
+			    (s->length + seg_size > max_seg_size) ||
 			    (ps->offset + ps->length) % PAGE_SIZE) {
 				if (dma_map_cont(start_sg, i - start, sgmap,
 						  pages, need) < 0)
 					goto error;
 				out++;
+				seg_size = 0;
 				sgmap = sg_next(sgmap);
 				pages = 0;
 				start = i;
@@ -419,6 +425,7 @@ static int gart_map_sg(struct device *de
 			}
 		}
 
+		seg_size += s->length;
 		need = nextneed;
 		pages += to_pages(s->offset, s->length);
 		ps = s;
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
