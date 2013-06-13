From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-fix-lockless-reclaim-hierarchy-iterator.patch removed from
 -mm tree
Date: Thu, 13 Jun 2013 11:58:12 -0700
Message-ID: <51ba1644.qkG1GtU8Zsar6zfc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37147 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758256Ab3FMS6N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 14:58:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, stable@kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, glommer@parallels.com, hannes@cmpxchg.org

Subject: [merged] mm-memcontrol-fix-lockless-reclaim-hierarchy-iterator.patch removed from -mm tree
To: hannes@cmpxchg.org,glommer@parallels.com,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,stable@kernel.org,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 11:58:12 -0700


The patch titled
     Subject: mm: memcontrol: fix lockless reclaim hierarchy iterator
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-lockless-reclaim-hierarchy-iterator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: fix lockless reclaim hierarchy iterator

The lockless reclaim hierarchy iterator currently has a misplaced barrier
that can lead to use-after-free crashes.

The reclaim hierarchy iterator consist of a sequence count and a position
pointer that are read and written locklessly, with memory barriers
enforcing ordering.

The write side sets the position pointer first, then updates the sequence
count to "publish" the new position.  Likewise, the read side must read
the sequence count first, then the position.  If the sequence count is up
to date, it's guaranteed that the position is up to date as well:

  writer:                         reader:
  iter->position = position       if iter->sequence == expected:
  smp_wmb()                           smp_rmb()
  iter->sequence = sequence           position = iter->position

However, the read side barrier is currently misplaced, which can lead to
dereferencing stale position pointers that no longer point to valid
memory.  Fix this.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Tejun Heo <tj@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: <stable@kernel.org>		[3.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fix-lockless-reclaim-hierarchy-iterator mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fix-lockless-reclaim-hierarchy-iterator
+++ a/mm/memcontrol.c
@@ -1199,7 +1199,6 @@ struct mem_cgroup *mem_cgroup_iter(struc
 
 			mz = mem_cgroup_zoneinfo(root, nid, zid);
 			iter = &mz->reclaim_iter[reclaim->priority];
-			last_visited = iter->last_visited;
 			if (prev && reclaim->generation != iter->generation) {
 				iter->last_visited = NULL;
 				goto out_unlock;
@@ -1218,13 +1217,12 @@ struct mem_cgroup *mem_cgroup_iter(struc
 			 * is alive.
 			 */
 			dead_count = atomic_read(&root->dead_count);
-			smp_rmb();
-			last_visited = iter->last_visited;
-			if (last_visited) {
-				if ((dead_count != iter->last_dead_count) ||
-					!css_tryget(&last_visited->css)) {
+			if (dead_count == iter->last_dead_count) {
+				smp_rmb();
+				last_visited = iter->last_visited;
+				if (last_visited &&
+				    !css_tryget(&last_visited->css))
 					last_visited = NULL;
-				}
 			}
 		}
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
mm-memcg-dont-take-task_lock-in-task_in_mem_cgroup.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
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
mm-memcontrol-factor-out-reclaim-iterator-loading-and-updating.patch
memcg-clean-up-memcg-nodeinfo.patch
mm-invoke-oom-killer-from-remaining-unconverted-page-fault-handlers.patch
mm-vmallocc-remove-dead-code-in-vb_alloc.patch
mm-vmallocc-remove-unused-purge_fragmented_blocks_thiscpu.patch
mm-vmallocc-remove-alloc_map-from-vmap_block.patch
memcg-also-test-for-skip-accounting-at-the-page-allocation-level.patch
memcg-do-not-account-memory-used-for-cache-creation.patch
mm-memmap_init_zone-performance-improvement.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

