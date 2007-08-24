From: akpm@linux-foundation.org
Subject: + slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way.patch added to -mm tree
Date: Fri, 24 Aug 2007 14:45:21 -0700
Message-ID: <200708242145.l7OLjLLo016228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43748 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759307AbXHXVpZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:45:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: Place kmem_cache_cpu structures in a NUMA aware way
has been added to the -mm tree.  Its filename is
     slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: Place kmem_cache_cpu structures in a NUMA aware way
From: Christoph Lameter <clameter@sgi.com>

The kmem_cache_cpu structures introduced are currently an array placed in the
kmem_cache struct. Meaning the kmem_cache_cpu structures are overwhelmingly
on the wrong node for systems with a higher amount of nodes. These are
performance critical structures since the per node information has
to be touched for every alloc and free in a slab.

In order to place the kmem_cache_cpu structure optimally we put an array
of pointers to kmem_cache_cpu structs in kmem_cache (similar to SLAB).

However, the kmem_cache_cpu structures can now be allocated in a more
intelligent way.

We would like to put per cpu structures for the same cpu but different
slab caches in cachelines together to save space and decrease the cache
footprint. However, the slab allocators itself control only allocations
per node. We set up a simple per cpu array for every processor with
100 per cpu structures which is usually enough to get them all set up right.
If we run out then we fall back to kmalloc_node. This also solves the
bootstrap problem since we do not have to use slab allocator functions
early in boot to get memory for the small per cpu structures.

Pro:
	- NUMA aware placement improves memory performance
	- All global structures in struct kmem_cache become readonly
	- Dense packing of per cpu structures reduces cacheline
	  footprint in SMP and NUMA.
	- Potential avoidance of exclusive cacheline fetches
	  on the free and alloc hotpath since multiple kmem_cache_cpu
	  structures are in one cacheline. This is particularly important
	  for the kmalloc array.

Cons:
	- Additional reference to one read only cacheline (per cpu
	  array of pointers to kmem_cache_cpu) in both slab_alloc()
	  and slab_free().

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    9 +-
 mm/slub.c                |  162 +++++++++++++++++++++++++++++++++----
 2 files changed, 154 insertions(+), 17 deletions(-)

diff -puN include/linux/slub_def.h~slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way include/linux/slub_def.h
--- a/include/linux/slub_def.h~slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way
+++ a/include/linux/slub_def.h
@@ -16,8 +16,7 @@ struct kmem_cache_cpu {
 	struct page *page;
 	int node;
 	unsigned int offset;
-	/* Lots of wasted space */
-} ____cacheline_aligned_in_smp;
+};
 
 struct kmem_cache_node {
 	spinlock_t list_lock;	/* Protect partial list and nr_partial */
@@ -62,7 +61,11 @@ struct kmem_cache {
 	int defrag_ratio;
 	struct kmem_cache_node *node[MAX_NUMNODES];
 #endif
-	struct kmem_cache_cpu cpu_slab[NR_CPUS];
+#ifdef CONFIG_SMP
+	struct kmem_cache_cpu *cpu_slab[NR_CPUS];
+#else
+	struct kmem_cache_cpu cpu_slab;
+#endif
 };
 
 /*
diff -puN mm/slub.c~slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way mm/slub.c
--- a/mm/slub.c~slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way
+++ a/mm/slub.c
@@ -269,7 +269,11 @@ static inline struct kmem_cache_node *ge
 
 static inline struct kmem_cache_cpu *get_cpu_slab(struct kmem_cache *s, int cpu)
 {
-	return &s->cpu_slab[cpu];
+#ifdef CONFIG_SMP
+	return s->cpu_slab[cpu];
+#else
+	return &s->cpu_slab;
+#endif
 }
 
 static inline int check_valid_pointer(struct kmem_cache *s,
@@ -1831,16 +1835,6 @@ static void init_kmem_cache_cpu(struct k
 	c->node = 0;
 }
 
-static inline int alloc_kmem_cache_cpus(struct kmem_cache *s, gfp_t flags)
-{
-	int cpu;
-
-	for_each_possible_cpu(cpu)
-		init_kmem_cache_cpu(s, get_cpu_slab(s, cpu));
-
-	return 1;
-}
-
 static void init_kmem_cache_node(struct kmem_cache_node *n)
 {
 	n->nr_partial = 0;
@@ -1852,6 +1846,125 @@ static void init_kmem_cache_node(struct 
 #endif
 }
 
+#ifdef CONFIG_SMP
+/*
+ * Per cpu array for per cpu structures.
+ *
+ * The per cpu array places all kmem_cache_cpu structures from one processor
+ * close together meaning that it becomes possible that multiple per cpu
+ * structures are contained in one cacheline. This may be particularly
+ * beneficial for the kmalloc caches.
+ *
+ * A desktop system typically has around 60-80 slabs. With 100 here we are
+ * likely able to get per cpu structures for all caches from the array defined
+ * here. We must be able to cover all kmalloc caches during bootstrap.
+ *
+ * If the per cpu array is exhausted then fall back to kmalloc
+ * of individual cachelines. No sharing is possible then.
+ */
+#define NR_KMEM_CACHE_CPU 100
+
+static DEFINE_PER_CPU(struct kmem_cache_cpu,
+				kmem_cache_cpu)[NR_KMEM_CACHE_CPU];
+
+static DEFINE_PER_CPU(struct kmem_cache_cpu *, kmem_cache_cpu_free);
+
+static struct kmem_cache_cpu *alloc_kmem_cache_cpu(struct kmem_cache *s,
+							int cpu, gfp_t flags)
+{
+	struct kmem_cache_cpu *c = per_cpu(kmem_cache_cpu_free, cpu);
+
+	if (c)
+		per_cpu(kmem_cache_cpu_free, cpu) =
+				(void *)c->freelist;
+	else {
+		/* Table overflow: So allocate ourselves */
+		c = kmalloc_node(
+			ALIGN(sizeof(struct kmem_cache_cpu), cache_line_size()),
+			flags, cpu_to_node(cpu));
+		if (!c)
+			return NULL;
+	}
+
+	init_kmem_cache_cpu(s, c);
+	return c;
+}
+
+static void free_kmem_cache_cpu(struct kmem_cache_cpu *c, int cpu)
+{
+	if (c < per_cpu(kmem_cache_cpu, cpu) ||
+			c > per_cpu(kmem_cache_cpu, cpu) + NR_KMEM_CACHE_CPU) {
+		kfree(c);
+		return;
+	}
+	c->freelist = (void *)per_cpu(kmem_cache_cpu_free, cpu);
+	per_cpu(kmem_cache_cpu_free, cpu) = c;
+}
+
+static void free_kmem_cache_cpus(struct kmem_cache *s)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
+
+		if (c) {
+			s->cpu_slab[cpu] = NULL;
+			free_kmem_cache_cpu(c, cpu);
+		}
+	}
+}
+
+static int alloc_kmem_cache_cpus(struct kmem_cache *s, gfp_t flags)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
+
+		if (c)
+			continue;
+
+		c = alloc_kmem_cache_cpu(s, cpu, flags);
+		if (!c) {
+			free_kmem_cache_cpus(s);
+			return 0;
+		}
+		s->cpu_slab[cpu] = c;
+	}
+	return 1;
+}
+
+/*
+ * Initialize the per cpu array.
+ */
+static void init_alloc_cpu_cpu(int cpu)
+{
+	int i;
+
+	for (i = NR_KMEM_CACHE_CPU - 1; i >= 0; i--)
+		free_kmem_cache_cpu(&per_cpu(kmem_cache_cpu, cpu)[i], cpu);
+}
+
+static void __init init_alloc_cpu(void)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		init_alloc_cpu_cpu(cpu);
+  }
+
+#else
+static inline void free_kmem_cache_cpus(struct kmem_cache *s) {}
+static inline void init_alloc_cpu(void) {}
+
+static inline int alloc_kmem_cache_cpus(struct kmem_cache *s, gfp_t flags)
+{
+	init_kmem_cache_cpu(s, &s->cpu_slab);
+	return 1;
+}
+#endif
+
 #ifdef CONFIG_NUMA
 /*
  * No kmalloc_node yet so do it by hand. We know that this is the first
@@ -1859,7 +1972,8 @@ static void init_kmem_cache_node(struct 
  * possible.
  *
  * Note that this function only works on the kmalloc_node_cache
- * when allocating for the kmalloc_node_cache.
+ * when allocating for the kmalloc_node_cache. This is used for bootstrapping
+ * memory on a fresh node that has no slab structures yet.
  */
 static struct kmem_cache_node *early_kmem_cache_node_alloc(gfp_t gfpflags,
 							   int node)
@@ -2089,6 +2203,7 @@ static int kmem_cache_open(struct kmem_c
 
 	if (alloc_kmem_cache_cpus(s, gfpflags & ~SLUB_DMA))
 		return 1;
+	free_kmem_cache_nodes(s);
 error:
 	if (flags & SLAB_PANIC)
 		panic("Cannot create slab %s size=%lu realsize=%u "
@@ -2171,6 +2286,7 @@ static inline int kmem_cache_close(struc
 	flush_all(s);
 
 	/* Attempt to free all objects */
+	free_kmem_cache_cpus(s);
 	for_each_node_state(node, N_NORMAL_MEMORY) {
 		struct kmem_cache_node *n = get_node(s, node);
 
@@ -2558,6 +2674,8 @@ void __init kmem_cache_init(void)
 	int i;
 	int caches = 0;
 
+	init_alloc_cpu();
+
 #ifdef CONFIG_NUMA
 	/*
 	 * Must first have the slab cache available for the allocations of the
@@ -2618,10 +2736,12 @@ void __init kmem_cache_init(void)
 
 #ifdef CONFIG_SMP
 	register_cpu_notifier(&slab_notifier);
+	kmem_size = offsetof(struct kmem_cache, cpu_slab) +
+				nr_cpu_ids * sizeof(struct kmem_cache_cpu *);
+#else
+	kmem_size = sizeof(struct kmem_cache);
 #endif
 
-	kmem_size = offsetof(struct kmem_cache, cpu_slab) +
-				nr_cpu_ids * sizeof(struct kmem_cache_cpu);
 
 	printk(KERN_INFO "SLUB: Genslabs=%d, HWalign=%d, Order=%d-%d, MinObjects=%d,"
 		" CPUs=%d, Nodes=%d\n",
@@ -2748,15 +2868,29 @@ static int __cpuinit slab_cpuup_callback
 	unsigned long flags;
 
 	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		init_alloc_cpu_cpu(cpu);
+		down_read(&slub_lock);
+		list_for_each_entry(s, &slab_caches, list)
+			s->cpu_slab[cpu] = alloc_kmem_cache_cpu(s, cpu,
+							GFP_KERNEL);
+		up_read(&slub_lock);
+		break;
+
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		down_read(&slub_lock);
 		list_for_each_entry(s, &slab_caches, list) {
+			struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
+
 			local_irq_save(flags);
 			__flush_cpu_slab(s, cpu);
 			local_irq_restore(flags);
+			free_kmem_cache_cpu(c, cpu);
+			s->cpu_slab[cpu] = NULL;
 		}
 		up_read(&slub_lock);
 		break;
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
process_zones-fix-recovery-code.patch
fix-rcu_read_lock-in-page-migraton.patch
do-not-fail-if-we-cannot-register-a-slab-with-sysfs.patch
page-migration-do-not-accept-invalid-nodes-in-the-target-nodeset.patch
check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on.patch
infiniband-work-around-gcc-slub-problem.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes.patch
x86_64-family-10h-and-11h-to-k8topology.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
x86_64-get-mp_bus_to_node-as-early-v3-update.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch
generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch
generic-virtual-memmap-support-vmemmap-generify-initialisation-via-helpers.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation.patch
sparc64-sparsemem_vmemmap-support.patch
sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
ppc64-sparsemem_vmemmap-support-convert-to-new-config-options.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
slub-direct-pass-through-of-page-size-or-higher-kmalloc.patch
slub-slob-use-unlikely-for-kfreezero_or_null_ptr-check.patch
slab-allocators-fail-if-ksize-is-called-with-a-null-parameter.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes-fix.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
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
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch
categorize-gfp-flags.patch
categorize-gfp-flags-fix.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte-fix-update.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
slub-avoid-page-struct-cacheline-bouncing-due-to-remote-frees-to-cpu-slab.patch
slub-do-not-use-page-mapping.patch
slub-move-page-offset-to-kmem_cache_cpu-offset.patch
slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab.patch
slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way.patch
slub-optimize-cacheline-use-for-zeroing.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap.patch
mm-mempolicyc-cleanups.patch
mm-mempolicyc-cleanups-fix.patch
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
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-prefetch.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
page-owner-tracking-leak-detector.patch
