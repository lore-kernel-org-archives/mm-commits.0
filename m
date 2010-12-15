From: akpm@linux-foundation.org
Subject: + thp-alter-compound-get_page-put_page.patch added to -mm tree
Date: Wed, 15 Dec 2010 15:56:13 -0800
Message-ID: <201012152356.oBFNuDMO013391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755840Ab0LOX5U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 18:57:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com


The patch titled
     thp: alter compound get_page/put_page
has been added to the -mm tree.  Its filename is
     thp-alter-compound-get_page-put_page.patch

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
Subject: thp: alter compound get_page/put_page
From: Andrea Arcangeli <aarcange@redhat.com>

Alter compound get_page/put_page to keep references on subpages too, in
order to allow __split_huge_page_refcount to split an hugepage even while
subpages have been pinned by one of the get_user_pages() variants.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/gup.c |   12 +++++
 arch/x86/mm/gup.c     |   12 +++++
 include/linux/mm.h    |   24 +++++++++-
 mm/swap.c             |   90 ++++++++++++++++++++++++++++++++++++----
 4 files changed, 129 insertions(+), 9 deletions(-)

diff -puN arch/powerpc/mm/gup.c~thp-alter-compound-get_page-put_page arch/powerpc/mm/gup.c
--- a/arch/powerpc/mm/gup.c~thp-alter-compound-get_page-put_page
+++ a/arch/powerpc/mm/gup.c
@@ -16,6 +16,16 @@
 
 #ifdef __HAVE_ARCH_PTE_SPECIAL
 
+static inline void get_huge_page_tail(struct page *page)
+{
+	/*
+	 * __split_huge_page_refcount() cannot run
+	 * from under us.
+	 */
+	VM_BUG_ON(atomic_read(&page->_count) < 0);
+	atomic_inc(&page->_count);
+}
+
 /*
  * The performance critical leaf functions are made noinline otherwise gcc
  * inlines everything into a single function which results in too much
@@ -47,6 +57,8 @@ static noinline int gup_pte_range(pmd_t 
 			put_page(page);
 			return 0;
 		}
+		if (PageTail(page))
+			get_huge_page_tail(page);
 		pages[*nr] = page;
 		(*nr)++;
 
diff -puN arch/x86/mm/gup.c~thp-alter-compound-get_page-put_page arch/x86/mm/gup.c
--- a/arch/x86/mm/gup.c~thp-alter-compound-get_page-put_page
+++ a/arch/x86/mm/gup.c
@@ -105,6 +105,16 @@ static inline void get_head_page_multipl
 	atomic_add(nr, &page->_count);
 }
 
+static inline void get_huge_page_tail(struct page *page)
+{
+	/*
+	 * __split_huge_page_refcount() cannot run
+	 * from under us.
+	 */
+	VM_BUG_ON(atomic_read(&page->_count) < 0);
+	atomic_inc(&page->_count);
+}
+
 static noinline int gup_huge_pmd(pmd_t pmd, unsigned long addr,
 		unsigned long end, int write, struct page **pages, int *nr)
 {
@@ -128,6 +138,8 @@ static noinline int gup_huge_pmd(pmd_t p
 	do {
 		VM_BUG_ON(compound_head(page) != head);
 		pages[*nr] = page;
+		if (PageTail(page))
+			get_huge_page_tail(page);
 		(*nr)++;
 		page++;
 		refs++;
diff -puN include/linux/mm.h~thp-alter-compound-get_page-put_page include/linux/mm.h
--- a/include/linux/mm.h~thp-alter-compound-get_page-put_page
+++ a/include/linux/mm.h
@@ -354,9 +354,29 @@ static inline int page_count(struct page
 
 static inline void get_page(struct page *page)
 {
-	page = compound_head(page);
-	VM_BUG_ON(atomic_read(&page->_count) == 0);
+	/*
+	 * Getting a normal page or the head of a compound page
+	 * requires to already have an elevated page->_count. Only if
+	 * we're getting a tail page, the elevated page->_count is
+	 * required only in the head page, so for tail pages the
+	 * bugcheck only verifies that the page->_count isn't
+	 * negative.
+	 */
+	VM_BUG_ON(atomic_read(&page->_count) < !PageTail(page));
 	atomic_inc(&page->_count);
+	/*
+	 * Getting a tail page will elevate both the head and tail
+	 * page->_count(s).
+	 */
+	if (unlikely(PageTail(page))) {
+		/*
+		 * This is safe only because
+		 * __split_huge_page_refcount can't run under
+		 * get_page().
+		 */
+		VM_BUG_ON(atomic_read(&page->first_page->_count) <= 0);
+		atomic_inc(&page->first_page->_count);
+	}
 }
 
 static inline struct page *virt_to_head_page(const void *x)
diff -puN mm/swap.c~thp-alter-compound-get_page-put_page mm/swap.c
--- a/mm/swap.c~thp-alter-compound-get_page-put_page
+++ a/mm/swap.c
@@ -58,17 +58,93 @@ static void __page_cache_release(struct 
 		del_page_from_lru(zone, page);
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
 	}
+}
+
+static void __put_single_page(struct page *page)
+{
+	__page_cache_release(page);
 	free_hot_cold_page(page, 0);
 }
 
-static void put_compound_page(struct page *page)
+static void __put_compound_page(struct page *page)
 {
-	page = compound_head(page);
-	if (put_page_testzero(page)) {
-		compound_page_dtor *dtor;
+	compound_page_dtor *dtor;
+
+	__page_cache_release(page);
+	dtor = get_compound_page_dtor(page);
+	(*dtor)(page);
+}
 
-		dtor = get_compound_page_dtor(page);
-		(*dtor)(page);
+static void put_compound_page(struct page *page)
+{
+	if (unlikely(PageTail(page))) {
+		/* __split_huge_page_refcount can run under us */
+		struct page *page_head = page->first_page;
+		smp_rmb();
+		/*
+		 * If PageTail is still set after smp_rmb() we can be sure
+		 * that the page->first_page we read wasn't a dangling pointer.
+		 * See __split_huge_page_refcount() smp_wmb().
+		 */
+		if (likely(PageTail(page) && get_page_unless_zero(page_head))) {
+			unsigned long flags;
+			/*
+			 * Verify that our page_head wasn't converted
+			 * to a a regular page before we got a
+			 * reference on it.
+			 */
+			if (unlikely(!PageHead(page_head))) {
+				/* PageHead is cleared after PageTail */
+				smp_rmb();
+				VM_BUG_ON(PageTail(page));
+				goto out_put_head;
+			}
+			/*
+			 * Only run compound_lock on a valid PageHead,
+			 * after having it pinned with
+			 * get_page_unless_zero() above.
+			 */
+			smp_mb();
+			/* page_head wasn't a dangling pointer */
+			flags = compound_lock_irqsave(page_head);
+			if (unlikely(!PageTail(page))) {
+				/* __split_huge_page_refcount run before us */
+				compound_unlock_irqrestore(page_head, flags);
+				VM_BUG_ON(PageHead(page_head));
+			out_put_head:
+				if (put_page_testzero(page_head))
+					__put_single_page(page_head);
+			out_put_single:
+				if (put_page_testzero(page))
+					__put_single_page(page);
+				return;
+			}
+			VM_BUG_ON(page_head != page->first_page);
+			/*
+			 * We can release the refcount taken by
+			 * get_page_unless_zero now that
+			 * split_huge_page_refcount is blocked on the
+			 * compound_lock.
+			 */
+			if (put_page_testzero(page_head))
+				VM_BUG_ON(1);
+			/* __split_huge_page_refcount will wait now */
+			VM_BUG_ON(atomic_read(&page->_count) <= 0);
+			atomic_dec(&page->_count);
+			VM_BUG_ON(atomic_read(&page_head->_count) <= 0);
+			compound_unlock_irqrestore(page_head, flags);
+			if (put_page_testzero(page_head))
+				__put_compound_page(page_head);
+		} else {
+			/* page_head is a dangling pointer */
+			VM_BUG_ON(PageTail(page));
+			goto out_put_single;
+		}
+	} else if (put_page_testzero(page)) {
+		if (PageHead(page))
+			__put_compound_page(page);
+		else
+			__put_single_page(page);
 	}
 }
 
@@ -77,7 +153,7 @@ void put_page(struct page *page)
 	if (unlikely(PageCompound(page)))
 		put_compound_page(page);
 	else if (put_page_testzero(page))
-		__page_cache_release(page);
+		__put_single_page(page);
 }
 EXPORT_SYMBOL(put_page);
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-compaction-add-trace-events-for-memory-compaction-activity.patch
mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch
mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode-fix.patch
thp-ksm-free-swap-when-swapcache-page-is-replaced.patch
thp-fix-bad_page-to-show-the-real-reason-the-page-is-bad.patch
thp-transparent-hugepage-support-documentation.patch
thp-mm-define-madv_hugepage.patch
thp-compound_lock.patch
thp-alter-compound-get_page-put_page.patch
thp-put_page-recheck-pagehead-after-releasing-the-compound_lock.patch
thp-update-futex-compound-knowledge.patch
thp-clear-compound-mapping.patch
thp-add-native_set_pmd_at.patch
thp-add-pmd-paravirt-ops.patch
thp-no-paravirt-version-of-pmd-ops.patch
thp-export-maybe_mkwrite.patch
thp-comment-reminder-in-destroy_compound_page.patch
thp-config_transparent_hugepage.patch
thp-special-pmd_trans_-functions.patch
thp-add-pmd-mangling-generic-functions.patch
thp-add-pmd-mangling-functions-to-x86.patch
thp-bail-out-gup_fast-on-splitting-pmd.patch
thp-pte-alloc-trans-splitting.patch
thp-add-pmd-mmu_notifier-helpers.patch
thp-clear-page-compound.patch
thp-add-pmd_huge_pte-to-mm_struct.patch
thp-split_huge_page_mm-vma.patch
thp-split_huge_page-paging.patch
thp-clear_copy_huge_page.patch
thp-_gfp_no_kswapd.patch
thp-dont-alloc-harder-for-gfp-nomemalloc-even-if-nowait.patch
thp-transparent-hugepage-core.patch
thp-split_huge_page-anon_vma-ordering-dependency.patch
thp-verify-pmd_trans_huge-isnt-leaking.patch
thp-madvisemadv_hugepage.patch
thp-add-pagetranscompound.patch
thp-pmd_trans_huge-migrate-bugcheck.patch
thp-memcg-compound.patch
thp-transhuge-memcg-commit-tail-pages-at-charge.patch
thp-memcg-huge-memory.patch
thp-transparent-hugepage-vmstat.patch
thp-khugepaged.patch
thp-khugepaged-vma-merge.patch
thp-skip-transhuge-pages-in-ksm-for-now.patch
thp-remove-pg_buddy.patch
thp-add-x86-32bit-support.patch
thp-mincore-transparent-hugepage-support.patch
thp-add-pmd_modify.patch
thp-mprotect-pass-vma-down-to-page-table-walkers.patch
thp-mprotect-transparent-huge-page-support.patch
thp-set-recommended-min-free-kbytes.patch
thp-enable-direct-defrag.patch
thp-add-numa-awareness-to-hugepage-allocations.patch
thp-allocate-memory-in-khugepaged-outside-of-mmap_sem-write-mode.patch
thp-transparent-hugepage-config-choice.patch
thp-select-config_compaction-if-transparent_hugepage-enabled.patch
thp-transhuge-isolate_migratepages.patch
thp-avoid-breaking-huge-pmd-invariants-in-case-of-vma_adjust-failures.patch
thp-dont-allow-transparent-hugepage-support-without-pse.patch
thp-mmu_notifier_test_young.patch
thp-freeze-khugepaged-and-ksmd.patch
thp-use-compaction-in-kswapd-for-gfp_atomic-order-0.patch
thp-use-compaction-for-all-allocation-orders.patch
thp-disable-transparent-hugepages-by-default-on-small-systems.patch
thp-fix-anon-memory-statistics-with-transparent-hugepages.patch
thp-scale-nr_rotated-to-balance-memory-pressure.patch
thp-transparent-hugepage-sysfs-meminfo.patch
thp-add-debug-checks-for-mapcount-related-invariants.patch
thp-fix-memory-failure-hugetlbfs-vs-thp-collision.patch
thp-compound_trans_order.patch
thp-mm-define-madv_nohugepage.patch
thp-madvisemadv_nohugepage.patch

