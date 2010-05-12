From: akpm@linux-foundation.org
Subject: + numa-introduce-numa_mem_id-effective-local-memory-node-id-fix2.patch added to -mm tree
Date: Wed, 12 May 2010 11:49:26 -0700
Message-ID: <201005121849.o4CInRKD013938@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755078Ab0ELSu0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 14:50:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, cl@linux-foundation.org, eric.whitney@hp.com, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, linux-arch@vger.kernel.org, mel@csn.ul.ie, mingo@elte.hu, npiggin@suse.de, penberg@cs.helsinki.fi, rientjes@google.com, tglx@linutronix.de, tj@kernel.org, tony.luck@intel.com


The patch titled
     numa-introduce-numa_mem_id-effective-local-memory-node-id-fix2
has been added to the -mm tree.  Its filename is
     numa-introduce-numa_mem_id-effective-local-memory-node-id-fix2.patch

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
Subject: numa-introduce-numa_mem_id-effective-local-memory-node-id-fix2
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Incremental patch 1 to
numa-introduce-numa_mem_id-effective-local-memory-node-id.patch
in mmotm 100428-1638.  Atop Andrew's build fix to that patch.

If any of the numa topology functions--numa_mem_id() et al--have not
been overridden by the arch, we can define them as static inline
functions.

Now, since we can no longer use cpu_to_mem() as an lvalue, also
define set_cpu_numa_mem(cpu, node) and use this to initialize the
per cpu numa_mem variable in __build_all_zonelists().

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

 include/linux/topology.h |   24 +++++++++++++++++++++---
 mm/page_alloc.c          |    2 +-
 2 files changed, 22 insertions(+), 4 deletions(-)

diff -puN include/linux/topology.h~numa-introduce-numa_mem_id-effective-local-memory-node-id-fix2 include/linux/topology.h
--- a/include/linux/topology.h~numa-introduce-numa_mem_id-effective-local-memory-node-id-fix2
+++ a/include/linux/topology.h
@@ -256,7 +256,17 @@ static inline int numa_node_id(void)
 DECLARE_PER_CPU(int, numa_mem);
 
 #ifndef set_numa_mem
-#define set_numa_mem(__node) percpu_write(numa_mem, __node)
+static inline void set_numa_mem(int node)
+{
+	percpu_write(numa_mem, node);
+}
+#endif
+
+#ifndef set_cpu_numa_mem
+static inline void set_cpu_numa_mem(int cpu, int node)
+{
+	per_cpu(numa_mem, cpu) = node;
+}
 #endif
 
 #else	/* !CONFIG_HAVE_MEMORYLESS_NODES */
@@ -264,15 +274,23 @@ DECLARE_PER_CPU(int, numa_mem);
 #define numa_mem numa_node
 static inline void set_numa_mem(int node) {}
 
+static inline void set_cpu_numa_mem(int cpu, int node) {}
+
 #endif	/* [!]CONFIG_HAVE_MEMORYLESS_NODES */
 
 #ifndef numa_mem_id
 /* Returns the number of the nearest Node with memory */
-#define numa_mem_id()		__this_cpu_read(numa_mem)
+static inline int numa_mem_id(void)
+{
+	return __this_cpu_read(numa_mem);
+}
 #endif
 
 #ifndef cpu_to_mem
-#define cpu_to_mem(__cpu)	per_cpu(numa_mem, (__cpu))
+static inline int cpu_to_mem(int cpu)
+{
+	return per_cpu(numa_mem, cpu);
+}
 #endif
 
 #ifndef topology_physical_package_id
diff -puN mm/page_alloc.c~numa-introduce-numa_mem_id-effective-local-memory-node-id-fix2 mm/page_alloc.c
--- a/mm/page_alloc.c~numa-introduce-numa_mem_id-effective-local-memory-node-id-fix2
+++ a/mm/page_alloc.c
@@ -3004,7 +3004,7 @@ static int __build_all_zonelists(void *d
 		 * node/memory hotplug, we'll fixup all on-line cpus.
 		 */
 		if (cpu_online(cpu))
-			cpu_to_mem(cpu) = local_memory_node(cpu_to_node(cpu));
+			set_cpu_numa_mem(cpu, local_memory_node(cpu_to_node(cpu)));
 #endif
 	}
 
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

