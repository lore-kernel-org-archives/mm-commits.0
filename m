Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89007156962
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854881; cv=none; b=p7W2qVCfjPRDQ+X2NFevadzeglc7FTgdgFaNzknpy6S0mEtPD7jikqcPVhVCFfaeZ2gGcSI9rzFVxXath2QwGJRJeA6Q3eDd1x1iYsYdxbf1sUQRsP6ppeTH2XWvY7nQMewH5cJYu+U1yo5VB14cwoj9PMzGVIQnQjGp5P4xYio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854881; c=relaxed/simple;
	bh=FhIhupD/9XTIcjv44/Ds6GzRhqsaVo6QcdajIW05B+k=;
	h=Date:To:From:Subject:Message-Id; b=HcYwWIhskCxm/NLHLkuWE75nxSSVF5pcy/r0tQ7t4rK+hIvIMqdRs6mS96q4AXLpbJVs1s4YOgNuLWjSTEqSZk/fkHbZTCt05vhK4pghwOk8RaIj7opJ+wcD010DSJ9uiDPDCLhB0NZYldK9Q5v5Zd+/iaob3drIOYCC2khoCmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U/6LgIS6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U/6LgIS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E85C4CECF;
	Wed,  6 Nov 2024 01:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854880;
	bh=FhIhupD/9XTIcjv44/Ds6GzRhqsaVo6QcdajIW05B+k=;
	h=Date:To:From:Subject:From;
	b=U/6LgIS6KavsQlTPj9MP8khmNaYmE6aPxU3vgDhAEdl29ubGubOR78plhvdt1iok7
	 I+oPdl7NV2TshlHdp2iILVfEFa1BQK3skmpDVA1D6ntlSSQoO7EI4ZGHFfEOWuY8ez
	 zzWLpBvvvSx7qkblnBJpCo7Hr0M6lDCyC/dx7mkU=
Date: Tue, 05 Nov 2024 17:01:19 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hughd@google.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-v1-remove-memcg-move-locking-code.patch removed from -mm tree
Message-Id: <20241106010120.06E85C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg-v1: remove memcg move locking code
has been removed from the -mm tree.  Its filename was
     memcg-v1-remove-memcg-move-locking-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg-v1: remove memcg move locking code
Date: Thu, 24 Oct 2024 18:23:03 -0700

The memcg v1's charge move feature has been deprecated.  All the places
using the memcg move lock, have stopped using it as they don't need the
protection any more.  Let's proceed to remove all the locking code related
to charge moving.

Link: https://lkml.kernel.org/r/20241025012304.2473312-7-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   54 -----------------------
 mm/filemap.c               |    1 
 mm/memcontrol-v1.c         |   82 -----------------------------------
 mm/memcontrol.c            |    5 --
 mm/rmap.c                  |    1 
 5 files changed, 143 deletions(-)

--- a/include/linux/memcontrol.h~memcg-v1-remove-memcg-move-locking-code
+++ a/include/linux/memcontrol.h
@@ -299,20 +299,10 @@ struct mem_cgroup {
 	/* For oom notifier event fd */
 	struct list_head oom_notify;
 
-	/* taken only while moving_account > 0 */
-	spinlock_t move_lock;
-	unsigned long move_lock_flags;
-
 	/* Legacy tcp memory accounting */
 	bool tcpmem_active;
 	int tcpmem_pressure;
 
-	/*
-	 * set > 0 if pages under this cgroup are moving to other cgroup.
-	 */
-	atomic_t moving_account;
-	struct task_struct *move_lock_task;
-
 	/* List of events which userspace want to receive */
 	struct list_head event_list;
 	spinlock_t event_list_lock;
@@ -428,9 +418,7 @@ static inline struct obj_cgroup *__folio
  *
  * - the folio lock
  * - LRU isolation
- * - folio_memcg_lock()
  * - exclusive reference
- * - mem_cgroup_trylock_pages()
  *
  * For a kmem folio a caller should hold an rcu read lock to protect memcg
  * associated with a kmem folio from being released.
@@ -499,9 +487,7 @@ static inline struct mem_cgroup *folio_m
  *
  * - the folio lock
  * - LRU isolation
- * - lock_folio_memcg()
  * - exclusive reference
- * - mem_cgroup_trylock_pages()
  *
  * For a kmem folio a caller should hold an rcu read lock to protect memcg
  * associated with a kmem folio from being released.
@@ -1873,26 +1859,6 @@ static inline bool task_in_memcg_oom(str
 	return p->memcg_in_oom;
 }
 
-void folio_memcg_lock(struct folio *folio);
-void folio_memcg_unlock(struct folio *folio);
-
-/* try to stablize folio_memcg() for all the pages in a memcg */
-static inline bool mem_cgroup_trylock_pages(struct mem_cgroup *memcg)
-{
-	rcu_read_lock();
-
-	if (mem_cgroup_disabled() || !atomic_read(&memcg->moving_account))
-		return true;
-
-	rcu_read_unlock();
-	return false;
-}
-
-static inline void mem_cgroup_unlock_pages(void)
-{
-	rcu_read_unlock();
-}
-
 static inline void mem_cgroup_enter_user_fault(void)
 {
 	WARN_ON(current->in_user_fault);
@@ -1914,26 +1880,6 @@ unsigned long memcg1_soft_limit_reclaim(
 	return 0;
 }
 
-static inline void folio_memcg_lock(struct folio *folio)
-{
-}
-
-static inline void folio_memcg_unlock(struct folio *folio)
-{
-}
-
-static inline bool mem_cgroup_trylock_pages(struct mem_cgroup *memcg)
-{
-	/* to match folio_memcg_rcu() */
-	rcu_read_lock();
-	return true;
-}
-
-static inline void mem_cgroup_unlock_pages(void)
-{
-	rcu_read_unlock();
-}
-
 static inline bool task_in_memcg_oom(struct task_struct *p)
 {
 	return false;
--- a/mm/filemap.c~memcg-v1-remove-memcg-move-locking-code
+++ a/mm/filemap.c
@@ -119,7 +119,6 @@
  *    ->i_pages lock		(folio_remove_rmap_pte->set_page_dirty)
  *    bdi.wb->list_lock		(folio_remove_rmap_pte->set_page_dirty)
  *    ->inode->i_lock		(folio_remove_rmap_pte->set_page_dirty)
- *    ->memcg->move_lock	(folio_remove_rmap_pte->folio_memcg_lock)
  *    bdi.wb->list_lock		(zap_pte_range->set_page_dirty)
  *    ->inode->i_lock		(zap_pte_range->set_page_dirty)
  *    ->private_lock		(zap_pte_range->block_dirty_folio)
--- a/mm/memcontrol.c~memcg-v1-remove-memcg-move-locking-code
+++ a/mm/memcontrol.c
@@ -1189,7 +1189,6 @@ void lruvec_memcg_debug(struct lruvec *l
  * These functions are safe to use under any of the following conditions:
  * - folio locked
  * - folio_test_lru false
- * - folio_memcg_lock()
  * - folio frozen (refcount of 0)
  *
  * Return: The lruvec this folio is on with its lock held.
@@ -1211,7 +1210,6 @@ struct lruvec *folio_lruvec_lock(struct
  * These functions are safe to use under any of the following conditions:
  * - folio locked
  * - folio_test_lru false
- * - folio_memcg_lock()
  * - folio frozen (refcount of 0)
  *
  * Return: The lruvec this folio is on with its lock held and interrupts
@@ -1235,7 +1233,6 @@ struct lruvec *folio_lruvec_lock_irq(str
  * These functions are safe to use under any of the following conditions:
  * - folio locked
  * - folio_test_lru false
- * - folio_memcg_lock()
  * - folio frozen (refcount of 0)
  *
  * Return: The lruvec this folio is on with its lock held and interrupts
@@ -2375,9 +2372,7 @@ static void commit_charge(struct folio *
 	 *
 	 * - the page lock
 	 * - LRU isolation
-	 * - folio_memcg_lock()
 	 * - exclusive reference
-	 * - mem_cgroup_trylock_pages()
 	 */
 	folio->memcg_data = (unsigned long)memcg;
 }
--- a/mm/memcontrol-v1.c~memcg-v1-remove-memcg-move-locking-code
+++ a/mm/memcontrol-v1.c
@@ -401,87 +401,6 @@ unsigned long memcg1_soft_limit_reclaim(
 	return nr_reclaimed;
 }
 
-/**
- * folio_memcg_lock - Bind a folio to its memcg.
- * @folio: The folio.
- *
- * This function prevents unlocked LRU folios from being moved to
- * another cgroup.
- *
- * It ensures lifetime of the bound memcg.  The caller is responsible
- * for the lifetime of the folio.
- */
-void folio_memcg_lock(struct folio *folio)
-{
-	struct mem_cgroup *memcg;
-	unsigned long flags;
-
-	/*
-	 * The RCU lock is held throughout the transaction.  The fast
-	 * path can get away without acquiring the memcg->move_lock
-	 * because page moving starts with an RCU grace period.
-         */
-	rcu_read_lock();
-
-	if (mem_cgroup_disabled())
-		return;
-again:
-	memcg = folio_memcg(folio);
-	if (unlikely(!memcg))
-		return;
-
-#ifdef CONFIG_PROVE_LOCKING
-	local_irq_save(flags);
-	might_lock(&memcg->move_lock);
-	local_irq_restore(flags);
-#endif
-
-	if (atomic_read(&memcg->moving_account) <= 0)
-		return;
-
-	spin_lock_irqsave(&memcg->move_lock, flags);
-	if (memcg != folio_memcg(folio)) {
-		spin_unlock_irqrestore(&memcg->move_lock, flags);
-		goto again;
-	}
-
-	/*
-	 * When charge migration first begins, we can have multiple
-	 * critical sections holding the fast-path RCU lock and one
-	 * holding the slowpath move_lock. Track the task who has the
-	 * move_lock for folio_memcg_unlock().
-	 */
-	memcg->move_lock_task = current;
-	memcg->move_lock_flags = flags;
-}
-
-static void __folio_memcg_unlock(struct mem_cgroup *memcg)
-{
-	if (memcg && memcg->move_lock_task == current) {
-		unsigned long flags = memcg->move_lock_flags;
-
-		memcg->move_lock_task = NULL;
-		memcg->move_lock_flags = 0;
-
-		spin_unlock_irqrestore(&memcg->move_lock, flags);
-	}
-
-	rcu_read_unlock();
-}
-
-/**
- * folio_memcg_unlock - Release the binding between a folio and its memcg.
- * @folio: The folio.
- *
- * This releases the binding created by folio_memcg_lock().  This does
- * not change the accounting of this folio to its memcg, but it does
- * permit others to change it.
- */
-void folio_memcg_unlock(struct folio *folio)
-{
-	__folio_memcg_unlock(folio_memcg(folio));
-}
-
 static u64 mem_cgroup_move_charge_read(struct cgroup_subsys_state *css,
 				struct cftype *cft)
 {
@@ -1189,7 +1108,6 @@ void memcg1_memcg_init(struct mem_cgroup
 {
 	INIT_LIST_HEAD(&memcg->oom_notify);
 	mutex_init(&memcg->thresholds_lock);
-	spin_lock_init(&memcg->move_lock);
 	INIT_LIST_HEAD(&memcg->event_list);
 	spin_lock_init(&memcg->event_list_lock);
 }
--- a/mm/rmap.c~memcg-v1-remove-memcg-move-locking-code
+++ a/mm/rmap.c
@@ -32,7 +32,6 @@
  *                   swap_lock (in swap_duplicate, swap_info_get)
  *                     mmlist_lock (in mmput, drain_mmlist and others)
  *                     mapping->private_lock (in block_dirty_folio)
- *                       folio_lock_memcg move_lock (in block_dirty_folio)
  *                         i_pages lock (widely used)
  *                           lruvec->lru_lock (in folio_lruvec_lock_irq)
  *                     inode->i_lock (in set_page_dirty's __mark_inode_dirty)
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


