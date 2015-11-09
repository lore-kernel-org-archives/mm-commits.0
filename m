From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-x86-enable-memoryless-node-support-to-better-support-cpu-memory-hotplug.patch removed from -mm tree
Date: Mon, 09 Nov 2015 13:52:45 -0800
Message-ID: <564115ad.irensAU5BQme8rvv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbbKIVwq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 16:52:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiang.liu@linux.intel.com, hpa@zytor.com, mgorman@suse.de, mingo@elte.hu, peterz@infradead.org, rafael.j.wysocki@intel.com, rientjes@google.com, tangchen@cn.fujitsu.com, tglx@linutronix.de, tj@kernel.org, tony.luck@intel.com, umgwanakikbuti@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, x86: enable memoryless node support to better support CPU/memory hotplug
has been removed from the -mm tree.  Its filename was
     mm-x86-enable-memoryless-node-support-to-better-support-cpu-memory-hotplug.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: mm, x86: enable memoryless node support to better support CPU/memory hotplug

With current implementation, all CPUs within a NUMA node will be
associated with another NUMA node if the node has no memory installed.

For example, on a four-node system, CPUs on node 2 and 3 are associated
with node 0 when are no memory install on node 2 and 3, which may
confuse users.
root@bkd01sdp:~# numactl --hardware
available: 2 nodes (0-1)
node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119
node 0 size: 15602 MB
node 0 free: 15014 MB
node 1 cpus: 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89
node 1 size: 15985 MB
node 1 free: 15686 MB
node distances:
node   0   1
  0:  10  21
  1:  21  10

To be worse, the CPU affinity relationship won't get fixed even after
memory has been added to those nodes. After memory hot-addition to
node 2, CPUs on node 2 are still associated with node 0. This may cause
sub-optimal performance.
root@bkd01sdp:/sys/devices/system/node/node2# numactl --hardware
available: 3 nodes (0-2)
node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119
node 0 size: 15602 MB
node 0 free: 14743 MB
node 1 cpus: 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89
node 1 size: 15985 MB
node 1 free: 15715 MB
node 2 cpus:
node 2 size: 128 MB
node 2 free: 128 MB
node distances:
node   0   1   2
  0:  10  21  21
  1:  21  10  21
  2:  21  21  10

With support of memoryless node enabled, it will correctly report system
hardware topology for nodes without memory installed.
root@bkd01sdp:~# numactl --hardware
available: 4 nodes (0-3)
node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74
node 0 size: 15725 MB
node 0 free: 15129 MB
node 1 cpus: 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89
node 1 size: 15862 MB
node 1 free: 15627 MB
node 2 cpus: 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104
node 2 size: 0 MB
node 2 free: 0 MB
node 3 cpus: 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119
node 3 size: 0 MB
node 3 free: 0 MB
node distances:
node   0   1   2   3
  0:  10  21  21  21
  1:  21  10  21  21
  2:  21  21  10  21
  3:  21  21  21  10

With memoryless node enabled, CPUs are correctly associated with node 2
after memory hot-addition to node 2.
root@bkd01sdp:/sys/devices/system/node/node2# numactl --hardware
available: 4 nodes (0-3)
node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74
node 0 size: 15725 MB
node 0 free: 14872 MB
node 1 cpus: 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89
node 1 size: 15862 MB
node 1 free: 15641 MB
node 2 cpus: 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104
node 2 size: 128 MB
node 2 free: 127 MB
node 3 cpus: 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119
node 3 size: 0 MB
node 3 free: 0 MB
node distances:
node   0   1   2   3
  0:  10  21  21  21
  1:  21  10  21  21
  2:  21  21  10  21
  3:  21  21  21  10

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig            |    3 ++
 arch/x86/kernel/acpi/boot.c |    4 ++
 arch/x86/kernel/smpboot.c   |    2 +
 arch/x86/mm/numa.c          |   49 ++++++++++++++++++++++++----------
 4 files changed, 44 insertions(+), 14 deletions(-)

diff -puN arch/x86/Kconfig~mm-x86-enable-memoryless-node-support-to-better-support-cpu-memory-hotplug arch/x86/Kconfig
--- a/arch/x86/Kconfig~mm-x86-enable-memoryless-node-support-to-better-support-cpu-memory-hotplug
+++ a/arch/x86/Kconfig
@@ -2151,6 +2151,9 @@ config USE_PERCPU_NUMA_NODE_ID
 	def_bool y
 	depends on NUMA
 
+config HAVE_MEMORYLESS_NODES
+	def_bool NUMA
+
 config ARCH_ENABLE_SPLIT_PMD_PTLOCK
 	def_bool y
 	depends on X86_64 || X86_PAE
diff -puN arch/x86/kernel/acpi/boot.c~mm-x86-enable-memoryless-node-support-to-better-support-cpu-memory-hotplug arch/x86/kernel/acpi/boot.c
--- a/arch/x86/kernel/acpi/boot.c~mm-x86-enable-memoryless-node-support-to-better-support-cpu-memory-hotplug
+++ a/arch/x86/kernel/acpi/boot.c
@@ -712,6 +712,7 @@ static void acpi_map_cpu2node(acpi_handl
 		}
 		set_apicid_to_node(physid, nid);
 		numa_set_node(cpu, nid);
+		set_cpu_numa_mem(cpu, local_memory_node(nid));
 	}
 #endif
 }
@@ -738,9 +739,10 @@ int acpi_unmap_cpu(int cpu)
 {
 #ifdef CONFIG_ACPI_NUMA
 	set_apicid_to_node(per_cpu(x86_cpu_to_apicid, cpu), NUMA_NO_NODE);
+	set_cpu_numa_mem(cpu, NUMA_NO_NODE);
 #endif
 
-	per_cpu(x86_cpu_to_apicid, cpu) = -1;
+	per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
 	set_cpu_present(cpu, false);
 	num_processors--;
 
diff -puN arch/x86/kernel/smpboot.c~mm-x86-enable-memoryless-node-support-to-better-support-cpu-memory-hotplug arch/x86/kernel/smpboot.c
--- a/arch/x86/kernel/smpboot.c~mm-x86-enable-memoryless-node-support-to-better-support-cpu-memory-hotplug
+++ a/arch/x86/kernel/smpboot.c
@@ -155,6 +155,8 @@ static void smp_callin(void)
 	 */
 	phys_id = read_apic_id();
 
+	set_numa_mem(local_memory_node(cpu_to_node(cpuid)));
+
 	/*
 	 * the boot CPU has finished the init stage and is spinning
 	 * on callin_map until we finish. We are free to set up this
diff -puN arch/x86/mm/numa.c~mm-x86-enable-memoryless-node-support-to-better-support-cpu-memory-hotplug arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~mm-x86-enable-memoryless-node-support-to-better-support-cpu-memory-hotplug
+++ a/arch/x86/mm/numa.c
@@ -22,6 +22,7 @@
 
 int __initdata numa_off;
 nodemask_t numa_nodes_parsed __initdata;
+static nodemask_t numa_nodes_empty __initdata;
 
 struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
@@ -562,17 +563,16 @@ static int __init numa_register_memblks(
 			end = max(mi->blk[i].end, end);
 		}
 
-		if (start >= end)
-			continue;
-
 		/*
 		 * Don't confuse VM with a node that doesn't have the
 		 * minimum amount of memory:
 		 */
-		if (end && (end - start) < NODE_MIN_SIZE)
-			continue;
-
-		alloc_node_data(nid);
+		if (start < end && (end - start) >= NODE_MIN_SIZE) {
+			alloc_node_data(nid);
+		} else if (IS_ENABLED(CONFIG_HAVE_MEMORYLESS_NODES)) {
+			alloc_node_data(nid);
+			node_set(nid, numa_nodes_empty);
+		}
 	}
 
 	/* Dump memblock with node info and return. */
@@ -589,14 +589,18 @@ static int __init numa_register_memblks(
  */
 static void __init numa_init_array(void)
 {
-	int rr, i;
+	int i, rr = MAX_NUMNODES;
 
-	rr = first_node(node_online_map);
 	for (i = 0; i < nr_cpu_ids; i++) {
+		/* Search for an onlined node with memory */
+		do {
+			if (rr != MAX_NUMNODES)
+				rr = next_node(rr, node_online_map);
+			if (rr == MAX_NUMNODES)
+				rr = first_node(node_online_map);
+		} while (node_isset(rr, numa_nodes_empty));
+
 		numa_set_node(i, rr);
-		rr = next_node(rr, node_online_map);
-		if (rr == MAX_NUMNODES)
-			rr = first_node(node_online_map);
 	}
 }
 
@@ -698,9 +702,12 @@ static __init int find_near_online_node(
 {
 	int n, val;
 	int min_val = INT_MAX;
-	int best_node = -1;
+	int best_node = NUMA_NO_NODE;
 
 	for_each_online_node(n) {
+		if (node_isset(n, numa_nodes_empty))
+			continue;
+
 		val = node_distance(node, n);
 
 		if (val < min_val) {
@@ -741,6 +748,22 @@ void __init init_cpu_to_node(void)
 		if (!node_online(node))
 			node = find_near_online_node(node);
 		numa_set_node(cpu, node);
+		if (node_spanned_pages(node))
+			set_cpu_numa_mem(cpu, node);
+		if (IS_ENABLED(CONFIG_HAVE_MEMORYLESS_NODES))
+			node_clear(node, numa_nodes_empty);
+	}
+
+	/* Destroy empty nodes */
+	if (IS_ENABLED(CONFIG_HAVE_MEMORYLESS_NODES)) {
+		int nid;
+		const size_t nd_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
+
+		for_each_node_mask(nid, numa_nodes_empty) {
+			node_set_offline(nid);
+			memblock_free(__pa(node_data[nid]), nd_size);
+			node_data[nid] = NULL;
+		}
 	}
 }
 
_

Patches currently in -mm which might be from jiang.liu@linux.intel.com are


