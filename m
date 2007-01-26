From: akpm@osdl.org
Subject: + readahead-state-based-method-aging-accounting-vs-zvc-changes.patch added to -mm tree
Date: Fri, 26 Jan 2007 14:04:58 -0800
Message-ID: <200701262204.l0QM4wjX027794@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57151 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbXAZWFB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 17:05:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     ZVC writeback: Fix mm and other issues
has been added to the -mm tree.  Its filename is
     readahead-state-based-method-aging-accounting-vs-zvc-changes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ZVC writeback: Fix mm and other issues
From: Christoph Lameter <clameter@sgi.com>

This deals with swap prefetch and various things changed in mm.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/page_alloc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~readahead-state-based-method-aging-accounting-vs-zvc-changes mm/page_alloc.c
--- a/mm/page_alloc.c~readahead-state-based-method-aging-accounting-vs-zvc-changes
+++ a/mm/page_alloc.c
@@ -1507,12 +1507,12 @@ unsigned int nr_free_pagecache_pages(voi
 unsigned long nr_free_inactive_pages_node(int nid)
 {
 	enum zone_type i;
-	unsigned long sum = 0;
+	unsigned long sum = node_page_state(nid, NR_FREE_PAGES)
+				+ node_page_state(nid, NR_INACTIVE);
 	struct zone *zones = NODE_DATA(nid)->node_zones;
 
 	for (i = 0; i < MAX_NR_ZONES; i++)
-		sum += zones[i].nr_inactive +
-			zones[i].free_pages - zones[i].pages_low;
+		sum -= zones[i].pages_low;
 
 	return sum;
 }
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-cache_grow-cleanup.patch
use-zvc-for-inactive-and-active-counts.patch
use-zvc-for-free_pages.patch
use-zvc-for-free_pages-fix.patch
use-zvc-for-free_pages-fix-2.patch
reorder-zvcs-according-to-cacheline.patch
drop-free_pages.patch
drop-nr_free_pages_pgdat.patch
drop-__get_zone_counts.patch
drop-get_zone_counts.patch
get_dirty_limits-accurately-calculate-the-available-memory-that-can-be-dirtied.patch
get_dirty_limits-accurately-calculate-the-available-memory-that-can-be-dirtied-fix.patch
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
replace-highest_possible_node_id-with-nr_node_ids.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-aging-accounting-vs-zvc-changes.patch
