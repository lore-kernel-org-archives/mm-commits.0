From: akpm@linux-foundation.org
Subject: [merged]
 mm-memmap_init-update-variable-name-in-memmap_init_zone.patch removed from
 -mm tree
Date: Tue, 04 Feb 2020 10:40:09 -0800
Message-ID: <20200204184009.qOPgkvjgU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727308AbgBDSkL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:40:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, dan.j.williams@intel.com, david@redhat.com, gregkh@linuxfoundation.org, logang@deltatee.com, mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de, pagupta@redhat.com, pasha.tatashin@soleen.com, willy@infradead.org


The patch titled
     Subject: mm/memmap_init: update variable name in memmap_init_zone
has been removed from the -mm tree.  Its filename was
     mm-memmap_init-update-variable-name-in-memmap_init_zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/memmap_init: update variable name in memmap_init_zone

Patch series "mm/memory_hotplug: Shrink zones before removing memory", v6.


This series fixes the access of uninitialized memmaps when shrinking
zones/nodes and when removing memory.  Also, it contains all fixes for
crashes that can be triggered when removing certain namespace using
memunmap_pages() - ZONE_DEVICE, reported by Aneesh.

We stop trying to shrink ZONE_DEVICE, as it's buggy, fixing it would be
more involved (we don't have SECTION_IS_ONLINE as an indicator), and
shrinking is only of limited use (set_zone_contiguous() cannot detect the
ZONE_DEVICE as contiguous).

We continue shrinking !ZONE_DEVICE zones, however, I reduced the amount of
code to a minimum.  Shrinking is especially necessary to keep
zone->contiguous set where possible, especially, on memory unplug of DIMMs
at zone boundaries.

--------------------------------------------------------------------------

Zones are now properly shrunk when offlining memory blocks or when
onlining failed.  This allows to properly shrink zones on memory unplug
even if the separate memory blocks of a DIMM were onlined to different
zones or re-onlined to a different zone after offlining.

Example:

:/# cat /proc/zoneinfo
Node 1, zone  Movable
        spanned  0
        present  0
        managed  0
:/# echo "online_movable" > /sys/devices/system/memory/memory41/state
:/# echo "online_movable" > /sys/devices/system/memory/memory43/state
:/# cat /proc/zoneinfo
Node 1, zone  Movable
        spanned  98304
        present  65536
        managed  65536
:/# echo 0 > /sys/devices/system/memory/memory43/online
:/# cat /proc/zoneinfo
Node 1, zone  Movable
        spanned  32768
        present  32768
        managed  32768
:/# echo 0 > /sys/devices/system/memory/memory41/online
:/# cat /proc/zoneinfo
Node 1, zone  Movable
        spanned  0
        present  0
        managed  0


This patch (of 6):

The third argument is actually number of pages.  Change the variable name
from size to nr_pages to indicate this better.

No functional change in this patch.

Link: http://lkml.kernel.org/r/20191006085646.5768-3-david@redhat.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pankaj Gupta <pagupta@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-memmap_init-update-variable-name-in-memmap_init_zone
+++ a/mm/page_alloc.c
@@ -5946,10 +5946,10 @@ void __meminit memmap_init_zone(unsigned
 #ifdef CONFIG_ZONE_DEVICE
 void __ref memmap_init_zone_device(struct zone *zone,
 				   unsigned long start_pfn,
-				   unsigned long size,
+				   unsigned long nr_pages,
 				   struct dev_pagemap *pgmap)
 {
-	unsigned long pfn, end_pfn = start_pfn + size;
+	unsigned long pfn, end_pfn = start_pfn + nr_pages;
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	struct vmem_altmap *altmap = pgmap_altmap(pgmap);
 	unsigned long zone_idx = zone_idx(zone);
@@ -5966,7 +5966,7 @@ void __ref memmap_init_zone_device(struc
 	 */
 	if (altmap) {
 		start_pfn = altmap->base_pfn + vmem_altmap_offset(altmap);
-		size = end_pfn - start_pfn;
+		nr_pages = end_pfn - start_pfn;
 	}
 
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
@@ -6013,7 +6013,7 @@ void __ref memmap_init_zone_device(struc
 	}
 
 	pr_info("%s initialised %lu pages in %ums\n", __func__,
-		size, jiffies_to_msecs(jiffies - start));
+		nr_pages, jiffies_to_msecs(jiffies - start));
 }
 
 #endif
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are
