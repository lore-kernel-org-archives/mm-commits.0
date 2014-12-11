From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch removed
 from -mm tree
Date: Thu, 11 Dec 2014 10:56:03 -0800
Message-ID: <5489e8c3.Fb3GxZWidimuwARQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758564AbaLKS4E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:56:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, rientjes@google.com, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: continue cache reclaim from offlined groups
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: continue cache reclaim from offlined groups

On cgroup deletion, outstanding page cache charges are moved to the parent
group so that they're not lost and can be reclaimed during pressure
on/inside said parent.  But this reparenting is fairly tricky and its
synchroneous nature has led to several lock-ups in the past.

Since c2931b70a32c ("cgroup: iterate cgroup_subsys_states directly") css
iterators now also include offlined css, so memcg iterators can be changed
to include offlined children during reclaim of a group, and leftover cache
can just stay put.

There is a slight change of behavior in that charges of deleted groups no
longer show up as local charges in the parent.  But they are still
included in the parent's hierarchical statistics.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  218 ----------------------------------------------
 1 file changed, 1 insertion(+), 217 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-continue-cache-reclaim-from-offlined-groups mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-continue-cache-reclaim-from-offlined-groups
+++ a/mm/memcontrol.c
@@ -1132,7 +1132,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		if (css == &root->css)
 			break;
 
-		if (css_tryget_online(css)) {
+		if (css_tryget(css)) {
 			/*
 			 * Make sure the memcg is initialized:
 			 * mem_cgroup_css_online() orders the the
@@ -3316,79 +3316,6 @@ out:
 	return ret;
 }
 
-/**
- * mem_cgroup_move_parent - moves page to the parent group
- * @page: the page to move
- * @pc: page_cgroup of the page
- * @child: page's cgroup
- *
- * move charges to its parent or the root cgroup if the group has no
- * parent (aka use_hierarchy==0).
- * Although this might fail (get_page_unless_zero, isolate_lru_page or
- * mem_cgroup_move_account fails) the failure is always temporary and
- * it signals a race with a page removal/uncharge or migration. In the
- * first case the page is on the way out and it will vanish from the LRU
- * on the next attempt and the call should be retried later.
- * Isolation from the LRU fails only if page has been isolated from
- * the LRU since we looked at it and that usually means either global
- * reclaim or migration going on. The page will either get back to the
- * LRU or vanish.
- * Finaly mem_cgroup_move_account fails only if the page got uncharged
- * (!PageCgroupUsed) or moved to a different group. The page will
- * disappear in the next attempt.
- */
-static int mem_cgroup_move_parent(struct page *page,
-				  struct page_cgroup *pc,
-				  struct mem_cgroup *child)
-{
-	struct mem_cgroup *parent;
-	unsigned int nr_pages;
-	unsigned long uninitialized_var(flags);
-	int ret;
-
-	VM_BUG_ON(mem_cgroup_is_root(child));
-
-	ret = -EBUSY;
-	if (!get_page_unless_zero(page))
-		goto out;
-	if (isolate_lru_page(page))
-		goto put;
-
-	nr_pages = hpage_nr_pages(page);
-
-	parent = parent_mem_cgroup(child);
-	/*
-	 * If no parent, move charges to root cgroup.
-	 */
-	if (!parent)
-		parent = root_mem_cgroup;
-
-	if (nr_pages > 1) {
-		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
-		flags = compound_lock_irqsave(page);
-	}
-
-	ret = mem_cgroup_move_account(page, nr_pages,
-				pc, child, parent);
-	if (!ret) {
-		if (!mem_cgroup_is_root(parent))
-			css_get_many(&parent->css, nr_pages);
-		/* Take charge off the local counters */
-		page_counter_cancel(&child->memory, nr_pages);
-		if (do_swap_account)
-			page_counter_cancel(&child->memsw, nr_pages);
-		css_put_many(&child->css, nr_pages);
-	}
-
-	if (nr_pages > 1)
-		compound_unlock_irqrestore(page, flags);
-	putback_lru_page(page);
-put:
-	put_page(page);
-out:
-	return ret;
-}
-
 #ifdef CONFIG_MEMCG_SWAP
 static void mem_cgroup_swap_statistics(struct mem_cgroup *memcg,
 					 bool charge)
@@ -3682,105 +3609,6 @@ unsigned long mem_cgroup_soft_limit_recl
 	return nr_reclaimed;
 }
 
-/**
- * mem_cgroup_force_empty_list - clears LRU of a group
- * @memcg: group to clear
- * @node: NUMA node
- * @zid: zone id
- * @lru: lru to to clear
- *
- * Traverse a specified page_cgroup list and try to drop them all.  This doesn't
- * reclaim the pages page themselves - pages are moved to the parent (or root)
- * group.
- */
-static void mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
-				int node, int zid, enum lru_list lru)
-{
-	struct lruvec *lruvec;
-	unsigned long flags;
-	struct list_head *list;
-	struct page *busy;
-	struct zone *zone;
-
-	zone = &NODE_DATA(node)->node_zones[zid];
-	lruvec = mem_cgroup_zone_lruvec(zone, memcg);
-	list = &lruvec->lists[lru];
-
-	busy = NULL;
-	do {
-		struct page_cgroup *pc;
-		struct page *page;
-
-		spin_lock_irqsave(&zone->lru_lock, flags);
-		if (list_empty(list)) {
-			spin_unlock_irqrestore(&zone->lru_lock, flags);
-			break;
-		}
-		page = list_entry(list->prev, struct page, lru);
-		if (busy == page) {
-			list_move(&page->lru, list);
-			busy = NULL;
-			spin_unlock_irqrestore(&zone->lru_lock, flags);
-			continue;
-		}
-		spin_unlock_irqrestore(&zone->lru_lock, flags);
-
-		pc = lookup_page_cgroup(page);
-
-		if (mem_cgroup_move_parent(page, pc, memcg)) {
-			/* found lock contention or "pc" is obsolete. */
-			busy = page;
-		} else
-			busy = NULL;
-		cond_resched();
-	} while (!list_empty(list));
-}
-
-/*
- * make mem_cgroup's charge to be 0 if there is no task by moving
- * all the charges and pages to the parent.
- * This enables deleting this mem_cgroup.
- *
- * Caller is responsible for holding css reference on the memcg.
- */
-static void mem_cgroup_reparent_charges(struct mem_cgroup *memcg)
-{
-	int node, zid;
-
-	do {
-		/* This is for making all *used* pages to be on LRU. */
-		lru_add_drain_all();
-		drain_all_stock_sync(memcg);
-		mem_cgroup_start_move(memcg);
-		for_each_node_state(node, N_MEMORY) {
-			for (zid = 0; zid < MAX_NR_ZONES; zid++) {
-				enum lru_list lru;
-				for_each_lru(lru) {
-					mem_cgroup_force_empty_list(memcg,
-							node, zid, lru);
-				}
-			}
-		}
-		mem_cgroup_end_move(memcg);
-		memcg_oom_recover(memcg);
-		cond_resched();
-
-		/*
-		 * Kernel memory may not necessarily be trackable to a specific
-		 * process. So they are not migrated, and therefore we can't
-		 * expect their value to drop to 0 here.
-		 * Having res filled up with kmem only is enough.
-		 *
-		 * This is a safety check because mem_cgroup_force_empty_list
-		 * could have raced with mem_cgroup_replace_page_cache callers
-		 * so the lru seemed empty but the page could have been added
-		 * right after the check. RES_USAGE should be safe as we always
-		 * charge before adding to the LRU.
-		 */
-	} while (page_counter_read(&memcg->memory) -
-		 page_counter_read(&memcg->kmem) > 0);
-}
-
 /*
  * Test whether @memcg has children, dead or alive.  Note that this
  * function doesn't care whether @memcg has use_hierarchy enabled and
@@ -5323,7 +5151,6 @@ static void mem_cgroup_css_offline(struc
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 	struct mem_cgroup_event *event, *tmp;
-	struct cgroup_subsys_state *iter;
 
 	/*
 	 * Unregister events and notify userspace.
@@ -5337,13 +5164,6 @@ static void mem_cgroup_css_offline(struc
 	}
 	spin_unlock(&memcg->event_list_lock);
 
-	/*
-	 * This requires that offlining is serialized.  Right now that is
-	 * guaranteed because css_killed_work_fn() holds the cgroup_mutex.
-	 */
-	css_for_each_descendant_post(iter, css)
-		mem_cgroup_reparent_charges(mem_cgroup_from_css(iter));
-
 	memcg_unregister_all_caches(memcg);
 	vmpressure_cleanup(&memcg->vmpressure);
 }
@@ -5351,42 +5171,6 @@ static void mem_cgroup_css_offline(struc
 static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
-	/*
-	 * XXX: css_offline() would be where we should reparent all
-	 * memory to prepare the cgroup for destruction.  However,
-	 * memcg does not do css_tryget_online() and page_counter charging
-	 * under the same RCU lock region, which means that charging
-	 * could race with offlining.  Offlining only happens to
-	 * cgroups with no tasks in them but charges can show up
-	 * without any tasks from the swapin path when the target
-	 * memcg is looked up from the swapout record and not from the
-	 * current task as it usually is.  A race like this can leak
-	 * charges and put pages with stale cgroup pointers into
-	 * circulation:
-	 *
-	 * #0                        #1
-	 *                           lookup_swap_cgroup_id()
-	 *                           rcu_read_lock()
-	 *                           mem_cgroup_lookup()
-	 *                           css_tryget_online()
-	 *                           rcu_read_unlock()
-	 * disable css_tryget_online()
-	 * call_rcu()
-	 *   offline_css()
-	 *     reparent_charges()
-	 *                           page_counter_try_charge()
-	 *                           css_put()
-	 *                             css_free()
-	 *                           pc->mem_cgroup = dead memcg
-	 *                           add page to lru
-	 *
-	 * The bulk of the charges are still moved in offline_css() to
-	 * avoid pinning a lot of pages in case a long-term reference
-	 * like a swapout record is deferring the css_free() to long
-	 * after offlining.  But this makes sure we catch any charges
-	 * made after offlining:
-	 */
-	mem_cgroup_reparent_charges(memcg);
 
 	memcg_destroy_kmem(memcg);
 	__mem_cgroup_free(memcg);
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

