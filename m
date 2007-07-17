From: akpm@linux-foundation.org
Subject: - slub-slab-validation-move-tracking-information-alloc-outside-of.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:00:57 -0700
Message-ID: <200707172300.l6HN0vCv011335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59632 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935934AbXGQXBY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:01:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB slab validation: Move tracking information alloc outside of lock
has been removed from the -mm tree.  Its filename was
     slub-slab-validation-move-tracking-information-alloc-outside-of.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB slab validation: Move tracking information alloc outside of lock
From: Christoph Lameter <clameter@sgi.com>

We currently have to do an GFP_ATOMIC allocation because the list_lock is
already taken when we first allocate memory for tracking allocation
information.  It would be better if we could avoid atomic allocations.

Allocate a size of the tracking table that is usually sufficient (one page)
before we take the list lock.  We will then only do the atomic allocation
if we need to resize the table to become larger than a page (mostly only
needed under large NUMA because of the tracking of cpus and nodes otherwise
the table stays small).

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN mm/slub.c~slub-slab-validation-move-tracking-information-alloc-outside-of mm/slub.c
--- a/mm/slub.c~slub-slab-validation-move-tracking-information-alloc-outside-of
+++ a/mm/slub.c
@@ -2902,18 +2902,14 @@ static void free_loc_track(struct loc_tr
 			get_order(sizeof(struct location) * t->max));
 }
 
-static int alloc_loc_track(struct loc_track *t, unsigned long max)
+static int alloc_loc_track(struct loc_track *t, unsigned long max, gfp_t flags)
 {
 	struct location *l;
 	int order;
 
-	if (!max)
-		max = PAGE_SIZE / sizeof(struct location);
-
 	order = get_order(sizeof(struct location) * max);
 
-	l = (void *)__get_free_pages(GFP_ATOMIC, order);
-
+	l = (void *)__get_free_pages(flags, order);
 	if (!l)
 		return 0;
 
@@ -2979,7 +2975,7 @@ static int add_location(struct loc_track
 	/*
 	 * Not found. Insert new tracking element.
 	 */
-	if (t->count >= t->max && !alloc_loc_track(t, 2 * t->max))
+	if (t->count >= t->max && !alloc_loc_track(t, 2 * t->max, GFP_ATOMIC))
 		return 0;
 
 	l = t->loc + pos;
@@ -3022,11 +3018,12 @@ static int list_locations(struct kmem_ca
 {
 	int n = 0;
 	unsigned long i;
-	struct loc_track t;
+	struct loc_track t = { 0, 0, NULL };
 	int node;
 
-	t.count = 0;
-	t.max = 0;
+	if (!alloc_loc_track(&t, PAGE_SIZE / sizeof(struct location),
+			GFP_KERNEL))
+		return sprintf(buf, "Out of memory\n");
 
 	/* Push back cpu slabs */
 	flush_all(s);
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
