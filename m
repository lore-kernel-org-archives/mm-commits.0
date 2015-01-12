From: akpm@linux-foundation.org
Subject: [merged]
 memcg-fix-destination-cgroup-leak-on-task-charges-migration.patch removed
 from -mm tree
Date: Mon, 12 Jan 2015 11:33:29 -0800
Message-ID: <54b42189.IjGxF/AEf+eDf/j0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbbALTda (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 14:33:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix destination cgroup leak on task charges migration
has been removed from the -mm tree.  Its filename was
     memcg-fix-destination-cgroup-leak-on-task-charges-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: fix destination cgroup leak on task charges migration

We are supposed to take one css reference per each memory page and per
each swap entry accounted to a memory cgroup.  However, during task
charges migration we take a reference to the destination cgroup twice per
each swap entry: first in mem_cgroup_do_precharge()->try_charge() and then
in mem_cgroup_move_swap_account(), permanently leaking the destination
cgroup.

The hunk taking the second reference seems to be a leftover from the
pre-00501b531c472 ("mm: memcontrol: rewrite charge API") era.  Remove it
to fix the leak.

Fixes: e8ea14cc6ead (mm: memcontrol: take a css reference for each charged page)
Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-destination-cgroup-leak-on-task-charges-migration mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-destination-cgroup-leak-on-task-charges-migration
+++ a/mm/memcontrol.c
@@ -3043,18 +3043,6 @@ static int mem_cgroup_move_swap_account(
 	if (swap_cgroup_cmpxchg(entry, old_id, new_id) == old_id) {
 		mem_cgroup_swap_statistics(from, false);
 		mem_cgroup_swap_statistics(to, true);
-		/*
-		 * This function is only called from task migration context now.
-		 * It postpones page_counter and refcount handling till the end
-		 * of task migration(mem_cgroup_clear_mc()) for performance
-		 * improvement. But we cannot postpone css_get(to)  because if
-		 * the process that has been moved to @to does swap-in, the
-		 * refcount of @to might be decreased to 0.
-		 *
-		 * We are in attach() phase, so the cgroup is guaranteed to be
-		 * alive, so we can just call css_get().
-		 */
-		css_get(&to->css);
 		return 0;
 	}
 	return -EINVAL;
_

Patches currently in -mm which might be from vdavydov@parallels.com are

memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
mm-memcontrol-track-move_lock-state-internally.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
vmscan-force-scan-offline-memory-cgroups.patch

