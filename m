From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix-fix.patch removed from -mm tree
Date: Mon, 08 Oct 2012 16:11:31 -0700
Message-ID: <20121008231132.4001520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:48676 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2JHXLe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 19:11:34 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so295269wey.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 16:11:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@suse.de, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix-fix.patch

This patch was dropped because it was folded into mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix-fix

Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/compaction.c~mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix-fix
+++ a/mm/compaction.c
@@ -414,9 +414,10 @@ isolate_migratepages_range(struct zone *
 		 * splitting and collapsing (collapsing has already happened
 		 * if PageLRU is set) but the lock is not necessarily taken
 		 * here and it is wasteful to take it just to check transhuge.
-		 * Check transhuge without lock and skip if it's either a
-		 * transhuge or hugetlbfs page because calling compound_order()
-		 * requires lru_lock to exclude isolation and splitting.
+		 * Check TransHuge without lock and skip the whole pageblock if
+		 * it's either a transhuge or hugetlbfs page, as calling
+		 * compound_order() without preventing THP from splitting the
+		 * page underneath us may return surprising results.
 		 */
 		if (PageTransHuge(page)) {
 			if (!locked)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host.patch
rbtree-performance-and-correctness-test.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch
mm-fix-tracing-in-free_pcppages_bulk.patch
cma-count-free-cma-pages.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
atomic-implement-generic-atomic_dec_if_positive.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
cma-migrate-mlocked-pages-fix.patch
mm-avoid-section-mismatch-warning-for-memblock_type_name-fix.patch
mm-document-pagehuge-somewhat.patch
mm-memcg-clean-up-mm_match_cgroup-signature-fix.patch
memory-hotplug-suppress-trying-to-free-nonexistent-resource-xxxxxxxxxxxxxxxx-yyyyyyyyyyyyyyyy-warning.patch
mm-add-and-use-update_mmu_cache_pmd-in-transparent-huge-page-code-fix.patch

