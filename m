From: akpm@linux-foundation.org
Subject: + mm-move-most-file-based-accounting-to-the-node.patch added to
 -mm tree
Date: Tue, 21 Jun 2016 15:49:48 -0700
Message-ID: <5769c48c.in/6RZdgEIySENd+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbcFUWuJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2016 18:50:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move most file-based accounting to the node
has been added to the -mm tree.  Its filename is
     mm-move-most-file-based-accounting-to-the-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-most-file-based-accounting-to-the-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-most-file-based-accounting-to-the-node.patch

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
Subject: mm: move most file-based accounting to the node

There are now a number of accounting oddities such as mapped file pages
being accounted for on the node while the total number of file pages are
accounted on the zone.  This can be coped with to some extent but it's
confusing so this patch moves the relevant file-based accounted.

Link: http://lkml.kernel.org/r/1466518566-30034-19-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/appldata/appldata_mem.c         |    2 
 arch/tile/mm/pgtable.c                    |    8 +--
 drivers/base/node.c                       |   10 ++--
 drivers/staging/android/lowmemorykiller.c |    4 -
 fs/fs-writeback.c                         |    4 -
 fs/fuse/file.c                            |    8 +--
 fs/nfs/internal.h                         |    2 
 fs/nfs/write.c                            |    2 
 fs/proc/meminfo.c                         |   10 ++--
 include/linux/mmzone.h                    |   12 ++---
 include/trace/events/writeback.h          |    6 +-
 mm/filemap.c                              |    6 +-
 mm/migrate.c                              |   12 ++---
 mm/page-writeback.c                       |   42 ++++++++------------
 mm/page_alloc.c                           |   24 ++++++++---
 mm/shmem.c                                |    8 +--
 mm/swap_state.c                           |    4 -
 mm/util.c                                 |    4 -
 mm/vmscan.c                               |   16 +++----
 mm/vmstat.c                               |   12 ++---
 20 files changed, 99 insertions(+), 97 deletions(-)

diff -puN arch/s390/appldata/appldata_mem.c~mm-move-most-file-based-accounting-to-the-node arch/s390/appldata/appldata_mem.c
--- a/arch/s390/appldata/appldata_mem.c~mm-move-most-file-based-accounting-to-the-node
+++ a/arch/s390/appldata/appldata_mem.c
@@ -102,7 +102,7 @@ static void appldata_get_mem_data(void *
 	mem_data->totalhigh = P2K(val.totalhigh);
 	mem_data->freehigh  = P2K(val.freehigh);
 	mem_data->bufferram = P2K(val.bufferram);
-	mem_data->cached    = P2K(global_page_state(NR_FILE_PAGES)
+	mem_data->cached    = P2K(global_node_page_state(NR_FILE_PAGES)
 				- val.bufferram);
 
 	si_swapinfo(&val);
diff -puN arch/tile/mm/pgtable.c~mm-move-most-file-based-accounting-to-the-node arch/tile/mm/pgtable.c
--- a/arch/tile/mm/pgtable.c~mm-move-most-file-based-accounting-to-the-node
+++ a/arch/tile/mm/pgtable.c
@@ -49,16 +49,16 @@ void show_mem(unsigned int filter)
 		global_node_page_state(NR_ACTIVE_FILE)),
 	       (global_node_page_state(NR_INACTIVE_ANON) +
 		global_node_page_state(NR_INACTIVE_FILE)),
-	       global_page_state(NR_FILE_DIRTY),
-	       global_page_state(NR_WRITEBACK),
-	       global_page_state(NR_UNSTABLE_NFS),
+	       global_node_page_state(NR_FILE_DIRTY),
+	       global_node_page_state(NR_WRITEBACK),
+	       global_node_page_state(NR_UNSTABLE_NFS),
 	       global_page_state(NR_FREE_PAGES),
 	       (global_page_state(NR_SLAB_RECLAIMABLE) +
 		global_page_state(NR_SLAB_UNRECLAIMABLE)),
 	       global_node_page_state(NR_FILE_MAPPED),
 	       global_page_state(NR_PAGETABLE),
 	       global_page_state(NR_BOUNCE),
-	       global_page_state(NR_FILE_PAGES),
+	       global_node_page_state(NR_FILE_PAGES),
 	       get_nr_swap_pages());
 
 	for_each_zone(zone) {
diff -puN drivers/base/node.c~mm-move-most-file-based-accounting-to-the-node drivers/base/node.c
--- a/drivers/base/node.c~mm-move-most-file-based-accounting-to-the-node
+++ a/drivers/base/node.c
@@ -118,18 +118,18 @@ static ssize_t node_read_meminfo(struct
 		       "Node %d ShmemPmdMapped: %8lu kB\n"
 #endif
 			,
-		       nid, K(sum_zone_node_page_state(nid, NR_FILE_DIRTY)),
-		       nid, K(sum_zone_node_page_state(nid, NR_WRITEBACK)),
-		       nid, K(sum_zone_node_page_state(nid, NR_FILE_PAGES)),
+		       nid, K(node_page_state(pgdat, NR_FILE_DIRTY)),
+		       nid, K(node_page_state(pgdat, NR_WRITEBACK)),
+		       nid, K(node_page_state(pgdat, NR_FILE_PAGES)),
 		       nid, K(node_page_state(pgdat, NR_FILE_MAPPED)),
 		       nid, K(node_page_state(pgdat, NR_ANON_MAPPED)),
 		       nid, K(i.sharedram),
 		       nid, node_page_state(nid, NR_KERNEL_STACK) *
 				THREAD_SIZE / 1024,
 		       nid, K(sum_zone_node_page_state(nid, NR_PAGETABLE)),
-		       nid, K(sum_zone_node_page_state(nid, NR_UNSTABLE_NFS)),
+		       nid, K(node_page_state(pgdat, NR_UNSTABLE_NFS)),
 		       nid, K(sum_zone_node_page_state(nid, NR_BOUNCE)),
-		       nid, K(sum_zone_node_page_state(nid, NR_WRITEBACK_TEMP)),
+		       nid, K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
 		       nid, K(sum_zone_node_page_state(nid, NR_SLAB_RECLAIMABLE) +
 				sum_zone_node_page_state(nid, NR_SLAB_UNRECLAIMABLE)),
 		       nid, K(sum_zone_node_page_state(nid, NR_SLAB_RECLAIMABLE)),
diff -puN drivers/staging/android/lowmemorykiller.c~mm-move-most-file-based-accounting-to-the-node drivers/staging/android/lowmemorykiller.c
--- a/drivers/staging/android/lowmemorykiller.c~mm-move-most-file-based-accounting-to-the-node
+++ a/drivers/staging/android/lowmemorykiller.c
@@ -91,8 +91,8 @@ static unsigned long lowmem_scan(struct
 	short selected_oom_score_adj;
 	int array_size = ARRAY_SIZE(lowmem_adj);
 	int other_free = global_page_state(NR_FREE_PAGES) - totalreserve_pages;
-	int other_file = global_page_state(NR_FILE_PAGES) -
-						global_page_state(NR_SHMEM) -
+	int other_file = global_node_page_state(NR_FILE_PAGES) -
+						global_node_page_state(NR_SHMEM) -
 						total_swapcache_pages();
 
 	if (lowmem_adj_size < array_size)
diff -puN fs/fs-writeback.c~mm-move-most-file-based-accounting-to-the-node fs/fs-writeback.c
--- a/fs/fs-writeback.c~mm-move-most-file-based-accounting-to-the-node
+++ a/fs/fs-writeback.c
@@ -1771,8 +1771,8 @@ static struct wb_writeback_work *get_nex
  */
 static unsigned long get_nr_dirty_pages(void)
 {
-	return global_page_state(NR_FILE_DIRTY) +
-		global_page_state(NR_UNSTABLE_NFS) +
+	return global_node_page_state(NR_FILE_DIRTY) +
+		global_node_page_state(NR_UNSTABLE_NFS) +
 		get_nr_dirty_inodes();
 }
 
diff -puN fs/fuse/file.c~mm-move-most-file-based-accounting-to-the-node fs/fuse/file.c
--- a/fs/fuse/file.c~mm-move-most-file-based-accounting-to-the-node
+++ a/fs/fuse/file.c
@@ -1452,7 +1452,7 @@ static void fuse_writepage_finish(struct
 	list_del(&req->writepages_entry);
 	for (i = 0; i < req->num_pages; i++) {
 		dec_wb_stat(&bdi->wb, WB_WRITEBACK);
-		dec_zone_page_state(req->pages[i], NR_WRITEBACK_TEMP);
+		dec_node_page_state(req->pages[i], NR_WRITEBACK_TEMP);
 		wb_writeout_inc(&bdi->wb);
 	}
 	wake_up(&fi->page_waitq);
@@ -1642,7 +1642,7 @@ static int fuse_writepage_locked(struct
 	req->inode = inode;
 
 	inc_wb_stat(&inode_to_bdi(inode)->wb, WB_WRITEBACK);
-	inc_zone_page_state(tmp_page, NR_WRITEBACK_TEMP);
+	inc_node_page_state(tmp_page, NR_WRITEBACK_TEMP);
 
 	spin_lock(&fc->lock);
 	list_add(&req->writepages_entry, &fi->writepages);
@@ -1756,7 +1756,7 @@ static bool fuse_writepage_in_flight(str
 		spin_unlock(&fc->lock);
 
 		dec_wb_stat(&bdi->wb, WB_WRITEBACK);
-		dec_zone_page_state(page, NR_WRITEBACK_TEMP);
+		dec_node_page_state(page, NR_WRITEBACK_TEMP);
 		wb_writeout_inc(&bdi->wb);
 		fuse_writepage_free(fc, new_req);
 		fuse_request_free(new_req);
@@ -1855,7 +1855,7 @@ static int fuse_writepages_fill(struct p
 	req->page_descs[req->num_pages].length = PAGE_SIZE;
 
 	inc_wb_stat(&inode_to_bdi(inode)->wb, WB_WRITEBACK);
-	inc_zone_page_state(tmp_page, NR_WRITEBACK_TEMP);
+	inc_node_page_state(tmp_page, NR_WRITEBACK_TEMP);
 
 	err = 0;
 	if (is_writeback && fuse_writepage_in_flight(req, page)) {
diff -puN fs/nfs/internal.h~mm-move-most-file-based-accounting-to-the-node fs/nfs/internal.h
--- a/fs/nfs/internal.h~mm-move-most-file-based-accounting-to-the-node
+++ a/fs/nfs/internal.h
@@ -623,7 +623,7 @@ void nfs_mark_page_unstable(struct page
 	if (!cinfo->dreq) {
 		struct inode *inode = page_file_mapping(page)->host;
 
-		inc_zone_page_state(page, NR_UNSTABLE_NFS);
+		inc_node_page_state(page, NR_UNSTABLE_NFS);
 		inc_wb_stat(&inode_to_bdi(inode)->wb, WB_RECLAIMABLE);
 		__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
 	}
diff -puN fs/nfs/write.c~mm-move-most-file-based-accounting-to-the-node fs/nfs/write.c
--- a/fs/nfs/write.c~mm-move-most-file-based-accounting-to-the-node
+++ a/fs/nfs/write.c
@@ -898,7 +898,7 @@ nfs_mark_request_commit(struct nfs_page
 static void
 nfs_clear_page_commit(struct page *page)
 {
-	dec_zone_page_state(page, NR_UNSTABLE_NFS);
+	dec_node_page_state(page, NR_UNSTABLE_NFS);
 	dec_wb_stat(&inode_to_bdi(page_file_mapping(page)->host)->wb,
 		    WB_RECLAIMABLE);
 }
diff -puN fs/proc/meminfo.c~mm-move-most-file-based-accounting-to-the-node fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~mm-move-most-file-based-accounting-to-the-node
+++ a/fs/proc/meminfo.c
@@ -40,7 +40,7 @@ static int meminfo_proc_show(struct seq_
 	si_swapinfo(&i);
 	committed = percpu_counter_read_positive(&vm_committed_as);
 
-	cached = global_page_state(NR_FILE_PAGES) -
+	cached = global_node_page_state(NR_FILE_PAGES) -
 			total_swapcache_pages() - i.bufferram;
 	if (cached < 0)
 		cached = 0;
@@ -138,8 +138,8 @@ static int meminfo_proc_show(struct seq_
 #endif
 		K(i.totalswap),
 		K(i.freeswap),
-		K(global_page_state(NR_FILE_DIRTY)),
-		K(global_page_state(NR_WRITEBACK)),
+		K(global_node_page_state(NR_FILE_DIRTY)),
+		K(global_node_page_state(NR_WRITEBACK)),
 		K(global_node_page_state(NR_ANON_MAPPED)),
 		K(global_node_page_state(NR_FILE_MAPPED)),
 		K(i.sharedram),
@@ -152,9 +152,9 @@ static int meminfo_proc_show(struct seq_
 #ifdef CONFIG_QUICKLIST
 		K(quicklist_total_size()),
 #endif
-		K(global_page_state(NR_UNSTABLE_NFS)),
+		K(global_node_page_state(NR_UNSTABLE_NFS)),
 		K(global_page_state(NR_BOUNCE)),
-		K(global_page_state(NR_WRITEBACK_TEMP)),
+		K(global_node_page_state(NR_WRITEBACK_TEMP)),
 		K(vm_commit_limit()),
 		K(committed),
 		(unsigned long)VMALLOC_TOTAL >> 10,
diff -puN include/linux/mmzone.h~mm-move-most-file-based-accounting-to-the-node include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-move-most-file-based-accounting-to-the-node
+++ a/include/linux/mmzone.h
@@ -115,20 +115,14 @@ enum zone_stat_item {
 	NR_ZONE_LRU_ANON = NR_ZONE_LRU_BASE,
 	NR_ZONE_LRU_FILE,
 	NR_MLOCK,		/* mlock()ed pages found and moved off LRU */
-	NR_FILE_PAGES,
-	NR_FILE_DIRTY,
-	NR_WRITEBACK,
 	NR_SLAB_RECLAIMABLE,
 	NR_SLAB_UNRECLAIMABLE,
 	NR_PAGETABLE,		/* used for pagetables */
 	NR_KERNEL_STACK,
 	/* Second 128 byte cacheline */
-	NR_UNSTABLE_NFS,	/* NFS unstable pages */
 	NR_BOUNCE,
 	NR_VMSCAN_WRITE,
 	NR_VMSCAN_IMMEDIATE,	/* Prioritise for reclaim when writeback ends */
-	NR_WRITEBACK_TEMP,	/* Writeback using temporary buffers */
-	NR_SHMEM,		/* shmem pages (included tmpfs/GEM pages) */
 	NR_DIRTIED,		/* page dirtyings since bootup */
 	NR_WRITTEN,		/* page writings since bootup */
 #if IS_ENABLED(CONFIG_ZSMALLOC)
@@ -164,6 +158,12 @@ enum node_stat_item {
 	NR_ANON_MAPPED,	/* Mapped anonymous pages */
 	NR_FILE_MAPPED,	/* pagecache pages mapped into pagetables.
 			   only modified from process context */
+	NR_FILE_PAGES,
+	NR_FILE_DIRTY,
+	NR_WRITEBACK,
+	NR_WRITEBACK_TEMP,	/* Writeback using temporary buffers */
+	NR_SHMEM,		/* shmem pages (included tmpfs/GEM pages) */
+	NR_UNSTABLE_NFS,	/* NFS unstable pages */
 	NR_VM_NODE_STAT_ITEMS
 };
 
diff -puN include/trace/events/writeback.h~mm-move-most-file-based-accounting-to-the-node include/trace/events/writeback.h
--- a/include/trace/events/writeback.h~mm-move-most-file-based-accounting-to-the-node
+++ a/include/trace/events/writeback.h
@@ -412,9 +412,9 @@ TRACE_EVENT(global_dirty_state,
 	),
 
 	TP_fast_assign(
-		__entry->nr_dirty	= global_page_state(NR_FILE_DIRTY);
-		__entry->nr_writeback	= global_page_state(NR_WRITEBACK);
-		__entry->nr_unstable	= global_page_state(NR_UNSTABLE_NFS);
+		__entry->nr_dirty	= global_node_page_state(NR_FILE_DIRTY);
+		__entry->nr_writeback	= global_node_page_state(NR_WRITEBACK);
+		__entry->nr_unstable	= global_node_page_state(NR_UNSTABLE_NFS);
 		__entry->nr_dirtied	= global_page_state(NR_DIRTIED);
 		__entry->nr_written	= global_page_state(NR_WRITTEN);
 		__entry->background_thresh = background_thresh;
diff -puN mm/filemap.c~mm-move-most-file-based-accounting-to-the-node mm/filemap.c
--- a/mm/filemap.c~mm-move-most-file-based-accounting-to-the-node
+++ a/mm/filemap.c
@@ -568,9 +568,9 @@ int replace_page_cache_page(struct page
 		 * hugetlb pages do not participate in page cache accounting.
 		 */
 		if (!PageHuge(new))
-			__inc_zone_page_state(new, NR_FILE_PAGES);
+			__inc_node_page_state(new, NR_FILE_PAGES);
 		if (PageSwapBacked(new))
-			__inc_zone_page_state(new, NR_SHMEM);
+			__inc_node_page_state(new, NR_SHMEM);
 		spin_unlock_irqrestore(&mapping->tree_lock, flags);
 		mem_cgroup_migrate(old, new);
 		radix_tree_preload_end();
@@ -677,7 +677,7 @@ static int __add_to_page_cache_locked(st
 
 	/* hugetlb pages do not participate in page cache accounting. */
 	if (!huge)
-		__inc_zone_page_state(page, NR_FILE_PAGES);
+		__inc_node_page_state(page, NR_FILE_PAGES);
 	spin_unlock_irq(&mapping->tree_lock);
 	if (!huge)
 		mem_cgroup_commit_charge(page, memcg, false, false);
diff -puN mm/migrate.c~mm-move-most-file-based-accounting-to-the-node mm/migrate.c
--- a/mm/migrate.c~mm-move-most-file-based-accounting-to-the-node
+++ a/mm/migrate.c
@@ -505,15 +505,15 @@ int migrate_page_move_mapping(struct add
 	 * are mapped to swap space.
 	 */
 	if (newzone != oldzone) {
-		__dec_zone_state(oldzone, NR_FILE_PAGES);
-		__inc_zone_state(newzone, NR_FILE_PAGES);
+		__dec_node_state(oldzone->zone_pgdat, NR_FILE_PAGES);
+		__inc_node_state(newzone->zone_pgdat, NR_FILE_PAGES);
 		if (PageSwapBacked(page) && !PageSwapCache(page)) {
-			__dec_zone_state(oldzone, NR_SHMEM);
-			__inc_zone_state(newzone, NR_SHMEM);
+			__dec_node_state(oldzone->zone_pgdat, NR_SHMEM);
+			__inc_node_state(newzone->zone_pgdat, NR_SHMEM);
 		}
 		if (dirty && mapping_cap_account_dirty(mapping)) {
-			__dec_zone_state(oldzone, NR_FILE_DIRTY);
-			__inc_zone_state(newzone, NR_FILE_DIRTY);
+			__dec_node_state(oldzone->zone_pgdat, NR_FILE_DIRTY);
+			__inc_node_state(newzone->zone_pgdat, NR_FILE_DIRTY);
 		}
 	}
 	local_irq_enable();
diff -puN mm/page-writeback.c~mm-move-most-file-based-accounting-to-the-node mm/page-writeback.c
--- a/mm/page-writeback.c~mm-move-most-file-based-accounting-to-the-node
+++ a/mm/page-writeback.c
@@ -471,20 +471,12 @@ static unsigned long node_dirty_limit(st
  */
 bool node_dirty_ok(struct pglist_data *pgdat)
 {
-	int z;
 	unsigned long limit = node_dirty_limit(pgdat);
 	unsigned long nr_pages = 0;
 
-	for (z = 0; z < MAX_NR_ZONES; z++) {
-		struct zone *zone = pgdat->node_zones + z;
-
-		if (!populated_zone(zone))
-			continue;
-
-		nr_pages += zone_page_state(zone, NR_FILE_DIRTY);
-		nr_pages += zone_page_state(zone, NR_UNSTABLE_NFS);
-		nr_pages += zone_page_state(zone, NR_WRITEBACK);
-	}
+	nr_pages += node_page_state(pgdat, NR_FILE_DIRTY);
+	nr_pages += node_page_state(pgdat, NR_UNSTABLE_NFS);
+	nr_pages += node_page_state(pgdat, NR_WRITEBACK);
 
 	return nr_pages <= limit;
 }
@@ -1574,10 +1566,10 @@ static void balance_dirty_pages(struct a
 		 * written to the server's write cache, but has not yet
 		 * been flushed to permanent storage.
 		 */
-		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
-					global_page_state(NR_UNSTABLE_NFS);
+		nr_reclaimable = global_node_page_state(NR_FILE_DIRTY) +
+					global_node_page_state(NR_UNSTABLE_NFS);
 		gdtc->avail = global_dirtyable_memory();
-		gdtc->dirty = nr_reclaimable + global_page_state(NR_WRITEBACK);
+		gdtc->dirty = nr_reclaimable + global_node_page_state(NR_WRITEBACK);
 
 		domain_dirty_limits(gdtc);
 
@@ -1914,8 +1906,8 @@ bool wb_over_bg_thresh(struct bdi_writeb
 	 * as we're trying to decide whether to put more under writeback.
 	 */
 	gdtc->avail = global_dirtyable_memory();
-	gdtc->dirty = global_page_state(NR_FILE_DIRTY) +
-		      global_page_state(NR_UNSTABLE_NFS);
+	gdtc->dirty = global_node_page_state(NR_FILE_DIRTY) +
+		      global_node_page_state(NR_UNSTABLE_NFS);
 	domain_dirty_limits(gdtc);
 
 	if (gdtc->dirty > gdtc->bg_thresh)
@@ -1959,8 +1951,8 @@ void throttle_vm_writeout(gfp_t gfp_mask
                  */
                 dirty_thresh += dirty_thresh / 10;      /* wheeee... */
 
-                if (global_page_state(NR_UNSTABLE_NFS) +
-			global_page_state(NR_WRITEBACK) <= dirty_thresh)
+                if (global_node_page_state(NR_UNSTABLE_NFS) +
+			global_node_page_state(NR_WRITEBACK) <= dirty_thresh)
                         	break;
                 congestion_wait(BLK_RW_ASYNC, HZ/10);
 
@@ -1988,8 +1980,8 @@ int dirty_writeback_centisecs_handler(st
 void laptop_mode_timer_fn(unsigned long data)
 {
 	struct request_queue *q = (struct request_queue *)data;
-	int nr_pages = global_page_state(NR_FILE_DIRTY) +
-		global_page_state(NR_UNSTABLE_NFS);
+	int nr_pages = global_node_page_state(NR_FILE_DIRTY) +
+		global_node_page_state(NR_UNSTABLE_NFS);
 	struct bdi_writeback *wb;
 
 	/*
@@ -2440,7 +2432,7 @@ void account_page_dirtied(struct page *p
 		wb = inode_to_wb(inode);
 
 		mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_DIRTY);
-		__inc_zone_page_state(page, NR_FILE_DIRTY);
+		__inc_node_page_state(page, NR_FILE_DIRTY);
 		__inc_zone_page_state(page, NR_DIRTIED);
 		__inc_wb_stat(wb, WB_RECLAIMABLE);
 		__inc_wb_stat(wb, WB_DIRTIED);
@@ -2461,7 +2453,7 @@ void account_page_cleaned(struct page *p
 {
 	if (mapping_cap_account_dirty(mapping)) {
 		mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_DIRTY);
-		dec_zone_page_state(page, NR_FILE_DIRTY);
+		dec_node_page_state(page, NR_FILE_DIRTY);
 		dec_wb_stat(wb, WB_RECLAIMABLE);
 		task_io_account_cancelled_write(PAGE_SIZE);
 	}
@@ -2717,7 +2709,7 @@ int clear_page_dirty_for_io(struct page
 		wb = unlocked_inode_to_wb_begin(inode, &locked);
 		if (TestClearPageDirty(page)) {
 			mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_DIRTY);
-			dec_zone_page_state(page, NR_FILE_DIRTY);
+			dec_node_page_state(page, NR_FILE_DIRTY);
 			dec_wb_stat(wb, WB_RECLAIMABLE);
 			ret = 1;
 		}
@@ -2758,7 +2750,7 @@ int test_clear_page_writeback(struct pag
 	}
 	if (ret) {
 		mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_WRITEBACK);
-		dec_zone_page_state(page, NR_WRITEBACK);
+		dec_node_page_state(page, NR_WRITEBACK);
 		inc_zone_page_state(page, NR_WRITTEN);
 	}
 	unlock_page_memcg(page);
@@ -2799,7 +2791,7 @@ int __test_set_page_writeback(struct pag
 	}
 	if (!ret) {
 		mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_WRITEBACK);
-		inc_zone_page_state(page, NR_WRITEBACK);
+		inc_node_page_state(page, NR_WRITEBACK);
 	}
 	unlock_page_memcg(page);
 	return ret;
diff -puN mm/page_alloc.c~mm-move-most-file-based-accounting-to-the-node mm/page_alloc.c
--- a/mm/page_alloc.c~mm-move-most-file-based-accounting-to-the-node
+++ a/mm/page_alloc.c
@@ -4182,7 +4182,7 @@ EXPORT_SYMBOL_GPL(si_mem_available);
 void si_meminfo(struct sysinfo *val)
 {
 	val->totalram = totalram_pages;
-	val->sharedram = global_page_state(NR_SHMEM);
+	val->sharedram = global_node_page_state(NR_SHMEM);
 	val->freeram = global_page_state(NR_FREE_PAGES);
 	val->bufferram = nr_blockdev_pages();
 	val->totalhigh = totalhigh_pages;
@@ -4204,7 +4204,7 @@ void si_meminfo_node(struct sysinfo *val
 	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++)
 		managed_pages += pgdat->node_zones[zone_type].managed_pages;
 	val->totalram = managed_pages;
-	val->sharedram = sum_zone_node_page_state(nid, NR_SHMEM);
+	val->sharedram = node_page_state(pgdat, NR_SHMEM);
 	val->freeram = sum_zone_node_page_state(nid, NR_FREE_PAGES);
 #ifdef CONFIG_HIGHMEM
 	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
@@ -4314,13 +4314,13 @@ void show_free_areas(unsigned int filter
 		global_node_page_state(NR_INACTIVE_FILE),
 		global_node_page_state(NR_ISOLATED_FILE),
 		global_node_page_state(NR_UNEVICTABLE),
-		global_page_state(NR_FILE_DIRTY),
-		global_page_state(NR_WRITEBACK),
-		global_page_state(NR_UNSTABLE_NFS),
+		global_node_page_state(NR_FILE_DIRTY),
+		global_node_page_state(NR_WRITEBACK),
+		global_node_page_state(NR_UNSTABLE_NFS),
 		global_page_state(NR_SLAB_RECLAIMABLE),
 		global_page_state(NR_SLAB_UNRECLAIMABLE),
 		global_node_page_state(NR_FILE_MAPPED),
-		global_page_state(NR_SHMEM),
+		global_node_page_state(NR_SHMEM),
 		global_page_state(NR_PAGETABLE),
 		global_page_state(NR_BOUNCE),
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -4342,6 +4342,11 @@ void show_free_areas(unsigned int filter
 			" isolated(anon):%lukB"
 			" isolated(file):%lukB"
 			" mapped:%lukB"
+			" dirty:%lukB"
+			" writeback:%lukB"
+			" shmem:%lukB"
+			" writeback_tmp:%lukB"
+			" unstable:%lukB"
 			" all_unreclaimable? %s"
 			"\n",
 			pgdat->node_id,
@@ -4353,6 +4358,11 @@ void show_free_areas(unsigned int filter
 			K(node_page_state(pgdat, NR_ISOLATED_ANON)),
 			K(node_page_state(pgdat, NR_ISOLATED_FILE)),
 			K(node_page_state(pgdat, NR_FILE_MAPPED)),
+			K(node_page_state(pgdat, NR_FILE_DIRTY)),
+			K(node_page_state(pgdat, NR_WRITEBACK)),
+			K(node_page_state(pgdat, NR_SHMEM)),
+			K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
+			K(node_page_state(pgdat, NR_UNSTABLE_NFS)),
 			!pgdat_reclaimable(pgdat) ? "yes" : "no");
 	}
 
@@ -4465,7 +4475,7 @@ void show_free_areas(unsigned int filter
 
 	hugetlb_show_meminfo();
 
-	printk("%ld total pagecache pages\n", global_page_state(NR_FILE_PAGES));
+	printk("%ld total pagecache pages\n", global_node_page_state(NR_FILE_PAGES));
 
 	show_swap_cache_info();
 }
diff -puN mm/shmem.c~mm-move-most-file-based-accounting-to-the-node mm/shmem.c
--- a/mm/shmem.c~mm-move-most-file-based-accounting-to-the-node
+++ a/mm/shmem.c
@@ -601,8 +601,8 @@ static void shmem_delete_from_page_cache
 	error = shmem_radix_tree_replace(mapping, page->index, page, radswap);
 	page->mapping = NULL;
 	mapping->nrpages--;
-	__dec_zone_page_state(page, NR_FILE_PAGES);
-	__dec_zone_page_state(page, NR_SHMEM);
+	__dec_node_page_state(page, NR_FILE_PAGES);
+	__dec_node_page_state(page, NR_SHMEM);
 	spin_unlock_irq(&mapping->tree_lock);
 	put_page(page);
 	BUG_ON(error);
@@ -1493,8 +1493,8 @@ static int shmem_replace_page(struct pag
 	error = shmem_radix_tree_replace(swap_mapping, swap_index, oldpage,
 								   newpage);
 	if (!error) {
-		__inc_zone_page_state(newpage, NR_FILE_PAGES);
-		__dec_zone_page_state(oldpage, NR_FILE_PAGES);
+		__inc_node_page_state(newpage, NR_FILE_PAGES);
+		__dec_node_page_state(oldpage, NR_FILE_PAGES);
 	}
 	spin_unlock_irq(&swap_mapping->tree_lock);
 
diff -puN mm/swap_state.c~mm-move-most-file-based-accounting-to-the-node mm/swap_state.c
--- a/mm/swap_state.c~mm-move-most-file-based-accounting-to-the-node
+++ a/mm/swap_state.c
@@ -95,7 +95,7 @@ int __add_to_swap_cache(struct page *pag
 					entry.val, page);
 	if (likely(!error)) {
 		address_space->nrpages++;
-		__inc_zone_page_state(page, NR_FILE_PAGES);
+		__inc_node_page_state(page, NR_FILE_PAGES);
 		INC_CACHE_INFO(add_total);
 	}
 	spin_unlock_irq(&address_space->tree_lock);
@@ -147,7 +147,7 @@ void __delete_from_swap_cache(struct pag
 	set_page_private(page, 0);
 	ClearPageSwapCache(page);
 	address_space->nrpages--;
-	__dec_zone_page_state(page, NR_FILE_PAGES);
+	__dec_node_page_state(page, NR_FILE_PAGES);
 	INC_CACHE_INFO(del_total);
 }
 
diff -puN mm/util.c~mm-move-most-file-based-accounting-to-the-node mm/util.c
--- a/mm/util.c~mm-move-most-file-based-accounting-to-the-node
+++ a/mm/util.c
@@ -528,7 +528,7 @@ int __vm_enough_memory(struct mm_struct
 
 	if (sysctl_overcommit_memory == OVERCOMMIT_GUESS) {
 		free = global_page_state(NR_FREE_PAGES);
-		free += global_page_state(NR_FILE_PAGES);
+		free += global_node_page_state(NR_FILE_PAGES);
 
 		/*
 		 * shmem pages shouldn't be counted as free in this
@@ -536,7 +536,7 @@ int __vm_enough_memory(struct mm_struct
 		 * that won't affect the overall amount of available
 		 * memory in the system.
 		 */
-		free -= global_page_state(NR_SHMEM);
+		free -= global_node_page_state(NR_SHMEM);
 
 		free += get_nr_swap_pages();
 
diff -puN mm/vmscan.c~mm-move-most-file-based-accounting-to-the-node mm/vmscan.c
--- a/mm/vmscan.c~mm-move-most-file-based-accounting-to-the-node
+++ a/mm/vmscan.c
@@ -3600,11 +3600,11 @@ int sysctl_min_unmapped_ratio = 1;
  */
 int sysctl_min_slab_ratio = 5;
 
-static inline unsigned long zone_unmapped_file_pages(struct zone *zone)
+static inline unsigned long node_unmapped_file_pages(struct pglist_data *pgdat)
 {
-	unsigned long file_mapped = node_page_state(zone->zone_pgdat, NR_FILE_MAPPED);
-	unsigned long file_lru = node_page_state(zone->zone_pgdat, NR_INACTIVE_FILE) +
-		node_page_state(zone->zone_pgdat, NR_ACTIVE_FILE);
+	unsigned long file_mapped = node_page_state(pgdat, NR_FILE_MAPPED);
+	unsigned long file_lru = node_page_state(pgdat, NR_INACTIVE_FILE) +
+		node_page_state(pgdat, NR_ACTIVE_FILE);
 
 	/*
 	 * It's possible for there to be more file mapped pages than
@@ -3623,17 +3623,17 @@ static unsigned long zone_pagecache_recl
 	/*
 	 * If RECLAIM_UNMAP is set, then all file pages are considered
 	 * potentially reclaimable. Otherwise, we have to worry about
-	 * pages like swapcache and zone_unmapped_file_pages() provides
+	 * pages like swapcache and node_unmapped_file_pages() provides
 	 * a better estimate
 	 */
 	if (zone_reclaim_mode & RECLAIM_UNMAP)
-		nr_pagecache_reclaimable = zone_page_state(zone, NR_FILE_PAGES);
+		nr_pagecache_reclaimable = node_page_state(zone->zone_pgdat, NR_FILE_PAGES);
 	else
-		nr_pagecache_reclaimable = zone_unmapped_file_pages(zone);
+		nr_pagecache_reclaimable = node_unmapped_file_pages(zone->zone_pgdat);
 
 	/* If we can't clean pages, remove dirty pages from consideration */
 	if (!(zone_reclaim_mode & RECLAIM_WRITE))
-		delta += zone_page_state(zone, NR_FILE_DIRTY);
+		delta += node_page_state(zone->zone_pgdat, NR_FILE_DIRTY);
 
 	/* Watch for any possible underflows due to delta */
 	if (unlikely(delta > nr_pagecache_reclaimable))
diff -puN mm/vmstat.c~mm-move-most-file-based-accounting-to-the-node mm/vmstat.c
--- a/mm/vmstat.c~mm-move-most-file-based-accounting-to-the-node
+++ a/mm/vmstat.c
@@ -912,19 +912,13 @@ const char * const vmstat_text[] = {
 	"nr_zone_anon_lru",
 	"nr_zone_file_lru",
 	"nr_mlock",
-	"nr_file_pages",
-	"nr_dirty",
-	"nr_writeback",
 	"nr_slab_reclaimable",
 	"nr_slab_unreclaimable",
 	"nr_page_table_pages",
 	"nr_kernel_stack",
-	"nr_unstable",
 	"nr_bounce",
 	"nr_vmscan_write",
 	"nr_vmscan_immediate_reclaim",
-	"nr_writeback_temp",
-	"nr_shmem",
 	"nr_dirtied",
 	"nr_written",
 #if IS_ENABLED(CONFIG_ZSMALLOC)
@@ -957,6 +951,12 @@ const char * const vmstat_text[] = {
 	"workingset_nodereclaim",
 	"nr_anon_pages",
 	"nr_mapped",
+	"nr_file_pages",
+	"nr_dirty",
+	"nr_writeback",
+	"nr_writeback_temp",
+	"nr_shmem",
+	"nr_unstable",
 
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

