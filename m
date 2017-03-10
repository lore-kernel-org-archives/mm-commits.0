From: akpm@linux-foundation.org
Subject: [merged]
 power-mm-update-pte_write-and-pte_wrprotect-to-handle-savedwrite.patch
 removed from -mm tree
Date: Fri, 10 Mar 2017 13:42:43 -0800
Message-ID: <58c31dd3.qMs+GNzr4m5s+ceE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37922 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933047AbdCJVmp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Mar 2017 16:42:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, mgorman@techsingularity.net, mpe@ellerman.id.au, paulus@ozlabs.org, riel@surriel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: power/mm: update pte_write and pte_wrprotect to handle savedwrite
has been removed from the -mm tree.  Its filename was
     power-mm-update-pte_write-and-pte_wrprotect-to-handle-savedwrite.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: power/mm: update pte_write and pte_wrprotect to handle savedwrite

We use pte_write() to check whethwer the pte entry is writable.  This is
mostly used to later mark the pte read only if it is writable.  The other
use of pte_write() is to check whether the pte_entry is writable so that
hardware page table entry can be marked accordingly.  This is used in kvm
where we look at qemu page table entry and update hardware hash page table
for the guest with correct write enable bit.

With the above, for the first usage we should also check the savedwrite
bit so that we can correctly clear the savedwite bit.  For the later, we
add a new variant __pte_write().

With this we can revert write_protect_page part of 595cd8f256d2 ("mm/ksm:
handle protnone saved writes when making page write protect").  But I left
it as it is as an example code for savedwrite check.

Fixes: c137a2757b886 ("powerpc/mm/autonuma: switch ppc64 to its own implementation of saved write")
Link: http://lkml.kernel.org/r/1488203787-17849-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/pgtable.h |   24 +++++++++++++----
 arch/powerpc/kvm/book3s_64_mmu_hv.c          |    2 -
 arch/powerpc/kvm/book3s_hv_rm_mmu.c          |    2 -
 3 files changed, 21 insertions(+), 7 deletions(-)

diff -puN arch/powerpc/include/asm/book3s/64/pgtable.h~power-mm-update-pte_write-and-pte_wrprotect-to-handle-savedwrite arch/powerpc/include/asm/book3s/64/pgtable.h
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~power-mm-update-pte_write-and-pte_wrprotect-to-handle-savedwrite
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -347,7 +347,7 @@ static inline int __ptep_test_and_clear_
 	__r;							\
 })
 
-static inline int pte_write(pte_t pte)
+static inline int __pte_write(pte_t pte)
 {
 	return !!(pte_raw(pte) & cpu_to_be64(_PAGE_WRITE));
 }
@@ -373,11 +373,16 @@ static inline bool pte_savedwrite(pte_t
 }
 #endif
 
+static inline int pte_write(pte_t pte)
+{
+	return __pte_write(pte) || pte_savedwrite(pte);
+}
+
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr,
 				      pte_t *ptep)
 {
-	if (pte_write(*ptep))
+	if (__pte_write(*ptep))
 		pte_update(mm, addr, ptep, _PAGE_WRITE, 0, 0);
 	else if (unlikely(pte_savedwrite(*ptep)))
 		pte_update(mm, addr, ptep, 0, _PAGE_PRIVILEGED, 0);
@@ -390,7 +395,7 @@ static inline void huge_ptep_set_wrprote
 	 * We should not find protnone for hugetlb, but this complete the
 	 * interface.
 	 */
-	if (pte_write(*ptep))
+	if (__pte_write(*ptep))
 		pte_update(mm, addr, ptep, _PAGE_WRITE, 0, 1);
 	else if (unlikely(pte_savedwrite(*ptep)))
 		pte_update(mm, addr, ptep, 0, _PAGE_PRIVILEGED, 1);
@@ -490,7 +495,13 @@ static inline pte_t pte_clear_savedwrite
 	VM_BUG_ON(!pte_protnone(pte));
 	return __pte(pte_val(pte) | _PAGE_PRIVILEGED);
 }
-
+#else
+#define pte_clear_savedwrite pte_clear_savedwrite
+static inline pte_t pte_clear_savedwrite(pte_t pte)
+{
+	VM_WARN_ON(1);
+	return __pte(pte_val(pte) & ~_PAGE_WRITE);
+}
 #endif /* CONFIG_NUMA_BALANCING */
 
 static inline int pte_present(pte_t pte)
@@ -518,6 +529,8 @@ static inline unsigned long pte_pfn(pte_
 /* Generic modifiers for PTE bits */
 static inline pte_t pte_wrprotect(pte_t pte)
 {
+	if (unlikely(pte_savedwrite(pte)))
+		return pte_clear_savedwrite(pte);
 	return __pte(pte_val(pte) & ~_PAGE_WRITE);
 }
 
@@ -938,6 +951,7 @@ static inline int pmd_protnone(pmd_t pmd
 
 #define __HAVE_ARCH_PMD_WRITE
 #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
+#define __pmd_write(pmd)	__pte_write(pmd_pte(pmd))
 #define pmd_savedwrite(pmd)	pte_savedwrite(pmd_pte(pmd))
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -994,7 +1008,7 @@ static inline int __pmdp_test_and_clear_
 static inline void pmdp_set_wrprotect(struct mm_struct *mm, unsigned long addr,
 				      pmd_t *pmdp)
 {
-	if (pmd_write((*pmdp)))
+	if (__pmd_write((*pmdp)))
 		pmd_hugepage_update(mm, addr, pmdp, _PAGE_WRITE, 0);
 	else if (unlikely(pmd_savedwrite(*pmdp)))
 		pmd_hugepage_update(mm, addr, pmdp, 0, _PAGE_PRIVILEGED);
diff -puN arch/powerpc/kvm/book3s_64_mmu_hv.c~power-mm-update-pte_write-and-pte_wrprotect-to-handle-savedwrite arch/powerpc/kvm/book3s_64_mmu_hv.c
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c~power-mm-update-pte_write-and-pte_wrprotect-to-handle-savedwrite
+++ a/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -601,7 +601,7 @@ int kvmppc_book3s_hv_page_fault(struct k
 							 hva, NULL, NULL);
 			if (ptep) {
 				pte = kvmppc_read_update_linux_pte(ptep, 1);
-				if (pte_write(pte))
+				if (__pte_write(pte))
 					write_ok = 1;
 			}
 			local_irq_restore(flags);
diff -puN arch/powerpc/kvm/book3s_hv_rm_mmu.c~power-mm-update-pte_write-and-pte_wrprotect-to-handle-savedwrite arch/powerpc/kvm/book3s_hv_rm_mmu.c
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c~power-mm-update-pte_write-and-pte_wrprotect-to-handle-savedwrite
+++ a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -256,7 +256,7 @@ long kvmppc_do_h_enter(struct kvm *kvm,
 		}
 		pte = kvmppc_read_update_linux_pte(ptep, writing);
 		if (pte_present(pte) && !pte_protnone(pte)) {
-			if (writing && !pte_write(pte))
+			if (writing && !__pte_write(pte))
 				/* make the actual HPTE be read-only */
 				ptel = hpte_make_readonly(ptel);
 			is_ci = pte_ci(pte);
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are


