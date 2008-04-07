From: akpm@linux-foundation.org
Subject: - asm-generic-add-node_to_cpumask_ptr-macro.patch removed from -mm tree
Date: Mon, 07 Apr 2008 14:43:24 -0700
Message-ID: <200804072143.m37LhOBq026567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751405AbYDGVou (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2008 17:44:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, anton@samba.org, davem@davemloft.net, dhowells@redhat.com, hpa@zytor.com, mingo@elte.hu, paulus@samba.org, rth@twiddle.net, tglx@linutronix.de, tony.luck@intel.com, wl


The patch titled
     asm-generic: add node_to_cpumask_ptr macro
has been removed from the -mm tree.  Its filename was
     asm-generic-add-node_to_cpumask_ptr-macro.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asm-generic: add node_to_cpumask_ptr macro
From: Mike Travis <travis@sgi.com>

Create a simple macro to always return a pointer to the node_to_cpumask(node)
value.  This relies on compiler optimization to remove the extra indirection:

    #define node_to_cpumask_ptr(v, node) 		\
	    cpumask_t _##v = node_to_cpumask(node), *v = &_##v

For those systems with a large cpumask size, then a true pointer
to the array element can be used:

    #define node_to_cpumask_ptr(v, node)		\
	    cpumask_t *v = &(node_to_cpumask_map[node])

A node_to_cpumask_ptr_next() macro is provided to access another
node_to_cpumask value.

The other change is to always include asm-generic/topology.h moving the
ifdef CONFIG_NUMA to this same file.

Note: there are no references to either of these new macros in this patch,
only the definition.

Cc: Richard Henderson <rth@twiddle.net>
Cc: David Howells <dhowells@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: William L. Irwin <wli@holomorphy.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/topology.h   |    3 +--
 include/asm-frv/topology.h     |    4 +---
 include/asm-generic/topology.h |   14 ++++++++++++++
 include/asm-ia64/topology.h    |    5 +++++
 include/asm-powerpc/topology.h |    3 +--
 include/asm-x86/topology.h     |   15 +++++++++++++--
 6 files changed, 35 insertions(+), 9 deletions(-)

diff -puN include/asm-alpha/topology.h~asm-generic-add-node_to_cpumask_ptr-macro include/asm-alpha/topology.h
--- a/include/asm-alpha/topology.h~asm-generic-add-node_to_cpumask_ptr-macro
+++ a/include/asm-alpha/topology.h
@@ -41,8 +41,7 @@ static inline cpumask_t node_to_cpumask(
 
 #define pcibus_to_cpumask(bus)	(cpu_online_map)
 
-#else /* CONFIG_NUMA */
-# include <asm-generic/topology.h>
 #endif /* !CONFIG_NUMA */
+# include <asm-generic/topology.h>
 
 #endif /* _ASM_ALPHA_TOPOLOGY_H */
diff -puN include/asm-frv/topology.h~asm-generic-add-node_to_cpumask_ptr-macro include/asm-frv/topology.h
--- a/include/asm-frv/topology.h~asm-generic-add-node_to_cpumask_ptr-macro
+++ a/include/asm-frv/topology.h
@@ -5,10 +5,8 @@
 
 #error NUMA not supported yet
 
-#else /* !CONFIG_NUMA */
+#endif /* CONFIG_NUMA */
 
 #include <asm-generic/topology.h>
 
-#endif /* CONFIG_NUMA */
-
 #endif /* _ASM_TOPOLOGY_H */
diff -puN include/asm-generic/topology.h~asm-generic-add-node_to_cpumask_ptr-macro include/asm-generic/topology.h
--- a/include/asm-generic/topology.h~asm-generic-add-node_to_cpumask_ptr-macro
+++ a/include/asm-generic/topology.h
@@ -27,6 +27,8 @@
 #ifndef _ASM_GENERIC_TOPOLOGY_H
 #define _ASM_GENERIC_TOPOLOGY_H
 
+#ifndef	CONFIG_NUMA
+
 /* Other architectures wishing to use this simple topology API should fill
    in the below functions as appropriate in their own <asm/topology.h> file. */
 #ifndef cpu_to_node
@@ -52,4 +54,16 @@
 				)
 #endif
 
+#endif	/* CONFIG_NUMA */
+
+/* returns pointer to cpumask for specified node */
+#ifndef node_to_cpumask_ptr
+
+#define	node_to_cpumask_ptr(v, node) 					\
+		cpumask_t _##v = node_to_cpumask(node), *v = &_##v
+
+#define node_to_cpumask_ptr_next(v, node)				\
+			  _##v = node_to_cpumask(node)
+#endif
+
 #endif /* _ASM_GENERIC_TOPOLOGY_H */
diff -puN include/asm-ia64/topology.h~asm-generic-add-node_to_cpumask_ptr-macro include/asm-ia64/topology.h
--- a/include/asm-ia64/topology.h~asm-generic-add-node_to_cpumask_ptr-macro
+++ a/include/asm-ia64/topology.h
@@ -116,6 +116,11 @@ void build_cpu_to_node_map(void);
 #define smt_capable() 				(smp_num_siblings > 1)
 #endif
 
+#define pcibus_to_cpumask(bus)	(pcibus_to_node(bus) == -1 ? \
+					CPU_MASK_ALL : \
+					node_to_cpumask(pcibus_to_node(bus)) \
+				)
+
 #include <asm-generic/topology.h>
 
 #endif /* _ASM_IA64_TOPOLOGY_H */
diff -puN include/asm-powerpc/topology.h~asm-generic-add-node_to_cpumask_ptr-macro include/asm-powerpc/topology.h
--- a/include/asm-powerpc/topology.h~asm-generic-add-node_to_cpumask_ptr-macro
+++ a/include/asm-powerpc/topology.h
@@ -96,11 +96,10 @@ static inline void sysfs_remove_device_f
 {
 }
 
+#endif /* CONFIG_NUMA */
 
 #include <asm-generic/topology.h>
 
-#endif /* CONFIG_NUMA */
-
 #ifdef CONFIG_SMP
 #include <asm/cputable.h>
 #define smt_capable()		(cpu_has_feature(CPU_FTR_SMT))
diff -puN include/asm-x86/topology.h~asm-generic-add-node_to_cpumask_ptr-macro include/asm-x86/topology.h
--- a/include/asm-x86/topology.h~asm-generic-add-node_to_cpumask_ptr-macro
+++ a/include/asm-x86/topology.h
@@ -81,6 +81,17 @@ static inline int cpu_to_node(int cpu)
 	else
 		return NUMA_NO_NODE;
 }
+
+#ifdef	CONFIG_NUMA
+
+/* Returns a pointer to the cpumask of CPUs on Node 'node'. */
+#define node_to_cpumask_ptr(v, node)		\
+		cpumask_t *v = &(node_to_cpumask_map[node])
+
+#define node_to_cpumask_ptr_next(v, node)	\
+			   v = &(node_to_cpumask_map[node])
+#endif
+
 #endif /* CONFIG_X86_64 */
 
 /*
@@ -167,10 +178,10 @@ extern int __node_distance(int, int);
 
 #else /* CONFIG_NUMA */
 
-#include <asm-generic/topology.h>
-
 #endif
 
+#include <asm-generic/topology.h>
+
 extern cpumask_t cpu_coregroup_map(int cpu);
 
 #ifdef ENABLE_TOPO_DEFINES
_

Patches currently in -mm which might be from travis@sgi.com are

git-cpufreq.patch
asm-generic-add-node_to_cpumask_ptr-macro.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
cpufreq-change-cpu-freq-arrays-to-per_cpu-variables.patch
acpi-change-processors-from-array-to-per_cpu-variable.patch
cpu-change-cpu_sys_devices-from-array-to-per_cpu-variable.patch
net-remove-nr_cpus-arrays-in-net-core-devc-v2.patch
cpumask-convert-cpumask_of_cpu-to-static-array.patch
cpumask-pass-pointer-to-cpumask-for-set_cpus_allowed.patch
cpumask-reduce-stack-pressure-in-sched_affinity.patch
cpumask-pass-cpumask-by-reference-to-acpi-cpufreq.patch
init-move-large-array-from-stack-to-_initdata-section.patch
cpumask-create-pointer-to-node_to_cpumask-array-element.patch
cpumask-reduce-stack-usage-in-sd_x_init-initializers.patch
cpumask-pass-temp-cpumask-variables-in-init_sched_build_groups.patch
sched-fix-memory-leak-in-build_sched_domains.patch
cpumask-reduce-stack-usage-in-build_sched_domains.patch
cpumask-reduce-stack-pressure-in-cpu_coregroup_map.patch
cpu-node-mask-reduce-stack-usage-using-mask_none-mask_all.patch

