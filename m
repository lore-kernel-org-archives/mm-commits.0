From: akpm@linux-foundation.org
Subject: + numa-ia64-use-generic-percpu-var-numa_node_id-implementation.patch added to -mm tree
Date: Fri, 16 Apr 2010 13:35:29 -0700
Message-ID: <201004162035.o3GKZTtg025739@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932503Ab0DPUgr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Apr 2010 16:36:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, cl@linux-foundation.org, eric.whitney@hp.com, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, linux-arch@vger.kernel.org, mel@csn.ul.ie, mingo@elte.hu, npiggin@suse.de, penberg@cs.helsinki.fi, rientjes@google.com, tglx@linutronix.de, tj@kernel.org, tony.luck@intel.com


The patch titled
     numa: ia64: use generic percpu var numa_node_id() implementation
has been added to the -mm tree.  Its filename is
     numa-ia64-use-generic-percpu-var-numa_node_id-implementation.patch

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
Subject: numa: ia64: use generic percpu var numa_node_id() implementation
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

ia64:  Use generic percpu implementation of numa_node_id()
   + intialize per cpu 'numa_node'
   + remove ia64 cpu_to_node() macro;  use generic
   + define CONFIG_USE_PERCPU_NUMA_NODE_ID when NUMA configured

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
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

 arch/ia64/Kconfig                |    4 ++++
 arch/ia64/include/asm/topology.h |    5 -----
 arch/ia64/kernel/smpboot.c       |    6 ++++++
 3 files changed, 10 insertions(+), 5 deletions(-)

diff -puN arch/ia64/Kconfig~numa-ia64-use-generic-percpu-var-numa_node_id-implementation arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~numa-ia64-use-generic-percpu-var-numa_node_id-implementation
+++ a/arch/ia64/Kconfig
@@ -497,6 +497,10 @@ config HAVE_ARCH_NODEDATA_EXTENSION
 	def_bool y
 	depends on NUMA
 
+config USE_PERCPU_NUMA_NODE_ID
+	def_bool y
+	depends on NUMA
+
 config ARCH_PROC_KCORE_TEXT
 	def_bool y
 	depends on PROC_KCORE
diff -puN arch/ia64/include/asm/topology.h~numa-ia64-use-generic-percpu-var-numa_node_id-implementation arch/ia64/include/asm/topology.h
--- a/arch/ia64/include/asm/topology.h~numa-ia64-use-generic-percpu-var-numa_node_id-implementation
+++ a/arch/ia64/include/asm/topology.h
@@ -26,11 +26,6 @@
 #define RECLAIM_DISTANCE 15
 
 /*
- * Returns the number of the node containing CPU 'cpu'
- */
-#define cpu_to_node(cpu) (int)(cpu_to_node_map[cpu])
-
-/*
  * Returns a bitmask of CPUs on Node 'node'.
  */
 #define cpumask_of_node(node) ((node) == -1 ?				\
diff -puN arch/ia64/kernel/smpboot.c~numa-ia64-use-generic-percpu-var-numa_node_id-implementation arch/ia64/kernel/smpboot.c
--- a/arch/ia64/kernel/smpboot.c~numa-ia64-use-generic-percpu-var-numa_node_id-implementation
+++ a/arch/ia64/kernel/smpboot.c
@@ -390,6 +390,11 @@ smp_callin (void)
 
 	fix_b0_for_bsp();
 
+	/*
+	 * numa_node_id() works after this.
+	 */
+	set_numa_node(cpu_to_node_map[cpuid]);
+
 	ipi_call_lock_irq();
 	spin_lock(&vector_lock);
 	/* Setup the per cpu irq handling data structures */
@@ -632,6 +637,7 @@ void __devinit smp_prepare_boot_cpu(void
 {
 	cpu_set(smp_processor_id(), cpu_online_map);
 	cpu_set(smp_processor_id(), cpu_callin_map);
+	set_numa_node(cpu_to_node_map[smp_processor_id()]);
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
 	paravirt_post_smp_prepare_boot_cpu();
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

