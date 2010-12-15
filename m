From: akpm@linux-foundation.org
Subject: + thp-split_huge_page-paging.patch added to -mm tree
Date: Wed, 15 Dec 2010 15:56:52 -0800
Message-ID: <201012152356.oBFNuqUK013537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755885Ab0LPAC1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 19:02:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com


The patch titled
     thp: split_huge_page paging
has been added to the -mm tree.  Its filename is
     thp-split_huge_page-paging.patch

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
Subject: thp: split_huge_page paging
From: Andrea Arcangeli <aarcange@redhat.com>

Paging logic that splits the page before it is unmapped and added to swap
to ensure backwards compatibility with the legacy swap code.  Eventually
swap should natively pageout the hugepages to increase performance and
decrease seeking and fragmentation of swap space.  swapoff can just skip
over huge pmd as they cannot be part of swap yet.  In add_to_swap be
careful to split the page only if we got a valid swap entry so we don't
split hugepages with a full swap.

In theory we could split pages before isolating them during the lru scan,
but for khugepaged to be safe, I'm relying on either mmap_sem write mode,
or PG_lock taken, so split_huge_page has to run either with mmap_sem
read/write mode or PG_lock taken.  Calling it from isolate_lru_page would
make locking more complicated, in addition to that split_huge_page would
deadlock if called by __isolate_lru_page because it has to take the lru
lock to add the tail pages.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 ++
 mm/rmap.c           |    1 +
 mm/swap_state.c     |    6 ++++++
 mm/swapfile.c       |    2 ++
 4 files changed, 11 insertions(+)

diff -puN mm/memory-failure.c~thp-split_huge_page-paging mm/memory-failure.c
--- a/mm/memory-failure.c~thp-split_huge_page-paging
+++ a/mm/memory-failure.c
@@ -386,6 +386,8 @@ static void collect_procs_anon(struct pa
 	struct task_struct *tsk;
 	struct anon_vma *av;
 
+	if (unlikely(split_huge_page(page)))
+		return;
 	read_lock(&tasklist_lock);
 	av = page_lock_anon_vma(page);
 	if (av == NULL)	/* Not actually mapped anymore */
diff -puN mm/rmap.c~thp-split_huge_page-paging mm/rmap.c
--- a/mm/rmap.c~thp-split_huge_page-paging
+++ a/mm/rmap.c
@@ -1400,6 +1400,7 @@ int try_to_unmap(struct page *page, enum
 	int ret;
 
 	BUG_ON(!PageLocked(page));
+	BUG_ON(PageTransHuge(page));
 
 	if (unlikely(PageKsm(page)))
 		ret = try_to_unmap_ksm(page, flags);
diff -puN mm/swap_state.c~thp-split_huge_page-paging mm/swap_state.c
--- a/mm/swap_state.c~thp-split_huge_page-paging
+++ a/mm/swap_state.c
@@ -157,6 +157,12 @@ int add_to_swap(struct page *page)
 	if (!entry.val)
 		return 0;
 
+	if (unlikely(PageTransHuge(page)))
+		if (unlikely(split_huge_page(page))) {
+			swapcache_free(entry, NULL);
+			return 0;
+		}
+
 	/*
 	 * Radix-tree node allocations from PF_MEMALLOC contexts could
 	 * completely exhaust the page allocator. __GFP_NOMEMALLOC
diff -puN mm/swapfile.c~thp-split_huge_page-paging mm/swapfile.c
--- a/mm/swapfile.c~thp-split_huge_page-paging
+++ a/mm/swapfile.c
@@ -964,6 +964,8 @@ static inline int unuse_pmd_range(struct
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
+		if (unlikely(pmd_trans_huge(*pmd)))
+			continue;
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
 		ret = unuse_pte_range(vma, pmd, addr, next, entry, page);
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

