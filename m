From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-drop-bogus-rcu-locking-from-mem_cgroup_same_or_subtree.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:57:31 -0800
Message-ID: <5489e91b.JVeAjjVY9FZpopH0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758406AbaLKS5c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:57:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: drop bogus RCU locking from mem_cgroup_same_or_subtree()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-drop-bogus-rcu-locking-from-mem_cgroup_same_or_subtree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: drop bogus RCU locking from mem_cgroup_same_or_subtree()

None of the mem_cgroup_same_or_subtree() callers actually require it to
take the RCU lock, either because they hold it themselves or they have css
references.  Remove it.

To make the API change clear, rename the leftover helper to
mem_cgroup_is_descendant() to match cgroup_is_descendant().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   13 +++----
 mm/memcontrol.c            |   59 +++++++++--------------------------
 mm/oom_kill.c              |    4 +-
 3 files changed, 24 insertions(+), 52 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-drop-bogus-rcu-locking-from-mem_cgroup_same_or_subtree include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-drop-bogus-rcu-locking-from-mem_cgroup_same_or_subtree
+++ a/include/linux/memcontrol.h
@@ -68,10 +68,9 @@ void mem_cgroup_migrate(struct page *old
 struct lruvec *mem_cgroup_zone_lruvec(struct zone *, struct mem_cgroup *);
 struct lruvec *mem_cgroup_page_lruvec(struct page *, struct zone *);
 
-bool __mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
-				  struct mem_cgroup *memcg);
-bool task_in_mem_cgroup(struct task_struct *task,
-			const struct mem_cgroup *memcg);
+bool mem_cgroup_is_descendant(struct mem_cgroup *memcg,
+			      struct mem_cgroup *root);
+bool task_in_mem_cgroup(struct task_struct *task, struct mem_cgroup *memcg);
 
 extern struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page);
 extern struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
@@ -79,8 +78,8 @@ extern struct mem_cgroup *mem_cgroup_fro
 extern struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *memcg);
 extern struct mem_cgroup *mem_cgroup_from_css(struct cgroup_subsys_state *css);
 
-static inline
-bool mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *memcg)
+static inline bool mm_match_cgroup(struct mm_struct *mm,
+				   struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *task_memcg;
 	bool match = false;
@@ -88,7 +87,7 @@ bool mm_match_cgroup(const struct mm_str
 	rcu_read_lock();
 	task_memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
 	if (task_memcg)
-		match = __mem_cgroup_same_or_subtree(memcg, task_memcg);
+		match = mem_cgroup_is_descendant(task_memcg, memcg);
 	rcu_read_unlock();
 	return match;
 }
diff -puN mm/memcontrol.c~mm-memcontrol-drop-bogus-rcu-locking-from-mem_cgroup_same_or_subtree mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-drop-bogus-rcu-locking-from-mem_cgroup_same_or_subtree
+++ a/mm/memcontrol.c
@@ -1328,41 +1328,24 @@ void mem_cgroup_update_lru_size(struct l
 	VM_BUG_ON((long)(*lru_size) < 0);
 }
 
-/*
- * Checks whether given mem is same or in the root_mem_cgroup's
- * hierarchy subtree
- */
-bool __mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
-				  struct mem_cgroup *memcg)
+bool mem_cgroup_is_descendant(struct mem_cgroup *memcg, struct mem_cgroup *root)
 {
-	if (root_memcg == memcg)
+	if (root == memcg)
 		return true;
-	if (!root_memcg->use_hierarchy)
+	if (!root->use_hierarchy)
 		return false;
-	return cgroup_is_descendant(memcg->css.cgroup, root_memcg->css.cgroup);
-}
-
-static bool mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
-				       struct mem_cgroup *memcg)
-{
-	bool ret;
-
-	rcu_read_lock();
-	ret = __mem_cgroup_same_or_subtree(root_memcg, memcg);
-	rcu_read_unlock();
-	return ret;
+	return cgroup_is_descendant(memcg->css.cgroup, root->css.cgroup);
 }
 
-bool task_in_mem_cgroup(struct task_struct *task,
-			const struct mem_cgroup *memcg)
+bool task_in_mem_cgroup(struct task_struct *task, struct mem_cgroup *memcg)
 {
-	struct mem_cgroup *curr;
+	struct mem_cgroup *task_memcg;
 	struct task_struct *p;
 	bool ret;
 
 	p = find_lock_task_mm(task);
 	if (p) {
-		curr = get_mem_cgroup_from_mm(p->mm);
+		task_memcg = get_mem_cgroup_from_mm(p->mm);
 		task_unlock(p);
 	} else {
 		/*
@@ -1371,18 +1354,12 @@ bool task_in_mem_cgroup(struct task_stru
 		 * killed to prevent needlessly killing additional tasks.
 		 */
 		rcu_read_lock();
-		curr = mem_cgroup_from_task(task);
-		css_get(&curr->css);
+		task_memcg = mem_cgroup_from_task(task);
+		css_get(&task_memcg->css);
 		rcu_read_unlock();
 	}
-	/*
-	 * We should check use_hierarchy of "memcg" not "curr". Because checking
-	 * use_hierarchy of "curr" here make this function true if hierarchy is
-	 * enabled in "curr" and "curr" is a child of "memcg" in *cgroup*
-	 * hierarchy(even if use_hierarchy is disabled in "memcg").
-	 */
-	ret = mem_cgroup_same_or_subtree(memcg, curr);
-	css_put(&curr->css);
+	ret = mem_cgroup_is_descendant(task_memcg, memcg);
+	css_put(&task_memcg->css);
 	return ret;
 }
 
@@ -1467,8 +1444,8 @@ static bool mem_cgroup_under_move(struct
 	if (!from)
 		goto unlock;
 
-	ret = mem_cgroup_same_or_subtree(memcg, from)
-		|| mem_cgroup_same_or_subtree(memcg, to);
+	ret = mem_cgroup_is_descendant(from, memcg) ||
+		mem_cgroup_is_descendant(to, memcg);
 unlock:
 	spin_unlock(&mc.lock);
 	return ret;
@@ -1900,12 +1877,8 @@ static int memcg_oom_wake_function(wait_
 	oom_wait_info = container_of(wait, struct oom_wait_info, wait);
 	oom_wait_memcg = oom_wait_info->memcg;
 
-	/*
-	 * Both of oom_wait_info->memcg and wake_memcg are stable under us.
-	 * Then we can use css_is_ancestor without taking care of RCU.
-	 */
-	if (!mem_cgroup_same_or_subtree(oom_wait_memcg, wake_memcg)
-		&& !mem_cgroup_same_or_subtree(wake_memcg, oom_wait_memcg))
+	if (!mem_cgroup_is_descendant(wake_memcg, oom_wait_memcg) &&
+	    !mem_cgroup_is_descendant(oom_wait_memcg, wake_memcg))
 		return 0;
 	return autoremove_wake_function(wait, mode, sync, arg);
 }
@@ -2225,7 +2198,7 @@ static void drain_all_stock(struct mem_c
 		memcg = stock->cached;
 		if (!memcg || !stock->nr_pages)
 			continue;
-		if (!mem_cgroup_same_or_subtree(root_memcg, memcg))
+		if (!mem_cgroup_is_descendant(memcg, root_memcg))
 			continue;
 		if (!test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags)) {
 			if (cpu == curcpu)
diff -puN mm/oom_kill.c~mm-memcontrol-drop-bogus-rcu-locking-from-mem_cgroup_same_or_subtree mm/oom_kill.c
--- a/mm/oom_kill.c~mm-memcontrol-drop-bogus-rcu-locking-from-mem_cgroup_same_or_subtree
+++ a/mm/oom_kill.c
@@ -119,7 +119,7 @@ found:
 
 /* return true if the task is not adequate as candidate victim task. */
 static bool oom_unkillable_task(struct task_struct *p,
-		const struct mem_cgroup *memcg, const nodemask_t *nodemask)
+		struct mem_cgroup *memcg, const nodemask_t *nodemask)
 {
 	if (is_global_init(p))
 		return true;
@@ -353,7 +353,7 @@ static struct task_struct *select_bad_pr
  * State information includes task's pid, uid, tgid, vm size, rss, nr_ptes,
  * swapents, oom_score_adj value, and name.
  */
-static void dump_tasks(const struct mem_cgroup *memcg, const nodemask_t *nodemask)
+static void dump_tasks(struct mem_cgroup *memcg, const nodemask_t *nodemask)
 {
 	struct task_struct *p;
 	struct task_struct *task;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
memcg-__mem_cgroup_free-remove-stale-disarm_static_keys-comment.patch
memcg-dont-check-mm-in-__memcg_kmem_get_cachenewpage_charge.patch
memcg-do-not-abuse-memcg_kmem_skip_account.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-mincore-add-hwpoison-page-handle.patch
memcg-zap-kmem_account_flags.patch
memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch
memcg-turn-memcg_kmem_skip_account-into-a-bit-field.patch
mm-move-swp_entry_t-definition-to-include-linux-mm_typesh.patch
mm-gfp-escalatedly-define-gfp_highuser-and-gfp_highuser_movable.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging-fix.patch
mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable-fix.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch
stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch
mm-page_owner-keep-track-of-page-owners.patch
mm-page_owner-correct-owner-information-for-early-allocated-pages.patch
documentation-add-new-page_owner-document.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone-fix.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
mm-memcontrol-fix-defined-but-not-used-compiler-warning.patch
memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache.patch
mm-memcontrolc-cleaning-up-function-that-are-not-used-anywhere.patch

