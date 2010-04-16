From: akpm@linux-foundation.org
Subject: + mm-introduce-free_pages_prepare.patch added to -mm tree
Date: Fri, 16 Apr 2010 15:13:21 -0700
Message-ID: <201004162213.o3GMDL2j029711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932622Ab0DPWNu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Apr 2010 18:13:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     mm: introduce free_pages_prepare()
has been added to the -mm tree.  Its filename is
     mm-introduce-free_pages_prepare.patch

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
Subject: mm: introduce free_pages_prepare()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

free_hot_cold_page() and __free_pages_ok() have very similar freeing
preparation.  Consolidate them.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff -puN mm/page_alloc.c~mm-introduce-free_pages_prepare mm/page_alloc.c
--- a/mm/page_alloc.c~mm-introduce-free_pages_prepare
+++ a/mm/page_alloc.c
@@ -620,20 +620,23 @@ static void free_one_page(struct zone *z
 	spin_unlock(&zone->lock);
 }
 
-static void __free_pages_ok(struct page *page, unsigned int order)
+static bool free_pages_prepare(struct page *page, unsigned int order)
 {
-	unsigned long flags;
 	int i;
 	int bad = 0;
-	int wasMlocked = __TestClearPageMlocked(page);
 
 	trace_mm_page_free_direct(page, order);
 	kmemcheck_free_shadow(page, order);
 
-	for (i = 0 ; i < (1 << order) ; ++i)
-		bad += free_pages_check(page + i);
+	for (i = 0 ; i < (1 << order) ; ++i) {
+		struct page *pg = page + i;
+
+		if (PageAnon(pg))
+			pg->mapping = NULL;
+		bad += free_pages_check(pg);
+	}
 	if (bad)
-		return;
+		return false;
 
 	if (!PageHighMem(page)) {
 		debug_check_no_locks_freed(page_address(page),PAGE_SIZE<<order);
@@ -643,6 +646,17 @@ static void __free_pages_ok(struct page 
 	arch_free_page(page, order);
 	kernel_map_pages(page, 1 << order, 0);
 
+	return true;
+}
+
+static void __free_pages_ok(struct page *page, unsigned int order)
+{
+	unsigned long flags;
+	int wasMlocked = __TestClearPageMlocked(page);
+
+	if (!free_pages_prepare(page, order))
+		return;
+
 	local_irq_save(flags);
 	if (unlikely(wasMlocked))
 		free_page_mlock(page);
@@ -1128,21 +1142,9 @@ void free_hot_cold_page(struct page *pag
 	int migratetype;
 	int wasMlocked = __TestClearPageMlocked(page);
 
-	trace_mm_page_free_direct(page, 0);
-	kmemcheck_free_shadow(page, 0);
-
-	if (PageAnon(page))
-		page->mapping = NULL;
-	if (free_pages_check(page))
+	if (!free_pages_prepare(page, 0))
 		return;
 
-	if (!PageHighMem(page)) {
-		debug_check_no_locks_freed(page_address(page), PAGE_SIZE);
-		debug_check_no_obj_freed(page_address(page), PAGE_SIZE);
-	}
-	arch_free_page(page, 0);
-	kernel_map_pages(page, 1, 0);
-
 	migratetype = get_pageblock_migratetype(page);
 	set_page_private(page, migratetype);
 	local_irq_save(flags);
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
rmap-add-exclusively-owned-pages-to-the-newest-anon_vma.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mm-remove-return-value-of-putback_lru_pages.patch
mempolicy-remove-redundant-code.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-badness-heuristic-rewrite.patch
oom-deprecate-oom_adj-tunable.patch
oom-replace-sysctls-with-quick-mode.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-remove-unnecessary-code-and-cleanup.patch
oom-default-to-killing-current-for-pagefault-ooms.patch
oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch
oom-hold-tasklist_lock-when-dumping-tasks.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-clean-up-oom_kill_task.patch
oom-clean-up-oom_badness.patch
mempolicy-dont-call-mpol_set_nodemask-when-no_context.patch
mempolicy-lose-unnecessary-loop-variable-in-mpol_parse_str.patch
mempolicy-rename-policy_types-and-cleanup-initialization.patch
mempolicy-factor-mpol_shared_policy_init-return-paths.patch
mempolicy-document-cpuset-interaction-with-tmpfs-mpol-mount-option.patch
mm-migration-take-a-reference-to-the-anon_vma-before-migrating.patch
mm-migration-do-not-try-to-migrate-unmapped-anonymous-pages.patch
mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove-fix.patch
mm-export-unusable-free-space-index-via-proc-unusable_index.patch
mm-export-unusable-free-space-index-via-proc-unusable_index-fix.patch
mm-export-unusable-free-space-index-via-proc-unusable_index-fix-fix-2.patch
mm-export-fragmentation-index-via-proc-extfrag_index.patch
mm-export-fragmentation-index-via-proc-extfrag_index-fix.patch
mm-move-definition-for-lru-isolation-modes-to-a-header.patch
mm-compaction-memory-compaction-core.patch
mm-compaction-memory-compaction-core-fix.patch
mm-compaction-add-proc-trigger-for-memory-compaction.patch
mm-compaction-add-proc-trigger-for-memory-compaction-fix.patch
mm-compaction-add-proc-trigger-for-memory-compaction-fix-fix.patch
mm-compaction-add-sys-trigger-for-per-node-memory-compaction.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails-reject-fix.patch
mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
mm-migration-allow-the-migration-of-pageswapcache-pages.patch
mm-migration-allow-the-migration-of-pageswapcache-pages-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-fix-fix-2.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_co-mpaction-reject-fixpatch-added-to-mm-tree.patch
vmscan-prevent-get_scan_ratio-rounding-errors.patch
vmscan-page_check_references-check-low-order-lumpy-reclaim-properly.patch
mm-introduce-free_pages_prepare.patch
proc-cleanup-remove-unused-assignments.patch
reiser4.patch

