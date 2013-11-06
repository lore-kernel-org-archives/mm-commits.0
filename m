From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix.patch removed from -mm tree
Date: Wed, 06 Nov 2013 13:35:40 -0800
Message-ID: <527ab62c.Ib3OI+RB5owIcx7h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39496 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab3KFVfl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Nov 2013 16:35:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com

Subject: [folded-merged] mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 06 Nov 2013 13:35:40 -0800


The patch titled
     Subject: mm: try to detect that page->ptl is in use
has been removed from the -mm tree.  Its filename was
     mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix.patch

This patch was dropped because it was folded into mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: try to detect that page->ptl is in use

prep_new_page() initialize page->private (and therefore page->ptl) with 0.
 Make sure nobody took it in use in between allocation of the page and
page table constructor.

It can happen if arch try to use slab for page table allocation: slab code
uses page->slab_cache and page->first_page (for tail pages), which share
storage with page->ptl.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/split_page_table_lock |    4 ++++
 include/linux/mm.h                     |    9 +++++++++
 2 files changed, 13 insertions(+)

diff -puN Documentation/vm/split_page_table_lock~mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix Documentation/vm/split_page_table_lock
--- a/Documentation/vm/split_page_table_lock~mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix
+++ a/Documentation/vm/split_page_table_lock
@@ -53,6 +53,10 @@ There's no need in special enabling of P
 everything required is done by pgtable_page_ctor() and pgtable_page_dtor(),
 which must be called on PTE table allocation / freeing.
 
+Make sure the architecture doesn't use slab allocator for page table
+allacation: slab uses page->slab_cache and page->first_page for its pages.
+These fields share storage with page->ptl.
+
 PMD split lock only makes sense if you have more than two page table
 levels.
 
diff -puN include/linux/mm.h~mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix include/linux/mm.h
--- a/include/linux/mm.h~mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix
+++ a/include/linux/mm.h
@@ -1346,6 +1346,15 @@ static inline spinlock_t *pte_lockptr(st
 
 static inline bool ptlock_init(struct page *page)
 {
+	/*
+	 * prep_new_page() initialize page->private (and therefore page->ptl)
+	 * with 0. Make sure nobody took it in use in between.
+	 *
+	 * It can happen if arch try to use slab for page table allocation:
+	 * slab code uses page->slab_cache and page->first_page (for tail
+	 * pages), which share storage with page->ptl.
+	 */
+	VM_BUG_ON(page->ptl);
 	if (!ptlock_alloc(page))
 		return false;
 	spin_lock_init(ptlock_ptr(page));
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-huge_memoryc-fix-stale-comments-of-transparent_hugepage_flags.patch
mm-thp-cleanup-mv-alloc_hugepage-to-better-place.patch
mm-thp-khugepaged-add-policy-for-finding-target-node.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
x86-add-missed-pgtable_pmd_page_ctor-dtor-calls-for-preallocated-pmds.patch
cris-fix-potential-null-pointer-dereference.patch
m32r-fix-potential-null-pointer-dereference.patch
xtensa-fix-potential-null-pointer-dereference.patch
mm-allow-pgtable_page_ctor-to-fail.patch
microblaze-add-missing-pgtable_page_ctor-dtor-calls.patch
mn10300-add-missing-pgtable_page_ctor-dtor-calls.patch
openrisc-add-missing-pgtable_page_ctor-dtor-calls.patch
alpha-handle-pgtable_page_ctor-fail.patch
arc-handle-pgtable_page_ctor-fail.patch
arm-handle-pgtable_page_ctor-fail.patch
arm64-handle-pgtable_page_ctor-fail.patch
avr32-handle-pgtable_page_ctor-fail.patch
cris-handle-pgtable_page_ctor-fail.patch
frv-handle-pgtable_page_ctor-fail.patch
hexagon-handle-pgtable_page_ctor-fail.patch
ia64-handle-pgtable_page_ctor-fail.patch
m32r-handle-pgtable_page_ctor-fail.patch
m68k-handle-pgtable_page_ctor-fail.patch
m68k-handle-pgtable_page_ctor-fail-fix.patch
m68k-handle-pgtable_page_ctor-fail-fix-fix.patch
metag-handle-pgtable_page_ctor-fail.patch
mips-handle-pgtable_page_ctor-fail.patch
parisc-handle-pgtable_page_ctor-fail.patch
powerpc-handle-pgtable_page_ctor-fail.patch
s390-handle-pgtable_page_ctor-fail.patch
score-handle-pgtable_page_ctor-fail.patch
sh-handle-pgtable_page_ctor-fail.patch
sparc-handle-pgtable_page_ctor-fail.patch
tile-handle-pgtable_page_ctor-fail.patch
um-handle-pgtable_page_ctor-fail.patch
unicore32-handle-pgtable_page_ctor-fail.patch
x86-handle-pgtable_page_ctor-fail.patch
xtensa-handle-pgtable_page_ctor-fail.patch
iommu-arm-smmu-handle-pgtable_page_ctor-fail.patch
xtensa-use-buddy-allocator-for-pte-table.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix.patch
mm-create-a-separate-slab-for-page-ptl-allocation.patch

