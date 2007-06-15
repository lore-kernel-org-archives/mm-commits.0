From: akpm@linux-foundation.org
Subject: + slub-minimum-alignment-fixes.patch added to -mm tree
Date: Thu, 14 Jun 2007 19:15:54 -0700
Message-ID: <200706150215.l5F2Fsku008399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50599 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751981AbXFOCQI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Jun 2007 22:16:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, hskinnemoen@atmel.com


The patch titled
     SLUB: minimum alignment fixes
has been added to the -mm tree.  Its filename is
     slub-minimum-alignment-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: minimum alignment fixes
From: Christoph Lameter <clameter@sgi.com>

If ARCH_KMALLOC_MINALIGN is set to a value greater than 8 (SLUBs smallest
kmalloc cache) then SLUB may generate duplicate slabs in sysfs (yes again)
because the object size is padded to reach ARCH_KMALLOC_MINALIGN.  Thus the
size of the small slabs is all the same.

No arch sets ARCH_KMALLOC_MINALIGN larger than 8 though except mips which
for some reason wants a 128 byte alignment.

This patch increases the size of the smallest cache if
ARCH_KMALLOC_MINALIGN is greater than 8.  In that case more and more of the
smallest caches are disabled.

If we do that then the count of the active general caches that is displayed
on boot is not correct anymore since we may skip elements of the kmalloc
array.  So count them separately.

This approach was tested by Havard yesterday.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |   13 +++++++++++--
 mm/slub.c                |   20 +++++++++++++++-----
 2 files changed, 26 insertions(+), 7 deletions(-)

diff -puN include/linux/slub_def.h~slub-minimum-alignment-fixes include/linux/slub_def.h
--- a/include/linux/slub_def.h~slub-minimum-alignment-fixes
+++ a/include/linux/slub_def.h
@@ -28,7 +28,7 @@ struct kmem_cache {
 	int size;		/* The size of an object including meta data */
 	int objsize;		/* The size of an object without meta data */
 	int offset;		/* Free pointer offset. */
-	unsigned int order;
+	int order;
 
 	/*
 	 * Avoid an extra cache line for UP, SMP and for the node local to
@@ -56,7 +56,13 @@ struct kmem_cache {
 /*
  * Kmalloc subsystem.
  */
-#define KMALLOC_SHIFT_LOW 3
+#if defined(ARCH_KMALLOC_MINALIGN) && ARCH_KMALLOC_MINALIGN > 8
+#define KMALLOC_MIN_SIZE ARCH_KMALLOC_MINALIGN
+#else
+#define KMALLOC_MIN_SIZE 8
+#endif
+
+#define KMALLOC_SHIFT_LOW ilog2(KMALLOC_MIN_SIZE)
 
 /*
  * We keep the general caches in an array of slab caches that are used for
@@ -76,6 +82,9 @@ static inline int kmalloc_index(size_t s
 	if (size > KMALLOC_MAX_SIZE)
 		return -1;
 
+	if (size <= KMALLOC_MIN_SIZE)
+		return KMALLOC_SHIFT_LOW;
+
 	if (size > 64 && size <= 96)
 		return 1;
 	if (size > 128 && size <= 192)
diff -puN mm/slub.c~slub-minimum-alignment-fixes mm/slub.c
--- a/mm/slub.c~slub-minimum-alignment-fixes
+++ a/mm/slub.c
@@ -2436,6 +2436,7 @@ EXPORT_SYMBOL(krealloc);
 void __init kmem_cache_init(void)
 {
 	int i;
+	int caches = 0;
 
 #ifdef CONFIG_NUMA
 	/*
@@ -2446,20 +2447,29 @@ void __init kmem_cache_init(void)
 	create_kmalloc_cache(&kmalloc_caches[0], "kmem_cache_node",
 		sizeof(struct kmem_cache_node), GFP_KERNEL);
 	kmalloc_caches[0].refcount = -1;
+	caches++;
 #endif
 
 	/* Able to allocate the per node structures */
 	slab_state = PARTIAL;
 
 	/* Caches that are not of the two-to-the-power-of size */
-	create_kmalloc_cache(&kmalloc_caches[1],
+	if (KMALLOC_MIN_SIZE <= 64) {
+		create_kmalloc_cache(&kmalloc_caches[1],
 				"kmalloc-96", 96, GFP_KERNEL);
-	create_kmalloc_cache(&kmalloc_caches[2],
+		caches++;
+	}
+	if (KMALLOC_MIN_SIZE <= 128) {
+		create_kmalloc_cache(&kmalloc_caches[2],
 				"kmalloc-192", 192, GFP_KERNEL);
+		caches++;
+	}
 
-	for (i = KMALLOC_SHIFT_LOW; i <= KMALLOC_SHIFT_HIGH; i++)
+	for (i = KMALLOC_SHIFT_LOW; i <= KMALLOC_SHIFT_HIGH; i++) {
 		create_kmalloc_cache(&kmalloc_caches[i],
 			"kmalloc", 1 << i, GFP_KERNEL);
+		caches++;
+	}
 
 	slab_state = UP;
 
@@ -2476,8 +2486,8 @@ void __init kmem_cache_init(void)
 				nr_cpu_ids * sizeof(struct page *);
 
 	printk(KERN_INFO "SLUB: Genslabs=%d, HWalign=%d, Order=%d-%d, MinObjects=%d,"
-		" Processors=%d, Nodes=%d\n",
-		KMALLOC_SHIFT_HIGH, cache_line_size(),
+		" CPUs=%d, Nodes=%d\n",
+		caches, cache_line_size(),
 		slub_min_order, slub_max_order, slub_min_objects,
 		nr_cpu_ids, nr_node_ids);
 }
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
group-short-lived-and-reclaimable-kernel-allocations-fix.patch
cpuset-zero-malloc-fix-for-old-cpusets.patch
slub-minimum-alignment-fixes.patch
fix-get_policy-for-stacked-shared-memory-files.patch
git-ubi.patch
quicklist-support-for-x86_64.patch
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
gfph-gfp_thisnode-can-go-to-other-nodes-if-some-are-unpopulated.patch
numa-mempolicy-trivial-debug-fixes.patch
add-populated_map-to-account-for-memoryless-nodes.patch
add-populated_map-to-account-for-memoryless-nodes-fix.patch
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
slub-remove-useless-export_symbol.patch
slub-use-list_for_each_entry-for-loops-over-all-slabs.patch
slub-slab-validation-move-tracking-information-alloc-outside-of.patch
slub-ensure-that-the-object-per-slabs-stays-low-for-high-orders.patch
define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
