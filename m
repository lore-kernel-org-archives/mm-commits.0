From: akpm@linux-foundation.org
Subject: + group-short-lived-and-reclaimable-kernel-allocations-fix.patch added to -mm tree
Date: Fri, 08 Jun 2007 15:03:24 -0700
Message-ID: <200706082203.l58M3PF0013535@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52308 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968026AbXFHWEJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 18:04:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, apw@shadowen.org, mel@csn.ul.ie


The patch titled
     SLUB slab validation: Alloc while interrupts are disabled must use GFP_ATOMIC
has been added to the -mm tree.  Its filename is
     group-short-lived-and-reclaimable-kernel-allocations-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB slab validation: Alloc while interrupts are disabled must use GFP_ATOMIC
From: Christoph Lameter <clameter@sgi.com>

The data structure to manage the information gathered about functions
allocating and freeing objects is allocated when the list_lock has already
been taken.  We need to allocate with GFP_ATOMIC instead of GFP_KERNEL.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~group-short-lived-and-reclaimable-kernel-allocations-fix mm/slub.c
--- a/mm/slub.c~group-short-lived-and-reclaimable-kernel-allocations-fix
+++ a/mm/slub.c
@@ -2867,7 +2867,7 @@ static int alloc_loc_track(struct loc_tr
 
 	order = get_order(sizeof(struct location) * max);
 
-	l = (void *)__get_free_pages(GFP_KERNEL, order);
+	l = (void *)__get_free_pages(GFP_ATOMIC, order);
 
 	if (!l)
 		return 0;
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
define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
