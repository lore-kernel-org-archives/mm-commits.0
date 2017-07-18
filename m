From: akpm@linux-foundation.org
Subject: + mm-thp-introduce-separate-ttu-flag-for-thp-freezing.patch added to -mm tree
Date: Tue, 18 Jul 2017 15:27:05 -0700
Message-ID: <596e8b39.vAoQCfmf871we4HY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49836 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752387AbdGRW1G (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Jul 2017 18:27:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, dave.hansen@intel.com, dnellans@nvidia.com, hpa@zytor.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, minchan@kernel.org, mingo@elte.hu, tglx@linutronix.de, vbabka@suse.cz, zi.yan@cs.rutgers.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: introduce separate TTU flag for thp freezing
has been added to the -mm tree.  Its filename is
     mm-thp-introduce-separate-ttu-flag-for-thp-freezing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-introduce-separate-ttu-flag-for-thp-freezing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-introduce-separate-ttu-flag-for-thp-freezing.patch

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
@@ -2167,7 +2167,7 @@ static void freeze_page(struct page *pag
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 
 	if (PageAnon(page))
-		ttu_flags |= TTU_MIGRATION;
+		ttu_flags |= TTU_SPLIT_FREEZE;
 
 	unmap_success = try_to_unmap(page, ttu_flags);
 	VM_BUG_ON_PAGE(!unmap_success, page);
diff -puN mm/rmap.c~mm-thp-introduce-separate-ttu-flag-for-thp-freezing mm/rmap.c
--- a/mm/rmap.c~mm-thp-introduce-separate-ttu-flag-for-thp-freezing
+++ a/mm/rmap.c
@@ -1296,7 +1296,7 @@ static bool try_to_unmap_one(struct page
 
 	if (flags & TTU_SPLIT_HUGE_PMD) {
 		split_huge_pmd_address(vma, address,
-				flags & TTU_MIGRATION, page);
+				flags & TTU_SPLIT_FREEZE, page);
 	}
 
 	while (page_vma_mapped_walk(&pvmw)) {
@@ -1385,7 +1385,7 @@ static bool try_to_unmap_one(struct page
 			 */
 			dec_mm_counter(mm, mm_counter(page));
 		} else if (IS_ENABLED(CONFIG_MIGRATION) &&
-				(flags & TTU_MIGRATION)) {
+				(flags & (TTU_MIGRATION|TTU_SPLIT_FREEZE))) {
 			swp_entry_t entry;
 			pte_t swp_pte;
 			/*
@@ -1510,7 +1510,8 @@ bool try_to_unmap(struct page *page, enu
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

mm-mempolicy-add-queue_pages_required.patch
mm-x86-move-_page_swp_soft_dirty-from-bit-7-to-bit-1.patch
mm-thp-introduce-separate-ttu-flag-for-thp-freezing.patch
mm-thp-introduce-config_arch_enable_thp_migration.patch
mm-soft-dirty-keep-soft-dirty-bits-over-thp-migration.patch
mm-mempolicy-mbind-and-migrate_pages-support-thp-migration.patch
mm-migrate-move_pages-supports-thp-migration.patch
mm-memory_hotplug-memory-hotremove-supports-thp-migration.patch

