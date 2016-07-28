From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim-fix.patch removed from -mm tree
Date: Thu, 28 Jul 2016 14:58:01 -0700
Message-ID: <579a7fe9.47C6yvvRfFMD8oE4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54678 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbcG1V6C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 17:58:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmstat: account per-zone stalls and pages skipped during reclaim -fix
has been removed from the -mm tree.  Its filename was
     mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim-fix.patch

This patch was dropped because it was folded into mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim.patch

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: vmstat: account per-zone stalls and pages skipped during reclaim -fix

As pointed out by Johannes -- the PG prefix seems to stand for page, and
all stat names that contain it represent some per-page event. PGSTALL is
not a page event. This patch renames it.

This is a fix for the mmotm patch
mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim.patch

Link: http://lkml.kernel.org/r/1468404004-5085-3-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    2 +-
 mm/vmscan.c                   |    2 +-
 mm/vmstat.c                   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/vm_event_item.h~mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim-fix include/linux/vm_event_item.h
--- a/include/linux/vm_event_item.h~mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim-fix
+++ a/include/linux/vm_event_item.h
@@ -23,7 +23,7 @@
 
 enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		FOR_ALL_ZONES(PGALLOC),
-		FOR_ALL_ZONES(PGSTALL),
+		FOR_ALL_ZONES(ALLOCSTALL),
 		FOR_ALL_ZONES(PGSCAN_SKIP),
 		PGFREE, PGACTIVATE, PGDEACTIVATE,
 		PGFAULT, PGMAJFAULT,
diff -puN mm/vmscan.c~mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim-fix
+++ a/mm/vmscan.c
@@ -2691,7 +2691,7 @@ retry:
 	delayacct_freepages_start();
 
 	if (global_reclaim(sc))
-		__count_zid_vm_events(PGSTALL, sc->reclaim_idx, 1);
+		__count_zid_vm_events(ALLOCSTALL, sc->reclaim_idx, 1);
 
 	do {
 		vmpressure_prio(sc->gfp_mask, sc->target_mem_cgroup,
diff -puN mm/vmstat.c~mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim-fix mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim-fix
+++ a/mm/vmstat.c
@@ -983,7 +983,7 @@ const char * const vmstat_text[] = {
 	"pswpout",
 
 	TEXTS_FOR_ZONES("pgalloc")
-	TEXTS_FOR_ZONES("pgstall")
+	TEXTS_FOR_ZONES("allocstall")
 	TEXTS_FOR_ZONES("pgskip")
 
 	"pgfree",
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
mm-vmstat-remove-zone-and-node-double-accounting-by-approximating-retries-fix.patch
mm-pagevec-release-reacquire-lru_lock-on-pgdat-change.patch
mm-vmscan-update-all-zone-lru-sizes-before-updating-memcg.patch
mm-vmscan-remove-redundant-check-in-shrink_zones.patch
mm-vmscan-release-reacquire-lru_lock-on-pgdat-change.patch
mm-vmscan-release-reacquire-lru_lock-on-pgdat-change-fix.patch
mm-add-per-zone-lru-list-stat-fix.patch
mm-vmscan-remove-highmem_file_pages.patch
mm-vmscan-remove-highmem_file_pages-fix.patch
mm-remove-reclaim-and-compaction-retry-approximations.patch
mm-consider-whether-to-decivate-based-on-eligible-zones-inactive-ratio.patch
mm-vmscan-account-for-skipped-pages-as-a-partial-scan.patch

