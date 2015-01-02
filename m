From: akpm@linux-foundation.org
Subject: + mm-memcontrol-track-move_lock-state-internally.patch added to
 -mm tree
Date: Fri, 02 Jan 2015 15:44:20 -0800
Message-ID: <54a72d54.zXWA83mxacWzDV/v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbbABXoV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jan 2015 18:44:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: track move_lock state internally
has been added to the -mm tree.  Its filename is
     mm-memcontrol-track-move_lock-state-internally.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-track-move_lock-state-internally.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-track-move_lock-state-internally.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: track move_lock state internally

The complexity of memcg page stat synchronization is currently leaking
into the callsites, forcing them to keep track of the move_lock state and
the IRQ flags.  Simplify the API by tracking it in the memcg.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    6 +--
 mm/memcontrol.c            |   70 ++++++++++++++++++++---------------
 mm/page-writeback.c        |   12 ++----
 mm/rmap.c                  |   12 ++----
 4 files changed, 50 insertions(+), 50 deletions(-)

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
@@ -1086,24 +1086,20 @@ void page_add_new_anon_rmap(struct page
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
@@ -1124,7 +1120,7 @@ static void page_remove_file_rmap(struct
 	if (unlikely(PageMlocked(page)))
 		clear_page_mlock(page);
 out:
-	mem_cgroup_end_page_stat(memcg, &locked, &flags);
+	mem_cgroup_end_page_stat(memcg);
 }
 
 /**
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-protect-set_page_dirty-from-ongoing-truncation.patch
mm-memcontrol-switch-soft-limit-default-back-to-infinity.patch
memcg-fix-destination-cgroup-leak-on-task-charges-migration.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-update.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch
mm-page_alloc-place-zone_id-check-before-vm_bug_on_page-check.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok.patch
mm-memcontrol-track-move_lock-state-internally.patch

