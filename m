From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrol-track-move_lock-state-internally.patch
 removed from -mm tree
Date: Thu, 12 Feb 2015 11:36:05 -0800
Message-ID: <54dd00a5.0ZOwEhU+OU25jABo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbbBLTgG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:36:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, fengguang.wu@intel.com, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: track move_lock state internally
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-track-move_lock-state-internally.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: track move_lock state internally

The complexity of memcg page stat synchronization is currently leaking
into the callsites, forcing them to keep track of the move_lock state and
the IRQ flags.  Simplify the API by tracking it in the memcg.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   12 ++----
 mm/memcontrol.c            |   70 ++++++++++++++++++++---------------
 mm/page-writeback.c        |   12 ++----
 mm/rmap.c                  |   12 ++----
 4 files changed, 52 insertions(+), 54 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-track-move_lock-state-internally include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-track-move_lock-state-internally
+++ a/include/linux/memcontrol.h
@@ -138,12 +138,10 @@ static inline bool mem_cgroup_disabled(v
 	return false;
 }
 
-struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page, bool *locked,
-					      unsigned long *flags);
-void mem_cgroup_end_page_stat(struct mem_cgroup *memcg, bool *locked,
-			      unsigned long *flags);
+struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page);
 void mem_cgroup_update_page_stat(struct mem_cgroup *memcg,
 				 enum mem_cgroup_stat_index idx, int val);
+void mem_cgroup_end_page_stat(struct mem_cgroup *memcg);
 
 static inline void mem_cgroup_inc_page_stat(struct mem_cgroup *memcg,
 					    enum mem_cgroup_stat_index idx)
@@ -285,14 +283,12 @@ mem_cgroup_print_oom_info(struct mem_cgr
 {
 }
 
-static inline struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page,
-					bool *locked, unsigned long *flags)
+static inline struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page)
 {
 	return NULL;
 }
 
-static inline void mem_cgroup_end_page_stat(struct mem_cgroup *memcg,
-					bool *locked, unsigned long *flags)
+static inline void mem_cgroup_end_page_stat(struct mem_cgroup *memcg)
 {
 }
 
diff -puN mm/memcontrol.c~mm-memcontrol-track-move_lock-state-internally mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-track-move_lock-state-internally
+++ a/mm/memcontrol.c
@@ -325,9 +325,11 @@ struct mem_cgroup {
 	/*
 	 * set > 0 if pages under this cgroup are moving to other cgroup.
 	 */
-	atomic_t	moving_account;
+	atomic_t		moving_account;
 	/* taken only while moving_account > 0 */
-	spinlock_t	move_lock;
+	spinlock_t		move_lock;
+	struct task_struct	*move_lock_task;
+	unsigned long		move_lock_flags;
 	/*
 	 * percpu counter.
 	 */
@@ -1977,34 +1979,33 @@ cleanup:
 /**
  * mem_cgroup_begin_page_stat - begin a page state statistics transaction
  * @page: page that is going to change accounted state
- * @locked: &memcg->move_lock slowpath was taken
- * @flags: IRQ-state flags for &memcg->move_lock
  *
  * This function must mark the beginning of an accounted page state
  * change to prevent double accounting when the page is concurrently
  * being moved to another memcg:
  *
- *   memcg = mem_cgroup_begin_page_stat(page, &locked, &flags);
+ *   memcg = mem_cgroup_begin_page_stat(page);
  *   if (TestClearPageState(page))
  *     mem_cgroup_update_page_stat(memcg, state, -1);
- *   mem_cgroup_end_page_stat(memcg, locked, flags);
- *
- * The RCU lock is held throughout the transaction.  The fast path can
- * get away without acquiring the memcg->move_lock (@locked is false)
- * because page moving starts with an RCU grace period.
- *
- * The RCU lock also protects the memcg from being freed when the page
- * state that is going to change is the only thing preventing the page
- * from being uncharged.  E.g. end-writeback clearing PageWriteback(),
- * which allows migration to go ahead and uncharge the page before the
- * account transaction might be complete.
- */
-struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page,
-					      bool *locked,
-					      unsigned long *flags)
+ *   mem_cgroup_end_page_stat(memcg);
+ */
+struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page)
 {
 	struct mem_cgroup *memcg;
+	unsigned long flags;
 
+	/*
+	 * The RCU lock is held throughout the transaction.  The fast
+	 * path can get away without acquiring the memcg->move_lock
+	 * because page moving starts with an RCU grace period.
+	 *
+	 * The RCU lock also protects the memcg from being freed when
+	 * the page state that is going to change is the only thing
+	 * preventing the page from being uncharged.
+	 * E.g. end-writeback clearing PageWriteback(), which allows
+	 * migration to go ahead and uncharge the page before the
+	 * account transaction might be complete.
+	 */
 	rcu_read_lock();
 
 	if (mem_cgroup_disabled())
@@ -2014,16 +2015,22 @@ again:
 	if (unlikely(!memcg))
 		return NULL;
 
-	*locked = false;
 	if (atomic_read(&memcg->moving_account) <= 0)
 		return memcg;
 
-	spin_lock_irqsave(&memcg->move_lock, *flags);
+	spin_lock_irqsave(&memcg->move_lock, flags);
 	if (memcg != page->mem_cgroup) {
-		spin_unlock_irqrestore(&memcg->move_lock, *flags);
+		spin_unlock_irqrestore(&memcg->move_lock, flags);
 		goto again;
 	}
-	*locked = true;
+
+	/*
+	 * When charge migration first begins, we can have locked and
+	 * unlocked page stat updates happening concurrently.  Track
+	 * the task who has the lock for mem_cgroup_end_page_stat().
+	 */
+	memcg->move_lock_task = current;
+	memcg->move_lock_flags = flags;
 
 	return memcg;
 }
@@ -2031,14 +2038,17 @@ again:
 /**
  * mem_cgroup_end_page_stat - finish a page state statistics transaction
  * @memcg: the memcg that was accounted against
- * @locked: value received from mem_cgroup_begin_page_stat()
- * @flags: value received from mem_cgroup_begin_page_stat()
  */
-void mem_cgroup_end_page_stat(struct mem_cgroup *memcg, bool *locked,
-			      unsigned long *flags)
+void mem_cgroup_end_page_stat(struct mem_cgroup *memcg)
 {
-	if (memcg && *locked)
-		spin_unlock_irqrestore(&memcg->move_lock, *flags);
+	if (memcg && memcg->move_lock_task == current) {
+		unsigned long flags = memcg->move_lock_flags;
+
+		memcg->move_lock_task = NULL;
+		memcg->move_lock_flags = 0;
+
+		spin_unlock_irqrestore(&memcg->move_lock, flags);
+	}
 
 	rcu_read_unlock();
 }
diff -puN mm/page-writeback.c~mm-memcontrol-track-move_lock-state-internally mm/page-writeback.c
--- a/mm/page-writeback.c~mm-memcontrol-track-move_lock-state-internally
+++ a/mm/page-writeback.c
@@ -2308,12 +2308,10 @@ EXPORT_SYMBOL(clear_page_dirty_for_io);
 int test_clear_page_writeback(struct page *page)
 {
 	struct address_space *mapping = page_mapping(page);
-	unsigned long memcg_flags;
 	struct mem_cgroup *memcg;
-	bool locked;
 	int ret;
 
-	memcg = mem_cgroup_begin_page_stat(page, &locked, &memcg_flags);
+	memcg = mem_cgroup_begin_page_stat(page);
 	if (mapping) {
 		struct backing_dev_info *bdi = mapping->backing_dev_info;
 		unsigned long flags;
@@ -2338,19 +2336,17 @@ int test_clear_page_writeback(struct pag
 		dec_zone_page_state(page, NR_WRITEBACK);
 		inc_zone_page_state(page, NR_WRITTEN);
 	}
-	mem_cgroup_end_page_stat(memcg, &locked, &memcg_flags);
+	mem_cgroup_end_page_stat(memcg);
 	return ret;
 }
 
 int __test_set_page_writeback(struct page *page, bool keep_write)
 {
 	struct address_space *mapping = page_mapping(page);
-	unsigned long memcg_flags;
 	struct mem_cgroup *memcg;
-	bool locked;
 	int ret;
 
-	memcg = mem_cgroup_begin_page_stat(page, &locked, &memcg_flags);
+	memcg = mem_cgroup_begin_page_stat(page);
 	if (mapping) {
 		struct backing_dev_info *bdi = mapping->backing_dev_info;
 		unsigned long flags;
@@ -2380,7 +2376,7 @@ int __test_set_page_writeback(struct pag
 		mem_cgroup_inc_page_stat(memcg, MEM_CGROUP_STAT_WRITEBACK);
 		inc_zone_page_state(page, NR_WRITEBACK);
 	}
-	mem_cgroup_end_page_stat(memcg, &locked, &memcg_flags);
+	mem_cgroup_end_page_stat(memcg);
 	return ret;
 
 }
diff -puN mm/rmap.c~mm-memcontrol-track-move_lock-state-internally mm/rmap.c
--- a/mm/rmap.c~mm-memcontrol-track-move_lock-state-internally
+++ a/mm/rmap.c
@@ -1085,24 +1085,20 @@ void page_add_new_anon_rmap(struct page
 void page_add_file_rmap(struct page *page)
 {
 	struct mem_cgroup *memcg;
-	unsigned long flags;
-	bool locked;
 
-	memcg = mem_cgroup_begin_page_stat(page, &locked, &flags);
+	memcg = mem_cgroup_begin_page_stat(page);
 	if (atomic_inc_and_test(&page->_mapcount)) {
 		__inc_zone_page_state(page, NR_FILE_MAPPED);
 		mem_cgroup_inc_page_stat(memcg, MEM_CGROUP_STAT_FILE_MAPPED);
 	}
-	mem_cgroup_end_page_stat(memcg, &locked, &flags);
+	mem_cgroup_end_page_stat(memcg);
 }
 
 static void page_remove_file_rmap(struct page *page)
 {
 	struct mem_cgroup *memcg;
-	unsigned long flags;
-	bool locked;
 
-	memcg = mem_cgroup_begin_page_stat(page, &locked, &flags);
+	memcg = mem_cgroup_begin_page_stat(page);
 
 	/* page still mapped by someone else? */
 	if (!atomic_add_negative(-1, &page->_mapcount))
@@ -1123,7 +1119,7 @@ static void page_remove_file_rmap(struct
 	if (unlikely(PageMlocked(page)))
 		clear_page_mlock(page);
 out:
-	mem_cgroup_end_page_stat(memcg, &locked, &flags);
+	mem_cgroup_end_page_stat(memcg);
 }
 
 /**
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
memcg-cleanup-static-keys-decrement.patch
documentation-proc-add-proc-pid-numa_maps-interface-explanation-snippet.patch
fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps.patch
fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps-fix.patch

