From: akpm@linux-foundation.org
Subject: [patch 037/101] mm: move vmscan writes and file write accounting
 to the node
Date: Thu, 28 Jul 2016 15:46:23 -0700
Message-ID: <579a8b3f.rAIqmkO0k/727Bwn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbcG1WqY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:46:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@suse.com, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz

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
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
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
