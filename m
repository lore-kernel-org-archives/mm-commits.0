From: akpm@linux-foundation.org
Subject: + slub-avoid-page-struct-cacheline-bouncing-due-to-remote-frees-to-cpu-slab.patch added to -mm tree
Date: Fri, 24 Aug 2007 14:45:12 -0700
Message-ID: <200708242145.l7OLjCG8016211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45004 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755594AbXHXVpS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:45:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: Avoid page struct cacheline bouncing due to remote frees to cpu slab
has been added to the -mm tree.  Its filename is
     slub-avoid-page-struct-cacheline-bouncing-due-to-remote-frees-to-cpu-slab.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: Avoid page struct cacheline bouncing due to remote frees to cpu slab
From: Christoph Lameter <clameter@sgi.com>

A remote free may access the same page struct that also contains the lockless
freelist for the cpu slab. If objects have a short lifetime and are freed by
a different processor then remote frees back to the slab from which we are
currently allocating are frequent. The cacheline with the page struct needs
to be repeately acquired in exclusive mode by both the allocating thread and
the freeing thread. If this is frequent enough then performance will suffer
because of cacheline bouncing.

This patchset puts the lockless_freelist pointer in its own cacheline. In
order to make that happen we introduce a per cpu structure called
kmem_cache_cpu.

Instead of keeping an array of pointers to page structs we now keep an array
to a per cpu structure that--among other things--contains the pointer to the
lockless freelist. The freeing thread can then keep possession of exclusive
access to the page struct cacheline while the allocating thread keeps its
exclusive access to the cacheline containing the per cpu structure.

This works as long as the allocating cpu is able to service its request
from the lockless freelist. If the lockless freelist runs empty then the
allocating thread needs to acquire exclusive access to the cacheline with
the page struct lock the slab.

The allocating thread will then check if new objects were freed to the per
cpu slab. If so it will keep the slab as the cpu slab and continue with the
recently remote freed objects. So the allocating thread can take a series
of just freed remote pages and dish them out again. Ideally allocations
could be just recycling objects in the same slab this way which will lead
to an ideal allocation / remote free pattern.

The number of objects that can be handled in this way is limited by the
capacity of one slab. Increasing slab size via slub_min_objects/
slub_max_order may increase the number of objects and therefore performance.

If the allocating thread runs out of objects and finds that no objects were
put back by the remote processor then it will retrieve a new slab (from the
partial lists or from the page allocator) and start with a whole
new set of objects while the remote thread may still be freeing objects to
the old cpu slab. This may then repeat until the new slab is also exhausted.
If remote freeing has freed objects in the earlier slab then that earlier
slab will now be on the partial freelist and the allocating thread will
pick that slab next for allocation. So the loop is extended. However,
both threads need to take the list_lock to make the swizzling via
the partial list happen.

It is likely that this kind of scheme will keep the objects being passed
around to a small set that can be kept in the cpu caches leading to increased
performance.

More code cleanups become possible:

- Instead of passing a cpu we can now pass a kmem_cache_cpu structure around.
  Allows reducing the number of parameters to various functions.
- Can define a new node_match() function for NUMA to encapsulate locality
  checks.

Effect on allocations:

Cachelines touched before this patch:

	Write:	page cache struct and first cacheline of object

Cachelines touched after this patch:

	Write:	kmem_cache_cpu cacheline and first cacheline of object
	Read: page cache struct (but see later patch that avoids touching
		that cacheline)

The handling when the lockless alloc list runs empty gets to be a bit more
complicated since another cacheline has now to be written to. But that is
halfway out of the hot path.

Effect on freeing:

Cachelines touched before this patch:

	Write: page_struct and first cacheline of object

Cachelines touched after this patch depending on how we free:

  Write(to cpu_slab):	kmem_cache_cpu struct and first cacheline of object
  Write(to other):	page struct and first cacheline of object

  Read(to cpu_slab):	page struct to id slab etc. (but see later patch that
  			avoids touching the page struct on free)
  Read(to other):	cpu local kmem_cache_cpu struct to verify its not
  			the cpu slab.

Summary:

Pro:
	- Distinct cachelines so that concurrent remote frees and local
	  allocs on a cpuslab can occur without cacheline bouncing.
	- Avoids potential bouncing cachelines because of neighboring
	  per cpu pointer updates in kmem_cache's cpu_slab structure since
	  it now grows to a cacheline (Therefore remove the comment
	  that talks about that concern).

Cons:
	- Freeing objects now requires the reading of one additional
	  cacheline. That can be mitigated for some cases by the following
	  patches but its not possible to completely eliminate these
	  references.

	- Memory usage grows slightly.

	The size of each per cpu object is blown up from one word
	(pointing to the page_struct) to one cacheline with various data.
	So this is NR_CPUS*NR_SLABS*L1_BYTES more memory use. Lets say
	NR_SLABS is 100 and a cache line size of 128 then we have just
	increased SLAB metadata requirements by 12.8k per cpu.
	(Another later patch reduces these requirements)

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    9 +
 mm/slub.c                |  190 ++++++++++++++++++++++---------------
 2 files changed, 124 insertions(+), 75 deletions(-)

diff -puN include/linux/slub_def.h~slub-avoid-page-struct-cacheline-bouncing-due-to-remote-frees-to-cpu-slab include/linux/slub_def.h
--- a/include/linux/slub_def.h~slub-avoid-page-struct-cacheline-bouncing-due-to-remote-frees-to-cpu-slab
+++ a/include/linux/slub_def.h
@@ -11,6 +11,13 @@
 #include <linux/workqueue.h>
 #include <linux/kobject.h>
 
+struct kmem_cache_cpu {
+	void **freelist;
+	struct page *page;
+	int node;
+	/* Lots of wasted space */
+} ____cacheline_aligned_in_smp;
+
 struct kmem_cache_node {
 	spinlock_t list_lock;	/* Protect partial list and nr_partial */
 	unsigned long nr_partial;
@@ -54,7 +61,7 @@ struct kmem_cache {
 	int defrag_ratio;
 	struct kmem_cache_node *node[MAX_NUMNODES];
 #endif
-	struct page *cpu_slab[NR_CPUS];
+	struct kmem_cache_cpu cpu_slab[NR_CPUS];
 };
 
 /*
diff -puN mm/slub.c~slub-avoid-page-struct-cacheline-bouncing-due-to-remote-frees-to-cpu-slab mm/slub.c
--- a/mm/slub.c~slub-avoid-page-struct-cacheline-bouncing-due-to-remote-frees-to-cpu-slab
+++ a/mm/slub.c
@@ -90,7 +90,7 @@
  * 			One use of this flag is to mark slabs that are
  * 			used for allocations. Then such a slab becomes a cpu
  * 			slab. The cpu slab may be equipped with an additional
- * 			lockless_freelist that allows lockless access to
+ * 			freelist that allows lockless access to
  * 			free objects in addition to the regular freelist
  * 			that requires the slab lock.
  *
@@ -140,11 +140,6 @@ static inline void ClearSlabDebug(struct
 /*
  * Issues still to be resolved:
  *
- * - The per cpu array is updated for each new slab and and is a remote
- *   cacheline for most nodes. This could become a bouncing cacheline given
- *   enough frequent updates. There are 16 pointers in a cacheline, so at
- *   max 16 cpus could compete for the cacheline which may be okay.
- *
  * - Support PAGE_ALLOC_DEBUG. Should be easy to do.
  *
  * - Variable sizing of the per node arrays
@@ -277,6 +272,11 @@ static inline struct kmem_cache_node *ge
 #endif
 }
 
+static inline struct kmem_cache_cpu *get_cpu_slab(struct kmem_cache *s, int cpu)
+{
+	return &s->cpu_slab[cpu];
+}
+
 static inline int check_valid_pointer(struct kmem_cache *s,
 				struct page *page, const void *object)
 {
@@ -1378,33 +1378,34 @@ static void unfreeze_slab(struct kmem_ca
 /*
  * Remove the cpu slab
  */
-static void deactivate_slab(struct kmem_cache *s, struct page *page, int cpu)
+static void deactivate_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
 {
+	struct page *page = c->page;
 	/*
 	 * Merge cpu freelist into freelist. Typically we get here
 	 * because both freelists are empty. So this is unlikely
 	 * to occur.
 	 */
-	while (unlikely(page->lockless_freelist)) {
+	while (unlikely(c->freelist)) {
 		void **object;
 
 		/* Retrieve object from cpu_freelist */
-		object = page->lockless_freelist;
-		page->lockless_freelist = page->lockless_freelist[page->offset];
+		object = c->freelist;
+		c->freelist = c->freelist[page->offset];
 
 		/* And put onto the regular freelist */
 		object[page->offset] = page->freelist;
 		page->freelist = object;
 		page->inuse--;
 	}
-	s->cpu_slab[cpu] = NULL;
+	c->page = NULL;
 	unfreeze_slab(s, page);
 }
 
-static inline void flush_slab(struct kmem_cache *s, struct page *page, int cpu)
+static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
 {
-	slab_lock(page);
-	deactivate_slab(s, page, cpu);
+	slab_lock(c->page);
+	deactivate_slab(s, c);
 }
 
 /*
@@ -1413,18 +1414,17 @@ static inline void flush_slab(struct kme
  */
 static inline void __flush_cpu_slab(struct kmem_cache *s, int cpu)
 {
-	struct page *page = s->cpu_slab[cpu];
+	struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
 
-	if (likely(page))
-		flush_slab(s, page, cpu);
+	if (likely(c && c->page))
+		flush_slab(s, c);
 }
 
 static void flush_cpu_slab(void *d)
 {
 	struct kmem_cache *s = d;
-	int cpu = smp_processor_id();
 
-	__flush_cpu_slab(s, cpu);
+	__flush_cpu_slab(s, smp_processor_id());
 }
 
 static void flush_all(struct kmem_cache *s)
@@ -1441,6 +1441,19 @@ static void flush_all(struct kmem_cache 
 }
 
 /*
+ * Check if the objects in a per cpu structure fit numa
+ * locality expectations.
+ */
+static inline int node_match(struct kmem_cache_cpu *c, int node)
+{
+#ifdef CONFIG_NUMA
+	if (node != -1 && c->node != node)
+		return 0;
+#endif
+	return 1;
+}
+
+/*
  * Slow path. The lockless freelist is empty or we need to perform
  * debugging duties.
  *
@@ -1458,45 +1471,46 @@ static void flush_all(struct kmem_cache 
  * we need to allocate a new slab. This is slowest path since we may sleep.
  */
 static void *__slab_alloc(struct kmem_cache *s,
-		gfp_t gfpflags, int node, void *addr, struct page *page)
+		gfp_t gfpflags, int node, void *addr, struct kmem_cache_cpu *c)
 {
 	void **object;
-	int cpu = smp_processor_id();
+	struct page *new;
 
-	if (!page)
+	if (!c->page)
 		goto new_slab;
 
-	slab_lock(page);
-	if (unlikely(node != -1 && page_to_nid(page) != node))
+	slab_lock(c->page);
+	if (unlikely(!node_match(c, node)))
 		goto another_slab;
 load_freelist:
-	object = page->freelist;
+	object = c->page->freelist;
 	if (unlikely(!object))
 		goto another_slab;
-	if (unlikely(SlabDebug(page)))
+	if (unlikely(SlabDebug(c->page)))
 		goto debug;
 
-	object = page->freelist;
-	page->lockless_freelist = object[page->offset];
-	page->inuse = s->objects;
-	page->freelist = NULL;
-	slab_unlock(page);
+	object = c->page->freelist;
+	c->freelist = object[c->page->offset];
+	c->page->inuse = s->objects;
+	c->page->freelist = NULL;
+	c->node = page_to_nid(c->page);
+	slab_unlock(c->page);
 	return object;
 
 another_slab:
-	deactivate_slab(s, page, cpu);
+	deactivate_slab(s, c);
 
 new_slab:
-	page = get_partial(s, gfpflags, node);
-	if (page) {
-		s->cpu_slab[cpu] = page;
+	new = get_partial(s, gfpflags, node);
+	if (new) {
+		c->page = new;
 		goto load_freelist;
 	}
 
-	page = new_slab(s, gfpflags, node);
-	if (page) {
-		cpu = smp_processor_id();
-		if (s->cpu_slab[cpu]) {
+	new = new_slab(s, gfpflags, node);
+	if (new) {
+		c = get_cpu_slab(s, smp_processor_id());
+		if (c->page) {
 			/*
 			 * Someone else populated the cpu_slab while we
 			 * enabled interrupts, or we have gotten scheduled
@@ -1504,34 +1518,32 @@ new_slab:
 			 * requested node even if __GFP_THISNODE was
 			 * specified. So we need to recheck.
 			 */
-			if (node == -1 ||
-				page_to_nid(s->cpu_slab[cpu]) == node) {
+			if (node_match(c, node)) {
 				/*
 				 * Current cpuslab is acceptable and we
 				 * want the current one since its cache hot
 				 */
-				discard_slab(s, page);
-				page = s->cpu_slab[cpu];
-				slab_lock(page);
+				discard_slab(s, new);
+				slab_lock(c->page);
 				goto load_freelist;
 			}
 			/* New slab does not fit our expectations */
-			flush_slab(s, s->cpu_slab[cpu], cpu);
+			flush_slab(s, c);
 		}
-		slab_lock(page);
-		SetSlabFrozen(page);
-		s->cpu_slab[cpu] = page;
+		slab_lock(new);
+		SetSlabFrozen(new);
+		c->page = new;
 		goto load_freelist;
 	}
 	return NULL;
 debug:
-	object = page->freelist;
-	if (!alloc_debug_processing(s, page, object, addr))
+	object = c->page->freelist;
+	if (!alloc_debug_processing(s, c->page, object, addr))
 		goto another_slab;
 
-	page->inuse++;
-	page->freelist = object[page->offset];
-	slab_unlock(page);
+	c->page->inuse++;
+	c->page->freelist = object[c->page->offset];
+	slab_unlock(c->page);
 	return object;
 }
 
@@ -1548,20 +1560,20 @@ debug:
 static void __always_inline *slab_alloc(struct kmem_cache *s,
 		gfp_t gfpflags, int node, void *addr)
 {
-	struct page *page;
 	void **object;
 	unsigned long flags;
+	struct kmem_cache_cpu *c;
 
 	local_irq_save(flags);
-	page = s->cpu_slab[smp_processor_id()];
-	if (unlikely(!page || !page->lockless_freelist ||
-			(node != -1 && page_to_nid(page) != node)))
+	c = get_cpu_slab(s, smp_processor_id());
+	if (unlikely(!c->page || !c->freelist ||
+					!node_match(c, node)))
 
-		object = __slab_alloc(s, gfpflags, node, addr, page);
+		object = __slab_alloc(s, gfpflags, node, addr, c);
 
 	else {
-		object = page->lockless_freelist;
-		page->lockless_freelist = object[page->offset];
+		object = c->freelist;
+		c->freelist = object[c->page->offset];
 	}
 	local_irq_restore(flags);
 
@@ -1659,13 +1671,14 @@ static void __always_inline slab_free(st
 {
 	void **object = (void *)x;
 	unsigned long flags;
+	struct kmem_cache_cpu *c;
 
 	local_irq_save(flags);
 	debug_check_no_locks_freed(object, s->objsize);
-	if (likely(page == s->cpu_slab[smp_processor_id()] &&
-						!SlabDebug(page))) {
-		object[page->offset] = page->lockless_freelist;
-		page->lockless_freelist = object;
+	c = get_cpu_slab(s, smp_processor_id());
+	if (likely(page == c->page && !SlabDebug(page))) {
+		object[page->offset] = c->freelist;
+		c->freelist = object;
 	} else
 		__slab_free(s, page, x, addr);
 
@@ -1853,6 +1866,24 @@ static unsigned long calculate_alignment
 	return ALIGN(align, sizeof(void *));
 }
 
+static void init_kmem_cache_cpu(struct kmem_cache *s,
+			struct kmem_cache_cpu *c)
+{
+	c->page = NULL;
+	c->freelist = NULL;
+	c->node = 0;
+}
+
+static inline int alloc_kmem_cache_cpus(struct kmem_cache *s, gfp_t flags)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		init_kmem_cache_cpu(s, get_cpu_slab(s, cpu));
+
+	return 1;
+}
+
 static void init_kmem_cache_node(struct kmem_cache_node *n)
 {
 	n->nr_partial = 0;
@@ -2103,8 +2134,10 @@ static int kmem_cache_open(struct kmem_c
 #ifdef CONFIG_NUMA
 	s->defrag_ratio = 100;
 #endif
+	if (!init_kmem_cache_nodes(s, gfpflags & ~SLUB_DMA))
+		goto error;
 
-	if (init_kmem_cache_nodes(s, gfpflags & ~SLUB_DMA))
+	if (alloc_kmem_cache_cpus(s, gfpflags & ~SLUB_DMA))
 		return 1;
 error:
 	if (flags & SLAB_PANIC)
@@ -2638,7 +2671,7 @@ void __init kmem_cache_init(void)
 #endif
 
 	kmem_size = offsetof(struct kmem_cache, cpu_slab) +
-				nr_cpu_ids * sizeof(struct page *);
+				nr_cpu_ids * sizeof(struct kmem_cache_cpu);
 
 	printk(KERN_INFO "SLUB: Genslabs=%d, HWalign=%d, Order=%d-%d, MinObjects=%d,"
 		" CPUs=%d, Nodes=%d\n",
@@ -3240,11 +3273,14 @@ static unsigned long slab_objects(struct
 	per_cpu = nodes + nr_node_ids;
 
 	for_each_possible_cpu(cpu) {
-		struct page *page = s->cpu_slab[cpu];
-		int node;
+		struct page *page;
+		struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
 
+		if (!c)
+			continue;
+
+		page = c->page;
 		if (page) {
-			node = page_to_nid(page);
 			if (flags & SO_CPU) {
 				int x = 0;
 
@@ -3253,9 +3289,9 @@ static unsigned long slab_objects(struct
 				else
 					x = 1;
 				total += x;
-				nodes[node] += x;
+				nodes[c->node] += x;
 			}
-			per_cpu[node]++;
+			per_cpu[c->node]++;
 		}
 	}
 
@@ -3301,13 +3337,19 @@ static int any_slab_objects(struct kmem_
 	int node;
 	int cpu;
 
-	for_each_possible_cpu(cpu)
-		if (s->cpu_slab[cpu])
+	for_each_possible_cpu(cpu) {
+		struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
+
+		if (c && c->page)
 			return 1;
+	}
 
-	for_each_node(node) {
+	for_each_online_node(node) {
 		struct kmem_cache_node *n = get_node(s, node);
 
+		if (!n)
+			continue;
+
 		if (n->nr_partial || atomic_long_read(&n->nr_slabs))
 			return 1;
 	}
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
