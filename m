From: akpm@linux-foundation.org
Subject: - iommu-sg-merging-sparc64-make-iommu-respect-the-segment-size-limits.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:28:16 -0800
Message-ID: <200802052227.m15MRvJs011839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54034 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759690AbYBEWoR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:44:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tomof@acm.org, James.Bottomley@steeleye.com, davem@davemloft.net, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     iommu sg merging: sparc64: make iommu respect the segment size limits
has been removed from the -mm tree.  Its filename was
     iommu-sg-merging-sparc64-make-iommu-respect-the-segment-size-limits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iommu sg merging: sparc64: make iommu respect the segment size limits
From: FUJITA Tomonori <tomof@acm.org>

This patch makes iommu respect segment size limits when merging sg
lists.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/kernel/iommu.c        |    2 +-
 arch/sparc64/kernel/iommu_common.c |    8 ++++++--
 arch/sparc64/kernel/iommu_common.h |    3 ++-
 arch/sparc64/kernel/pci_sun4v.c    |    2 +-
 4 files changed, 10 insertions(+), 5 deletions(-)

diff -puN arch/sparc64/kernel/iommu.c~iommu-sg-merging-sparc64-make-iommu-respect-the-segment-size-limits arch/sparc64/kernel/iommu.c
--- a/arch/sparc64/kernel/iommu.c~iommu-sg-merging-sparc64-make-iommu-respect-the-segment-size-limits
+++ a/arch/sparc64/kernel/iommu.c
@@ -580,7 +580,7 @@ static int dma_4u_map_sg(struct device *
 
 	/* Step 1: Prepare scatter list. */
 
-	npages = prepare_sg(sglist, nelems);
+	npages = prepare_sg(dev, sglist, nelems);
 
 	/* Step 2: Allocate a cluster and context, if necessary. */
 
diff -puN arch/sparc64/kernel/iommu_common.c~iommu-sg-merging-sparc64-make-iommu-respect-the-segment-size-limits arch/sparc64/kernel/iommu_common.c
--- a/arch/sparc64/kernel/iommu_common.c~iommu-sg-merging-sparc64-make-iommu-respect-the-segment-size-limits
+++ a/arch/sparc64/kernel/iommu_common.c
@@ -4,6 +4,7 @@
  * Copyright (C) 1999 David S. Miller (davem@redhat.com)
  */
 
+#include <linux/dma-mapping.h>
 #include "iommu_common.h"
 
 /* You are _strongly_ advised to enable the following debugging code
@@ -201,21 +202,24 @@ void verify_sglist(struct scatterlist *s
 }
 #endif
 
-unsigned long prepare_sg(struct scatterlist *sg, int nents)
+unsigned long prepare_sg(struct device *dev, struct scatterlist *sg, int nents)
 {
 	struct scatterlist *dma_sg = sg;
 	unsigned long prev;
 	u32 dent_addr, dent_len;
+	unsigned int max_seg_size;
 
 	prev  = (unsigned long) sg_virt(sg);
 	prev += (unsigned long) (dent_len = sg->length);
 	dent_addr = (u32) ((unsigned long)(sg_virt(sg)) & (IO_PAGE_SIZE - 1UL));
+	max_seg_size = dma_get_max_seg_size(dev);
 	while (--nents) {
 		unsigned long addr;
 
 		sg = sg_next(sg);
 		addr = (unsigned long) sg_virt(sg);
-		if (! VCONTIG(prev, addr)) {
+		if (! VCONTIG(prev, addr) ||
+			dent_len + sg->length > max_seg_size) {
 			dma_sg->dma_address = dent_addr;
 			dma_sg->dma_length = dent_len;
 			dma_sg = sg_next(dma_sg);
diff -puN arch/sparc64/kernel/iommu_common.h~iommu-sg-merging-sparc64-make-iommu-respect-the-segment-size-limits arch/sparc64/kernel/iommu_common.h
--- a/arch/sparc64/kernel/iommu_common.h~iommu-sg-merging-sparc64-make-iommu-respect-the-segment-size-limits
+++ a/arch/sparc64/kernel/iommu_common.h
@@ -9,6 +9,7 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/scatterlist.h>
+#include <linux/device.h>
 
 #include <asm/iommu.h>
 #include <asm/scatterlist.h>
@@ -46,4 +47,4 @@ extern void verify_sglist(struct scatter
 #define VCONTIG(__X, __Y)	(((__X) == (__Y)) || \
 				 (((__X) | (__Y)) << (64UL - PAGE_SHIFT)) == 0UL)
 
-extern unsigned long prepare_sg(struct scatterlist *sg, int nents);
+extern unsigned long prepare_sg(struct device *dev, struct scatterlist *sg, int nents);
diff -puN arch/sparc64/kernel/pci_sun4v.c~iommu-sg-merging-sparc64-make-iommu-respect-the-segment-size-limits arch/sparc64/kernel/pci_sun4v.c
--- a/arch/sparc64/kernel/pci_sun4v.c~iommu-sg-merging-sparc64-make-iommu-respect-the-segment-size-limits
+++ a/arch/sparc64/kernel/pci_sun4v.c
@@ -490,7 +490,7 @@ static int dma_4v_map_sg(struct device *
 		goto bad;
 
 	/* Step 1: Prepare scatter list. */
-	npages = prepare_sg(sglist, nelems);
+	npages = prepare_sg(dev, sglist, nelems);
 
 	/* Step 2: Allocate a cluster and context, if necessary. */
 	spin_lock_irqsave(&iommu->lock, flags);
_

Patches currently in -mm which might be from tomof@acm.org are

origin.patch
