From: akpm@linux-foundation.org
Subject: [folded] memcg-fix-percpu-cached-charge-draining-frequency-v6.patch removed from -mm tree
Date: Wed, 15 Jun 2011 15:04:51 -0700
Message-ID: <201106152204.p5FM4pCB022209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751958Ab1FOWF1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jun 2011 18:05:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg-fix-percpu-cached-charge-draining-frequency-v6
has been removed from the -mm tree.  Its filename was
     memcg-fix-percpu-cached-charge-draining-frequency-v6.patch

This patch was dropped because it was folded into memcg-fix-percpu-cached-charge-draining-frequency.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-fix-percpu-cached-charge-draining-frequency-v6
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

  - removed unnecessary rcu_read_lock()
  - removed a fix for softlimit case (move to another independent patch)
  - make mutex static.
  - applied comment updates from Andrew Morton.

Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-percpu-cached-charge-draining-frequency-v6 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-percpu-cached-charge-draining-frequency-v6
+++ a/mm/memcontrol.c
@@ -1670,7 +1670,7 @@ static int mem_cgroup_hierarchical_recla
 		victim = mem_cgroup_select_victim(root_mem);
 		if (victim == root_mem) {
 			loop++;
-			if (!check_soft && loop >= 1)
+			if (loop >= 1)
 				drain_all_stock_async(root_mem);
 			if (loop >= 2) {
 				/*
@@ -2021,7 +2021,6 @@ static void drain_all_stock_async(struct
 		return;
 	/* Notify other cpus that system-wide "drain" is running */
 	get_online_cpus();
-
 	/*
 	 * Get a hint for avoiding draining charges on the current cpu,
 	 * which must be exhausted by our charging.  It is not required that
@@ -2043,12 +2042,8 @@ static void drain_all_stock_async(struct
 			if (!root_mem->use_hierarchy)
 				continue;
 			/* check whether "mem" is under tree of "root_mem" */
-			rcu_read_lock();
-			if (!css_is_ancestor(&mem->css, &root_mem->css)) {
-				rcu_read_unlock();
+			if (!css_is_ancestor(&mem->css, &root_mem->css))
 				continue;
-			}
-			rcu_read_unlock();
 		}
 		if (!test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
 			schedule_work_on(cpu, &stock->work);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

vmscanmemcg-memcg-aware-swap-token.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
memcg-add-documentation-for-the-memorynumastat-api.patch
mm-increase-reclaim_distance-to-30.patch
mm-fix-wrong-kunmap_atomic-pointer.patch
mm-memory_hotplugc-fix-building-of-node-hotplug-zonelist.patch
mm-memorynuma_stat-fix-file-permission.patch
memcg-fix-init_page_cgroup-nid-with-sparsemem.patch
memcg-clear-mm-owner-when-last-possible-owner-leaves.patch
memcg-fix-wrong-check-of-noswap-with-softlimit.patch
memcg-fix-percpu-cached-charge-draining-frequency.patch
memcg-avoid-percpu-cached-charge-draining-at-softlimit.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch

