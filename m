From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix.patch removed from -mm tree
Date: Mon, 08 Oct 2012 16:11:27 -0700
Message-ID: <20121008231128.3DDFD200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:57563 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2JHXLa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 19:11:30 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so215639wib.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 16:11:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix.patch

This patch was dropped because it was folded into mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix

augment comment

Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix
+++ a/mm/compaction.c
@@ -415,7 +415,8 @@ isolate_migratepages_range(struct zone *
 		 * if PageLRU is set) but the lock is not necessarily taken
 		 * here and it is wasteful to take it just to check transhuge.
 		 * Check transhuge without lock and skip if it's either a
-		 * transhuge or hugetlbfs page.
+		 * transhuge or hugetlbfs page because calling compound_order()
+		 * requires lru_lock to exclude isolation and splitting.
 		 */
 		if (PageTransHuge(page)) {
 			if (!locked)
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-remove-__gfp_no_kswapd.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch
mm-fix-tracing-in-free_pcppages_bulk.patch
cma-fix-counting-of-isolated-pages.patch
cma-count-free-cma-pages.patch
cma-fix-watermark-checking.patch
mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private.patch
mm-remain-migratetype-in-freed-page.patch
memory-hotplug-bug-fix-race-between-isolation-and-allocation.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
mm-memblock-use-existing-interface-to-set-nid.patch
mm-memblock-cleanup-early_node_map-related-comments.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix-fix.patch
mm-compaction-acquire-the-zone-lock-as-late-as-possible.patch
revert-mm-have-order-0-compaction-start-off-where-it-left.patch
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix3.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
memory-hotplug-dont-replace-lowmem-pages-with-highmem.patch
mm-enable-config_compaction-by-default.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix-fix.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range-fix.patch
memory-hotplug-fix-zone-stat-mismatch.patch
cma-migrate-mlocked-pages.patch
cma-migrate-mlocked-pages-fix.patch
cma-decrease-ccnr_migratepages-after-reclaiming-pagelist.patch

