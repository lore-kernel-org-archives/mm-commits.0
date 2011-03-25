From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-memcg-reclaim_param_lock.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:24:53 -0700
Message-ID: <201103250724.p2P7OllN025957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933706Ab1CYHZB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:25:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: remove memcg->reclaim_param_lock
has been removed from the -mm tree.  Its filename was
     memcg-remove-memcg-reclaim_param_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: remove memcg->reclaim_param_lock
From: Johannes Weiner <hannes@cmpxchg.org>

The reclaim_param_lock is only taken around single reads and writes to
integer variables and is thus superfluous.  Drop it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-memcg-reclaim_param_lock mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-memcg-reclaim_param_lock
+++ a/mm/memcontrol.c
@@ -218,12 +218,6 @@ struct mem_cgroup {
 	 * per zone LRU lists.
 	 */
 	struct mem_cgroup_lru_info info;
-
-	/*
-	  protect against reclaim related member.
-	*/
-	spinlock_t reclaim_param_lock;
-
 	/*
 	 * While reclaiming in a hierarchy, we cache the last child we
 	 * reclaimed from.
@@ -1130,17 +1124,12 @@ static unsigned long long mem_cgroup_mar
 static unsigned int get_swappiness(struct mem_cgroup *memcg)
 {
 	struct cgroup *cgrp = memcg->css.cgroup;
-	unsigned int swappiness;
 
 	/* root ? */
 	if (cgrp->parent == NULL)
 		return vm_swappiness;
 
-	spin_lock(&memcg->reclaim_param_lock);
-	swappiness = memcg->swappiness;
-	spin_unlock(&memcg->reclaim_param_lock);
-
-	return swappiness;
+	return memcg->swappiness;
 }
 
 static void mem_cgroup_start_move(struct mem_cgroup *mem)
@@ -1356,13 +1345,11 @@ mem_cgroup_select_victim(struct mem_cgro
 
 		rcu_read_unlock();
 		/* Updates scanning parameter */
-		spin_lock(&root_mem->reclaim_param_lock);
 		if (!css) {
 			/* this means start scan from ID:1 */
 			root_mem->last_scanned_child = 0;
 		} else
 			root_mem->last_scanned_child = found;
-		spin_unlock(&root_mem->reclaim_param_lock);
 	}
 
 	return ret;
@@ -3868,9 +3855,7 @@ static int mem_cgroup_swappiness_write(s
 		return -EINVAL;
 	}
 
-	spin_lock(&memcg->reclaim_param_lock);
 	memcg->swappiness = val;
-	spin_unlock(&memcg->reclaim_param_lock);
 
 	cgroup_unlock();
 
@@ -4526,7 +4511,6 @@ mem_cgroup_create(struct cgroup_subsys *
 		res_counter_init(&mem->memsw, NULL);
 	}
 	mem->last_scanned_child = 0;
-	spin_lock_init(&mem->reclaim_param_lock);
 	INIT_LIST_HEAD(&mem->oom_notify);
 
 	if (parent)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-add-vm-counters-for-transparent-hugepages.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch

