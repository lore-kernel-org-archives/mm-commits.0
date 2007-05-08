From: akpm@linux-foundation.org
Subject: + slub-rework-slab-order-determination.patch added to -mm tree
Date: Tue, 08 May 2007 14:49:09 -0700
Message-ID: <200705082149.l48Ln9lM002653@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968372AbXEHVtM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 17:49:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: rework slab order determination
has been added to the -mm tree.  Its filename is
     slub-rework-slab-order-determination.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: rework slab order determination
From: Christoph Lameter <clameter@sgi.com>

In some cases SLUB is creating uselessly slabs that are larger than
slub_max_order. Also the layout of some of the slabs was not satisfactory.

Go to an iterarive approach.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   66 ++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 52 insertions(+), 14 deletions(-)

diff -puN mm/slub.c~slub-rework-slab-order-determination mm/slub.c
--- a/mm/slub.c~slub-rework-slab-order-determination
+++ a/mm/slub.c
@@ -1572,37 +1572,75 @@ static int slub_nomerge;
  * requested a higher mininum order then we start with that one instead of
  * the smallest order which will fit the object.
  */
-static int calculate_order(int size)
+static inline int slab_order(int size, int min_objects,
+				int max_order, int fract_leftover)
 {
 	int order;
 	int rem;
 
-	for (order = max(slub_min_order, fls(size - 1) - PAGE_SHIFT);
-			order < MAX_ORDER; order++) {
-		unsigned long slab_size = PAGE_SIZE << order;
+	for (order = max(slub_min_order,
+				fls(min_objects * size - 1) - PAGE_SHIFT);
+			order <= max_order; order++) {
 
-		if (order < slub_max_order &&
-				slab_size < slub_min_objects * size)
-			continue;
+		unsigned long slab_size = PAGE_SIZE << order;
 
-		if (slab_size < size)
+		if (slab_size < min_objects * size)
 			continue;
 
-		if (order >= slub_max_order)
-			break;
-
 		rem = slab_size % size;
 
-		if (rem <= slab_size / 8)
+		if (rem <= slab_size / fract_leftover)
 			break;
 
 	}
-	if (order >= MAX_ORDER)
-		return -E2BIG;
 
 	return order;
 }
 
+static inline int calculate_order(int size)
+{
+	int order;
+	int min_objects;
+	int fraction;
+
+	/*
+	 * Attempt to find best configuration for a slab. This
+	 * works by first attempting to generate a layout with
+	 * the best configuration and backing off gradually.
+	 *
+	 * First we reduce the acceptable waste in a slab. Then
+	 * we reduce the minimum objects required in a slab.
+	 */
+	min_objects = slub_min_objects;
+	while (min_objects > 1) {
+		fraction = 8;
+		while (fraction >= 4) {
+			order = slab_order(size, min_objects,
+						slub_max_order, fraction);
+			if (order <= slub_max_order)
+				return order;
+			fraction /= 2;
+		}
+		min_objects /= 2;
+	}
+
+	/*
+	 * We were unable to place multiple objects in a slab. Now
+	 * lets see if we can place a single object there.
+	 */
+	order = slab_order(size, 1, slub_max_order, 1);
+	if (order <= slub_max_order)
+		return order;
+
+	/*
+	 * Doh this slab cannot be placed using slub_max_order.
+	 */
+	order = slab_order(size, 1, MAX_ORDER, 1);
+	if (order <= MAX_ORDER)
+		return order;
+	return -ENOSYS;
+}
+
 /*
  * Figure out what the alignment of the objects will be.
  */
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-add-support-for-dynamic-cacheline-size-determination.patch
slub-add-support-for-dynamic-cacheline-size-determination-fix.patch
slub-after-object-padding-only-needed-for-redzoning.patch
slub-slabinfo-upgrade.patch
slub-use-check_valid_pointer-in-kmem_ptr_validate.patch
slub-clean-up-krealloc.patch
slub-clean-up-krealloc-fix.patch
slub-get-rid-of-finish_bootstrap.patch
slub-update-comments.patch
slub-add-macros-for-scanning-objects-in-a-slab.patch
slub-move-resiliency-check-into-sysfs-section.patch
slub-introduce-debugslabpage.patch
slub-consolidate-trace-code.patch
slub-move-tracking-definitions-and-check_valid_pointer-away-from-debug-code.patch
slub-add-config_slub_debug.patch
slub-include-lifetime-stats-and-sets-of-cpus--nodes-in-tracking-output.patch
slub-include-lifetime-stats-and-sets-of-cpus--nodes-in-tracking-output-fix.patch
slub-rework-slab-order-determination.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-reduce-antifrag-max-order.patch
slub-i386-support.patch
remove-constructor-from-buffer_head.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
vmstat-use-our-own-timer-events.patch
vmstat-use-our-own-timer-events-fix.patch
make-vm-statistics-update-interval-configurable.patch
make-vm-statistics-update-interval-configurable-fix.patch
move-remote-node-draining-out-of-slab-allocators.patch
