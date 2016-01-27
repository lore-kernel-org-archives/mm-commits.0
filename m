From: akpm@linux-foundation.org
Subject: + mm-add-support-for-pud-sized-transparent-hugepages.patch added
 to -mm tree
Date: Wed, 27 Jan 2016 12:26:57 -0800
Message-ID: <56a92811.FwiWNZBS09qrTeRC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965602AbcA0U07 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 15:26:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, darrick.wong@oracle.com, david@fromorbit.com, hpa@zytor.com, kirill.shutemov@linux.intel.com, mingming.cao@oracle.com, mingo@elte.hu, rientjes@google.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add support for PUD-sized transparent hugepages
has been added to the -mm tree.  Its filename is
     mm-add-support-for-pud-sized-transparent-hugepages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-support-for-pud-sized-transparent-hugepages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-support-for-pud-sized-transparent-hugepages.patch

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
Subject: mm: add support for PUD-sized transparent hugepages

The current transparent hugepage code only supports PMDs.  This patch adds
support for transparent use of PUDs with DAX.  It does not include support
for anonymous pages.

Most of this patch simply parallels the work that was done for huge PMDs. 
The only major difference is how the new ->pud_entry method in mm_walk
works.  The ->pmd_entry method replaces the ->pte_entry method, whereas
the ->pud_entry method works along with either ->pmd_entry or ->pte_entry.
The pagewalk code takes care of locking the PUD before calling
->pud_walk, so handlers do not need to worry whether the PUD is stable.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: mingming cao <mingming.cao@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig                  |    3 
 include/asm-generic/pgtable.h |   62 ++++++++++++-
 include/asm-generic/tlb.h     |   14 ++
 include/linux/huge_mm.h       |   50 ++++++++++
 include/linux/mm.h            |   23 ++++
 include/linux/mmu_notifier.h  |   13 ++
 include/linux/pfn_t.h         |    8 +
 mm/huge_memory.c              |  151 ++++++++++++++++++++++++++++++++
 mm/memory.c                   |   71 +++++++++++++++
 mm/pagewalk.c                 |   19 +++-
 mm/pgtable-generic.c          |   14 ++
 11 files changed, 423 insertions(+), 5 deletions(-)

diff -puN arch/Kconfig~mm-add-support-for-pud-sized-transparent-hugepages arch/Kconfig
--- a/arch/Kconfig~mm-add-support-for-pud-sized-transparent-hugepages
+++ a/arch/Kconfig
@@ -455,6 +455,9 @@ config HAVE_IRQ_TIME_ACCOUNTING
 config HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	bool
 
+config HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+	bool
+
 config HAVE_ARCH_HUGE_VMAP
 	bool
 
diff -puN include/asm-generic/pgtable.h~mm-add-support-for-pud-sized-transparent-hugepages include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-add-support-for-pud-sized-transparent-hugepages
+++ a/include/asm-generic/pgtable.h
@@ -36,6 +36,9 @@ extern int ptep_set_access_flags(struct
 extern int pmdp_set_access_flags(struct vm_area_struct *vma,
 				 unsigned long address, pmd_t *pmdp,
 				 pmd_t entry, int dirty);
+extern int pudp_set_access_flags(struct vm_area_struct *vma,
+				 unsigned long address, pud_t *pudp,
+				 pud_t entry, int dirty);
 #else
 static inline int pmdp_set_access_flags(struct vm_area_struct *vma,
 					unsigned long address, pmd_t *pmdp,
@@ -44,6 +47,13 @@ static inline int pmdp_set_access_flags(
 	BUILD_BUG();
 	return 0;
 }
+static inline int pudp_set_access_flags(struct vm_area_struct *vma,
+					unsigned long address, pud_t *pudp,
+					pud_t entry, int dirty)
+{
+	BUILD_BUG();
+	return 0;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
@@ -121,8 +131,8 @@ static inline pte_t ptep_get_and_clear(s
 }
 #endif
 
-#ifndef __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#ifndef __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
 static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 					    unsigned long address,
 					    pmd_t *pmdp)
@@ -131,20 +141,39 @@ static inline pmd_t pmdp_huge_get_and_cl
 	pmd_clear(pmdp);
 	return pmd;
 }
+#endif /* __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR */
+#ifndef __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR
+static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
+					    unsigned long address,
+					    pud_t *pudp)
+{
+	pud_t pud = *pudp;
+	pud_clear(pudp);
+	return pud;
+}
+#endif /* __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR */
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-#endif
 
-#ifndef __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR_FULL
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#ifndef __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR_FULL
 static inline pmd_t pmdp_huge_get_and_clear_full(struct mm_struct *mm,
 					    unsigned long address, pmd_t *pmdp,
 					    int full)
 {
 	return pmdp_huge_get_and_clear(mm, address, pmdp);
 }
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
+#ifndef __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR_FULL
+static inline pud_t pudp_huge_get_and_clear_full(struct mm_struct *mm,
+					    unsigned long address, pud_t *pudp,
+					    int full)
+{
+	return pudp_huge_get_and_clear(mm, address, pudp);
+}
+#endif
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
 #ifndef __HAVE_ARCH_PTEP_GET_AND_CLEAR_FULL
 static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 					    unsigned long address, pte_t *ptep,
@@ -181,6 +210,9 @@ extern pte_t ptep_clear_flush(struct vm_
 extern pmd_t pmdp_huge_clear_flush(struct vm_area_struct *vma,
 			      unsigned long address,
 			      pmd_t *pmdp);
+extern pud_t pudp_huge_clear_flush(struct vm_area_struct *vma,
+			      unsigned long address,
+			      pud_t *pudp);
 #endif
 
 #ifndef __HAVE_ARCH_PTEP_SET_WRPROTECT
@@ -265,12 +297,23 @@ static inline int pmd_same(pmd_t pmd_a,
 {
 	return pmd_val(pmd_a) == pmd_val(pmd_b);
 }
+
+static inline int pud_same(pud_t pud_a, pud_t pud_b)
+{
+	return pud_val(pud_a) == pud_val(pud_b);
+}
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 static inline int pmd_same(pmd_t pmd_a, pmd_t pmd_b)
 {
 	BUILD_BUG();
 	return 0;
 }
+
+static inline int pud_same(pud_t pud_a, pud_t pud_b)
+{
+	BUILD_BUG();
+	return 0;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
@@ -633,6 +676,17 @@ static inline int pmd_write(pmd_t pmd)
 #endif /* __HAVE_ARCH_PMD_WRITE */
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+#ifndef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+static inline int pud_trans_huge(pud_t pud)
+{
+	return 0;
+}
+static inline int pud_devmap(pud_t pud)
+{
+	return 0;
+}
+#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
+
 #ifndef pmd_read_atomic
 static inline pmd_t pmd_read_atomic(pmd_t *pmdp)
 {
diff -puN include/asm-generic/tlb.h~mm-add-support-for-pud-sized-transparent-hugepages include/asm-generic/tlb.h
--- a/include/asm-generic/tlb.h~mm-add-support-for-pud-sized-transparent-hugepages
+++ a/include/asm-generic/tlb.h
@@ -196,6 +196,20 @@ static inline void __tlb_reset_range(str
 		__tlb_remove_pmd_tlb_entry(tlb, pmdp, address);	\
 	} while (0)
 
+/**
+ * tlb_remove_pud_tlb_entry - remember a pud mapping for later tlb invalidation
+ * This is a nop so far, because only x86 needs it.
+ */
+#ifndef __tlb_remove_pud_tlb_entry
+#define __tlb_remove_pud_tlb_entry(tlb, pudp, address) do {} while (0)
+#endif
+
+#define tlb_remove_pud_tlb_entry(tlb, pudp, address)		\
+	do {							\
+		__tlb_adjust_range(tlb, address);		\
+		__tlb_remove_pud_tlb_entry(tlb, pudp, address);	\
+	} while (0)
+
 #define pte_free_tlb(tlb, ptep, address)			\
 	do {							\
 		__tlb_adjust_range(tlb, address);		\
diff -puN include/linux/huge_mm.h~mm-add-support-for-pud-sized-transparent-hugepages include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-add-support-for-pud-sized-transparent-hugepages
+++ a/include/linux/huge_mm.h
@@ -12,6 +12,20 @@ extern void huge_pmd_set_accessed(struct
 				  struct vm_area_struct *vma,
 				  unsigned long address, pmd_t *pmd,
 				  pmd_t orig_pmd, int dirty);
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+extern void huge_pud_set_accessed(struct mm_struct *mm,
+				  struct vm_area_struct *vma,
+				  unsigned long address, pud_t *pud,
+				  pud_t orig_pud, int dirty);
+#else
+static inline void huge_pud_set_accessed(struct mm_struct *mm,
+				  struct vm_area_struct *vma,
+				  unsigned long address, pud_t *pud,
+				  pud_t orig_pud, int dirty)
+{
+}
+#endif
+
 extern int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			       unsigned long address, pmd_t *pmd,
 			       pmd_t orig_pmd);
@@ -25,6 +39,9 @@ extern int madvise_free_huge_pmd(struct
 extern int zap_huge_pmd(struct mmu_gather *tlb,
 			struct vm_area_struct *vma,
 			pmd_t *pmd, unsigned long addr);
+extern int zap_huge_pud(struct mmu_gather *tlb,
+			struct vm_area_struct *vma,
+			pud_t *pud, unsigned long addr);
 extern int mincore_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 			unsigned long addr, unsigned long end,
 			unsigned char *vec);
@@ -38,6 +55,8 @@ extern int change_huge_pmd(struct vm_are
 			int prot_numa);
 int vmf_insert_pfn_pmd(struct vm_area_struct *, unsigned long addr, pmd_t *,
 			pfn_t pfn, bool write);
+int vmf_insert_pfn_pud(struct vm_area_struct *, unsigned long addr, pud_t *,
+			pfn_t pfn, bool write);
 enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_FLAG,
 	TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
@@ -61,6 +80,10 @@ struct page *follow_devmap_pmd(struct vm
 #define HPAGE_PMD_SIZE	((1UL) << HPAGE_PMD_SHIFT)
 #define HPAGE_PMD_MASK	(~(HPAGE_PMD_SIZE - 1))
 
+#define HPAGE_PUD_SHIFT PUD_SHIFT
+#define HPAGE_PUD_SIZE	((1UL) << HPAGE_PUD_SHIFT)
+#define HPAGE_PUD_MASK	(~(HPAGE_PUD_SIZE - 1))
+
 extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
 
 #define transparent_hugepage_enabled(__vma)				\
@@ -111,6 +134,17 @@ void __split_huge_pmd(struct vm_area_str
 			__split_huge_pmd(__vma, __pmd, __address);	\
 	}  while (0)
 
+void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
+		unsigned long address);
+
+#define split_huge_pud(__vma, __pud, __address)				\
+	do {								\
+		pud_t *____pud = (__pud);				\
+		if (pud_trans_huge(*____pud)				\
+					|| pud_devmap(*____pud))	\
+			__split_huge_pud(__vma, __pud, __address);	\
+	}  while (0)
+
 #if HPAGE_PMD_ORDER >= MAX_ORDER
 #error "hugepages can't be allocated by the buddy allocator"
 #endif
@@ -122,6 +156,8 @@ extern void vma_adjust_trans_huge(struct
 				    long adjust_next);
 extern spinlock_t *__pmd_trans_huge_lock(pmd_t *pmd,
 		struct vm_area_struct *vma);
+extern bool __pud_trans_huge_lock(pud_t *pud, struct vm_area_struct *vma,
+		spinlock_t **ptl);
 /* mmap_sem must be held on entry */
 static inline spinlock_t *pmd_trans_huge_lock(pmd_t *pmd,
 		struct vm_area_struct *vma)
@@ -132,6 +168,15 @@ static inline spinlock_t *pmd_trans_huge
 	else
 		return false;
 }
+static inline bool pud_trans_huge_lock(pud_t *pud, struct vm_area_struct *vma,
+		spinlock_t **ptl)
+{
+	VM_BUG_ON_VMA(!rwsem_is_locked(&vma->vm_mm->mmap_sem), vma);
+	if (pud_trans_huge(*pud) || pud_devmap(*pud))
+		return __pud_trans_huge_lock(pud, vma, ptl);
+	else
+		return false;
+}
 static inline int hpage_nr_pages(struct page *page)
 {
 	if (unlikely(PageTransHuge(page)))
@@ -154,6 +199,11 @@ static inline bool is_huge_zero_pmd(pmd_
 	return is_huge_zero_page(pmd_page(pmd));
 }
 
+static inline bool is_huge_zero_pud(pud_t pud)
+{
+	return 0;
+}
+
 struct page *get_huge_zero_page(void);
 
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
diff -puN include/linux/mm.h~mm-add-support-for-pud-sized-transparent-hugepages include/linux/mm.h
--- a/include/linux/mm.h~mm-add-support-for-pud-sized-transparent-hugepages
+++ a/include/linux/mm.h
@@ -345,6 +345,10 @@ static inline int pmd_devmap(pmd_t pmd)
 {
 	return 0;
 }
+static inline int pud_devmap(pud_t pud)
+{
+	return 0;
+}
 #endif
 
 /*
@@ -1135,6 +1139,10 @@ void unmap_vmas(struct mmu_gather *tlb,
 
 /**
  * mm_walk - callbacks for walk_page_range
+ * @pud_entry: if set, called for each non-empty PUD (2nd-level) entry
+ *	       this handler should only handle pud_trans_huge() puds.
+ *	       the pmd_entry or pte_entry callbacks will be used for
+ *	       regular PUDs.
  * @pmd_entry: if set, called for each non-empty PMD (3rd-level) entry
  *	       this handler is required to be able to handle
  *	       pmd_trans_huge() pmds.  They may simply choose to
@@ -1154,6 +1162,8 @@ void unmap_vmas(struct mmu_gather *tlb,
  * (see the comment on walk_page_range() for more details)
  */
 struct mm_walk {
+	int (*pud_entry)(pud_t *pud, unsigned long addr,
+			 unsigned long next, struct mm_walk *walk);
 	int (*pmd_entry)(pmd_t *pmd, unsigned long addr,
 			 unsigned long next, struct mm_walk *walk);
 	int (*pte_entry)(pte_t *pte, unsigned long addr,
@@ -1732,6 +1742,19 @@ static inline spinlock_t *pmd_lock(struc
 	spin_lock(ptl);
 	return ptl;
 }
+
+/*
+ * No scalability reason to split PUD locks yet, but follow the same pattern
+ * as the PMD locks to make it easier if we have to.  There are places that
+ * will need to be converted to use pud_lock() instead of explicitly grabbing
+ * the page_table_lock, eg __pud_alloc().
+ */
+static inline spinlock_t *pud_lock(struct mm_struct *mm, pud_t *pud)
+{
+	spinlock_t *ptl = &mm->page_table_lock;
+	spin_lock(ptl);
+	return ptl;
+}
 
 extern void free_area_init(unsigned long * zones_size);
 extern void free_area_init_node(int nid, unsigned long * zones_size,
diff -puN include/linux/mmu_notifier.h~mm-add-support-for-pud-sized-transparent-hugepages include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h~mm-add-support-for-pud-sized-transparent-hugepages
+++ a/include/linux/mmu_notifier.h
@@ -381,6 +381,19 @@ static inline void mmu_notifier_mm_destr
 	___pmd;								\
 })
 
+#define pudp_huge_clear_flush_notify(__vma, __haddr, __pud)		\
+({									\
+	unsigned long ___haddr = __haddr & HPAGE_PUD_MASK;		\
+	struct mm_struct *___mm = (__vma)->vm_mm;			\
+	pud_t ___pud;							\
+									\
+	___pud = pudp_huge_clear_flush(__vma, __haddr, __pud);		\
+	mmu_notifier_invalidate_range(___mm, ___haddr,			\
+				      ___haddr + HPAGE_PUD_SIZE);	\
+									\
+	___pud;								\
+})
+
 #define pmdp_huge_get_and_clear_notify(__mm, __haddr, __pmd)		\
 ({									\
 	unsigned long ___haddr = __haddr & HPAGE_PMD_MASK;		\
diff -puN include/linux/pfn_t.h~mm-add-support-for-pud-sized-transparent-hugepages include/linux/pfn_t.h
--- a/include/linux/pfn_t.h~mm-add-support-for-pud-sized-transparent-hugepages
+++ a/include/linux/pfn_t.h
@@ -82,6 +82,13 @@ static inline pmd_t pfn_t_pmd(pfn_t pfn,
 {
 	return pfn_pmd(pfn_t_to_pfn(pfn), pgprot);
 }
+
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+static inline pud_t pfn_t_pud(pfn_t pfn, pgprot_t pgprot)
+{
+	return pfn_pud(pfn_t_to_pfn(pfn), pgprot);
+}
+#endif
 #endif
 
 #ifdef __HAVE_ARCH_PTE_DEVMAP
@@ -98,5 +105,6 @@ static inline bool pfn_t_devmap(pfn_t pf
 }
 pte_t pte_mkdevmap(pte_t pte);
 pmd_t pmd_mkdevmap(pmd_t pmd);
+pud_t pud_mkdevmap(pud_t pud);
 #endif
 #endif /* _LINUX_PFN_T_H_ */
diff -puN mm/huge_memory.c~mm-add-support-for-pud-sized-transparent-hugepages mm/huge_memory.c
--- a/mm/huge_memory.c~mm-add-support-for-pud-sized-transparent-hugepages
+++ a/mm/huge_memory.c
@@ -972,6 +972,58 @@ int vmf_insert_pfn_pmd(struct vm_area_st
 	return VM_FAULT_NOPAGE;
 }
 
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+static pud_t maybe_pud_mkwrite(pud_t pud, struct vm_area_struct *vma)
+{
+	if (likely(vma->vm_flags & VM_WRITE))
+		pud = pud_mkwrite(pud);
+	return pud;
+}
+
+static void insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
+		pud_t *pud, pfn_t pfn, pgprot_t prot, bool write)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	pud_t entry;
+	spinlock_t *ptl;
+
+	ptl = pud_lock(mm, pud);
+	entry = pud_mkhuge(pfn_t_pud(pfn, prot));
+	if (pfn_t_devmap(pfn))
+		entry = pud_mkdevmap(entry);
+	if (write) {
+		entry = pud_mkyoung(pud_mkdirty(entry));
+		entry = maybe_pud_mkwrite(entry, vma);
+	}
+	set_pud_at(mm, addr, pud, entry);
+	update_mmu_cache_pud(vma, addr, pud);
+	spin_unlock(ptl);
+}
+
+int vmf_insert_pfn_pud(struct vm_area_struct *vma, unsigned long addr,
+			pud_t *pud, pfn_t pfn, bool write)
+{
+	pgprot_t pgprot = vma->vm_page_prot;
+	/*
+	 * If we had pud_special, we could avoid all these restrictions,
+	 * but we need to be consistent with PTEs and architectures that
+	 * can't support a 'special' bit.
+	 */
+	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)));
+	BUG_ON((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) ==
+						(VM_PFNMAP|VM_MIXEDMAP));
+	BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
+	BUG_ON(!pfn_t_devmap(pfn));
+
+	if (addr < vma->vm_start || addr >= vma->vm_end)
+		return VM_FAULT_SIGBUS;
+	if (track_pfn_insert(vma, &pgprot, pfn))
+		return VM_FAULT_SIGBUS;
+	insert_pfn_pud(vma, addr, pud, pfn, pgprot, write);
+	return VM_FAULT_NOPAGE;
+}
+#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
+
 static void touch_pmd(struct vm_area_struct *vma, unsigned long addr,
 		pmd_t *pmd)
 {
@@ -1096,6 +1148,29 @@ out:
 	return ret;
 }
 
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+void huge_pud_set_accessed(struct mm_struct *mm, struct vm_area_struct *vma,
+			   unsigned long address, pud_t *pud, pud_t orig_pud,
+			   int dirty)
+{
+	spinlock_t *ptl;
+	pud_t entry;
+	unsigned long haddr;
+
+	ptl = pud_lock(mm, pud);
+	if (unlikely(!pud_same(*pud, orig_pud)))
+		goto unlock;
+
+	entry = pud_mkyoung(orig_pud);
+	haddr = address & HPAGE_PMD_MASK;
+	if (pudp_set_access_flags(vma, haddr, pud, entry, dirty))
+		update_mmu_cache_pud(vma, address, pud);
+
+unlock:
+	spin_unlock(ptl);
+}
+#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
+
 void huge_pmd_set_accessed(struct mm_struct *mm,
 			   struct vm_area_struct *vma,
 			   unsigned long address,
@@ -1771,6 +1846,22 @@ spinlock_t *__pmd_trans_huge_lock(pmd_t
 	return NULL;
 }
 
+/*
+ * Returns true if a given pud maps a thp, false otherwise.
+ *
+ * Note that if it returns true, this routine returns without unlocking page
+ * table lock. So callers must unlock it.
+ */
+bool __pud_trans_huge_lock(pud_t *pud, struct vm_area_struct *vma,
+		spinlock_t **ptl)
+{
+	*ptl = pud_lock(vma->vm_mm, pud);
+	if (likely(pud_trans_huge(*pud) || pud_devmap(*pud)))
+		return true;
+	spin_unlock(*ptl);
+	return false;
+}
+
 #define VM_NO_THP (VM_SPECIAL | VM_HUGETLB | VM_SHARED | VM_MAYSHARE)
 
 int hugepage_madvise(struct vm_area_struct *vma,
@@ -2796,6 +2887,66 @@ static int khugepaged(void *none)
 	return 0;
 }
 
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		 pud_t *pud, unsigned long addr)
+{
+	pud_t orig_pud;
+	spinlock_t *ptl;
+
+	if (!__pud_trans_huge_lock(pud, vma, &ptl))
+		return 0;
+	/*
+	 * For architectures like ppc64 we look at deposited pgtable
+	 * when calling pudp_huge_get_and_clear. So do the
+	 * pgtable_trans_huge_withdraw after finishing pudp related
+	 * operations.
+	 */
+	orig_pud = pudp_huge_get_and_clear_full(tlb->mm, addr, pud,
+			tlb->fullmm);
+	tlb_remove_pud_tlb_entry(tlb, pud, addr);
+	if (vma_is_dax(vma)) {
+		spin_unlock(ptl);
+		/* No zero page support yet */
+	} else {
+		/* No support for anonymous PUD pages yet */
+		BUG();
+	}
+	return 1;
+}
+
+static void __split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
+		unsigned long haddr)
+{
+	VM_BUG_ON(haddr & ~HPAGE_PUD_MASK);
+	VM_BUG_ON_VMA(vma->vm_start > haddr, vma);
+	VM_BUG_ON_VMA(vma->vm_end < haddr + HPAGE_PUD_SIZE, vma);
+	VM_BUG_ON(!pud_trans_huge(*pud) && !pud_devmap(*pud));
+
+	count_vm_event(THP_SPLIT_PMD);
+
+	pudp_huge_clear_flush_notify(vma, haddr, pud);
+}
+
+void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
+		unsigned long address)
+{
+	spinlock_t *ptl;
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long haddr = address & HPAGE_PUD_MASK;
+
+	mmu_notifier_invalidate_range_start(mm, haddr, haddr + HPAGE_PUD_SIZE);
+	ptl = pud_lock(mm, pud);
+	if (unlikely(!pud_trans_huge(*pud) && !pud_devmap(*pud)))
+		goto out;
+	__split_huge_pud_locked(vma, pud, haddr);
+
+out:
+	spin_unlock(ptl);
+	mmu_notifier_invalidate_range_end(mm, haddr, haddr + HPAGE_PUD_SIZE);
+}
+#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
+
 static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 		unsigned long haddr, pmd_t *pmd)
 {
diff -puN mm/memory.c~mm-add-support-for-pud-sized-transparent-hugepages mm/memory.c
--- a/mm/memory.c~mm-add-support-for-pud-sized-transparent-hugepages
+++ a/mm/memory.c
@@ -1213,9 +1213,19 @@ static inline unsigned long zap_pud_rang
 	pud = pud_offset(pgd, addr);
 	do {
 		next = pud_addr_end(addr, end);
+		if (pud_trans_huge(*pud) || pud_devmap(*pud)) {
+			if (next - addr != HPAGE_PUD_SIZE) {
+				VM_BUG_ON_VMA(!rwsem_is_locked(&tlb->mm->mmap_sem), vma);
+				split_huge_pud(vma, pud, addr);
+			} else if (zap_huge_pud(tlb, vma, pud, addr))
+				goto next;
+			/* fall through */
+		}
 		if (pud_none_or_clear_bad(pud))
 			continue;
 		next = zap_pmd_range(tlb, vma, pud, addr, next, details);
+next:
+		cond_resched();
 	} while (pud++, addr = next, addr != end);
 
 	return addr;
@@ -3277,6 +3287,41 @@ static int wp_huge_pmd(struct mm_struct
 	return VM_FAULT_FALLBACK;
 }
 
+static int create_huge_pud(struct mm_struct *mm, struct vm_area_struct *vma,
+			unsigned long address, pud_t *pud, unsigned int flags)
+{
+	struct vm_fault vmf = {
+		.virtual_address = (void __user *)address,
+		.flags = flags | FAULT_FLAG_SIZE_PUD,
+		.pud = pud,
+	};
+
+	/* No support for anonymous transparent PUD pages yet */
+	if (vma_is_anonymous(vma))
+		return VM_FAULT_FALLBACK;
+	if (vma->vm_ops->huge_fault)
+		return vma->vm_ops->huge_fault(vma, &vmf);
+	return VM_FAULT_FALLBACK;
+}
+
+static int wp_huge_pud(struct mm_struct *mm, struct vm_area_struct *vma,
+			unsigned long address, pud_t *pud, pud_t orig_pud,
+			unsigned int flags)
+{
+	struct vm_fault vmf = {
+		.virtual_address = (void __user *)address,
+		.flags = flags | FAULT_FLAG_SIZE_PUD,
+		.pud = pud,
+	};
+
+	/* No support for anonymous transparent PUD pages yet */
+	if (vma_is_anonymous(vma))
+		return VM_FAULT_FALLBACK;
+	if (vma->vm_ops->huge_fault)
+		return vma->vm_ops->huge_fault(vma, &vmf);
+	return VM_FAULT_FALLBACK;
+}
+
 /*
  * These routines also need to handle stuff like marking pages dirty
  * and/or accessed for architectures that don't do it in hardware (most
@@ -3375,6 +3420,32 @@ static int __handle_mm_fault(struct mm_s
 	pud = pud_alloc(mm, pgd, address);
 	if (!pud)
 		return VM_FAULT_OOM;
+	if (pud_none(*pud) && transparent_hugepage_enabled(vma)) {
+		int ret = create_huge_pud(mm, vma, address, pud, flags);
+		if (!(ret & VM_FAULT_FALLBACK))
+			return ret;
+	} else {
+		pud_t orig_pud = *pud;
+		int ret;
+
+		barrier();
+		if (pud_trans_huge(orig_pud) || pud_devmap(orig_pud)) {
+			unsigned int dirty = flags & FAULT_FLAG_WRITE;
+
+			/* NUMA case for anonymous PUDs would go here */
+
+			if (dirty && !pud_write(orig_pud)) {
+				ret = wp_huge_pud(mm, vma, address, pud,
+							orig_pud, flags);
+				if (!(ret & VM_FAULT_FALLBACK))
+					return ret;
+			} else {
+				huge_pud_set_accessed(mm, vma, address, pud,
+						      orig_pud, dirty);
+				return 0;
+			}
+		}
+	}
 	pmd = pmd_alloc(mm, pud, address);
 	if (!pmd)
 		return VM_FAULT_OOM;
diff -puN mm/pagewalk.c~mm-add-support-for-pud-sized-transparent-hugepages mm/pagewalk.c
--- a/mm/pagewalk.c~mm-add-support-for-pud-sized-transparent-hugepages
+++ a/mm/pagewalk.c
@@ -78,14 +78,31 @@ static int walk_pud_range(pgd_t *pgd, un
 
 	pud = pud_offset(pgd, addr);
 	do {
+ again:
 		next = pud_addr_end(addr, end);
-		if (pud_none_or_clear_bad(pud)) {
+		if (pud_none(*pud) || !walk->vma) {
 			if (walk->pte_hole)
 				err = walk->pte_hole(addr, next, walk);
 			if (err)
 				break;
 			continue;
 		}
+
+		if (walk->pud_entry) {
+			spinlock_t *ptl;
+			if (pud_trans_huge_lock(pud, walk->vma, &ptl)) {
+				err = walk->pud_entry(pud, addr, next, walk);
+				spin_unlock(ptl);
+				if (err)
+					break;
+				continue;
+			}
+		}
+
+		split_huge_pud(walk->vma, pud, addr);
+		if (pud_none(*pud))
+			goto again;
+
 		if (walk->pmd_entry || walk->pte_entry)
 			err = walk_pmd_range(pud, addr, next, walk);
 		if (err)
diff -puN mm/pgtable-generic.c~mm-add-support-for-pud-sized-transparent-hugepages mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~mm-add-support-for-pud-sized-transparent-hugepages
+++ a/mm/pgtable-generic.c
@@ -96,6 +96,7 @@ pte_t ptep_clear_flush(struct vm_area_st
  * e.g. see arch/arc: flush_pmd_tlb_range
  */
 #define flush_pmd_tlb_range(vma, addr, end)	flush_tlb_range(vma, addr, end)
+#define flush_pud_tlb_range(vma, addr, end)	flush_tlb_range(vma, addr, end)
 #endif
 
 #ifndef __HAVE_ARCH_PMDP_SET_ACCESS_FLAGS
@@ -137,6 +138,19 @@ pmd_t pmdp_huge_clear_flush(struct vm_ar
 	flush_pmd_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 	return pmd;
 }
+
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+pud_t pudp_huge_clear_flush(struct vm_area_struct *vma, unsigned long address,
+			    pud_t *pudp)
+{
+	pud_t pud;
+	VM_BUG_ON(address & ~HPAGE_PUD_MASK);
+	VM_BUG_ON(!pud_trans_huge(*pudp) && !pud_devmap(*pudp));
+	pud = pudp_huge_get_and_clear(vma->vm_mm, address, pudp);
+	flush_pud_tlb_range(vma, address, address + HPAGE_PUD_SIZE);
+	return pud;
+}
+#endif
 #endif
 
 #ifndef __HAVE_ARCH_PGTABLE_DEPOSIT
_

Patches currently in -mm which might be from willy@linux.intel.com are

mm-convert-an-open-coded-vm_bug_on_vma.patch
mmfsdax-change-pmd_fault-to-huge_fault.patch
mm-add-support-for-pud-sized-transparent-hugepages.patch
mincore-add-support-for-puds.patch
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

