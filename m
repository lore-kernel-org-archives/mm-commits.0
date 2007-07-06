From: akpm@linux-foundation.org
Subject: + slab-allocators-replace-explicit-zeroing-with-__gfp_zero.patch added to -mm tree
Date: Fri, 06 Jul 2007 16:21:28 -0700
Message-ID: <200707062321.l66NLSWe026546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60076 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670AbXGFXVg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 19:21:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     Slab allocators: Replace explicit zeroing with __GFP_ZERO
has been added to the -mm tree.  Its filename is
     slab-allocators-replace-explicit-zeroing-with-__gfp_zero.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Slab allocators: Replace explicit zeroing with __GFP_ZERO
From: Christoph Lameter <clameter@sgi.com>

kmalloc_node() and kmem_cache_alloc_node() were not available in a zeroing
variant in the past.  But with __GFP_ZERO it is possible now to do zeroing
while allocating.

Use __GFP_ZERO to remove the explicit clearing of memory via memset whereever
we can.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/as-iosched.c       |    3 +--
 block/cfq-iosched.c      |   18 +++++++++---------
 block/deadline-iosched.c |    3 +--
 block/elevator.c         |    3 +--
 block/genhd.c            |    8 ++++----
 block/ll_rw_blk.c        |    4 ++--
 drivers/ide/ide-probe.c  |    4 ++--
 kernel/timer.c           |    4 ++--
 lib/genalloc.c           |    3 +--
 mm/allocpercpu.c         |    9 +++------
 mm/mempool.c             |    3 +--
 mm/vmalloc.c             |    6 +++---
 12 files changed, 30 insertions(+), 38 deletions(-)

diff -puN block/as-iosched.c~slab-allocators-replace-explicit-zeroing-with-__gfp_zero block/as-iosched.c
--- a/block/as-iosched.c~slab-allocators-replace-explicit-zeroing-with-__gfp_zero
+++ a/block/as-iosched.c
@@ -1322,10 +1322,9 @@ static void *as_init_queue(request_queue
 {
 	struct as_data *ad;
 
-	ad = kmalloc_node(sizeof(*ad), GFP_KERNEL, q->node);
+	ad = kmalloc_node(sizeof(*ad), GFP_KERNEL | __GFP_ZERO, q->node);
 	if (!ad)
 		return NULL;
-	memset(ad, 0, sizeof(*ad));
 
 	ad->q = q; /* Identify what queue the data belongs to */
 
diff -puN block/cfq-iosched.c~slab-allocators-replace-explicit-zeroing-with-__gfp_zero block/cfq-iosched.c
--- a/block/cfq-iosched.c~slab-allocators-replace-explicit-zeroing-with-__gfp_zero
+++ a/block/cfq-iosched.c
@@ -1249,9 +1249,9 @@ cfq_alloc_io_context(struct cfq_data *cf
 {
 	struct cfq_io_context *cic;
 
-	cic = kmem_cache_alloc_node(cfq_ioc_pool, gfp_mask, cfqd->queue->node);
+	cic = kmem_cache_alloc_node(cfq_ioc_pool, gfp_mask | __GFP_ZERO,
+							cfqd->queue->node);
 	if (cic) {
-		memset(cic, 0, sizeof(*cic));
 		cic->last_end_request = jiffies;
 		INIT_LIST_HEAD(&cic->queue_list);
 		cic->dtor = cfq_free_io_context;
@@ -1374,17 +1374,19 @@ retry:
 			 * free memory.
 			 */
 			spin_unlock_irq(cfqd->queue->queue_lock);
-			new_cfqq = kmem_cache_alloc_node(cfq_pool, gfp_mask|__GFP_NOFAIL, cfqd->queue->node);
+			new_cfqq = kmem_cache_alloc_node(cfq_pool,
+					gfp_mask | __GFP_NOFAIL | __GFP_ZERO,
+					cfqd->queue->node);
 			spin_lock_irq(cfqd->queue->queue_lock);
 			goto retry;
 		} else {
-			cfqq = kmem_cache_alloc_node(cfq_pool, gfp_mask, cfqd->queue->node);
+			cfqq = kmem_cache_alloc_node(cfq_pool,
+					gfp_mask | __GFP_ZERO,
+					cfqd->queue->node);
 			if (!cfqq)
 				goto out;
 		}
 
-		memset(cfqq, 0, sizeof(*cfqq));
-
 		RB_CLEAR_NODE(&cfqq->rb_node);
 		INIT_LIST_HEAD(&cfqq->fifo);
 
@@ -2046,12 +2048,10 @@ static void *cfq_init_queue(request_queu
 {
 	struct cfq_data *cfqd;
 
-	cfqd = kmalloc_node(sizeof(*cfqd), GFP_KERNEL, q->node);
+	cfqd = kmalloc_node(sizeof(*cfqd), GFP_KERNEL | __GFP_ZERO, q->node);
 	if (!cfqd)
 		return NULL;
 
-	memset(cfqd, 0, sizeof(*cfqd));
-
 	cfqd->service_tree = CFQ_RB_ROOT;
 	INIT_LIST_HEAD(&cfqd->cic_list);
 
diff -puN block/deadline-iosched.c~slab-allocators-replace-explicit-zeroing-with-__gfp_zero block/deadline-iosched.c
--- a/block/deadline-iosched.c~slab-allocators-replace-explicit-zeroing-with-__gfp_zero
+++ a/block/deadline-iosched.c
@@ -360,10 +360,9 @@ static void *deadline_init_queue(request
 {
 	struct deadline_data *dd;
 
-	dd = kmalloc_node(sizeof(*dd), GFP_KERNEL, q->node);
+	dd = kmalloc_node(sizeof(*dd), GFP_KERNEL | __GFP_ZERO, q->node);
 	if (!dd)
 		return NULL;
-	memset(dd, 0, sizeof(*dd));
 
 	INIT_LIST_HEAD(&dd->fifo_list[READ]);
 	INIT_LIST_HEAD(&dd->fifo_list[WRITE]);
diff -puN block/elevator.c~slab-allocators-replace-explicit-zeroing-with-__gfp_zero block/elevator.c
--- a/block/elevator.c~slab-allocators-replace-explicit-zeroing-with-__gfp_zero
+++ a/block/elevator.c
@@ -177,11 +177,10 @@ static elevator_t *elevator_alloc(reques
 	elevator_t *eq;
 	int i;
 
-	eq = kmalloc_node(sizeof(elevator_t), GFP_KERNEL, q->node);
+	eq = kmalloc_node(sizeof(elevator_t), GFP_KERNEL | __GFP_ZERO, q->node);
 	if (unlikely(!eq))
 		goto err;
 
-	memset(eq, 0, sizeof(*eq));
 	eq->ops = &e->ops;
 	eq->elevator_type = e;
 	kobject_init(&eq->kobj);
diff -puN block/genhd.c~slab-allocators-replace-explicit-zeroing-with-__gfp_zero block/genhd.c
--- a/block/genhd.c~slab-allocators-replace-explicit-zeroing-with-__gfp_zero
+++ a/block/genhd.c
@@ -726,21 +726,21 @@ struct gendisk *alloc_disk_node(int mino
 {
 	struct gendisk *disk;
 
-	disk = kmalloc_node(sizeof(struct gendisk), GFP_KERNEL, node_id);
+	disk = kmalloc_node(sizeof(struct gendisk),
+				GFP_KERNEL | __GFP_ZERO, node_id);
 	if (disk) {
-		memset(disk, 0, sizeof(struct gendisk));
 		if (!init_disk_stats(disk)) {
 			kfree(disk);
 			return NULL;
 		}
 		if (minors > 1) {
 			int size = (minors - 1) * sizeof(struct hd_struct *);
-			disk->part = kmalloc_node(size, GFP_KERNEL, node_id);
+			disk->part = kmalloc_node(size,
+				GFP_KERNEL | __GFP_ZERO, node_id);
 			if (!disk->part) {
 				kfree(disk);
 				return NULL;
 			}
-			memset(disk->part, 0, size);
 		}
 		disk->minors = minors;
 		kobj_set_kset_s(disk,block_subsys);
diff -puN block/ll_rw_blk.c~slab-allocators-replace-explicit-zeroing-with-__gfp_zero block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~slab-allocators-replace-explicit-zeroing-with-__gfp_zero
+++ a/block/ll_rw_blk.c
@@ -1828,11 +1828,11 @@ request_queue_t *blk_alloc_queue_node(gf
 {
 	request_queue_t *q;
 
-	q = kmem_cache_alloc_node(requestq_cachep, gfp_mask, node_id);
+	q = kmem_cache_alloc_node(requestq_cachep,
+				gfp_mask | __GFP_ZERO, node_id);
 	if (!q)
 		return NULL;
 
-	memset(q, 0, sizeof(*q));
 	init_timer(&q->unplug_timer);
 
 	snprintf(q->kobj.name, KOBJ_NAME_LEN, "%s", "queue");
diff -puN drivers/ide/ide-probe.c~slab-allocators-replace-explicit-zeroing-with-__gfp_zero drivers/ide/ide-probe.c
--- a/drivers/ide/ide-probe.c~slab-allocators-replace-explicit-zeroing-with-__gfp_zero
+++ a/drivers/ide/ide-probe.c
@@ -1073,14 +1073,14 @@ static int init_irq (ide_hwif_t *hwif)
 		hwgroup->hwif->next = hwif;
 		spin_unlock_irq(&ide_lock);
 	} else {
-		hwgroup = kmalloc_node(sizeof(ide_hwgroup_t), GFP_KERNEL,
+		hwgroup = kmalloc_node(sizeof(ide_hwgroup_t),
+					GFP_KERNEL | __GFP_ZERO,
 					hwif_to_node(hwif->drives[0].hwif));
 		if (!hwgroup)
 	       		goto out_up;
 
 		hwif->hwgroup = hwgroup;
 
-		memset(hwgroup, 0, sizeof(ide_hwgroup_t));
 		hwgroup->hwif     = hwif->next = hwif;
 		hwgroup->rq       = NULL;
 		hwgroup->handler  = NULL;
diff -puN kernel/timer.c~slab-allocators-replace-explicit-zeroing-with-__gfp_zero kernel/timer.c
--- a/kernel/timer.c~slab-allocators-replace-explicit-zeroing-with-__gfp_zero
+++ a/kernel/timer.c
@@ -1210,7 +1210,8 @@ static int __devinit init_timers_cpu(int
 			/*
 			 * The APs use this path later in boot
 			 */
-			base = kmalloc_node(sizeof(*base), GFP_KERNEL,
+			base = kmalloc_node(sizeof(*base),
+						GFP_KERNEL | __GFP_ZERO,
 						cpu_to_node(cpu));
 			if (!base)
 				return -ENOMEM;
@@ -1221,7 +1222,6 @@ static int __devinit init_timers_cpu(int
 				kfree(base);
 				return -ENOMEM;
 			}
-			memset(base, 0, sizeof(*base));
 			per_cpu(tvec_bases, cpu) = base;
 		} else {
 			/*
diff -puN lib/genalloc.c~slab-allocators-replace-explicit-zeroing-with-__gfp_zero lib/genalloc.c
--- a/lib/genalloc.c~slab-allocators-replace-explicit-zeroing-with-__gfp_zero
+++ a/lib/genalloc.c
@@ -54,11 +54,10 @@ int gen_pool_add(struct gen_pool *pool, 
 	int nbytes = sizeof(struct gen_pool_chunk) +
 				(nbits + BITS_PER_BYTE - 1) / BITS_PER_BYTE;
 
-	chunk = kmalloc_node(nbytes, GFP_KERNEL, nid);
+	chunk = kmalloc_node(nbytes, GFP_KERNEL | __GFP_ZERO, nid);
 	if (unlikely(chunk == NULL))
 		return -1;
 
-	memset(chunk, 0, nbytes);
 	spin_lock_init(&chunk->lock);
 	chunk->start_addr = addr;
 	chunk->end_addr = addr + size;
diff -puN mm/allocpercpu.c~slab-allocators-replace-explicit-zeroing-with-__gfp_zero mm/allocpercpu.c
--- a/mm/allocpercpu.c~slab-allocators-replace-explicit-zeroing-with-__gfp_zero
+++ a/mm/allocpercpu.c
@@ -53,12 +53,9 @@ void *percpu_populate(void *__pdata, siz
 	int node = cpu_to_node(cpu);
 
 	BUG_ON(pdata->ptrs[cpu]);
-	if (node_online(node)) {
-		/* FIXME: kzalloc_node(size, gfp, node) */
-		pdata->ptrs[cpu] = kmalloc_node(size, gfp, node);
-		if (pdata->ptrs[cpu])
-			memset(pdata->ptrs[cpu], 0, size);
-	} else
+	if (node_online(node))
+		pdata->ptrs[cpu] = kmalloc_node(size, gfp|__GFP_ZERO, node);
+	else
 		pdata->ptrs[cpu] = kzalloc(size, gfp);
 	return pdata->ptrs[cpu];
 }
diff -puN mm/mempool.c~slab-allocators-replace-explicit-zeroing-with-__gfp_zero mm/mempool.c
--- a/mm/mempool.c~slab-allocators-replace-explicit-zeroing-with-__gfp_zero
+++ a/mm/mempool.c
@@ -62,10 +62,9 @@ mempool_t *mempool_create_node(int min_n
 			mempool_free_t *free_fn, void *pool_data, int node_id)
 {
 	mempool_t *pool;
-	pool = kmalloc_node(sizeof(*pool), GFP_KERNEL, node_id);
+	pool = kmalloc_node(sizeof(*pool), GFP_KERNEL | __GFP_ZERO, node_id);
 	if (!pool)
 		return NULL;
-	memset(pool, 0, sizeof(*pool));
 	pool->elements = kmalloc_node(min_nr * sizeof(void *),
 					GFP_KERNEL, node_id);
 	if (!pool->elements) {
diff -puN mm/vmalloc.c~slab-allocators-replace-explicit-zeroing-with-__gfp_zero mm/vmalloc.c
--- a/mm/vmalloc.c~slab-allocators-replace-explicit-zeroing-with-__gfp_zero
+++ a/mm/vmalloc.c
@@ -432,11 +432,12 @@ void *__vmalloc_area_node(struct vm_stru
 	area->nr_pages = nr_pages;
 	/* Please note that the recursion is strictly bounded. */
 	if (array_size > PAGE_SIZE) {
-		pages = __vmalloc_node(array_size, gfp_mask, PAGE_KERNEL, node);
+		pages = __vmalloc_node(array_size, gfp_mask | __GFP_ZERO,
+					PAGE_KERNEL, node);
 		area->flags |= VM_VPAGES;
 	} else {
 		pages = kmalloc_node(array_size,
-				(gfp_mask & GFP_LEVEL_MASK),
+				(gfp_mask & GFP_LEVEL_MASK) | __GFP_ZERO,
 				node);
 	}
 	area->pages = pages;
@@ -445,7 +446,6 @@ void *__vmalloc_area_node(struct vm_stru
 		kfree(area);
 		return NULL;
 	}
-	memset(area->pages, 0, array_size);
 
 	for (i = 0; i < area->nr_pages; i++) {
 		if (node < 0)
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-remove-useless-export_symbol.patch
git-ubi.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
pa-risc-use-page-allocator-instead-of-slab-allocator-fix.patch
usb-make-the-usb_device-numa_node-to-get-assigned-from.patch
quicklist-support-for-x86_64.patch
x86_64-get-mp_bus_to_node-as-early.patch
x86_64-get-mp_bus_to_node-as-early-fix.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
make-proc-slabinfo-use-seq_list_xxx-helpers-fix.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
slub-support-slub_debug-on-by-default.patch
slub-support-slub_debug-on-by-default-tidy.patch
numa-mempolicy-dynamic-interleave-map-for-system-init.patch
numa-mempolicy-trivial-debug-fixes.patch
slob-initial-numa-support.patch
mm-fixup-proc-vmstat-output.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely-fix.patch
slub-use-list_for_each_entry-for-loops-over-all-slabs.patch
slub-slab-validation-move-tracking-information-alloc-outside-of.patch
slub-ensure-that-the-object-per-slabs-stays-low-for-high-orders.patch
slub-debug-fix-initial-object-debug-state-of-numa-bootstrap-objects.patch
slab-allocators-consolidate-code-for-krealloc-in-mm-utilc.patch
slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics.patch
slab-allocators-support-__gfp_zero-in-all-allocators.patch
slab-allocators-support-__gfp_zero-in-all-allocators-fix.patch
slub-add-some-more-inlines-and-ifdef-config_slub_debug.patch
slub-extract-dma_kmalloc_cache-from-get_cache.patch
slub-do-proper-locking-during-dma-slab-creation.patch
slub-faster-more-efficient-slab-determination-for-__kmalloc.patch
slub-faster-more-efficient-slab-determination-for-__kmalloc-fix.patch
slub-faster-more-efficient-slab-determination-for-__kmalloc-fix-2.patch
slub-simplify-dma-index-size-calculation.patch
mm-slubc-make-code-static.patch
slub-style-fix-up-the-loop-to-disable-small-slabs.patch
slub-do-not-use-length-parameter-in-slab_alloc.patch
slab-allocators-cleanup-zeroing-allocations.patch
slab-allocators-replace-explicit-zeroing-with-__gfp_zero.patch
slub-do-not-allocate-object-bit-array-on-stack.patch
slub-move-sysfs-operations-outside-of-slub_lock.patch
slub-fix-config_slub_debug-use-for-config_numa.patch
add-vm_bug_on-in-case-someone-uses-page_mapping-on-a-slab-page.patch
memory-unplug-v7-migration-by-kernel.patch
memory-unplug-v7-isolate_lru_page-fix.patch
define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch
dma-make-dma-pool-to-use-kmalloc_node.patch
revoke-core-code.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-pci-generic-helper-function-fix.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-iova-allocation-and-management-routines-fix.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-intel-iommu-driver-fix.patch
intel-iommu-intel-iommu-driver-fix-2.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-iommu-floppy-workaround-fix.patch
define-new-percpu-interface-for-shared-data-version-4.patch
use-the-new-percpu-interface-for-shared-data-version-4.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
