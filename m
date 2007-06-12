From: akpm@linux-foundation.org
Subject: + slub-ensure-that-the-object-per-slabs-stays-low-for-high-orders.patch added to -mm tree
Date: Tue, 12 Jun 2007 12:58:49 -0700
Message-ID: <200706121958.l5CJwnx6020070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58872 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752714AbXFLT73 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:59:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: ensure that the number of objects per slab stays low for high orders
has been added to the -mm tree.  Its filename is
     slub-ensure-that-the-object-per-slabs-stays-low-for-high-orders.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: ensure that the number of objects per slab stays low for high orders
From: Christoph Lameter <clameter@sgi.com>

Currently SLUB has no provision to deal with too high page orders that may
be specified on the kernel boot line.  If an order higher than 6 (on a 4k
platform) is generated then we will BUG() because slabs get more than 65535
objects.

Add some logic that decreases order for slabs that have too many objects. 
This allow booting with slab sizes up to MAX_ORDER.

For example

	slub_min_order=10

will boot with a default slab size of 4M and reduce slab sizes for small
object sizes to lower orders if the number of objects becomes too big. 
Large slab sizes like that allow a concentration of objects of the same
slab cache under as few as possible TLB entries and thus potentially
reduces TLB pressure.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff -puN mm/slub.c~slub-ensure-that-the-object-per-slabs-stays-low-for-high-orders mm/slub.c
--- a/mm/slub.c~slub-ensure-that-the-object-per-slabs-stays-low-for-high-orders
+++ a/mm/slub.c
@@ -212,6 +212,11 @@ static inline void ClearSlabDebug(struct
 #define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
 #endif
 
+/*
+ * The page->inuse field is 16 bit thus we have this limitation
+ */
+#define MAX_OBJECTS_PER_SLAB 65535
+
 /* Internal SLUB flags */
 #define __OBJECT_POISON 0x80000000	/* Poison object */
 
@@ -1751,8 +1756,17 @@ static inline int slab_order(int size, i
 {
 	int order;
 	int rem;
+	int min_order = slub_min_order;
 
-	for (order = max(slub_min_order,
+	/*
+	 * If we would create too many object per slab then reduce
+	 * the slab order even if it goes below slub_min_order.
+	 */
+	while (min_order > 0 &&
+		(PAGE_SIZE << min_order) >= MAX_OBJECTS_PER_SLAB * size)
+			min_order--;
+
+	for (order = max(min_order,
 				fls(min_objects * size - 1) - PAGE_SHIFT);
 			order <= max_order; order++) {
 
@@ -1766,6 +1780,9 @@ static inline int slab_order(int size, i
 		if (rem <= slab_size / fract_leftover)
 			break;
 
+		/* If the next size is too high then exit now */
+		if (slab_size * 2 >= MAX_OBJECTS_PER_SLAB * size)
+			break;
 	}
 
 	return order;
@@ -2048,7 +2065,7 @@ static int calculate_sizes(struct kmem_c
 	 * The page->inuse field is only 16 bit wide! So we cannot have
 	 * more than 64k objects per slab.
 	 */
-	if (!s->objects || s->objects > 65535)
+	if (!s->objects || s->objects > MAX_OBJECTS_PER_SLAB)
 		return 0;
 	return 1;
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
group-short-lived-and-reclaimable-kernel-allocations-fix.patch
cpuset-zero-malloc-fix-for-old-cpusets.patch
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
