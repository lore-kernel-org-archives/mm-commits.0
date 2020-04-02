From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 122/155] mm/vmscan.c: remove cpu online
 notification for now
Date: Wed, 01 Apr 2020 21:10:09 -0700
Message-ID: <20200402041009.1Gvv_lVsn%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEKK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:10:10 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mm@kvack.org, mhocko@suse.com, mhocko@suse.org, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com, rientjes@google.com, torvalds@linux-foundation.org

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
