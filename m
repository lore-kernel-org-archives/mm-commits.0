From: akpm@linux-foundation.org
Subject: [merged]
 arm-thp-remove-infrastructure-for-handling-splitting-pmds.patch removed
 from -mm tree
Date: Tue, 19 Jan 2016 12:02:08 -0800
Message-ID: <569e9640.B/gu9Lg56R5FklNw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42824 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865AbcASUCJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:02:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, arnd@arndb.de, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: arm, thp: remove infrastructure for handling splitting PMDs
has been removed from the -mm tree.  Its filename was
     arm-thp-remove-infrastructure-for-handling-splitting-pmds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: arm, thp: remove infrastructure for handling splitting PMDs

With new refcounting we don't need to mark PMDs splitting. Let's drop
code to handle this.

pmdp_splitting_flush() is not needed too: on splitting PMD we will do
pmdp_clear_flush() + set_pte_at(). pmdp_clear_flush() will do IPI as
needed for fast_gup.

[arnd@arndb.de: fix unterminated ifdef in header file]
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable-3level.h |    9 ---------
 arch/arm/lib/uaccess_with_memcpy.c    |    5 ++---
 arch/arm/mm/flush.c                   |   15 ---------------
 3 files changed, 2 insertions(+), 27 deletions(-)

diff -puN arch/arm/include/asm/pgtable-3level.h~arm-thp-remove-infrastructure-for-handling-splitting-pmds arch/arm/include/asm/pgtable-3level.h
--- a/arch/arm/include/asm/pgtable-3level.h~arm-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -88,7 +88,6 @@
 
 #define L_PMD_SECT_VALID	(_AT(pmdval_t, 1) << 0)
 #define L_PMD_SECT_DIRTY	(_AT(pmdval_t, 1) << 55)
-#define L_PMD_SECT_SPLITTING	(_AT(pmdval_t, 1) << 56)
 #define L_PMD_SECT_NONE		(_AT(pmdval_t, 1) << 57)
 #define L_PMD_SECT_RDONLY	(_AT(pteval_t, 1) << 58)
 
@@ -232,13 +231,6 @@ static inline pte_t pte_mkspecial(pte_t
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define pmd_trans_huge(pmd)	(pmd_val(pmd) && !pmd_table(pmd))
-#define pmd_trans_splitting(pmd) (pmd_isset((pmd), L_PMD_SECT_SPLITTING))
-
-#ifdef CONFIG_HAVE_RCU_TABLE_FREE
-#define __HAVE_ARCH_PMDP_SPLITTING_FLUSH
-void pmdp_splitting_flush(struct vm_area_struct *vma, unsigned long address,
-			  pmd_t *pmdp);
-#endif
 #endif
 
 #define PMD_BIT_FUNC(fn,op) \
@@ -246,7 +238,6 @@ static inline pmd_t pmd_##fn(pmd_t pmd)
 
 PMD_BIT_FUNC(wrprotect,	|= L_PMD_SECT_RDONLY);
 PMD_BIT_FUNC(mkold,	&= ~PMD_SECT_AF);
-PMD_BIT_FUNC(mksplitting, |= L_PMD_SECT_SPLITTING);
 PMD_BIT_FUNC(mkwrite,   &= ~L_PMD_SECT_RDONLY);
 PMD_BIT_FUNC(mkdirty,   |= L_PMD_SECT_DIRTY);
 PMD_BIT_FUNC(mkyoung,   |= PMD_SECT_AF);
diff -puN arch/arm/lib/uaccess_with_memcpy.c~arm-thp-remove-infrastructure-for-handling-splitting-pmds arch/arm/lib/uaccess_with_memcpy.c
--- a/arch/arm/lib/uaccess_with_memcpy.c~arm-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/arm/lib/uaccess_with_memcpy.c
@@ -52,14 +52,13 @@ pin_page_for_write(const void __user *_a
 	 *
 	 * Lock the page table for the destination and check
 	 * to see that it's still huge and whether or not we will
-	 * need to fault on write, or if we have a splitting THP.
+	 * need to fault on write.
 	 */
 	if (unlikely(pmd_thp_or_huge(*pmd))) {
 		ptl = &current->mm->page_table_lock;
 		spin_lock(ptl);
 		if (unlikely(!pmd_thp_or_huge(*pmd)
-			|| pmd_hugewillfault(*pmd)
-			|| pmd_trans_splitting(*pmd))) {
+			|| pmd_hugewillfault(*pmd))) {
 			spin_unlock(ptl);
 			return 0;
 		}
diff -puN arch/arm/mm/flush.c~arm-thp-remove-infrastructure-for-handling-splitting-pmds arch/arm/mm/flush.c
--- a/arch/arm/mm/flush.c~arm-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/arm/mm/flush.c
@@ -415,18 +415,3 @@ void __flush_anon_page(struct vm_area_st
 	 */
 	__cpuc_flush_dcache_area(page_address(page), PAGE_SIZE);
 }
-
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-#ifdef CONFIG_HAVE_RCU_TABLE_FREE
-void pmdp_splitting_flush(struct vm_area_struct *vma, unsigned long address,
-			  pmd_t *pmdp)
-{
-	pmd_t pmd = pmd_mksplitting(*pmdp);
-	VM_BUG_ON(address & ~PMD_MASK);
-	set_pmd_at(vma->vm_mm, address, pmdp, pmd);
