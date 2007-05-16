From: akpm@linux-foundation.org
Subject: + slub-slabinfo-fixes.patch added to -mm tree
Date: Tue, 15 May 2007 22:41:20 -0700
Message-ID: <200705160541.l4G5fK0K027196@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57290 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759516AbXEPFmu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 May 2007 01:42:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: slabinfo fixes
has been added to the -mm tree.  Its filename is
     slub-slabinfo-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
slub-it-is-legit-to-allocate-a-slab-of-the-maximum-permitted-size.patch
slub-dont-confuse-ctor-and-dtor.patch
fix-find_or_create_page-skips-cpuset-memory-spreading.patch
git-ubi.patch
quicklist-support-for-x86_64.patch
slab-allocators-drop-support-for-destructors.patch
remove-slab_ctor_constructor.patch
remove-constructor-from-buffer_head.patch
remove-slab_ctor_constructor-fix.patch
slub-remove-depends-on-experimental-and-arch_uses_slab_page_struct.patch
slab-move-two-remaining-slab-specific-definitions-to-slab_defh.patch
slub-define-functions-for-cpu-slab-handling-instead-of-using.patch
slub-define-functions-for-cpu-slab-handling-instead-of-using-fix.patch
slab-warn-on-zero-length-allocations.patch
i386-dont-check_pgt_cache-in-flush_tlb_mm.patch
slub-fix-handling-of-oversized-slabs.patch
fix-page-allocation-flags-in-grow_dev_page.patch
slub-slabinfo-fixes.patch
slub-do-our-own-flags-based-on-pg_active-and-pg_error.patch
slub-simplify-debug-code.patch
compat_core_sys_select-avoid-kmalloc0.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch
