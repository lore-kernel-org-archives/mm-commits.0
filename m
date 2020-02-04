From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory_hotplug-poison-memmap-in-remove_pfn_range_from_zone.patch removed
 from -mm tree
Date: Tue, 04 Feb 2020 10:40:12 -0800
Message-ID: <20200204184012.WWGg0AhwB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727308AbgBDSkN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:40:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.ibm.com, dan.j.williams@intel.com, david@redhat.com, gregkh@linuxfoundation.org, logang@deltatee.com, mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de, pagupta@redhat.com, pasha.tatashin@soleen.com, willy@infradead.org


The patch titled
     Subject: mm/memory_hotplug: poison memmap in remove_pfn_range_from_zone()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-poison-memmap-in-remove_pfn_range_from_zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: poison memmap in remove_pfn_range_from_zone()

Let's poison the pages similar to when adding new memory in
sparse_add_section().  Also call remove_pfn_range_from_zone() from
memunmap_pages(), so we can poison the memmap from there as well.

Link: http://lkml.kernel.org/r/20191006085646.5768-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pankaj Gupta <pagupta@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    3 +++
 mm/memremap.c       |    2 ++
 2 files changed, 5 insertions(+)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-poison-memmap-in-remove_pfn_range_from_zone
+++ a/mm/memory_hotplug.c
@@ -490,6 +490,9 @@ void __ref remove_pfn_range_from_zone(st
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	unsigned long flags;
 
+	/* Poison struct pages because they are now uninitialized again. */
+	page_init_poison(pfn_to_page(start_pfn), sizeof(struct page) * nr_pages);
+
 #ifdef CONFIG_ZONE_DEVICE
 	/*
 	 * Zone shrinking code cannot properly deal with ZONE_DEVICE. So
--- a/mm/memremap.c~mm-memory_hotplug-poison-memmap-in-remove_pfn_range_from_zone
+++ a/mm/memremap.c
@@ -120,6 +120,8 @@ void memunmap_pages(struct dev_pagemap *
 	nid = page_to_nid(first_page);
 
 	mem_hotplug_begin();
+	remove_pfn_range_from_zone(page_zone(first_page), PHYS_PFN(res->start),
+				   PHYS_PFN(resource_size(res)));
 	if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
 		__remove_pages(PHYS_PFN(res->start),
 			       PHYS_PFN(resource_size(res)), NULL);
_

Patches currently in -mm which might be from david@redhat.com are

drivers-base-memoryc-cache-memory-blocks-in-xarray-to-accelerate-lookup-fix.patch
