From: akpm@linux-foundation.org
Subject: + numa-x86_64-use-generic-percpu-var-numa_node_id-implementation.patch added to -mm tree
Date: Fri, 16 Apr 2010 13:35:26 -0700
Message-ID: <201004162035.o3GKZRgk025736__15606.7932876342$1271450238$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932506Ab0DPUhA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Apr 2010 16:37:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, cl@linux-foundation.org, eric.whitney@hp.com, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, linux-arch@vger.kernel.org, mel@csn.ul.ie, mingo@elte.hu, npiggin@suse.de, penberg@cs.helsinki.fi, rientjes@google.com, tglx@linutronix.de, tj@kernel.org, tony.luck@intel.com


The patch titled
     numa: x86_64: use generic percpu var numa_node_id() implementation
has been added to the -mm tree.  Its filename is
     numa-x86_64-use-generic-percpu-var-numa_node_id-implementation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: numa: x86_64: use generic percpu var numa_node_id() implementation
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

x86 arch specific changes to use generic numa_node_id() based on generic
percpu variable infrastructure.  Back out x86's custom version of
numa_node_id()

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Whitney <eric.whitney@hp.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                |    4 ++++
 arch/x86/include/asm/topology.h |   20 +++++++-------------
 arch/x86/kernel/cpu/common.c    |    6 +++---
 arch/x86/kernel/setup_percpu.c  |    4 ++--
 arch/x86/mm/numa_64.c           |    9 +++------
 5 files changed, 19 insertions(+), 24 deletions(-)

diff -puN arch/x86/Kconfig~numa-x86_64-use-generic-percpu-var-numa_node_id-implementation arch/x86/Kconfig
--- a/arch/x86/Kconfig~numa-x86_64-use-generic-percpu-var-numa_node_id-implementation
+++ a/arch/x86/Kconfig
@@ -1718,6 +1718,10 @@ config HAVE_ARCH_EARLY_PFN_TO_NID
 	def_bool X86_64
 	depends on NUMA
 
+config USE_PERCPU_NUMA_NODE_ID
+	def_bool y
+	depends on NUMA
+
 menu "Power management and ACPI options"
 
 config ARCH_HIBERNATION_HEADER
diff -puN arch/x86/include/asm/topology.h~numa-x86_64-use-generic-percpu-var-numa_node_id-implementation arch/x86/include/asm/topology.h
--- a/arch/x86/include/asm/topology.h~numa-x86_64-use-generic-percpu-var-numa_node_id-implementation
+++ a/arch/x86/include/asm/topology.h
@@ -53,33 +53,27 @@
 extern int cpu_to_node_map[];
 
 /* Returns the number of the node containing CPU 'cpu' */
-static inline int cpu_to_node(int cpu)
+static inline int early_cpu_to_node(int cpu)
 {
 	return cpu_to_node_map[cpu];
 }
-#define early_cpu_to_node(cpu)	cpu_to_node(cpu)
 
 #else /* CONFIG_X86_64 */
 
 /* Mappings between logical cpu number and node number */
 DECLARE_EARLY_PER_CPU(int, x86_cpu_to_node_map);
 
-/* Returns the number of the current Node. */
-DECLARE_PER_CPU(int, node_number);
-#define numa_node_id()		percpu_read(node_number)
-
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
-extern int cpu_to_node(int cpu);
+/*
+ * override generic percpu implementation of cpu_to_node
+ */
+extern int __cpu_to_node(int cpu);
+#define cpu_to_node __cpu_to_node
+
 extern int early_cpu_to_node(int cpu);
 
 #else	/* !CONFIG_DEBUG_PER_CPU_MAPS */
 
-/* Returns the number of the node containing CPU 'cpu' */
-static inline int cpu_to_node(int cpu)
-{
-	return per_cpu(x86_cpu_to_node_map, cpu);
-}
-
 /* Same function but used if called before per_cpu areas are setup */
 static inline int early_cpu_to_node(int cpu)
 {
diff -puN arch/x86/kernel/cpu/common.c~numa-x86_64-use-generic-percpu-var-numa_node_id-implementation arch/x86/kernel/cpu/common.c
--- a/arch/x86/kernel/cpu/common.c~numa-x86_64-use-generic-percpu-var-numa_node_id-implementation
+++ a/arch/x86/kernel/cpu/common.c
@@ -1121,9 +1121,9 @@ void __cpuinit cpu_init(void)
 	oist = &per_cpu(orig_ist, cpu);
 
 #ifdef CONFIG_NUMA
-	if (cpu != 0 && percpu_read(node_number) == 0 &&
-	    cpu_to_node(cpu) != NUMA_NO_NODE)
-		percpu_write(node_number, cpu_to_node(cpu));
+	if (cpu != 0 && percpu_read(numa_node) == 0 &&
+	    early_cpu_to_node(cpu) != NUMA_NO_NODE)
+		set_numa_node(early_cpu_to_node(cpu));
 #endif
 
 	me = current;
diff -puN arch/x86/kernel/setup_percpu.c~numa-x86_64-use-generic-percpu-var-numa_node_id-implementation arch/x86/kernel/setup_percpu.c
--- a/arch/x86/kernel/setup_percpu.c~numa-x86_64-use-generic-percpu-var-numa_node_id-implementation
+++ a/arch/x86/kernel/setup_percpu.c
@@ -265,10 +265,10 @@ void __init setup_per_cpu_areas(void)
 
 #if defined(CONFIG_X86_64) && defined(CONFIG_NUMA)
 	/*
-	 * make sure boot cpu node_number is right, when boot cpu is on the
+	 * make sure boot cpu numa_node is right, when boot cpu is on the
 	 * node that doesn't have mem installed
 	 */
-	per_cpu(node_number, boot_cpu_id) = cpu_to_node(boot_cpu_id);
+	per_cpu(numa_node, boot_cpu_id) = early_cpu_to_node(boot_cpu_id);
 #endif
 
 	/* Setup node to cpumask map */
diff -puN arch/x86/mm/numa_64.c~numa-x86_64-use-generic-percpu-var-numa_node_id-implementation arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c~numa-x86_64-use-generic-percpu-var-numa_node_id-implementation
+++ a/arch/x86/mm/numa_64.c
@@ -33,9 +33,6 @@ int numa_off __initdata;
 static unsigned long __initdata nodemap_addr;
 static unsigned long __initdata nodemap_size;
 
-DEFINE_PER_CPU(int, node_number) = 0;
-EXPORT_PER_CPU_SYMBOL(node_number);
-
 /*
  * Map cpu index to node index
  */
@@ -809,7 +806,7 @@ void __cpuinit numa_set_node(int cpu, in
 	per_cpu(x86_cpu_to_node_map, cpu) = node;
 
 	if (node != NUMA_NO_NODE)
-		per_cpu(node_number, cpu) = node;
+		per_cpu(numa_node, cpu) = node;
 }
 
 void __cpuinit numa_clear_node(int cpu)
@@ -867,7 +864,7 @@ void __cpuinit numa_remove_cpu(int cpu)
 	numa_set_cpumask(cpu, 0);
 }
 
-int cpu_to_node(int cpu)
+int __cpu_to_node(int cpu)
 {
 	if (early_per_cpu_ptr(x86_cpu_to_node_map)) {
 		printk(KERN_WARNING
@@ -877,7 +874,7 @@ int cpu_to_node(int cpu)
 	}
 	return per_cpu(x86_cpu_to_node_map, cpu);
 }
-EXPORT_SYMBOL(cpu_to_node);
+EXPORT_SYMBOL(__cpu_to_node);
 
 /*
  * Same function as cpu_to_node() but used if called before the
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

mempolicy-remove-case-mpol_interleave-from-policy_zonelist.patch
mempolicy-remove-redundant-check.patch
mempolicy-dont-call-mpol_set_nodemask-when-no_context.patch
mempolicy-lose-unnecessary-loop-variable-in-mpol_parse_str.patch
mempolicy-rename-policy_types-and-cleanup-initialization.patch
mempolicy-factor-mpol_shared_policy_init-return-paths.patch
mempolicy-document-cpuset-interaction-with-tmpfs-mpol-mount-option.patch
numa-add-generic-percpu-var-numa_node_id-implementation.patch
numa-x86_64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-ia64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id.patch
numa-ia64-support-numa_mem_id-for-memoryless-nodes.patch
numa-slab-use-numa_mem_id-for-slab-local-memory-node.patch
numa-in-kernel-profiling-use-cpu_to_mem-for-per-cpu-allocations.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch

