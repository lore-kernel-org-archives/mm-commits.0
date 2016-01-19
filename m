From: akpm@linux-foundation.org
Subject: [merged]
 powerpc-thp-remove-infrastructure-for-handling-splitting-pmds.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:02:14 -0800
Message-ID: <569e9646.r9KS8pDSidetfVYs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865AbcASUCP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:02:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc, thp: remove infrastructure for handling splitting PMDs
has been removed from the -mm tree.  Its filename was
     powerpc-thp-remove-infrastructure-for-handling-splitting-pmds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: powerpc, thp: remove infrastructure for handling splitting PMDs

With new refcounting we don't need to mark PMDs splitting. Let's drop
code to handle this.

pmdp_splitting_flush() is not needed too: on splitting PMD we will do
pmdp_clear_flush() + set_pte_at(). pmdp_clear_flush() will do IPI as
needed for fast_gup.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
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

 arch/powerpc/include/asm/book3s/64/hash-64k.h |   12 ---
 arch/powerpc/include/asm/book3s/64/hash.h     |   10 ---
 arch/powerpc/include/asm/book3s/64/pgtable.h  |    4 -
 arch/powerpc/mm/hugepage-hash64.c             |    3 
 arch/powerpc/mm/hugetlbpage.c                 |    4 -
 arch/powerpc/mm/pgtable_64.c                  |   49 ----------------
 6 files changed, 2 insertions(+), 80 deletions(-)

diff -puN arch/powerpc/include/asm/book3s/64/hash-64k.h~powerpc-thp-remove-infrastructure-for-handling-splitting-pmds arch/powerpc/include/asm/book3s/64/hash-64k.h
--- a/arch/powerpc/include/asm/book3s/64/hash-64k.h~powerpc-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/powerpc/include/asm/book3s/64/hash-64k.h
@@ -256,13 +256,6 @@ static inline int pmd_trans_huge(pmd_t p
 		  (_PAGE_PTE | _PAGE_THP_HUGE));
 }
 
-static inline int pmd_trans_splitting(pmd_t pmd)
-{
-	if (pmd_trans_huge(pmd))
-		return pmd_val(pmd) & _PAGE_SPLITTING;
-	return 0;
-}
-
 static inline int pmd_large(pmd_t pmd)
 {
 	return !!(pmd_val(pmd) & _PAGE_PTE);
@@ -273,11 +266,6 @@ static inline pmd_t pmd_mknotpresent(pmd
 	return __pmd(pmd_val(pmd) & ~_PAGE_PRESENT);
 }
 
-static inline pmd_t pmd_mksplitting(pmd_t pmd)
-{
-	return __pmd(pmd_val(pmd) | _PAGE_SPLITTING);
-}
-
 #define __HAVE_ARCH_PMD_SAME
 static inline int pmd_same(pmd_t pmd_a, pmd_t pmd_b)
 {
diff -puN arch/powerpc/include/asm/book3s/64/hash.h~powerpc-thp-remove-infrastructure-for-handling-splitting-pmds arch/powerpc/include/asm/book3s/64/hash.h
--- a/arch/powerpc/include/asm/book3s/64/hash.h~powerpc-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/powerpc/include/asm/book3s/64/hash.h
@@ -41,11 +41,6 @@
 #endif
 
 /*
- * THP pages can't be special. So use the _PAGE_SPECIAL
- */
-#define _PAGE_SPLITTING _PAGE_SPECIAL
-
-/*
  * We need to differentiate between explicit huge page and THP huge
  * page, since THP huge page also need to track real subpage details
  */
@@ -54,9 +49,8 @@
 /*
  * set of bits not changed in pmd_modify.
  */
-#define _HPAGE_CHG_MASK (PTE_RPN_MASK | _PAGE_HPTEFLAGS |		\
-			 _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_SPLITTING | \
-			 _PAGE_THP_HUGE | _PAGE_PTE | _PAGE_SOFT_DIRTY)
+#define _HPAGE_CHG_MASK (PTE_RPN_MASK | _PAGE_HPTEFLAGS | _PAGE_DIRTY | \
+			 _PAGE_ACCESSED | _PAGE_THP_HUGE)
 
 #ifdef CONFIG_PPC_64K_PAGES
 #include <asm/book3s/64/hash-64k.h>
diff -puN arch/powerpc/include/asm/book3s/64/pgtable.h~powerpc-thp-remove-infrastructure-for-handling-splitting-pmds arch/powerpc/include/asm/book3s/64/pgtable.h
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~powerpc-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -266,10 +266,6 @@ extern int pmdp_clear_flush_young(struct
 extern pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 				     unsigned long addr, pmd_t *pmdp);
 
-#define __HAVE_ARCH_PMDP_SPLITTING_FLUSH
-extern void pmdp_splitting_flush(struct vm_area_struct *vma,
-				 unsigned long address, pmd_t *pmdp);
-
 extern pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
 				 unsigned long address, pmd_t *pmdp);
 #define pmdp_collapse_flush pmdp_collapse_flush
diff -puN arch/powerpc/mm/hugepage-hash64.c~powerpc-thp-remove-infrastructure-for-handling-splitting-pmds arch/powerpc/mm/hugepage-hash64.c
--- a/arch/powerpc/mm/hugepage-hash64.c~powerpc-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/powerpc/mm/hugepage-hash64.c
@@ -39,9 +39,6 @@ int __hash_page_thp(unsigned long ea, un
 		/* If PMD busy, retry the access */
 		if (unlikely(old_pmd & _PAGE_BUSY))
 			return 0;
-		/* If PMD is trans splitting retry the access */
-		if (unlikely(old_pmd & _PAGE_SPLITTING))
-			return 0;
 		/* If PMD permissions don't match, take page fault */
 		if (unlikely(access & ~old_pmd))
 			return 1;
diff -puN arch/powerpc/mm/hugetlbpage.c~powerpc-thp-remove-infrastructure-for-handling-splitting-pmds arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~powerpc-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -958,10 +958,6 @@ pte_t *__find_linux_pte_or_hugepte(pgd_t
 			/*
 			 * A hugepage collapse is captured by pmd_none, because
 			 * it mark the pmd none and do a hpte invalidate.
-			 *
-			 * We don't worry about pmd_trans_splitting here, The
-			 * caller if it needs to handle the splitting case
-			 * should check for that.
 			 */
 			if (pmd_none(pmd))
 				return NULL;
diff -puN arch/powerpc/mm/pgtable_64.c~powerpc-thp-remove-infrastructure-for-handling-splitting-pmds arch/powerpc/mm/pgtable_64.c
--- a/arch/powerpc/mm/pgtable_64.c~powerpc-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/powerpc/mm/pgtable_64.c
@@ -604,55 +604,6 @@ int pmdp_clear_flush_young(struct vm_are
 }
 
 /*
- * We mark the pmd splitting and invalidate all the hpte
- * entries for this hugepage.
- */
-void pmdp_splitting_flush(struct vm_area_struct *vma,
-			  unsigned long address, pmd_t *pmdp)
-{
-	unsigned long old, tmp;
-
-	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
-
-#ifdef CONFIG_DEBUG_VM
-	WARN_ON(!pmd_trans_huge(*pmdp));
-	assert_spin_locked(&vma->vm_mm->page_table_lock);
-#endif
-
-#ifdef PTE_ATOMIC_UPDATES
-
-	__asm__ __volatile__(
-	"1:	ldarx	%0,0,%3\n\
-		andi.	%1,%0,%6\n\
-		bne-	1b \n\
-		oris	%1,%0,%4@h \n\
-		stdcx.	%1,0,%3 \n\
-		bne-	1b"
-	: "=&r" (old), "=&r" (tmp), "=m" (*pmdp)
-	: "r" (pmdp), "i" (_PAGE_SPLITTING), "m" (*pmdp), "i" (_PAGE_BUSY)
-	: "cc" );
-#else
-	old = pmd_val(*pmdp);
-	*pmdp = __pmd(old | _PAGE_SPLITTING);
-#endif
-	/*
-	 * If we didn't had the splitting flag set, go and flush the
-	 * HPTE entries.
-	 */
-	trace_hugepage_splitting(address, old);
-	if (!(old & _PAGE_SPLITTING)) {
-		/* We need to flush the hpte */
-		if (old & _PAGE_HASHPTE)
-			hpte_do_hugepage_flush(vma->vm_mm, address, pmdp, old);
-	}
-	/*
-	 * This ensures that generic code that rely on IRQ disabling
-	 * to prevent a parallel THP split work as expected.
-	 */
-	kick_all_cpus_sync();
-}
