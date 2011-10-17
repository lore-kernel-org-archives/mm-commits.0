From: akpm@google.com
Subject: + powerpc-gup_hugepte-support-thp-based-tail-recounting.patch added to -mm tree
Date: Mon, 17 Oct 2011 12:12:11 -0700
Message-ID: <201110171912.p9HJCCnR025239@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:26173 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab1JQTM2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2011 15:12:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, david@gibson.dropbear.id.au, hughd@google.com, jweiner@redhat.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, riel@redhat.com


The patch titled
     Subject: powerpc: gup_hugepte() support THP based tail recounting
has been added to the -mm tree.  Its filename is
     powerpc-gup_hugepte-support-thp-based-tail-recounting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: powerpc: gup_hugepte() support THP based tail recounting

Up to this point the code assumed old refcounting for hugepages (pre-thp).
This updates the code directly to the thp mapcount tail page refcounting.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 arch/powerpc/mm/hugetlbpage.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff -puN arch/powerpc/mm/hugetlbpage.c~powerpc-gup_hugepte-support-thp-based-tail-recounting arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~powerpc-gup_hugepte-support-thp-based-tail-recounting
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -609,12 +609,23 @@ follow_huge_pmd(struct mm_struct *mm, un
 	return NULL;
 }
 
+static inline void get_huge_page_tail(struct page *page)
+{
+	/*
+	 * __split_huge_page_refcount() cannot run
+	 * from under us.
+	 */
+	VM_BUG_ON(page_mapcount(page) < 0);
+	VM_BUG_ON(atomic_read(&page->_count) != 0);
+	atomic_inc(&page->_mapcount);
+}
+
 static noinline int gup_hugepte(pte_t *ptep, unsigned long sz, unsigned long addr,
 		       unsigned long end, int write, struct page **pages, int *nr)
 {
 	unsigned long mask;
 	unsigned long pte_end;
-	struct page *head, *page;
+	struct page *head, *page, *tail;
 	pte_t pte;
 	int refs;
 
@@ -637,6 +648,7 @@ static noinline int gup_hugepte(pte_t *p
 	head = pte_page(pte);
 
 	page = head + ((addr & (sz-1)) >> PAGE_SHIFT);
+	tail = page;
 	do {
 		VM_BUG_ON(compound_head(page) != head);
 		pages[*nr] = page;
@@ -655,6 +667,16 @@ static noinline int gup_hugepte(pte_t *p
 		*nr -= refs;
 		while (refs--)
 			put_page(head);
+	} else {
+		/*
+		 * Any tail page need their mapcount reference taken
+		 * before we return.
+		 */
+		while (refs--) {
+			if (PageTail(tail))
+				get_huge_page_tail(tail);
+			tail++;
+		}
 	}
 
 	return 1;
_
Subject: Subject: powerpc: gup_hugepte() support THP based tail recounting

Patches currently in -mm which might be from aarcange@redhat.com are

mm-compaction-trivial-clean-up-in-acct_isolated.patch
mm-change-isolate-mode-from-define-to-bitwise-type.patch
mm-compaction-make-isolate_lru_page-filter-aware.patch
mm-compaction-make-isolate_lru_page-filter-aware-fix.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware-fix.patch
mm-migration-clean-up-unmap_and_move.patch
mremap-check-for-overflow-using-deltas.patch
mremap-avoid-sending-one-ipi-per-page.patch
thp-mremap-support-and-tlb-optimization.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix-fix.patch
thp-tail-page-refcounting-fix-5.patch
powerpc-remove-superfluous-pagetail-checks-on-the-pte-gup_fast.patch
powerpc-get_hugepte-dont-put_page-the-wrong-page.patch
powerpc-gup_hugepte-avoid-to-free-the-head-page-too-many-times.patch
powerpc-gup_hugepte-support-thp-based-tail-recounting.patch
mm-mempolicyc-quiet-sparse-noise.patch
mm-huge_memoryc-quiet-sparse-noise.patch
vmscan-limit-direct-reclaim-for-higher-order-allocations.patch
vmscan-limit-direct-reclaim-for-higher-order-allocations-fix.patch
vmscan-abort-reclaim-compaction-if-compaction-can-proceed.patch
mm-huge_memory-fix-copying-user-highpage.patch
mm-huge_memory-fix-typo-when-updating-mmu-cache.patch

