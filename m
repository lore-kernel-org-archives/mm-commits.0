From: akpm@linux-foundation.org
Subject: + mm-remove-free_page_mlock.patch added to -mm tree
Date: Wed, 19 Sep 2012 15:02:10 -0700
Message-ID: <20120919220211.59CF01E004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:51224 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab2ISWCM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Sep 2012 18:02:12 -0400
Received: by qcqs25 with SMTP id s25so212139qcq.1
        for <mm-commits@vger.kernel.org>; Wed, 19 Sep 2012 15:02:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, hannes@cmpxchg.org, mel@csn.ul.ie, riel@redhat.com, walken@google.com, yinghan@google.com


The patch titled
     Subject: mm: remove free_page_mlock
has been added to the -mm tree.  Its filename is
     mm-remove-free_page_mlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: remove free_page_mlock

We should not be seeing non-0 unevictable_pgs_mlockfreed any longer.  So
remove free_page_mlock() from the page freeing paths: __PG_MLOCKED is
already in PAGE_FLAGS_CHECK_AT_FREE, so free_pages_check() will now be
checking it, reporting "BUG: Bad page state" if it's ever found set. 
Comment UNEVICTABLE_MLOCKFREED and unevictable_pgs_mlockfreed always 0.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    2 +-
 mm/page_alloc.c               |   17 -----------------
 mm/vmstat.c                   |    2 +-
 3 files changed, 2 insertions(+), 19 deletions(-)

diff -puN include/linux/vm_event_item.h~mm-remove-free_page_mlock include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-remove-free_page_mlock
+++ a/include/linux/vm_event_item.h
@@ -52,7 +52,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		UNEVICTABLE_PGMUNLOCKED,
 		UNEVICTABLE_PGCLEARED,	/* on COW, page truncate */
 		UNEVICTABLE_PGSTRANDED,	/* unable to isolate on unlock */
-		UNEVICTABLE_MLOCKFREED,
+		UNEVICTABLE_MLOCKFREED,	/* no longer useful: always zero */
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 		THP_FAULT_ALLOC,
 		THP_FAULT_FALLBACK,
diff -puN mm/page_alloc.c~mm-remove-free_page_mlock mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-free_page_mlock
+++ a/mm/page_alloc.c
@@ -597,17 +597,6 @@ out:
 	zone->free_area[order].nr_free++;
 }
 
-/*
- * free_page_mlock() -- clean up attempts to free and mlocked() page.
- * Page should not be on lru, so no need to fix that up.
- * free_pages_check() will verify...
- */
-static inline void free_page_mlock(struct page *page)
-{
-	__dec_zone_page_state(page, NR_MLOCK);
-	__count_vm_event(UNEVICTABLE_MLOCKFREED);
-}
-
 static inline int free_pages_check(struct page *page)
 {
 	if (unlikely(page_mapcount(page) |
@@ -727,15 +716,12 @@ static bool free_pages_prepare(struct pa
 static void __free_pages_ok(struct page *page, unsigned int order)
 {
 	unsigned long flags;
-	int wasMlocked = __TestClearPageMlocked(page);
 	int migratetype;
 
 	if (!free_pages_prepare(page, order))
 		return;
 
 	local_irq_save(flags);
-	if (unlikely(wasMlocked))
-		free_page_mlock(page);
 	__count_vm_events(PGFREE, 1 << order);
 	migratetype = get_pageblock_migratetype(page);
 	set_freepage_migratetype(page, migratetype);
@@ -1309,7 +1295,6 @@ void free_hot_cold_page(struct page *pag
 	struct per_cpu_pages *pcp;
 	unsigned long flags;
 	int migratetype;
-	int wasMlocked = __TestClearPageMlocked(page);
 
 	if (!free_pages_prepare(page, 0))
 		return;
@@ -1317,8 +1302,6 @@ void free_hot_cold_page(struct page *pag
 	migratetype = get_pageblock_migratetype(page);
 	set_freepage_migratetype(page, migratetype);
 	local_irq_save(flags);
-	if (unlikely(wasMlocked))
-		free_page_mlock(page);
 	__count_vm_event(PGFREE);
 
 	/*
diff -puN mm/vmstat.c~mm-remove-free_page_mlock mm/vmstat.c
--- a/mm/vmstat.c~mm-remove-free_page_mlock
+++ a/mm/vmstat.c
@@ -782,7 +782,7 @@ const char * const vmstat_text[] = {
 	"unevictable_pgs_munlocked",
 	"unevictable_pgs_cleared",
 	"unevictable_pgs_stranded",
-	"unevictable_pgs_mlockfreed",
+	"unevictable_pgs_mlockfreed",	/* no longer useful: always zero */
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	"thp_fault_alloc",
_

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
x86-pat-remove-the-dependency-on-vm_pgoff-in-track-untrack-pfn-vma-routines.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
mm-x86-pat-rework-linear-pfn-mmap-tracking.patch
mm-introduce-arch-specific-vma-flag-vm_arch_1.patch
mm-kill-vma-flag-vm_insertpage.patch
mm-kill-vma-flag-vm_can_nonlinear.patch
mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file.patch
mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas.patch
mm-prepare-vm_dontdump-for-using-in-drivers.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch
mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links.patch
mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
mm-mmu_notifier-init-notifier-if-necessary.patch
thp-fix-the-count-of-thp_collapse_alloc.patch
thp-remove-unnecessary-check-in-start_khugepaged.patch
thp-move-khugepaged_mutex-out-of-khugepaged.patch
thp-remove-unnecessary-khugepaged_thread-check.patch
thp-remove-wake_up_interruptible-in-the-exit-path.patch
thp-remove-some-code-depend-on-config_numa.patch
thp-merge-page-pre-alloc-in-khugepaged_loop-into-khugepaged_do_scan.patch
thp-release-page-in-page-pre-alloc-path.patch
thp-introduce-khugepaged_prealloc_page-and-khugepaged_alloc_page.patch
thp-remove-khugepaged_loop.patch
thp-use-khugepaged_enabled-to-remove-duplicate-code.patch
thp-remove-unnecessary-set_recommended_min_free_kbytes.patch
mm-fix-potential-anon_vma-locking-issue-in-mprotect.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch
mm-interval-tree-updates.patch
mm-anon-rmap-remove-anon_vma_moveto_tail.patch
mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree.patch
mm-rmap-remove-vma_address-check-for-address-inside-vma.patch
mm-add-config_debug_vm_rb-build-option.patch
mm-anon-rmap-in-mremap-set-the-new-vmas-position-before-anon_vma_clone.patch
mm-avoid-taking-rmap-locks-in-move_ptes.patch
mm-fix-tracing-in-free_pcppages_bulk.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-fix-counting-of-isolated-pages.patch
cma-count-free-cma-pages.patch
cma-count-free-cma-pages-fix.patch
cma-fix-watermark-checking.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
thp-khugepaged_prealloc_page-forgot-to-reset-the-page-alloc-indicator.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-remove-vma-arg-from-page_evictable.patch
mm-clear_page_mlock-in-page_remove_rmap.patch
mm-remove-free_page_mlock.patch
mm-thp-fix-pmd_present-for-split_huge_page-and-prot_none-with-thp.patch

