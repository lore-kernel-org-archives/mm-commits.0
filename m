From: akpm@linux-foundation.org
Subject: [patch 116/119] mm, memory_hotplug: fix memmap
 initialization
Date: Wed, 31 Jan 2018 16:21:14 -0800
Message-ID: <20180201002114.A4R7B1sCW%akpm__19328.194918535$1517444386$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36556 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754559AbeBAAVR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:21:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bharata@linux.vnet.ibm.com, bob.picco@oracle.com, daniel.m.jordan@oracle.com, mhocko@suse.com, mm-commits@vger.kernel.org, pasha.tatashin@oracle.com, stable@vger.kernel.org, steven.sistare@oracle.com, torvalds@linux-foundation.org

From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory_hotplug: fix memmap initialization

Bharata has noticed that onlining a newly added memory doesn't increase
the total memory, pointing to f7f99100d8d9 ("mm: stop zeroing memory
during allocation in vmemmap") as a culprit.  This commit has changed the
way how the memory for memmaps is initialized and moves it from the
allocation time to the initialization time.  This works properly for the
early memmap init path.

It doesn't work for the memory hotplug though because we need to mark page
as reserved when the sparsemem section is created and later initialize it
completely during onlining.  memmap_init_zone is called in the early stage
of onlining.  With the current code it calls __init_single_page and as
such it clears up the whole stage and therefore online_pages_range skips
those pages.

Fix this by skipping mm_zero_struct_page in __init_single_page for memory
hotplug path.  This is quite uggly but unifying both early init and memory
hotplug init paths is a large project.  Make sure we plug the regression
at least.

Link: http://lkml.kernel.org/r/20180130101141.GW21609@dhcp22.suse.cz
Fixes: f7f99100d8d9 ("mm: stop zeroing memory during allocation in vmemmap")
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Tested-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Reviewed-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Cc: Steven Sistare <steven.sistare@oracle.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Bob Picco <bob.picco@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff -puN mm/page_alloc.c~mm-memory_hotplug-fix-memmap-initialization mm/page_alloc.c
--- a/mm/page_alloc.c~mm-memory_hotplug-fix-memmap-initialization
+++ a/mm/page_alloc.c
@@ -1177,9 +1177,10 @@ static void free_one_page(struct zone *z
 }
 
 static void __meminit __init_single_page(struct page *page, unsigned long pfn,
-				unsigned long zone, int nid)
+				unsigned long zone, int nid, bool zero)
 {
-	mm_zero_struct_page(page);
+	if (zero)
+		mm_zero_struct_page(page);
 	set_page_links(page, zone, nid, pfn);
 	init_page_count(page);
 	page_mapcount_reset(page);
@@ -1194,9 +1195,9 @@ static void __meminit __init_single_page
 }
 
 static void __meminit __init_single_pfn(unsigned long pfn, unsigned long zone,
-					int nid)
+					int nid, bool zero)
 {
-	return __init_single_page(pfn_to_page(pfn), pfn, zone, nid);
+	return __init_single_page(pfn_to_page(pfn), pfn, zone, nid, zero);
 }
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
@@ -1217,7 +1218,7 @@ static void __meminit init_reserved_page
 		if (pfn >= zone->zone_start_pfn && pfn < zone_end_pfn(zone))
 			break;
 	}
-	__init_single_pfn(pfn, zid, nid);
+	__init_single_pfn(pfn, zid, nid, true);
 }
 #else
 static inline void init_reserved_page(unsigned long pfn)
@@ -1534,7 +1535,7 @@ static unsigned long  __init deferred_in
 		} else {
 			page++;
 		}
-		__init_single_page(page, pfn, zid, nid);
+		__init_single_page(page, pfn, zid, nid, true);
 		nr_pages++;
 	}
 	return (nr_pages);
@@ -5399,15 +5400,20 @@ not_early:
 		 * can be created for invalid pages (for alignment)
 		 * check here not to call set_pageblock_migratetype() against
 		 * pfn out of zone.
+		 *
+		 * Please note that MEMMAP_HOTPLUG path doesn't clear memmap
+		 * because this is done early in sparse_add_one_section
 		 */
 		if (!(pfn & (pageblock_nr_pages - 1))) {
 			struct page *page = pfn_to_page(pfn);
 
-			__init_single_page(page, pfn, zone, nid);
+			__init_single_page(page, pfn, zone, nid,
+					context != MEMMAP_HOTPLUG);
 			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
 			cond_resched();
 		} else {
-			__init_single_pfn(pfn, zone, nid);
+			__init_single_pfn(pfn, zone, nid,
+					context != MEMMAP_HOTPLUG);
 		}
 	}
 }
_
