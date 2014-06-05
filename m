From: akpm@linux-foundation.org
Subject: [merged]
 hugetlb-rename-hugepage_migration_support-to-_supported.patch removed from
 -mm tree
Date: Thu, 05 Jun 2014 12:53:35 -0700
Message-ID: <5390cabf.2V0to2y+mMOfTB+r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56619 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaFETxf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:53:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, n-horiguchi@ah.jp.nec.com

Subject: [merged] hugetlb-rename-hugepage_migration_support-to-_supported.patch removed from -mm tree
To: n-horiguchi@ah.jp.nec.com,hughd@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:53:35 -0700


The patch titled
     Subject: hugetlb: rename hugepage_migration_support() to ..._supported()
has been removed from the -mm tree.  Its filename was
     hugetlb-rename-hugepage_migration_support-to-_supported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: hugetlb: rename hugepage_migration_support() to ..._supported()

We already have a function named hugepages_supported(), and the similar
name hugepage_migration_support() is a bit unconfortable, so let's rename
it hugepage_migration_supported().

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 ++--
 mm/hugetlb.c            |    2 +-
 mm/migrate.c            |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/hugetlb.h~hugetlb-rename-hugepage_migration_support-to-_supported include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-rename-hugepage_migration_support-to-_supported
+++ a/include/linux/hugetlb.h
@@ -397,7 +397,7 @@ static inline pgoff_t basepage_index(str
 
 extern void dissolve_free_huge_pages(unsigned long start_pfn,
 				     unsigned long end_pfn);
-static inline int hugepage_migration_support(struct hstate *h)
+static inline int hugepage_migration_supported(struct hstate *h)
 {
 #ifdef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
 	return huge_page_shift(h) == PMD_SHIFT;
@@ -453,7 +453,7 @@ static inline pgoff_t basepage_index(str
 	return page->index;
 }
 #define dissolve_free_huge_pages(s, e)	do {} while (0)
-#define hugepage_migration_support(h)	0
+#define hugepage_migration_supported(h)	0
 
 static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
 					   struct mm_struct *mm, pte_t *pte)
diff -puN mm/hugetlb.c~hugetlb-rename-hugepage_migration_support-to-_supported mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-rename-hugepage_migration_support-to-_supported
+++ a/mm/hugetlb.c
@@ -544,7 +544,7 @@ static struct page *dequeue_huge_page_no
 /* Movability of hugepages depends on migration support. */
 static inline gfp_t htlb_alloc_mask(struct hstate *h)
 {
-	if (hugepages_treat_as_movable || hugepage_migration_support(h))
+	if (hugepages_treat_as_movable || hugepage_migration_supported(h))
 		return GFP_HIGHUSER_MOVABLE;
 	else
 		return GFP_HIGHUSER;
diff -puN mm/migrate.c~hugetlb-rename-hugepage_migration_support-to-_supported mm/migrate.c
--- a/mm/migrate.c~hugetlb-rename-hugepage_migration_support-to-_supported
+++ a/mm/migrate.c
@@ -1039,7 +1039,7 @@ static int unmap_and_move_huge_page(new_
 	 * tables or check whether the hugepage is pmd-based or not before
 	 * kicking migration.
 	 */
-	if (!hugepage_migration_support(page_hstate(hpage))) {
+	if (!hugepage_migration_supported(page_hstate(hpage))) {
 		putback_active_hugepage(hpage);
 		return -ENOSYS;
 	}
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-update-page-table-walker-core-fix.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch
mm-pagewalkc-move-pte-null-check.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-prom-pid-clear_refs-avoid-split_huge_page.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

