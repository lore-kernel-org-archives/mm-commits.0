From: akpm@linux-foundation.org
Subject: [merged] memcg-unify-sync-and-async-per-cpu-charge-cache-draining.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:28:18 -0700
Message-ID: <201107271927.p6RJR4AK003181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754890Ab1G0T1L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:27:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: unify sync and async per-cpu charge cache draining
has been removed from the -mm tree.  Its filename was
     memcg-unify-sync-and-async-per-cpu-charge-cache-draining.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: unify sync and async per-cpu charge cache draining
From: Michal Hocko <mhocko@suse.cz>

Currently we have two ways how to drain per-CPU caches for charges. 
drain_all_stock_sync will synchronously drain all caches while
drain_all_stock_async will asynchronously drain only those that refer to a
given memory cgroup or its subtree in hierarchy.  Targeted async draining
has been introduced by 26fe6168 (memcg: fix percpu cached charge draining
frequency) to reduce the cpu workers number.

sync draining is currently triggered only from mem_cgroup_force_empty
which is triggered only by userspace (mem_cgroup_force_empty_write) or
when a cgroup is removed (mem_cgroup_pre_destroy).  Although these are not
usually frequent operations it still makes some sense to do targeted
draining as well, especially if the box has many CPUs.

This patch unifies both methods to use the single code (drain_all_stock)
which relies on the original async implementation and just adds flush_work
to wait on all caches that are still under work for the sync mode.  We are
using FLUSHING_CACHED_CHARGE bit check to prevent from waiting on a work
that we haven't triggered.  Please note that both sync and async functions
are currently protected by percpu_charge_mutex so we cannot race with
other drainers.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   48 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff -puN mm/memcontrol.c~memcg-unify-sync-and-async-per-cpu-charge-cache-draining mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-unify-sync-and-async-per-cpu-charge-cache-draining
+++ a/mm/memcontrol.c
@@ -2154,19 +2154,14 @@ static void refill_stock(struct mem_cgro
 }
 
 /*
- * Tries to drain stocked charges in other cpus. This function is asynchronous
- * and just put a work per cpu for draining localy on each cpu. Caller can
- * expects some charges will be back to res_counter later but cannot wait for
- * it.
+ * Drains all per-CPU charge caches for given root_mem resp. subtree
+ * of the hierarchy under it. sync flag says whether we should block
+ * until the work is done.
  */
-static void drain_all_stock_async(struct mem_cgroup *root_mem)
+static void drain_all_stock(struct mem_cgroup *root_mem, bool sync)
 {
 	int cpu, curcpu;
-	/*
-	 * If someone calls draining, avoid adding more kworker runs.
-	 */
-	if (!mutex_trylock(&percpu_charge_mutex))
-		return;
+
 	/* Notify other cpus that system-wide "drain" is running */
 	get_online_cpus();
 	/*
@@ -2197,17 +2192,42 @@ static void drain_all_stock_async(struct
 				schedule_work_on(cpu, &stock->work);
 		}
 	}
+
+	if (!sync)
+		goto out;
+
+	for_each_online_cpu(cpu) {
+		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
+		if (test_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
+			flush_work(&stock->work);
+	}
+out:
  	put_online_cpus();
+}
+
+/*
+ * Tries to drain stocked charges in other cpus. This function is asynchronous
+ * and just put a work per cpu for draining localy on each cpu. Caller can
+ * expects some charges will be back to res_counter later but cannot wait for
+ * it.
+ */
+static void drain_all_stock_async(struct mem_cgroup *root_mem)
+{
+	/*
+	 * If someone calls draining, avoid adding more kworker runs.
+	 */
+	if (!mutex_trylock(&percpu_charge_mutex))
+		return;
+	drain_all_stock(root_mem, false);
 	mutex_unlock(&percpu_charge_mutex);
-	/* We don't wait for flush_work */
 }
 
 /* This is a synchronous drain interface. */
-static void drain_all_stock_sync(void)
+static void drain_all_stock_sync(struct mem_cgroup *root_mem)
 {
 	/* called when force_empty is called */
 	mutex_lock(&percpu_charge_mutex);
-	schedule_on_each_cpu(drain_local_stock);
+	drain_all_stock(root_mem, true);
 	mutex_unlock(&percpu_charge_mutex);
 }
 
@@ -3856,7 +3876,7 @@ move_account:
 			goto out;
 		/* This is for making all *used* pages to be on LRU. */
 		lru_add_drain_all();
-		drain_all_stock_sync();
+		drain_all_stock_sync(mem);
 		ret = 0;
 		mem_cgroup_start_move(mem);
 		for_each_node_state(node, N_HIGH_MEMORY) {
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch

