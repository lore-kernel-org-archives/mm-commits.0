From: akpm@osdl.org
Subject: + reorder-zvcs-according-to-cacheline.patch added to -mm tree
Date: Thu, 25 Jan 2007 22:16:40 -0800
Message-ID: <200701260616.l0Q6GeD4009153@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47730 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbXAZGQm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 01:16:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     Reorder ZVCs according to cacheline
has been added to the -mm tree.  Its filename is
     reorder-zvcs-according-to-cacheline.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Reorder ZVCs according to cacheline
From: Christoph Lameter <clameter@sgi.com>

The global and per zone counter sums are in arrays of longs.  Reorder the ZVCs
so that the most frequently used ZVCs are put into the same cacheline.  That
way calculations of the global, node and per zone vm state touches only a
single cacheline.  This is mostly important for 64 bit systems were one 128
byte cacheline takes only 8 longs.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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

mbind-restrict-nodes-to-the-currently-allowed-cpuset.patch
slab-cache_grow-cleanup.patch
use-zvc-for-inactive-and-active-counts.patch
use-zvc-for-free_pages.patch
reorder-zvcs-according-to-cacheline.patch
drop-free_pages.patch
drop-nr_free_pages_pgdat.patch
drop-__get_zone_counts.patch
drop-get_zone_counts.patch
fix-writeback-calculation.patch
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
