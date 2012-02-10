From: akpm@linux-foundation.org
Subject: + thp-optimize-away-unnecessary-page-table-locking.patch added to -mm tree
Date: Thu, 09 Feb 2012 16:28:03 -0800
Message-ID: <20120210002804.17505A04C2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:36215 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757729Ab2BJA2G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2012 19:28:06 -0500
Received: by yhgm50 with SMTP id m50so265152yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 09 Feb 2012 16:28:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, andi@firstfloor.org, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com


The patch titled
     Subject: thp: optimize away unnecessary page table locking
has been added to the -mm tree.  Its filename is
     thp-optimize-away-unnecessary-page-table-locking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: thp: optimize away unnecessary page table locking

Currently when we check if we can handle thp as it is or we need to split
it into regular sized pages, we hold page table lock prior to check
whether a given pmd is mapping thp or not.  Because of this, when it's not
"huge pmd" we suffer from unnecessary lock/unlock overhead.  To remove it,
this patch introduces a optimized check function and replace several
similar logics with it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c      |   68 ++++++---------------
 include/linux/huge_mm.h |   17 +++++
 mm/huge_memory.c        |  122 ++++++++++++++++++--------------------
 mm/mremap.c             |    2 
 4 files changed, 97 insertions(+), 112 deletions(-)

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
+	if (pmd_trans_huge_lock(pmd, vma)) {
+		smaps_pte_entry(*(pte_t *)pmd, addr, HPAGE_PMD_SIZE, walk);
 		spin_unlock(&walk->mm->page_table_lock);
+		mss->anonymous_thp += HPAGE_PMD_SIZE;
+		return 0;
 	}
 	/*
 	 * The mmap_sem held all the way back in m_start() is what
@@ -697,25 +688,17 @@ static int pagemap_pte_range(pmd_t *pmd,
 	/* find the first VMA at or above 'addr' */
 	vma = find_vma(walk->mm, addr);
 
-	spin_lock(&walk->mm->page_table_lock);
-	if (pmd_trans_huge(*pmd)) {
-		if (pmd_trans_splitting(*pmd)) {
-			spin_unlock(&walk->mm->page_table_lock);
-			wait_split_huge_page(vma->anon_vma, pmd);
-		} else {
-			for (; addr != end; addr += PAGE_SIZE) {
-				unsigned long offset = (addr & ~PAGEMAP_WALK_MASK)
-					>> PAGE_SHIFT;
-				pfn = thp_pmd_to_pagemap_entry(*pmd, offset);
-				err = add_to_pagemap(addr, pfn, pm);
-				if (err)
-					break;
-			}
-			spin_unlock(&walk->mm->page_table_lock);
-			return err;
+	if (pmd_trans_huge_lock(pmd, vma)) {
+		for (; addr != end; addr += PAGE_SIZE) {
+			unsigned long offset = (addr & ~PAGEMAP_WALK_MASK)
+				>> PAGE_SHIFT;
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
@@ -982,24 +965,17 @@ static int gather_pte_stats(pmd_t *pmd, 
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
+	if (pmd_trans_huge_lock(pmd, md->vma)) {
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
 
 	orig_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
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
@@ -1030,30 +1030,22 @@ int zap_huge_pmd(struct mmu_gather *tlb,
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
-			spin_unlock(&tlb->mm->page_table_lock);
-			tlb_remove_page(tlb, page);
-			pte_free(tlb->mm, pgtable);
-			ret = 1;
-		}
-	} else
+	if (__pmd_trans_huge_lock(pmd, vma)) {
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
 		spin_unlock(&tlb->mm->page_table_lock);
+		tlb_remove_page(tlb, page);
+		pte_free(tlb->mm, pgtable);
+		ret = 1;
+	}
 
 	return ret;
 }
@@ -1064,21 +1056,15 @@ int mincore_huge_pmd(struct vm_area_stru
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
+	if (__pmd_trans_huge_lock(pmd, vma)) {
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
@@ -1108,21 +1094,12 @@ int move_huge_pmd(struct vm_area_struct 
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
+	if (__pmd_trans_huge_lock(old_pmd, vma)) {
+		pmd = pmdp_get_and_clear(mm, old_addr, old_pmd);
+		VM_BUG_ON(!pmd_none(*new_pmd));
+		set_pmd_at(mm, new_addr, new_pmd, pmd);
 		spin_unlock(&mm->page_table_lock);
+		ret = 1;
 	}
 out:
 	return ret;
@@ -1134,24 +1111,41 @@ int change_huge_pmd(struct vm_area_struc
 	struct mm_struct *mm = vma->vm_mm;
 	int ret = 0;
 
-	spin_lock(&mm->page_table_lock);
+	if (__pmd_trans_huge_lock(pmd, vma)) {
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
+ * Returns 0 otherwise.
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
+			return 0;
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
-
-	return ret;
+	}
+	spin_unlock(&vma->vm_mm->page_table_lock);
+	return 0;
 }
 
 pmd_t *page_check_address_pmd(struct page *page,
diff -puN mm/mremap.c~thp-optimize-away-unnecessary-page-table-locking mm/mremap.c
--- a/mm/mremap.c~thp-optimize-away-unnecessary-page-table-locking
+++ a/mm/mremap.c
@@ -155,8 +155,6 @@ unsigned long move_page_tables(struct vm
 			if (err > 0) {
 				need_flush = true;
 				continue;
-			} else if (!err) {
-				split_huge_page_pmd(vma->vm_mm, old_pmd);
 			}
 			VM_BUG_ON(pmd_trans_huge(*old_pmd));
 		}
_
Subject: Subject: thp: optimize away unnecessary page table locking

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
thp-optimize-away-unnecessary-page-table-locking.patch
pagemap-export-kpf_thp.patch
pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch
mm-introduce-pmd_to_pte_t.patch
pagemap-introduce-data-structure-for-pagemap-entry.patch

