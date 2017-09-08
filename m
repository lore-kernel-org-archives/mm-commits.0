From: akpm@linux-foundation.org
Subject: [patch 010/126] mm: memory_hotplug: memory hotremove
 supports thp migration
Date: Fri, 08 Sep 2017 16:11:15 -0700
Message-ID: <20170908231115.h2Rz-w2BD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51252 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757173AbdIHXLX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:11:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, dave.hansen@intel.com, dnellans@nvidia.com, hpa@zytor.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz, zi.yan@cs.rutgers.edu

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: memory_hotplug: memory hotremove supports thp migration

This patch enables thp migration for memory hotremove.

Link: http://lkml.kernel.org/r/20170717193955.20207-11-zi.yan@sent.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Zi Yan <zi.yan@cs.rutgers.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Nellans <dnellans@nvidia.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |   15 ++++++++++++++-
 mm/memory_hotplug.c     |    4 +++-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff -puN include/linux/migrate.h~mm-memory_hotplug-memory-hotremove-supports-thp-migration include/linux/migrate.h
--- a/include/linux/migrate.h~mm-memory_hotplug-memory-hotremove-supports-thp-migration
+++ a/include/linux/migrate.h
@@ -35,15 +35,28 @@ static inline struct page *new_page_node
 				int preferred_nid, nodemask_t *nodemask)
 {
 	gfp_t gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL;
+	unsigned int order = 0;
+	struct page *new_page = NULL;
 
 	if (PageHuge(page))
 		return alloc_huge_page_nodemask(page_hstate(compound_head(page)),
 				preferred_nid, nodemask);
 
+	if (thp_migration_supported() && PageTransHuge(page)) {
+		order = HPAGE_PMD_ORDER;
+		gfp_mask |= GFP_TRANSHUGE;
+	}
+
 	if (PageHighMem(page) || (zone_idx(page_zone(page)) == ZONE_MOVABLE))
 		gfp_mask |= __GFP_HIGHMEM;
 
-	return __alloc_pages_nodemask(gfp_mask, 0, preferred_nid, nodemask);
+	new_page = __alloc_pages_nodemask(gfp_mask, order,
+				preferred_nid, nodemask);
+
+	if (new_page && PageTransHuge(page))
+		prep_transhuge_page(new_page);
+
+	return new_page;
 }
 
 #ifdef CONFIG_MIGRATION
diff -puN mm/memory_hotplug.c~mm-memory_hotplug-memory-hotremove-supports-thp-migration mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-memory-hotremove-supports-thp-migration
+++ a/mm/memory_hotplug.c
@@ -1380,7 +1380,9 @@ do_migrate_range(unsigned long start_pfn
 			if (isolate_huge_page(page, &source))
 				move_pages -= 1 << compound_order(head);
 			continue;
-		}
+		} else if (thp_migration_supported() && PageTransHuge(page))
+			pfn = page_to_pfn(compound_head(page))
+				+ hpage_nr_pages(page) - 1;
 
 		if (!get_page_unless_zero(page))
 			continue;
_
