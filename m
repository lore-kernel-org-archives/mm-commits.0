From: akpm@osdl.org
Subject: + check-for-populated-zone-in-__drain_pages.patch added to -mm tree
Date: Thu, 04 Jan 2007 14:11:46 -0800
Message-ID: <200701042211.l04MBlgH000470@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp0.osdl.org ([65.172.181.24]:58259 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965081AbXADWL5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 17:11:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     Check for populated zone in __drain_pages
has been added to the -mm tree.  Its filename is
     check-for-populated-zone-in-__drain_pages.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Check for populated zone in __drain_pages
From: Christoph Lameter <clameter@sgi.com>

Both process_zones() and drain_node_pages() check for populated zones
before touching pagesets.  However, __drain_pages does not do so,

This may result in a NULL pointer dereference for pagesets in unpopulated
zones if a NUMA setup is combined with cpu hotplug.

Initially the unpopulated zone has the pcp pointers pointing to the boot
pagesets.  Since the zone is not populated the boot pageset pointers will
not be changed during page allocator and slab bootstrap.

If a cpu is later brought down (first call to __drain_pages()) then the pcp
pointers for cpus in unpopulated zones are set to NULL since __drain_pages
does not first check for an unpopulated zone.

If the cpu is then brought up again then we call process_zones() which will
ignore the unpopulated zone.  So the pageset pointers will still be NULL.

If the cpu is then again brought down then __drain_pages will attempt to
drain pages by following the NULL pageset pointer for unpopulated zones.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/page_alloc.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN mm/page_alloc.c~check-for-populated-zone-in-__drain_pages mm/page_alloc.c
--- a/mm/page_alloc.c~check-for-populated-zone-in-__drain_pages
+++ a/mm/page_alloc.c
@@ -715,6 +715,9 @@ static void __drain_pages(unsigned int c
 	for_each_zone(zone) {
 		struct per_cpu_pageset *pset;
 
+		if (!populated_zone(zone))
+			continue;
+
 		pset = zone_pcp(zone, cpu);
 		for (i = 0; i < ARRAY_SIZE(pset->pcp); i++) {
 			struct per_cpu_pages *pcp;
_

Patches currently in -mm which might be from clameter@sgi.com are

fix-bug_onpageslab-from-fallback_alloc.patch
check-for-populated-zone-in-__drain_pages.patch
deal-with-cases-of-zone_dma-meaning-the-first-zone.patch
introduce-config_zone_dma.patch
optional-zone_dma-in-the-vm.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set.patch
optional-zone_dma-in-the-vm-no-gfp_dma-check-in-the-slab-if-no-config_zone_dma-is-set-reduce-config_zone_dma-ifdefs.patch
optional-zone_dma-for-ia64.patch
remove-zone_dma-remains-from-parisc.patch
remove-zone_dma-remains-from-sh-sh64.patch
set-config_zone_dma-for-arches-with-generic_isa_dma.patch
zoneid-fix-up-calculations-for-zoneid_pgshift.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
