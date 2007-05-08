From: akpm@linux-foundation.org
Subject: - do-not-disable-interrupts-when-reading-min_free_kbytes.patch removed from -mm tree
Date: Mon, 07 May 2007 17:02:45 -0700
Message-ID: <200705080002.l4802jep008869@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967324AbXEHADJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:03:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, clameter@engr.sgi.com, mm-commits@vger.kernel.org


The patch titled
     Do not disable interrupts when reading min_free_kbytes
has been removed from the -mm tree.  Its filename was
     do-not-disable-interrupts-when-reading-min_free_kbytes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Do not disable interrupts when reading min_free_kbytes
From: Mel Gorman <mel@csn.ul.ie>

The sysctl handler for min_free_kbytes calls setup_per_zone_pages_min() on
read or write.  This function iterates through every zone and calls
spin_lock_irqsave() on the zone LRU lock.  When reading min_free_kbytes,
this is a total waste of time that disables interrupts on the local
processor.  It might even be noticable machines with large numbers of zones
if a process started constantly reading min_free_kbytes.

This patch only calls setup_per_zone_pages_min() only on write. Tested on
an x86 laptop and it did the right thing.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~do-not-disable-interrupts-when-reading-min_free_kbytes mm/page_alloc.c
--- a/mm/page_alloc.c~do-not-disable-interrupts-when-reading-min_free_kbytes
+++ a/mm/page_alloc.c
@@ -3199,7 +3199,8 @@ int min_free_kbytes_sysctl_handler(ctl_t
 	struct file *file, void __user *buffer, size_t *length, loff_t *ppos)
 {
 	proc_dointvec(table, write, file, buffer, length, ppos);
-	setup_per_zone_pages_min();
+	if (write)
+		setup_per_zone_pages_min();
 	return 0;
 }
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
move-free-pages-between-lists-on-steal-anti-fragmentation-switch-over-to-pfn_valid_within.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
create-the-zone_movable-zone.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
handle-kernelcore=-generic.patch
lumpy-reclaim-v4.patch
lumpy-move-to-using-pfn_valid_within.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
add-debugging-aid-for-memory-initialisation-problems.patch
