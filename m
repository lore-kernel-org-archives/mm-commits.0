From: akpm@linux-foundation.org
Subject: - slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:35:19 -0700
Message-ID: <200710162035.l9GKZJcl015050@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58050 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935959AbXJPVgk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:36:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, akinobu.mita@gmail.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     SLUB: Place kmem_cache_cpu structures in a NUMA aware way
has been removed from the -mm tree.  Its filename was
     slub-place-kmem_cache_cpu-structures-in-a-numa-aware-way.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akinobu.mita@gmail.com: fix cpu hotplug offline/online path]
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    9 +
 mm/slub.c                |  168 +++++++++++++++++++++++++++++++++----
 2 files changed, 160 insertions(+), 17 deletions(-)

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
@@ -1858,16 +1862,6 @@ static void init_kmem_cache_cpu(struct k
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
@@ -1879,6 +1873,131 @@ static void init_kmem_cache_node(struct 
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
+static cpumask_t kmem_cach_cpu_free_init_once = CPU_MASK_NONE;
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
+	if (cpu_isset(cpu, kmem_cach_cpu_free_init_once))
+		return;
+
+	for (i = NR_KMEM_CACHE_CPU - 1; i >= 0; i--)
+		free_kmem_cache_cpu(&per_cpu(kmem_cache_cpu, cpu)[i], cpu);
+
+	cpu_set(cpu, kmem_cach_cpu_free_init_once);
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
@@ -1886,7 +2005,8 @@ static void init_kmem_cache_node(struct 
  * possible.
  *
  * Note that this function only works on the kmalloc_node_cache
- * when allocating for the kmalloc_node_cache.
+ * when allocating for the kmalloc_node_cache. This is used for bootstrapping
+ * memory on a fresh node that has no slab structures yet.
  */
 static struct kmem_cache_node *early_kmem_cache_node_alloc(gfp_t gfpflags,
 							   int node)
@@ -2115,6 +2235,7 @@ static int kmem_cache_open(struct kmem_c
 
 	if (alloc_kmem_cache_cpus(s, gfpflags & ~SLUB_DMA))
 		return 1;
+	free_kmem_cache_nodes(s);
 error:
 	if (flags & SLAB_PANIC)
 		panic("Cannot create slab %s size=%lu realsize=%u "
@@ -2197,6 +2318,7 @@ static inline int kmem_cache_close(struc
 	flush_all(s);
 
 	/* Attempt to free all objects */
+	free_kmem_cache_cpus(s);
 	for_each_node_state(node, N_NORMAL_MEMORY) {
 		struct kmem_cache_node *n = get_node(s, node);
 
@@ -2584,6 +2706,8 @@ void __init kmem_cache_init(void)
 	int i;
 	int caches = 0;
 
+	init_alloc_cpu();
+
 #ifdef CONFIG_NUMA
 	/*
 	 * Must first have the slab cache available for the allocations of the
@@ -2644,10 +2768,12 @@ void __init kmem_cache_init(void)
 
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
@@ -2774,15 +2900,29 @@ static int __cpuinit slab_cpuup_callback
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
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86-fix-cpu_to_node-references.patch
x86-convert-x86_cpu_to_apicid-to-be-a-per-cpu-variable.patch
x86-convert-cpu_llc_id-to-be-a-per-cpu-variable.patch
x86-acpi-use-cpu_physical_id.patch
x86-convert-cpuinfo_x86-array-to-a-per_cpu-array.patch
slub-simplify-irq-off-handling.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix-2.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
oom-move-prototypes-to-appropriate-header-file.patch
oom-move-constraints-to-enum.patch
oom-change-all_unreclaimable-zone-member-to-flags.patch
oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
oom-add-per-zone-locking.patch
oom-serialize-out-of-memory-calls.patch
oom-add-oom_kill_allocating_task-sysctl.patch
oom-suppress-extraneous-stack-and-memory-dump.patch
oom-compare-cpuset-mems_allowed-instead-of-exclusive.patch
oom-do-not-take-callback_mutex.patch
oom-do-not-take-callback_mutex-fix.patch
oom-prevent-including-schedh-in-header-file.patch
oom-add-header-file-to-kbuild-as-unifdef.patch
oom-convert-zone_scan_lock-from-mutex-to-spinlock.patch
mm-test-and-set-zone-reclaim-lock-before-starting.patch
mm-test-and-set-zone-reclaim-lock-before-starting-cleanup.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
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
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
documentation-vm-slabinfoc-clean-up-this-code.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
bit_spin_lock-use-lock-bitops.patch
ext3-support-large-blocksize-up-to-pagesize.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
