From: akpm@linux-foundation.org
Subject: + do-not-trigger-oom-killer-for-high-order-allocation-failures.patch added to -mm tree
Date: Thu, 26 Jul 2007 18:35:25 -0700
Message-ID: <200707270135.l6R1ZP8v032134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57051 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760803AbXG0BgL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jul 2007 21:36:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, apw@shadowen.org, rientjes@google.com


The patch titled
     Do not trigger OOM-killer for high-order allocation failures
has been added to the -mm tree.  Its filename is
     do-not-trigger-oom-killer-for-high-order-allocation-failures.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Do not trigger OOM-killer for high-order allocation failures
From: mel@skynet.ie (Mel Gorman)

out_of_memory() may be called when an allocation is failing and the direct
reclaim is not making any progress.  This does not take into account the
requested order of the allocation.  If the request if for an order larger
than PAGE_ALLOC_COSTLY_ORDER, it is reasonable to fail the allocation
because the kernel makes no guarantees about those allocations succeeding.

This false OOM situation can occur if a user is trying to grow the hugepage
pool in a script like;

#!/bin/bash
REQUIRED=$1
echo 1 > /proc/sys/vm/hugepages_treat_as_movable
echo $REQUIRED > /proc/sys/vm/nr_hugepages
ACTUAL=`cat /proc/sys/vm/nr_hugepages`
while [ $REQUIRED -ne $ACTUAL ]; do
	echo Huge page pool at $ACTUAL growing to $REQUIRED
	echo $REQUIRED > /proc/sys/vm/nr_hugepages
	ACTUAL=`cat /proc/sys/vm/nr_hugepages`
	sleep 1
done

This is a reasonable scenario when ZONE_MOVABLE is in use but triggers OOM
easily on 2.6.23-rc1. This patch will fail an allocation for an order above
PAGE_ALLOC_COSTLY_ORDER instead of killing processes and retrying.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/page_alloc.c~do-not-trigger-oom-killer-for-high-order-allocation-failures mm/page_alloc.c
--- a/mm/page_alloc.c~do-not-trigger-oom-killer-for-high-order-allocation-failures
+++ a/mm/page_alloc.c
@@ -1350,6 +1350,10 @@ nofail_alloc:
 		if (page)
 			goto got_pg;
 
+		/* The OOM killer will not help higher order allocs so fail */
+		if (order > PAGE_ALLOC_COSTLY_ORDER)
+			goto nopage;
+
 		out_of_memory(zonelist, gfp_mask, order);
 		goto restart;
 	}
_

Patches currently in -mm which might be from mel@csn.ul.ie are

allow-nodes-to-exist-that-only-contain-zone_movable.patch
do-not-trigger-oom-killer-for-high-order-allocation-failures.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
