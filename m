From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix.patch removed from -mm tree
Date: Mon, 08 Oct 2012 16:07:55 -0700
Message-ID: <20121008230756.2FCAA5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:52064 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab2JHXH7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 19:07:59 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so291283fae.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 16:07:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, kyungmin.park@samsung.com, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix
has been removed from the -mm tree.  Its filename was
     mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix.patch

This patch was dropped because it was folded into mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix

It is possible for pages to be dirty after the check
in reclaim_clean_pages_from_list so that it ends up
paging out the pages, which is never what we want for speed up.

This patch fixes it.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix
+++ a/mm/vmscan.c
@@ -694,7 +694,7 @@ static unsigned long shrink_page_list(st
 		struct address_space *mapping;
 		struct page *page;
 		int may_enter_fs;
-		enum page_references references = PAGEREF_RECLAIM;
+		enum page_references references = PAGEREF_RECLAIM_CLEAN;
 
 		cond_resched();
 
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-remove-__gfp_no_kswapd.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix-fix.patch
mm-fix-tracing-in-free_pcppages_bulk.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-fix-counting-of-isolated-pages.patch
cma-count-free-cma-pages.patch
cma-count-free-cma-pages-fix.patch
cma-fix-watermark-checking.patch
cma-fix-watermark-checking-fix.patch
mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private.patch
mm-remain-migratetype-in-freed-page.patch
memory-hotplug-bug-fix-race-between-isolation-and-allocation.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
mm-memblock-use-existing-interface-to-set-nid.patch
mm-memblock-cleanup-early_node_map-related-comments.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix.patch
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

