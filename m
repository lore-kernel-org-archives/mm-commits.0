From: akpm@linux-foundation.org
Subject: [merged]
 mips-thp-remove-infrastructure-for-handling-splitting-pmds.patch removed
 from -mm tree
Date: Tue, 19 Jan 2016 12:02:11 -0800
Message-ID: <569e9643.h3kcgIaNwS+wOXIC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbcASUCM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:02:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mips, thp: remove infrastructure for handling splitting PMDs
has been removed from the -mm tree.  Its filename was
     mips-thp-remove-infrastructure-for-handling-splitting-pmds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mips, thp: remove infrastructure for handling splitting PMDs

With new refcounting we don't need to mark PMDs splitting. Let's drop
code to handle this.

pmdp_splitting_flush() is not needed too: on splitting PMD we will do
pmdp_clear_flush() + set_pte_at(). pmdp_clear_flush() will do IPI as
needed for fast_gup.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/pgtable-bits.h |   10 ++++------
 arch/mips/include/asm/pgtable.h      |   18 ------------------
 arch/mips/mm/gup.c                   |   13 +------------
 arch/mips/mm/pgtable-64.c            |   14 --------------
 arch/mips/mm/tlbex.c                 |    1 -
 5 files changed, 5 insertions(+), 51 deletions(-)

diff -puN arch/mips/include/asm/pgtable-bits.h~mips-thp-remove-infrastructure-for-handling-splitting-pmds arch/mips/include/asm/pgtable-bits.h
--- a/arch/mips/include/asm/pgtable-bits.h~mips-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/mips/include/asm/pgtable-bits.h
@@ -131,14 +131,12 @@
 /* Huge TLB page */
 #define _PAGE_HUGE_SHIFT	(_PAGE_MODIFIED_SHIFT + 1)
 #define _PAGE_HUGE		(1 << _PAGE_HUGE_SHIFT)
-#define _PAGE_SPLITTING_SHIFT	(_PAGE_HUGE_SHIFT + 1)
-#define _PAGE_SPLITTING		(1 << _PAGE_SPLITTING_SHIFT)
 #endif	/* CONFIG_64BIT && CONFIG_MIPS_HUGE_TLB_SUPPORT */
 
 #if defined(CONFIG_CPU_MIPSR2) || defined(CONFIG_CPU_MIPSR6)
 /* XI - page cannot be executed */
-#ifdef _PAGE_SPLITTING_SHIFT
-#define _PAGE_NO_EXEC_SHIFT	(_PAGE_SPLITTING_SHIFT + 1)
+#ifdef _PAGE_HUGE_SHIFT
+#define _PAGE_NO_EXEC_SHIFT	(_PAGE_HUGE_SHIFT + 1)
 #else
 #define _PAGE_NO_EXEC_SHIFT	(_PAGE_MODIFIED_SHIFT + 1)
 #endif
@@ -153,8 +151,8 @@
 
 #if defined(_PAGE_NO_READ_SHIFT)
 #define _PAGE_GLOBAL_SHIFT	(_PAGE_NO_READ_SHIFT + 1)
-#elif defined(_PAGE_SPLITTING_SHIFT)
-#define _PAGE_GLOBAL_SHIFT	(_PAGE_SPLITTING_SHIFT + 1)
+#elif defined(_PAGE_HUGE_SHIFT)
+#define _PAGE_GLOBAL_SHIFT	(_PAGE_HUGE_SHIFT + 1)
 #else
 #define _PAGE_GLOBAL_SHIFT	(_PAGE_MODIFIED_SHIFT + 1)
 #endif
diff -puN arch/mips/include/asm/pgtable.h~mips-thp-remove-infrastructure-for-handling-splitting-pmds arch/mips/include/asm/pgtable.h
--- a/arch/mips/include/asm/pgtable.h~mips-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/mips/include/asm/pgtable.h
@@ -482,27 +482,9 @@ static inline pmd_t pmd_mkhuge(pmd_t pmd
 	return pmd;
 }
 
-static inline int pmd_trans_splitting(pmd_t pmd)
-{
-	return !!(pmd_val(pmd) & _PAGE_SPLITTING);
-}
-
-static inline pmd_t pmd_mksplitting(pmd_t pmd)
-{
-	pmd_val(pmd) |= _PAGE_SPLITTING;
-
-	return pmd;
-}
-
 extern void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 		       pmd_t *pmdp, pmd_t pmd);
 
-#define __HAVE_ARCH_PMDP_SPLITTING_FLUSH
-/* Extern to avoid header file madness */
-extern void pmdp_splitting_flush(struct vm_area_struct *vma,
-					unsigned long address,
-					pmd_t *pmdp);
-
 #define __HAVE_ARCH_PMD_WRITE
 static inline int pmd_write(pmd_t pmd)
 {
diff -puN arch/mips/mm/gup.c~mips-thp-remove-infrastructure-for-handling-splitting-pmds arch/mips/mm/gup.c
--- a/arch/mips/mm/gup.c~mips-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/mips/mm/gup.c
@@ -107,18 +107,7 @@ static int gup_pmd_range(pud_t pud, unsi
 		pmd_t pmd = *pmdp;
 
 		next = pmd_addr_end(addr, end);
-		/*
-		 * The pmd_trans_splitting() check below explains why
-		 * pmdp_splitting_flush has to flush the tlb, to stop
-		 * this gup-fast code from running while we set the
-		 * splitting bit in the pmd. Returning zero will take
-		 * the slow path that will call wait_split_huge_page()
-		 * if the pmd is still in splitting state. gup-fast
-		 * can't because it has irq disabled and
-		 * wait_split_huge_page() would never return as the
-		 * tlb flush IPI wouldn't run.
-		 */
-		if (pmd_none(pmd) || pmd_trans_splitting(pmd))
+		if (pmd_none(pmd))
 			return 0;
 		if (unlikely(pmd_huge(pmd))) {
 			if (!gup_huge_pmd(pmd, addr, next, write, pages,nr))
diff -puN arch/mips/mm/pgtable-64.c~mips-thp-remove-infrastructure-for-handling-splitting-pmds arch/mips/mm/pgtable-64.c
--- a/arch/mips/mm/pgtable-64.c~mips-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/mips/mm/pgtable-64.c
@@ -62,20 +62,6 @@ void pmd_init(unsigned long addr, unsign
 }
 #endif
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-
-void pmdp_splitting_flush(struct vm_area_struct *vma,
-			 unsigned long address,
-			 pmd_t *pmdp)
-{
-	if (!pmd_trans_splitting(*pmdp)) {
-		pmd_t pmd = pmd_mksplitting(*pmdp);
-		set_pmd_at(vma->vm_mm, address, pmdp, pmd);
-	}
-}
-
-#endif
-
 pmd_t mk_pmd(struct page *page, pgprot_t prot)
 {
 	pmd_t pmd;
diff -puN arch/mips/mm/tlbex.c~mips-thp-remove-infrastructure-for-handling-splitting-pmds arch/mips/mm/tlbex.c
--- a/arch/mips/mm/tlbex.c~mips-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/mips/mm/tlbex.c
@@ -240,7 +240,6 @@ static void output_pgtable_bits_defines(
 	pr_define("_PAGE_MODIFIED_SHIFT %d\n", _PAGE_MODIFIED_SHIFT);
 #ifdef CONFIG_MIPS_HUGE_TLB_SUPPORT
 	pr_define("_PAGE_HUGE_SHIFT %d\n", _PAGE_HUGE_SHIFT);
-	pr_define("_PAGE_SPLITTING_SHIFT %d\n", _PAGE_SPLITTING_SHIFT);
 #endif
 #ifdef CONFIG_CPU_MIPSR2
 	if (cpu_has_rixi) {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
thp-add-debugfs-handle-to-split-all-huge-pages.patch
thp-increase-split_huge_page-success-rate.patch
thp-fix-split_huge_page-after-mremap-of-thp.patch
memblock-fix-section-mismatch.patch
mm-fix-locking-order-in-mm_take_all_locks.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

