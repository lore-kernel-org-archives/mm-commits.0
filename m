From: akpm@linux-foundation.org
Subject: [merged] cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:50:55 -0800
Message-ID: <20130225205056.040115A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:35528 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757943Ab3BYUu5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:50:57 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so347775yhr.4
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:50:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wency@cn.fujitsu.com, hpa@zytor.com, isimatu.yasuaki@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, liuj97@gmail.com, mel@csn.ul.ie, minchan.kim@gmail.com, mingo@redhat.com, peterz@infradead.org, rientjes@google.com, tangchen@cn.fujitsu.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: cpu-hotplug,memory-hotplug: clear cpu_to_node() when offlining the node
has been removed from the -mm tree.  Its filename was
     cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wen Congyang <wency@cn.fujitsu.com>
Subject: cpu-hotplug,memory-hotplug: clear cpu_to_node() when offlining the node

When the node is offlined, there is no memory/cpu on the node.  If a sleep
task runs on a cpu of this node, it will be migrated to the cpu on the
other node.  So we can clear cpu-to-node mapping.

[akpm@linux-foundation.org: numa_clear_node() and numa_set_node() can no longer be __cpuinit]
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/numa.h |    4 ++--
 arch/x86/mm/numa.c          |    4 ++--
 mm/memory_hotplug.c         |   30 +++++++++++++++++++++++++++++-
 3 files changed, 33 insertions(+), 5 deletions(-)

diff -puN arch/x86/include/asm/numa.h~cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node arch/x86/include/asm/numa.h
--- a/arch/x86/include/asm/numa.h~cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node
+++ a/arch/x86/include/asm/numa.h
@@ -57,8 +57,8 @@ static inline int numa_cpu_node(int cpu)
 #endif
 
 #ifdef CONFIG_NUMA
-extern void __cpuinit numa_set_node(int cpu, int node);
-extern void __cpuinit numa_clear_node(int cpu);
+extern void numa_set_node(int cpu, int node);
+extern void numa_clear_node(int cpu);
 extern void __init init_cpu_to_node(void);
 extern void __cpuinit numa_add_cpu(int cpu);
 extern void __cpuinit numa_remove_cpu(int cpu);
diff -puN arch/x86/mm/numa.c~cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node
+++ a/arch/x86/mm/numa.c
@@ -78,7 +78,7 @@ EXPORT_SYMBOL(node_to_cpumask_map);
 DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node_map, NUMA_NO_NODE);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_node_map);
 
-void __cpuinit numa_set_node(int cpu, int node)
+void numa_set_node(int cpu, int node)
 {
 	int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);
 
@@ -101,7 +101,7 @@ void __cpuinit numa_set_node(int cpu, in
 		set_cpu_numa_node(cpu, node);
 }
 
-void __cpuinit numa_clear_node(int cpu)
+void numa_clear_node(int cpu)
 {
 	numa_set_node(cpu, NUMA_NO_NODE);
 }
diff -puN mm/memory_hotplug.c~cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node
+++ a/mm/memory_hotplug.c
@@ -1705,6 +1705,34 @@ static int check_cpu_on_node(void *data)
 	return 0;
 }
 
+static void unmap_cpu_on_node(void *data)
+{
+#ifdef CONFIG_ACPI_NUMA
+	struct pglist_data *pgdat = data;
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		if (cpu_to_node(cpu) == pgdat->node_id)
+			numa_clear_node(cpu);
+#endif
+}
+
+static int check_and_unmap_cpu_on_node(void *data)
+{
+	int ret = check_cpu_on_node(data);
+
+	if (ret)
+		return ret;
+
+	/*
+	 * the node will be offlined when we come here, so we can clear
+	 * the cpu_to_node() now.
+	 */
+
+	unmap_cpu_on_node(data);
+	return 0;
+}
+
 /* offline the node if all memory sections of this node are removed */
 void try_offline_node(int nid)
 {
@@ -1731,7 +1759,7 @@ void try_offline_node(int nid)
 		return;
 	}
 
-	if (stop_machine(check_cpu_on_node, pgdat, NULL))
+	if (stop_machine(check_and_unmap_cpu_on_node, pgdat, NULL))
 		return;
 
 	/*
_

Patches currently in -mm which might be from wency@cn.fujitsu.com are

origin.patch
x86-numa-dont-check-if-node-is-numa_no_node.patch
x86-make-mem=-option-to-work-for-efi-platform.patch

