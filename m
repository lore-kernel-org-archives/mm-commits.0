From: akpm@linux-foundation.org
Subject: +
 mm-move-vmscan-writes-and-file-write-accounting-to-the-node.patch added to
 -mm tree
Date: Tue, 21 Jun 2016 15:49:50 -0700
Message-ID: <5769c48e.8/y9+clNdBJjV2qb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45082 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbcFUWuJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2016 18:50:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


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

Link: http://lkml.kernel.org/r/1466518566-30034-20-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
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
@@ -121,10 +121,6 @@ enum zone_stat_item {
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
@@ -164,6 +160,10 @@ enum node_stat_item {
 	NR_WRITEBACK_TEMP,	/* Writeback using temporary buffers */
 	NR_SHMEM,		/* shmem pages (included tmpfs/GEM pages) */
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
@@ -2433,7 +2433,7 @@ void account_page_dirtied(struct page *p
 
 		mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_DIRTY);
 		__inc_node_page_state(page, NR_FILE_DIRTY);
-		__inc_zone_page_state(page, NR_DIRTIED);
+		__inc_node_page_state(page, NR_DIRTIED);
 		__inc_wb_stat(wb, WB_RECLAIMABLE);
 		__inc_wb_stat(wb, WB_DIRTIED);
 		task_io_account_write(PAGE_SIZE);
@@ -2521,7 +2521,7 @@ void account_page_redirty(struct page *p
 
 		wb = unlocked_inode_to_wb_begin(inode, &locked);
 		current->nr_dirtied--;
-		dec_zone_page_state(page, NR_DIRTIED);
+		dec_node_page_state(page, NR_DIRTIED);
 		dec_wb_stat(wb, WB_DIRTIED);
 		unlocked_inode_to_wb_end(inode, locked);
 	}
@@ -2751,7 +2751,7 @@ int test_clear_page_writeback(struct pag
 	if (ret) {
 		mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_WRITEBACK);
 		dec_node_page_state(page, NR_WRITEBACK);
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
@@ -917,10 +917,6 @@ const char * const vmstat_text[] = {
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
@@ -957,6 +953,10 @@ const char * const vmstat_text[] = {
 	"nr_writeback_temp",
 	"nr_shmem",
 	"nr_unstable",
+	"nr_vmscan_write",
+	"nr_vmscan_immediate_reclaim",
+	"nr_dirtied",
+	"nr_written",
 
 	/* enum writeback_stat_item counters */
 	"nr_dirty_threshold",
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-slaub-add-__gfp_atomic-to-the-gfp-reclaim-mask.patch
mm-vmstat-add-infrastructure-for-per-node-vmstats.patch
mm-vmscan-move-lru_lock-to-the-node.patch
mm-vmscan-move-lru-lists-to-node.patch
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
mm-vmscan-update-classzone_idx-if-buffer_heads_over_limit.patch
mm-vmscan-only-wakeup-kswapd-once-per-node-for-the-requested-classzone.patch
mm-convert-zone_reclaim-to-node_reclaim.patch
mm-vmscan-add-classzone-information-to-tracepoints.patch
mm-page_alloc-remove-fair-zone-allocation-policy.patch
mm-page_alloc-cache-the-last-node-whose-dirty-limit-is-reached.patch
mm-vmstat-replace-__count_zone_vm_events-with-a-zone-id-equivalent.patch
mm-vmstat-account-per-zone-stalls-and-pages-skipped-during-reclaim.patch

