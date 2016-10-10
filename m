From: akpm@linux-foundation.org
Subject: [merged] cpu-fix-node-state-for-whether-it-contains-cpu.patch
 removed from -mm tree
Date: Mon, 10 Oct 2016 15:45:00 -0700
Message-ID: <57fc19ec.w+DfJ+y+wpcHo0fu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36861 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752225AbcJJWpB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:45:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tim.c.chen@linux.intel.com, Huang@linux.intel.com, andi@firstfloor.org, dan.j.williams@intel.com, dave.hansen@intel.com, hpa@zytor.com, mingo@elte.hu, peterz@infradead.org, rientjes@google.com, rjw@rjwysocki.net, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cpu: fix node state for whether it contains CPU
has been removed from the -mm tree.  Its filename was
     cpu-fix-node-state-for-whether-it-contains-cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: cpu: fix node state for whether it contains CPU

In current kernel code, we only call node_set_state(cpu_to_node(cpu),
N_CPU) when a cpu is hot plugged.  But we do not set the node state for
N_CPU when the cpus are brought online during boot.

So this could lead to failure when we check to see if a node contains cpu
with node_state(node_id, N_CPU).

One use case is in the node_reclaime function:

        /*
         * Only run node reclaim on the local node or on nodes that do
         * not
         * have associated processors. This will favor the local
         * processor
         * over remote processors and spread off node memory allocations
         * as wide as possible.
         */
        if (node_state(pgdat->node_id, N_CPU) && pgdat->node_id !=
                numa_node_id())
                return NODE_RECLAIM_NOSCAN;

I instrumented the kernel to call this function after boot and it always
returns 0 on a x86 desktop machine until I apply the attached patch.

int num_cpu_node(void)
{
       int i, nr_cpu_nodes = 0;

       for_each_node(i) {
               if (node_state(i, N_CPU))
                       ++ nr_cpu_nodes;
       }

       return nr_cpu_nodes;
}

Fix this by checking each node for online CPU when we initialize
vmstat that's responsible for maintaining node state.

Link: http://lkml.kernel.org/r/20160829175922.GA21775@linux.intel.com
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: <Huang@linux.intel.com>
Cc: Ying <ying.huang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN mm/vmstat.c~cpu-fix-node-state-for-whether-it-contains-cpu mm/vmstat.c
--- a/mm/vmstat.c~cpu-fix-node-state-for-whether-it-contains-cpu
+++ a/mm/vmstat.c
@@ -1715,6 +1715,16 @@ static void __init start_shepherd_timer(
 		round_jiffies_relative(sysctl_stat_interval));
 }
 
+static void __init init_cpu_node_state(void)
+{
+	int cpu;
+
+	get_online_cpus();
+	for_each_online_cpu(cpu)
+		node_set_state(cpu_to_node(cpu), N_CPU);
+	put_online_cpus();
+}
+
 static void vmstat_cpu_dead(int node)
 {
 	int cpu;
@@ -1772,6 +1782,7 @@ static int __init setup_vmstat(void)
 #ifdef CONFIG_SMP
 	cpu_notifier_register_begin();
 	__register_cpu_notifier(&vmstat_notifier);
+	init_cpu_node_state();
 
 	start_shepherd_timer();
 	cpu_notifier_register_done();
_

Patches currently in -mm which might be from tim.c.chen@linux.intel.com are


