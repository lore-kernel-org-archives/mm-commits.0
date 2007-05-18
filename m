From: akpm@linux-foundation.org
Subject: - slub-slabinfo-fixes.patch removed from -mm tree
Date: Fri, 18 May 2007 00:05:35 -0700
Message-ID: <200705180705.l4I75YkG010106@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50957 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755119AbXERHHI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 May 2007 03:07:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: slabinfo fixes
has been removed from the -mm tree.  Its filename was
     slub-slabinfo-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: slabinfo fixes
From: Christoph Lameter <clameter@sgi.com>

Align the output of % with K/M/G of sizes.

Check for empty NUMA information to avoid segfault on !NUMA.

-r should work directly not only if we match a single slab
   without additional options.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/slabinfo.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff -puN Documentation/vm/slabinfo.c~slub-slabinfo-fixes Documentation/vm/slabinfo.c
--- a/Documentation/vm/slabinfo.c~slub-slabinfo-fixes
+++ a/Documentation/vm/slabinfo.c
@@ -242,6 +242,9 @@ void decode_numa_list(int *numa, char *t
 
 	memset(numa, 0, MAX_NODES * sizeof(int));
 
+	if (!t)
+		return;
+
 	while (*t == 'N') {
 		t++;
 		node = strtoul(t, &t, 10);
@@ -386,7 +389,9 @@ void report(struct slabinfo *s)
 {
 	if (strcmp(s->name, "*") == 0)
 		return;
-	printf("\nSlabcache: %-20s  Aliases: %2d Order : %2d\n", s->name, s->aliases, s->order);
+
+	printf("\nSlabcache: %-20s  Aliases: %2d Order : %2d Objects: %d\n",
+		s->name, s->aliases, s->order, s->objects);
 	if (s->hwcache_align)
 		printf("** Hardware cacheline aligned\n");
 	if (s->cache_dma)
@@ -791,11 +796,11 @@ void totals(void)
 
 	store_size(b1, total_size);store_size(b2, total_waste);
 	store_size(b3, total_waste * 100 / total_used);
-	printf("Memory used: %6s   # Loss   : %6s   MRatio: %6s%%\n", b1, b2, b3);
+	printf("Memory used: %6s   # Loss   : %6s   MRatio:%6s%%\n", b1, b2, b3);
 
 	store_size(b1, total_objects);store_size(b2, total_partobj);
 	store_size(b3, total_partobj * 100 / total_objects);
-	printf("# Objects  : %6s   # PartObj: %6s   ORatio: %6s%%\n", b1, b2, b3);
+	printf("# Objects  : %6s   # PartObj: %6s   ORatio:%6s%%\n", b1, b2, b3);
 
 	printf("\n");
 	printf("Per Cache    Average         Min         Max       Total\n");
@@ -818,7 +823,7 @@ void totals(void)
 	store_size(b1, avg_ppart);store_size(b2, min_ppart);
 	store_size(b3, max_ppart);
 	store_size(b4, total_partial * 100  / total_slabs);
-	printf("%%PartSlab %10s%% %10s%% %10s%% %10s%%\n",
+	printf("%%PartSlab%10s%% %10s%% %10s%% %10s%%\n",
 			b1,	b2,	b3,	b4);
 
 	store_size(b1, avg_partobj);store_size(b2, min_partobj);
@@ -830,7 +835,7 @@ void totals(void)
 	store_size(b1, avg_ppartobj);store_size(b2, min_ppartobj);
 	store_size(b3, max_ppartobj);
 	store_size(b4, total_partobj * 100 / total_objects);
-	printf("%% PartObj %10s%% %10s%% %10s%% %10s%%\n",
+	printf("%% PartObj%10s%% %10s%% %10s%% %10s%%\n",
 			b1,	b2,	b3,	b4);
 
 	store_size(b1, avg_size);store_size(b2, min_size);
@@ -1100,6 +1105,8 @@ void output_slabs(void)
 			ops(slab);
 		else if (show_slab)
 			slabcache(slab);
+		else if (show_report)
+			report(slab);
 	}
 }
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-another-slabinfo-fix.patch
git-ubi.patch
quicklist-support-for-x86_64.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-mark-bio_alloc-allocations-correctly.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-rename-gfp_high_movable-to-gfp_highuser_movable.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-mark-page-cache-pages-as-__gfp_pagecache-instead-of-__gfp_movable.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
group-short-lived-and-reclaimable-kernel-allocations-do-not-annotate-shmem-allocations-explicitly.patch
group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
revoke-core-code.patch
