From: akpm@linux-foundation.org
Subject: + numa-introduce-numa_mem_id-effective-local-memory-node-id-fix3.patch added to -mm tree
Date: Wed, 12 May 2010 11:49:29 -0700
Message-ID: <201005121849.o4CInTV2013944__17991.7038804435$1273690229$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755103Ab0ELSuU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 14:50:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, cl@linux-foundation.org, eric.whitney@hp.com, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, linux-arch@vger.kernel.org, mel@csn.ul.ie, mingo@elte.hu, npiggin@suse.de, penberg@cs.helsinki.fi, rientjes@google.com, tglx@linutronix.de, tj@kernel.org, tony.luck@intel.com


The patch titled
     numa-introduce-numa_mem_id-effective-local-memory-node-id-fix3
has been added to the -mm tree.  Its filename is
     numa-introduce-numa_mem_id-effective-local-memory-node-id-fix3.patch

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
Subject: numa-introduce-numa_mem_id-effective-local-memory-node-id-fix3
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Incremental patch 2 to
numa-introduce-numa_mem_id-effective-local-memory-node-id
in 28april10 mmotm.

Remove the "#define numa_mem numa_node" when !HAVE_MEMORYLESS_NODES
from topology.h per Tejun Heo.  Because 'numa_mem' is [was] a percpu
variable, we cannot make it a macro with arguments or a static inline
function.  I considered making it a variable alias for numa_node, but
since both are percpu variables whose actual definitions and declarations
are buried deep in the DECLARE_PER_CPU() macros, I proposed a
DECLARE_PER_CPU_ALIAS(variable, alias).  Tejun agreed that if this
were a common occurrence, that would be a good idea, but since we
currently have only this instance, we agreed to just eliminate
the numa_mem variable when !HAVE_MEMORYLESS_NODES.

This patch renames the variable to _numa_mem_ and adds warnings
in both linux/topology.h and mm/page_alloc.c against referencing
the variable directly.  The accessor functions numa_mem_id() and
cpu_to_mem() will return the appropriate value when
!HAVE_MEMORYLESS_NODES.

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

 include/linux/topology.h |   35 +++++++++++++++++++++++++++--------
 mm/page_alloc.c          |   10 ++++++++--
 2 files changed, 35 insertions(+), 10 deletions(-)

diff -puN include/linux/topology.h~numa-introduce-numa_mem_id-effective-local-memory-node-id-fix3 include/linux/topology.h
--- a/include/linux/topology.h~numa-introduce-numa_mem_id-effective-local-memory-node-id-fix3
+++ a/include/linux/topology.h
@@ -253,46 +253,65 @@ static inline int numa_node_id(void)
 
 #ifdef CONFIG_HAVE_MEMORYLESS_NODES
 
-DECLARE_PER_CPU(int, numa_mem);
+/*
+ * N.B., Do NOT reference the '_numa_mem_' per cpu variable directly.
+ * It will not be defined when CONFIG_HAVE_MEMORYLESS_NODES is not defined.
+ * Use the accessor functions set_numa_mem(), numa_mem_id() and cpu_to_mem().
+ */
+DECLARE_PER_CPU(int, _numa_mem_);
 
 #ifndef set_numa_mem
 static inline void set_numa_mem(int node)
 {
-	percpu_write(numa_mem, node);
+	percpu_write(_numa_mem_, node);
+}
+#endif
+
+#ifndef numa_mem_id
+/* Returns the number of the nearest Node with memory */
+static inline int numa_mem_id(void)
+{
+	return __this_cpu_read(_numa_mem_);
+}
+#endif
+
+#ifndef cpu_to_mem
+static inline int cpu_to_mem(int cpu)
+{
+	return per_cpu(_numa_mem_, cpu);
 }
 #endif
 
 #ifndef set_cpu_numa_mem
 static inline void set_cpu_numa_mem(int cpu, int node)
 {
-	per_cpu(numa_mem, cpu) = node;
+	per_cpu(_numa_mem_, cpu) = node;
 }
 #endif
 
 #else	/* !CONFIG_HAVE_MEMORYLESS_NODES */
 
-#define numa_mem numa_node
 static inline void set_numa_mem(int node) {}
 
 static inline void set_cpu_numa_mem(int cpu, int node) {}
 
-#endif	/* [!]CONFIG_HAVE_MEMORYLESS_NODES */
-
 #ifndef numa_mem_id
 /* Returns the number of the nearest Node with memory */
 static inline int numa_mem_id(void)
 {
-	return __this_cpu_read(numa_mem);
+	return numa_node_id();
 }
 #endif
 
 #ifndef cpu_to_mem
 static inline int cpu_to_mem(int cpu)
 {
-	return per_cpu(numa_mem, cpu);
+	return cpu_to_node(cpu);
 }
 #endif
 
+#endif	/* [!]CONFIG_HAVE_MEMORYLESS_NODES */
+
 #ifndef topology_physical_package_id
 #define topology_physical_package_id(cpu)	((void)(cpu), -1)
 #endif
diff -puN mm/page_alloc.c~numa-introduce-numa_mem_id-effective-local-memory-node-id-fix3 mm/page_alloc.c
--- a/mm/page_alloc.c~numa-introduce-numa_mem_id-effective-local-memory-node-id-fix3
+++ a/mm/page_alloc.c
@@ -63,8 +63,14 @@ EXPORT_PER_CPU_SYMBOL(numa_node);
 #endif
 
 #ifdef CONFIG_HAVE_MEMORYLESS_NODES
-DEFINE_PER_CPU(int, numa_mem);		/* Kernel "local memory" node */
-EXPORT_PER_CPU_SYMBOL(numa_mem);
+/*
+ * N.B., Do NOT reference the '_numa_mem_' per cpu variable directly.
+ * It will not be defined when CONFIG_HAVE_MEMORYLESS_NODES is not defined.
+ * Use the accessor functions set_numa_mem(), numa_mem_id() and cpu_to_mem()
+ * defined in <linux/topology.h>.
+ */
+DEFINE_PER_CPU(int, _numa_mem_);		/* Kernel "local memory" node */
+EXPORT_PER_CPU_SYMBOL(_numa_mem_);
 #endif
 
 /*
_

Patches currently in -mm which might be from lee.schermerhorn@hp.com are

origin.patch
mempolicy-remove-case-mpol_interleave-from-policy_zonelist.patch
mempolicy-remove-redundant-check.patch
mempolicy-dont-call-mpol_set_nodemask-when-no_context.patch
mempolicy-lose-unnecessary-loop-variable-in-mpol_parse_str.patch
mempolicy-rename-policy_types-and-cleanup-initialization.patch
mempolicy-factor-mpol_shared_policy_init-return-paths.patch
mempolicy-document-cpuset-interaction-with-tmpfs-mpol-mount-option.patch
mempolicy-restructure-rebinding-mempolicy-functions.patch
cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems.patch
cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems-fix.patch
cpusetmm-fix-no-node-to-alloc-memory-when-changing-cpusets-mems-fix2.patch
numa-add-generic-percpu-var-numa_node_id-implementation.patch
numa-add-generic-percpu-var-numa_node_id-implementation-fix1.patch
numa-add-generic-percpu-var-numa_node_id-implementation-fix2.patch
numa-x86_64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix1.patch
numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix2.patch
numa-ia64-use-generic-percpu-var-numa_node_id-implementation.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id-fix.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id-fix2.patch
numa-introduce-numa_mem_id-effective-local-memory-node-id-fix3.patch
numa-ia64-support-numa_mem_id-for-memoryless-nodes.patch
numa-slab-use-numa_mem_id-for-slab-local-memory-node.patch
numa-in-kernel-profiling-use-cpu_to_mem-for-per-cpu-allocations.patch
numa-update-documentation-vm-numa-add-memoryless-node-info.patch
numa-update-documentation-vm-numa-add-memoryless-node-info-fix1.patch

