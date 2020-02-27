From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-optimize-cpumask_local_spread.patch added to -mm
 tree
Date: Wed, 26 Feb 2020 19:50:46 -0800
Message-ID: <20200227035046.QC-oYV8zN%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728221AbgB0Dus (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 26 Feb 2020 22:50:48 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, jgross@suse.com, jinyuqi@huawei.com, mgorman@techsingularity.net, mhocko@suse.com, mingo@elte.hu, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paul.burton@mips.com, peterz@infradead.org, rppt@linux.ibm.com, rusty@rustcorp.com.au, zhangshaokun@hisilicon.com


The patch titled
     Subject: lib: optimize cpumask_local_spread()
has been added to the -mm tree.  Its filename is
     lib-optimize-cpumask_local_spread.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-optimize-cpumask_local_spread.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-optimize-cpumask_local_spread.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: yuqi jin <jinyuqi@huawei.com>
Subject: lib: optimize cpumask_local_spread()

In multi-processor and NUMA system, I/O driver will find cpu cores that
which shall be bound IRQ.  When cpu cores in the local numa have been
used, it is better to find the node closest to the local numa node for
performance, instead of choosing any online cpu immediately.

On Huawei Kunpeng 920 server, there are 4 NUMA node(0 - 3) in the 2-cpu
system(0 - 1). The topology of this server is followed:
available: 4 nodes (0-3)
node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
node 0 size: 63379 MB
node 0 free: 61899 MB
node 1 cpus: 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47
node 1 size: 64509 MB
node 1 free: 63942 MB
node 2 cpus: 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71
node 2 size: 64509 MB
node 2 free: 63056 MB
node 3 cpus: 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95
node 3 size: 63997 MB
node 3 free: 63420 MB
node distances:
node   0   1   2   3
  0:  10  16  32  33
  1:  16  10  25  32
  2:  32  25  10  16
  3:  33  32  16  10

We perform PS (parameter server) business test, the behavior of the
service is that the client initiates a request through the network card,
the server responds to the request after calculation.  When two PS
processes run on node2 and node3 separately and the network card is
located on 'node2' which is in cpu1, the performance of node2 (26W QPS)
and node3 (22W QPS) is different.

It is better that the NIC queues are bound to the cpu1 cores in turn, then
XPS will also be properly initialized, while cpumask_local_spread only
considers the local node.  When the number of NIC queues exceeds the
number of cores in the local node, it returns to the online core directly.
So when PS runs on node3 sending a calculated request, the performance is
not as good as the node2.

The IRQ from 369-392 will be bound from NUMA node0 to NUMA node3 with this
patch, before the patch:

Euler:/sys/bus/pci # cat /proc/irq/369/smp_affinity_list
0
Euler:/sys/bus/pci # cat /proc/irq/370/smp_affinity_list
1
...
Euler:/sys/bus/pci # cat /proc/irq/391/smp_affinity_list
22
Euler:/sys/bus/pci # cat /proc/irq/392/smp_affinity_list
23
After the patch:
Euler:/sys/bus/pci # cat /proc/irq/369/smp_affinity_list
72
Euler:/sys/bus/pci # cat /proc/irq/370/smp_affinity_list
73
...
Euler:/sys/bus/pci # cat /proc/irq/391/smp_affinity_list
94
Euler:/sys/bus/pci # cat /proc/irq/392/smp_affinity_list
95

So the performance of the node3 is the same as node2 that is 26W QPS when
the network card is still in 'node2' with the patch.

It is considered that the NIC and other I/O devices shall initialize the
interrupt binding, if the cores of the local node are used up, it is
reasonable to return the node closest to it.  Let's optimize it and find
the nearest node through NUMA distance for the non-local NUMA nodes.

Link: http://lkml.kernel.org/r/1582768688-2314-1-git-send-email-zhangshaokun@hisilicon.com
Signed-off-by: yuqi jin <jinyuqi@huawei.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Juergen Gross <jgross@suse.com>
Cc: Paul Burton <paul.burton@mips.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/cpumask.c |  102 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 90 insertions(+), 12 deletions(-)

--- a/lib/cpumask.c~lib-optimize-cpumask_local_spread
+++ a/lib/cpumask.c
@@ -6,6 +6,7 @@
 #include <linux/export.h>
 #include <linux/memblock.h>
 #include <linux/numa.h>
+#include <linux/spinlock.h>
 
 /**
  * cpumask_next - get the next cpu in a cpumask
@@ -192,18 +193,39 @@ void __init free_bootmem_cpumask_var(cpu
 }
 #endif
 
-/**
- * cpumask_local_spread - select the i'th cpu with local numa cpu's first
- * @i: index number
- * @node: local numa_node
- *
- * This function selects an online CPU according to a numa aware policy;
- * local cpus are returned first, followed by non-local ones, then it
- * wraps around.
- *
- * It's not very efficient, but useful for setup.
- */
-unsigned int cpumask_local_spread(unsigned int i, int node)
+static void calc_node_distance(int *node_dist, int node)
+{
+	int i;
+
+	for (i = 0; i < nr_node_ids; i++)
+		node_dist[i] = node_distance(node, i);
+}
+
+static int find_nearest_node(int *node_dist, bool *used)
+{
+	int i, min_dist = node_dist[0], node_id = -1;
+
+	/* Choose the first unused node to compare */
+	for (i = 0; i < nr_node_ids; i++) {
+		if (used[i] == 0) {
+			min_dist = node_dist[i];
+			node_id = i;
+			break;
+		}
+	}
+
+	/* Compare and return the nearest node */
+	for (i = 0; i < nr_node_ids; i++) {
+		if (node_dist[i] < min_dist && used[i] == 0) {
+			min_dist = node_dist[i];
+			node_id = i;
+		}
+	}
+
+	return node_id;
+}
+
+static unsigned int __cpumask_local_spread(unsigned int i, int node)
 {
 	int cpu;
 
@@ -231,4 +253,60 @@ unsigned int cpumask_local_spread(unsign
 	}
 	BUG();
 }
+
+/**
+ * cpumask_local_spread - select the i'th cpu with local numa cpu's first
+ * @i: index number
+ * @node: local numa_node
+ *
+ * This function selects an online CPU according to a numa aware policy;
+ * local cpus are returned first, followed by the nearest non-local ones,
+ * then it wraps around.
+ *
+ * It's not very efficient, but useful for setup.
+ */
+unsigned int cpumask_local_spread(unsigned int i, int node)
+{
+	static DEFINE_SPINLOCK(spread_lock);
+	static int node_dist[MAX_NUMNODES];
+	static bool used[MAX_NUMNODES];
+	unsigned long flags;
+	int cpu, j, id;
+
+	/* Wrap: we always want a cpu. */
+	i %= num_online_cpus();
+
+	if (node == NUMA_NO_NODE) {
+		for_each_cpu(cpu, cpu_online_mask)
+			if (i-- == 0)
+				return cpu;
+	} else {
+		if (nr_node_ids > MAX_NUMNODES)
+			return __cpumask_local_spread(i, node);
+
+		spin_lock_irqsave(&spread_lock, flags);
+		memset(used, 0, nr_node_ids * sizeof(bool));
+		calc_node_distance(node_dist, node);
+		for (j = 0; j < nr_node_ids; j++) {
+			id = find_nearest_node(node_dist, used);
+			if (id < 0)
+				break;
+
+			for_each_cpu_and(cpu, cpumask_of_node(id),
+					 cpu_online_mask)
+				if (i-- == 0) {
+					spin_unlock_irqrestore(&spread_lock,
+							       flags);
+					return cpu;
+				}
+			used[id] = 1;
+		}
+		spin_unlock_irqrestore(&spread_lock, flags);
+
+		for_each_cpu(cpu, cpu_online_mask)
+			if (i-- == 0)
+				return cpu;
+	}
+	BUG();
+}
 EXPORT_SYMBOL(cpumask_local_spread);
_

Patches currently in -mm which might be from jinyuqi@huawei.com are

lib-optimize-cpumask_local_spread.patch
