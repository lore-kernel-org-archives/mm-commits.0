From: akpm@linux-foundation.org
Subject: [withdrawn]
 mm-hugetlb-cleanup-and-rename-is_hugetlb_entry_migrationhwpoisoned.patch
 removed from -mm tree
Date: Fri, 30 Jan 2015 13:47:35 -0800
Message-ID: <54cbfbf7.X5TovO6iMgh5eFb3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47261 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763306AbbA3Vrg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Jan 2015 16:47:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, hannes@cmpxchg.org, hughd@google.com, james.hogan@imgtec.com, lcapitulino@redhat.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, mhocko@suse.cz, nacc@linux.vnet.ibm.com, riel@redhat.com, rientjes@google.com, steve.capper@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: cleanup and rename is_hugetlb_entry_(migration|hwpoisoned)()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-cleanup-and-rename-is_hugetlb_entry_migrationhwpoisoned.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/hugetlb: cleanup and rename is_hugetlb_entry_(migration|hwpoisoned)()

non_swap_entry() returns true if a given swp_entry_t is a migration entry
or hwpoisoned entry.  So non_swap_entry() && is_migration_entry() is
identical with just is_migration_entry().  So by removing
non_swap_entry(), we can write is_hugetlb_entry_(migration|hwpoisoned)()
more simply.

And the name is_hugetlb_entry_(migration|hwpoisoned) is lengthy and it's
not predictable from naming convention around pte_* family.  Just
pte_migration() looks better, but these function contains hugetlb specific
(so architecture dependent) huge_pte_none() check, so let's rename them as
huge_pte_(migration|hwpoisoned).

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Steve Capper <steve.capper@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-cleanup-and-rename-is_hugetlb_entry_migrationhwpoisoned mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-cleanup-and-rename-is_hugetlb_entry_migrationhwpoisoned
+++ a/mm/hugetlb.c
@@ -2516,30 +2516,18 @@ static void set_huge_ptep_writable(struc
 		update_mmu_cache(vma, address, ptep);
 }
 
-static int is_hugetlb_entry_migration(pte_t pte)
+static inline int huge_pte_migration(pte_t pte)
 {
-	swp_entry_t swp;
-
 	if (huge_pte_none(pte) || pte_present(pte))
 		return 0;
-	swp = pte_to_swp_entry(pte);
-	if (non_swap_entry(swp) && is_migration_entry(swp))
-		return 1;
-	else
-		return 0;
+	return is_migration_entry(pte_to_swp_entry(pte));
 }
 
-static int is_hugetlb_entry_hwpoisoned(pte_t pte)
+static inline int huge_pte_hwpoisoned(pte_t pte)
 {
-	swp_entry_t swp;
-
 	if (huge_pte_none(pte) || pte_present(pte))
 		return 0;
-	swp = pte_to_swp_entry(pte);
-	if (non_swap_entry(swp) && is_hwpoison_entry(swp))
-		return 1;
-	else
-		return 0;
+	return is_hwpoison_entry(pte_to_swp_entry(pte));
 }
 
 int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
@@ -2583,8 +2571,8 @@ int copy_hugetlb_page_range(struct mm_st
 		entry = huge_ptep_get(src_pte);
 		if (huge_pte_none(entry)) { /* skip none entry */
 			;
-		} else if (unlikely(is_hugetlb_entry_migration(entry) ||
-				    is_hugetlb_entry_hwpoisoned(entry))) {
+		} else if (unlikely(huge_pte_migration(entry) ||
+				    huge_pte_hwpoisoned(entry))) {
 			swp_entry_t swp_entry = pte_to_swp_entry(entry);
 
 			if (is_write_migration_entry(swp_entry) && cow) {
@@ -3169,9 +3157,9 @@ int hugetlb_fault(struct mm_struct *mm,
 	 * a active hugepage in pagecache.
 	 */
 	if (!pte_present(entry)) {
-		if (is_hugetlb_entry_migration(entry))
+		if (huge_pte_migration(entry))
 			need_wait_migration = 1;
-		else if (is_hugetlb_entry_hwpoisoned(entry))
+		else if (huge_pte_hwpoisoned(entry))
 			ret = VM_FAULT_HWPOISON_LARGE |
 				VM_FAULT_SET_HINDEX(hstate_index(h));
 		goto out_mutex;
@@ -3303,8 +3291,8 @@ long follow_hugetlb_page(struct mm_struc
 		 * (in which case hugetlb_fault waits for the migration,) and
 		 * hwpoisoned hugepages (in which case we need to prevent the
 		 * caller from accessing to them.) In order to do this, we use
-		 * here is_swap_pte instead of is_hugetlb_entry_migration and
-		 * is_hugetlb_entry_hwpoisoned. This is because it simply covers
+		 * here is_swap_pte instead of huge_pte_migration and
+		 * huge_pte_hwpoisoned. This is because it simply covers
 		 * both cases, and because we can't follow correct pages
 		 * directly from any kind of swap entries.
 		 */
@@ -3382,11 +3370,11 @@ unsigned long hugetlb_change_protection(
 			continue;
 		}
 		pte = huge_ptep_get(ptep);
-		if (unlikely(is_hugetlb_entry_hwpoisoned(pte))) {
+		if (unlikely(huge_pte_hwpoisoned(pte))) {
 			spin_unlock(ptl);
 			continue;
 		}
-		if (unlikely(is_hugetlb_entry_migration(pte))) {
+		if (unlikely(huge_pte_migration(pte))) {
 			swp_entry_t entry = pte_to_swp_entry(pte);
 
 			if (is_write_migration_entry(entry)) {
@@ -3730,7 +3718,7 @@ retry:
 		if (flags & FOLL_GET)
 			get_page(page);
 	} else {
-		if (is_hugetlb_entry_migration(huge_ptep_get((pte_t *)pmd))) {
+		if (huge_pte_migration(huge_ptep_get((pte_t *)pmd))) {
 			spin_unlock(ptl);
 			__migration_entry_wait(mm, (pte_t *)pmd, ptl);
 			goto retry;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range.patch
mm-add-kpf_zero_page-flag-for-proc-kpageflags.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
proc-pagemap-walk-page-tables-under-pte-lock.patch
mm-pagewalk-remove-pgd_entry-and-pud_entry.patch
pagewalk-improve-vma-handling.patch
pagewalk-add-walk_page_vma.patch
smaps-remove-mem_size_stats-vma-and-use-walk_page_vma.patch
clear_refs-remove-clear_refs_private-vma-and-introduce-clear_refs_test_walk.patch
pagemap-use-walk-vma-instead-of-calling-find_vma.patch
numa_maps-fix-typo-in-gather_hugetbl_stats.patch
numa_maps-remove-numa_maps-vma.patch
memcg-cleanup-preparation-for-page-table-walk.patch
arch-powerpc-mm-subpage-protc-use-walk-vma-and-walk_page_vma.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-pagewalk-fix-misbehavior-of-walk_page_range-for-vmavm_pfnmap-re-pagewalk-improve-vma-handling.patch
mm-proc-pid-clear_refs-avoid-split_huge_page.patch
mincore-apply-page-table-walker-on-do_mincore.patch
mincore-apply-page-table-walker-on-do_mincore-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

