From: akpm@linux-foundation.org
Subject: + slub-fix-dynamic-dma-kmalloc-cache-creation.patch added to -mm tree
Date: Wed, 15 Aug 2007 12:54:16 -0700
Message-ID: <200708151954.l7FJsGRa012264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34590 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755265AbXHOTyZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 15:54:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: fix dynamic dma kmalloc cache creation
has been added to the -mm tree.  Its filename is
     slub-fix-dynamic-dma-kmalloc-cache-creation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: fix dynamic dma kmalloc cache creation
From: Christoph Lameter <clameter@sgi.com>

We can avoid the slight chance of failing on the first GFP_ATOMIC|GFP_DMA
allocation through a new spin lock in the ZONE_DMA section if we do not
take the slub_lock in dma_cache_create() but speculatively allocate the
kmem_cache structures and related entities.  Then we take the dma cache
lock and check if the cache was already installed.  If so then we just call
kmem_cache_close() (I moved the flushing from kmem_cache_close() into
kmem_cache_destroy() to make that work and added checking so that
kmem_cache_close() works on a kmem_cache structure that has no nodes
allocated) and then free up the space we allocated.

If we are successful then we schedule the dma_cache_add_func().  The
function now scans over the dma kmalloc caches instead over all the slab
caches.  If it finds a dma kmalloc caches whose adding to the list was
deferred then it will add the kmalloc cache to the slab list in addition to
performing the sysfs add.

This means that during short periods we may have active slab caches that
are not on the slab lists.  We create races with cpu and node hotplug by
doing so.  But maybe they are negligible.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   76 +++++++++++++++++++++++++++-------------------------
 1 files changed, 40 insertions(+), 36 deletions(-)

diff -puN mm/slub.c~slub-fix-dynamic-dma-kmalloc-cache-creation mm/slub.c
--- a/mm/slub.c~slub-fix-dynamic-dma-kmalloc-cache-creation
+++ a/mm/slub.c
@@ -212,7 +212,7 @@ static inline void ClearSlabDebug(struct
 
 /* Internal SLUB flags */
 #define __OBJECT_POISON		0x80000000 /* Poison object */
-#define __SYSFS_ADD_DEFERRED	0x40000000 /* Not yet visible via sysfs */
+#define __SLAB_ADD_DEFERRED	0x40000000 /* Not yet added to list */
 
 /* Not all arches define cache_line_size */
 #ifndef cache_line_size
@@ -2175,15 +2175,15 @@ static inline int kmem_cache_close(struc
 {
 	int node;
 
-	flush_all(s);
-
 	/* Attempt to free all objects */
 	for_each_node_state(node, N_NORMAL_MEMORY) {
 		struct kmem_cache_node *n = get_node(s, node);
 
-		n->nr_partial -= free_list(s, n, &n->partial);
-		if (atomic_long_read(&n->nr_slabs))
-			return 1;
+		if (n) {
+			n->nr_partial -= free_list(s, n, &n->partial);
+			if (atomic_long_read(&n->nr_slabs))
+				return 1;
+		}
 	}
 	free_kmem_cache_nodes(s);
 	return 0;
@@ -2195,6 +2195,7 @@ static inline int kmem_cache_close(struc
  */
 void kmem_cache_destroy(struct kmem_cache *s)
 {
+	flush_all(s);
 	down_write(&slub_lock);
 	s->refcount--;
 	if (!s->refcount) {
@@ -2216,10 +2217,6 @@ EXPORT_SYMBOL(kmem_cache_destroy);
 struct kmem_cache kmalloc_caches[PAGE_SHIFT] __cacheline_aligned;
 EXPORT_SYMBOL(kmalloc_caches);
 
-#ifdef CONFIG_ZONE_DMA
-static struct kmem_cache *kmalloc_caches_dma[PAGE_SHIFT];
-#endif
-
 static int __init setup_slub_min_order(char *str)
 {
 	get_option (&str, &slub_min_order);
@@ -2279,22 +2276,35 @@ panic:
 }
 
 #ifdef CONFIG_ZONE_DMA
+static struct kmem_cache *kmalloc_caches_dma[KMALLOC_SHIFT_HIGH + 1];
+
+static spinlock_t dma_cache_lock;
 
-static void sysfs_add_func(struct work_struct *w)
+static void dma_cache_add_func(struct work_struct *w)
 {
 	struct kmem_cache *s;
+	struct kmem_cache **p;
 
-	down_write(&slub_lock);
-	list_for_each_entry(s, &slab_caches, list) {
-		if (s->flags & __SYSFS_ADD_DEFERRED) {
-			s->flags &= ~__SYSFS_ADD_DEFERRED;
+redo:
+	spin_lock(&dma_cache_lock);
+	for (p = kmalloc_caches_dma;
+		p < kmalloc_caches_dma + KMALLOC_SHIFT_HIGH + 1; p++) {
+		s = *p;
+
+		if (s->flags & __SLAB_ADD_DEFERRED) {
+			spin_unlock(&dma_cache_lock);
+			down_write(&slub_lock);
+			s->flags &= ~__SLAB_ADD_DEFERRED;
+			list_add(&s->list, &slab_caches);
 			sysfs_slab_add(s);
+			up_write(&slub_lock);
+			goto redo;
 		}
 	}
-	up_write(&slub_lock);
+	spin_unlock(&dma_cache_lock);
 }
 
-static DECLARE_WORK(sysfs_add_work, sysfs_add_func);
+static DECLARE_WORK(dma_cache_add_work, dma_cache_add_func);
 
 static noinline struct kmem_cache *dma_kmalloc_cache(int index, gfp_t flags)
 {
@@ -2307,36 +2317,30 @@ static noinline struct kmem_cache *dma_k
 		return s;
 
 	/* Dynamically create dma cache */
-	if (flags & __GFP_WAIT)
-		down_write(&slub_lock);
-	else {
-		if (!down_write_trylock(&slub_lock))
-			goto out;
-	}
-
-	if (kmalloc_caches_dma[index])
-		goto unlock_out;
-
 	realsize = kmalloc_caches[index].objsize;
 	text = kasprintf(flags & ~SLUB_DMA, "kmalloc_dma-%d", (unsigned int)realsize),
 	s = kmalloc(kmem_size, flags & ~SLUB_DMA);
 
 	if (!s || !text || !kmem_cache_open(s, flags, text,
 			realsize, ARCH_KMALLOC_MINALIGN,
-			SLAB_CACHE_DMA|__SYSFS_ADD_DEFERRED, NULL)) {
-		kfree(s);
-		kfree(text);
-		goto unlock_out;
-	}
+			SLAB_CACHE_DMA|__SLAB_ADD_DEFERRED, NULL))
+		goto out;
 
-	list_add(&s->list, &slab_caches);
+	spin_lock(&dma_cache_lock);
+	if (kmalloc_caches_dma[index]) {
+		spin_unlock(&dma_cache_lock);
+		goto out;
+	}
 	kmalloc_caches_dma[index] = s;
+	spin_unlock(&dma_cache_lock);
 
-	schedule_work(&sysfs_add_work);
+	schedule_work(&dma_cache_add_work);
+	return kmalloc_caches_dma[index];
 
-unlock_out:
-	up_write(&slub_lock);
 out:
+	kmem_cache_close(s);
+	kfree(s);
+	kfree(text);
 	return kmalloc_caches_dma[index];
 }
 #endif
_

Patches currently in -mm which might be from clameter@sgi.com are

sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
document-linux-memory-policy-v3.patch
apply-memory-policies-to-top-two-highest-zones-when-highest-zone-is-zone_movable.patch
check-for-pageslab-in-arch-flush_dcache_page-to-avoid-triggering-vm_bug_on.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes.patch
x86_64-family-10h-and-11h-to-k8topology.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
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
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes.patch
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
categorize-gfp-flags.patch
categorize-gfp-flags-fix.patch
slub-fix-dynamic-dma-kmalloc-cache-creation.patch
flush-cache-before-installing-new-page-at-migraton.patch
flush-icache-before-set_pte-on-ia64-flush-icache-at-set_pte.patch
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
