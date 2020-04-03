From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscanc-remove-cpu-online-notification-for-now.patch removed from -mm
 tree
Date: Fri, 03 Apr 2020 13:39:50 -0700
Message-ID: <20200403203950.I8BQDwfdg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUjv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:39:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mhocko@suse.org, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com, rientjes@google.com


The patch titled
     Subject: mm/vmscan.c: remove cpu online notification for now
has been removed from the -mm tree.  Its filename was
     mm-vmscanc-remove-cpu-online-notification-for-now.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: mm/vmscan.c: remove cpu online notification for now

kswapd kernel thread starts either with a CPU affinity set to the full cpu
mask of its target node or without any affinity at all if the node is
CPUless.  There is a cpu hotplug callback (kswapd_cpu_online) that
implements an elaborate way to update this mask when a cpu is onlined.

It is not really clear whether there is any actual benefit from this
scheme. Completely CPU-less NUMA nodes rarely gain a new CPU during
runtime. Drop the code for that reason. If there is a real usecase then
we can resurrect and simplify the code.

[mhocko@suse.com rewrite changelog]

Link: http://lkml.kernel.org/r/20200218224422.3407-1-richardw.yang@linux.intel.com
Suggested-by: Michal Hocko <mhocko@suse.org>
Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   27 +--------------------------
 1 file changed, 1 insertion(+), 26 deletions(-)

--- a/mm/vmscan.c~mm-vmscanc-remove-cpu-online-notification-for-now
+++ a/mm/vmscan.c
@@ -4030,27 +4030,6 @@ unsigned long shrink_all_memory(unsigned
 }
 #endif /* CONFIG_HIBERNATION */
 
-/* It's optimal to keep kswapds on the same CPUs as their memory, but
-   not required for correctness.  So if the last cpu in a node goes
-   away, we get changed to run anywhere: as the first one comes back,
-   restore their cpu bindings. */
-static int kswapd_cpu_online(unsigned int cpu)
-{
-	int nid;
-
-	for_each_node_state(nid, N_MEMORY) {
-		pg_data_t *pgdat = NODE_DATA(nid);
-		const struct cpumask *mask;
-
-		mask = cpumask_of_node(pgdat->node_id);
-
-		if (cpumask_any_and(cpu_online_mask, mask) < nr_cpu_ids)
-			/* One of our CPUs online: restore mask */
-			set_cpus_allowed_ptr(pgdat->kswapd, mask);
-	}
-	return 0;
-}
-
 /*
  * This kswapd start function will be called by init and node-hot-add.
  * On node-hot-add, kswapd will moved to proper cpus if cpus are hot-added.
@@ -4090,15 +4069,11 @@ void kswapd_stop(int nid)
 
 static int __init kswapd_init(void)
 {
-	int nid, ret;
+	int nid;
 
 	swap_setup();
 	for_each_node_state(nid, N_MEMORY)
  		kswapd_run(nid);
-	ret = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
-					"mm/vmscan:online", kswapd_cpu_online,
-					NULL);
-	WARN_ON(ret < 0);
 	return 0;
 }
 
_

Patches currently in -mm which might be from richardw.yang@linux.intel.com are

mm-migratec-no-need-to-check-for-i-start-in-do_pages_move.patch
mm-migratec-wrap-do_move_pages_to_node-and-store_status.patch
mm-migratec-check-pagelist-in-move_pages_and_store_status.patch
mm-migratec-unify-not-queued-for-migration-handling-in-do_pages_move.patch
