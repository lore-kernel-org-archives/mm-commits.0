From: akpm@linux-foundation.org
Subject: [merged]
 mm-move-vma_is_anonymous-check-within-pmd_move_must_withdraw.patch removed
 from -mm tree
Date: Wed, 14 Dec 2016 11:26:12 -0800
Message-ID: <58519cd4.FfXSo8Oq0/KzVusj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45400 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756632AbcLNT0b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:26:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, bsingharora@gmail.com, kirill.shutemov@linux.intel.com, mikey@neuling.org, mpe@ellerman.id.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move vma_is_anonymous check within pmd_move_must_withdraw
has been removed from the -mm tree.  Its filename was
     mm-move-vma_is_anonymous-check-within-pmd_move_must_withdraw.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm: move vma_is_anonymous check within pmd_move_must_withdraw

Independent of whether the vma is for anonymous memory, some arches like
ppc64 would like to override pmd_move_must_withdraw().  One option is to
encapsulate the vma_is_anonymous() check for general architectures inside
pmd_move_must_withdraw() so that is always called and architectures that
need unconditional overriding can override this function.  ppc64 needs to
override the function when the MMU is configured to use hash PTE's.

[bsingharora@gmail.com: reworked changelog]
Link: http://lkml.kernel.org/r/20161113150025.17942-1-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/pgtable.h |    3 +-
 include/asm-generic/pgtable.h                |   12 -----------
 mm/huge_memory.c                             |   18 +++++++++++++++--
 3 files changed, 18 insertions(+), 15 deletions(-)

diff -puN arch/powerpc/include/asm/book3s/64/pgtable.h~mm-move-vma_is_anonymous-check-within-pmd_move_must_withdraw arch/powerpc/include/asm/book3s/64/pgtable.h
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~mm-move-vma_is_anonymous-check-within-pmd_move_must_withdraw
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1009,7 +1009,8 @@ static inline void pmdp_huge_split_prepa
 #define pmd_move_must_withdraw pmd_move_must_withdraw
 struct spinlock;
 static inline int pmd_move_must_withdraw(struct spinlock *new_pmd_ptl,
-					 struct spinlock *old_pmd_ptl)
+					 struct spinlock *old_pmd_ptl,
+					 struct vm_area_struct *vma)
 {
 	if (radix_enabled())
 		return false;
diff -puN include/asm-generic/pgtable.h~mm-move-vma_is_anonymous-check-within-pmd_move_must_withdraw include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-move-vma_is_anonymous-check-within-pmd_move_must_withdraw
+++ a/include/asm-generic/pgtable.h
@@ -652,18 +652,6 @@ static inline pmd_t pmd_read_atomic(pmd_
 }
 #endif
 
-#ifndef pmd_move_must_withdraw
-static inline int pmd_move_must_withdraw(spinlock_t *new_pmd_ptl,
-					 spinlock_t *old_pmd_ptl)
-{
-	/*
-	 * With split pmd lock we also need to move preallocated
-	 * PTE page table if new_pmd is on different PMD page table.
-	 */
-	return new_pmd_ptl != old_pmd_ptl;
-}
-#endif
-
 /*
  * This function is meant to be used by sites walking pagetables with
  * the mmap_sem hold in read mode to protect against MADV_DONTNEED and
diff -puN mm/huge_memory.c~mm-move-vma_is_anonymous-check-within-pmd_move_must_withdraw mm/huge_memory.c
--- a/mm/huge_memory.c~mm-move-vma_is_anonymous-check-within-pmd_move_must_withdraw
+++ a/mm/huge_memory.c
@@ -1429,6 +1429,21 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 	return 1;
 }
 
+#ifndef pmd_move_must_withdraw
+static inline int pmd_move_must_withdraw(spinlock_t *new_pmd_ptl,
+					 spinlock_t *old_pmd_ptl,
+					 struct vm_area_struct *vma)
+{
+	/*
+	 * With split pmd lock we also need to move preallocated
+	 * PTE page table if new_pmd is on different PMD page table.
+	 *
+	 * We also don't deposit and withdraw tables for file pages.
+	 */
+	return (new_pmd_ptl != old_pmd_ptl) && vma_is_anonymous(vma);
+}
+#endif
+
 bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 		  unsigned long new_addr, unsigned long old_end,
 		  pmd_t *old_pmd, pmd_t *new_pmd, bool *need_flush)
@@ -1466,8 +1481,7 @@ bool move_huge_pmd(struct vm_area_struct
 			force_flush = true;
 		VM_BUG_ON(!pmd_none(*new_pmd));
 
-		if (pmd_move_must_withdraw(new_ptl, old_ptl) &&
-				vma_is_anonymous(vma)) {
+		if (pmd_move_must_withdraw(new_ptl, old_ptl, vma)) {
 			pgtable_t pgtable;
 			pgtable = pgtable_trans_huge_withdraw(mm, old_pmd);
 			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are


