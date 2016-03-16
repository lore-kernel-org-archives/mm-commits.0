From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:56:38 -0700
Message-ID: <56e9ba76./xLAGQrUukS0KAgp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641AbcCPT4j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:56:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: generalize locking for the page->mem_cgroup binding
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: generalize locking for the page->mem_cgroup binding

These patches tag the page cache radix tree eviction entries with the
memcg an evicted page belonged to, thus making per-cgroup LRU reclaim work
properly and be as adaptive to new cache workingsets as global reclaim
already is.

This should have been part of the original thrash detection patch series,
but was deferred due to the complexity of those patches.



This patch (of 5):

So far the only sites that needed to exclude charge migration to stabilize
page->mem_cgroup have been per-cgroup page statistics, hence the name
mem_cgroup_begin_page_stat().  But per-cgroup thrash detection will add
another site that needs to ensure page->mem_cgroup lifetime.

Rename these locking functions to the more generic lock_page_memcg() and
unlock_page_memcg().  Since charge migration is a cgroup1 feature only, we
might be able to delete it at some point, and these now easy to identify
locking sites along with it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                |   14 +++++++-------
 fs/xfs/xfs_aops.c          |    8 ++++----
 include/linux/memcontrol.h |   16 +++++++++++-----
 mm/filemap.c               |   12 ++++++------
 mm/memcontrol.c            |   34 ++++++++++++++--------------------
 mm/page-writeback.c        |   28 ++++++++++++++--------------
 mm/rmap.c                  |    8 ++++----
 mm/truncate.c              |    6 +++---
 mm/vmscan.c                |    8 ++++----
 9 files changed, 67 insertions(+), 67 deletions(-)

diff -puN fs/buffer.c~mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding fs/buffer.c
--- a/fs/buffer.c~mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding
+++ a/fs/buffer.c
@@ -621,7 +621,7 @@ EXPORT_SYMBOL(mark_buffer_dirty_inode);
  * If warn is true, then emit a warning if the page is not uptodate and has
  * not been truncated.
  *
- * The caller must hold mem_cgroup_begin_page_stat() lock.
+ * The caller must hold lock_page_memcg().
  */
 static void __set_page_dirty(struct page *page, struct address_space *mapping,
 			     struct mem_cgroup *memcg, int warn)
@@ -683,17 +683,17 @@ int __set_page_dirty_buffers(struct page
 		} while (bh != head);
 	}
 	/*
-	 * Use mem_group_begin_page_stat() to keep PageDirty synchronized with
-	 * per-memcg dirty page counters.
+	 * Lock out page->mem_cgroup migration to keep PageDirty
+	 * synchronized with per-memcg dirty page counters.
 	 */
-	memcg = mem_cgroup_begin_page_stat(page);
+	memcg = lock_page_memcg(page);
 	newly_dirty = !TestSetPageDirty(page);
 	spin_unlock(&mapping->private_lock);
 
 	if (newly_dirty)
 		__set_page_dirty(page, mapping, memcg, 1);
 
-	mem_cgroup_end_page_stat(memcg);
+	unlock_page_memcg(memcg);
 
 	if (newly_dirty)
 		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
@@ -1169,13 +1169,13 @@ void mark_buffer_dirty(struct buffer_hea
 		struct address_space *mapping = NULL;
 		struct mem_cgroup *memcg;
 
-		memcg = mem_cgroup_begin_page_stat(page);
+		memcg = lock_page_memcg(page);
 		if (!TestSetPageDirty(page)) {
 			mapping = page_mapping(page);
 			if (mapping)
 				__set_page_dirty(page, mapping, memcg, 0);
 		}
-		mem_cgroup_end_page_stat(memcg);
+		unlock_page_memcg(memcg);
 		if (mapping)
 			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 	}
diff -puN fs/xfs/xfs_aops.c~mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding fs/xfs/xfs_aops.c
--- a/fs/xfs/xfs_aops.c~mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding
+++ a/fs/xfs/xfs_aops.c
@@ -1978,10 +1978,10 @@ xfs_vm_set_page_dirty(
 		} while (bh != head);
 	}
 	/*
-	 * Use mem_group_begin_page_stat() to keep PageDirty synchronized with
-	 * per-memcg dirty page counters.
+	 * Lock out page->mem_cgroup migration to keep PageDirty
+	 * synchronized with per-memcg dirty page counters.
 	 */
-	memcg = mem_cgroup_begin_page_stat(page);
+	memcg = lock_page_memcg(page);
 	newly_dirty = !TestSetPageDirty(page);
 	spin_unlock(&mapping->private_lock);
 
@@ -1998,7 +1998,7 @@ xfs_vm_set_page_dirty(
 		}
 		spin_unlock_irqrestore(&mapping->tree_lock, flags);
 	}
-	mem_cgroup_end_page_stat(memcg);
+	unlock_page_memcg(memcg);
 	if (newly_dirty)
 		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 	return newly_dirty;
diff -puN include/linux/memcontrol.h~mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding
+++ a/include/linux/memcontrol.h
@@ -429,8 +429,8 @@ bool mem_cgroup_oom_synchronize(bool wai
 extern int do_swap_account;
 #endif
 
-struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page);
-void mem_cgroup_end_page_stat(struct mem_cgroup *memcg);
+struct mem_cgroup *lock_page_memcg(struct page *page);
+void unlock_page_memcg(struct mem_cgroup *memcg);
 
 /**
  * mem_cgroup_update_page_stat - update page state statistics
@@ -438,7 +438,13 @@ void mem_cgroup_end_page_stat(struct mem
  * @idx: page state item to account
  * @val: number of pages (positive or negative)
  *
- * See mem_cgroup_begin_page_stat() for locking requirements.
+ * Callers must use lock_page_memcg() to prevent double accounting
+ * when the page is concurrently being moved to another memcg:
+ *
+ *   memcg = lock_page_memcg(page);
+ *   if (TestClearPageState(page))
+ *     mem_cgroup_update_page_stat(memcg, state, -1);
+ *   unlock_page_memcg(memcg);
  */
 static inline void mem_cgroup_update_page_stat(struct mem_cgroup *memcg,
 				 enum mem_cgroup_stat_index idx, int val)
@@ -613,12 +619,12 @@ mem_cgroup_print_oom_info(struct mem_cgr
 {
 }
 
-static inline struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page)
+static inline struct mem_cgroup *lock_page_memcg(struct page *page)
 {
 	return NULL;
 }
 
-static inline void mem_cgroup_end_page_stat(struct mem_cgroup *memcg)
+static inline void unlock_page_memcg(struct mem_cgroup *memcg)
 {
 }
 
diff -puN mm/filemap.c~mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding mm/filemap.c
--- a/mm/filemap.c~mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding
+++ a/mm/filemap.c
@@ -101,7 +101,7 @@
  *    ->tree_lock		(page_remove_rmap->set_page_dirty)
  *    bdi.wb->list_lock		(page_remove_rmap->set_page_dirty)
  *    ->inode->i_lock		(page_remove_rmap->set_page_dirty)
- *    ->memcg->move_lock	(page_remove_rmap->mem_cgroup_begin_page_stat)
+ *    ->memcg->move_lock	(page_remove_rmap->lock_page_memcg)
  *    bdi.wb->list_lock		(zap_pte_range->set_page_dirty)
  *    ->inode->i_lock		(zap_pte_range->set_page_dirty)
  *    ->private_lock		(zap_pte_range->__set_page_dirty_buffers)
@@ -177,7 +177,7 @@ static void page_cache_tree_delete(struc
  * Delete a page from the page cache and free it. Caller has to make
  * sure the page is locked and that nobody else uses it - or that usage
  * is safe.  The caller must hold the mapping's tree_lock and
- * mem_cgroup_begin_page_stat().
+ * lock_page_memcg().
  */
 void __delete_from_page_cache(struct page *page, void *shadow,
 			      struct mem_cgroup *memcg)
@@ -263,11 +263,11 @@ void delete_from_page_cache(struct page
 
 	freepage = mapping->a_ops->freepage;
 
-	memcg = mem_cgroup_begin_page_stat(page);
+	memcg = lock_page_memcg(page);
 	spin_lock_irqsave(&mapping->tree_lock, flags);
 	__delete_from_page_cache(page, NULL, memcg);
 	spin_unlock_irqrestore(&mapping->tree_lock, flags);
-	mem_cgroup_end_page_stat(memcg);
+	unlock_page_memcg(memcg);
 
 	if (freepage)
 		freepage(page);
@@ -561,7 +561,7 @@ int replace_page_cache_page(struct page
 		new->mapping = mapping;
 		new->index = offset;
 
-		memcg = mem_cgroup_begin_page_stat(old);
+		memcg = lock_page_memcg(old);
 		spin_lock_irqsave(&mapping->tree_lock, flags);
 		__delete_from_page_cache(old, NULL, memcg);
 		error = radix_tree_insert(&mapping->page_tree, offset, new);
@@ -576,7 +576,7 @@ int replace_page_cache_page(struct page
 		if (PageSwapBacked(new))
 			__inc_zone_page_state(new, NR_SHMEM);
 		spin_unlock_irqrestore(&mapping->tree_lock, flags);
-		mem_cgroup_end_page_stat(memcg);
+		unlock_page_memcg(memcg);
 		mem_cgroup_replace_page(old, new);
 		radix_tree_preload_end();
 		if (freepage)
diff -puN mm/memcontrol.c~mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding
+++ a/mm/memcontrol.c
@@ -1709,19 +1709,13 @@ cleanup:
 }
 
 /**
- * mem_cgroup_begin_page_stat - begin a page state statistics transaction
- * @page: page that is going to change accounted state
+ * lock_page_memcg - lock a page->mem_cgroup binding
+ * @page: the page
  *
- * This function must mark the beginning of an accounted page state
- * change to prevent double accounting when the page is concurrently
- * being moved to another memcg:
- *
- *   memcg = mem_cgroup_begin_page_stat(page);
- *   if (TestClearPageState(page))
- *     mem_cgroup_update_page_stat(memcg, state, -1);
- *   mem_cgroup_end_page_stat(memcg);
+ * This function protects unlocked LRU pages from being moved to
+ * another cgroup and stabilizes their page->mem_cgroup binding.
  */
-struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page)
+struct mem_cgroup *lock_page_memcg(struct page *page)
 {
 	struct mem_cgroup *memcg;
 	unsigned long flags;
@@ -1759,20 +1753,20 @@ again:
 	/*
 	 * When charge migration first begins, we can have locked and
 	 * unlocked page stat updates happening concurrently.  Track
-	 * the task who has the lock for mem_cgroup_end_page_stat().
+	 * the task who has the lock for unlock_page_memcg().
 	 */
 	memcg->move_lock_task = current;
 	memcg->move_lock_flags = flags;
 
 	return memcg;
 }
-EXPORT_SYMBOL(mem_cgroup_begin_page_stat);
+EXPORT_SYMBOL(lock_page_memcg);
 
 /**
- * mem_cgroup_end_page_stat - finish a page state statistics transaction
- * @memcg: the memcg that was accounted against
+ * unlock_page_memcg - unlock a page->mem_cgroup binding
+ * @memcg: the memcg returned by lock_page_memcg()
  */
-void mem_cgroup_end_page_stat(struct mem_cgroup *memcg)
+void unlock_page_memcg(struct mem_cgroup *memcg)
 {
 	if (memcg && memcg->move_lock_task == current) {
 		unsigned long flags = memcg->move_lock_flags;
@@ -1785,7 +1779,7 @@ void mem_cgroup_end_page_stat(struct mem
 
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL(mem_cgroup_end_page_stat);
+EXPORT_SYMBOL(unlock_page_memcg);
 
 /*
  * size of first charge trial. "32" comes from vmscan.c's magic value.
@@ -4923,9 +4917,9 @@ static void mem_cgroup_move_charge(struc
 
 	lru_add_drain_all();
 	/*
-	 * Signal mem_cgroup_begin_page_stat() to take the memcg's
-	 * move_lock while we're moving its pages to another memcg.
-	 * Then wait for already started RCU-only updates to finish.
+	 * Signal lock_page_memcg() to take the memcg's move_lock
+	 * while we're moving its pages to another memcg. Then wait
+	 * for already started RCU-only updates to finish.
 	 */
 	atomic_inc(&mc.from->moving_account);
 	synchronize_rcu();
diff -puN mm/page-writeback.c~mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding mm/page-writeback.c
--- a/mm/page-writeback.c~mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding
+++ a/mm/page-writeback.c
@@ -2410,7 +2410,7 @@ int __set_page_dirty_no_writeback(struct
 /*
  * Helper function for set_page_dirty family.
  *
- * Caller must hold mem_cgroup_begin_page_stat().
+ * Caller must hold lock_page_memcg().
  *
  * NOTE: This relies on being atomic wrt interrupts.
  */
@@ -2442,7 +2442,7 @@ EXPORT_SYMBOL(account_page_dirtied);
 /*
  * Helper function for deaccounting dirty page without writeback.
  *
- * Caller must hold mem_cgroup_begin_page_stat().
+ * Caller must hold lock_page_memcg().
  */
 void account_page_cleaned(struct page *page, struct address_space *mapping,
 			  struct mem_cgroup *memcg, struct bdi_writeback *wb)
@@ -2471,13 +2471,13 @@ int __set_page_dirty_nobuffers(struct pa
 {
 	struct mem_cgroup *memcg;
 
-	memcg = mem_cgroup_begin_page_stat(page);
+	memcg = lock_page_memcg(page);
 	if (!TestSetPageDirty(page)) {
 		struct address_space *mapping = page_mapping(page);
 		unsigned long flags;
 
 		if (!mapping) {
-			mem_cgroup_end_page_stat(memcg);
+			unlock_page_memcg(memcg);
 			return 1;
 		}
 
@@ -2488,7 +2488,7 @@ int __set_page_dirty_nobuffers(struct pa
 		radix_tree_tag_set(&mapping->page_tree, page_index(page),
 				   PAGECACHE_TAG_DIRTY);
 		spin_unlock_irqrestore(&mapping->tree_lock, flags);
-		mem_cgroup_end_page_stat(memcg);
+		unlock_page_memcg(memcg);
 
 		if (mapping->host) {
 			/* !PageAnon && !swapper_space */
@@ -2496,7 +2496,7 @@ int __set_page_dirty_nobuffers(struct pa
 		}
 		return 1;
 	}
-	mem_cgroup_end_page_stat(memcg);
+	unlock_page_memcg(memcg);
 	return 0;
 }
 EXPORT_SYMBOL(__set_page_dirty_nobuffers);
@@ -2629,14 +2629,14 @@ void cancel_dirty_page(struct page *page
 		struct mem_cgroup *memcg;
 		bool locked;
 
-		memcg = mem_cgroup_begin_page_stat(page);
+		memcg = lock_page_memcg(page);
 		wb = unlocked_inode_to_wb_begin(inode, &locked);
 
 		if (TestClearPageDirty(page))
 			account_page_cleaned(page, mapping, memcg, wb);
 
 		unlocked_inode_to_wb_end(inode, locked);
-		mem_cgroup_end_page_stat(memcg);
+		unlock_page_memcg(memcg);
 	} else {
 		ClearPageDirty(page);
 	}
@@ -2705,7 +2705,7 @@ int clear_page_dirty_for_io(struct page
 		 * always locked coming in here, so we get the desired
 		 * exclusion.
 		 */
-		memcg = mem_cgroup_begin_page_stat(page);
+		memcg = lock_page_memcg(page);
 		wb = unlocked_inode_to_wb_begin(inode, &locked);
 		if (TestClearPageDirty(page)) {
 			mem_cgroup_dec_page_stat(memcg, MEM_CGROUP_STAT_DIRTY);
@@ -2714,7 +2714,7 @@ int clear_page_dirty_for_io(struct page
 			ret = 1;
 		}
 		unlocked_inode_to_wb_end(inode, locked);
-		mem_cgroup_end_page_stat(memcg);
+		unlock_page_memcg(memcg);
 		return ret;
 	}
 	return TestClearPageDirty(page);
@@ -2727,7 +2727,7 @@ int test_clear_page_writeback(struct pag
 	struct mem_cgroup *memcg;
 	int ret;
 
-	memcg = mem_cgroup_begin_page_stat(page);
+	memcg = lock_page_memcg(page);
 	if (mapping) {
 		struct inode *inode = mapping->host;
 		struct backing_dev_info *bdi = inode_to_bdi(inode);
@@ -2755,7 +2755,7 @@ int test_clear_page_writeback(struct pag
 		dec_zone_page_state(page, NR_WRITEBACK);
 		inc_zone_page_state(page, NR_WRITTEN);
 	}
-	mem_cgroup_end_page_stat(memcg);
+	unlock_page_memcg(memcg);
 	return ret;
 }
 
@@ -2765,7 +2765,7 @@ int __test_set_page_writeback(struct pag
 	struct mem_cgroup *memcg;
 	int ret;
 
-	memcg = mem_cgroup_begin_page_stat(page);
+	memcg = lock_page_memcg(page);
 	if (mapping) {
 		struct inode *inode = mapping->host;
 		struct backing_dev_info *bdi = inode_to_bdi(inode);
@@ -2796,7 +2796,7 @@ int __test_set_page_writeback(struct pag
 		mem_cgroup_inc_page_stat(memcg, MEM_CGROUP_STAT_WRITEBACK);
 		inc_zone_page_state(page, NR_WRITEBACK);
 	}
-	mem_cgroup_end_page_stat(memcg);
+	unlock_page_memcg(memcg);
 	return ret;
 
 }
diff -puN mm/rmap.c~mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding mm/rmap.c
--- a/mm/rmap.c~mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding
+++ a/mm/rmap.c
@@ -1289,19 +1289,19 @@ void page_add_file_rmap(struct page *pag
 {
 	struct mem_cgroup *memcg;
 
-	memcg = mem_cgroup_begin_page_stat(page);
+	memcg = lock_page_memcg(page);
 	if (atomic_inc_and_test(&page->_mapcount)) {
 		__inc_zone_page_state(page, NR_FILE_MAPPED);
 		mem_cgroup_inc_page_stat(memcg, MEM_CGROUP_STAT_FILE_MAPPED);
 	}
-	mem_cgroup_end_page_stat(memcg);
+	unlock_page_memcg(memcg);
 }
 
 static void page_remove_file_rmap(struct page *page)
 {
 	struct mem_cgroup *memcg;
 
-	memcg = mem_cgroup_begin_page_stat(page);
+	memcg = lock_page_memcg(page);
 
 	/* Hugepages are not counted in NR_FILE_MAPPED for now. */
 	if (unlikely(PageHuge(page))) {
@@ -1325,7 +1325,7 @@ static void page_remove_file_rmap(struct
 	if (unlikely(PageMlocked(page)))
 		clear_page_mlock(page);
 out:
-	mem_cgroup_end_page_stat(memcg);
+	unlock_page_memcg(memcg);
 }
 
 static void page_remove_anon_compound_rmap(struct page *page)
diff -puN mm/truncate.c~mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding mm/truncate.c
--- a/mm/truncate.c~mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding
+++ a/mm/truncate.c
@@ -528,7 +528,7 @@ invalidate_complete_page2(struct address
 	if (page_has_private(page) && !try_to_release_page(page, GFP_KERNEL))
 		return 0;
 
-	memcg = mem_cgroup_begin_page_stat(page);
+	memcg = lock_page_memcg(page);
 	spin_lock_irqsave(&mapping->tree_lock, flags);
 	if (PageDirty(page))
 		goto failed;
@@ -536,7 +536,7 @@ invalidate_complete_page2(struct address
 	BUG_ON(page_has_private(page));
 	__delete_from_page_cache(page, NULL, memcg);
 	spin_unlock_irqrestore(&mapping->tree_lock, flags);
-	mem_cgroup_end_page_stat(memcg);
+	unlock_page_memcg(memcg);
 
 	if (mapping->a_ops->freepage)
 		mapping->a_ops->freepage(page);
@@ -545,7 +545,7 @@ invalidate_complete_page2(struct address
 	return 1;
 failed:
 	spin_unlock_irqrestore(&mapping->tree_lock, flags);
-	mem_cgroup_end_page_stat(memcg);
+	unlock_page_memcg(memcg);
 	return 0;
 }
 
diff -puN mm/vmscan.c~mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding mm/vmscan.c
--- a/mm/vmscan.c~mm-memcontrol-generalize-locking-for-the-page-mem_cgroup-binding
+++ a/mm/vmscan.c
@@ -608,7 +608,7 @@ static int __remove_mapping(struct addre
 	BUG_ON(!PageLocked(page));
 	BUG_ON(mapping != page_mapping(page));
 
-	memcg = mem_cgroup_begin_page_stat(page);
+	memcg = lock_page_memcg(page);
 	spin_lock_irqsave(&mapping->tree_lock, flags);
 	/*
 	 * The non racy check for a busy page.
@@ -648,7 +648,7 @@ static int __remove_mapping(struct addre
 		mem_cgroup_swapout(page, swap);
 		__delete_from_swap_cache(page);
 		spin_unlock_irqrestore(&mapping->tree_lock, flags);
-		mem_cgroup_end_page_stat(memcg);
+		unlock_page_memcg(memcg);
 		swapcache_free(swap);
 	} else {
 		void (*freepage)(struct page *);
@@ -676,7 +676,7 @@ static int __remove_mapping(struct addre
 			shadow = workingset_eviction(mapping, page);
 		__delete_from_page_cache(page, shadow, memcg);
 		spin_unlock_irqrestore(&mapping->tree_lock, flags);
-		mem_cgroup_end_page_stat(memcg);
+		unlock_page_memcg(memcg);
 
 		if (freepage != NULL)
 			freepage(page);
@@ -686,7 +686,7 @@ static int __remove_mapping(struct addre
 
 cannot_free:
 	spin_unlock_irqrestore(&mapping->tree_lock, flags);
-	mem_cgroup_end_page_stat(memcg);
+	unlock_page_memcg(memcg);
 	return 0;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-oom_kill-dont-ignore-oom-score-on-exiting-tasks.patch
mm-scale-kswapd-watermarks-in-proportion-to-memory.patch
mm-scale-kswapd-watermarks-in-proportion-to-memory-v3.patch
mm-memcontrol-reclaim-when-shrinking-memoryhigh-below-usage.patch
mm-memcontrol-reclaim-and-oom-kill-when-shrinking-memorymax-below-usage.patch
mm-memcontrol-clarify-the-uncharge_list-loop.patch

