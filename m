From: akpm@linux-foundation.org
Subject: + sparc64-remove-unused-calc_npages-in-iommu_commonh.patch added to -mm tree
Date: Thu, 13 Mar 2008 14:03:39 -0700
Message-ID: <200803132103.m2DL3dJh000311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757417AbYCMVEM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 17:04:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net


The patch titled
     sparc64: remove unused calc_npages() in iommu_common.h
has been added to the -mm tree.  Its filename is
     sparc64-remove-unused-calc_npages-in-iommu_commonh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
