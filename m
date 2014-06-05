From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:52:39 -0700
Message-ID: <5390ca87.dqxns7rJY0qxVfEn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56437 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaFETwk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:52:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, tytso@mit.edu, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, mhocko@suse.cz, jack@suse.cz, hughd@google.com, hannes@cmpxchg.org, dave.hansen@intel.com, mgorman@suse.de

Subject: [merged] mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool.patch removed from -mm tree
To: mgorman@suse.de,dave.hansen@intel.com,hannes@cmpxchg.org,hughd@google.com,jack@suse.cz,mhocko@suse.cz,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,tytso@mit.edu,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:52:39 -0700


The patch titled
     Subject: mm: page_alloc: convert hot/cold parameter and immediate callers to bool
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: page_alloc: convert hot/cold parameter and immediate callers to bool

cold is a bool, make it one.  Make the likely case the "if" part of the
block instead of the else as according to the optimisation manual this is
preferred.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/tile/mm/homecache.c |    2 +-
 fs/fuse/dev.c            |    2 +-
 include/linux/gfp.h      |    4 ++--
 include/linux/pagemap.h  |    2 +-
 include/linux/swap.h     |    2 +-
 mm/page_alloc.c          |   20 ++++++++++----------
 mm/swap.c                |    4 ++--
 mm/swap_state.c          |    2 +-
 mm/vmscan.c              |    6 +++---
 9 files changed, 22 insertions(+), 22 deletions(-)

diff -puN arch/tile/mm/homecache.c~mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool arch/tile/mm/homecache.c
--- a/arch/tile/mm/homecache.c~mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool
+++ a/arch/tile/mm/homecache.c
@@ -417,7 +417,7 @@ void __homecache_free_pages(struct page
 	if (put_page_testzero(page)) {
 		homecache_change_page_home(page, order, PAGE_HOME_HASH);
 		if (order == 0) {
-			free_hot_cold_page(page, 0);
+			free_hot_cold_page(page, false);
 		} else {
 			init_page_count(page);
 			__free_pages(page, order);
diff -puN fs/fuse/dev.c~mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool fs/fuse/dev.c
--- a/fs/fuse/dev.c~mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool
+++ a/fs/fuse/dev.c
@@ -1614,7 +1614,7 @@ out_finish:
 
 static void fuse_retrieve_end(struct fuse_conn *fc, struct fuse_req *req)
 {
-	release_pages(req->pages, req->num_pages, 0);
+	release_pages(req->pages, req->num_pages, false);
 }
 
 static int fuse_retrieve(struct fuse_conn *fc, struct inode *inode,
diff -puN include/linux/gfp.h~mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool include/linux/gfp.h
--- a/include/linux/gfp.h~mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool
+++ a/include/linux/gfp.h
@@ -371,8 +371,8 @@ void *alloc_pages_exact_nid(int nid, siz
 
 extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);
-extern void free_hot_cold_page(struct page *page, int cold);
-extern void free_hot_cold_page_list(struct list_head *list, int cold);
+extern void free_hot_cold_page(struct page *page, bool cold);
+extern void free_hot_cold_page_list(struct list_head *list, bool cold);
 
 extern void __free_kmem_pages(struct page *page, unsigned int order);
 extern void free_kmem_pages(unsigned long addr, unsigned int order);
diff -puN include/linux/pagemap.h~mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool
+++ a/include/linux/pagemap.h
@@ -110,7 +110,7 @@ static inline void mapping_set_gfp_mask(
 
 #define page_cache_get(page)		get_page(page)
 #define page_cache_release(page)	put_page(page)
-void release_pages(struct page **pages, int nr, int cold);
+void release_pages(struct page **pages, int nr, bool cold);
 
 /*
  * speculatively take a reference to a page.
diff -puN include/linux/swap.h~mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool include/linux/swap.h
--- a/include/linux/swap.h~mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool
+++ a/include/linux/swap.h
@@ -477,7 +477,7 @@ mem_cgroup_uncharge_swapcache(struct pag
 #define free_page_and_swap_cache(page) \
 	page_cache_release(page)
 #define free_pages_and_swap_cache(pages, nr) \
-	release_pages((pages), (nr), 0);
+	release_pages((pages), (nr), false);
 
 static inline void show_swap_cache_info(void)
 {
diff -puN mm/page_alloc.c~mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool
+++ a/mm/page_alloc.c
@@ -1199,7 +1199,7 @@ retry_reserve:
  */
 static int rmqueue_bulk(struct zone *zone, unsigned int order,
 			unsigned long count, struct list_head *list,
-			int migratetype, int cold)
+			int migratetype, bool cold)
 {
 	int i;
 
@@ -1218,7 +1218,7 @@ static int rmqueue_bulk(struct zone *zon
 		 * merge IO requests if the physical pages are ordered
 		 * properly.
 		 */
-		if (likely(cold == 0))
+		if (likely(!cold))
 			list_add(&page->lru, list);
 		else
 			list_add_tail(&page->lru, list);
@@ -1379,9 +1379,9 @@ void mark_free_pages(struct zone *zone)
 
 /*
  * Free a 0-order page
- * cold == 1 ? free a cold page : free a hot page
+ * cold == true ? free a cold page : free a hot page
  */
-void free_hot_cold_page(struct page *page, int cold)
+void free_hot_cold_page(struct page *page, bool cold)
 {
 	struct zone *zone = page_zone(page);
 	struct per_cpu_pages *pcp;
@@ -1413,10 +1413,10 @@ void free_hot_cold_page(struct page *pag
 	}
 
 	pcp = &this_cpu_ptr(zone->pageset)->pcp;
-	if (cold)
-		list_add_tail(&page->lru, &pcp->lists[migratetype]);
-	else
+	if (!cold)
 		list_add(&page->lru, &pcp->lists[migratetype]);
+	else
+		list_add_tail(&page->lru, &pcp->lists[migratetype]);
 	pcp->count++;
 	if (pcp->count >= pcp->high) {
 		unsigned long batch = ACCESS_ONCE(pcp->batch);
@@ -1431,7 +1431,7 @@ out:
 /*
  * Free a list of 0-order pages
  */
-void free_hot_cold_page_list(struct list_head *list, int cold)
+void free_hot_cold_page_list(struct list_head *list, bool cold)
 {
 	struct page *page, *next;
 
@@ -1548,7 +1548,7 @@ struct page *buffered_rmqueue(struct zon
 {
 	unsigned long flags;
 	struct page *page;
-	int cold = !!(gfp_flags & __GFP_COLD);
+	bool cold = ((gfp_flags & __GFP_COLD) != 0);
 
 again:
 	if (likely(order == 0)) {
@@ -2823,7 +2823,7 @@ void __free_pages(struct page *page, uns
 {
 	if (put_page_testzero(page)) {
 		if (order == 0)
-			free_hot_cold_page(page, 0);
+			free_hot_cold_page(page, false);
 		else
 			__free_pages_ok(page, order);
 	}
diff -puN mm/swap.c~mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool mm/swap.c
--- a/mm/swap.c~mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool
+++ a/mm/swap.c
@@ -67,7 +67,7 @@ static void __page_cache_release(struct
 static void __put_single_page(struct page *page)
 {
 	__page_cache_release(page);
-	free_hot_cold_page(page, 0);
+	free_hot_cold_page(page, false);
 }
 
 static void __put_compound_page(struct page *page)
@@ -860,7 +860,7 @@ void lru_add_drain_all(void)
  * grabbed the page via the LRU.  If it did, give up: shrink_inactive_list()
  * will free it.
  */
-void release_pages(struct page **pages, int nr, int cold)
+void release_pages(struct page **pages, int nr, bool cold)
 {
 	int i;
 	LIST_HEAD(pages_to_free);
diff -puN mm/swap_state.c~mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool mm/swap_state.c
--- a/mm/swap_state.c~mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool
+++ a/mm/swap_state.c
@@ -270,7 +270,7 @@ void free_pages_and_swap_cache(struct pa
 
 		for (i = 0; i < todo; i++)
 			free_swap_cache(pagep[i]);
-		release_pages(pagep, todo, 0);
+		release_pages(pagep, todo, false);
 		pagep += todo;
 		nr -= todo;
 	}
diff -puN mm/vmscan.c~mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool mm/vmscan.c
--- a/mm/vmscan.c~mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool
+++ a/mm/vmscan.c
@@ -1121,7 +1121,7 @@ keep:
 		VM_BUG_ON_PAGE(PageLRU(page) || PageUnevictable(page), page);
 	}
 
-	free_hot_cold_page_list(&free_pages, 1);
+	free_hot_cold_page_list(&free_pages, true);
 
 	list_splice(&ret_pages, page_list);
 	count_vm_events(PGACTIVATE, pgactivate);
@@ -1532,7 +1532,7 @@ shrink_inactive_list(unsigned long nr_to
 
 	spin_unlock_irq(&zone->lru_lock);
 
-	free_hot_cold_page_list(&page_list, 1);
+	free_hot_cold_page_list(&page_list, true);
 
 	/*
 	 * If reclaim is isolating dirty pages under writeback, it implies
@@ -1755,7 +1755,7 @@ static void shrink_active_list(unsigned
 	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -nr_taken);
 	spin_unlock_irq(&zone->lru_lock);
 
-	free_hot_cold_page_list(&l_hold, 1);
+	free_hot_cold_page_list(&l_hold, true);
 }
 
 #ifdef CONFIG_SWAP
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-v5.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
linux-next.patch

