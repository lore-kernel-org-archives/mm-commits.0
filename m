From: akpm@google.com
Subject: [folded] thp-tail-page-refcounting-fix-6.patch removed from -mm tree
Date: Mon, 17 Oct 2011 12:08:56 -0700
Message-ID: <201110171908.p9HJ8u4o022573@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:24462 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab1JQTJA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2011 15:09:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, minchan.kim@gmail.com, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-tail-page-refcounting-fix-6
has been removed from the -mm tree.  Its filename was
     thp-tail-page-refcounting-fix-6.patch

This patch was dropped because it was folded into thp-tail-page-refcounting-fix-5.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: thp-tail-page-refcounting-fix-6

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 mm/internal.h      |    5 +++++
 mm/swap.c          |   12 +++++++++---
 3 files changed, 15 insertions(+), 4 deletions(-)

diff -puN include/linux/mm.h~thp-tail-page-refcounting-fix-6 include/linux/mm.h
--- a/include/linux/mm.h~thp-tail-page-refcounting-fix-6
+++ a/include/linux/mm.h
@@ -377,7 +377,7 @@ static inline int page_count(struct page
 	return atomic_read(&compound_head(page)->_count);
 }
 
-extern int __get_page_tail(struct page *page);
+extern bool __get_page_tail(struct page *page);
 
 static inline void get_page(struct page *page)
 {
diff -puN mm/internal.h~thp-tail-page-refcounting-fix-6 mm/internal.h
--- a/mm/internal.h~thp-tail-page-refcounting-fix-6
+++ a/mm/internal.h
@@ -59,6 +59,11 @@ static inline void __get_page_tail_foll(
 	atomic_inc(&page->_mapcount);
 }
 
+/*
+ * This is meant to be called as the FOLL_GET operation of
+ * follow_page() and it must be called while holding the proper PT
+ * lock while the pte (or pmd_trans_huge) is still mapping the page.
+ */
 static inline void get_page_foll(struct page *page)
 {
 	if (unlikely(PageTail(page)))
diff -puN mm/swap.c~thp-tail-page-refcounting-fix-6 mm/swap.c
--- a/mm/swap.c~thp-tail-page-refcounting-fix-6
+++ a/mm/swap.c
@@ -79,6 +79,7 @@ static void put_compound_page(struct pag
 	if (unlikely(PageTail(page))) {
 		/* __split_huge_page_refcount can run under us */
 		struct page *page_head = compound_trans_head(page);
+
 		if (likely(page != page_head &&
 			   get_page_unless_zero(page_head))) {
 			unsigned long flags;
@@ -143,7 +144,11 @@ void put_page(struct page *page)
 }
 EXPORT_SYMBOL(put_page);
 
-int __get_page_tail(struct page *page)
+/*
+ * This function is exported but must not be called by anything other
+ * than get_page(). It implements the slow path of get_page().
+ */
+bool __get_page_tail(struct page *page)
 {
 	/*
 	 * This takes care of get_page() if run on a tail page
@@ -154,8 +159,9 @@ int __get_page_tail(struct page *page)
 	 * split_huge_page().
 	 */
 	unsigned long flags;
-	int got = 0;
+	bool got = false;
 	struct page *page_head = compound_trans_head(page);
+
 	if (likely(page != page_head && get_page_unless_zero(page_head))) {
 		/*
 		 * page_head wasn't a dangling pointer but it
@@ -167,7 +173,7 @@ int __get_page_tail(struct page *page)
 		/* here __split_huge_page_refcount won't run anymore */
 		if (likely(PageTail(page))) {
 			__get_page_tail_foll(page, false);
-			got = 1;
+			got = true;
 		}
 		compound_unlock_irqrestore(page_head, flags);
 		if (unlikely(!got))
_

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

