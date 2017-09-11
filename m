From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-introduce-separate-ttu-flag-for-thp-freezing.patch removed from -mm
 tree
Date: Mon, 11 Sep 2017 12:38:17 -0700
Message-ID: <20170911193817.dDktyWGRu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48382 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751031AbdIKTi0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:38:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dave.hansen@intel.com, dnellans@nvidia.com, hpa@zytor.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, tglx@linutronix.de, vbabka@suse.cz, zi.yan@cs.rutgers.edu


The patch titled
     Subject: mm: thp: introduce separate TTU flag for thp freezing
has been removed from the -mm tree.  Its filename was
     mm-thp-introduce-separate-ttu-flag-for-thp-freezing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: thp: introduce separate TTU flag for thp freezing

TTU_MIGRATION is used to convert pte into migration entry until thp split
completes.  This behavior conflicts with thp migration added later
patches, so let's introduce a new TTU flag specifically for freezing.

try_to_unmap() is used both for thp split (via freeze_page()) and page
migration (via __unmap_and_move()).  In freeze_page(), ttu_flag given for
head page is like below (assuming anonymous thp):

    (TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS | TTU_RMAP_LOCKED | \
     TTU_MIGRATION | TTU_SPLIT_HUGE_PMD)

and ttu_flag given for tail pages is:

    (TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS | TTU_RMAP_LOCKED | \
     TTU_MIGRATION)

__unmap_and_move() calls try_to_unmap() with ttu_flag:

    (TTU_MIGRATION | TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS)

Now I'm trying to insert a branch for thp migration at the top of
try_to_unmap_one() like below

static int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
                       unsigned long address, void *arg)
  {
          ...
          /* PMD-mapped THP migration entry */
          if (!pvmw.pte && (flags & TTU_MIGRATION)) {
              if (!PageAnon(page))
                  continue;

              set_pmd_migration_entry(&pvmw, page);
              continue;
          }
	  ...
  }

, so try_to_unmap() for tail pages called by thp split can go into thp
migration code path (which converts *pmd* into migration entry), while the
expectation is to freeze thp (which converts *pte* into migration entry.)

I detected this failure as a "bad page state" error in a testcase where
split_huge_page() is called from queue_pages_pte_range().

Link: http://lkml.kernel.org/r/20170717193955.20207-4-zi.yan@sent.com
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Zi Yan <zi.yan@cs.rutgers.edu>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Nellans <dnellans@nvidia.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    3 ++-
 mm/huge_memory.c     |    2 +-
 mm/rmap.c            |    7 ++++---
 3 files changed, 7 insertions(+), 5 deletions(-)

diff -puN include/linux/rmap.h~mm-thp-introduce-separate-ttu-flag-for-thp-freezing include/linux/rmap.h
--- a/include/linux/rmap.h~mm-thp-introduce-separate-ttu-flag-for-thp-freezing
+++ a/include/linux/rmap.h
@@ -93,8 +93,9 @@ enum ttu_flags {
 	TTU_BATCH_FLUSH		= 0x40,	/* Batch TLB flushes where possible
 					 * and caller guarantees they will
 					 * do a final flush if necessary */
-	TTU_RMAP_LOCKED		= 0x80	/* do not grab rmap lock:
+	TTU_RMAP_LOCKED		= 0x80,	/* do not grab rmap lock:
 					 * caller holds it */
+	TTU_SPLIT_FREEZE	= 0x100,		/* freeze pte under splitting thp */
 };
 
 #ifdef CONFIG_MMU
diff -puN mm/huge_memory.c~mm-thp-introduce-separate-ttu-flag-for-thp-freezing mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-introduce-separate-ttu-flag-for-thp-freezing
+++ a/mm/huge_memory.c
@@ -2210,7 +2210,7 @@ static void freeze_page(struct page *pag
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 
 	if (PageAnon(page))
-		ttu_flags |= TTU_MIGRATION;
+		ttu_flags |= TTU_SPLIT_FREEZE;
 
 	unmap_success = try_to_unmap(page, ttu_flags);
 	VM_BUG_ON_PAGE(!unmap_success, page);
diff -puN mm/rmap.c~mm-thp-introduce-separate-ttu-flag-for-thp-freezing mm/rmap.c
--- a/mm/rmap.c~mm-thp-introduce-separate-ttu-flag-for-thp-freezing
+++ a/mm/rmap.c
@@ -1348,7 +1348,7 @@ static bool try_to_unmap_one(struct page
 
 	if (flags & TTU_SPLIT_HUGE_PMD) {
 		split_huge_pmd_address(vma, address,
-				flags & TTU_MIGRATION, page);
+				flags & TTU_SPLIT_FREEZE, page);
 	}
 
 	/*
@@ -1445,7 +1445,7 @@ static bool try_to_unmap_one(struct page
 			 */
 			dec_mm_counter(mm, mm_counter(page));
 		} else if (IS_ENABLED(CONFIG_MIGRATION) &&
-				(flags & TTU_MIGRATION)) {
+				(flags & (TTU_MIGRATION|TTU_SPLIT_FREEZE))) {
 			swp_entry_t entry;
 			pte_t swp_pte;
 			/*
@@ -1575,7 +1575,8 @@ bool try_to_unmap(struct page *page, enu
 	 * locking requirements of exec(), migration skips
 	 * temporary VMAs until after exec() completes.
 	 */
-	if ((flags & TTU_MIGRATION) && !PageKsm(page) && PageAnon(page))
+	if ((flags & (TTU_MIGRATION|TTU_SPLIT_FREEZE))
+	    && !PageKsm(page) && PageAnon(page))
 		rwc.invalid_vma = invalid_migration_vma;
 
 	if (flags & TTU_RMAP_LOCKED)
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are


