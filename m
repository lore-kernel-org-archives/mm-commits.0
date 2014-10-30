From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-fix-missed-end-writeback-page-accounting.patch removed from
 -mm tree
Date: Thu, 30 Oct 2014 13:27:49 -0700
Message-ID: <54529f45.gwa5JbD3Kriw98k9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40525 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161185AbaJ3U1s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Oct 2014 16:27:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, stable@vger.kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix missed end-writeback page accounting
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-missed-end-writeback-page-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: fix missed end-writeback page accounting

0a31bc97c80c ("mm: memcontrol: rewrite uncharge API") changed page
migration to uncharge the old page right away.  The page is locked,
unmapped, truncated, and off the LRU, but it could race with writeback
ending, which then doesn't unaccount the page properly:

test_clear_page_writeback()              migration
                                           wait_on_page_writeback()
  TestClearPageWriteback()
                                           mem_cgroup_migrate()
                                             clear PCG_USED
  mem_cgroup_update_page_stat()
    if (PageCgroupUsed(pc))
      decrease memcg pages under writeback

  release pc->mem_cgroup->move_lock

The per-page statistics interface is heavily optimized to avoid a function
call and a lookup_page_cgroup() in the file unmap fast path, which means
it doesn't verify whether a page is still charged before clearing
PageWriteback() and it has to do it in the stat update later.

Rework it so that it looks up the page's memcg once at the beginning of
the transaction and then uses it throughout.  The charge will be verified
before clearing PageWriteback() and migration can't uncharge the page as
long as that is still set.  The RCU lock will protect the memcg past
uncharge.

As far as losing the optimization goes, the following test results are
from a microbenchmark that maps, faults, and unmaps a 4GB sparse file
three times in a nested fashion, so that there are two negative passes
that don't account but still go through the new transaction overhead. 
There is no actual difference:

old:     33.195102545 seconds time elapsed       ( +-  0.01% )
new:     33.199231369 seconds time elapsed       ( +-  0.03% )

The time spent in page_remove_rmap()'s callees still adds up to the
same, but the time spent in the function itself seems reduced:

    # Children      Self  Command        Shared Object       Symbol
old:     0.12%     0.11%  filemapstress  [kernel.kallsyms]   [k] page_remove_rmap
new:     0.12%     0.08%  filemapstress  [kernel.kallsyms]   [k] page_remove_rmap

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: <stable@vger.kernel.org>	[3.17.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   56 ++++-------------
 mm/memcontrol.c            |  115 ++++++++++++++++++-----------------
 mm/page-writeback.c        |   22 +++---
 mm/rmap.c                  |   20 +++---
 4 files changed, 100 insertions(+), 113 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-fix-missed-end-writeback-page-accounting include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-fix-missed-end-writeback-page-accounting
+++ a/include/linux/memcontrol.h
@@ -139,48 +139,23 @@ static inline bool mem_cgroup_disabled(v
 	return false;
 }
 
-void __mem_cgroup_begin_update_page_stat(struct page *page, bool *locked,
-					 unsigned long *flags);
+struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page, bool *locked,
+					      unsigned long *flags);
+void mem_cgroup_end_page_stat(struct mem_cgroup *memcg, bool locked,
+			      unsigned long flags);
+void mem_cgroup_update_page_stat(struct mem_cgroup *memcg,
+				 enum mem_cgroup_stat_index idx, int val);
 
-extern atomic_t memcg_moving;
-
-static inline void mem_cgroup_begin_update_page_stat(struct page *page,
-					bool *locked, unsigned long *flags)
-{
-	if (mem_cgroup_disabled())
-		return;
-	rcu_read_lock();
-	*locked = false;
-	if (atomic_read(&memcg_moving))
-		__mem_cgroup_begin_update_page_stat(page, locked, flags);
-}
-
-void __mem_cgroup_end_update_page_stat(struct page *page,
-				unsigned long *flags);
-static inline void mem_cgroup_end_update_page_stat(struct page *page,
-					bool *locked, unsigned long *flags)
-{
-	if (mem_cgroup_disabled())
-		return;
-	if (*locked)
-		__mem_cgroup_end_update_page_stat(page, flags);
-	rcu_read_unlock();
-}
-
-void mem_cgroup_update_page_stat(struct page *page,
-				 enum mem_cgroup_stat_index idx,
-				 int val);
-
-static inline void mem_cgroup_inc_page_stat(struct page *page,
+static inline void mem_cgroup_inc_page_stat(struct mem_cgroup *memcg,
 					    enum mem_cgroup_stat_index idx)
 {
-	mem_cgroup_update_page_stat(page, idx, 1);
+	mem_cgroup_update_page_stat(memcg, idx, 1);
 }
 
-static inline void mem_cgroup_dec_page_stat(struct page *page,
+static inline void mem_cgroup_dec_page_stat(struct mem_cgroup *memcg,
 					    enum mem_cgroup_stat_index idx)
 {
-	mem_cgroup_update_page_stat(page, idx, -1);
+	mem_cgroup_update_page_stat(memcg, idx, -1);
 }
 
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
@@ -315,13 +290,14 @@ mem_cgroup_print_oom_info(struct mem_cgr
 {
 }
 
-static inline void mem_cgroup_begin_update_page_stat(struct page *page,
+static inline struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page,
 					bool *locked, unsigned long *flags)
 {
+	return NULL;
 }
 
-static inline void mem_cgroup_end_update_page_stat(struct page *page,
-					bool *locked, unsigned long *flags)
+static inline void mem_cgroup_end_page_stat(struct mem_cgroup *memcg,
+					bool locked, unsigned long flags)
 {
 }
 
@@ -343,12 +319,12 @@ static inline bool mem_cgroup_oom_synchr
 	return false;
 }
 
-static inline void mem_cgroup_inc_page_stat(struct page *page,
+static inline void mem_cgroup_inc_page_stat(struct mem_cgroup *memcg,
 					    enum mem_cgroup_stat_index idx)
 {
 }
 
-static inline void mem_cgroup_dec_page_stat(struct page *page,
+static inline void mem_cgroup_dec_page_stat(struct mem_cgroup *memcg,
 					    enum mem_cgroup_stat_index idx)
 {
 }
diff -puN mm/memcontrol.c~mm-memcontrol-fix-missed-end-writeback-page-accounting mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fix-missed-end-writeback-page-accounting
+++ a/mm/memcontrol.c
@@ -1536,12 +1536,8 @@ int mem_cgroup_swappiness(struct mem_cgr
  *         start move here.
  */
 
-/* for quick checking without looking up memcg */
-atomic_t memcg_moving __read_mostly;
-
 static void mem_cgroup_start_move(struct mem_cgroup *memcg)
 {
-	atomic_inc(&memcg_moving);
 	atomic_inc(&memcg->moving_account);
 	synchronize_rcu();
 }
@@ -1552,10 +1548,8 @@ static void mem_cgroup_end_move(struct m
 	 * Now, mem_cgroup_clear_mc() may call this function with NULL.
 	 * We check NULL in callee rather than caller.
 	 */
-	if (memcg) {
-		atomic_dec(&memcg_moving);
+	if (memcg)
 		atomic_dec(&memcg->moving_account);
-	}
 }
 
 /*
@@ -2204,41 +2198,52 @@ cleanup:
 	return true;
 }
 
-/*
- * Used to update mapped file or writeback or other statistics.
- *
- * Notes: Race condition
- *
- * Charging occurs during page instantiation, while the page is
- * unmapped and locked in page migration, or while the page table is
- * locked in THP migration.  No race is possible.
- *
- * Uncharge happens to pages with zero references, no race possible.
- *
- * Charge moving between groups is protected by checking mm->moving
- * account and taking the move_lock in the slowpath.
- */
-
-void __mem_cgroup_begin_update_page_stat(struct page *page,
-				bool *locked, unsigned long *flags)
+/**
+ * mem_cgroup_begin_page_stat - begin a page state statistics transaction
+ * @page: page that is going to change accounted state
+ * @locked: &memcg->move_lock slowpath was taken
+ * @flags: IRQ-state flags for &memcg->move_lock
+ *
+ * This function must mark the beginning of an accounted page state
+ * change to prevent double accounting when the page is concurrently
+ * being moved to another memcg:
+ *
+ *   memcg = mem_cgroup_begin_page_stat(page, &locked, &flags);
+ *   if (TestClearPageState(page))
+ *     mem_cgroup_update_page_stat(memcg, state, -1);
+ *   mem_cgroup_end_page_stat(memcg, locked, flags);
+ *
+ * The RCU lock is held throughout the transaction.  The fast path can
+ * get away without acquiring the memcg->move_lock (@locked is false)
+ * because page moving starts with an RCU grace period.
+ *
+ * The RCU lock also protects the memcg from being freed when the page
+ * state that is going to change is the only thing preventing the page
+ * from being uncharged.  E.g. end-writeback clearing PageWriteback(),
+ * which allows migration to go ahead and uncharge the page before the
+ * account transaction might be complete.
+ */
+struct mem_cgroup *mem_cgroup_begin_page_stat(struct page *page,
+					      bool *locked,
+					      unsigned long *flags)
 {
 	struct mem_cgroup *memcg;
 	struct page_cgroup *pc;
 
+	rcu_read_lock();
+
+	if (mem_cgroup_disabled())
+		return NULL;
+
 	pc = lookup_page_cgroup(page);
 again:
 	memcg = pc->mem_cgroup;
 	if (unlikely(!memcg || !PageCgroupUsed(pc)))
-		return;
-	/*
-	 * If this memory cgroup is not under account moving, we don't
-	 * need to take move_lock_mem_cgroup(). Because we already hold
-	 * rcu_read_lock(), any calls to move_account will be delayed until
-	 * rcu_read_unlock().
-	 */
-	VM_BUG_ON(!rcu_read_lock_held());
+		return NULL;
+
+	*locked = false;
 	if (atomic_read(&memcg->moving_account) <= 0)
-		return;
+		return memcg;
 
 	move_lock_mem_cgroup(memcg, flags);
 	if (memcg != pc->mem_cgroup || !PageCgroupUsed(pc)) {
@@ -2246,36 +2251,40 @@ again:
 		goto again;
 	}
 	*locked = true;
+
+	return memcg;
 }
 
-void __mem_cgroup_end_update_page_stat(struct page *page, unsigned long *flags)
+/**
+ * mem_cgroup_end_page_stat - finish a page state statistics transaction
+ * @memcg: the memcg that was accounted against
+ * @locked: value received from mem_cgroup_begin_page_stat()
+ * @flags: value received from mem_cgroup_begin_page_stat()
+ */
+void mem_cgroup_end_page_stat(struct mem_cgroup *memcg, bool locked,
+			      unsigned long flags)
 {
-	struct page_cgroup *pc = lookup_page_cgroup(page);
+	if (memcg && locked)
+		move_unlock_mem_cgroup(memcg, &flags);
 
-	/*
-	 * It's guaranteed that pc->mem_cgroup never changes while
-	 * lock is held because a routine modifies pc->mem_cgroup
-	 * should take move_lock_mem_cgroup().
-	 */
-	move_unlock_mem_cgroup(pc->mem_cgroup, flags);
+	rcu_read_unlock();
 }
 
-void mem_cgroup_update_page_stat(struct page *page,
+/**
+ * mem_cgroup_update_page_stat - update page state statistics
+ * @memcg: memcg to account against
+ * @idx: page state item to account
+ * @val: number of pages (positive or negative)
+ *
+ * See mem_cgroup_begin_page_stat() for locking requirements.
+ */
+void mem_cgroup_update_page_stat(struct mem_cgroup *memcg,
 				 enum mem_cgroup_stat_index idx, int val)
 {
-	struct mem_cgroup *memcg;
-	struct page_cgroup *pc = lookup_page_cgroup(page);
-	unsigned long uninitialized_var(flags);
-
-	if (mem_cgroup_disabled())
-		return;
-
 	VM_BUG_ON(!rcu_read_lock_held());
-	memcg = pc->mem_cgroup;
-	if (unlikely(!memcg || !PageCgroupUsed(pc)))
-		return;
 
-	this_cpu_add(memcg->stat->count[idx], val);
+	if (memcg)
+		this_cpu_add(memcg->stat->count[idx], val);
 }
 
 /*
diff -puN mm/page-writeback.c~mm-memcontrol-fix-missed-end-writeback-page-accounting mm/page-writeback.c
--- a/mm/page-writeback.c~mm-memcontrol-fix-missed-end-writeback-page-accounting
+++ a/mm/page-writeback.c
@@ -2327,11 +2327,12 @@ EXPORT_SYMBOL(clear_page_dirty_for_io);
 int test_clear_page_writeback(struct page *page)
 {
 	struct address_space *mapping = page_mapping(page);
-	int ret;
-	bool locked;
 	unsigned long memcg_flags;
+	struct mem_cgroup *memcg;
+	bool locked;
+	int ret;
 
-	mem_cgroup_begin_update_page_stat(page, &locked, &memcg_flags);
+	memcg = mem_cgroup_begin_page_stat(page, &locked, &memcg_flags);
 	if (mapping) {
 		struct backing_dev_info *bdi = mapping->backing_dev_info;
 		unsigned long flags;
@@ -2352,22 +2353,23 @@ int test_clear_page_writeback(struct pag
 		ret = TestClearPageWriteback(page);
 	}
 	if (ret) {
-		mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_WRITEBACK);
+		mem_cgroup_dec_page_stat(memcg, MEM_CGROUP_STAT_WRITEBACK);
 		dec_zone_page_state(page, NR_WRITEBACK);
 		inc_zone_page_state(page, NR_WRITTEN);
 	}
-	mem_cgroup_end_update_page_stat(page, &locked, &memcg_flags);
+	mem_cgroup_end_page_stat(memcg, locked, memcg_flags);
 	return ret;
 }
 
 int __test_set_page_writeback(struct page *page, bool keep_write)
 {
 	struct address_space *mapping = page_mapping(page);
-	int ret;
-	bool locked;
 	unsigned long memcg_flags;
+	struct mem_cgroup *memcg;
+	bool locked;
+	int ret;
 
-	mem_cgroup_begin_update_page_stat(page, &locked, &memcg_flags);
+	memcg = mem_cgroup_begin_page_stat(page, &locked, &memcg_flags);
 	if (mapping) {
 		struct backing_dev_info *bdi = mapping->backing_dev_info;
 		unsigned long flags;
@@ -2394,10 +2396,10 @@ int __test_set_page_writeback(struct pag
 		ret = TestSetPageWriteback(page);
 	}
 	if (!ret) {
-		mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_WRITEBACK);
+		mem_cgroup_inc_page_stat(memcg, MEM_CGROUP_STAT_WRITEBACK);
 		inc_zone_page_state(page, NR_WRITEBACK);
 	}
-	mem_cgroup_end_update_page_stat(page, &locked, &memcg_flags);
+	mem_cgroup_end_page_stat(memcg, locked, memcg_flags);
 	return ret;
 
 }
diff -puN mm/rmap.c~mm-memcontrol-fix-missed-end-writeback-page-accounting mm/rmap.c
--- a/mm/rmap.c~mm-memcontrol-fix-missed-end-writeback-page-accounting
+++ a/mm/rmap.c
@@ -1042,15 +1042,16 @@ void page_add_new_anon_rmap(struct page
  */
 void page_add_file_rmap(struct page *page)
 {
-	bool locked;
+	struct mem_cgroup *memcg;
 	unsigned long flags;
+	bool locked;
 
-	mem_cgroup_begin_update_page_stat(page, &locked, &flags);
+	memcg = mem_cgroup_begin_page_stat(page, &locked, &flags);
 	if (atomic_inc_and_test(&page->_mapcount)) {
 		__inc_zone_page_state(page, NR_FILE_MAPPED);
-		mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED);
+		mem_cgroup_inc_page_stat(memcg, MEM_CGROUP_STAT_FILE_MAPPED);
 	}
-	mem_cgroup_end_update_page_stat(page, &locked, &flags);
+	mem_cgroup_end_page_stat(memcg, locked, flags);
 }
 
 /**
@@ -1061,9 +1062,10 @@ void page_add_file_rmap(struct page *pag
  */
 void page_remove_rmap(struct page *page)
 {
+	struct mem_cgroup *uninitialized_var(memcg);
 	bool anon = PageAnon(page);
-	bool locked;
 	unsigned long flags;
+	bool locked;
 
 	/*
 	 * The anon case has no mem_cgroup page_stat to update; but may
@@ -1071,7 +1073,7 @@ void page_remove_rmap(struct page *page)
 	 * we hold the lock against page_stat move: so avoid it on anon.
 	 */
 	if (!anon)
-		mem_cgroup_begin_update_page_stat(page, &locked, &flags);
+		memcg = mem_cgroup_begin_page_stat(page, &locked, &flags);
 
 	/* page still mapped by someone else? */
 	if (!atomic_add_negative(-1, &page->_mapcount))
@@ -1096,8 +1098,7 @@ void page_remove_rmap(struct page *page)
 				-hpage_nr_pages(page));
 	} else {
 		__dec_zone_page_state(page, NR_FILE_MAPPED);
-		mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED);
-		mem_cgroup_end_update_page_stat(page, &locked, &flags);
+		mem_cgroup_dec_page_stat(memcg, MEM_CGROUP_STAT_FILE_MAPPED);
 	}
 	if (unlikely(PageMlocked(page)))
 		clear_page_mlock(page);
@@ -1110,10 +1111,9 @@ void page_remove_rmap(struct page *page)
 	 * Leaving it set also helps swapoff to reinstate ptes
 	 * faster for those pages still in swapcache.
 	 */
-	return;
 out:
 	if (!anon)
-		mem_cgroup_end_update_page_stat(page, &locked, &flags);
+		mem_cgroup_end_page_stat(memcg, locked, flags);
 }
 
 /*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
slab-print-slabinfo-header-in-seq-show.patch
mm-memcontrol-lockless-page-counters.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
mm-memcontrol-lockless-page-counters-fix-2.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
kernel-res_counter-remove-the-unused-api-fix.patch
kernel-res_counter-remove-the-unused-api-fix-2.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
mm-vmscan-count-only-dirty-pages-as-congested.patch
memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch
mm-memcontrol-update-mem_cgroup_page_lruvec-documentation.patch
mm-memcontrol-clarify-migration-where-old-page-is-uncharged.patch
memcg-remove-activate_kmem_mutex.patch
mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup.patch
mm-memcontrol-uncharge-pages-on-swapout.patch
mm-memcontrol-uncharge-pages-on-swapout-fix.patch
mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-inline-memcg-move_lock-locking.patch
mm-memcontrol-dont-pass-a-null-memcg-to-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
memcg-remove-mem_cgroup_reclaimable-check-from-soft-reclaim.patch
memcg-use-generic-slab-iterators-for-showing-slabinfo.patch
mm-memcontrol-shorten-the-page-statistics-update-slowpath.patch
mm-memcontrol-remove-bogus-null-check-after-mem_cgroup_from_task.patch
mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree.patch
mm-memcontrol-drop-bogus-rcu-locking-from-mem_cgroup_same_or_subtree.patch
debugging-keep-track-of-page-owners.patch

