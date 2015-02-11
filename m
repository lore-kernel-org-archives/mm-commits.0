From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-account-pmd-page-tables-to-the-process-fix-3.patch removed from -mm tree
Date: Wed, 11 Feb 2015 15:14:55 -0800
Message-ID: <54dbe26f.ukSTK4/pH7Iy4fur%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43139 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbbBKXO4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 18:14:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, pat-lkml@erley.org, sedat.dilek@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix race on pmd accounting
has been removed from the -mm tree.  Its filename was
     mm-account-pmd-page-tables-to-the-process-fix-3.patch

This patch was dropped because it was folded into mm-account-pmd-page-tables-to-the-process.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: fix race on pmd accounting

Do not account the pmd table to the process if other thread allocated it
under us.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Reported-by: Pat Erley <pat-lkml@erley.org>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN mm/memory.c~mm-account-pmd-page-tables-to-the-process-fix-3 mm/memory.c
--- a/mm/memory.c~mm-account-pmd-page-tables-to-the-process-fix-3
+++ a/mm/memory.c
@@ -3326,17 +3326,18 @@ int __pmd_alloc(struct mm_struct *mm, pu
 	smp_wmb(); /* See comment in __pte_alloc */
 
 	spin_lock(&mm->page_table_lock);
-	mm_inc_nr_pmds(mm);
 #ifndef __ARCH_HAS_4LEVEL_HACK
-	if (pud_present(*pud))		/* Another has populated it */
-		pmd_free(mm, new);
-	else
+	if (!pud_present(*pud)) {
+		mm_inc_nr_pmds(mm);
 		pud_populate(mm, pud, new);
-#else
-	if (pgd_present(*pud))		/* Another has populated it */
+	} else	/* Another has populated it */
 		pmd_free(mm, new);
-	else
+#else
+	if (!pgd_present(*pud)) {
+		mm_inc_nr_pmds(mm);
 		pgd_populate(mm, pud, new);
+	} else /* Another has populated it */
+		pmd_free(mm, new);
 #endif /* __ARCH_HAS_4LEVEL_HACK */
 	spin_unlock(&mm->page_table_lock);
 	return 0;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
mm-add-vm_bug_on_page-for-page_mapcount.patch
sparc32-fix-broken-set_pte.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
mm-page_allocc-drop-dead-destroy_compound_page.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages.patch
microblaze-define-__pagetable_pmd_folded.patch
mm-make-first_user_address-unsigned-long-on-all-archs.patch
mm-asm-generic-define-pud_shift-in-asm-generic-4level-fixuph.patch
arm-define-__pagetable_pmd_folded-for-lpae.patch
mm-account-pmd-page-tables-to-the-process.patch
mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm.patch
mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm-fix-2.patch
mm-thp-allocate-transparent-hugepages-on-local-node.patch
mm-thp-allocate-transparent-hugepages-on-local-node-fix.patch
mm-mempolicy-merge-alloc_hugepage_vma-to-alloc_pages_vma.patch
mm-gup-add-get_user_pages_locked-and-get_user_pages_unlocked.patch
mm-gup-add-__get_user_pages_unlocked-to-customize-gup_flags.patch
mm-gup-use-get_user_pages_unlocked-within-get_user_pages_fast.patch
mm-gup-use-get_user_pages_unlocked.patch
mm-gup-kvm-use-get_user_pages_unlocked.patch
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
mm-proc-pid-clear_refs-avoid-split_huge_page.patch
mincore-apply-page-table-walker-on-do_mincore.patch
mm-when-stealing-freepages-also-take-pages-created-by-splitting-buddy-page.patch
mm-always-steal-split-buddies-in-fallback-allocations.patch
mm-more-aggressive-page-stealing-for-unmovable-allocations.patch
mm-incorporate-read-only-pages-into-transparent-huge-pages.patch

