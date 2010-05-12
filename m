From: akpm@linux-foundation.org
Subject: + numa-add-generic-percpu-var-numa_node_id-implementation-fix1.patch added to -mm tree
Date: Wed, 12 May 2010 11:49:15 -0700
Message-ID: <201005121849.o4CInFig013921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58025 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755103Ab0ELSu2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 14:50:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, cl@linux-foundation.org, eric.whitney@hp.com, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, linux-arch@vger.kernel.org, mel@csn.ul.ie, mingo@elte.hu, npiggin@suse.de, penberg@cs.helsinki.fi, rientjes@google.com, tglx@linutronix.de, tj@kernel.org, tony.luck@intel.com


The patch titled
     numa-add-generic-percpu-var-numa_node_id-implementation-fix1
has been added to the -mm tree.  Its filename is
     numa-add-generic-percpu-var-numa_node_id-implementation-fix1.patch

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
Subject: numa-add-generic-percpu-var-numa_node_id-implementation-fix1
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Incremental patch 1 to
numa-add-generic-percpu-var-numa_node_id-implementation.patch in 28apri10
mmotm.

If any of the numa topology functions--numa_node_id() et al--have not been
overridden by the arch, we can define them as static inline functions.

Note that this means that cpu_to_node() can no longer be used as an
lvalue.  However, the tree contains no such usage currently, and a
subsequent patch will add a function to set the 'numa_node' for a
specified cpu.

x86 defines numa_node_id() as a static inline function when CONFIG_NUMA is
not set.  Add #define of numa_node_id to itself to indicate this override
of the default definition, so we can build !NUMA with this patch applied.

   Maybe we should move the default definitions to
   asm-generic/topology.h?  Or remove it altogether?
   x86_64 !NUMA seems to build without it.

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

 arch/x86/include/asm/topology.h |    4 ++++
 include/linux/topology.h        |   21 ++++++++++++++++-----
 2 files changed, 20 insertions(+), 5 deletions(-)

diff -puN arch/x86/include/asm/topology.h~numa-add-generic-percpu-var-numa_node_id-implementation-fix1 arch/x86/include/asm/topology.h
--- a/arch/x86/include/asm/topology.h~numa-add-generic-percpu-var-numa_node_id-implementation-fix1
+++ a/arch/x86/include/asm/topology.h
@@ -170,6 +170,10 @@ static inline int numa_node_id(void)
 {
 	return 0;
 }
+/*
+ * indicate override:
+ */
+#define numa_node_id numa_node_id
 
 static inline int early_cpu_to_node(int cpu)
 {
diff -puN include/linux/topology.h~numa-add-generic-percpu-var-numa_node_id-implementation-fix1 include/linux/topology.h
--- a/include/linux/topology.h~numa-add-generic-percpu-var-numa_node_id-implementation-fix1
+++ a/include/linux/topology.h
@@ -212,23 +212,34 @@ DECLARE_PER_CPU(int, numa_node);
 
 #ifndef numa_node_id
 /* Returns the number of the current Node. */
-#define numa_node_id()		__this_cpu_read(numa_node)
+static inline int numa_node_id(void)
+{
+	return __this_cpu_read(numa_node);
+}
 #endif
 
 #ifndef cpu_to_node
-#define cpu_to_node(__cpu)	per_cpu(numa_node, (__cpu))
+static inline int cpu_to_node(int cpu)
+{
+	return per_cpu(numa_node, cpu);
+}
 #endif
 
 #ifndef set_numa_node
-#define set_numa_node(__node) percpu_write(numa_node, __node)
+static inline void set_numa_node(int node)
+{
+	percpu_write(numa_node, node);
+}
 #endif
 
 #else	/* !CONFIG_USE_PERCPU_NUMA_NODE_ID */
 
 /* Returns the number of the current Node. */
 #ifndef numa_node_id
-#define numa_node_id()		(cpu_to_node(raw_smp_processor_id()))
-
+static inline int numa_node_id(void)
+{
+	return cpu_to_node(raw_smp_processor_id());
+}
 #endif
 
 #endif	/* [!]CONFIG_USE_PERCPU_NUMA_NODE_ID */
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

