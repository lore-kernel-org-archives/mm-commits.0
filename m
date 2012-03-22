From: akpm@linux-foundation.org
Subject: [merged] thp-optimize-away-unnecessary-page-table-locking.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:18:02 -0700
Message-ID: <20120322201802.60BBFA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:33426 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab2CVUSD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:18:03 -0400
Received: by mail-gx0-f202.google.com with SMTP id d2so401419ggn.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:18:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, andi@firstfloor.org, fengguang.wu@intel.com, jslaby@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: optimize away unnecessary page table locking
has been removed from the -mm tree.  Its filename was
     thp-optimize-away-unnecessary-page-table-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: thp: optimize away unnecessary page table locking

Currently when we check if we can handle thp as it is or we need to split
it into regular sized pages, we hold page table lock prior to check
whether a given pmd is mapping thp or not.  Because of this, when it's not
"huge pmd" we suffer from unnecessary lock/unlock overhead.  To remove it,
this patch introduces a optimized check function and replace several
similar logics with it.

[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c      |   71 +++++++--------------
 include/linux/huge_mm.h |   17 +++++
 mm/huge_memory.c        |  125 +++++++++++++++++---------------------
 3 files changed, 100 insertions(+), 113 deletions(-)

diff -puN fs/proc/task_mmu.c~thp-optimize-away-unnecessary-page-table-locking fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~thp-optimize-away-unnecessary-page-table-locking
+++ a/fs/proc/task_mmu.c
@@ -394,20 +394,11 @@ static int smaps_pte_range(pmd_t *pmd, u
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	spin_lock(&walk->mm->page_table_lock);
-	if (pmd_trans_huge(*pmd)) {
-		if (pmd_trans_splitting(*pmd)) {
-			spin_unlock(&walk->mm->page_table_lock);
-			wait_split_huge_page(vma->anon_vma, pmd);
-		} else {
-			smaps_pte_entry(*(pte_t *)pmd, addr,
-					HPAGE_PMD_SIZE, walk);
-			spin_unlock(&walk->mm->page_table_lock);
-			mss->anonymous_thp += HPAGE_PMD_SIZE;
-			return 0;
-		}
-	} else {
+	if (pmd_trans_huge_lock(pmd, vma) == 1) {
+		smaps_pte_entry(*(pte_t *)pmd, addr, HPAGE_PMD_SIZE, walk);
 		spin_unlock(&walk->mm->page_table_lock);
+		mss->anonymous_thp += HPAGE_PMD_SIZE;
+		return 0;
 	}
 
 	if (pmd_trans_unstable(pmd))
@@ -705,26 +696,19 @@ static int pagemap_pte_range(pmd_t *pmd,
 	/* find the first VMA at or above 'addr' */
 	vma = find_vma(walk->mm, addr);
 	spin_lock(&walk->mm->page_table_lock);
-	if (pmd_trans_huge(*pmd)) {
-		if (pmd_trans_splitting(*pmd)) {
-			spin_unlock(&walk->mm->page_table_lock);
-			wait_split_huge_page(vma->anon_vma, pmd);
-		} else {
-			for (; addr != end; addr += PAGE_SIZE) {
-				unsigned long offset;
-
-				offset = (addr & ~PAGEMAP_WALK_MASK) >>
-						PAGE_SHIFT;
-				pfn = thp_pmd_to_pagemap_entry(*pmd, offset);
-				err = add_to_pagemap(addr, pfn, pm);
-				if (err)
-					break;
-			}
-			spin_unlock(&walk->mm->page_table_lock);
-			return err;
+	if (pmd_trans_huge_lock(pmd, vma) == 1) {
+		for (; addr != end; addr += PAGE_SIZE) {
+			unsigned long offset;
+
+			offset = (addr & ~PAGEMAP_WALK_MASK) >>
+					PAGE_SHIFT;
+			pfn = thp_pmd_to_pagemap_entry(*pmd, offset);
+			err = add_to_pagemap(addr, pfn, pm);
+			if (err)
+				break;
 		}
-	} else {
 		spin_unlock(&walk->mm->page_table_lock);
+		return err;
 	}
 
 	for (; addr != end; addr += PAGE_SIZE) {
@@ -992,24 +976,17 @@ static int gather_pte_stats(pmd_t *pmd, 
 	pte_t *pte;
 
 	md = walk->private;
-	spin_lock(&walk->mm->page_table_lock);
-	if (pmd_trans_huge(*pmd)) {
-		if (pmd_trans_splitting(*pmd)) {
-			spin_unlock(&walk->mm->page_table_lock);
-			wait_split_huge_page(md->vma->anon_vma, pmd);
-		} else {
-			pte_t huge_pte = *(pte_t *)pmd;
-			struct page *page;
 
-			page = can_gather_numa_stats(huge_pte, md->vma, addr);
-			if (page)
-				gather_stats(page, md, pte_dirty(huge_pte),
-						HPAGE_PMD_SIZE/PAGE_SIZE);
-			spin_unlock(&walk->mm->page_table_lock);
-			return 0;
-		}
-	} else {
+	if (pmd_trans_huge_lock(pmd, md->vma) == 1) {
+		pte_t huge_pte = *(pte_t *)pmd;
+		struct page *page;
+
+		page = can_gather_numa_stats(huge_pte, md->vma, addr);
+		if (page)
+			gather_stats(page, md, pte_dirty(huge_pte),
+				     HPAGE_PMD_SIZE/PAGE_SIZE);
 		spin_unlock(&walk->mm->page_table_lock);
+		return 0;
 	}
 
 	if (pmd_trans_unstable(pmd))
diff -puN include/linux/huge_mm.h~thp-optimize-away-unnecessary-page-table-locking include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-optimize-away-unnecessary-page-table-locking
+++ a/include/linux/huge_mm.h
@@ -113,6 +113,18 @@ extern void __vma_adjust_trans_huge(stru
 				    unsigned long start,
 				    unsigned long end,
 				    long adjust_next);
+extern int __pmd_trans_huge_lock(pmd_t *pmd,
+				 struct vm_area_struct *vma);
+/* mmap_sem must be held on entry */
+static inline int pmd_trans_huge_lock(pmd_t *pmd,
+				      struct vm_area_struct *vma)
+{
+	VM_BUG_ON(!rwsem_is_locked(&vma->vm_mm->mmap_sem));
+	if (pmd_trans_huge(*pmd))
+		return __pmd_trans_huge_lock(pmd, vma);
+	else
+		return 0;
+}
 static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
 					 unsigned long start,
 					 unsigned long end,
@@ -176,6 +188,11 @@ static inline void vma_adjust_trans_huge
 					 long adjust_next)
 {
 }
+static inline int pmd_trans_huge_lock(pmd_t *pmd,
+				      struct vm_area_struct *vma)
+{
+	return 0;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #endif /* _LINUX_HUGE_MM_H */
diff -puN mm/huge_memory.c~thp-optimize-away-unnecessary-page-table-locking mm/huge_memory.c
--- a/mm/huge_memory.c~thp-optimize-away-unnecessary-page-table-locking
+++ a/mm/huge_memory.c
@@ -1031,32 +1031,23 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 {
 	int ret = 0;
 
-	spin_lock(&tlb->mm->page_table_lock);
-	if (likely(pmd_trans_huge(*pmd))) {
-		if (unlikely(pmd_trans_splitting(*pmd))) {
-			spin_unlock(&tlb->mm->page_table_lock);
-			wait_split_huge_page(vma->anon_vma,
-					     pmd);
-		} else {
-			struct page *page;
-			pgtable_t pgtable;
-			pgtable = get_pmd_huge_pte(tlb->mm);
-			page = pmd_page(*pmd);
-			pmd_clear(pmd);
-			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
-			page_remove_rmap(page);
-			VM_BUG_ON(page_mapcount(page) < 0);
-			add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
-			VM_BUG_ON(!PageHead(page));
-			tlb->mm->nr_ptes--;
-			spin_unlock(&tlb->mm->page_table_lock);
-			tlb_remove_page(tlb, page);
-			pte_free(tlb->mm, pgtable);
-			ret = 1;
-		}
-	} else
+	if (__pmd_trans_huge_lock(pmd, vma) == 1) {
+		struct page *page;
+		pgtable_t pgtable;
+		pgtable = get_pmd_huge_pte(tlb->mm);
+		page = pmd_page(*pmd);
+		pmd_clear(pmd);
+		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
+		page_remove_rmap(page);
+		VM_BUG_ON(page_mapcount(page) < 0);
+		add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
+		VM_BUG_ON(!PageHead(page));
+		tlb->mm->nr_ptes--;
 		spin_unlock(&tlb->mm->page_table_lock);
-
+		tlb_remove_page(tlb, page);
+		pte_free(tlb->mm, pgtable);
+		ret = 1;
+	}
 	return ret;
 }
 
@@ -1066,21 +1057,15 @@ int mincore_huge_pmd(struct vm_area_stru
 {
 	int ret = 0;
 
-	spin_lock(&vma->vm_mm->page_table_lock);
-	if (likely(pmd_trans_huge(*pmd))) {
-		ret = !pmd_trans_splitting(*pmd);
-		spin_unlock(&vma->vm_mm->page_table_lock);
-		if (unlikely(!ret))
-			wait_split_huge_page(vma->anon_vma, pmd);
-		else {
-			/*
-			 * All logical pages in the range are present
-			 * if backed by a huge page.
-			 */
-			memset(vec, 1, (end - addr) >> PAGE_SHIFT);
-		}
-	} else
+	if (__pmd_trans_huge_lock(pmd, vma) == 1) {
+		/*
+		 * All logical pages in the range are present
+		 * if backed by a huge page.
+		 */
 		spin_unlock(&vma->vm_mm->page_table_lock);
+		memset(vec, 1, (end - addr) >> PAGE_SHIFT);
+		ret = 1;
+	}
 
 	return ret;
 }
@@ -1110,20 +1095,11 @@ int move_huge_pmd(struct vm_area_struct 
 		goto out;
 	}
 
-	spin_lock(&mm->page_table_lock);
-	if (likely(pmd_trans_huge(*old_pmd))) {
-		if (pmd_trans_splitting(*old_pmd)) {
-			spin_unlock(&mm->page_table_lock);
-			wait_split_huge_page(vma->anon_vma, old_pmd);
-			ret = -1;
-		} else {
-			pmd = pmdp_get_and_clear(mm, old_addr, old_pmd);
-			VM_BUG_ON(!pmd_none(*new_pmd));
-			set_pmd_at(mm, new_addr, new_pmd, pmd);
-			spin_unlock(&mm->page_table_lock);
-			ret = 1;
-		}
-	} else {
+	ret = __pmd_trans_huge_lock(old_pmd, vma);
+	if (ret == 1) {
+		pmd = pmdp_get_and_clear(mm, old_addr, old_pmd);
+		VM_BUG_ON(!pmd_none(*new_pmd));
+		set_pmd_at(mm, new_addr, new_pmd, pmd);
 		spin_unlock(&mm->page_table_lock);
 	}
 out:
@@ -1136,24 +1112,41 @@ int change_huge_pmd(struct vm_area_struc
 	struct mm_struct *mm = vma->vm_mm;
 	int ret = 0;
 
-	spin_lock(&mm->page_table_lock);
+	if (__pmd_trans_huge_lock(pmd, vma) == 1) {
+		pmd_t entry;
+		entry = pmdp_get_and_clear(mm, addr, pmd);
+		entry = pmd_modify(entry, newprot);
+		set_pmd_at(mm, addr, pmd, entry);
+		spin_unlock(&vma->vm_mm->page_table_lock);
+		ret = 1;
+	}
+
+	return ret;
+}
+
+/*
+ * Returns 1 if a given pmd maps a stable (not under splitting) thp.
+ * Returns -1 if it maps a thp under splitting. Returns 0 otherwise.
+ *
+ * Note that if it returns 1, this routine returns without unlocking page
+ * table locks. So callers must unlock them.
+ */
+int __pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma)
+{
+	spin_lock(&vma->vm_mm->page_table_lock);
 	if (likely(pmd_trans_huge(*pmd))) {
 		if (unlikely(pmd_trans_splitting(*pmd))) {
-			spin_unlock(&mm->page_table_lock);
+			spin_unlock(&vma->vm_mm->page_table_lock);
 			wait_split_huge_page(vma->anon_vma, pmd);
+			return -1;
 		} else {
-			pmd_t entry;
-
-			entry = pmdp_get_and_clear(mm, addr, pmd);
-			entry = pmd_modify(entry, newprot);
-			set_pmd_at(mm, addr, pmd, entry);
-			spin_unlock(&vma->vm_mm->page_table_lock);
-			ret = 1;
+			/* Thp mapped by 'pmd' is stable, so we can
+			 * handle it as it is. */
+			return 1;
 		}
-	} else
-		spin_unlock(&vma->vm_mm->page_table_lock);
