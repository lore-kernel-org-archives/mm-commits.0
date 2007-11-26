From: akpm@linux-foundation.org
Subject: + alpha-kill-deprecated-virt_to_bus.patch added to -mm tree
Date: Mon, 26 Nov 2007 14:49:02 -0800
Message-ID: <200711262249.lAQMn2p2027112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45477 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755582AbXKZWtz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 17:49:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tomof@acm.org, fujita.tomonori@lab.ntt.co.jp, ink@jurassic.park.msu.ru, jens.axboe@oracle.com, rth@twiddle.net


The patch titled
     alpha: kill deprecated virt_to_bus
has been added to the -mm tree.  Its filename is
     alpha-kill-deprecated-virt_to_bus.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: alpha: kill deprecated virt_to_bus
From: FUJITA Tomonori <tomof@acm.org>

pci-noop.c doesn't use DMA mappings.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/pci-noop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/alpha/kernel/pci-noop.c~alpha-kill-deprecated-virt_to_bus arch/alpha/kernel/pci-noop.c
--- a/arch/alpha/kernel/pci-noop.c~alpha-kill-deprecated-virt_to_bus
+++ a/arch/alpha/kernel/pci-noop.c
@@ -164,7 +164,7 @@ dma_alloc_coherent(struct device *dev, s
 	ret = (void *)__get_free_pages(gfp, get_order(size));
 	if (ret) {
 		memset(ret, 0, size);
-		*dma_handle = virt_to_bus(ret);
+		*dma_handle = virt_to_phys(ret);
 	}
 	return ret;
 }
@@ -182,7 +182,7 @@ dma_map_sg(struct device *dev, struct sc
 
 		BUG_ON(!sg[i].page);
 		va = page_address(sg[i].page) + sg[i].offset;
-		sg_dma_address(sg + i) = (dma_addr_t)virt_to_bus(va);
+		sg_dma_address(sg + i) = (dma_addr_t)virt_to_phys(va);
 		sg_dma_len(sg + i) = sg[i].length;
 	}
 
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
alpha-kill-deprecated-virt_to_bus.patch
