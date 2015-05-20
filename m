From: akpm@linux-foundation.org
Subject: [failures]
 mm-clarify-that-the-function-operateds-on-hugepage-pte.patch removed from
 -mm tree
Date: Wed, 20 May 2015 12:45:06 -0700
Message-ID: <555ce442.xnkOGWP5+ALDy7aH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422AbbETTpH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 May 2015 15:45:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, benh@kernel.crashing.org, cmetcalf@ezchip.com, davem@davemloft.net, heiko.carstens@de.ibm.com, hpa@zytor.com, kirill.shutemov@linux.intel.com, mingo@elte.hu, mpe@ellerman.id.au, paulus@samba.org, ralf@linux-mips.org, schwidefsky@de.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clarify that the function operates on hugepage pte
has been removed from the -mm tree.  Its filename was
     mm-clarify-that-the-function-operateds-on-hugepage-pte.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm: clarify that the function operates on hugepage pte

We have confusing functions to clear pmd, pmd_clear_* and pmd_clear.  Add
_huge_ to pmdp_clear functions so that we are clear that they operate on
hugepage pte.

We don't bother about other functions like pmdp_set_wrprotect,
pmdp_clear_flush_young, because they operate on PTE bits and hence
indicate they are operating on hugepage ptes

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/pgtable.h          |    8 +++----
 arch/powerpc/include/asm/pgtable-ppc64.h |    6 ++---
 arch/powerpc/mm/pgtable_64.c             |    4 +--
 arch/s390/include/asm/pgtable.h          |   22 ++++++++++-----------
 arch/sparc/include/asm/pgtable_64.h      |    8 +++----
 arch/tile/include/asm/pgtable.h          |    8 +++----
 arch/x86/include/asm/pgtable.h           |    4 +--
 include/asm-generic/pgtable.h            |   18 ++++++++---------
 include/linux/mmu_notifier.h             |   12 +++++------
 mm/huge_memory.c                         |   16 +++++++--------
 mm/migrate.c                             |    2 -
 mm/pgtable-generic.c                     |    8 +++----
 mm/rmap.c                                |    2 -
 13 files changed, 59 insertions(+), 59 deletions(-)

diff -puN arch/mips/include/asm/pgtable.h~mm-clarify-that-the-function-operateds-on-hugepage-pte arch/mips/include/asm/pgtable.h
--- a/arch/mips/include/asm/pgtable.h~mm-clarify-that-the-function-operateds-on-hugepage-pte
+++ a/arch/mips/include/asm/pgtable.h
@@ -568,12 +568,12 @@ static inline pmd_t pmd_mknotpresent(pmd
 }
 
 /*
- * The generic version pmdp_get_and_clear uses a version of pmd_clear() with a
+ * The generic version pmdp_huge_get_and_clear uses a version of pmd_clear() with a
  * different prototype.
  */
-#define __HAVE_ARCH_PMDP_GET_AND_CLEAR
-static inline pmd_t pmdp_get_and_clear(struct mm_struct *mm,
-				       unsigned long address, pmd_t *pmdp)
+#define __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
+static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
+					    unsigned long address, pmd_t *pmdp)
 {
 	pmd_t old = *pmdp;
 
diff -puN arch/powerpc/include/asm/pgtable-ppc64.h~mm-clarify-that-the-function-operateds-on-hugepage-pte arch/powerpc/include/asm/pgtable-ppc64.h
--- a/arch/powerpc/include/asm/pgtable-ppc64.h~mm-clarify-that-the-function-operateds-on-hugepage-pte
+++ a/arch/powerpc/include/asm/pgtable-ppc64.h
@@ -553,9 +553,9 @@ extern int pmdp_test_and_clear_young(str
 extern int pmdp_clear_flush_young(struct vm_area_struct *vma,
 				  unsigned long address, pmd_t *pmdp);
 
-#define __HAVE_ARCH_PMDP_GET_AND_CLEAR
-extern pmd_t pmdp_get_and_clear(struct mm_struct *mm,
-				unsigned long addr, pmd_t *pmdp);
+#define __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
+extern pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
+				     unsigned long addr, pmd_t *pmdp);
 
 #define __HAVE_ARCH_PMDP_SET_WRPROTECT
 static inline void pmdp_set_wrprotect(struct mm_struct *mm, unsigned long addr,
diff -puN arch/powerpc/mm/pgtable_64.c~mm-clarify-that-the-function-operateds-on-hugepage-pte arch/powerpc/mm/pgtable_64.c
--- a/arch/powerpc/mm/pgtable_64.c~mm-clarify-that-the-function-operateds-on-hugepage-pte
+++ a/arch/powerpc/mm/pgtable_64.c
@@ -812,8 +812,8 @@ void update_mmu_cache_pmd(struct vm_area
 	return;
 }
 
-pmd_t pmdp_get_and_clear(struct mm_struct *mm,
-			 unsigned long addr, pmd_t *pmdp)
+pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
+			      unsigned long addr, pmd_t *pmdp)
 {
 	pmd_t old_pmd;
 	pgtable_t pgtable;
diff -puN arch/s390/include/asm/pgtable.h~mm-clarify-that-the-function-operateds-on-hugepage-pte arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~mm-clarify-that-the-function-operateds-on-hugepage-pte
+++ a/arch/s390/include/asm/pgtable.h
@@ -1498,9 +1498,9 @@ static inline int pmdp_test_and_clear_yo
 	return pmd_young(pmd);
 }
 
-#define __HAVE_ARCH_PMDP_GET_AND_CLEAR
-static inline pmd_t pmdp_get_and_clear(struct mm_struct *mm,
-				       unsigned long address, pmd_t *pmdp)
+#define __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
+static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
+					    unsigned long address, pmd_t *pmdp)
 {
 	pmd_t pmd = *pmdp;
 
@@ -1509,10 +1509,10 @@ static inline pmd_t pmdp_get_and_clear(s
 	return pmd;
 }
 
-#define __HAVE_ARCH_PMDP_GET_AND_CLEAR_FULL
-static inline pmd_t pmdp_get_and_clear_full(struct mm_struct *mm,
-					    unsigned long address,
-					    pmd_t *pmdp, int full)
+#define __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR_FULL
+static inline pmd_t pmdp_huge_get_and_clear_full(struct mm_struct *mm,
+						 unsigned long address,
+						 pmd_t *pmdp, int full)
 {
 	pmd_t pmd = *pmdp;
 
@@ -1522,11 +1522,11 @@ static inline pmd_t pmdp_get_and_clear_f
 	return pmd;
 }
 
-#define __HAVE_ARCH_PMDP_CLEAR_FLUSH
-static inline pmd_t pmdp_clear_flush(struct vm_area_struct *vma,
-				     unsigned long address, pmd_t *pmdp)
+#define __HAVE_ARCH_PMDP_HUGE_CLEAR_FLUSH
+static inline pmd_t pmdp_huge_clear_flush(struct vm_area_struct *vma,
+					  unsigned long address, pmd_t *pmdp)
 {
-	return pmdp_get_and_clear(vma->vm_mm, address, pmdp);
+	return pmdp_huge_get_and_clear(vma->vm_mm, address, pmdp);
 }
 
 #define __HAVE_ARCH_PMDP_INVALIDATE
diff -puN arch/sparc/include/asm/pgtable_64.h~mm-clarify-that-the-function-operateds-on-hugepage-pte arch/sparc/include/asm/pgtable_64.h
--- a/arch/sparc/include/asm/pgtable_64.h~mm-clarify-that-the-function-operateds-on-hugepage-pte
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -845,10 +845,10 @@ static inline unsigned long pud_pfn(pud_
 void tlb_batch_add(struct mm_struct *mm, unsigned long vaddr,
 		   pte_t *ptep, pte_t orig, int fullmm);
 
-#define __HAVE_ARCH_PMDP_GET_AND_CLEAR
-static inline pmd_t pmdp_get_and_clear(struct mm_struct *mm,
-				       unsigned long addr,
-				       pmd_t *pmdp)
+#define __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
+static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
+					    unsigned long addr,
+					    pmd_t *pmdp)
 {
 	pmd_t pmd = *pmdp;
 	set_pmd_at(mm, addr, pmdp, __pmd(0UL));
diff -puN arch/tile/include/asm/pgtable.h~mm-clarify-that-the-function-operateds-on-hugepage-pte arch/tile/include/asm/pgtable.h
--- a/arch/tile/include/asm/pgtable.h~mm-clarify-that-the-function-operateds-on-hugepage-pte
+++ a/arch/tile/include/asm/pgtable.h
@@ -414,10 +414,10 @@ static inline void pmdp_set_wrprotect(st
 }
 
 
-#define __HAVE_ARCH_PMDP_GET_AND_CLEAR
-static inline pmd_t pmdp_get_and_clear(struct mm_struct *mm,
-				       unsigned long address,
-				       pmd_t *pmdp)
+#define __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
+static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
+					    unsigned long address,
+					    pmd_t *pmdp)
 {
 	return pte_pmd(ptep_get_and_clear(mm, address, pmdp_ptep(pmdp)));
 }
diff -puN arch/x86/include/asm/pgtable.h~mm-clarify-that-the-function-operateds-on-hugepage-pte arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-clarify-that-the-function-operateds-on-hugepage-pte
+++ a/arch/x86/include/asm/pgtable.h
@@ -799,8 +799,8 @@ static inline int pmd_write(pmd_t pmd)
 	return pmd_flags(pmd) & _PAGE_RW;
 }
 
-#define __HAVE_ARCH_PMDP_GET_AND_CLEAR
-static inline pmd_t pmdp_get_and_clear(struct mm_struct *mm, unsigned long addr,
+#define __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
+static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm, unsigned long addr,
 				       pmd_t *pmdp)
 {
 	pmd_t pmd = native_pmdp_get_and_clear(pmdp);
diff -puN include/asm-generic/pgtable.h~mm-clarify-that-the-function-operateds-on-hugepage-pte include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-clarify-that-the-function-operateds-on-hugepage-pte
+++ a/include/asm-generic/pgtable.h
@@ -96,11 +96,11 @@ static inline pte_t ptep_get_and_clear(s
 }
 #endif
 
-#ifndef __HAVE_ARCH_PMDP_GET_AND_CLEAR
+#ifndef __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static inline pmd_t pmdp_get_and_clear(struct mm_struct *mm,
-				       unsigned long address,
-				       pmd_t *pmdp)
+static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
+					    unsigned long address,
+					    pmd_t *pmdp)
 {
 	pmd_t pmd = *pmdp;
 	pmd_clear(pmdp);
@@ -109,13 +109,13 @@ static inline pmd_t pmdp_get_and_clear(s
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
-#ifndef __HAVE_ARCH_PMDP_GET_AND_CLEAR_FULL
+#ifndef __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR_FULL
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static inline pmd_t pmdp_get_and_clear_full(struct mm_struct *mm,
+static inline pmd_t pmdp_huge_get_and_clear_full(struct mm_struct *mm,
 					    unsigned long address, pmd_t *pmdp,
 					    int full)
 {
-	return pmdp_get_and_clear(mm, address, pmdp);
+	return pmdp_huge_get_and_clear(mm, address, pmdp);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
@@ -152,8 +152,8 @@ extern pte_t ptep_clear_flush(struct vm_
 			      pte_t *ptep);
 #endif
 
-#ifndef __HAVE_ARCH_PMDP_CLEAR_FLUSH
-extern pmd_t pmdp_clear_flush(struct vm_area_struct *vma,
+#ifndef __HAVE_ARCH_PMDP_HUGE_CLEAR_FLUSH
+extern pmd_t pmdp_huge_clear_flush(struct vm_area_struct *vma,
 			      unsigned long address,
 			      pmd_t *pmdp);
 #endif
diff -puN include/linux/mmu_notifier.h~mm-clarify-that-the-function-operateds-on-hugepage-pte include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h~mm-clarify-that-the-function-operateds-on-hugepage-pte
+++ a/include/linux/mmu_notifier.h
@@ -324,25 +324,25 @@ static inline void mmu_notifier_mm_destr
 	___pte;								\
 })
 
-#define pmdp_clear_flush_notify(__vma, __haddr, __pmd)			\
+#define pmdp_huge_clear_flush_notify(__vma, __haddr, __pmd)		\
 ({									\
 	unsigned long ___haddr = __haddr & HPAGE_PMD_MASK;		\
 	struct mm_struct *___mm = (__vma)->vm_mm;			\
 	pmd_t ___pmd;							\
 									\
-	___pmd = pmdp_clear_flush(__vma, __haddr, __pmd);		\
+	___pmd = pmdp_huge_clear_flush(__vma, __haddr, __pmd);		\
 	mmu_notifier_invalidate_range(___mm, ___haddr,			\
 				      ___haddr + HPAGE_PMD_SIZE);	\
 									\
 	___pmd;								\
 })
 
-#define pmdp_get_and_clear_notify(__mm, __haddr, __pmd)			\
+#define pmdp_huge_get_and_clear_notify(__mm, __haddr, __pmd)		\
 ({									\
 	unsigned long ___haddr = __haddr & HPAGE_PMD_MASK;		\
 	pmd_t ___pmd;							\
 									\
-	___pmd = pmdp_get_and_clear(__mm, __haddr, __pmd);		\
+	___pmd = pmdp_huge_get_and_clear(__mm, __haddr, __pmd);		\
 	mmu_notifier_invalidate_range(__mm, ___haddr,			\
 				      ___haddr + HPAGE_PMD_SIZE);	\
 									\
@@ -428,8 +428,8 @@ static inline void mmu_notifier_mm_destr
 #define ptep_clear_flush_young_notify ptep_clear_flush_young
 #define pmdp_clear_flush_young_notify pmdp_clear_flush_young
 #define	ptep_clear_flush_notify ptep_clear_flush
-#define pmdp_clear_flush_notify pmdp_clear_flush
-#define pmdp_get_and_clear_notify pmdp_get_and_clear
+#define pmdp_huge_clear_flush_notify pmdp_huge_clear_flush
+#define pmdp_huge_get_and_clear_notify pmdp_huge_get_and_clear
 #define set_pte_at_notify set_pte_at
 
 #endif /* CONFIG_MMU_NOTIFIER */
diff -puN mm/huge_memory.c~mm-clarify-that-the-function-operateds-on-hugepage-pte mm/huge_memory.c
--- a/mm/huge_memory.c~mm-clarify-that-the-function-operateds-on-hugepage-pte
+++ a/mm/huge_memory.c
@@ -1031,7 +1031,7 @@ static int do_huge_pmd_wp_page_fallback(
 		goto out_free_pages;
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 
-	pmdp_clear_flush_notify(vma, haddr, pmd);
+	pmdp_huge_clear_flush_notify(vma, haddr, pmd);
 	/* leave pmd empty until pte is filled */
 
 	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
@@ -1174,7 +1174,7 @@ alloc:
 		pmd_t entry;
 		entry = mk_huge_pmd(new_page, vma->vm_page_prot);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
-		pmdp_clear_flush_notify(vma, haddr, pmd);
+		pmdp_huge_clear_flush_notify(vma, haddr, pmd);
 		page_add_new_anon_rmap(new_page, vma, haddr);
 		mem_cgroup_commit_charge(new_page, memcg, false);
 		lru_cache_add_active_or_unevictable(new_page, vma);
@@ -1396,12 +1396,12 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		pmd_t orig_pmd;
 		/*
 		 * For architectures like ppc64 we look at deposited pgtable
-		 * when calling pmdp_get_and_clear. So do the
+		 * when calling pmdp_huge_get_and_clear. So do the
 		 * pgtable_trans_huge_withdraw after finishing pmdp related
 		 * operations.
 		 */
-		orig_pmd = pmdp_get_and_clear_full(tlb->mm, addr, pmd,
-						   tlb->fullmm);
+		orig_pmd = pmdp_huge_get_and_clear_full(tlb->mm, addr, pmd,
+							tlb->fullmm);
 		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 		pgtable = pgtable_trans_huge_withdraw(tlb->mm, pmd);
 		if (is_huge_zero_pmd(orig_pmd)) {
@@ -1459,7 +1459,7 @@ int move_huge_pmd(struct vm_area_struct
 		new_ptl = pmd_lockptr(mm, new_pmd);
 		if (new_ptl != old_ptl)
 			spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
-		pmd = pmdp_get_and_clear(mm, old_addr, old_pmd);
+		pmd = pmdp_huge_get_and_clear(mm, old_addr, old_pmd);
 		VM_BUG_ON(!pmd_none(*new_pmd));
 
 		if (pmd_move_must_withdraw(new_ptl, old_ptl)) {
@@ -1505,7 +1505,7 @@ int change_huge_pmd(struct vm_area_struc
 		}
 
 		if (!prot_numa || !pmd_protnone(*pmd)) {
-			entry = pmdp_get_and_clear_notify(mm, addr, pmd);
+			entry = pmdp_huge_get_and_clear_notify(mm, addr, pmd);
 			entry = pmd_modify(entry, newprot);
 			if (preserve_write)
 				entry = pmd_mkwrite(entry);
@@ -2863,7 +2863,7 @@ static void __split_huge_zero_page_pmd(s
 	pmd_t _pmd;
 	int i;
 
-	pmdp_clear_flush_notify(vma, haddr, pmd);
+	pmdp_huge_clear_flush_notify(vma, haddr, pmd);
 	/* leave pmd empty until pte is filled */
 
 	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
diff -puN mm/migrate.c~mm-clarify-that-the-function-operateds-on-hugepage-pte mm/migrate.c
--- a/mm/migrate.c~mm-clarify-that-the-function-operateds-on-hugepage-pte
+++ a/mm/migrate.c
@@ -1799,7 +1799,7 @@ fail_putback:
 	 */
 	flush_cache_range(vma, mmun_start, mmun_end);
 	page_add_anon_rmap(new_page, vma, mmun_start);
-	pmdp_clear_flush_notify(vma, mmun_start, pmd);
+	pmdp_huge_clear_flush_notify(vma, mmun_start, pmd);
 	set_pmd_at(mm, mmun_start, pmd, entry);
 	flush_tlb_range(vma, mmun_start, mmun_end);
 	update_mmu_cache_pmd(vma, address, &entry);
diff -puN mm/pgtable-generic.c~mm-clarify-that-the-function-operateds-on-hugepage-pte mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~mm-clarify-that-the-function-operateds-on-hugepage-pte
+++ a/mm/pgtable-generic.c
@@ -119,15 +119,15 @@ pte_t ptep_clear_flush(struct vm_area_st
 }
 #endif
 
-#ifndef __HAVE_ARCH_PMDP_CLEAR_FLUSH
+#ifndef __HAVE_ARCH_PMDP_HUGE_CLEAR_FLUSH
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-pmd_t pmdp_clear_flush(struct vm_area_struct *vma, unsigned long address,
-		       pmd_t *pmdp)
+pmd_t pmdp_huge_clear_flush(struct vm_area_struct *vma, unsigned long address,
+			    pmd_t *pmdp)
 {
 	pmd_t pmd;
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 	VM_BUG_ON(!pmd_trans_huge(*pmdp));
-	pmd = pmdp_get_and_clear(vma->vm_mm, address, pmdp);
+	pmd = pmdp_huge_get_and_clear(vma->vm_mm, address, pmdp);
 	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 	return pmd;
 }
diff -puN mm/rmap.c~mm-clarify-that-the-function-operateds-on-hugepage-pte mm/rmap.c
--- a/mm/rmap.c~mm-clarify-that-the-function-operateds-on-hugepage-pte
+++ a/mm/rmap.c
@@ -625,7 +625,7 @@ pmd_t *mm_find_pmd(struct mm_struct *mm,
 
 	pmd = pmd_offset(pud, address);
 	/*
-	 * Some THP functions use the sequence pmdp_clear_flush(), set_pmd_at()
+	 * Some THP functions use the sequence pmdp_huge_clear_flush(), set_pmd_at()
 	 * without holding anon_vma lock for write.  So when looking for a
 	 * genuine pmde (in which to find pte), test present and !THP together.
 	 */
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

origin.patch
tracing-mm-dont-trace-kmem_cache_free-on-offline-cpus.patch
mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare.patch
mm-clarify-that-the-function-operates-on-hugepage-pte-v5.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch

