From: akpm@linux-foundation.org
Subject: + numa-add-generic-percpu-var-numa_node_id-implementation.patch added to -mm tree
Date: Fri, 16 Apr 2010 13:35:23 -0700
Message-ID: <201004162035.o3GKZNdQ025731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932396Ab0DPUgz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Apr 2010 16:36:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, cl@linux-foundation.org, eric.whitney@hp.com, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, linux-arch@vger.kernel.org, mel@csn.ul.ie, mingo@elte.hu, npiggin@suse.de, penberg@cs.helsinki.fi, rientjes@google.com, tglx@linutronix.de, tj@kernel.org, tony.luck@intel.com


The patch titled
     numa: add generic percpu var numa_node_id() implementation
has been added to the -mm tree.  Its filename is
     numa-add-generic-percpu-var-numa_node_id-implementation.patch

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
Subject: numa: add generic percpu var numa_node_id() implementation
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Rework the generic version of the numa_node_id() function to use the new
generic percpu variable infrastructure.

Guard the new implementation with a new config option:

        CONFIG_USE_PERCPU_NUMA_NODE_ID.

Archs which support this new implemention will default this option to 'y'
when NUMA is configured.  This config option could be removed if/when all
archs switch over to the generic percpu implementation of numa_node_id(). 
Arch support involves:

  1) converting any existing per cpu variable implementations to use
     this implementation.  x86_64 is an instance of such an arch.
  2) archs that don't use a per cpu variable for numa_node_id() will
     need to initialize the new per cpu variable "numa_node" as cpus
     are brought on-line.  ia64 is an example.
  3) Defining USE_PERCPU_NUMA_NODE_ID in arch dependent Kconfig--e.g.,
     when NUMA is configured.  This is required because I have
     retained the old implementation by default to allow archs to
     be modified incrementally, as desired.

Subsequent patches will convert x86_64 and ia64 to use this implemenation.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
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

 include/linux/topology.h |   33 ++++++++++++++++++++++++++++-----
 mm/page_alloc.c          |    5 +++++
 2 files changed, 33 insertions(+), 5 deletions(-)

diff -puN include/linux/topology.h~numa-add-generic-percpu-var-numa_node_id-implementation include/linux/topology.h
--- a/include/linux/topology.h~numa-add-generic-percpu-var-numa_node_id-implementation
+++ a/include/linux/topology.h
@@ -31,6 +31,7 @@
 #include <linux/bitops.h>
 #include <linux/mmzone.h>
 #include <linux/smp.h>
+#include <linux/percpu.h>
 #include <asm/topology.h>
 
 #ifndef node_has_online_mem
@@ -203,8 +204,35 @@ int arch_update_cpu_topology(void);
 #ifndef SD_NODE_INIT
 #error Please define an appropriate SD_NODE_INIT in include/asm/topology.h!!!
 #endif
+
 #endif /* CONFIG_NUMA */
 
+#ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
+DECLARE_PER_CPU(int, numa_node);
+
+#ifndef numa_node_id
+/* Returns the number of the current Node. */
+#define numa_node_id()		__this_cpu_read(numa_node)
+#endif
+
+#ifndef cpu_to_node
+#define cpu_to_node(__cpu)	per_cpu(numa_node, (__cpu))
+#endif
+
+#ifndef set_numa_node
+#define set_numa_node(__node) percpu_write(numa_node, __node)
+#endif
+
+#else	/* !CONFIG_USE_PERCPU_NUMA_NODE_ID */
+
+/* Returns the number of the current Node. */
+#ifndef numa_node_id
+#define numa_node_id()		(cpu_to_node(raw_smp_processor_id()))
+
+#endif
+
+#endif	/* [!]CONFIG_USE_PERCPU_NUMA_NODE_ID */
+
 #ifndef topology_physical_package_id
 #define topology_physical_package_id(cpu)	((void)(cpu), -1)
 #endif
@@ -218,9 +246,4 @@ int arch_update_cpu_topology(void);
 #define topology_core_cpumask(cpu)		cpumask_of(cpu)
 #endif
 
-/* Returns the number of the current Node. */
-#ifndef numa_node_id
-#define numa_node_id()		(cpu_to_node(raw_smp_processor_id()))
-#endif
-
 #endif /* _LINUX_TOPOLOGY_H */
diff -puN mm/page_alloc.c~numa-add-generic-percpu-var-numa_node_id-implementation mm/page_alloc.c
--- a/mm/page_alloc.c~numa-add-generic-percpu-var-numa_node_id-implementation
+++ a/mm/page_alloc.c
@@ -57,6 +57,11 @@
 #include <asm/div64.h>
 #include "internal.h"
 
+#ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
+DEFINE_PER_CPU(int, numa_node);
+EXPORT_PER_CPU_SYMBOL(numa_node);
+#endif
+
 /*
  * Array of node states.
  */
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

