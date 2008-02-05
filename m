From: akpm@linux-foundation.org
Subject: - iommu-sg-merging-alpha-make-pci_iommu-respect-the-segment-size-limits.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:28:11 -0800
Message-ID: <200802052227.m15MRqsC011835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54589 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762152AbYBEWo3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:44:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomof@acm.org, James.Bottomley@steeleye.com, fujita.tomonori@lab.ntt.co.jp, ink@jurassic.park.msu.ru, jeff@garzik.org, jens.axboe@oracle.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     iommu sg merging: alpha: make pci_iommu respect the segment size limits
has been removed from the -mm tree.  Its filename was
     iommu-sg-merging-alpha-make-pci_iommu-respect-the-segment-size-limits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iommu sg merging: alpha: make pci_iommu respect the segment size limits
From: FUJITA Tomonori <tomof@acm.org>

This patch makes pci_iommu respect segment size limits when merging sg
lists.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/pci_iommu.c |   24 ++++++++++++++++++------
 include/asm-alpha/pci.h       |    1 +
 2 files changed, 19 insertions(+), 6 deletions(-)

diff -puN arch/alpha/kernel/pci_iommu.c~iommu-sg-merging-alpha-make-pci_iommu-respect-the-segment-size-limits arch/alpha/kernel/pci_iommu.c
--- a/arch/alpha/kernel/pci_iommu.c~iommu-sg-merging-alpha-make-pci_iommu-respect-the-segment-size-limits
+++ a/arch/alpha/kernel/pci_iommu.c
@@ -9,6 +9,7 @@
 #include <linux/bootmem.h>
 #include <linux/scatterlist.h>
 #include <linux/log2.h>
+#include <linux/dma-mapping.h>
 
 #include <asm/io.h>
 #include <asm/hwrpb.h>
@@ -470,22 +471,29 @@ EXPORT_SYMBOL(pci_free_consistent);
 #define SG_ENT_PHYS_ADDRESS(SG) __pa(SG_ENT_VIRT_ADDRESS(SG))
 
 static void
-sg_classify(struct scatterlist *sg, struct scatterlist *end, int virt_ok)
+sg_classify(struct device *dev, struct scatterlist *sg, struct scatterlist *end,
+	    int virt_ok)
 {
 	unsigned long next_paddr;
 	struct scatterlist *leader;
 	long leader_flag, leader_length;
+	unsigned int max_seg_size;
 
 	leader = sg;
 	leader_flag = 0;
 	leader_length = leader->length;
 	next_paddr = SG_ENT_PHYS_ADDRESS(leader) + leader_length;
 
+	/* we will not marge sg without device. */
+	max_seg_size = dev ? dma_get_max_seg_size(dev) : 0;
 	for (++sg; sg < end; ++sg) {
 		unsigned long addr, len;
 		addr = SG_ENT_PHYS_ADDRESS(sg);
 		len = sg->length;
 
+		if (leader_length + len > max_seg_size)
+			goto new_segment;
+
 		if (next_paddr == addr) {
 			sg->dma_address = -1;
 			leader_length += len;
@@ -494,6 +502,7 @@ sg_classify(struct scatterlist *sg, stru
 			leader_flag = 1;
 			leader_length += len;
 		} else {
+new_segment:
 			leader->dma_address = leader_flag;
 			leader->dma_length = leader_length;
 			leader = sg;
@@ -512,7 +521,7 @@ sg_classify(struct scatterlist *sg, stru
    in the blanks.  */
 
 static int
-sg_fill(struct scatterlist *leader, struct scatterlist *end,
+sg_fill(struct device *dev, struct scatterlist *leader, struct scatterlist *end,
 	struct scatterlist *out, struct pci_iommu_arena *arena,
 	dma_addr_t max_dma, int dac_allowed)
 {
@@ -562,8 +571,8 @@ sg_fill(struct scatterlist *leader, stru
 
 		/* Otherwise, break up the remaining virtually contiguous
 		   hunks into individual direct maps and retry.  */
-		sg_classify(leader, end, 0);
-		return sg_fill(leader, end, out, arena, max_dma, dac_allowed);
+		sg_classify(dev, leader, end, 0);
+		return sg_fill(dev, leader, end, out, arena, max_dma, dac_allowed);
 	}
 
 	out->dma_address = arena->dma_base + dma_ofs*PAGE_SIZE + paddr;
@@ -619,12 +628,15 @@ pci_map_sg(struct pci_dev *pdev, struct 
 	struct pci_iommu_arena *arena;
 	dma_addr_t max_dma;
 	int dac_allowed;
+	struct device *dev;
 
 	if (direction == PCI_DMA_NONE)
 		BUG();
 
 	dac_allowed = pdev ? pci_dac_dma_supported(pdev, pdev->dma_mask) : 0;
 
+	dev = pdev ? &pdev->dev : NULL;
+
 	/* Fast path single entry scatterlists.  */
 	if (nents == 1) {
 		sg->dma_length = sg->length;
@@ -638,7 +650,7 @@ pci_map_sg(struct pci_dev *pdev, struct 
 	end = sg + nents;
 
 	/* First, prepare information about the entries.  */
-	sg_classify(sg, end, alpha_mv.mv_pci_tbi != 0);
+	sg_classify(dev, sg, end, alpha_mv.mv_pci_tbi != 0);
 
 	/* Second, figure out where we're going to map things.  */
 	if (alpha_mv.mv_pci_tbi) {
@@ -658,7 +670,7 @@ pci_map_sg(struct pci_dev *pdev, struct 
 	for (out = sg; sg < end; ++sg) {
 		if ((int) sg->dma_address < 0)
 			continue;
-		if (sg_fill(sg, end, out, arena, max_dma, dac_allowed) < 0)
+		if (sg_fill(dev, sg, end, out, arena, max_dma, dac_allowed) < 0)
 			goto error;
 		out++;
 	}
diff -puN include/asm-alpha/pci.h~iommu-sg-merging-alpha-make-pci_iommu-respect-the-segment-size-limits include/asm-alpha/pci.h
--- a/include/asm-alpha/pci.h~iommu-sg-merging-alpha-make-pci_iommu-respect-the-segment-size-limits
+++ a/include/asm-alpha/pci.h
@@ -4,6 +4,7 @@
 #ifdef __KERNEL__
 
 #include <linux/spinlock.h>
+#include <linux/dma-mapping.h>
 #include <asm/scatterlist.h>
 #include <asm/machvec.h>
 
_

Patches currently in -mm which might be from tomof@acm.org are

origin.patch
