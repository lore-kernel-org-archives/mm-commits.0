From: akpm@linux-foundation.org
Subject: + numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix2.patch added to -mm tree
Date: Wed, 12 May 2010 11:49:22 -0700
Message-ID: <201005121849.o4CInMaH013934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756035Ab0ELSue (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 14:50:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lee.schermerhorn@hp.com, cl@linux-foundation.org, eric.whitney@hp.com, hpa@zytor.com, kamezawa.hiroyu@jp.fujitsu.com, linux-arch@vger.kernel.org, mel@csn.ul.ie, mingo@elte.hu, npiggin@suse.de, penberg@cs.helsinki.fi, rientjes@google.com, tglx@linutronix.de, tj@kernel.org, tony.luck@intel.com


The patch titled
     numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix2
has been added to the -mm tree.  Its filename is
     numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix2.patch

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
Subject: numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix2
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

Incremental patch 2 to
numa-x86_64-use-generic-percpu-var-numa_node_id-implementation.patch
in 28apr10 mmotm.

Use generic function to set numa_node for a specified cpu as
suggested by Christoph Lameter and seconded by Tejun Heo.

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

 arch/x86/kernel/setup_percpu.c |    2 +-
 arch/x86/mm/numa_64.c          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/setup_percpu.c~numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix2 arch/x86/kernel/setup_percpu.c
--- a/arch/x86/kernel/setup_percpu.c~numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix2
+++ a/arch/x86/kernel/setup_percpu.c
@@ -268,7 +268,7 @@ void __init setup_per_cpu_areas(void)
 	 * make sure boot cpu numa_node is right, when boot cpu is on the
 	 * node that doesn't have mem installed
 	 */
-	per_cpu(numa_node, boot_cpu_id) = early_cpu_to_node(boot_cpu_id);
+	set_cpu_numa_node(boot_cpu_id, early_cpu_to_node(boot_cpu_id));
 #endif
 
 	/* Setup node to cpumask map */
diff -puN arch/x86/mm/numa_64.c~numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix2 arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c~numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix2
+++ a/arch/x86/mm/numa_64.c
@@ -806,7 +806,7 @@ void __cpuinit numa_set_node(int cpu, in
 	per_cpu(x86_cpu_to_node_map, cpu) = node;
 
 	if (node != NUMA_NO_NODE)
-		per_cpu(numa_node, cpu) = node;
+		set_cpu_numa_node(cpu, node);
 }
 
 void __cpuinit numa_clear_node(int cpu)
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

