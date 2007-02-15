From: akpm@linux-foundation.org
Subject: + use-zvc-counters-to-establish-exact-size-of-dirtyable-pages-fix.patch added to -mm tree
Date: Wed, 14 Feb 2007 20:42:39 -0800
Message-ID: <200702150442.l1F4gdeM019980@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34475 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932685AbXBOEml (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 23:42:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     Use ZVC counters to establish exact size of dirtyable pages (fix)
has been added to the -mm tree.  Its filename is
     use-zvc-counters-to-establish-exact-size-of-dirtyable-pages-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use ZVC counters to establish exact size of dirtyable pages (fix)
From: Christoph Lameter <clameter@sgi.com>

Insure that dirtyable memory calculation always returns positive number

In order to avoid division by zero and strange results we insure that
the memory calculation of dirtyable memory always returns at least 1.

We need to make sure that highmem_dirtyable_memory() never returns a number
larger than the total dirtyable memory. Counter deferrals and strange VM
situations with unimagiably small lowmem may make the count go negative.

Also base the calculation of the mapped_ratio on the amount of dirtyable
memory.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN mm/page-writeback.c~use-zvc-counters-to-establish-exact-size-of-dirtyable-pages-fix mm/page-writeback.c
--- a/mm/page-writeback.c~use-zvc-counters-to-establish-exact-size-of-dirtyable-pages-fix
+++ a/mm/page-writeback.c
@@ -120,7 +120,7 @@ static void background_writeout(unsigned
  * clamping level.
  */
 
-static unsigned long highmem_dirtyable_memory(void)
+static unsigned long highmem_dirtyable_memory(unsigned long total)
 {
 #ifdef CONFIG_HIGHMEM
 	int node;
@@ -134,7 +134,13 @@ static unsigned long highmem_dirtyable_m
 			+ zone_page_state(z, NR_INACTIVE)
 			+ zone_page_state(z, NR_ACTIVE);
 	}
-	return x;
+	/*
+	 * Make sure that the number of highmem pages is never larger
+	 * than the number of the total dirtyable memory. This can only
+	 * occur in very strange VM situations but we want to make sure
+	 * that this does not occur.
+	 */
+	return min(x, total);
 #else
 	return 0;
 #endif
@@ -146,9 +152,9 @@ static unsigned long determine_dirtyable
 
 	x = global_page_state(NR_FREE_PAGES)
 		+ global_page_state(NR_INACTIVE)
-		+ global_page_state(NR_ACTIVE)
-		- highmem_dirtyable_memory();
-	return x;
+		+ global_page_state(NR_ACTIVE);
+	x -= highmem_dirtyable_memory(x);
+	return x + 1;	/* Ensure that we never return 0 */
 }
 
 static void
@@ -165,7 +171,7 @@ get_dirty_limits(long *pbackground, long
 
 	unmapped_ratio = 100 - ((global_page_state(NR_FILE_MAPPED) +
 				global_page_state(NR_ANON_PAGES)) * 100) /
-					vm_total_pages;
+					available_memory;
 
 	dirty_ratio = vm_dirty_ratio;
 	if (dirty_ratio > unmapped_ratio / 2)
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages-fix.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
convert-highest_possible_processor_id-to-nr_cpu_ids.patch
convert-highest_possible_processor_id-to-nr_cpu_ids-fix.patch
slab-reduce-size-of-alien-cache-to-cover-only-possible-nodes.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
mm-implement-swap-prefetching-vs-zvc-stuff.patch
mm-implement-swap-prefetching-vs-zvc-stuff-2.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-aging-accounting-vs-zvc-changes.patch
