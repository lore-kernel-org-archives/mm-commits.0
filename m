From: akpm@linux-foundation.org
Subject: - iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:28:02 -0800
Message-ID: <200802052227.m15MRhoB011824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56236 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761512AbYBEWpW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:45:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomof@acm.org, James.Bottomley@steeleye.com, airlied@linux.ie, ak@suse.de, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, jens.axboe@oracle.com, mingo@elte.hu, tglx@linutronix.de, mm


The patch titled
     iommu sg merging: x86: make pci-gart iommu respect the segment size limits
has been removed from the -mm tree.  Its filename was
     iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iommu sg merging: x86: make pci-gart iommu respect the segment size limits
From: FUJITA Tomonori <tomof@acm.org>

This patch makes pci-gart iommu respect segment size limits when
merging sg lists.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
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
@@ -416,6 +416,8 @@ gart_map_sg(struct device *dev, struct s
 	struct scatterlist *s, *ps, *start_sg, *sgmap;
 	int need = 0, nextneed, i, out, start;
 	unsigned long pages = 0;
+	unsigned int seg_size;
+	unsigned int max_seg_size;
 
 	if (nents == 0)
 		return 0;
@@ -426,6 +428,8 @@ gart_map_sg(struct device *dev, struct s
 	out = 0;
 	start = 0;
 	start_sg = sgmap = sg;
+	seg_size = 0;
+	max_seg_size = dma_get_max_seg_size(dev);
 	ps = NULL; /* shut up gcc */
 	for_each_sg(sg, s, nents, i) {
 		dma_addr_t addr = sg_phys(s);
@@ -443,11 +447,13 @@ gart_map_sg(struct device *dev, struct s
 			 * offset.
 			 */
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
@@ -455,6 +461,7 @@ gart_map_sg(struct device *dev, struct s
 			}
 		}
 
+		seg_size += s->length;
 		need = nextneed;
 		pages += to_pages(s->offset, s->length);
 		ps = s;
_

Patches currently in -mm which might be from tomof@acm.org are

origin.patch
