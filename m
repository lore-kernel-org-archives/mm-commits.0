From: akpm@linux-foundation.org
Subject: + slub-slab-validation-move-tracking-information-alloc-outside-of.patch added to -mm tree
Date: Mon, 11 Jun 2007 11:37:44 -0700
Message-ID: <200706111837.l5BIbiMO026113@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57814 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753410AbXFKShy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2007 14:37:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB slab validation: Move tracking information alloc outside of lock
has been added to the -mm tree.  Its filename is
     slub-slab-validation-move-tracking-information-alloc-outside-of.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 7 insertions(+), 10 deletions(-)

diff -puN mm/slub.c~slub-slab-validation-move-tracking-information-alloc-outside-of mm/slub.c
--- a/mm/slub.c~slub-slab-validation-move-tracking-information-alloc-outside-of
+++ a/mm/slub.c
@@ -2912,18 +2912,14 @@ static void free_loc_track(struct loc_tr
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
 
@@ -2989,7 +2985,7 @@ static int add_location(struct loc_track
 	/*
 	 * Not found. Insert new tracking element.
 	 */
-	if (t->count >= t->max && !alloc_loc_track(t, 2 * t->max))
+	if (t->count >= t->max && !alloc_loc_track(t, 2 * t->max, GFP_ATOMIC))
 		return 0;
 
 	l = t->loc + pos;
@@ -3032,11 +3028,12 @@ static int list_locations(struct kmem_ca
 {
 	int n = 0;
 	unsigned long i;
-	struct loc_track t;
+	struct loc_track t = { 0, 0, NULL };
 	int node;
 
-	t.count = 0;
-	t.max = 0;
+	if (!alloc_loc_track(&t, PAGE_SIZE / sizeof(struct location),
+			GFP_TEMPORARY))
+		return sprintf(buf, "Out of memory\n");
 
 	/* Push back cpu slabs */
 	flush_all(s);
_

Patches currently in -mm which might be from clameter@sgi.com are

mount-t-tmpfs-o-mpol=-check-nodes-online.patch
slab-fix-alien-cache-handling.patch
slub-return-zero_size_ptr-for-kmalloc0.patch
hexdump-more-output-formatting.patch
group-short-lived-and-reclaimable-kernel-allocations-fix.patch
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
define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
