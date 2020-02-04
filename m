From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 08/67] mm/memory_hotplug: poison memmap in
 remove_pfn_range_from_zone()
Date: Mon, 03 Feb 2020 17:34:09 -0800
Message-ID: <20200204013409.sNZYG6x_7%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgBDBeL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Feb 2020 20:34:11 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com, dan.j.williams@intel.com, david@redhat.com, gregkh@linuxfoundation.org, linux-mm@kvack.org, logang@deltatee.com, mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de, pagupta@redhat.com, pasha.tatashin@soleen.com, torvalds@linux-foundation.org, willy@infradead.org

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
