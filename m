From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-move-lru_lock-to-the-node.patch removed from
 -mm tree
Date: Fri, 29 Jul 2016 11:54:28 -0700
Message-ID: <579ba664.H5wDbwoHxWcG3cfT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37078 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbcG2Sy3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:54:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: move lru_lock to the node
has been removed from the -mm tree.  Its filename was
     mm-vmscan-move-lru_lock-to-the-node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, vmscan: move lru_lock to the node

Node-based reclaim requires node-based LRUs and locking.  This is a
preparation patch that just moves the lru_lock to the node so later
patches are easier to review.  It is a mechanical change but note this
patch makes contention worse because the LRU lock is hotter and direct
reclaim and kswapd can contend on the same lock even when reclaiming from
different zones.

Link: http://lkml.kernel.org/r/1467970510-21195-3-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroup-v1/memcg_test.txt |    4 -
 Documentation/cgroup-v1/memory.txt     |    4 -
 include/linux/mm_types.h               |    2 
 include/linux/mmzone.h                 |   10 +++-
 mm/compaction.c                        |   10 ++--
 mm/filemap.c                           |    4 -
 mm/huge_memory.c                       |    6 +-
 mm/memcontrol.c                        |    6 +-
 mm/mlock.c                             |   10 ++--
 mm/page_alloc.c                        |    4 -
 mm/page_idle.c                         |    4 -
 mm/rmap.c                              |    2 
 mm/swap.c                              |   30 +++++++-------
 mm/vmscan.c                            |   48 +++++++++++------------
 14 files changed, 75 insertions(+), 69 deletions(-)

diff -puN Documentation/cgroup-v1/memcg_test.txt~mm-vmscan-move-lru_lock-to-the-node Documentation/cgroup-v1/memcg_test.txt
--- a/Documentation/cgroup-v1/memcg_test.txt~mm-vmscan-move-lru_lock-to-the-node
+++ a/Documentation/cgroup-v1/memcg_test.txt
@@ -107,9 +107,9 @@ Under below explanation, we assume CONFI
 
 8. LRU
         Each memcg has its own private LRU. Now, its handling is under global
-	VM's control (means that it's handled under global zone->lru_lock).
+	VM's control (means that it's handled under global zone_lru_lock).
 	Almost all routines around memcg's LRU is called by global LRU's
-	list management functions under zone->lru_lock().
+	list management functions under zone_lru_lock().
 
 	A special function is mem_cgroup_isolate_pages(). This scans
 	memcg's private LRU and call __isolate_lru_page() to extract a page
diff -puN Documentation/cgroup-v1/memory.txt~mm-vmscan-move-lru_lock-to-the-node Documentation/cgroup-v1/memory.txt
--- a/Documentation/cgroup-v1/memory.txt~mm-vmscan-move-lru_lock-to-the-node
+++ a/Documentation/cgroup-v1/memory.txt
@@ -267,11 +267,11 @@ When oom event notifier is registered, e
    Other lock order is following:
    PG_locked.
    mm->page_table_lock
-       zone->lru_lock
+       zone_lru_lock
 	  lock_page_cgroup.
   In many cases, just lock_page_cgroup() is called.
   per-zone-per-cgroup LRU (cgroup's private LRU) is just guarded by
-  zone->lru_lock, it has no lock of its own.
+  zone_lru_lock, it has no lock of its own.
 
 2.7 Kernel Memory Extension (CONFIG_MEMCG_KMEM)
 
diff -puN include/linux/mm_types.h~mm-vmscan-move-lru_lock-to-the-node include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-vmscan-move-lru_lock-to-the-node
+++ a/include/linux/mm_types.h
@@ -118,7 +118,7 @@ struct page {
 	 */
 	union {
 		struct list_head lru;	/* Pageout list, eg. active_list
-					 * protected by zone->lru_lock !
+					 * protected by zone_lru_lock !
 					 * Can be used as a generic list
 					 * by the page owner.
 					 */
diff -puN include/linux/mmzone.h~mm-vmscan-move-lru_lock-to-the-node include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-vmscan-move-lru_lock-to-the-node
+++ a/include/linux/mmzone.h
@@ -93,7 +93,7 @@ struct free_area {
 struct pglist_data;
 
 /*
- * zone->lock and zone->lru_lock are two of the hottest locks in the kernel.
+ * zone->lock and the zone lru_lock are two of the hottest locks in the kernel.
  * So add a wild amount of padding here to ensure that they fall into separate
  * cachelines.  There are very few zone structures in the machine, so space
  * consumption is not a concern here.
@@ -496,7 +496,6 @@ struct zone {
 	/* Write-intensive fields used by page reclaim */
 
 	/* Fields commonly accessed by the page reclaim scanner */
-	spinlock_t		lru_lock;
 	struct lruvec		lruvec;
 
 	/*
@@ -690,6 +689,9 @@ typedef struct pglist_data {
 	/* Number of pages migrated during the rate limiting time interval */
 	unsigned long numabalancing_migrate_nr_pages;
 #endif
+	/* Write-intensive fields used by page reclaim */
+	ZONE_PADDING(_pad1_)
+	spinlock_t		lru_lock;
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 	/*
@@ -721,6 +723,10 @@ typedef struct pglist_data {
 
 #define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
 #define node_end_pfn(nid) pgdat_end_pfn(NODE_DATA(nid))
+static inline spinlock_t *zone_lru_lock(struct zone *zone)
+{
+	return &zone->zone_pgdat->lru_lock;
+}
 
 static inline unsigned long pgdat_end_pfn(pg_data_t *pgdat)
 {
diff -puN mm/compaction.c~mm-vmscan-move-lru_lock-to-the-node mm/compaction.c
--- a/mm/compaction.c~mm-vmscan-move-lru_lock-to-the-node
+++ a/mm/compaction.c
@@ -752,7 +752,7 @@ isolate_migratepages_block(struct compac
 		 * if contended.
 		 */
 		if (!(low_pfn % SWAP_CLUSTER_MAX)
-		    && compact_unlock_should_abort(&zone->lru_lock, flags,
+		    && compact_unlock_should_abort(zone_lru_lock(zone), flags,
 								&locked, cc))
 			break;
 
@@ -813,7 +813,7 @@ isolate_migratepages_block(struct compac
 			if (unlikely(__PageMovable(page)) &&
 					!PageIsolated(page)) {
 				if (locked) {
-					spin_unlock_irqrestore(&zone->lru_lock,
+					spin_unlock_irqrestore(zone_lru_lock(zone),
 									flags);
 					locked = false;
 				}
@@ -836,7 +836,7 @@ isolate_migratepages_block(struct compac
 
 		/* If we already hold the lock, we can skip some rechecking */
 		if (!locked) {
-			locked = compact_trylock_irqsave(&zone->lru_lock,
+			locked = compact_trylock_irqsave(zone_lru_lock(zone),
 								&flags, cc);
 			if (!locked)
 				break;
@@ -899,7 +899,7 @@ isolate_fail:
 		 */
 		if (nr_isolated) {
 			if (locked) {
-				spin_unlock_irqrestore(&zone->lru_lock,	flags);
+				spin_unlock_irqrestore(zone_lru_lock(zone), flags);
 				locked = false;
 			}
 			acct_isolated(zone, cc);
@@ -927,7 +927,7 @@ isolate_fail:
 		low_pfn = end_pfn;
 
 	if (locked)
-		spin_unlock_irqrestore(&zone->lru_lock, flags);
+		spin_unlock_irqrestore(zone_lru_lock(zone), flags);
 
 	/*
 	 * Update the pageblock-skip information and cached scanner pfn,
diff -puN mm/filemap.c~mm-vmscan-move-lru_lock-to-the-node mm/filemap.c
--- a/mm/filemap.c~mm-vmscan-move-lru_lock-to-the-node
+++ a/mm/filemap.c
@@ -95,8 +95,8 @@
  *    ->swap_lock		(try_to_unmap_one)
  *    ->private_lock		(try_to_unmap_one)
  *    ->tree_lock		(try_to_unmap_one)
- *    ->zone.lru_lock		(follow_page->mark_page_accessed)
- *    ->zone.lru_lock		(check_pte_range->isolate_lru_page)
+ *    ->zone_lru_lock(zone)	(follow_page->mark_page_accessed)
+ *    ->zone_lru_lock(zone)	(check_pte_range->isolate_lru_page)
  *    ->private_lock		(page_remove_rmap->set_page_dirty)
  *    ->tree_lock		(page_remove_rmap->set_page_dirty)
  *    bdi.wb->list_lock		(page_remove_rmap->set_page_dirty)
diff -puN mm/huge_memory.c~mm-vmscan-move-lru_lock-to-the-node mm/huge_memory.c
--- a/mm/huge_memory.c~mm-vmscan-move-lru_lock-to-the-node
+++ a/mm/huge_memory.c
@@ -1848,7 +1848,7 @@ static void __split_huge_page(struct pag
 		spin_unlock(&head->mapping->tree_lock);
 	}
 
-	spin_unlock_irqrestore(&page_zone(head)->lru_lock, flags);
+	spin_unlock_irqrestore(zone_lru_lock(page_zone(head)), flags);
 
 	unfreeze_page(head);
 
@@ -2034,7 +2034,7 @@ int split_huge_page_to_list(struct page
 		lru_add_drain();
 
 	/* prevent PageLRU to go away from under us, and freeze lru stats */
-	spin_lock_irqsave(&page_zone(head)->lru_lock, flags);
+	spin_lock_irqsave(zone_lru_lock(page_zone(head)), flags);
 
 	if (mapping) {
 		void **pslot;
@@ -2077,7 +2077,7 @@ int split_huge_page_to_list(struct page
 		spin_unlock(&pgdata->split_queue_lock);
 fail:		if (mapping)
 			spin_unlock(&mapping->tree_lock);
-		spin_unlock_irqrestore(&page_zone(head)->lru_lock, flags);
+		spin_unlock_irqrestore(zone_lru_lock(page_zone(head)), flags);
 		unfreeze_page(head);
 		ret = -EBUSY;
 	}
diff -puN mm/memcontrol.c~mm-vmscan-move-lru_lock-to-the-node mm/memcontrol.c
--- a/mm/memcontrol.c~mm-vmscan-move-lru_lock-to-the-node
+++ a/mm/memcontrol.c
@@ -2065,7 +2065,7 @@ static void lock_page_lru(struct page *p
 {
 	struct zone *zone = page_zone(page);
 
-	spin_lock_irq(&zone->lru_lock);
+	spin_lock_irq(zone_lru_lock(zone));
 	if (PageLRU(page)) {
 		struct lruvec *lruvec;
 
@@ -2089,7 +2089,7 @@ static void unlock_page_lru(struct page
 		SetPageLRU(page);
 		add_page_to_lru_list(page, lruvec, page_lru(page));
 	}
-	spin_unlock_irq(&zone->lru_lock);
+	spin_unlock_irq(zone_lru_lock(zone));
 }
 
 static void commit_charge(struct page *page, struct mem_cgroup *memcg,
@@ -2389,7 +2389,7 @@ void memcg_kmem_uncharge(struct page *pa
 
 /*
  * Because tail pages are not marked as "used", set it. We're under
- * zone->lru_lock and migration entries setup in all page mappings.
+ * zone_lru_lock and migration entries setup in all page mappings.
  */
 void mem_cgroup_split_huge_fixup(struct page *head)
 {
diff -puN mm/mlock.c~mm-vmscan-move-lru_lock-to-the-node mm/mlock.c
--- a/mm/mlock.c~mm-vmscan-move-lru_lock-to-the-node
+++ a/mm/mlock.c
@@ -188,7 +188,7 @@ unsigned int munlock_vma_page(struct pag
 	 * might otherwise copy PageMlocked to part of the tail pages before
 	 * we clear it in the head page. It also stabilizes hpage_nr_pages().
 	 */
-	spin_lock_irq(&zone->lru_lock);
+	spin_lock_irq(zone_lru_lock(zone));
 
 	nr_pages = hpage_nr_pages(page);
 	if (!TestClearPageMlocked(page))
@@ -197,14 +197,14 @@ unsigned int munlock_vma_page(struct pag
 	__mod_zone_page_state(zone, NR_MLOCK, -nr_pages);
 
 	if (__munlock_isolate_lru_page(page, true)) {
-		spin_unlock_irq(&zone->lru_lock);
+		spin_unlock_irq(zone_lru_lock(zone));
 		__munlock_isolated_page(page);
 		goto out;
 	}
 	__munlock_isolation_failed(page);
 
 unlock_out:
-	spin_unlock_irq(&zone->lru_lock);
+	spin_unlock_irq(zone_lru_lock(zone));
 
 out:
 	return nr_pages - 1;
@@ -289,7 +289,7 @@ static void __munlock_pagevec(struct pag
 	pagevec_init(&pvec_putback, 0);
 
 	/* Phase 1: page isolation */
-	spin_lock_irq(&zone->lru_lock);
+	spin_lock_irq(zone_lru_lock(zone));
 	for (i = 0; i < nr; i++) {
 		struct page *page = pvec->pages[i];
 
@@ -315,7 +315,7 @@ static void __munlock_pagevec(struct pag
 	}
 	delta_munlocked = -nr + pagevec_count(&pvec_putback);
 	__mod_zone_page_state(zone, NR_MLOCK, delta_munlocked);
-	spin_unlock_irq(&zone->lru_lock);
+	spin_unlock_irq(zone_lru_lock(zone));
 
 	/* Now we can release pins of pages that we are not munlocking */
 	pagevec_release(&pvec_putback);
diff -puN mm/page_alloc.c~mm-vmscan-move-lru_lock-to-the-node mm/page_alloc.c
--- a/mm/page_alloc.c~mm-vmscan-move-lru_lock-to-the-node
+++ a/mm/page_alloc.c
@@ -5904,6 +5904,7 @@ static void __paginginit free_area_init_
 	init_waitqueue_head(&pgdat->kcompactd_wait);
 #endif
 	pgdat_page_ext_init(pgdat);
+	spin_lock_init(&pgdat->lru_lock);
 
 	for (j = 0; j < MAX_NR_ZONES; j++) {
 		struct zone *zone = pgdat->node_zones + j;
@@ -5958,10 +5959,9 @@ static void __paginginit free_area_init_
 		zone->min_slab_pages = (freesize * sysctl_min_slab_ratio) / 100;
 #endif
 		zone->name = zone_names[j];
+		zone->zone_pgdat = pgdat;
 		spin_lock_init(&zone->lock);
-		spin_lock_init(&zone->lru_lock);
 		zone_seqlock_init(zone);
-		zone->zone_pgdat = pgdat;
 		zone_pcp_init(zone);
 
 		/* For bootup, initialized properly in watermark setup */
diff -puN mm/page_idle.c~mm-vmscan-move-lru_lock-to-the-node mm/page_idle.c
--- a/mm/page_idle.c~mm-vmscan-move-lru_lock-to-the-node
+++ a/mm/page_idle.c
@@ -41,12 +41,12 @@ static struct page *page_idle_get_page(u
 		return NULL;
 
 	zone = page_zone(page);
-	spin_lock_irq(&zone->lru_lock);
+	spin_lock_irq(zone_lru_lock(zone));
 	if (unlikely(!PageLRU(page))) {
 		put_page(page);
 		page = NULL;
 	}
-	spin_unlock_irq(&zone->lru_lock);
+	spin_unlock_irq(zone_lru_lock(zone));
 	return page;
 }
 
diff -puN mm/rmap.c~mm-vmscan-move-lru_lock-to-the-node mm/rmap.c
--- a/mm/rmap.c~mm-vmscan-move-lru_lock-to-the-node
+++ a/mm/rmap.c
@@ -27,7 +27,7 @@
  *         mapping->i_mmap_rwsem
  *           anon_vma->rwsem
  *             mm->page_table_lock or pte_lock
- *               zone->lru_lock (in mark_page_accessed, isolate_lru_page)
+ *               zone_lru_lock (in mark_page_accessed, isolate_lru_page)
  *               swap_lock (in swap_duplicate, swap_info_get)
  *                 mmlist_lock (in mmput, drain_mmlist and others)
  *                 mapping->private_lock (in __set_page_dirty_buffers)
diff -puN mm/swap.c~mm-vmscan-move-lru_lock-to-the-node mm/swap.c
--- a/mm/swap.c~mm-vmscan-move-lru_lock-to-the-node
+++ a/mm/swap.c
@@ -62,12 +62,12 @@ static void __page_cache_release(struct
 		struct lruvec *lruvec;
 		unsigned long flags;
 
-		spin_lock_irqsave(&zone->lru_lock, flags);
+		spin_lock_irqsave(zone_lru_lock(zone), flags);
 		lruvec = mem_cgroup_page_lruvec(page, zone);
 		VM_BUG_ON_PAGE(!PageLRU(page), page);
 		__ClearPageLRU(page);
 		del_page_from_lru_list(page, lruvec, page_off_lru(page));
-		spin_unlock_irqrestore(&zone->lru_lock, flags);
+		spin_unlock_irqrestore(zone_lru_lock(zone), flags);
 	}
 	mem_cgroup_uncharge(page);
 }
@@ -189,16 +189,16 @@ static void pagevec_lru_move_fn(struct p
 
 		if (pagezone != zone) {
 			if (zone)
-				spin_unlock_irqrestore(&zone->lru_lock, flags);
+				spin_unlock_irqrestore(zone_lru_lock(zone), flags);
 			zone = pagezone;
-			spin_lock_irqsave(&zone->lru_lock, flags);
+			spin_lock_irqsave(zone_lru_lock(zone), flags);
 		}
 
 		lruvec = mem_cgroup_page_lruvec(page, zone);
 		(*move_fn)(page, lruvec, arg);
 	}
 	if (zone)
-		spin_unlock_irqrestore(&zone->lru_lock, flags);
+		spin_unlock_irqrestore(zone_lru_lock(zone), flags);
 	release_pages(pvec->pages, pvec->nr, pvec->cold);
 	pagevec_reinit(pvec);
 }
@@ -318,9 +318,9 @@ void activate_page(struct page *page)
 	struct zone *zone = page_zone(page);
 
 	page = compound_head(page);
-	spin_lock_irq(&zone->lru_lock);
+	spin_lock_irq(zone_lru_lock(zone));
 	__activate_page(page, mem_cgroup_page_lruvec(page, zone), NULL);
-	spin_unlock_irq(&zone->lru_lock);
+	spin_unlock_irq(zone_lru_lock(zone));
 }
 #endif
 
@@ -448,13 +448,13 @@ void add_page_to_unevictable_list(struct
 	struct zone *zone = page_zone(page);
 	struct lruvec *lruvec;
 
-	spin_lock_irq(&zone->lru_lock);
+	spin_lock_irq(zone_lru_lock(zone));
 	lruvec = mem_cgroup_page_lruvec(page, zone);
 	ClearPageActive(page);
 	SetPageUnevictable(page);
 	SetPageLRU(page);
 	add_page_to_lru_list(page, lruvec, LRU_UNEVICTABLE);
-	spin_unlock_irq(&zone->lru_lock);
+	spin_unlock_irq(zone_lru_lock(zone));
 }
 
 /**
@@ -744,7 +744,7 @@ void release_pages(struct page **pages,
 		 * same zone. The lock is held only if zone != NULL.
 		 */
 		if (zone && ++lock_batch == SWAP_CLUSTER_MAX) {
-			spin_unlock_irqrestore(&zone->lru_lock, flags);
+			spin_unlock_irqrestore(zone_lru_lock(zone), flags);
 			zone = NULL;
 		}
 
@@ -759,7 +759,7 @@ void release_pages(struct page **pages,
 
 		if (PageCompound(page)) {
 			if (zone) {
-				spin_unlock_irqrestore(&zone->lru_lock, flags);
+				spin_unlock_irqrestore(zone_lru_lock(zone), flags);
 				zone = NULL;
 			}
 			__put_compound_page(page);
@@ -771,11 +771,11 @@ void release_pages(struct page **pages,
 
 			if (pagezone != zone) {
 				if (zone)
-					spin_unlock_irqrestore(&zone->lru_lock,
+					spin_unlock_irqrestore(zone_lru_lock(zone),
 									flags);
 				lock_batch = 0;
 				zone = pagezone;
-				spin_lock_irqsave(&zone->lru_lock, flags);
+				spin_lock_irqsave(zone_lru_lock(zone), flags);
 			}
 
 			lruvec = mem_cgroup_page_lruvec(page, zone);
@@ -790,7 +790,7 @@ void release_pages(struct page **pages,
 		list_add(&page->lru, &pages_to_free);
 	}
 	if (zone)
-		spin_unlock_irqrestore(&zone->lru_lock, flags);
+		spin_unlock_irqrestore(zone_lru_lock(zone), flags);
 
 	mem_cgroup_uncharge_list(&pages_to_free);
 	free_hot_cold_page_list(&pages_to_free, cold);
@@ -826,7 +826,7 @@ void lru_add_page_tail(struct page *page
 	VM_BUG_ON_PAGE(PageCompound(page_tail), page);
 	VM_BUG_ON_PAGE(PageLRU(page_tail), page);
 	VM_BUG_ON(NR_CPUS != 1 &&
-		  !spin_is_locked(&lruvec_zone(lruvec)->lru_lock));
+		  !spin_is_locked(zone_lru_lock(lruvec_zone(lruvec))));
 
 	if (!list)
 		SetPageLRU(page_tail);
diff -puN mm/vmscan.c~mm-vmscan-move-lru_lock-to-the-node mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-move-lru_lock-to-the-node
+++ a/mm/vmscan.c
@@ -1349,7 +1349,7 @@ int __isolate_lru_page(struct page *page
 }
 
 /*
- * zone->lru_lock is heavily contended.  Some of the functions that
+ * zone_lru_lock is heavily contended.  Some of the functions that
  * shrink the lists perform better by taking out a batch of pages
  * and working on them outside the LRU lock.
  *
@@ -1444,7 +1444,7 @@ int isolate_lru_page(struct page *page)
 		struct zone *zone = page_zone(page);
 		struct lruvec *lruvec;
 
-		spin_lock_irq(&zone->lru_lock);
+		spin_lock_irq(zone_lru_lock(zone));
 		lruvec = mem_cgroup_page_lruvec(page, zone);
 		if (PageLRU(page)) {
 			int lru = page_lru(page);
@@ -1453,7 +1453,7 @@ int isolate_lru_page(struct page *page)
 			del_page_from_lru_list(page, lruvec, lru);
 			ret = 0;
 		}
-		spin_unlock_irq(&zone->lru_lock);
+		spin_unlock_irq(zone_lru_lock(zone));
 	}
 	return ret;
 }
@@ -1512,9 +1512,9 @@ putback_inactive_pages(struct lruvec *lr
 		VM_BUG_ON_PAGE(PageLRU(page), page);
 		list_del(&page->lru);
 		if (unlikely(!page_evictable(page))) {
-			spin_unlock_irq(&zone->lru_lock);
+			spin_unlock_irq(zone_lru_lock(zone));
 			putback_lru_page(page);
-			spin_lock_irq(&zone->lru_lock);
+			spin_lock_irq(zone_lru_lock(zone));
 			continue;
 		}
 
@@ -1535,10 +1535,10 @@ putback_inactive_pages(struct lruvec *lr
 			del_page_from_lru_list(page, lruvec, lru);
 
 			if (unlikely(PageCompound(page))) {
-				spin_unlock_irq(&zone->lru_lock);
+				spin_unlock_irq(zone_lru_lock(zone));
 				mem_cgroup_uncharge(page);
 				(*get_compound_page_dtor(page))(page);
-				spin_lock_irq(&zone->lru_lock);
+				spin_lock_irq(zone_lru_lock(zone));
 			} else
 				list_add(&page->lru, &pages_to_free);
 		}
@@ -1600,7 +1600,7 @@ shrink_inactive_list(unsigned long nr_to
 	if (!sc->may_writepage)
 		isolate_mode |= ISOLATE_CLEAN;
 
-	spin_lock_irq(&zone->lru_lock);
+	spin_lock_irq(zone_lru_lock(zone));
 
 	nr_taken = isolate_lru_pages(nr_to_scan, lruvec, &page_list,
 				     &nr_scanned, sc, isolate_mode, lru);
@@ -1616,7 +1616,7 @@ shrink_inactive_list(unsigned long nr_to
 		else
 			__count_zone_vm_events(PGSCAN_DIRECT, zone, nr_scanned);
 	}
-	spin_unlock_irq(&zone->lru_lock);
+	spin_unlock_irq(zone_lru_lock(zone));
 
 	if (nr_taken == 0)
 		return 0;
@@ -1626,7 +1626,7 @@ shrink_inactive_list(unsigned long nr_to
 				&nr_writeback, &nr_immediate,
 				false);
 
-	spin_lock_irq(&zone->lru_lock);
+	spin_lock_irq(zone_lru_lock(zone));
 
 	if (global_reclaim(sc)) {
 		if (current_is_kswapd())
@@ -1641,7 +1641,7 @@ shrink_inactive_list(unsigned long nr_to
 
 	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -nr_taken);
 
-	spin_unlock_irq(&zone->lru_lock);
+	spin_unlock_irq(zone_lru_lock(zone));
 
 	mem_cgroup_uncharge_list(&page_list);
 	free_hot_cold_page_list(&page_list, true);
@@ -1715,9 +1715,9 @@ shrink_inactive_list(unsigned long nr_to
  * processes, from rmap.
  *
  * If the pages are mostly unmapped, the processing is fast and it is
- * appropriate to hold zone->lru_lock across the whole operation.  But if
+ * appropriate to hold zone_lru_lock across the whole operation.  But if
  * the pages are mapped, the processing is slow (page_referenced()) so we
- * should drop zone->lru_lock around each page.  It's impossible to balance
+ * should drop zone_lru_lock around each page.  It's impossible to balance
  * this, so instead we remove the pages from the LRU while processing them.
  * It is safe to rely on PG_active against the non-LRU pages in here because
  * nobody will play with that bit on a non-LRU page.
@@ -1754,10 +1754,10 @@ static void move_active_pages_to_lru(str
 			del_page_from_lru_list(page, lruvec, lru);
 
 			if (unlikely(PageCompound(page))) {
-				spin_unlock_irq(&zone->lru_lock);
+				spin_unlock_irq(zone_lru_lock(zone));
 				mem_cgroup_uncharge(page);
 				(*get_compound_page_dtor(page))(page);
-				spin_lock_irq(&zone->lru_lock);
+				spin_lock_irq(zone_lru_lock(zone));
 			} else
 				list_add(&page->lru, pages_to_free);
 		}
@@ -1792,7 +1792,7 @@ static void shrink_active_list(unsigned
 	if (!sc->may_writepage)
 		isolate_mode |= ISOLATE_CLEAN;
 
-	spin_lock_irq(&zone->lru_lock);
+	spin_lock_irq(zone_lru_lock(zone));
 
 	nr_taken = isolate_lru_pages(nr_to_scan, lruvec, &l_hold,
 				     &nr_scanned, sc, isolate_mode, lru);
@@ -1805,7 +1805,7 @@ static void shrink_active_list(unsigned
 		__mod_zone_page_state(zone, NR_PAGES_SCANNED, nr_scanned);
 	__count_zone_vm_events(PGREFILL, zone, nr_scanned);
 
-	spin_unlock_irq(&zone->lru_lock);
+	spin_unlock_irq(zone_lru_lock(zone));
 
 	while (!list_empty(&l_hold)) {
 		cond_resched();
@@ -1850,7 +1850,7 @@ static void shrink_active_list(unsigned
 	/*
 	 * Move pages back to the lru list.
 	 */
-	spin_lock_irq(&zone->lru_lock);
+	spin_lock_irq(zone_lru_lock(zone));
 	/*
 	 * Count referenced pages from currently used mappings as rotated,
 	 * even though only some of them are actually re-activated.  This
@@ -1862,7 +1862,7 @@ static void shrink_active_list(unsigned
 	move_active_pages_to_lru(lruvec, &l_active, &l_hold, lru);
 	move_active_pages_to_lru(lruvec, &l_inactive, &l_hold, lru - LRU_ACTIVE);
 	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -nr_taken);
-	spin_unlock_irq(&zone->lru_lock);
+	spin_unlock_irq(zone_lru_lock(zone));
 
 	mem_cgroup_uncharge_list(&l_hold);
 	free_hot_cold_page_list(&l_hold, true);
@@ -2077,7 +2077,7 @@ static void get_scan_count(struct lruvec
 	file  = lruvec_lru_size(lruvec, LRU_ACTIVE_FILE) +
 		lruvec_lru_size(lruvec, LRU_INACTIVE_FILE);
 
-	spin_lock_irq(&zone->lru_lock);
+	spin_lock_irq(zone_lru_lock(zone));
 	if (unlikely(reclaim_stat->recent_scanned[0] > anon / 4)) {
 		reclaim_stat->recent_scanned[0] /= 2;
 		reclaim_stat->recent_rotated[0] /= 2;
@@ -2098,7 +2098,7 @@ static void get_scan_count(struct lruvec
 
 	fp = file_prio * (reclaim_stat->recent_scanned[1] + 1);
 	fp /= reclaim_stat->recent_rotated[1] + 1;
-	spin_unlock_irq(&zone->lru_lock);
+	spin_unlock_irq(zone_lru_lock(zone));
 
 	fraction[0] = ap;
 	fraction[1] = fp;
@@ -3791,9 +3791,9 @@ void check_move_unevictable_pages(struct
 		pagezone = page_zone(page);
 		if (pagezone != zone) {
 			if (zone)
-				spin_unlock_irq(&zone->lru_lock);
+				spin_unlock_irq(zone_lru_lock(zone));
 			zone = pagezone;
-			spin_lock_irq(&zone->lru_lock);
+			spin_lock_irq(zone_lru_lock(zone));
 		}
 		lruvec = mem_cgroup_page_lruvec(page, zone);
 
@@ -3814,7 +3814,7 @@ void check_move_unevictable_pages(struct
 	if (zone) {
 		__count_vm_events(UNEVICTABLE_PGRESCUED, pgrescued);
 		__count_vm_events(UNEVICTABLE_PGSCANNED, pgscanned);
-		spin_unlock_irq(&zone->lru_lock);
+		spin_unlock_irq(zone_lru_lock(zone));
 	}
 }
 #endif /* CONFIG_SHMEM */
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


