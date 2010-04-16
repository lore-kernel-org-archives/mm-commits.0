From: akpm@linux-foundation.org
Subject: + numa-introduce-numa_mem_id-effective-local-memory-node-id.patch added to -mm tree
Date: Fri, 16 Apr 2010 13:35:32 -0700
Message-ID: <201004162035.o3GKZWvf025745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932510Ab0DPUhA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Apr 2010 16:37:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, cl@linux-foundation.org, eric.whitney@hp.com, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, linux-arch@vger.kernel.org, mel@csn.ul.ie, mingo@elte.hu, npiggin@suse.de, penberg@cs.helsinki.fi, rientjes@google.com, tglx@linutronix.de, tj@kernel.org, tony.luck@intel.com


The patch titled
     numa: introduce numa_mem_id()- effective local memory node id
has been added to the -mm tree.  Its filename is
     numa-introduce-numa_mem_id-effective-local-memory-node-id.patch

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
Subject: numa: introduce numa_mem_id()- effective local memory node id
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Introduce numa_mem_id(), based on generic percpu variable infrastructure
to track "nearest node with memory" for archs that support memoryless
nodes.

Define API in <linux/topology.h> when CONFIG_HAVE_MEMORYLESS_NODES
defined, else stubs.  Architectures will define HAVE_MEMORYLESS_NODES
if/when they support them.

Archs can override definitions of:

numa_mem_id() - returns node number of "local memory" node
set_numa_mem() - initialize [this cpus'] per cpu variable 'numa_mem'
cpu_to_mem()  - return numa_mem for specified cpu; may be used as lvalue

Generic initialization of 'numa_mem' occurs in __build_all_zonelists(). 
This will initialize the boot cpu at boot time, and all cpus on change of
numa_zonelist_order, or when node or memory hot-plug requires zonelist
rebuild.  Archs that support memoryless nodes will need to initialize
'numa_mem' for secondary cpus as they're brought on-line.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
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

 include/asm-generic/topology.h |    3 ++
 include/linux/mmzone.h         |    6 ++++
 include/linux/topology.h       |   24 +++++++++++++++++++
 mm/page_alloc.c                |   39 ++++++++++++++++++++++++++++++-
 4 files changed, 71 insertions(+), 1 deletion(-)

diff -puN include/asm-generic/topology.h~numa-introduce-numa_mem_id-effective-local-memory-node-id include/asm-generic/topology.h
--- a/include/asm-generic/topology.h~numa-introduce-numa_mem_id-effective-local-memory-node-id
+++ a/include/asm-generic/topology.h
@@ -34,6 +34,9 @@
 #ifndef cpu_to_node
 #define cpu_to_node(cpu)	((void)(cpu),0)
 #endif
+#ifndef cpu_to_mem
+#define cpu_to_mem(cpu)		(void)(cpu),0)
+#endif
 #ifndef parent_node
 #define parent_node(node)	((void)(node),0)
 #endif
diff -puN include/linux/mmzone.h~numa-introduce-numa_mem_id-effective-local-memory-node-id include/linux/mmzone.h
--- a/include/linux/mmzone.h~numa-introduce-numa_mem_id-effective-local-memory-node-id
+++ a/include/linux/mmzone.h
@@ -670,6 +670,12 @@ void memory_present(int nid, unsigned lo
 static inline void memory_present(int nid, unsigned long start, unsigned long end) {}
 #endif
 
+#ifdef CONFIG_HAVE_MEMORYLESS_NODES
+int local_memory_node(int node_id);
+#else
+static inline int local_memory_node(int node_id) { return node_id; };
+#endif
+
 #ifdef CONFIG_NEED_NODE_MEMMAP_SIZE
 unsigned long __init node_memmap_size_bytes(int, unsigned long, unsigned long);
 #endif
diff -puN include/linux/topology.h~numa-introduce-numa_mem_id-effective-local-memory-node-id include/linux/topology.h
--- a/include/linux/topology.h~numa-introduce-numa_mem_id-effective-local-memory-node-id
+++ a/include/linux/topology.h
@@ -233,6 +233,30 @@ DECLARE_PER_CPU(int, numa_node);
 
 #endif	/* [!]CONFIG_USE_PERCPU_NUMA_NODE_ID */
 
+#ifdef CONFIG_HAVE_MEMORYLESS_NODES
+
+DECLARE_PER_CPU(int, numa_mem);
+
+#ifndef set_numa_mem
+#define set_numa_mem(__node) percpu_write(numa_mem, __node)
+#endif
+
+#else	/* !CONFIG_HAVE_MEMORYLESS_NODES */
+
+#define numa_mem numa_node
+static inline void set_numa_mem(int node) {}
+
+#endif	/* [!]CONFIG_HAVE_MEMORYLESS_NODES */
+
+#ifndef numa_mem_id
+/* Returns the number of the nearest Node with memory */
+#define numa_mem_id()		__this_cpu_read(numa_mem)
+#endif
+
+#ifndef cpu_to_mem
+#define cpu_to_mem(__cpu)	per_cpu(numa_mem, (__cpu))
+#endif
+
 #ifndef topology_physical_package_id
 #define topology_physical_package_id(cpu)	((void)(cpu), -1)
 #endif
diff -puN mm/page_alloc.c~numa-introduce-numa_mem_id-effective-local-memory-node-id mm/page_alloc.c
--- a/mm/page_alloc.c~numa-introduce-numa_mem_id-effective-local-memory-node-id
+++ a/mm/page_alloc.c
@@ -62,6 +62,11 @@ DEFINE_PER_CPU(int, numa_node);
 EXPORT_PER_CPU_SYMBOL(numa_node);
 #endif
 
+#ifdef CONFIG_HAVE_MEMORYLESS_NODES
+DEFINE_PER_CPU(int, numa_mem);		/* Kernel "local memory" node */
+EXPORT_PER_CPU_SYMBOL(numa_mem);
+#endif
+
 /*
  * Array of node states.
  */
@@ -2857,6 +2862,24 @@ static void build_zonelist_cache(pg_data
 		zlc->z_to_n[z - zonelist->_zonerefs] = zonelist_node_idx(z);
 }
 
+#ifdef CONFIG_HAVE_MEMORYLESS_NODES
+/*
+ * Return node id of node used for "local" allocations.
+ * I.e., first node id of first zone in arg node's generic zonelist.
+ * Used for initializing percpu 'numa_mem', which is used primarily
+ * for kernel allocations, so use GFP_KERNEL flags to locate zonelist.
+ */
+int local_memory_node(int node)
+{
+	struct zone *zone;
+
+	(void)first_zones_zonelist(node_zonelist(node, GFP_KERNEL),
+				   gfp_zone(GFP_KERNEL),
+				   NULL,
+				   &zone);
+	return zone->node;
+}
+#endif
 
 #else	/* CONFIG_NUMA */
 
@@ -2956,9 +2979,23 @@ static int __build_all_zonelists(void *d
 	 * needs the percpu allocator in order to allocate its pagesets
 	 * (a chicken-egg dilemma).
 	 */
-	for_each_possible_cpu(cpu)
+	for_each_possible_cpu(cpu) {
 		setup_pageset(&per_cpu(boot_pageset, cpu), 0);
 
+#ifdef CONFIG_HAVE_MEMORYLESS_NODES
+		/*
+		 * We now know the "local memory node" for each node--
+		 * i.e., the node of the first zone in the generic zonelist.
+		 * Set up numa_mem percpu variable for on-line cpus.  During
+		 * boot, only the boot cpu should be on-line;  we'll init the
+		 * secondary cpus' numa_mem as they come on-line.  During
+		 * node/memory hotplug, we'll fixup all on-line cpus.
+		 */
+		if (cpu_online(cpu))
+			cpu_to_mem(cpu) = local_memory_node(cpu_to_node(cpu));
+#endif
+	}
+
 	return 0;
 }
 
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

