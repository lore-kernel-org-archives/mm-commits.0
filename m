From: akpm@linux-foundation.org
Subject: - deal-with-cases-of-zone_dma-meaning-the-first-zone.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:46:30 -0800
Message-ID: <200702112246.l1BMkUmD015497@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59579 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932630AbXBKWrE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:47:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, James.Bottomley@steeleye.com, ak@suse.de, apw@shadowen.org, hch@infradead.org, kyle@mcmartin.ca, lethal@linux-sh.org, tony.luck@intel.com, willy@debian.org, mm-commits@vger.kernel.org


The patch titled
     optional ZONE_DMA: deal with cases of ZONE_DMA meaning the first zone
has been removed from the -mm tree.  Its filename was
     deal-with-cases-of-zone_dma-meaning-the-first-zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: optional ZONE_DMA: deal with cases of ZONE_DMA meaning the first zone
From: Christoph Lameter <clameter@sgi.com>

This patchset follows up on the earlier work in Andrew's tree to reduce the
number of zones.  The patches allow to go to a minimum of 2 zones.  This one
allows also to make ZONE_DMA optional and therefore the number of zones can be
reduced to one.

ZONE_DMA is usually used for ISA DMA devices.  There are a number of reasons
why we would not want to have ZONE_DMA

1. Some arches do not need ZONE_DMA at all.

2. With the advent of IOMMUs DMA zones are no longer needed.
   The necessity of DMA zones may drastically be reduced
   in the future. This patchset allows a compilation of
   a kernel without that overhead.

3. Devices that require ISA DMA get rare these days. All
   my systems do not have any need for ISA DMA.

4. The presence of an additional zone unecessarily complicates
   VM operations because it must be scanned and balancing
   logic must operate on its.

5. With only ZONE_NORMAL one can reach the situation where
   we have only one zone. This will allow the unrolling of many
   loops in the VM and allows the optimization of varous
   code paths in the VM.

6. Having only a single zone in a NUMA system results in a
   1-1 correspondence between nodes and zones. Various additional
   optimizations to critical VM paths become possible.

Many systems today can operate just fine with a single zone.  If you look at
what is in ZONE_DMA then one usually sees that nothing uses it.  The DMA slabs
are empty (Some arches use ZONE_DMA instead of ZONE_NORMAL, then ZONE_NORMAL
will be empty instead).

On all of my systems (i386, x86_64, ia64) ZONE_DMA is completely empty.  Why
constantly look at an empty zone in /proc/zoneinfo and empty slab in
/proc/slabinfo?  Non i386 also frequently have no need for ZONE_DMA and zones
stay empty.

The patchset was tested on i386 (UP / SMP), x86_64 (UP, NUMA) and ia64 (NUMA).

The RFC posted earlier (see
http://marc.theaimsgroup.com/?l=linux-kernel&m=115231723513008&w=2) had lots
of #ifdefs in them.  An effort has been made to minize the number of #ifdefs
and make this as compact as possible.  The job was made much easier by the
ongoing efforts of others to extract common arch specific functionality.

I have been running this for awhile now on my desktop and finally Linux is
using all my available RAM instead of leaving the 16MB in ZONE_DMA untouched:

christoph@pentium940:~$ cat /proc/zoneinfo
Node 0, zone   Normal
  pages free     4435
        min      1448
        low      1810
        high     2172
        active   241786
        inactive 210170
        scanned  0 (a: 0 i: 0)
        spanned  524224
        present  524224
    nr_anon_pages 61680
    nr_mapped    14271
    nr_file_pages 390264
    nr_slab_reclaimable 27564
    nr_slab_unreclaimable 1793
    nr_page_table_pages 449
    nr_dirty     39
    nr_writeback 0
    nr_unstable  0
    nr_bounce    0
    cpu: 0 pcp: 0
              count: 156
              high:  186
              batch: 31
    cpu: 0 pcp: 1
              count: 9
              high:  62
              batch: 15
  vm stats threshold: 20
    cpu: 1 pcp: 0
              count: 177
              high:  186
              batch: 31
    cpu: 1 pcp: 1
              count: 12
              high:  62
              batch: 15
  vm stats threshold: 20
  all_unreclaimable: 0
  prev_priority:     12
  temp_priority:     12
  start_pfn:         0



This patch:


In two places in the VM we use ZONE_DMA to refer to the first zone.  If
ZONE_DMA is optional then other zones may be first.  So simply replace
ZONE_DMA with zone 0.

This also fixes ZONETABLE_PGSHIFT.  If we have only a single zone then
ZONES_PGSHIFT may become 0 because there is no need anymore to encode the zone
number related to a pgdat.  However, we still need a zonetable to index all
the zones for each node if this is a NUMA system.  Therefore define
ZONETABLE_SHIFT unconditionally as the offset of the ZONE field in page flags.

[apw@shadowen.org: fix mismerge]
Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <willy@debian.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c  |    2 +-
 mm/page_alloc.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/mempolicy.c~deal-with-cases-of-zone_dma-meaning-the-first-zone mm/mempolicy.c
--- a/mm/mempolicy.c~deal-with-cases-of-zone_dma-meaning-the-first-zone
+++ a/mm/mempolicy.c
@@ -105,7 +105,7 @@ static struct kmem_cache *sn_cache;
 
 /* Highest zone. An specific allocation for a zone below that is not
    policied. */
-enum zone_type policy_zone = ZONE_DMA;
+enum zone_type policy_zone = 0;
 
 struct mempolicy default_policy = {
 	.refcnt = ATOMIC_INIT(1), /* never free it */
diff -puN mm/page_alloc.c~deal-with-cases-of-zone_dma-meaning-the-first-zone mm/page_alloc.c
--- a/mm/page_alloc.c~deal-with-cases-of-zone_dma-meaning-the-first-zone
+++ a/mm/page_alloc.c
@@ -2619,11 +2619,11 @@ static void __meminit free_area_init_cor
 				"  %s zone: %lu pages exceeds realsize %lu\n",
 				zone_names[j], memmap_pages, realsize);
 
-		/* Account for reserved DMA pages */
-		if (j == ZONE_DMA && realsize > dma_reserve) {
+		/* Account for reserved pages */
+		if (j == 0 && realsize > dma_reserve) {
 			realsize -= dma_reserve;
-			printk(KERN_DEBUG "  DMA zone: %lu pages reserved\n",
-								dma_reserve);
+			printk(KERN_DEBUG "  %s zone: %lu pages reserved\n",
+					zone_names[0], dma_reserve);
 		}
 
 		if (!is_highmem_idx(j))
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
