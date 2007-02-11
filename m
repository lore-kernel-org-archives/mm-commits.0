From: akpm@linux-foundation.org
Subject: - reorder-zvcs-according-to-cacheline.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:46:20 -0800
Message-ID: <200702112246.l1BMkKlQ015482@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59488 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932611AbXBKWqW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:46:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Reorder ZVCs according to cacheline
has been removed from the -mm tree.  Its filename was
     reorder-zvcs-according-to-cacheline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Reorder ZVCs according to cacheline
From: Christoph Lameter <clameter@sgi.com>

The global and per zone counter sums are in arrays of longs.  Reorder the ZVCs
so that the most frequently used ZVCs are put into the same cacheline.  That
way calculations of the global, node and per zone vm state touches only a
single cacheline.  This is mostly important for 64 bit systems were one 128
byte cacheline takes only 8 longs.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    8 +++++---
 mm/vmstat.c            |    4 ++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff -puN include/linux/mmzone.h~reorder-zvcs-according-to-cacheline include/linux/mmzone.h
--- a/include/linux/mmzone.h~reorder-zvcs-according-to-cacheline
+++ a/include/linux/mmzone.h
@@ -47,6 +47,7 @@ struct zone_padding {
 #endif
 
 enum zone_stat_item {
+	/* First 128 byte cacheline (assuming 64 bit words) */
 	NR_FREE_PAGES,
 	NR_INACTIVE,
 	NR_ACTIVE,
@@ -54,11 +55,12 @@ enum zone_stat_item {
 	NR_FILE_MAPPED,	/* pagecache pages mapped into pagetables.
 			   only modified from process context */
 	NR_FILE_PAGES,
-	NR_SLAB_RECLAIMABLE,
-	NR_SLAB_UNRECLAIMABLE,
-	NR_PAGETABLE,	/* used for pagetables */
 	NR_FILE_DIRTY,
 	NR_WRITEBACK,
+	/* Second 128 byte cacheline */
+	NR_SLAB_RECLAIMABLE,
+	NR_SLAB_UNRECLAIMABLE,
+	NR_PAGETABLE,		/* used for pagetables */
 	NR_UNSTABLE_NFS,	/* NFS unstable pages */
 	NR_BOUNCE,
 	NR_VMSCAN_WRITE,
diff -puN mm/vmstat.c~reorder-zvcs-according-to-cacheline mm/vmstat.c
--- a/mm/vmstat.c~reorder-zvcs-according-to-cacheline
+++ a/mm/vmstat.c
@@ -447,11 +447,11 @@ static const char * const vmstat_text[] 
 	"nr_anon_pages",
 	"nr_mapped",
 	"nr_file_pages",
+	"nr_dirty",
+	"nr_writeback",
 	"nr_slab_reclaimable",
 	"nr_slab_unreclaimable",
 	"nr_page_table_pages",
-	"nr_dirty",
-	"nr_writeback",
 	"nr_unstable",
 	"nr_bounce",
 	"nr_vmscan_write",
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
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
