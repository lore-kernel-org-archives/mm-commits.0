From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-fix-and-rework-pfn-handling-in-memmap_init_zone.patch added to
 -mm tree
Date: Mon, 13 Jan 2020 14:01:12 -0800
Message-ID: <20200113220112.sLDen%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:32900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728733AbgAMWBN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jan 2020 17:01:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhi.jin@intel.com, vbabka@suse.cz, pasha.tatashin@oracle.com, osalvador@suse.de, mhocko@suse.com, mhocko@kernel.org, mgorman@suse.de, kirill@shutemov.name, kirill.shutemov@linux.intel.com, dan.j.williams@intel.com, bhe@redhat.com, david@redhat.com


The patch titled
     Subject: mm/page_alloc: fix and rework pfn handling in memmap_init_zone()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-and-rework-pfn-handling-in-memmap_init_zone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fix-and-rework-pfn-handling-in-memmap_init_zone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fix-and-rework-pfn-handling-in-memmap_init_zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
no idea if this is relevant in practise (with kernelcore=3Dmirror).

Link: http://lkml.kernel.org/r/20200113144035.10848-2-david@redhat.com
Fixes: a9a9e77fbf27 ("mm: move mirrored memory specific code outside of m=
emmap_init_zone")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Pavel Tatashin <pasha.tatashin@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Jin, Zhi" <zhi.jin@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
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

mm-fix-uninitialized-memmaps-on-a-partially-populated-last-section.patch
fs-proc-pagec-allow-inspection-of-last-section-and-fix-end-detection.patch
mm-initialize-memmap-of-unavailable-memory-directly.patch
mm-memory_hotplug-dont-free-usage-map-when-removing-a-re-added-early-section.patch
drivers-base-memoryc-cache-blocks-in-radix-tree-to-accelerate-lookup-fix-2.patch
mm-memory_hotplug-poison-memmap-in-remove_pfn_range_from_zone.patch
mm-memory_hotplug-we-always-have-a-zone-in-find_smallestbiggest_section_pfn.patch
mm-memory_hotplug-dont-check-for-all-holes-in-shrink_zone_span.patch
mm-memory_hotplug-drop-local-variables-in-shrink_zone_span.patch
mm-memory_hotplug-cleanup-__remove_pages.patch
mm-memory_hotplug-drop-valid_start-valid_end-from-test_pages_in_a_zone.patch
mm-page_alloc-fix-and-rework-pfn-handling-in-memmap_init_zone.patch
mm-factor-out-next_present_section_nr.patch
