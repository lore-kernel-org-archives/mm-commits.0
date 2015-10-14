From: akpm@linux-foundation.org
Subject: + mm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
 added to -mm tree
Date: Wed, 14 Oct 2015 14:13:36 -0700
Message-ID: <561ec580.HLGPene+vXO1FZtn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50247 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbbJNVNi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Oct 2015 17:13:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: remove infrastructure for handling splitting PMDs
has been added to the -mm tree.  Its filename is
     mm-thp-remove-infrastructure-for-handling-splitting-pmds.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-remove-infrastructure-for-handling-splitting-pmds.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm, thp: remove infrastructure for handling splitting PMDs

With new refcounting we don't need to mark PMDs splitting. Let's drop code
to handle this.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c            |    8 +--
 include/asm-generic/pgtable.h |    9 ----
 include/linux/huge_mm.h       |   21 ++--------
 mm/gup.c                      |   12 -----
 mm/huge_memory.c              |   67 +++++++-------------------------
 mm/memcontrol.c               |   13 ------
 mm/memory.c                   |   18 --------
 mm/mincore.c                  |    2 
 mm/mremap.c                   |   15 +++----
 mm/page_idle.c                |    3 -
 mm/pgtable-generic.c          |   14 ------
 mm/rmap.c                     |    4 -
 12 files changed, 41 insertions(+), 145 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-thp-remove-infrastructure-for-handling-splitting-pmds fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/fs/proc/task_mmu.c
@@ -564,7 +564,7 @@ static int smaps_pte_range(pmd_t *pmd, u
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
+	if (pmd_trans_huge_lock(pmd, vma, &ptl)) {
 		smaps_pmd_entry(pmd, addr, walk);
 		spin_unlock(ptl);
 		return 0;
@@ -852,7 +852,7 @@ static int clear_refs_pte_range(pmd_t *p
 	spinlock_t *ptl;
 	struct page *page;
 
-	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
+	if (pmd_trans_huge_lock(pmd, vma, &ptl)) {
 		if (cp->type == CLEAR_REFS_SOFT_DIRTY) {
 			clear_soft_dirty_pmd(vma, addr, pmd);
 			goto out;
@@ -1126,7 +1126,7 @@ static int pagemap_pmd_range(pmd_t *pmdp
 	int err = 0;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (pmd_trans_huge_lock(pmdp, vma, &ptl) == 1) {
+	if (pmd_trans_huge_lock(pmdp, vma, &ptl)) {
 		u64 flags = 0, frame = 0;
 		pmd_t pmd = *pmdp;
 
@@ -1458,7 +1458,7 @@ static int gather_pte_stats(pmd_t *pmd,
 	pte_t *orig_pte;
 	pte_t *pte;
 
-	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
+	if (pmd_trans_huge_lock(pmd, vma, &ptl)) {
 		pte_t huge_pte = *(pte_t *)pmd;
 		struct page *page;
 
diff -puN include/asm-generic/pgtable.h~mm-thp-remove-infrastructure-for-handling-splitting-pmds include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/include/asm-generic/pgtable.h
@@ -184,11 +184,6 @@ static inline void pmdp_set_wrprotect(st
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
-#ifndef __HAVE_ARCH_PMDP_SPLITTING_FLUSH
-extern void pmdp_splitting_flush(struct vm_area_struct *vma,
-				 unsigned long address, pmd_t *pmdp);
-#endif
-
 #ifndef pmdp_collapse_flush
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern pmd_t pmdp_collapse_flush(struct vm_area_struct *vma,
@@ -586,10 +581,6 @@ static inline int pmd_trans_huge(pmd_t p
 {
 	return 0;
 }
-static inline int pmd_trans_splitting(pmd_t pmd)
-{
-	return 0;
-}
 #ifndef __HAVE_ARCH_PMD_WRITE
 static inline int pmd_write(pmd_t pmd)
 {
diff -puN include/linux/huge_mm.h~mm-thp-remove-infrastructure-for-handling-splitting-pmds include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/include/linux/huge_mm.h
@@ -25,7 +25,7 @@ extern int zap_huge_pmd(struct mmu_gathe
 extern int mincore_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 			unsigned long addr, unsigned long end,
 			unsigned char *vec);
-extern int move_huge_pmd(struct vm_area_struct *vma,
+extern bool move_huge_pmd(struct vm_area_struct *vma,
 			 struct vm_area_struct *new_vma,
 			 unsigned long old_addr,
 			 unsigned long new_addr, unsigned long old_end,
@@ -48,15 +48,9 @@ enum transparent_hugepage_flag {
 #endif
 };
 
-enum page_check_address_pmd_flag {
-	PAGE_CHECK_ADDRESS_PMD_FLAG,
-	PAGE_CHECK_ADDRESS_PMD_NOTSPLITTING_FLAG,
-	PAGE_CHECK_ADDRESS_PMD_SPLITTING_FLAG,
-};
 extern pmd_t *page_check_address_pmd(struct page *page,
 				     struct mm_struct *mm,
 				     unsigned long address,
-				     enum page_check_address_pmd_flag flag,
 				     spinlock_t **ptl);
 
 #define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
@@ -100,7 +94,6 @@ extern unsigned long transparent_hugepag
 #define split_huge_page(page) BUILD_BUG()
 #define split_huge_pmd(__vma, __pmd, __address) BUILD_BUG()
 
-#define wait_split_huge_page(__anon_vma, __pmd) BUILD_BUG()
 #if HPAGE_PMD_ORDER >= MAX_ORDER
 #error "hugepages can't be allocated by the buddy allocator"
 #endif
@@ -110,17 +103,17 @@ extern void vma_adjust_trans_huge(struct
 				    unsigned long start,
 				    unsigned long end,
 				    long adjust_next);
-extern int __pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma,
+extern bool __pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma,
 		spinlock_t **ptl);
 /* mmap_sem must be held on entry */
-static inline int pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma,
+static inline bool pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma,
 		spinlock_t **ptl)
 {
 	VM_BUG_ON_VMA(!rwsem_is_locked(&vma->vm_mm->mmap_sem), vma);
 	if (pmd_trans_huge(*pmd))
 		return __pmd_trans_huge_lock(pmd, vma, ptl);
 	else
-		return 0;
+		return false;
 }
 static inline int hpage_nr_pages(struct page *page)
 {
@@ -165,8 +158,6 @@ static inline int split_huge_page(struct
 {
 	return 0;
 }
-#define wait_split_huge_page(__anon_vma, __pmd)	\
-	do { } while (0)
 #define split_huge_pmd(__vma, __pmd, __address)	\
 	do { } while (0)
 static inline int hugepage_madvise(struct vm_area_struct *vma,
@@ -181,10 +172,10 @@ static inline void vma_adjust_trans_huge
 					 long adjust_next)
 {
 }
-static inline int pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma,
+static inline bool pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma,
 		spinlock_t **ptl)
 {
-	return 0;
+	return false;
 }
 
 static inline int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
diff -puN mm/gup.c~mm-thp-remove-infrastructure-for-handling-splitting-pmds mm/gup.c
--- a/mm/gup.c~mm-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/mm/gup.c
@@ -241,13 +241,6 @@ struct page *follow_page_mask(struct vm_
 		spin_unlock(ptl);
 		return follow_page_pte(vma, address, pmd, flags);
 	}
-
-	if (unlikely(pmd_trans_splitting(*pmd))) {
-		spin_unlock(ptl);
-		wait_split_huge_page(vma->anon_vma, pmd);
-		return follow_page_pte(vma, address, pmd, flags);
-	}
-
 	if (flags & FOLL_SPLIT) {
 		int ret;
 		page = pmd_page(*pmd);
@@ -1068,9 +1061,6 @@ struct page *get_dump_page(unsigned long
  *  *) HAVE_RCU_TABLE_FREE is enabled, and tlb_remove_table is used to free
  *      pages containing page tables.
  *
- *  *) THP splits will broadcast an IPI, this can be achieved by overriding
- *      pmdp_splitting_flush.
- *
  *  *) ptes can be read atomically by the architecture.
  *
  *  *) access_ok is sufficient to validate userspace address ranges.
@@ -1267,7 +1257,7 @@ static int gup_pmd_range(pud_t pud, unsi
 		pmd_t pmd = READ_ONCE(*pmdp);
 
 		next = pmd_addr_end(addr, end);
-		if (pmd_none(pmd) || pmd_trans_splitting(pmd))
+		if (pmd_none(pmd))
 			return 0;
 
 		if (unlikely(pmd_trans_huge(pmd) || pmd_huge(pmd))) {
diff -puN mm/huge_memory.c~mm-thp-remove-infrastructure-for-handling-splitting-pmds mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/mm/huge_memory.c
@@ -1017,15 +1017,6 @@ int copy_huge_pmd(struct mm_struct *dst_
 		goto out_unlock;
 	}
 
-	if (unlikely(pmd_trans_splitting(pmd))) {
-		/* split huge page running from under us */
-		spin_unlock(src_ptl);
-		spin_unlock(dst_ptl);
-		pte_free(dst_mm, pgtable);
-
-		wait_split_huge_page(vma->anon_vma, src_pmd); /* src_vma */
-		goto out;
-	}
 	src_page = pmd_page(pmd);
 	VM_BUG_ON_PAGE(!PageHead(src_page), src_page);
 	get_page(src_page);
@@ -1501,7 +1492,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 	pmd_t orig_pmd;
 	spinlock_t *ptl;
 
-	if (__pmd_trans_huge_lock(pmd, vma, &ptl) != 1)
+	if (!__pmd_trans_huge_lock(pmd, vma, &ptl))
 		return 0;
 	/*
 	 * For architectures like ppc64 we look at deposited pgtable
@@ -1535,13 +1526,12 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 	return 1;
 }
 
-int move_huge_pmd(struct vm_area_struct *vma, struct vm_area_struct *new_vma,
+bool move_huge_pmd(struct vm_area_struct *vma, struct vm_area_struct *new_vma,
 		  unsigned long old_addr,
 		  unsigned long new_addr, unsigned long old_end,
 		  pmd_t *old_pmd, pmd_t *new_pmd)
 {
 	spinlock_t *old_ptl, *new_ptl;
-	int ret = 0;
 	pmd_t pmd;
 
 	struct mm_struct *mm = vma->vm_mm;
@@ -1550,7 +1540,7 @@ int move_huge_pmd(struct vm_area_struct
 	    (new_addr & ~HPAGE_PMD_MASK) ||
 	    old_end - old_addr < HPAGE_PMD_SIZE ||
 	    (new_vma->vm_flags & VM_NOHUGEPAGE))
-		goto out;
+		return false;
 
 	/*
 	 * The destination pmd shouldn't be established, free_pgtables()
@@ -1558,15 +1548,14 @@ int move_huge_pmd(struct vm_area_struct
 	 */
 	if (WARN_ON(!pmd_none(*new_pmd))) {
 		VM_BUG_ON(pmd_trans_huge(*new_pmd));
-		goto out;
+		return false;
 	}
 
 	/*
 	 * We don't have to worry about the ordering of src and dst
 	 * ptlocks because exclusive mmap_sem prevents deadlock.
 	 */
-	ret = __pmd_trans_huge_lock(old_pmd, vma, &old_ptl);
-	if (ret == 1) {
+	if (__pmd_trans_huge_lock(old_pmd, vma, &old_ptl)) {
 		new_ptl = pmd_lockptr(mm, new_pmd);
 		if (new_ptl != old_ptl)
 			spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
@@ -1582,9 +1571,9 @@ int move_huge_pmd(struct vm_area_struct
 		if (new_ptl != old_ptl)
 			spin_unlock(new_ptl);
 		spin_unlock(old_ptl);
+		return true;
 	}
-out:
-	return ret;
+	return false;
 }
 
 /*
@@ -1600,7 +1589,7 @@ int change_huge_pmd(struct vm_area_struc
 	spinlock_t *ptl;
 	int ret = 0;
 
-	if (__pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
+	if (__pmd_trans_huge_lock(pmd, vma, &ptl)) {
 		pmd_t entry;
 		bool preserve_write = prot_numa && pmd_write(*pmd);
 		ret = 1;
@@ -1631,29 +1620,19 @@ int change_huge_pmd(struct vm_area_struc
 }
 
 /*
- * Returns 1 if a given pmd maps a stable (not under splitting) thp.
- * Returns -1 if it maps a thp under splitting. Returns 0 otherwise.
+ * Returns true if a given pmd maps a thp, false otherwise.
  *
- * Note that if it returns 1, this routine returns without unlocking page
- * table locks. So callers must unlock them.
+ * Note that if it returns true, this routine returns without unlocking page
+ * table lock. So callers must unlock it.
  */
-int __pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma,
+bool __pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma,
 		spinlock_t **ptl)
 {
 	*ptl = pmd_lock(vma->vm_mm, pmd);
-	if (likely(pmd_trans_huge(*pmd))) {
-		if (unlikely(pmd_trans_splitting(*pmd))) {
-			spin_unlock(*ptl);
-			wait_split_huge_page(vma->anon_vma, pmd);
-			return -1;
-		} else {
-			/* Thp mapped by 'pmd' is stable, so we can
-			 * handle it as it is. */
-			return 1;
-		}
-	}
+	if (likely(pmd_trans_huge(*pmd)))
+		return true;
 	spin_unlock(*ptl);
-	return 0;
+	return false;
 }
 
 /*
@@ -1667,7 +1646,6 @@ int __pmd_trans_huge_lock(pmd_t *pmd, st
 pmd_t *page_check_address_pmd(struct page *page,
 			      struct mm_struct *mm,
 			      unsigned long address,
-			      enum page_check_address_pmd_flag flag,
 			      spinlock_t **ptl)
 {
 	pgd_t *pgd;
@@ -1690,21 +1668,8 @@ pmd_t *page_check_address_pmd(struct pag
 		goto unlock;
 	if (pmd_page(*pmd) != page)
 		goto unlock;
-	/*
-	 * split_vma() may create temporary aliased mappings. There is
-	 * no risk as long as all huge pmd are found and have their
-	 * splitting bit set before __split_huge_page_refcount
-	 * runs. Finding the same huge pmd more than once during the
-	 * same rmap walk is not a problem.
-	 */
-	if (flag == PAGE_CHECK_ADDRESS_PMD_NOTSPLITTING_FLAG &&
-	    pmd_trans_splitting(*pmd))
-		goto unlock;
-	if (pmd_trans_huge(*pmd)) {
-		VM_BUG_ON(flag == PAGE_CHECK_ADDRESS_PMD_SPLITTING_FLAG &&
-			  !pmd_trans_splitting(*pmd));
+	if (pmd_trans_huge(*pmd))
 		return pmd;
-	}
 unlock:
 	spin_unlock(*ptl);
 	return NULL;
diff -puN mm/memcontrol.c~mm-thp-remove-infrastructure-for-handling-splitting-pmds mm/memcontrol.c
--- a/mm/memcontrol.c~mm-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/mm/memcontrol.c
@@ -4674,7 +4674,7 @@ static int mem_cgroup_count_precharge_pt
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
+	if (pmd_trans_huge_lock(pmd, vma, &ptl)) {
 		if (get_mctgt_type_thp(vma, addr, *pmd, NULL) == MC_TARGET_PAGE)
 			mc.precharge += HPAGE_PMD_NR;
 		spin_unlock(ptl);
@@ -4845,16 +4845,7 @@ static int mem_cgroup_move_charge_pte_ra
 	union mc_target target;
 	struct page *page;
 
-	/*
-	 * No race with splitting thp happens because:
-	 *  - if pmd_trans_huge_lock() returns 1, the relevant thp is not
-	 *    under splitting, which means there's no concurrent thp split,
-	 *  - if another thread runs into split_huge_page() just after we
-	 *    entered this if-block, the thread must wait for page table lock
-	 *    to be unlocked in __split_huge_page_splitting(), where the main
-	 *    part of thp split is not executed yet.
-	 */
-	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
+	if (pmd_trans_huge_lock(pmd, vma, &ptl)) {
 		if (mc.precharge < HPAGE_PMD_NR) {
 			spin_unlock(ptl);
 			return 0;
diff -puN mm/memory.c~mm-thp-remove-infrastructure-for-handling-splitting-pmds mm/memory.c
--- a/mm/memory.c~mm-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/mm/memory.c
@@ -566,7 +566,6 @@ int __pte_alloc(struct mm_struct *mm, st
 {
 	spinlock_t *ptl;
 	pgtable_t new = pte_alloc_one(mm, address);
-	int wait_split_huge_page;
 	if (!new)
 		return -ENOMEM;
 
@@ -586,18 +585,14 @@ int __pte_alloc(struct mm_struct *mm, st
 	smp_wmb(); /* Could be smp_wmb__xxx(before|after)_spin_lock */
 
 	ptl = pmd_lock(mm, pmd);
-	wait_split_huge_page = 0;
 	if (likely(pmd_none(*pmd))) {	/* Has another populated it ? */
 		atomic_long_inc(&mm->nr_ptes);
 		pmd_populate(mm, pmd, new);
 		new = NULL;
-	} else if (unlikely(pmd_trans_splitting(*pmd)))
-		wait_split_huge_page = 1;
+	}
 	spin_unlock(ptl);
 	if (new)
 		pte_free(mm, new);
-	if (wait_split_huge_page)
-		wait_split_huge_page(vma->anon_vma, pmd);
 	return 0;
 }
 
@@ -613,8 +608,7 @@ int __pte_alloc_kernel(pmd_t *pmd, unsig
 	if (likely(pmd_none(*pmd))) {	/* Has another populated it ? */
 		pmd_populate_kernel(&init_mm, pmd, new);
 		new = NULL;
-	} else
-		VM_BUG_ON(pmd_trans_splitting(*pmd));
+	}
 	spin_unlock(&init_mm.page_table_lock);
 	if (new)
 		pte_free_kernel(&init_mm, new);
@@ -3367,14 +3361,6 @@ static int __handle_mm_fault(struct mm_s
 		if (pmd_trans_huge(orig_pmd)) {
 			unsigned int dirty = flags & FAULT_FLAG_WRITE;
 
-			/*
-			 * If the pmd is splitting, return and retry the
-			 * the fault.  Alternative: wait until the split
-			 * is done, and goto retry.
-			 */
-			if (pmd_trans_splitting(orig_pmd))
-				return 0;
-
 			if (pmd_protnone(orig_pmd))
 				return do_huge_pmd_numa_page(mm, vma, address,
 							     orig_pmd, pmd);
diff -puN mm/mincore.c~mm-thp-remove-infrastructure-for-handling-splitting-pmds mm/mincore.c
--- a/mm/mincore.c~mm-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/mm/mincore.c
@@ -117,7 +117,7 @@ static int mincore_pte_range(pmd_t *pmd,
 	unsigned char *vec = walk->private;
 	int nr = (end - addr) >> PAGE_SHIFT;
 
-	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
+	if (pmd_trans_huge_lock(pmd, vma, &ptl)) {
 		memset(vec, 1, nr);
 		spin_unlock(ptl);
 		goto out;
diff -puN mm/mremap.c~mm-thp-remove-infrastructure-for-handling-splitting-pmds mm/mremap.c
--- a/mm/mremap.c~mm-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/mm/mremap.c
@@ -192,25 +192,24 @@ unsigned long move_page_tables(struct vm
 		if (!new_pmd)
 			break;
 		if (pmd_trans_huge(*old_pmd)) {
-			int err = 0;
 			if (extent == HPAGE_PMD_SIZE) {
+				bool moved;
 				VM_BUG_ON_VMA(vma->vm_file || !vma->anon_vma,
 					      vma);
 				/* See comment in move_ptes() */
 				if (need_rmap_locks)
 					anon_vma_lock_write(vma->anon_vma);
-				err = move_huge_pmd(vma, new_vma, old_addr,
+				moved = move_huge_pmd(vma, new_vma, old_addr,
 						    new_addr, old_end,
 						    old_pmd, new_pmd);
 				if (need_rmap_locks)
 					anon_vma_unlock_write(vma->anon_vma);
+				if (moved) {
+					need_flush = true;
+					continue;
+				}
 			}
-			if (err > 0) {
-				need_flush = true;
-				continue;
-			} else if (!err) {
-				split_huge_pmd(vma, old_pmd, old_addr);
-			}
+			split_huge_pmd(vma, old_pmd, old_addr);
 			VM_BUG_ON(pmd_trans_huge(*old_pmd));
 		}
 		if (pmd_none(*new_pmd) && __pte_alloc(new_vma->vm_mm, new_vma,
diff -puN mm/page_idle.c~mm-thp-remove-infrastructure-for-handling-splitting-pmds mm/page_idle.c
--- a/mm/page_idle.c~mm-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/mm/page_idle.c
@@ -61,8 +61,7 @@ static int page_idle_clear_pte_refs_one(
 	bool referenced = false;
 
 	if (unlikely(PageTransHuge(page))) {
-		pmd = page_check_address_pmd(page, mm, addr,
-					     PAGE_CHECK_ADDRESS_PMD_FLAG, &ptl);
+		pmd = page_check_address_pmd(page, mm, addr, &ptl);
 		if (pmd) {
 			referenced = pmdp_clear_young_notify(vma, addr, pmd);
 			spin_unlock(ptl);
diff -puN mm/pgtable-generic.c~mm-thp-remove-infrastructure-for-handling-splitting-pmds mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~mm-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/mm/pgtable-generic.c
@@ -134,20 +134,6 @@ pmd_t pmdp_huge_clear_flush(struct vm_ar
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
-#ifndef __HAVE_ARCH_PMDP_SPLITTING_FLUSH
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-void pmdp_splitting_flush(struct vm_area_struct *vma, unsigned long address,
-			  pmd_t *pmdp)
-{
-	pmd_t pmd = pmd_mksplitting(*pmdp);
-	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
-	set_pmd_at(vma->vm_mm, address, pmdp, pmd);
-	/* tlb flush only to serialize against gup-fast */
-	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
-}
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-#endif
-
 #ifndef __HAVE_ARCH_PGTABLE_DEPOSIT
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
diff -puN mm/rmap.c~mm-thp-remove-infrastructure-for-handling-splitting-pmds mm/rmap.c
--- a/mm/rmap.c~mm-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/mm/rmap.c
@@ -841,8 +841,7 @@ static int page_referenced_one(struct pa
 		 * rmap might return false positives; we must filter
 		 * these out using page_check_address_pmd().
 		 */
-		pmd = page_check_address_pmd(page, mm, address,
-					     PAGE_CHECK_ADDRESS_PMD_FLAG, &ptl);
+		pmd = page_check_address_pmd(page, mm, address, &ptl);
 		if (!pmd)
 			return SWAP_AGAIN;
 
@@ -852,7 +851,6 @@ static int page_referenced_one(struct pa
 			return SWAP_FAIL; /* To break the loop */
 		}
 
-		/* go ahead even if the pmd is pmd_trans_splitting() */
 		if (pmdp_clear_flush_young_notify(vma, address, pmd))
 			referenced++;
 		spin_unlock(ptl);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

rcu-force-alignment-on-struct-callback_head-rcu_head.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch
mm-make-compound_head-robust.patch
mm-make-compound_head-robust-fix.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-move-code-around.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages-fix.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-at-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-proc-adjust-pss-calculation.patch
rmap-add-argument-to-charge-compound-page.patch
memcg-adjust-to-support-new-thp-refcounting.patch
mm-thp-adjust-conditions-when-we-can-reuse-the-page-on-wp-fault.patch
mm-adjust-foll_split-for-new-refcounting.patch
mm-handle-pte-mapped-tail-pages-in-gerneric-fast-gup-implementaiton.patch
thp-mlock-do-not-allow-huge-pages-in-mlocked-area.patch
khugepaged-ignore-pmd-tables-with-thp-mapped-with-ptes.patch
thp-rename-split_huge_page_pmd-to-split_huge_pmd.patch
mm-vmstats-new-thp-splitting-event.patch
mm-temporally-mark-thp-broken.patch
thp-drop-all-split_huge_page-related-code.patch
mm-drop-tail-page-refcounting.patch
futex-thp-remove-special-case-for-thp-in-get_futex_key.patch
ksm-prepare-to-new-thp-semantics.patch
mm-thp-remove-compound_lock.patch
arm64-thp-remove-infrastructure-for-handling-splitting-pmds.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mips-thp-remove-infrastructure-for-handling-splitting-pmds.patch
powerpc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
s390-thp-remove-infrastructure-for-handling-splitting-pmds.patch
sparc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
tile-thp-remove-infrastructure-for-handling-splitting-pmds.patch
x86-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps.patch
mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages.patch
mm-numa-skip-pte-mapped-thp-on-numa-fault.patch
thp-implement-split_huge_pmd.patch
thp-add-option-to-setup-migration-entries-during-pmd-split.patch
thp-mm-split_huge_page-caller-need-to-lock-page.patch
thp-reintroduce-split_huge_page.patch
migrate_pages-try-to-split-pages-on-qeueuing.patch
thp-introduce-deferred_split_huge_page.patch
mm-re-enable-thp.patch
thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-support-madvisemadv_free-fix-3.patch

