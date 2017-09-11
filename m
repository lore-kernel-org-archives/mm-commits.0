From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-check-pmd-migration-entry-in-common-path.patch removed from -mm tree
Date: Mon, 11 Sep 2017 12:38:26 -0700
Message-ID: <20170911193826.DcyztqnR-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48410 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751052AbdIKTib (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:38:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dave.hansen@intel.com, dnellans@nvidia.com, hpa@zytor.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, tglx@linutronix.de, vbabka@suse.cz, zi.yan@cs.rutgers.edu


The patch titled
     Subject: mm: thp: check pmd migration entry in common path
has been removed from the -mm tree.  Its filename was
     mm-thp-check-pmd-migration-entry-in-common-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zi Yan <zi.yan@cs.rutgers.edu>
Subject: mm: thp: check pmd migration entry in common path


When THP migration is being used, memory management code needs to
handle pmd migration entries properly.  This patch uses !pmd_present()
or is_swap_pmd() (depending on whether pmd_none() needs separate code
or not) to check pmd migration entries at the places where a pmd entry
is present.

Since pmd-related code uses split_huge_page(), split_huge_pmd(),
pmd_trans_huge(), pmd_trans_unstable(), or
pmd_none_or_trans_huge_or_clear_bad(), this patch:

1. adds pmd migration entry split code in split_huge_pmd(),

2. takes care of pmd migration entries whenever pmd_trans_huge() is present,

3. makes pmd_none_or_trans_huge_or_clear_bad() pmd migration entry aware.

Since split_huge_page() uses split_huge_pmd() and pmd_trans_unstable()
is equivalent to pmd_none_or_trans_huge_or_clear_bad(), we do not
change them.

Until this commit, a pmd entry should be:
1. pointing to a pte page,
2. is_swap_pmd(),
3. pmd_trans_huge(),
4. pmd_devmap(), or
5. pmd_none().

Signed-off-by: Zi Yan <zi.yan@cs.rutgers.edu>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Nellans <dnellans@nvidia.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c            |   32 ++++++++++-----
 include/asm-generic/pgtable.h |   18 ++++++++
 include/linux/huge_mm.h       |   14 +++++-
 mm/gup.c                      |   22 +++++++++-
 mm/huge_memory.c              |   65 +++++++++++++++++++++++++++++---
 mm/memcontrol.c               |    5 ++
 mm/memory.c                   |   12 ++++-
 mm/mprotect.c                 |    4 -
 mm/mremap.c                   |    2 
 9 files changed, 147 insertions(+), 27 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-thp-check-pmd-migration-entry-in-common-path fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-thp-check-pmd-migration-entry-in-common-path
+++ a/fs/proc/task_mmu.c
@@ -608,7 +608,8 @@ static int smaps_pte_range(pmd_t *pmd, u
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (ptl) {
-		smaps_pmd_entry(pmd, addr, walk);
+		if (pmd_present(*pmd))
+			smaps_pmd_entry(pmd, addr, walk);
 		spin_unlock(ptl);
 		return 0;
 	}
@@ -1012,6 +1013,9 @@ static int clear_refs_pte_range(pmd_t *p
 			goto out;
 		}
 
+		if (!pmd_present(*pmd))
+			goto out;
+
 		page = pmd_page(*pmd);
 
 		/* Clear accessed and referenced bits. */
@@ -1293,27 +1297,33 @@ static int pagemap_pmd_range(pmd_t *pmdp
 	if (ptl) {
 		u64 flags = 0, frame = 0;
 		pmd_t pmd = *pmdp;
+		struct page *page = NULL;
 
 		if ((vma->vm_flags & VM_SOFTDIRTY) || pmd_soft_dirty(pmd))
 			flags |= PM_SOFT_DIRTY;
 
-		/*
-		 * Currently pmd for thp is always present because thp
-		 * can not be swapped-out, migrated, or HWPOISONed
-		 * (split in such cases instead.)
-		 * This if-check is just to prepare for future implementation.
-		 */
 		if (pmd_present(pmd)) {
-			struct page *page = pmd_page(pmd);
-
-			if (page_mapcount(page) == 1)
-				flags |= PM_MMAP_EXCLUSIVE;
+			page = pmd_page(pmd);
 
 			flags |= PM_PRESENT;
 			if (pm->show_pfn)
 				frame = pmd_pfn(pmd) +
 					((addr & ~PMD_MASK) >> PAGE_SHIFT);
 		}
+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+		else if (is_swap_pmd(pmd)) {
+			swp_entry_t entry = pmd_to_swp_entry(pmd);
+
+			frame = swp_type(entry) |
+				(swp_offset(entry) << MAX_SWAPFILES_SHIFT);
+			flags |= PM_SWAP;
+			VM_BUG_ON(!is_pmd_migration_entry(pmd));
+			page = migration_entry_to_page(entry);
+		}
+#endif
+
+		if (page && page_mapcount(page) == 1)
+			flags |= PM_MMAP_EXCLUSIVE;
 
 		for (; addr != end; addr += PAGE_SIZE) {
 			pagemap_entry_t pme = make_pme(frame, flags);
diff -puN include/asm-generic/pgtable.h~mm-thp-check-pmd-migration-entry-in-common-path include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-thp-check-pmd-migration-entry-in-common-path
+++ a/include/asm-generic/pgtable.h
@@ -846,7 +846,23 @@ static inline int pmd_none_or_trans_huge
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	barrier();
 #endif
-	if (pmd_none(pmdval) || pmd_trans_huge(pmdval))
+	/*
+	 * !pmd_present() checks for pmd migration entries
+	 *
+	 * The complete check uses is_pmd_migration_entry() in linux/swapops.h
+	 * But using that requires moving current function and pmd_trans_unstable()
+	 * to linux/swapops.h to resovle dependency, which is too much code move.
+	 *
+	 * !pmd_present() is equivalent to is_pmd_migration_entry() currently,
+	 * because !pmd_present() pages can only be under migration not swapped
+	 * out.
+	 *
+	 * pmd_none() is preseved for future condition checks on pmd migration
+	 * entries and not confusing with this function name, although it is
+	 * redundant with !pmd_present().
+	 */
+	if (pmd_none(pmdval) || pmd_trans_huge(pmdval) ||
+		(IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION) && !pmd_present(pmdval)))
 		return 1;
 	if (unlikely(pmd_bad(pmdval))) {
 		pmd_clear_bad(pmd);
diff -puN include/linux/huge_mm.h~mm-thp-check-pmd-migration-entry-in-common-path include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-thp-check-pmd-migration-entry-in-common-path
+++ a/include/linux/huge_mm.h
@@ -147,7 +147,7 @@ void __split_huge_pmd(struct vm_area_str
 #define split_huge_pmd(__vma, __pmd, __address)				\
 	do {								\
 		pmd_t *____pmd = (__pmd);				\
-		if (pmd_trans_huge(*____pmd)				\
+		if (is_swap_pmd(*____pmd) || pmd_trans_huge(*____pmd)	\
 					|| pmd_devmap(*____pmd))	\
 			__split_huge_pmd(__vma, __pmd, __address,	\
 						false, NULL);		\
@@ -178,12 +178,18 @@ extern spinlock_t *__pmd_trans_huge_lock
 		struct vm_area_struct *vma);
 extern spinlock_t *__pud_trans_huge_lock(pud_t *pud,
 		struct vm_area_struct *vma);
+
+static inline int is_swap_pmd(pmd_t pmd)
+{
+	return !pmd_none(pmd) && !pmd_present(pmd);
+}
+
 /* mmap_sem must be held on entry */
 static inline spinlock_t *pmd_trans_huge_lock(pmd_t *pmd,
 		struct vm_area_struct *vma)
 {
 	VM_BUG_ON_VMA(!rwsem_is_locked(&vma->vm_mm->mmap_sem), vma);
-	if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd))
+	if (is_swap_pmd(*pmd) || pmd_trans_huge(*pmd) || pmd_devmap(*pmd))
 		return __pmd_trans_huge_lock(pmd, vma);
 	else
 		return NULL;
@@ -299,6 +305,10 @@ static inline void vma_adjust_trans_huge
 					 long adjust_next)
 {
 }
+static inline int is_swap_pmd(pmd_t pmd)
+{
+	return 0;
+}
 static inline spinlock_t *pmd_trans_huge_lock(pmd_t *pmd,
 		struct vm_area_struct *vma)
 {
diff -puN mm/gup.c~mm-thp-check-pmd-migration-entry-in-common-path mm/gup.c
--- a/mm/gup.c~mm-thp-check-pmd-migration-entry-in-common-path
+++ a/mm/gup.c
@@ -234,6 +234,16 @@ static struct page *follow_pmd_mask(stru
 			return page;
 		return no_page_table(vma, flags);
 	}
+retry:
+	if (!pmd_present(*pmd)) {
+		if (likely(!(flags & FOLL_MIGRATION)))
+			return no_page_table(vma, flags);
+		VM_BUG_ON(thp_migration_supported() &&
+				  !is_pmd_migration_entry(*pmd));
+		if (is_pmd_migration_entry(*pmd))
+			pmd_migration_entry_wait(mm, pmd);
+		goto retry;
+	}
 	if (pmd_devmap(*pmd)) {
 		ptl = pmd_lock(mm, pmd);
 		page = follow_devmap_pmd(vma, address, pmd, flags);
@@ -247,7 +257,15 @@ static struct page *follow_pmd_mask(stru
 	if ((flags & FOLL_NUMA) && pmd_protnone(*pmd))
 		return no_page_table(vma, flags);
 
+retry_locked:
 	ptl = pmd_lock(mm, pmd);
+	if (unlikely(!pmd_present(*pmd))) {
+		spin_unlock(ptl);
+		if (likely(!(flags & FOLL_MIGRATION)))
+			return no_page_table(vma, flags);
+		pmd_migration_entry_wait(mm, pmd);
+		goto retry_locked;
+	}
 	if (unlikely(!pmd_trans_huge(*pmd))) {
 		spin_unlock(ptl);
 		return follow_page_pte(vma, address, pmd, flags);
@@ -424,7 +442,7 @@ static int get_gate_page(struct mm_struc
 	pud = pud_offset(p4d, address);
 	BUG_ON(pud_none(*pud));
 	pmd = pmd_offset(pud, address);
-	if (pmd_none(*pmd))
+	if (!pmd_present(*pmd))
 		return -EFAULT;
 	VM_BUG_ON(pmd_trans_huge(*pmd));
 	pte = pte_offset_map(pmd, address);
@@ -1534,7 +1552,7 @@ static int gup_pmd_range(pud_t pud, unsi
 		pmd_t pmd = READ_ONCE(*pmdp);
 
 		next = pmd_addr_end(addr, end);
-		if (pmd_none(pmd))
+		if (!pmd_present(pmd))
 			return 0;
 
 		if (unlikely(pmd_trans_huge(pmd) || pmd_huge(pmd))) {
diff -puN mm/huge_memory.c~mm-thp-check-pmd-migration-entry-in-common-path mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-check-pmd-migration-entry-in-common-path
+++ a/mm/huge_memory.c
@@ -928,6 +928,23 @@ int copy_huge_pmd(struct mm_struct *dst_
 
 	ret = -EAGAIN;
 	pmd = *src_pmd;
+
+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+	if (unlikely(is_swap_pmd(pmd))) {
+		swp_entry_t entry = pmd_to_swp_entry(pmd);
+
+		VM_BUG_ON(!is_pmd_migration_entry(pmd));
+		if (is_write_migration_entry(entry)) {
+			make_migration_entry_read(&entry);
+			pmd = swp_entry_to_pmd(entry);
+			set_pmd_at(src_mm, addr, src_pmd, pmd);
+		}
+		set_pmd_at(dst_mm, addr, dst_pmd, pmd);
+		ret = 0;
+		goto out_unlock;
+	}
+#endif
+
 	if (unlikely(!pmd_trans_huge(pmd))) {
 		pte_free(dst_mm, pgtable);
 		goto out_unlock;
@@ -1599,6 +1616,12 @@ bool madvise_free_huge_pmd(struct mmu_ga
 	if (is_huge_zero_pmd(orig_pmd))
 		goto out;
 
+	if (unlikely(!pmd_present(orig_pmd))) {
+		VM_BUG_ON(thp_migration_supported() &&
+				  !is_pmd_migration_entry(orig_pmd));
+		goto out;
+	}
+
 	page = pmd_page(orig_pmd);
 	/*
 	 * If other processes are mapping this page, we couldn't discard
@@ -1810,6 +1833,25 @@ int change_huge_pmd(struct vm_area_struc
 	preserve_write = prot_numa && pmd_write(*pmd);
 	ret = 1;
 
+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+	if (is_swap_pmd(*pmd)) {
+		swp_entry_t entry = pmd_to_swp_entry(*pmd);
+
+		VM_BUG_ON(!is_pmd_migration_entry(*pmd));
+		if (is_write_migration_entry(entry)) {
+			pmd_t newpmd;
+			/*
+			 * A protection check is difficult so
+			 * just be safe and disable write
+			 */
+			make_migration_entry_read(&entry);
+			newpmd = swp_entry_to_pmd(entry);
+			set_pmd_at(mm, addr, pmd, newpmd);
+		}
+		goto unlock;
+	}
+#endif
+
 	/*
 	 * Avoid trapping faults against the zero page. The read-only
 	 * data is likely to be read-cached on the local CPU and
@@ -1875,7 +1917,8 @@ spinlock_t *__pmd_trans_huge_lock(pmd_t
 {
 	spinlock_t *ptl;
 	ptl = pmd_lock(vma->vm_mm, pmd);
-	if (likely(pmd_trans_huge(*pmd) || pmd_devmap(*pmd)))
+	if (likely(is_swap_pmd(*pmd) || pmd_trans_huge(*pmd) ||
+			pmd_devmap(*pmd)))
 		return ptl;
 	spin_unlock(ptl);
 	return NULL;
@@ -1993,14 +2036,15 @@ static void __split_huge_pmd_locked(stru
 	struct page *page;
 	pgtable_t pgtable;
 	pmd_t _pmd;
-	bool young, write, dirty, soft_dirty;
+	bool young, write, dirty, soft_dirty, pmd_migration = false;
 	unsigned long addr;
 	int i;
 
 	VM_BUG_ON(haddr & ~HPAGE_PMD_MASK);
 	VM_BUG_ON_VMA(vma->vm_start > haddr, vma);
 	VM_BUG_ON_VMA(vma->vm_end < haddr + HPAGE_PMD_SIZE, vma);
-	VM_BUG_ON(!pmd_trans_huge(*pmd) && !pmd_devmap(*pmd));
+	VM_BUG_ON(!is_pmd_migration_entry(*pmd) && !pmd_trans_huge(*pmd)
+				&& !pmd_devmap(*pmd));
 
 	count_vm_event(THP_SPLIT_PMD);
 
@@ -2025,7 +2069,16 @@ static void __split_huge_pmd_locked(stru
 		return __split_huge_zero_page_pmd(vma, haddr, pmd);
 	}
 
-	page = pmd_page(*pmd);
+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+	pmd_migration = is_pmd_migration_entry(*pmd);
+	if (pmd_migration) {
+		swp_entry_t entry;
+
+		entry = pmd_to_swp_entry(*pmd);
+		page = pfn_to_page(swp_offset(entry));
+	} else
+#endif
+		page = pmd_page(*pmd);
 	VM_BUG_ON_PAGE(!page_count(page), page);
 	page_ref_add(page, HPAGE_PMD_NR - 1);
 	write = pmd_write(*pmd);
@@ -2044,7 +2097,7 @@ static void __split_huge_pmd_locked(stru
 		 * transferred to avoid any possibility of altering
 		 * permissions across VMAs.
 		 */
-		if (freeze) {
+		if (freeze || pmd_migration) {
 			swp_entry_t swp_entry;
 			swp_entry = make_migration_entry(page + i, write);
 			entry = swp_entry_to_pte(swp_entry);
@@ -2143,7 +2196,7 @@ void __split_huge_pmd(struct vm_area_str
 		page = pmd_page(*pmd);
 		if (PageMlocked(page))
 			clear_page_mlock(page);
-	} else if (!pmd_devmap(*pmd))
+	} else if (!(pmd_devmap(*pmd) || is_pmd_migration_entry(*pmd)))
 		goto out;
 	__split_huge_pmd_locked(vma, pmd, haddr, freeze);
 out:
diff -puN mm/memcontrol.c~mm-thp-check-pmd-migration-entry-in-common-path mm/memcontrol.c
--- a/mm/memcontrol.c~mm-thp-check-pmd-migration-entry-in-common-path
+++ a/mm/memcontrol.c
@@ -4664,6 +4664,11 @@ static enum mc_target_type get_mctgt_typ
 	struct page *page = NULL;
 	enum mc_target_type ret = MC_TARGET_NONE;
 
+	if (unlikely(is_swap_pmd(pmd))) {
+		VM_BUG_ON(thp_migration_supported() &&
+				  !is_pmd_migration_entry(pmd));
+		return ret;
+	}
 	page = pmd_page(pmd);
 	VM_BUG_ON_PAGE(!page || !PageHead(page), page);
 	if (!(mc.flags & MOVE_ANON))
diff -puN mm/memory.c~mm-thp-check-pmd-migration-entry-in-common-path mm/memory.c
--- a/mm/memory.c~mm-thp-check-pmd-migration-entry-in-common-path
+++ a/mm/memory.c
@@ -1065,7 +1065,8 @@ static inline int copy_pmd_range(struct
 	src_pmd = pmd_offset(src_pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
-		if (pmd_trans_huge(*src_pmd) || pmd_devmap(*src_pmd)) {
+		if (is_swap_pmd(*src_pmd) || pmd_trans_huge(*src_pmd)
+			|| pmd_devmap(*src_pmd)) {
 			int err;
 			VM_BUG_ON_VMA(next-addr != HPAGE_PMD_SIZE, vma);
 			err = copy_huge_pmd(dst_mm, src_mm,
@@ -1326,7 +1327,7 @@ static inline unsigned long zap_pmd_rang
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
-		if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
+		if (is_swap_pmd(*pmd) || pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE) {
 				VM_BUG_ON_VMA(vma_is_anonymous(vma) &&
 				    !rwsem_is_locked(&tlb->mm->mmap_sem), vma);
@@ -3911,6 +3912,13 @@ static int __handle_mm_fault(struct vm_a
 		pmd_t orig_pmd = *vmf.pmd;
 
 		barrier();
+		if (unlikely(is_swap_pmd(orig_pmd))) {
+			VM_BUG_ON(thp_migration_supported() &&
+					  !is_pmd_migration_entry(orig_pmd));
+			if (is_pmd_migration_entry(orig_pmd))
+				pmd_migration_entry_wait(mm, vmf.pmd);
+			return 0;
+		}
 		if (pmd_trans_huge(orig_pmd) || pmd_devmap(orig_pmd)) {
 			if (pmd_protnone(orig_pmd) && vma_is_accessible(vma))
 				return do_huge_pmd_numa_page(&vmf, orig_pmd);
diff -puN mm/mprotect.c~mm-thp-check-pmd-migration-entry-in-common-path mm/mprotect.c
--- a/mm/mprotect.c~mm-thp-check-pmd-migration-entry-in-common-path
+++ a/mm/mprotect.c
@@ -149,7 +149,7 @@ static inline unsigned long change_pmd_r
 		unsigned long this_pages;
 
 		next = pmd_addr_end(addr, end);
-		if (!pmd_trans_huge(*pmd) && !pmd_devmap(*pmd)
+		if (!is_swap_pmd(*pmd) && !pmd_trans_huge(*pmd) && !pmd_devmap(*pmd)
 				&& pmd_none_or_clear_bad(pmd))
 			continue;
 
@@ -159,7 +159,7 @@ static inline unsigned long change_pmd_r
 			mmu_notifier_invalidate_range_start(mm, mni_start, end);
 		}
 
-		if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
+		if (is_swap_pmd(*pmd) || pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE) {
 				__split_huge_pmd(vma, pmd, addr, false, NULL);
 			} else {
diff -puN mm/mremap.c~mm-thp-check-pmd-migration-entry-in-common-path mm/mremap.c
--- a/mm/mremap.c~mm-thp-check-pmd-migration-entry-in-common-path
+++ a/mm/mremap.c
@@ -223,7 +223,7 @@ unsigned long move_page_tables(struct vm
 		new_pmd = alloc_new_pmd(vma->vm_mm, vma, new_addr);
 		if (!new_pmd)
 			break;
-		if (pmd_trans_huge(*old_pmd)) {
+		if (is_swap_pmd(*old_pmd) || pmd_trans_huge(*old_pmd)) {
 			if (extent == HPAGE_PMD_SIZE) {
 				bool moved;
 				/* See comment in move_ptes() */
_

Patches currently in -mm which might be from zi.yan@cs.rutgers.edu are


