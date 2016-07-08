From: akpm@linux-foundation.org
Subject: +
 mm-move-vmscan-writes-and-file-write-accounting-to-the-node.patch added to
 -mm tree
Date: Fri, 08 Jul 2016 13:33:53 -0700
Message-ID: <57800e31.87vDnDt446pJFo6q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42891 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486AbcGHUdy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2016 16:33:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@suse.com, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move vmscan writes and file write accounting to the node
has been added to the -mm tree.  Its filename is
     mm-move-vmscan-writes-and-file-write-accounting-to-the-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-vmscan-writes-and-file-write-accounting-to-the-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-vmscan-writes-and-file-write-accounting-to-the-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: move vmscan writes and file write accounting to the node

As reclaim is now node-based, it follows that page write activity due to
page reclaim should also be accounted for on the node.  For consistency,
also account page writes and page dirtying on a per-node basis.

After this patch, there are a few remaining zone counters that may appear
strange but are fine.  NUMA stats are still per-zone as this is a
user-space interface that tools consume.  NR_MLOCK, NR_SLAB_*,
NR_PAGETABLE, NR_KERNEL_STACK and NR_BOUNCE are all allocations that
potentially pin low memory and cannot trivially be reclaimed on demand.
This information is still useful for debugging a page allocation failure
warning.

Link: http://lkml.kernel.org/r/1467970510-21195-21-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h           |    8 ++++----
 include/trace/events/writeback.h |    4 ++--
 mm/page-writeback.c              |    6 +++---
 mm/vmscan.c                      |    4 ++--
 mm/vmstat.c                      |    8 ++++----
 5 files changed, 15 insertions(+), 15 deletions(-)

diff -puN include/linux/mmzone.h~mm-move-vmscan-writes-and-file-write-accounting-to-the-node include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-move-vmscan-writes-and-file-write-accounting-to-the-node
+++ a/include/linux/mmzone.h
@@ -122,10 +122,6 @@ enum zone_stat_item {
 	NR_KERNEL_STACK,
 	/* Second 128 byte cacheline */
 	NR_BOUNCE,
-	NR_VMSCAN_WRITE,
-	NR_VMSCAN_IMMEDIATE,	/* Prioritise for reclaim when writeback ends */
-	NR_DIRTIED,		/* page dirtyings since bootup */
-	NR_WRITTEN,		/* page writings since bootup */
 #if IS_ENABLED(CONFIG_ZSMALLOC)
 	NR_ZSPAGES,		/* allocated in zsmalloc */
 #endif
@@ -165,6 +161,10 @@ enum node_stat_item {
 	NR_SHMEM_PMDMAPPED,
 	NR_ANON_THPS,
 	NR_UNSTABLE_NFS,	/* NFS unstable pages */
+	NR_VMSCAN_WRITE,
+	NR_VMSCAN_IMMEDIATE,	/* Prioritise for reclaim when writeback ends */
+	NR_DIRTIED,		/* page dirtyings since bootup */
+	NR_WRITTEN,		/* page writings since bootup */
 	NR_VM_NODE_STAT_ITEMS
 };
 
diff -puN include/trace/events/writeback.h~mm-move-vmscan-writes-and-file-write-accounting-to-the-node include/trace/events/writeback.h
--- a/include/trace/events/writeback.h~mm-move-vmscan-writes-and-file-write-accounting-to-the-node
+++ a/include/trace/events/writeback.h
@@ -415,8 +415,8 @@ TRACE_EVENT(global_dirty_state,
 		__entry->nr_dirty	= global_node_page_state(NR_FILE_DIRTY);
 		__entry->nr_writeback	= global_node_page_state(NR_WRITEBACK);
 		__entry->nr_unstable	= global_node_page_state(NR_UNSTABLE_NFS);
-		__entry->nr_dirtied	= global_page_state(NR_DIRTIED);
-		__entry->nr_written	= global_page_state(NR_WRITTEN);
+		__entry->nr_dirtied	= global_node_page_state(NR_DIRTIED);
+		__entry->nr_written	= global_node_page_state(NR_WRITTEN);
 		__entry->background_thresh = background_thresh;
 		__entry->dirty_thresh	= dirty_thresh;
 		__entry->dirty_limit	= global_wb_domain.dirty_limit;
diff -puN mm/page-writeback.c~mm-move-vmscan-writes-and-file-write-accounting-to-the-node mm/page-writeback.c
--- a/mm/page-writeback.c~mm-move-vmscan-writes-and-file-write-accounting-to-the-node
+++ a/mm/page-writeback.c
@@ -2461,7 +2461,7 @@ void account_page_dirtied(struct page *p
 		mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_DIRTY);
 		__inc_node_page_state(page, NR_FILE_DIRTY);
 		__inc_zone_page_state(page, NR_ZONE_WRITE_PENDING);
-		__inc_zone_page_state(page, NR_DIRTIED);
+		__inc_node_page_state(page, NR_DIRTIED);
 		__inc_wb_stat(wb, WB_RECLAIMABLE);
 		__inc_wb_stat(wb, WB_DIRTIED);
 		task_io_account_write(PAGE_SIZE);
@@ -2550,7 +2550,7 @@ void account_page_redirty(struct page *p
 
 		wb = unlocked_inode_to_wb_begin(inode, &locked);
 		current->nr_dirtied--;
-		dec_zone_page_state(page, NR_DIRTIED);
+		dec_node_page_state(page, NR_DIRTIED);
 		dec_wb_stat(wb, WB_DIRTIED);
 		unlocked_inode_to_wb_end(inode, locked);
 	}
@@ -2787,7 +2787,7 @@ int test_clear_page_writeback(struct pag
 		mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_WRITEBACK);
 		dec_node_page_state(page, NR_WRITEBACK);
 		dec_zone_page_state(page, NR_ZONE_WRITE_PENDING);
-		inc_zone_page_state(page, NR_WRITTEN);
+		inc_node_page_state(page, NR_WRITTEN);
 	}
 	unlock_page_memcg(page);
 	return ret;
diff -puN mm/vmscan.c~mm-move-vmscan-writes-and-file-write-accounting-to-the-node mm/vmscan.c
--- a/mm/vmscan.c~mm-move-vmscan-writes-and-file-write-accounting-to-the-node
+++ a/mm/vmscan.c
@@ -612,7 +612,7 @@ static pageout_t pageout(struct page *pa
 			ClearPageReclaim(page);
 		}
 		trace_mm_vmscan_writepage(page);
-		inc_zone_page_state(page, NR_VMSCAN_WRITE);
+		inc_node_page_state(page, NR_VMSCAN_WRITE);
 		return PAGE_SUCCESS;
 	}
 
@@ -1117,7 +1117,7 @@ static unsigned long shrink_page_list(st
 				 * except we already have the page isolated
 				 * and know it's dirty
 				 */
-				inc_zone_page_state(page, NR_VMSCAN_IMMEDIATE);
+				inc_node_page_state(page, NR_VMSCAN_IMMEDIATE);
 				SetPageReclaim(page);
 
 				goto keep_locked;
diff -puN mm/vmstat.c~mm-move-vmscan-writes-and-file-write-accounting-to-the-node mm/vmstat.c
--- a/mm/vmstat.c~mm-move-vmscan-writes-and-file-write-accounting-to-the-node
+++ a/mm/vmstat.c
@@ -931,10 +931,6 @@ const char * const vmstat_text[] = {
 	"nr_page_table_pages",
 	"nr_kernel_stack",
 	"nr_bounce",
-	"nr_vmscan_write",
-	"nr_vmscan_immediate_reclaim",
-	"nr_dirtied",
-	"nr_written",
 #if IS_ENABLED(CONFIG_ZSMALLOC)
 	"nr_zspages",
 #endif
@@ -971,6 +967,10 @@ const char * const vmstat_text[] = {
 	"nr_shmem_pmdmapped",
 	"nr_anon_transparent_hugepages",
 	"nr_unstable",
+	"nr_vmscan_write",
+	"nr_vmscan_immediate_reclaim",
+	"nr_dirtied",
+	"nr_written",
 
 	/* enum writeback_stat_item counters */
 	"nr_dirty_threshold",
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-meminit-always-return-a-valid-node-from-early_pfn_to_nid.patch
mm-meminit-ensure-node-is-online-before-checking-whether-pages-are-uninitialised.patch
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

