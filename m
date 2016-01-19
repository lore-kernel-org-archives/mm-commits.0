From: akpm@linux-foundation.org
Subject: [merged]
 s390-thp-remove-infrastructure-for-handling-splitting-pmds.patch removed
 from -mm tree
Date: Tue, 19 Jan 2016 12:02:17 -0800
Message-ID: <569e9649.zLuIj4NbKX7gkFAL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42865 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088AbcASUCS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:02:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: s390, thp: remove infrastructure for handling splitting PMDs
has been removed from the -mm tree.  Its filename was
     s390-thp-remove-infrastructure-for-handling-splitting-pmds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: s390, thp: remove infrastructure for handling splitting PMDs

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

 arch/s390/include/asm/pgtable.h |   16 +---------------
 arch/s390/mm/gup.c              |   11 +----------
 arch/s390/mm/pgtable.c          |   16 ----------------
 3 files changed, 2 insertions(+), 41 deletions(-)

diff -puN arch/s390/include/asm/pgtable.h~s390-thp-remove-infrastructure-for-handling-splitting-pmds arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~s390-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/s390/include/asm/pgtable.h
@@ -286,7 +286,6 @@ static inline int is_module_addr(void *a
 
 #define _SEGMENT_ENTRY_DIRTY	0x2000	/* SW segment dirty bit */
 #define _SEGMENT_ENTRY_YOUNG	0x1000	/* SW segment young bit */
-#define _SEGMENT_ENTRY_SPLIT	0x0800	/* THP splitting bit */
 #define _SEGMENT_ENTRY_LARGE	0x0400	/* STE-format control, large page */
 #define _SEGMENT_ENTRY_READ	0x0002	/* SW segment read bit */
 #define _SEGMENT_ENTRY_WRITE	0x0001	/* SW segment write bit */
@@ -318,8 +317,6 @@ static inline int is_module_addr(void *a
  * SW-bits: y young, d dirty, r read, w write
  */
 
-#define _SEGMENT_ENTRY_SPLIT_BIT 11	/* THP splitting bit number */
-
 /* Page status table bits for virtualization */
 #define PGSTE_ACC_BITS	0xf000000000000000UL
 #define PGSTE_FP_BIT	0x0800000000000000UL
@@ -523,10 +520,6 @@ static inline int pmd_bad(pmd_t pmd)
 	return (pmd_val(pmd) & ~_SEGMENT_ENTRY_BITS) != 0;
 }
 
-#define __HAVE_ARCH_PMDP_SPLITTING_FLUSH
-extern void pmdp_splitting_flush(struct vm_area_struct *vma,
-				 unsigned long addr, pmd_t *pmdp);
-
 #define  __HAVE_ARCH_PMDP_SET_ACCESS_FLAGS
 extern int pmdp_set_access_flags(struct vm_area_struct *vma,
 				 unsigned long address, pmd_t *pmdp,
@@ -1424,8 +1417,7 @@ static inline pmd_t pmd_modify(pmd_t pmd
 	if (pmd_large(pmd)) {
 		pmd_val(pmd) &= _SEGMENT_ENTRY_ORIGIN_LARGE |
 			_SEGMENT_ENTRY_DIRTY | _SEGMENT_ENTRY_YOUNG |
-			_SEGMENT_ENTRY_LARGE | _SEGMENT_ENTRY_SPLIT |
-			_SEGMENT_ENTRY_SOFT_DIRTY;
+			_SEGMENT_ENTRY_LARGE | _SEGMENT_ENTRY_SOFT_DIRTY;
 		pmd_val(pmd) |= massage_pgprot_pmd(newprot);
 		if (!(pmd_val(pmd) & _SEGMENT_ENTRY_DIRTY))
 			pmd_val(pmd) |= _SEGMENT_ENTRY_PROTECT;
@@ -1533,12 +1525,6 @@ extern void pgtable_trans_huge_deposit(s
 #define __HAVE_ARCH_PGTABLE_WITHDRAW
 extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
 
-static inline int pmd_trans_splitting(pmd_t pmd)
-{
-	return (pmd_val(pmd) & _SEGMENT_ENTRY_LARGE) &&
-		(pmd_val(pmd) & _SEGMENT_ENTRY_SPLIT);
-}
-
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 			      pmd_t *pmdp, pmd_t entry)
 {
diff -puN arch/s390/mm/gup.c~s390-thp-remove-infrastructure-for-handling-splitting-pmds arch/s390/mm/gup.c
--- a/arch/s390/mm/gup.c~s390-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/s390/mm/gup.c
@@ -105,16 +105,7 @@ static inline int gup_pmd_range(pud_t *p
 		pmd = *pmdp;
 		barrier();
 		next = pmd_addr_end(addr, end);
-		/*
-		 * The pmd_trans_splitting() check below explains why
-		 * pmdp_splitting_flush() has to serialize with
-		 * smp_call_function() against our disabled IRQs, to stop
-		 * this gup-fast code from running while we set the
-		 * splitting bit in the pmd. Returning zero will take
-		 * the slow path that will call wait_split_huge_page()
-		 * if the pmd is still in splitting state.
-		 */
-		if (pmd_none(pmd) || pmd_trans_splitting(pmd))
+		if (pmd_none(pmd))
 			return 0;
 		if (unlikely(pmd_large(pmd))) {
 			/*
diff -puN arch/s390/mm/pgtable.c~s390-thp-remove-infrastructure-for-handling-splitting-pmds arch/s390/mm/pgtable.c
--- a/arch/s390/mm/pgtable.c~s390-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/s390/mm/pgtable.c
@@ -1305,22 +1305,6 @@ int pmdp_set_access_flags(struct vm_area
 	return 1;
 }
 
-static void pmdp_splitting_flush_sync(void *arg)
-{
-	/* Simply deliver the interrupt */
-}
-
-void pmdp_splitting_flush(struct vm_area_struct *vma, unsigned long address,
-			  pmd_t *pmdp)
-{
-	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
-	if (!test_and_set_bit(_SEGMENT_ENTRY_SPLIT_BIT,
-			      (unsigned long *) pmdp)) {
-		/* need to serialize against gup-fast (IRQ disabled) */
-		smp_call_function(pmdp_splitting_flush_sync, NULL, 1);
-	}
-}
