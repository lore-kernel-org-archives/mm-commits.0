From: akpm@google.com
Subject: + powerpc-get_hugepte-dont-put_page-the-wrong-page.patch added to -mm tree
Date: Mon, 17 Oct 2011 12:12:03 -0700
Message-ID: <201110171912.p9HJC4xX027871@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:56083 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab1JQTMg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2011 15:12:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, david@gibson.dropbear.id.au, hughd@google.com, jweiner@redhat.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, riel@redhat.com


The patch titled
     Subject: powerpc: get_hugepte() don't put_page() the wrong page
has been added to the -mm tree.  Its filename is
     powerpc-get_hugepte-dont-put_page-the-wrong-page.patch

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
Subject: powerpc: get_hugepte() don't put_page() the wrong page

"page" may have changed to point to the next hugepage after the loop
completed, The references have been taken on the head page, so the
put_page must happen there too.

This is a longstanding issue pre-thp inclusion.

It's totally unclear how these page_cache_add_speculative and pte_val(pte)
!= pte_val(*ptep) checks are necessary across all the powerpc gup_fast
code, when x86 doesn't need any of that: there's no way the page can be
freed with irq disabled so we're guaranteed the atomic_inc will happen on
a page with page_count > 0 (so not needing the speculative check).  The
pte check is also meaningless on x86: no need to rollback on x86 if the
pte changed, because the pte can still change a CPU tick after the check
succeeded and it won't be rolled back in that case.  The important thing
is we got a reference on a valid page that was mapped there a CPU tick
ago.  So not knowing the soft tlb refill code of ppc64 in great detail I'm
not removing the "speculative" page_count increase and the pte checks
across all the code, but unless there's a strong reason for it they should
be later cleaned up too.

If a pte can change from huge to non-huge (like it could happen with THP)
passing a pte_t *ptep to gup_hugepte() would also require to repeat the
is_hugepd in gup_hugepte(), but that shouldn't happen with hugetlbfs only
so I'm not altering that.

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

 arch/powerpc/mm/hugetlbpage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/mm/hugetlbpage.c~powerpc-get_hugepte-dont-put_page-the-wrong-page arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~powerpc-get_hugepte-dont-put_page-the-wrong-page
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -653,7 +653,7 @@ static noinline int gup_hugepte(pte_t *p
 	if (unlikely(pte_val(pte) != pte_val(*ptep))) {
 		/* Could be optimized better */
 		while (*nr) {
-			put_page(page);
+			put_page(head);
 			(*nr)--;
 		}
 	}
_
Subject: Subject: powerpc: get_hugepte() don't put_page() the wrong page

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

