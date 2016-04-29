From: akpm@linux-foundation.org
Subject: [merged] thp-keep-huge-zero-page-pinned-until-tlb-flush.patch
 removed from -mm tree
Date: Fri, 29 Apr 2016 15:05:17 -0700
Message-ID: <5723da9d.VCm1HN+m/zlWD11p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbcD2WFS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2016 18:05:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, mgorman@techsingularity.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: keep huge zero page pinned until tlb flush
has been removed from the -mm tree.  Its filename was
     thp-keep-huge-zero-page-pinned-until-tlb-flush.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: keep huge zero page pinned until tlb flush

Andrea has found[1] a race condition on MMU-gather based TLB flush vs
split_huge_page() or shrinker which frees huge zero under us (patch 1/2
and 2/2 respectively).

With new THP refcounting, we don't need patch 1/2: mmu_gather keeps the
page pinned until flush is complete and the pin prevents the page from
being split under us.

We still need patch 2/2.  This is simplified version of Andrea's patch. 
We don't need fancy encoding.

[1] http://lkml.kernel.org/r/1447938052-22165-1-git-send-email-aarcange@redhat.com

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    5 +++++
 mm/huge_memory.c        |    6 +++---
 mm/swap.c               |    5 +++++
 3 files changed, 13 insertions(+), 3 deletions(-)

diff -puN include/linux/huge_mm.h~thp-keep-huge-zero-page-pinned-until-tlb-flush include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-keep-huge-zero-page-pinned-until-tlb-flush
+++ a/include/linux/huge_mm.h
@@ -152,6 +152,7 @@ static inline bool is_huge_zero_pmd(pmd_
 }
 
 struct page *get_huge_zero_page(void);
+void put_huge_zero_page(void);
 
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 #define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
@@ -208,6 +209,10 @@ static inline bool is_huge_zero_page(str
 	return false;
 }
 
+static inline void put_huge_zero_page(void)
+{
+	BUILD_BUG();
+}
 
 static inline struct page *follow_devmap_pmd(struct vm_area_struct *vma,
 		unsigned long addr, pmd_t *pmd, int flags)
diff -puN mm/huge_memory.c~thp-keep-huge-zero-page-pinned-until-tlb-flush mm/huge_memory.c
--- a/mm/huge_memory.c~thp-keep-huge-zero-page-pinned-until-tlb-flush
+++ a/mm/huge_memory.c
@@ -232,7 +232,7 @@ retry:
 	return READ_ONCE(huge_zero_page);
 }
 
-static void put_huge_zero_page(void)
+void put_huge_zero_page(void)
 {
 	/*
 	 * Counter should never go to zero here. Only shrinker can put
@@ -1684,12 +1684,12 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 	if (vma_is_dax(vma)) {
 		spin_unlock(ptl);
 		if (is_huge_zero_pmd(orig_pmd))
-			put_huge_zero_page();
+			tlb_remove_page(tlb, pmd_page(orig_pmd));
 	} else if (is_huge_zero_pmd(orig_pmd)) {
 		pte_free(tlb->mm, pgtable_trans_huge_withdraw(tlb->mm, pmd));
 		atomic_long_dec(&tlb->mm->nr_ptes);
 		spin_unlock(ptl);
-		put_huge_zero_page();
+		tlb_remove_page(tlb, pmd_page(orig_pmd));
 	} else {
 		struct page *page = pmd_page(orig_pmd);
 		page_remove_rmap(page, true);
diff -puN mm/swap.c~thp-keep-huge-zero-page-pinned-until-tlb-flush mm/swap.c
--- a/mm/swap.c~thp-keep-huge-zero-page-pinned-until-tlb-flush
+++ a/mm/swap.c
@@ -728,6 +728,11 @@ void release_pages(struct page **pages,
 			zone = NULL;
 		}
 
+		if (is_huge_zero_page(page)) {
+			put_huge_zero_page();
+			continue;
+		}
+
 		page = compound_head(page);
 		if (!put_page_testzero(page))
 			continue;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

