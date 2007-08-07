From: akpm@linux-foundation.org
Subject: + memoryless-nodes-use-n_high_memory-for-cpusets.patch added to -mm tree
Date: Tue, 07 Aug 2007 13:38:37 -0700
Message-ID: <200708072038.l77KcbX9002853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56989 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934949AbXHGUpx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 16:45:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, bob.picco@hp.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, mel@skynet.ie, nacc@us.ibm.com


The patch titled
     Memoryless nodes: Use N_HIGH_MEMORY for cpusets
has been added to the -mm tree.  Its filename is
     memoryless-nodes-use-n_high_memory-for-cpusets.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Memoryless nodes: Use N_HIGH_MEMORY for cpusets
From: Christoph Lameter <clameter@sgi.com>

cpusets try to ensure that any node added to a cpuset's mems_allowed is
on-line and contains memory.  The assumption was that online nodes contained
memory.  Thus, it is possible to add memoryless nodes to a cpuset and then add
tasks to this cpuset.  This results in continuous series of oom-kill and
apparent system hang.

Change cpusets to use node_states[N_HIGH_MEMORY] [a.k.a.  node_memory_map] in
place of node_online_map when vetting memories.  Return error if admin
attempts to write a non-empty mems_allowed node mask containing only
memoryless-nodes.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Bob Picco <bob.picco@hp.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@skynet.ie>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpusets.txt |    7 ++--
 include/linux/cpuset.h    |    2 -
 kernel/cpuset.c           |   56 ++++++++++++++++++++++++------------
 3 files changed, 43 insertions(+), 22 deletions(-)

diff -puN Documentation/cpusets.txt~memoryless-nodes-use-n_high_memory-for-cpusets Documentation/cpusets.txt
--- a/Documentation/cpusets.txt~memoryless-nodes-use-n_high_memory-for-cpusets
+++ a/Documentation/cpusets.txt
@@ -35,7 +35,8 @@ CONTENTS:
 ----------------------
 
 Cpusets provide a mechanism for assigning a set of CPUs and Memory
-Nodes to a set of tasks.
+Nodes to a set of tasks.   In this document "Memory Node" refers to
+an on-line node that contains memory.
 
 Cpusets constrain the CPU and Memory placement of tasks to only
 the resources within a tasks current cpuset.  They form a nested
@@ -220,8 +221,8 @@ and name space for cpusets, with a minim
 The cpus and mems files in the root (top_cpuset) cpuset are
 read-only.  The cpus file automatically tracks the value of
 cpu_online_map using a CPU hotplug notifier, and the mems file
-automatically tracks the value of node_online_map using the
-cpuset_track_online_nodes() hook.
+automatically tracks the value of node_states[N_MEMORY]--i.e.,
+nodes with memory--using the cpuset_track_online_nodes() hook.
 
 
 1.4 What are exclusive cpusets ?
diff -puN include/linux/cpuset.h~memoryless-nodes-use-n_high_memory-for-cpusets include/linux/cpuset.h
--- a/include/linux/cpuset.h~memoryless-nodes-use-n_high_memory-for-cpusets
+++ a/include/linux/cpuset.h
@@ -93,7 +93,7 @@ static inline nodemask_t cpuset_mems_all
 	return node_possible_map;
 }
 
-#define cpuset_current_mems_allowed (node_online_map)
+#define cpuset_current_mems_allowed (node_states[N_HIGH_MEMORY])
 static inline void cpuset_init_current_mems_allowed(void) {}
 static inline void cpuset_update_task_memory_state(void) {}
 #define cpuset_nodes_subset_current_mems_allowed(nodes) (1)
diff -puN kernel/cpuset.c~memoryless-nodes-use-n_high_memory-for-cpusets kernel/cpuset.c
--- a/kernel/cpuset.c~memoryless-nodes-use-n_high_memory-for-cpusets
+++ a/kernel/cpuset.c
@@ -581,26 +581,28 @@ static void guarantee_online_cpus(const 
 
 /*
  * Return in *pmask the portion of a cpusets's mems_allowed that
- * are online.  If none are online, walk up the cpuset hierarchy
- * until we find one that does have some online mems.  If we get
- * all the way to the top and still haven't found any online mems,
- * return node_online_map.
+ * are online, with memory.  If none are online with memory, walk
+ * up the cpuset hierarchy until we find one that does have some
+ * online mems.  If we get all the way to the top and still haven't
+ * found any online mems, return node_states[N_HIGH_MEMORY].
  *
  * One way or another, we guarantee to return some non-empty subset
- * of node_online_map.
+ * of node_states[N_HIGH_MEMORY].
  *
  * Call with callback_mutex held.
  */
 
 static void guarantee_online_mems(const struct cpuset *cs, nodemask_t *pmask)
 {
-	while (cs && !nodes_intersects(cs->mems_allowed, node_online_map))
+	while (cs && !nodes_intersects(cs->mems_allowed,
+					node_states[N_HIGH_MEMORY]))
 		cs = cs->parent;
 	if (cs)
-		nodes_and(*pmask, cs->mems_allowed, node_online_map);
+		nodes_and(*pmask, cs->mems_allowed,
+					node_states[N_HIGH_MEMORY]);
 	else
-		*pmask = node_online_map;
-	BUG_ON(!nodes_intersects(*pmask, node_online_map));
+		*pmask = node_states[N_HIGH_MEMORY];
+	BUG_ON(!nodes_intersects(*pmask, node_states[N_HIGH_MEMORY]));
 }
 
 /**
@@ -924,7 +926,10 @@ static int update_nodemask(struct cpuset
 	int fudge;
 	int retval;
 
-	/* top_cpuset.mems_allowed tracks node_online_map; it's read-only */
+	/*
+	 * top_cpuset.mems_allowed tracks node_stats[N_HIGH_MEMORY];
+	 * it's read-only
+	 */
 	if (cs == &top_cpuset)
 		return -EACCES;
 
@@ -941,8 +946,21 @@ static int update_nodemask(struct cpuset
 		retval = nodelist_parse(buf, trialcs.mems_allowed);
 		if (retval < 0)
 			goto done;
+		if (!nodes_intersects(trialcs.mems_allowed,
+						node_states[N_HIGH_MEMORY])) {
+			/*
+			 * error if only memoryless nodes specified.
+			 */
+			retval = -ENOSPC;
+			goto done;
+		}
 	}
-	nodes_and(trialcs.mems_allowed, trialcs.mems_allowed, node_online_map);
+	/*
+	 * Exclude memoryless nodes.  We know that trialcs.mems_allowed
+	 * contains at least one node with memory.
+	 */
+	nodes_and(trialcs.mems_allowed, trialcs.mems_allowed,
+						node_states[N_HIGH_MEMORY]);
 	oldmem = cs->mems_allowed;
 	if (nodes_equal(oldmem, trialcs.mems_allowed)) {
 		retval = 0;		/* Too easy - nothing to do */
@@ -2098,8 +2116,9 @@ static void guarantee_online_cpus_mems_i
 
 /*
  * The cpus_allowed and mems_allowed nodemasks in the top_cpuset track
- * cpu_online_map and node_online_map.  Force the top cpuset to track
- * whats online after any CPU or memory node hotplug or unplug event.
+ * cpu_online_map and node_states[N_HIGH_MEMORY].  Force the top cpuset to
+ * track what's online after any CPU or memory node hotplug or unplug
+ * event.
  *
  * To ensure that we don't remove a CPU or node from the top cpuset
  * that is currently in use by a child cpuset (which would violate
@@ -2119,7 +2138,7 @@ static void common_cpu_mem_hotplug_unplu
 
 	guarantee_online_cpus_mems_in_subtree(&top_cpuset);
 	top_cpuset.cpus_allowed = cpu_online_map;
-	top_cpuset.mems_allowed = node_online_map;
+	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
 
 	mutex_unlock(&callback_mutex);
 	mutex_unlock(&manage_mutex);
@@ -2147,8 +2166,9 @@ static int cpuset_handle_cpuhp(struct no
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 /*
- * Keep top_cpuset.mems_allowed tracking node_online_map.
- * Call this routine anytime after you change node_online_map.
+ * Keep top_cpuset.mems_allowed tracking node_states[N_HIGH_MEMORY].
+ * Call this routine anytime after you change
+ * node_states[N_HIGH_MEMORY].
  * See also the previous routine cpuset_handle_cpuhp().
  */
 
@@ -2167,7 +2187,7 @@ void cpuset_track_online_nodes(void)
 void __init cpuset_init_smp(void)
 {
 	top_cpuset.cpus_allowed = cpu_online_map;
-	top_cpuset.mems_allowed = node_online_map;
+	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
 
 	hotcpu_notifier(cpuset_handle_cpuhp, 0);
 }
@@ -2309,7 +2329,7 @@ void cpuset_init_current_mems_allowed(vo
  *
  * Description: Returns the nodemask_t mems_allowed of the cpuset
  * attached to the specified @tsk.  Guaranteed to return some non-empty
- * subset of node_online_map, even if this means going outside the
+ * subset of node_states[N_HIGH_MEMORY], even if this means going outside the
  * tasks cpuset.
  **/
 
_

Patches currently in -mm which might be from clameter@sgi.com are

apply-memory-policies-to-top-two-highest-zones-when-highest-zone-is-zone_movable.patch
check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
x86_64-get-mp_bus_to_node-as-early-v2.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default-v2.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86_64-store-core-id-bits-in-cpuinfo_x8.patch
x86_64-use-core-id-bits-for-apicid_to_node-initialization.patch
x86_64-remove-never-used-apic_mapped.patch
x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes.patch
x86_64-family-10h-and-11h-to-k8topology.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static-fix.patch
document-linux-memory-policy-v3.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch
generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
slub-direct-pass-through-of-page-size-or-higher-kmalloc.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-fix-interleave-behavior-for-memoryless-nodes.patch
memoryless-nodes-oom-use-n_high_memory-map-instead-of-constructing-one-on-the-fly.patch
memoryless-nodes-no-need-for-kswapd.patch
memoryless-nodes-slab-support.patch
memoryless-nodes-slub-support.patch
memoryless-nodes-uncached-allocator-updates.patch
memoryless-nodes-allow-profiling-data-to-fall-back-to-other-nodes.patch
memoryless-nodes-update-memory-policy-and-page-migration.patch
memoryless-nodes-add-n_cpu-node-state.patch
memoryless-nodes-drop-one-memoryless-node-boot-warning.patch
memoryless-nodes-fix-gfp_thisnode-behavior.patch
memoryless-nodes-use-n_high_memory-for-cpusets.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
mm-mempolicyc-cleanups.patch
mm-vmstatc-cleanups.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
page-owner-tracking-leak-detector.patch
