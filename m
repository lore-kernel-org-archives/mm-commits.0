From: akpm@linux-foundation.org
Subject: [merged] powerpc-mm-handle-protnone-ptes-on-fork.patch removed
 from -mm tree
Date: Fri, 10 Mar 2017 13:42:40 -0800
Message-ID: <58c31dd0./bFwRl7e3Y525bJo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37896 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933047AbdCJVmm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Mar 2017 16:42:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, mgorman@techsingularity.net, mpe@ellerman.id.au, paulus@ozlabs.org, riel@surriel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: handle protnone ptes on fork
has been removed from the -mm tree.  Its filename was
     powerpc-mm-handle-protnone-ptes-on-fork.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: powerpc/mm: handle protnone ptes on fork

We need to mark pages of parent process read only on fork.  Numa fault pte
needs a protnone ptes variant with saved write flag set.  On fork we need
to make sure we remove the saved write bit.  Instead of adding the
protnone check in the caller update ptep_set_wrprotect variants to clear
savedwrite bit.

Without this we see random segfaults in application on fork.

Fixes: c137a2757b886 ("powerpc/mm/autonuma: switch ppc64 to its own implementation of saved write")
Link: http://lkml.kernel.org/r/1488203787-17849-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/pgtable.h |   73 +++++++++--------
 1 file changed, 42 insertions(+), 31 deletions(-)

diff -puN arch/powerpc/include/asm/book3s/64/pgtable.h~powerpc-mm-handle-protnone-ptes-on-fork arch/powerpc/include/asm/book3s/64/pgtable.h
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~powerpc-mm-handle-protnone-ptes-on-fork
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -347,23 +347,53 @@ static inline int __ptep_test_and_clear_
 	__r;							\
 })
 
+static inline int pte_write(pte_t pte)
+{
+	return !!(pte_raw(pte) & cpu_to_be64(_PAGE_WRITE));
+}
+
+#ifdef CONFIG_NUMA_BALANCING
+#define pte_savedwrite pte_savedwrite
+static inline bool pte_savedwrite(pte_t pte)
+{
+	/*
+	 * Saved write ptes are prot none ptes that doesn't have
+	 * privileged bit sit. We mark prot none as one which has
+	 * present and pviliged bit set and RWX cleared. To mark
+	 * protnone which used to have _PAGE_WRITE set we clear
+	 * the privileged bit.
+	 */
+	return !(pte_raw(pte) & cpu_to_be64(_PAGE_RWX | _PAGE_PRIVILEGED));
+}
+#else
+#define pte_savedwrite pte_savedwrite
+static inline bool pte_savedwrite(pte_t pte)
+{
+	return false;
+}
+#endif
+
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr,
 				      pte_t *ptep)
 {
-	if ((pte_raw(*ptep) & cpu_to_be64(_PAGE_WRITE)) == 0)
-		return;
-
-	pte_update(mm, addr, ptep, _PAGE_WRITE, 0, 0);
+	if (pte_write(*ptep))
+		pte_update(mm, addr, ptep, _PAGE_WRITE, 0, 0);
+	else if (unlikely(pte_savedwrite(*ptep)))
+		pte_update(mm, addr, ptep, 0, _PAGE_PRIVILEGED, 0);
 }
 
 static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
 					   unsigned long addr, pte_t *ptep)
 {
-	if ((pte_raw(*ptep) & cpu_to_be64(_PAGE_WRITE)) == 0)
-		return;
-
-	pte_update(mm, addr, ptep, _PAGE_WRITE, 0, 1);
+	/*
+	 * We should not find protnone for hugetlb, but this complete the
+	 * interface.
+	 */
+	if (pte_write(*ptep))
+		pte_update(mm, addr, ptep, _PAGE_WRITE, 0, 1);
+	else if (unlikely(pte_savedwrite(*ptep)))
+		pte_update(mm, addr, ptep, 0, _PAGE_PRIVILEGED, 1);
 }
 
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
@@ -397,11 +427,6 @@ static inline void pte_clear(struct mm_s
 	pte_update(mm, addr, ptep, ~0UL, 0, 0);
 }
 
-static inline int pte_write(pte_t pte)
-{
-	return !!(pte_raw(pte) & cpu_to_be64(_PAGE_WRITE));
-}
-
 static inline int pte_dirty(pte_t pte)
 {
 	return !!(pte_raw(pte) & cpu_to_be64(_PAGE_DIRTY));
@@ -466,19 +491,6 @@ static inline pte_t pte_clear_savedwrite
 	return __pte(pte_val(pte) | _PAGE_PRIVILEGED);
 }
 
-#define pte_savedwrite pte_savedwrite
-static inline bool pte_savedwrite(pte_t pte)
-{
-	/*
-	 * Saved write ptes are prot none ptes that doesn't have
-	 * privileged bit sit. We mark prot none as one which has
-	 * present and pviliged bit set and RWX cleared. To mark
-	 * protnone which used to have _PAGE_WRITE set we clear
-	 * the privileged bit.
-	 */
-	VM_BUG_ON(!pte_protnone(pte));
-	return !(pte_raw(pte) & cpu_to_be64(_PAGE_RWX | _PAGE_PRIVILEGED));
-}
 #endif /* CONFIG_NUMA_BALANCING */
 
 static inline int pte_present(pte_t pte)
@@ -982,11 +994,10 @@ static inline int __pmdp_test_and_clear_
 static inline void pmdp_set_wrprotect(struct mm_struct *mm, unsigned long addr,
 				      pmd_t *pmdp)
 {
-
-	if ((pmd_raw(*pmdp) & cpu_to_be64(_PAGE_WRITE)) == 0)
-		return;
