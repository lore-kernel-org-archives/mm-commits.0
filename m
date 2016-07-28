From: akpm@linux-foundation.org
Subject: [folded-merged] mm-vmscan-remove-highmem_file_pages-fix.patch
 removed from -mm tree
Date: Thu, 28 Jul 2016 15:04:32 -0700
Message-ID: <579a8170.XeyTbCCh6tx3u4Sa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54696 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbcG1WEd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:04:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: remove highmem_file_pages -fix
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-highmem_file_pages-fix.patch

This patch was dropped because it was folded into mm-vmscan-remove-highmem_file_pages.patch

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, vmscan: remove highmem_file_pages -fix

The wrong stat is being accumulatedin highmem_dirtyable_memory, fix it.

This is a fix to the mmotm patch mm-vmscan-remove-highmem_file_pages.patch

Link: http://lkml.kernel.org/r/20160725092324.GM10438@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page-writeback.c~mm-vmscan-remove-highmem_file_pages-fix mm/page-writeback.c
--- a/mm/page-writeback.c~mm-vmscan-remove-highmem_file_pages-fix
+++ a/mm/page-writeback.c
@@ -322,8 +322,8 @@ static unsigned long highmem_dirtyable_m
 			nr_pages = zone_page_state(z, NR_FREE_PAGES);
 			/* watch for underflows */
 			nr_pages -= min(nr_pages, high_wmark_pages(z));
-			nr_pages += zone_page_state(z, NR_INACTIVE_FILE);
-			nr_pages += zone_page_state(z, NR_ACTIVE_FILE);
+			nr_pages += zone_page_state(z, NR_ZONE_INACTIVE_FILE);
+			nr_pages += zone_page_state(z, NR_ZONE_ACTIVE_FILE);
 			x += nr_pages;
 		}
 	}
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-meminit-remove-early_page_nid_uninitialised.patch
mm-vmstat-add-infrastructure-for-per-node-vmstats.patch
mm-vmscan-move-lru_lock-to-the-node.patch
mm-vmscan-move-lru-lists-to-node.patch
mm-mmzone-clarify-the-usage-of-zone-padding.patch
mm-vmscan-begin-reclaiming-pages-on-a-per-node-basis.patch
mm-vmscan-have-kswapd-only-scan-based-on-the-highest-requested-zone.patch
mm-vmscan-make-kswapd-reclaim-in-terms-of-nodes.patch
mm-vmscan-remove-balance-gap.patch
mm-vmscan-simplify-the-logic-deciding-whether-kswapd-sleeps.patch
mm-vmscan-by-default-have-direct-reclaim-only-shrink-once-per-node.patch
mm-vmscan-remove-duplicate-logic-clearing-node-congestion-and-dirty-state.patch
mm-vmscan-do-not-reclaim-from-kswapd-if-there-is-any-eligible-zone.patch
mm-vmscan-make-shrink_node-decisions-more-node-centric.patch
mm-memcg-move-memcg-limit-enforcement-from-zones-to-nodes.patch
mm-workingset-make-working-set-detection-node-aware.patch
mm-page_alloc-consider-dirtyable-memory-in-terms-of-nodes.patch
mm-move-page-mapped-accounting-to-the-node.patch
mm-rename-nr_anon_pages-to-nr_anon_mapped.patch
mm-move-most-file-based-accounting-to-the-node.patch
mm-move-vmscan-writes-and-file-write-accounting-to-the-node.patch
mm-vmscan-only-wakeup-kswapd-once-per-node-for-the-requested-classzone.patch
mm-page_alloc-wake-kswapd-based-on-the-highest-eligible-zone.patch
mm-convert-zone_reclaim-to-node_reclaim.patch
mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-shrink_node.patch
mm-vmscan-avoid-passing-in-classzone_idx-unnecessarily-to-compaction_ready.patch
mm-vmscan-avoid-passing-in-remaining-unnecessarily-to-prepare_kswapd_sleep.patch
mm-vmscan-have-kswapd-reclaim-from-all-zones-if-reclaiming-and-buffer_heads_over_limit.patch
mm-vmscan-add-classzone-information-to-tracepoints.patch
mm-page_alloc-remove-fair-zone-allocation-policy.patch
mm-page_alloc-cache-the-last-node-whose-dirty-limit-is-reached.patch
mm-vmstat-replace-__count_zone_vm_events-with-a-zone-id-equivalent.patch
mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim.patch
mm-vmstat-print-node-based-stats-in-zoneinfo-file.patch
mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries.patch
mm-pagevec-release-reacquire-lru_lock-on-pgdat-change.patch
mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg.patch
mm-vmscan-remove-redundant-check-in-shrink_zones.patch
mm-vmscan-release-reacquire-lru_lock-on-pgdat-change.patch
mm-vmscan-remove-highmem_file_pages.patch
mm-remove-reclaim-and-compaction-retry-approximations.patch
mm-consider-whether-to-decivate-based-on-eligible-zones-inactive-ratio.patch
mm-vmscan-account-for-skipped-pages-as-a-partial-scan.patch

