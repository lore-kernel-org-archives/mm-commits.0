From: akpm@google.com
Subject: + powerpc-remove-superfluous-pagetail-checks-on-the-pte-gup_fast.patch added to -mm tree
Date: Mon, 17 Oct 2011 12:11:58 -0700
Message-ID: <201110171911.p9HJBwHO007852@wpaz13.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:26100 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab1JQTMW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2011 15:12:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, david@gibson.dropbear.id.au, hughd@google.com, jweiner@redhat.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, riel@redhat.com


The patch titled
     Subject: powerpc: remove superfluous PageTail checks on the pte gup_fast
has been added to the -mm tree.  Its filename is
     powerpc-remove-superfluous-pagetail-checks-on-the-pte-gup_fast.patch

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
Subject: powerpc: remove superfluous PageTail checks on the pte gup_fast

This part of gup_fast doesn't seem capable of handling hugetlbfs ptes,
those should be handled by gup_hugepd only, so these checks are
superfluous.

Plus if this wasn't a noop, it would have oopsed because, the insistence
of using the speculative refcounting would trigger a VM_BUG_ON if a tail
page was encountered in the page_cache_get_speculative().

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

 arch/powerpc/mm/gup.c |   13 -------------
 1 file changed, 13 deletions(-)

diff -puN arch/powerpc/mm/gup.c~powerpc-remove-superfluous-pagetail-checks-on-the-pte-gup_fast arch/powerpc/mm/gup.c
--- a/arch/powerpc/mm/gup.c~powerpc-remove-superfluous-pagetail-checks-on-the-pte-gup_fast
+++ a/arch/powerpc/mm/gup.c
@@ -16,17 +16,6 @@
 
 #ifdef __HAVE_ARCH_PTE_SPECIAL
 
-static inline void get_huge_page_tail(struct page *page)
-{
-	/*
-	 * __split_huge_page_refcount() cannot run
-	 * from under us.
-	 */
-	VM_BUG_ON(page_mapcount(page) < 0);
-	VM_BUG_ON(atomic_read(&page->_count) != 0);
-	atomic_inc(&page->_mapcount);
-}
-
 /*
  * The performance critical leaf functions are made noinline otherwise gcc
  * inlines everything into a single function which results in too much
@@ -58,8 +47,6 @@ static noinline int gup_pte_range(pmd_t 
 			put_page(page);
 			return 0;
 		}
-		if (PageTail(page))
-			get_huge_page_tail(page);
 		pages[*nr] = page;
 		(*nr)++;
 
_
Subject: Subject: powerpc: remove superfluous PageTail checks on the pte gup_fast

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

