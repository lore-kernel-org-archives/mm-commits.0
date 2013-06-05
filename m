From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-factor-out-reclaim-iterator-loading-and-updating.patch added
 to -mm tree
Date: Wed, 05 Jun 2013 16:05:18 -0700
Message-ID: <51afc42e.tZ5k4vfXcwC9gb0Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773Ab3FEXFT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jun 2013 19:05:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, glommer@parallels.com, hannes@cmpxchg.org

Subject: + mm-memcontrol-factor-out-reclaim-iterator-loading-and-updating.patch added to -mm tree
To: hannes@cmpxchg.org,glommer@parallels.com,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,tj@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 05 Jun 2013 16:05:18 -0700


The patch titled
     Subject: mm: memcontrol: factor out reclaim iterator loading and updating
has been added to the -mm tree.  Its filename is
     mm-memcontrol-factor-out-reclaim-iterator-loading-and-updating.patch

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
Subject: mm: memcontrol: factor out reclaim iterator loading and updating

mem_cgroup_iter() is too hard to follow.  Factor out the lockless reclaim
iterator loading and updating so it's easier to follow the big picture.

Also document the iterator invalidation mechanism a bit more extensively.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   86 ++++++++++++++++++++++++++++++----------------
 1 file changed, 57 insertions(+), 29 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-factor-out-reclaim-iterator-loading-and-updating mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-factor-out-reclaim-iterator-loading-and-updating
+++ a/mm/memcontrol.c
@@ -1148,6 +1148,58 @@ skip_node:
 	return NULL;
 }
 
+static void mem_cgroup_iter_invalidate(struct mem_cgroup *root)
+{
+	/*
+	 * When a group in the hierarchy below root is destroyed, the
+	 * hierarchy iterator can no longer be trusted since it might
+	 * have pointed to the destroyed group.  Invalidate it.
+	 */
+	atomic_inc(&root->dead_count);
+}
+
+static struct mem_cgroup *
+mem_cgroup_iter_load(struct mem_cgroup_reclaim_iter *iter,
+		     struct mem_cgroup *root,
+		     int *sequence)
+{
+	struct mem_cgroup *position = NULL;
+	/*
+	 * A cgroup destruction happens in two stages: offlining and
+	 * release.  They are separated by a RCU grace period.
+	 *
+	 * If the iterator is valid, we may still race with an
+	 * offlining.  The RCU lock ensures the object won't be
+	 * released, tryget will fail if we lost the race.
+	 */
+	*sequence = atomic_read(&root->dead_count);
+	if (iter->last_dead_count == *sequence) {
+		smp_rmb();
+		position = iter->last_visited;
+		if (position && !css_tryget(&position->css))
+			position = NULL;
+	}
+	return position;
+}
+
+static void mem_cgroup_iter_update(struct mem_cgroup_reclaim_iter *iter,
+				   struct mem_cgroup *last_visited,
+				   struct mem_cgroup *new_position,
+				   int sequence)
+{
+	if (last_visited)
+		css_put(&last_visited->css);
+	/*
+	 * We store the sequence count from the time @last_visited was
+	 * loaded successfully instead of rereading it here so that we
+	 * don't lose destruction events in between.  We could have
+	 * raced with the destruction of @new_position after all.
+	 */
+	iter->last_visited = new_position;
+	smp_wmb();
+	iter->last_dead_count = sequence;
+}
+
 /**
  * mem_cgroup_iter - iterate over memory cgroup hierarchy
  * @root: hierarchy root
@@ -1171,7 +1223,6 @@ struct mem_cgroup *mem_cgroup_iter(struc
 {
 	struct mem_cgroup *memcg = NULL;
 	struct mem_cgroup *last_visited = NULL;
-	unsigned long uninitialized_var(dead_count);
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -1191,6 +1242,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 	rcu_read_lock();
 	while (!memcg) {
 		struct mem_cgroup_reclaim_iter *uninitialized_var(iter);
+		int uninitialized_var(seq);
 
 		if (reclaim) {
 			int nid = zone_to_nid(reclaim->zone);
@@ -1204,37 +1256,13 @@ struct mem_cgroup *mem_cgroup_iter(struc
 				goto out_unlock;
 			}
 
-			/*
-			 * If the dead_count mismatches, a destruction
-			 * has happened or is happening concurrently.
-			 * If the dead_count matches, a destruction
-			 * might still happen concurrently, but since
-			 * we checked under RCU, that destruction
-			 * won't free the object until we release the
-			 * RCU reader lock.  Thus, the dead_count
-			 * check verifies the pointer is still valid,
-			 * css_tryget() verifies the cgroup pointed to
-			 * is alive.
-			 */
-			dead_count = atomic_read(&root->dead_count);
-			if (dead_count == iter->last_dead_count) {
-				smp_rmb();
-				last_visited = iter->last_visited;
-				if (last_visited &&
-				    !css_tryget(&last_visited->css))
-					last_visited = NULL;
-			}
+			last_visited = mem_cgroup_iter_load(iter, root, &seq);
 		}
 
 		memcg = __mem_cgroup_iter_next(root, last_visited);
 
 		if (reclaim) {
-			if (last_visited)
-				css_put(&last_visited->css);
-
-			iter->last_visited = memcg;
-			smp_wmb();
-			iter->last_dead_count = dead_count;
+			mem_cgroup_iter_update(iter, last_visited, memcg, seq);
 
 			if (!memcg)
 				iter->generation++;
@@ -6317,14 +6345,14 @@ static void mem_cgroup_invalidate_reclai
 	struct mem_cgroup *parent = memcg;
 
 	while ((parent = parent_mem_cgroup(parent)))
-		atomic_inc(&parent->dead_count);
+		mem_cgroup_iter_invalidate(parent);
 
 	/*
 	 * if the root memcg is not hierarchical we have to check it
 	 * explicitely.
 	 */
 	if (!root_mem_cgroup->use_hierarchy)
-		atomic_inc(&root_mem_cgroup->dead_count);
+		mem_cgroup_iter_invalidate(root_mem_cgroup);
 }
 
 static void mem_cgroup_css_offline(struct cgroup *cont)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

memcg-dont-initialize-kmem-cache-destroying-work-for-root-caches.patch
swap-avoid-read_swap_cache_async-race-to-deadlock-while-waiting-on-discard-i-o-completion.patch
mm-memcontrol-fix-lockless-reclaim-hierarchy-iterator.patch
mm-memcontrol-factor-out-reclaim-iterator-loading-and-updating.patch
mm-memcg-dont-take-task_lock-in-task_in_mem_cgroup.patch
mm-vmscan-limit-the-number-of-pages-kswapd-reclaims-at-each-priority.patch
mm-vmscan-obey-proportional-scanning-requirements-for-kswapd.patch
mm-vmscan-flatten-kswapd-priority-loop.patch
mm-vmscan-decide-whether-to-compact-the-pgdat-based-on-reclaim-progress.patch
mm-vmscan-do-not-allow-kswapd-to-scan-at-maximum-priority.patch
mm-vmscan-have-kswapd-writeback-pages-based-on-dirty-pages-encountered-not-priority.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix.patch
mm-vmscan-check-if-kswapd-should-writepage-once-per-pgdat-scan.patch
mm-vmscan-move-logic-from-balance_pgdat-to-kswapd_shrink_zone.patch
mm-vmscan-stall-page-reclaim-and-writeback-pages-based-on-dirty-writepage-pages-encountered-v3.patch
mm-vmscan-stall-page-reclaim-after-a-list-of-pages-have-been-processed-v3.patch
mm-vmscan-set-zone-flags-before-blocking.patch
mm-vmscan-move-direct-reclaim-wait_iff_congested-into-shrink_list.patch
mm-vmscan-treat-pages-marked-for-immediate-reclaim-as-zone-congestion.patch
mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account-v3.patch
fs-nfs-inform-the-vm-about-pages-being-committed-or-unstable.patch
memcg-update-todo-list-in-documentation.patch
mm-add-tracepoints-for-lru-activation-and-insertions.patch
mm-pagevec-defer-deciding-what-lru-to-add-a-page-to-until-pagevec-drain-time.patch
mm-activate-pagelru-pages-on-mark_page_accessed-if-page-is-on-local-pagevec.patch
mm-remove-lru-parameter-from-__pagevec_lru_add-and-remove-parts-of-pagevec-api.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
memcg-kconfig-info-update.patch
mm-kill-free_all_bootmem_node.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
list_lru-per-node-api.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
vmscan-also-shrink-slab-in-memcg-pressure.patch
memcglist_lru-duplicate-lrus-upon-kmemcg-creation.patch
lru-add-an-element-to-a-memcg-list.patch
list_lru-per-memcg-walks.patch
memcg-per-memcg-kmem-shrinking.patch
memcg-scan-cache-objects-hierarchically.patch
vmscan-take-at-least-one-pass-with-shrinkers.patch
super-targeted-memcg-reclaim.patch
memcg-move-initialization-to-memcg-creation.patch
vmpressure-in-kernel-notifications.patch
memcg-reap-dead-memcgs-upon-global-memory-pressure.patch
mm-memmap_init_zone-performance-improvement.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

