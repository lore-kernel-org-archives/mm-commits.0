From: akpm@linux-foundation.org
Subject: [folded-merged] m68k-handle-pgtable_page_ctor-fail-fix-fix.patch
 removed from -mm tree
Date: Thu, 14 Nov 2013 14:22:10 -0800
Message-ID: <52854d12.5iLtvTuzp3na8ExI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52534 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757967Ab3KNWWL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Nov 2013 17:22:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, geert@linux-m68k.org, kirill.shutemov@linux.intel.com

Subject: [folded-merged] m68k-handle-pgtable_page_ctor-fail-fix-fix.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,geert@linux-m68k.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 14 Nov 2013 14:22:10 -0800


The patch titled
     Subject: m68k-handle-pgtable_page_ctor-fail-fix-fix
has been removed from the -mm tree.  Its filename was
     m68k-handle-pgtable_page_ctor-fail-fix-fix.patch

This patch was dropped because it was folded into m68k-handle-pgtable_page_ctor-fail.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: m68k-handle-pgtable_page_ctor-fail-fix-fix

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/mcf_pgalloc.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/m68k/include/asm/mcf_pgalloc.h~m68k-handle-pgtable_page_ctor-fail-fix-fix arch/m68k/include/asm/mcf_pgalloc.h
--- a/arch/m68k/include/asm/mcf_pgalloc.h~m68k-handle-pgtable_page_ctor-fail-fix-fix
+++ a/arch/m68k/include/asm/mcf_pgalloc.h
@@ -56,6 +56,10 @@ static inline struct page *pte_alloc_one
 
 	if (!page)
 		return NULL;
+	if (!pgtable_page_ctor(page)) {
+		__free_page(page);
+		return NULL;
+	}
 
 	pte = kmap(page);
 	if (pte) {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-avoid-increase-sizeofstruct-page-due-to-split-page-table-lock.patch
mm-rename-use_split_ptlocks-to-use_split_pte_ptlocks.patch
mm-convert-mm-nr_ptes-to-atomic_long_t.patch
mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch
mm-thp-change-pmd_trans_huge_lock-to-return-taken-lock.patch
mm-thp-move-ptl-taking-inside-page_check_address_pmd.patch
mm-thp-do-not-access-mm-pmd_huge_pte-directly.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
mm-convert-the-rest-to-new-page-table-lock-api.patch
mm-implement-split-page-table-lock-for-pmd-level.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch
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
xtensa-use-buddy-allocator-for-pte-table.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page.patch
mm-properly-separate-the-bloated-ptl-from-the-regular-case.patch
mm-create-a-separate-slab-for-page-ptl-allocation.patch
lockref-use-bloated_spinlocks-to-avoid-explicit-config-dependencies.patch

