From: akpm@linux-foundation.org
Subject: + openrisc-add-missing-pgtable_page_ctor-dtor-calls.patch added
 to -mm tree
Date: Thu, 10 Oct 2013 13:56:07 -0700
Message-ID: <52571467.0K2nnYaXg6US/+Rx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37684 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904Ab3JJU4I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Oct 2013 16:56:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jonas@southpole.se, kirill.shutemov@linux.intel.com

Subject: + openrisc-add-missing-pgtable_page_ctor-dtor-calls.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,jonas@southpole.se
From: akpm@linux-foundation.org
Date: Thu, 10 Oct 2013 13:56:07 -0700


The patch titled
     Subject: openrisc: add missing pgtable_page_ctor/dtor calls
has been added to the -mm tree.  Its filename is
     openrisc-add-missing-pgtable_page_ctor-dtor-calls.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/openrisc-add-missing-pgtable_page_ctor-dtor-calls.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/openrisc-add-missing-pgtable_page_ctor-dtor-calls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: openrisc: add missing pgtable_page_ctor/dtor calls

It will fix NR_PAGETABLE accounting.  It's also required if the arch is
going ever support split ptl.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jonas Bonn <jonas@southpole.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/openrisc/include/asm/pgalloc.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN arch/openrisc/include/asm/pgalloc.h~openrisc-add-missing-pgtable_page_ctor-dtor-calls arch/openrisc/include/asm/pgalloc.h
--- a/arch/openrisc/include/asm/pgalloc.h~openrisc-add-missing-pgtable_page_ctor-dtor-calls
+++ a/arch/openrisc/include/asm/pgalloc.h
@@ -78,8 +78,13 @@ static inline struct page *pte_alloc_one
 {
 	struct page *pte;
 	pte = alloc_pages(GFP_KERNEL|__GFP_REPEAT, 0);
-	if (pte)
-		clear_page(page_address(pte));
+	if (!pte)
+		return NULL;
+	clear_page(page_address(pte));
+	if (!pgtable_page_ctor(pte)) {
+		__free_page(pte);
+		return NULL;
+	}
 	return pte;
 }
 
@@ -90,6 +95,7 @@ static inline void pte_free_kernel(struc
 
 static inline void pte_free(struct mm_struct *mm, struct page *pte)
 {
+	pgtable_page_dtor(pte);
 	__free_page(pte);
 }
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-huge_memoryc-fix-stale-comments-of-transparent_hugepage_flags.patch
mm-thp-cleanup-mv-alloc_hugepage-to-better-place.patch
mm-thp-khugepaged-add-policy-for-finding-target-node.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
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
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page.patch
thp-mm-locking-tail-page-is-a-bug.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

