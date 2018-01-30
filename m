From: akpm@linux-foundation.org
Subject: + mm-memory_hotplug-fix-memmap-initialization.patch added to -mm
 tree
Date: Tue, 30 Jan 2018 11:44:13 -0800
Message-ID: <5a70cb0d.g3tDNQyDHzJXgZ0x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54368 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751805AbeA3ToP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jan 2018 14:44:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, bharata@linux.vnet.ibm.com, bob.picco@oracle.com, daniel.m.jordan@oracle.com, pasha.tatashin@oracle.com, stable@vger.kernel.org, steven.sistare@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory_hotplug: fix memmap initialization
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-fix-memmap-initialization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-fix-memmap-initialization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-fix-memmap-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -1178,9 +1178,10 @@ static void free_one_page(struct zone *z
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
@@ -1195,9 +1196,9 @@ static void __meminit __init_single_page
 }
 
 static void __meminit __init_single_pfn(unsigned long pfn, unsigned long zone,
-					int nid)
+					int nid, bool zero)
 {
-	return __init_single_page(pfn_to_page(pfn), pfn, zone, nid);
+	return __init_single_page(pfn_to_page(pfn), pfn, zone, nid, zero);
 }
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
@@ -1218,7 +1219,7 @@ static void __meminit init_reserved_page
 		if (pfn >= zone->zone_start_pfn && pfn < zone_end_pfn(zone))
 			break;
 	}
-	__init_single_pfn(pfn, zid, nid);
+	__init_single_pfn(pfn, zid, nid, true);
 }
 #else
 static inline void init_reserved_page(unsigned long pfn)
@@ -1535,7 +1536,7 @@ static unsigned long  __init deferred_in
 		} else {
 			page++;
 		}
-		__init_single_page(page, pfn, zid, nid);
+		__init_single_page(page, pfn, zid, nid, true);
 		nr_pages++;
 	}
 	return (nr_pages);
@@ -5400,15 +5401,20 @@ not_early:
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

Patches currently in -mm which might be from mhocko@suse.com are

mm-drop-hotplug-lock-from-lru_add_drain_all.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix-2.patch
mm-hugetlb-drop-hugepages_treat_as_movable-sysctl.patch
mm-introduce-map_fixed_safe.patch
fs-elf-drop-map_fixed-usage-from-elf_map.patch
fs-elf-drop-map_fixed-usage-from-elf_map-fix-fix.patch
mm-numa-rework-do_pages_move.patch
mm-migrate-remove-reason-argument-from-new_page_t.patch
mm-migrate-remove-reason-argument-from-new_page_t-fix-3.patch
mm-unclutter-thp-migration.patch
mm-hugetlb-unify-core-page-allocation-accounting-and-initialization.patch
mm-hugetlb-integrate-giga-hugetlb-more-naturally-to-the-allocation-path.patch
mm-hugetlb-do-not-rely-on-overcommit-limit-during-migration.patch
mm-hugetlb-get-rid-of-surplus-page-accounting-tricks.patch
mm-hugetlb-further-simplify-hugetlb-allocation-api.patch
hugetlb-mempolicy-fix-the-mbind-hugetlb-migration.patch
hugetlb-mbind-fall-back-to-default-policy-if-vma-is-null.patch
mm-memory_hotplug-fix-memmap-initialization.patch

