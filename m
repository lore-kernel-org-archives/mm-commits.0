From: akpm@linux-foundation.org
Subject: + cma-decrease-ccnr_migratepages-after-reclaiming-pagelist.patch added to -mm tree
Date: Wed, 26 Sep 2012 14:36:49 -0700
Message-ID: <20120926213650.4D278100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:45120 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2IZVgv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Sep 2012 17:36:51 -0400
Received: by qaea16 with SMTP id a16so233658qae.1
        for <mm-commits@vger.kernel.org>; Wed, 26 Sep 2012 14:36:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan@kernel.org, b.zolnierkie@samsung.com, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com


The patch titled
     Subject: CMA: decrease cc.nr_migratepages after reclaiming pagelist
has been added to the -mm tree.  Its filename is
     cma-decrease-ccnr_migratepages-after-reclaiming-pagelist.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: CMA: decrease cc.nr_migratepages after reclaiming pagelist

reclaim_clean_pages_from_list() reclaims clean pages before migration so
cc.nr_migratepages should be updated.  Currently, there is no problem but
it can be wrong if we try to use the value in future.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~cma-decrease-ccnr_migratepages-after-reclaiming-pagelist mm/page_alloc.c
--- a/mm/page_alloc.c~cma-decrease-ccnr_migratepages-after-reclaiming-pagelist
+++ a/mm/page_alloc.c
@@ -5663,7 +5663,7 @@ static unsigned long pfn_max_align_up(un
 static int __alloc_contig_migrate_range(unsigned long start, unsigned long end)
 {
 	/* This function is based on compact_zone() from compaction.c. */
-
+	unsigned long nr_reclaimed;
 	unsigned long pfn = start;
 	unsigned int tries = 0;
 	int ret = 0;
@@ -5699,7 +5699,9 @@ static int __alloc_contig_migrate_range(
 			break;
 		}
 
-		reclaim_clean_pages_from_list(cc.zone, &cc.migratepages);
+		nr_reclaimed = reclaim_clean_pages_from_list(cc.zone,
+							&cc.migratepages);
+		cc.nr_migratepages -= nr_reclaimed;
 
 		ret = migrate_pages(&cc.migratepages,
 				    alloc_migrate_target,
_

Patches currently in -mm which might be from minchan@kernel.org are

linux-next.patch
mm-remove-__gfp_no_kswapd.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix.patch
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
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-memblock-reduce-overhead-in-binary-search.patch
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
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
memory-hotplug-dont-replace-lowmem-pages-with-highmem.patch
mm-enable-config_compaction-by-default.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range-fix.patch
memory-hotplug-fix-zone-stat-mismatch.patch
cma-migrate-mlocked-pages.patch
cma-decrease-ccnr_migratepages-after-reclaiming-pagelist.patch

