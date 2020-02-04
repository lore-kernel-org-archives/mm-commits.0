From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-fix-and-rework-pfn-handling-in-memmap_init_zone.patch removed
 from -mm tree
Date: Tue, 04 Feb 2020 10:40:03 -0800
Message-ID: <20200204184003.XbDITzxj2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727308AbgBDSkF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 Feb 2020 13:40:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.h.duyck@linux.intel.com, bhe@redhat.com, dan.j.williams@intel.com, david@redhat.com, kirill.shutemov@linux.intel.com, kirill@shutemov.name, mgorman@suse.de, mhocko@kernel.org, mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de, pasha.tatashin@oracle.com, vbabka@suse.cz, zhi.jin@intel.com


The patch titled
     Subject: mm/page_alloc: fix and rework pfn handling in memmap_init_zone()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-and-rework-pfn-handling-in-memmap_init_zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_alloc: fix and rework pfn handling in memmap_init_zone()

Let's update the pfn manually whenever we continue the loop.  This makes
the code easier to read but also less error prone (and we can directly fix
one issue).

When overlap_memmap_init() returns true, pfn is updated to
"memblock_region_memory_end_pfn(r)".  So it already points at the *next*
pfn to process.  Incrementing the pfn another time is wrong, we might
leave one uninitialized.  I spotted this by inspecting the code, so I have
no idea if this is relevant in practise (with kernelcore=mirror).

Link: http://lkml.kernel.org/r/20200113144035.10848-2-david@redhat.com
Fixes: a9a9e77fbf27 ("mm: move mirrored memory specific code outside of m=
emmap_init_zone")
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Pavel Tatashin <pasha.tatashin@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Jin, Zhi" <zhi.jin@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-and-rework-pfn-handling-in-memmap_init_zone
+++ a/mm/page_alloc.c
@@ -5905,18 +5905,20 @@ void __meminit memmap_init_zone(unsigned
 	}
 #endif
 
-	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
+	for (pfn = start_pfn; pfn < end_pfn; ) {
 		/*
 		 * There can be holes in boot-time mem_map[]s handed to this
 		 * function.  They do not exist on hotplugged memory.
 		 */
 		if (context == MEMMAP_EARLY) {
 			if (!early_pfn_valid(pfn)) {
-				pfn = next_pfn(pfn) - 1;
+				pfn = next_pfn(pfn);
 				continue;
 			}
-			if (!early_pfn_in_nid(pfn, nid))
+			if (!early_pfn_in_nid(pfn, nid)) {
+				pfn++;
 				continue;
+			}
 			if (overlap_memmap_init(zone, &pfn))
 				continue;
 			if (defer_init(nid, pfn, end_pfn))
@@ -5944,6 +5946,7 @@ void __meminit memmap_init_zone(unsigned
 			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 			cond_resched();
 		}
+		pfn++;
 	}
 }
 
_

Patches currently in -mm which might be from david@redhat.com are

drivers-base-memoryc-cache-memory-blocks-in-xarray-to-accelerate-lookup-fix.patch
