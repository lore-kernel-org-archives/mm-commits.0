From: akpm@linux-foundation.org
Subject: + x86-add-support-for-pud-sized-transparent-hugepages.patch added to -mm tree
Date: Tue, 02 Feb 2016 14:53:52 -0800
Message-ID: <56b13380.vzOwvGp0cUcE5ekD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbcBBWxx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Feb 2016 17:53:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, dan.j.williams@intel.com, jack@suse.cz, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: add support for PUD-sized transparent hugepages
has been added to the -mm tree.  Its filename is
     x86-add-support-for-pud-sized-transparent-hugepages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-add-support-for-pud-sized-transparent-hugepages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-add-support-for-pud-sized-transparent-hugepages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: x86: add support for PUD-sized transparent hugepages

The x86-specific code needed to support the PUD uses in the transparent
hugepages code.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                      |    1 
 arch/x86/include/asm/paravirt.h       |   11 +
 arch/x86/include/asm/paravirt_types.h |    2 
 arch/x86/include/asm/pgtable-2level.h |   19 +++
 arch/x86/include/asm/pgtable-3level.h |   31 +++++
 arch/x86/include/asm/pgtable.h        |  134 ++++++++++++++++++++++++
 arch/x86/include/asm/pgtable_64.h     |   13 ++
 arch/x86/kernel/paravirt.c            |    1 
 arch/x86/mm/pgtable.c                 |   31 +++++
 9 files changed, 243 insertions(+)

diff -puN arch/x86/Kconfig~x86-add-support-for-pud-sized-transparent-hugepages arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-add-support-for-pud-sized-transparent-hugepages
+++ a/arch/x86/Kconfig
@@ -90,6 +90,7 @@ config X86
 	select HAVE_ARCH_SOFT_DIRTY		if X86_64
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
+	select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD if X86_64
 	select HAVE_BPF_JIT			if X86_64
 	select HAVE_CC_STACKPROTECTOR
 	select HAVE_CMPXCHG_DOUBLE
diff -puN arch/x86/include/asm/paravirt.h~x86-add-support-for-pud-sized-transparent-hugepages arch/x86/include/asm/paravirt.h
--- a/arch/x86/include/asm/paravirt.h~x86-add-support-for-pud-sized-transparent-hugepages
+++ a/arch/x86/include/asm/paravirt.h
@@ -485,6 +485,17 @@ static inline void set_pmd_at(struct mm_
 			    native_pmd_val(pmd));
 }
 
+static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
+			      pud_t *pudp, pud_t pud)
+{
+	if (sizeof(pudval_t) > sizeof(long))
+		/* 5 arg words */
+		pv_mmu_ops.set_pud_at(mm, addr, pudp, pud);
+	else
+		PVOP_VCALL4(pv_mmu_ops.set_pud_at, mm, addr, pudp,
+			    native_pud_val(pud));
+}
+
 static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
 {
 	pmdval_t val = native_pmd_val(pmd);
diff -puN arch/x86/include/asm/paravirt_types.h~x86-add-support-for-pud-sized-transparent-hugepages arch/x86/include/asm/paravirt_types.h
--- a/arch/x86/include/asm/paravirt_types.h~x86-add-support-for-pud-sized-transparent-hugepages
+++ a/arch/x86/include/asm/paravirt_types.h
@@ -252,6 +252,8 @@ struct pv_mmu_ops {
 	void (*set_pmd)(pmd_t *pmdp, pmd_t pmdval);
 	void (*set_pmd_at)(struct mm_struct *mm, unsigned long addr,
 			   pmd_t *pmdp, pmd_t pmdval);
+	void (*set_pud_at)(struct mm_struct *mm, unsigned long addr,
+			   pud_t *pudp, pud_t pudval);
 	void (*pte_update)(struct mm_struct *mm, unsigned long addr,
 			   pte_t *ptep);
 
diff -puN arch/x86/include/asm/pgtable-2level.h~x86-add-support-for-pud-sized-transparent-hugepages arch/x86/include/asm/pgtable-2level.h
--- a/arch/x86/include/asm/pgtable-2level.h~x86-add-support-for-pud-sized-transparent-hugepages
+++ a/arch/x86/include/asm/pgtable-2level.h
@@ -21,6 +21,11 @@ static inline void native_set_pmd(pmd_t
 	*pmdp = pmd;
 }
 
+static inline void native_set_pud(pud_t *pudp, pud_t pud)
+{
+	*pudp = pud;
+}
+
 static inline void native_set_pte_atomic(pte_t *ptep, pte_t pte)
 {
 	native_set_pte(ptep, pte);
@@ -31,6 +36,11 @@ static inline void native_pmd_clear(pmd_
 	native_set_pmd(pmdp, __pmd(0));
 }
 
+static inline void native_pud_clear(pud_t *pudp)
+{
+	native_set_pud(pudp, __pud(0));
+}
+
 static inline void native_pte_clear(struct mm_struct *mm,
 				    unsigned long addr, pte_t *xp)
 {
@@ -55,6 +65,15 @@ static inline pmd_t native_pmdp_get_and_
 #define native_pmdp_get_and_clear(xp) native_local_pmdp_get_and_clear(xp)
 #endif
 
+#ifdef CONFIG_SMP
+static inline pud_t native_pudp_get_and_clear(pud_t *xp)
+{
+	return __pud(xchg((pudval_t *)xp, 0));
+}
+#else
+#define native_pudp_get_and_clear(xp) native_local_pudp_get_and_clear(xp)
+#endif
+
 /* Bit manipulation helper on pte/pgoff entry */
 static inline unsigned long pte_bitop(unsigned long value, unsigned int rightshift,
 				      unsigned long mask, unsigned int leftshift)
diff -puN arch/x86/include/asm/pgtable-3level.h~x86-add-support-for-pud-sized-transparent-hugepages arch/x86/include/asm/pgtable-3level.h
--- a/arch/x86/include/asm/pgtable-3level.h~x86-add-support-for-pud-sized-transparent-hugepages
+++ a/arch/x86/include/asm/pgtable-3level.h
@@ -121,6 +121,14 @@ static inline void native_pmd_clear(pmd_
 	*(tmp + 1) = 0;
 }
 
+static inline void native_pud_clear(pud_t *pud)
+{
+	u32 *tmp = (u32 *)pud;
+	*tmp = 0;
+	smp_wmb();
+	*(tmp + 1) = 0;
+}
+
 static inline void pud_clear(pud_t *pudp)
 {
 	set_pud(pudp, __pud(0));
@@ -176,6 +184,29 @@ static inline pmd_t native_pmdp_get_and_
 #define native_pmdp_get_and_clear(xp) native_local_pmdp_get_and_clear(xp)
 #endif
 
+#ifdef CONFIG_SMP
+union split_pud {
+	struct {
+		u32 pud_low;
+		u32 pud_high;
+	};
+	pud_t pud;
+};
+static inline pud_t native_pudp_get_and_clear(pud_t *pudp)
+{
+	union split_pud res, *orig = (union split_pud *)pudp;
+
+	/* xchg acts as a barrier before setting of the high bits */
+	res.pud_low = xchg(&orig->pud_low, 0);
+	res.pud_high = orig->pud_high;
+	orig->pud_high = 0;
+
+	return res.pud;
+}
+#else
+#define native_pudp_get_and_clear(xp) native_local_pudp_get_and_clear(xp)
+#endif
+
 /* Encode and de-code a swap entry */
 #define MAX_SWAPFILES_CHECK() BUILD_BUG_ON(MAX_SWAPFILES_SHIFT > 5)
 #define __swp_type(x)			(((x).val) & 0x1f)
diff -puN arch/x86/include/asm/pgtable.h~x86-add-support-for-pud-sized-transparent-hugepages arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~x86-add-support-for-pud-sized-transparent-hugepages
+++ a/arch/x86/include/asm/pgtable.h
@@ -46,6 +46,7 @@ extern struct mm_struct *pgd_page_get_mm
 #define set_pte(ptep, pte)		native_set_pte(ptep, pte)
 #define set_pte_at(mm, addr, ptep, pte)	native_set_pte_at(mm, addr, ptep, pte)
 #define set_pmd_at(mm, addr, pmdp, pmd)	native_set_pmd_at(mm, addr, pmdp, pmd)
+#define set_pud_at(mm, addr, pudp, pud)	native_set_pud_at(mm, addr, pudp, pud)
 
 #define set_pte_atomic(ptep, pte)					\
 	native_set_pte_atomic(ptep, pte)
@@ -114,6 +115,16 @@ static inline int pmd_young(pmd_t pmd)
 	return pmd_flags(pmd) & _PAGE_ACCESSED;
 }
 
+static inline int pud_dirty(pud_t pud)
+{
+	return pud_flags(pud) & _PAGE_DIRTY;
+}
+
+static inline int pud_young(pud_t pud)
+{
+	return pud_flags(pud) & _PAGE_ACCESSED;
+}
+
 static inline int pte_write(pte_t pte)
 {
 	return pte_flags(pte) & _PAGE_RW;
@@ -177,6 +188,18 @@ static inline int pmd_devmap(pmd_t pmd)
 {
 	return !!(pmd_val(pmd) & _PAGE_DEVMAP);
 }
+
+static inline int pud_devmap(pud_t pud)
+{
+	return !!(pud_val(pud) & _PAGE_DEVMAP);
+}
+#endif
+
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+static inline int pud_trans_huge(pud_t pud)
+{
+	return (pud_val(pud) & (_PAGE_PSE|_PAGE_DEVMAP)) == _PAGE_PSE;
+}
 #endif
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
@@ -318,6 +341,65 @@ static inline pmd_t pmd_mknotpresent(pmd
 	return pmd_clear_flags(pmd, _PAGE_PRESENT | _PAGE_PROTNONE);
 }
 
+static inline pud_t pud_set_flags(pud_t pud, pudval_t set)
+{
+	pudval_t v = native_pud_val(pud);
+
+	return __pud(v | set);
+}
+
+static inline pud_t pud_clear_flags(pud_t pud, pudval_t clear)
+{
+	pudval_t v = native_pud_val(pud);
+
+	return __pud(v & ~clear);
+}
+
+static inline pud_t pud_mkold(pud_t pud)
+{
+	return pud_clear_flags(pud, _PAGE_ACCESSED);
+}
+
+static inline pud_t pud_mkclean(pud_t pud)
+{
+	return pud_clear_flags(pud, _PAGE_DIRTY);
+}
+
+static inline pud_t pud_wrprotect(pud_t pud)
+{
+	return pud_clear_flags(pud, _PAGE_RW);
+}
+
+static inline pud_t pud_mkdirty(pud_t pud)
+{
+	return pud_set_flags(pud, _PAGE_DIRTY | _PAGE_SOFT_DIRTY);
+}
+
+static inline pud_t pud_mkdevmap(pud_t pud)
+{
+	return pud_set_flags(pud, _PAGE_DEVMAP);
+}
+
+static inline pud_t pud_mkhuge(pud_t pud)
+{
+	return pud_set_flags(pud, _PAGE_PSE);
+}
+
+static inline pud_t pud_mkyoung(pud_t pud)
+{
+	return pud_set_flags(pud, _PAGE_ACCESSED);
+}
+
+static inline pud_t pud_mkwrite(pud_t pud)
+{
+	return pud_set_flags(pud, _PAGE_RW);
+}
+
+static inline pud_t pud_mknotpresent(pud_t pud)
+{
+	return pud_clear_flags(pud, _PAGE_PRESENT | _PAGE_PROTNONE);
+}
+
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 static inline int pte_soft_dirty(pte_t pte)
 {
@@ -329,6 +411,11 @@ static inline int pmd_soft_dirty(pmd_t p
 	return pmd_flags(pmd) & _PAGE_SOFT_DIRTY;
 }
 
+static inline int pud_soft_dirty(pud_t pud)
+{
+	return pud_flags(pud) & _PAGE_SOFT_DIRTY;
+}
+
 static inline pte_t pte_mksoft_dirty(pte_t pte)
 {
 	return pte_set_flags(pte, _PAGE_SOFT_DIRTY);
@@ -339,6 +426,11 @@ static inline pmd_t pmd_mksoft_dirty(pmd
 	return pmd_set_flags(pmd, _PAGE_SOFT_DIRTY);
 }
 
+static inline pud_t pud_mksoft_dirty(pud_t pud)
+{
+	return pud_set_flags(pud, _PAGE_SOFT_DIRTY);
+}
+
 static inline pte_t pte_clear_soft_dirty(pte_t pte)
 {
 	return pte_clear_flags(pte, _PAGE_SOFT_DIRTY);
@@ -349,6 +441,11 @@ static inline pmd_t pmd_clear_soft_dirty
 	return pmd_clear_flags(pmd, _PAGE_SOFT_DIRTY);
 }
 
+static inline pud_t pud_clear_soft_dirty(pud_t pud)
+{
+	return pud_clear_flags(pud, _PAGE_SOFT_DIRTY);
+}
+
 #endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
 
 /*
@@ -377,6 +474,13 @@ static inline pmd_t pfn_pmd(unsigned lon
 		     massage_pgprot(pgprot));
 }
 
+#define pfn_pud pfn_pud
+static inline pud_t pfn_pud(unsigned long page_nr, pgprot_t pgprot)
+{
+	return __pud(((phys_addr_t)page_nr << PAGE_SHIFT) |
+		     massage_pgprot(pgprot));
+}
+
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
 	pteval_t val = pte_val(pte);
@@ -732,6 +836,14 @@ static inline pmd_t native_local_pmdp_ge
 	return res;
 }
 
+static inline pud_t native_local_pudp_get_and_clear(pud_t *pudp)
+{
+	pud_t res = *pudp;
+
+	native_pud_clear(pudp);
+	return res;
+}
+
 static inline void native_set_pte_at(struct mm_struct *mm, unsigned long addr,
 				     pte_t *ptep , pte_t pte)
 {
@@ -744,6 +856,12 @@ static inline void native_set_pmd_at(str
 	native_set_pmd(pmdp, pmd);
 }
 
+static inline void native_set_pud_at(struct mm_struct *mm, unsigned long addr,
+				     pud_t *pudp , pud_t pud)
+{
+	native_set_pud(pudp, pud);
+}
+
 #ifndef CONFIG_PARAVIRT
 /*
  * Rules for using pte_update - it must be called after any PTE update which
@@ -822,10 +940,15 @@ static inline void ptep_set_wrprotect(st
 extern int pmdp_set_access_flags(struct vm_area_struct *vma,
 				 unsigned long address, pmd_t *pmdp,
 				 pmd_t entry, int dirty);
+extern int pudp_set_access_flags(struct vm_area_struct *vma,
+				 unsigned long address, pud_t *pudp,
+				 pud_t entry, int dirty);
 
 #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
 extern int pmdp_test_and_clear_young(struct vm_area_struct *vma,
 				     unsigned long addr, pmd_t *pmdp);
+extern int pudp_test_and_clear_young(struct vm_area_struct *vma,
+				     unsigned long addr, pud_t *pudp);
 
 #define __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
 extern int pmdp_clear_flush_young(struct vm_area_struct *vma,
@@ -845,6 +968,13 @@ static inline pmd_t pmdp_huge_get_and_cl
 	return native_pmdp_get_and_clear(pmdp);
 }
 
+#define __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR
+static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm, unsigned long addr,
+				       pud_t *pudp)
+{
+	return native_pudp_get_and_clear(pudp);
+}
+
 #define __HAVE_ARCH_PMDP_SET_WRPROTECT
 static inline void pmdp_set_wrprotect(struct mm_struct *mm,
 				      unsigned long addr, pmd_t *pmdp)
@@ -893,6 +1023,10 @@ static inline void update_mmu_cache_pmd(
 		unsigned long addr, pmd_t *pmd)
 {
 }
+static inline void update_mmu_cache_pud(struct vm_area_struct *vma,
+		unsigned long addr, pud_t *pud)
+{
+}
 
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
diff -puN arch/x86/include/asm/pgtable_64.h~x86-add-support-for-pud-sized-transparent-hugepages arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h~x86-add-support-for-pud-sized-transparent-hugepages
+++ a/arch/x86/include/asm/pgtable_64.h
@@ -106,6 +106,19 @@ static inline void native_pud_clear(pud_
 	native_set_pud(pud, native_make_pud(0));
 }
 
+static inline pud_t native_pudp_get_and_clear(pud_t *pudp)
+{
+#ifdef CONFIG_SMP
+	return native_make_pud(xchg(&pudp->pud, 0));
+#else
+	/* native_local_pudp_get_and_clear,
+	   but duplicated because of cyclic dependency */
+	pud_t ret = *pudp;
+	native_pud_clear(pudp);
+	return ret;
+#endif
+}
+
 static inline void native_set_pgd(pgd_t *pgdp, pgd_t pgd)
 {
 	*pgdp = pgd;
diff -puN arch/x86/kernel/paravirt.c~x86-add-support-for-pud-sized-transparent-hugepages arch/x86/kernel/paravirt.c
--- a/arch/x86/kernel/paravirt.c~x86-add-support-for-pud-sized-transparent-hugepages
+++ a/arch/x86/kernel/paravirt.c
@@ -425,6 +425,7 @@ struct pv_mmu_ops pv_mmu_ops = {
 	.pmd_clear = native_pmd_clear,
 #endif
 	.set_pud = native_set_pud,
+	.set_pud_at = native_set_pud_at,
 
 	.pmd_val = PTE_IDENT,
 	.make_pmd = PTE_IDENT,
diff -puN arch/x86/mm/pgtable.c~x86-add-support-for-pud-sized-transparent-hugepages arch/x86/mm/pgtable.c
--- a/arch/x86/mm/pgtable.c~x86-add-support-for-pud-sized-transparent-hugepages
+++ a/arch/x86/mm/pgtable.c
@@ -441,6 +441,26 @@ int pmdp_set_access_flags(struct vm_area
 
 	return changed;
 }
+
+int pudp_set_access_flags(struct vm_area_struct *vma, unsigned long address,
+			  pud_t *pudp, pud_t entry, int dirty)
+{
+	int changed = !pud_same(*pudp, entry);
+
+	VM_BUG_ON(address & ~HPAGE_PUD_MASK);
+
+	if (changed && dirty) {
+		*pudp = entry;
+		/*
+		 * We had a write-protection fault here and changed the pud
+		 * to to more permissive. No need to flush the TLB for that,
+		 * #PF is architecturally guaranteed to do that and in the
+		 * worst-case we'll generate a spurious fault.
+		 */
+	}
+
+	return changed;
+}
 #endif
 
 int ptep_test_and_clear_young(struct vm_area_struct *vma,
@@ -470,6 +490,17 @@ int pmdp_test_and_clear_young(struct vm_
 
 	return ret;
 }
+int pudp_test_and_clear_young(struct vm_area_struct *vma,
+			      unsigned long addr, pud_t *pudp)
+{
+	int ret = 0;
+
+	if (pud_young(*pudp))
+		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,
+					 (unsigned long *)pudp);
+
+	return ret;
+}
 #endif
 
 int ptep_clear_flush_young(struct vm_area_struct *vma,
_

Patches currently in -mm which might be from willy@linux.intel.com are

radix-tree-fix-race-in-gang-lookup.patch
hwspinlock-fix-race-between-radix-tree-insertion-and-lookup.patch
mm-convert-an-open-coded-vm_bug_on_vma.patch
mmfsdax-change-pmd_fault-to-huge_fault.patch
mm-add-support-for-pud-sized-transparent-hugepages.patch
procfs-add-support-for-puds-to-smaps-clear_refs-and-pagemap.patch
x86-add-support-for-pud-sized-transparent-hugepages.patch
dax-support-for-transparent-pud-pages.patch
ext4-support-for-pud-sized-transparent-huge-pages.patch
radix-tree-add-an-explicit-include-of-bitopsh.patch
radix-tree-test-harness.patch
radix_tree-tag-all-internal-tree-nodes-as-indirect-pointers.patch
radix_tree-loop-based-on-shift-count-not-height.patch
radix_tree-add-support-for-multi-order-entries.patch
radix_tree-add-radix_tree_dump.patch
btrfs-use-radix_tree_iter_retry.patch
mm-use-radix_tree_iter_retry.patch
radix-treeshmem-introduce-radix_tree_iter_next.patch

