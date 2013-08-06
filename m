From: akpm@linux-foundation.org
Subject: + mm-move-pgtable-related-functions-to-right-place.patch added to -mm tree
Date: Tue, 06 Aug 2013 15:13:40 -0700
Message-ID: <52017514.k+TRGhze/bAx8ujt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569Ab3HFWNl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Aug 2013 18:13:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, minchan@kernel.org, mgorman@suse.de, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com

Subject: + mm-move-pgtable-related-functions-to-right-place.patch added to -mm tree
To: iamjoonsoo.kim@lge.com,hannes@cmpxchg.org,mgorman@suse.de,minchan@kernel.org,riel@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 06 Aug 2013 15:13:40 -0700


The patch titled
     Subject: mm: move pgtable related functions to right place
has been added to the -mm tree.  Its filename is
     mm-move-pgtable-related-functions-to-right-place.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-pgtable-related-functions-to-right-place.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-pgtable-related-functions-to-right-place.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm: move pgtable related functions to right place

pgtable related functions are mostly in pgtable-generic.c.
So move remaining functions from memory.c to pgtable-generic.c.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c          |   24 ------------------------
 mm/pgtable-generic.c |   24 ++++++++++++++++++++++++
 2 files changed, 24 insertions(+), 24 deletions(-)

diff -puN mm/memory.c~mm-move-pgtable-related-functions-to-right-place mm/memory.c
--- a/mm/memory.c~mm-move-pgtable-related-functions-to-right-place
+++ a/mm/memory.c
@@ -374,30 +374,6 @@ void tlb_remove_table(struct mmu_gather
 #endif /* CONFIG_HAVE_RCU_TABLE_FREE */
 
 /*
- * If a p?d_bad entry is found while walking page tables, report
- * the error, before resetting entry to p?d_none.  Usually (but
- * very seldom) called out from the p?d_none_or_clear_bad macros.
- */
-
-void pgd_clear_bad(pgd_t *pgd)
-{
-	pgd_ERROR(*pgd);
-	pgd_clear(pgd);
-}
-
-void pud_clear_bad(pud_t *pud)
-{
-	pud_ERROR(*pud);
-	pud_clear(pud);
-}
-
-void pmd_clear_bad(pmd_t *pmd)
-{
-	pmd_ERROR(*pmd);
-	pmd_clear(pmd);
-}
-
-/*
  * Note: this doesn't free the actual pages themselves. That
  * has been handled earlier when unmapping all the memory regions.
  */
diff -puN mm/pgtable-generic.c~mm-move-pgtable-related-functions-to-right-place mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~mm-move-pgtable-related-functions-to-right-place
+++ a/mm/pgtable-generic.c
@@ -10,6 +10,30 @@
 #include <asm/tlb.h>
 #include <asm-generic/pgtable.h>
 
+/*
+ * If a p?d_bad entry is found while walking page tables, report
+ * the error, before resetting entry to p?d_none.  Usually (but
+ * very seldom) called out from the p?d_none_or_clear_bad macros.
+ */
+
+void pgd_clear_bad(pgd_t *pgd)
+{
+	pgd_ERROR(*pgd);
+	pgd_clear(pgd);
+}
+
+void pud_clear_bad(pud_t *pud)
+{
+	pud_ERROR(*pud);
+	pud_clear(pud);
+}
+
+void pmd_clear_bad(pmd_t *pmd)
+{
+	pmd_ERROR(*pmd);
+	pmd_clear(pmd);
+}
+
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 /*
  * Only sets the access flags (dirty, accessed), as well as write 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch
mm-hugetlb-trivial-commenting-fix.patch
mm-hugetlb-clean-up-alloc_huge_page.patch
mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free.patch
mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages.patch
mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch
mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch
mm-hugetlb-remove-decrement_hugepage_resv_vma.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
mm-page_alloc-add-unlikely-macro-to-help-compiler-optimization.patch
mm-move-pgtable-related-functions-to-right-place.patch
swap-clean-up-ifdef-in-page_mapping.patch

