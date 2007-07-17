From: akpm@linux-foundation.org
Subject: - slub-do-not-allocate-object-bit-array-on-stack.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:01:28 -0700
Message-ID: <200707172301.l6HN1SWb011399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40206 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936487AbXGQXPt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: Do not allocate object bit array on stack
has been removed from the -mm tree.  Its filename was
     slub-do-not-allocate-object-bit-array-on-stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: Do not allocate object bit array on stack
From: Christoph Lameter <clameter@sgi.com>

The objects per slab increase with the current patches in mm since we allow up
to order 3 allocs by default.  More patches in mm actually allow to use 2M or
higher sized slabs.  For slab validation we need per object bitmaps in order
to check a slab.  We end up with up to 64k objects per slab resulting in a
potential requirement of 8K stack space.  That does not look good.

Allocate the bit arrays via kmalloc.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff -puN mm/slub.c~slub-do-not-allocate-object-bit-array-on-stack mm/slub.c
--- a/mm/slub.c~slub-do-not-allocate-object-bit-array-on-stack
+++ a/mm/slub.c
@@ -2764,11 +2764,11 @@ void *__kmalloc_node_track_caller(size_t
 }
 
 #if defined(CONFIG_SYSFS) && defined(CONFIG_SLUB_DEBUG)
-static int validate_slab(struct kmem_cache *s, struct page *page)
+static int validate_slab(struct kmem_cache *s, struct page *page,
+						unsigned long *map)
 {
 	void *p;
 	void *addr = page_address(page);
-	DECLARE_BITMAP(map, s->objects);
 
 	if (!check_slab(s, page) ||
 			!on_freelist(s, page, NULL))
@@ -2790,10 +2790,11 @@ static int validate_slab(struct kmem_cac
 	return 1;
 }
 
-static void validate_slab_slab(struct kmem_cache *s, struct page *page)
+static void validate_slab_slab(struct kmem_cache *s, struct page *page,
+						unsigned long *map)
 {
 	if (slab_trylock(page)) {
-		validate_slab(s, page);
+		validate_slab(s, page, map);
 		slab_unlock(page);
 	} else
 		printk(KERN_INFO "SLUB %s: Skipped busy slab 0x%p\n",
@@ -2810,7 +2811,8 @@ static void validate_slab_slab(struct km
 	}
 }
 
-static int validate_slab_node(struct kmem_cache *s, struct kmem_cache_node *n)
+static int validate_slab_node(struct kmem_cache *s,
+		struct kmem_cache_node *n, unsigned long *map)
 {
 	unsigned long count = 0;
 	struct page *page;
@@ -2819,7 +2821,7 @@ static int validate_slab_node(struct kme
 	spin_lock_irqsave(&n->list_lock, flags);
 
 	list_for_each_entry(page, &n->partial, lru) {
-		validate_slab_slab(s, page);
+		validate_slab_slab(s, page, map);
 		count++;
 	}
 	if (count != n->nr_partial)
@@ -2830,7 +2832,7 @@ static int validate_slab_node(struct kme
 		goto out;
 
 	list_for_each_entry(page, &n->full, lru) {
-		validate_slab_slab(s, page);
+		validate_slab_slab(s, page, map);
 		count++;
 	}
 	if (count != atomic_long_read(&n->nr_slabs))
@@ -2843,17 +2845,23 @@ out:
 	return count;
 }
 
-static unsigned long validate_slab_cache(struct kmem_cache *s)
+static long validate_slab_cache(struct kmem_cache *s)
 {
 	int node;
 	unsigned long count = 0;
+	unsigned long *map = kmalloc(BITS_TO_LONGS(s->objects) *
+				sizeof(unsigned long), GFP_KERNEL);
+
+	if (!map)
+		return -ENOMEM;
 
 	flush_all(s);
 	for_each_online_node(node) {
 		struct kmem_cache_node *n = get_node(s, node);
 
-		count += validate_slab_node(s, n);
+		count += validate_slab_node(s, n, map);
 	}
+	kfree(map);
 	return count;
 }
 
@@ -3467,11 +3475,14 @@ static ssize_t validate_show(struct kmem
 static ssize_t validate_store(struct kmem_cache *s,
 			const char *buf, size_t length)
 {
-	if (buf[0] == '1')
-		validate_slab_cache(s);
-	else
-		return -EINVAL;
-	return length;
+	int ret = -EINVAL;
+
+	if (buf[0] == '1') {
+		ret = validate_slab_cache(s);
+		if (ret >= 0)
+			ret = length;
+	}
+	return ret;
 }
 SLAB_ATTR(validate);
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
git-ubi.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
quicklist-support-for-x86_64.patch
x86_64-get-mp_bus_to_node-as-early.patch
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
memory-unplug-v7-migration-by-kernel.patch
memory-unplug-v7-isolate_lru_page-fix.patch
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
define-new-percpu-interface-for-shared-data-version-4.patch
use-the-new-percpu-interface-for-shared-data-version-4.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
page-owner-tracking-leak-detector.patch
