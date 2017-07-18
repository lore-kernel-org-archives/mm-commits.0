From: akpm@linux-foundation.org
Subject: + mm-memory_hotplug-memory-hotremove-supports-thp-migration.patch added to -mm tree
Date: Tue, 18 Jul 2017 15:27:25 -0700
Message-ID: <596e8b4d./bl1uEhATxxOdy+w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50022 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752812AbdGRW10 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jul 2017 18:27:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, dave.hansen@intel.com, dnellans@nvidia.com, hpa@zytor.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, minchan@kernel.org, mingo@elte.hu, tglx@linutronix.de, vbabka@suse.cz, zi.yan@cs.rutgers.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory_hotplug: memory hotremove supports thp migration
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-memory-hotremove-supports-thp-migration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-memory-hotremove-supports-thp-migration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-memory-hotremove-supports-thp-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -1416,7 +1416,9 @@ do_migrate_range(unsigned long start_pfn
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

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-mempolicy-add-queue_pages_required.patch
mm-x86-move-_page_swp_soft_dirty-from-bit-7-to-bit-1.patch
mm-thp-introduce-separate-ttu-flag-for-thp-freezing.patch
mm-thp-introduce-config_arch_enable_thp_migration.patch
mm-soft-dirty-keep-soft-dirty-bits-over-thp-migration.patch
mm-mempolicy-mbind-and-migrate_pages-support-thp-migration.patch
mm-migrate-move_pages-supports-thp-migration.patch
mm-memory_hotplug-memory-hotremove-supports-thp-migration.patch

