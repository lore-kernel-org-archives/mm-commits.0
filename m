From: akpm@linux-foundation.org
Subject: + ensure-we-count-pages-transitioning-inactive-via-clear_active_flags.patch added to -mm tree
Date: Mon, 06 Aug 2007 12:22:14 -0700
Message-ID: <200708061922.l76JMEeY010619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34562 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755943AbXHFTWz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 15:22:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, mel@csn.ul.ie


The patch titled
     synchronous lumpy reclaim: ensure we count pages transitioning inactive via clear_active_flags
has been added to the -mm tree.  Its filename is
     ensure-we-count-pages-transitioning-inactive-via-clear_active_flags.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: synchronous lumpy reclaim: ensure we count pages transitioning inactive via clear_active_flags
From: Andy Whitcroft <apw@shadowen.org>

As pointed out by Mel when reclaim is applied at higher orders a significant
amount of IO may be started.  As this takes finite time to drain reclaim will
consider more areas than ultimatly needed to satisfy the request.  This leads
to more reclaim than strictly required and reduced success rates.

I was able to confirm Mel's test results on systems locally.  These show that
even under light load the success rates drop off far more than expected. 
Testing with a modified version of his patch (which follows) I was able to
allocate almost all of ZONE_MOVABLE with a near idle system.  I ran 5 test
passes sequentially following system boot (the system has 29 hugepages in
ZONE_MOVABLE):

  2.6.23-rc1              11  8  6  7  7
  sync_lumpy              28 28 29 29 26

These show that although hugely better than the near 0% success normally
expected we can only allocate about a 1/4 of the zone.  Using synchronous
reclaim for these allocations we get close to 100% as expected.

I have also run our standard high order tests and these show no regressions in
allocation success rates at rest, and some significant improvements under
load.


This patch:

We are transitioning pages from active to inactive in clear_active_flags,
those need counting as PGDEACTIVATE vm events.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/vmscan.c~ensure-we-count-pages-transitioning-inactive-via-clear_active_flags mm/vmscan.c
--- a/mm/vmscan.c~ensure-we-count-pages-transitioning-inactive-via-clear_active_flags
+++ a/mm/vmscan.c
@@ -777,6 +777,7 @@ static unsigned long shrink_inactive_lis
 			     (sc->order > PAGE_ALLOC_COSTLY_ORDER)?
 					     ISOLATE_BOTH : ISOLATE_INACTIVE);
 		nr_active = clear_active_flags(&page_list);
+		__count_vm_events(PGDEACTIVATE, nr_active);
 
 		__mod_zone_page_state(zone, NR_ACTIVE, -nr_active);
 		__mod_zone_page_state(zone, NR_INACTIVE,
_

Patches currently in -mm which might be from apw@shadowen.org are

x86_64-get-mp_bus_to_node-as-early-v2.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default-v2.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
pci-device-ensure-sysdata-initialised-v4.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static-fix.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-fix.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch
generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
ensure-we-count-pages-transitioning-inactive-via-clear_active_flags.patch
wait-for-page-writeback-when-directly-reclaiming-contiguous-areas.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-a-configure-option-to-group-pages-by-mobility.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
page-owner-tracking-leak-detector.patch
