From: akpm@linux-foundation.org
Subject: - sparc64-remove-unused-calc_npages-in-iommu_commonh.patch removed from -mm tree
Date: Mon, 31 Mar 2008 13:19:09 -0700
Message-ID: <200803312019.m2VKJ9ul024183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754168AbYCaU2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 16:28:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     sparc64: remove unused calc_npages() in iommu_common.h
has been removed from the -mm tree.  Its filename was
     sparc64-remove-unused-calc_npages-in-iommu_commonh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sparc64: remove unused calc_npages() in iommu_common.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/kernel/iommu_common.h |   13 -------------
 1 file changed, 13 deletions(-)

diff -puN arch/sparc64/kernel/iommu_common.h~sparc64-remove-unused-calc_npages-in-iommu_commonh arch/sparc64/kernel/iommu_common.h
--- a/arch/sparc64/kernel/iommu_common.h~sparc64-remove-unused-calc_npages-in-iommu_commonh
+++ a/arch/sparc64/kernel/iommu_common.h
@@ -46,19 +46,6 @@ static inline unsigned long iommu_num_pa
 	return npages;
 }
 
-static inline unsigned long calc_npages(struct scatterlist *sglist, int nelems)
-{
-	unsigned long i, npages = 0;
-	struct scatterlist *sg;
-
-	for_each_sg(sglist, sg, nelems, i) {
-		unsigned long paddr = SG_ENT_PHYS_ADDRESS(sg);
-		npages += iommu_num_pages(paddr, sg->length);
-	}
-
-	return npages;
-}
