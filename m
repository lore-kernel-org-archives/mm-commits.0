From: akpm@google.com
Subject: + sparc-gup_pte_range-support-thp-based-tail-recounting.patch added to -mm tree
Date: Mon, 17 Oct 2011 12:15:07 -0700
Message-ID: <201110171915.p9HJF8oo031045@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:57665 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab1JQTPc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2011 15:15:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, a.p.zijlstra@chello.nl, benh@kernel.crashing.org, davem@davemloft.net, david@gibson.dropbear.id.au, heiko.carstens@de.ibm.com, hughd@google.com, jweiner@redhat.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, riel@redhat.com, schwidefsky@de.ibm.com


The patch titled
     Subject: sparc: gup_pte_range() support THP based tail recounting
has been added to the -mm tree.  Its filename is
     sparc-gup_pte_range-support-thp-based-tail-recounting.patch

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
Subject: sparc: gup_pte_range() support THP based tail recounting

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
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 arch/sparc/mm/gup.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN arch/sparc/mm/gup.c~sparc-gup_pte_range-support-thp-based-tail-recounting arch/sparc/mm/gup.c
--- a/arch/sparc/mm/gup.c~sparc-gup_pte_range-support-thp-based-tail-recounting
+++ a/arch/sparc/mm/gup.c
@@ -12,6 +12,17 @@
 #include <linux/rwsem.h>
 #include <asm/pgtable.h>
 
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
 /*
  * The performance critical leaf functions are made noinline otherwise gcc
  * inlines everything into a single function which results in too much
@@ -56,6 +67,8 @@ static noinline int gup_pte_range(pmd_t 
 			put_page(head);
 			return 0;
 		}
+		if (head != page)
+			get_huge_page_tail(page);
 
 		pages[*nr] = page;
 		(*nr)++;
_
Subject: Subject: sparc: gup_pte_range() support THP based tail recounting

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
s390-gup_huge_pmd-support-thp-tail-recounting.patch
sparc-gup_pte_range-support-thp-based-tail-recounting.patch
thp-share-get_huge_page_tail.patch
mm-mempolicyc-quiet-sparse-noise.patch
mm-huge_memoryc-quiet-sparse-noise.patch
vmscan-limit-direct-reclaim-for-higher-order-allocations.patch
vmscan-limit-direct-reclaim-for-higher-order-allocations-fix.patch
vmscan-abort-reclaim-compaction-if-compaction-can-proceed.patch
mm-huge_memory-fix-copying-user-highpage.patch
mm-huge_memory-fix-typo-when-updating-mmu-cache.patch

