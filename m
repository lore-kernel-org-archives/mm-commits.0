From: akpm@linux-foundation.org
Subject: [merged] thp-do_huge_pmd_wp_page-handle-huge-zero-page.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:27:12 -0800
Message-ID: <20121214232712.D993F82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:48274 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418Ab2LNX1O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:27:14 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so410236vcd.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:27:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, hpa@linux.intel.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: do_huge_pmd_wp_page(): handle huge zero page
has been removed from the -mm tree.  Its filename was
     thp-do_huge_pmd_wp_page-handle-huge-zero-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: do_huge_pmd_wp_page(): handle huge zero page

On write access to huge zero page we alloc a new huge page and clear it.

If ENOMEM, graceful fallback: we create a new pmd table and set pte around
fault address to newly allocated normal (4k) page.  All other ptes in the
pmd set to normal zero page.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    8 +++
 mm/huge_memory.c   |  111 +++++++++++++++++++++++++++++++++++++------
 mm/memory.c        |    7 --
 3 files changed, 104 insertions(+), 22 deletions(-)

diff -puN include/linux/mm.h~thp-do_huge_pmd_wp_page-handle-huge-zero-page include/linux/mm.h
--- a/include/linux/mm.h~thp-do_huge_pmd_wp_page-handle-huge-zero-page
+++ a/include/linux/mm.h
@@ -516,6 +516,14 @@ static inline pte_t maybe_mkwrite(pte_t 
 }
 #endif
 
+#ifndef my_zero_pfn
+static inline unsigned long my_zero_pfn(unsigned long addr)
+{
+	extern unsigned long zero_pfn;
+	return zero_pfn;
+}
+#endif
+
 /*
  * Multiple processes may "see" the same page. E.g. for untouched
  * mappings of /dev/null, all processes see the same page full of
diff -puN mm/huge_memory.c~thp-do_huge_pmd_wp_page-handle-huge-zero-page mm/huge_memory.c
--- a/mm/huge_memory.c~thp-do_huge_pmd_wp_page-handle-huge-zero-page
+++ a/mm/huge_memory.c
@@ -858,6 +858,70 @@ unlock:
 	spin_unlock(&mm->page_table_lock);
 }
 
+static int do_huge_pmd_wp_zero_page_fallback(struct mm_struct *mm,
+		struct vm_area_struct *vma, unsigned long address,
+		pmd_t *pmd, unsigned long haddr)
+{
+	pgtable_t pgtable;
+	pmd_t _pmd;
+	struct page *page;
+	int i, ret = 0;
+	unsigned long mmun_start;	/* For mmu_notifiers */
+	unsigned long mmun_end;		/* For mmu_notifiers */
+
+	page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
+	if (!page) {
+		ret |= VM_FAULT_OOM;
+		goto out;
+	}
+
+	if (mem_cgroup_newpage_charge(page, mm, GFP_KERNEL)) {
+		put_page(page);
+		ret |= VM_FAULT_OOM;
+		goto out;
+	}
+
+	clear_user_highpage(page, address);
+	__SetPageUptodate(page);
+
+	mmun_start = haddr;
+	mmun_end   = haddr + HPAGE_PMD_SIZE;
+	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
+
+	spin_lock(&mm->page_table_lock);
+	pmdp_clear_flush(vma, haddr, pmd);
+	/* leave pmd empty until pte is filled */
+
+	pgtable = pgtable_trans_huge_withdraw(mm);
+	pmd_populate(mm, &_pmd, pgtable);
+
+	for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
+		pte_t *pte, entry;
+		if (haddr == (address & PAGE_MASK)) {
+			entry = mk_pte(page, vma->vm_page_prot);
+			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+			page_add_new_anon_rmap(page, vma, haddr);
+		} else {
+			entry = pfn_pte(my_zero_pfn(haddr), vma->vm_page_prot);
+			entry = pte_mkspecial(entry);
+		}
+		pte = pte_offset_map(&_pmd, haddr);
+		VM_BUG_ON(!pte_none(*pte));
+		set_pte_at(mm, haddr, pte, entry);
+		pte_unmap(pte);
+	}
+	smp_wmb(); /* make pte visible before pmd */
+	pmd_populate(mm, pmd, pgtable);
+	spin_unlock(&mm->page_table_lock);
+	inc_mm_counter(mm, MM_ANONPAGES);
+
+	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
+
+	ret |= VM_FAULT_WRITE;
+out:
+	return ret;
+}
+
 static int do_huge_pmd_wp_page_fallback(struct mm_struct *mm,
 					struct vm_area_struct *vma,
 					unsigned long address,
@@ -964,19 +1028,21 @@ int do_huge_pmd_wp_page(struct mm_struct
 			unsigned long address, pmd_t *pmd, pmd_t orig_pmd)
 {
 	int ret = 0;
-	struct page *page, *new_page;
+	struct page *page = NULL, *new_page;
 	unsigned long haddr;
 	unsigned long mmun_start;	/* For mmu_notifiers */
 	unsigned long mmun_end;		/* For mmu_notifiers */
 
 	VM_BUG_ON(!vma->anon_vma);
+	haddr = address & HPAGE_PMD_MASK;
+	if (is_huge_zero_pmd(orig_pmd))
+		goto alloc;
 	spin_lock(&mm->page_table_lock);
 	if (unlikely(!pmd_same(*pmd, orig_pmd)))
 		goto out_unlock;
 
 	page = pmd_page(orig_pmd);
 	VM_BUG_ON(!PageCompound(page) || !PageHead(page));
-	haddr = address & HPAGE_PMD_MASK;
 	if (page_mapcount(page) == 1) {
 		pmd_t entry;
 		entry = pmd_mkyoung(orig_pmd);
@@ -988,7 +1054,7 @@ int do_huge_pmd_wp_page(struct mm_struct
 	}
 	get_page(page);
 	spin_unlock(&mm->page_table_lock);
-
+alloc:
 	if (transparent_hugepage_enabled(vma) &&
 	    !transparent_hugepage_debug_cow())
 		new_page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
@@ -998,24 +1064,34 @@ int do_huge_pmd_wp_page(struct mm_struct
 
 	if (unlikely(!new_page)) {
 		count_vm_event(THP_FAULT_FALLBACK);
-		ret = do_huge_pmd_wp_page_fallback(mm, vma, address,
-						   pmd, orig_pmd, page, haddr);
-		if (ret & VM_FAULT_OOM)
-			split_huge_page(page);
-		put_page(page);
+		if (is_huge_zero_pmd(orig_pmd)) {
+			ret = do_huge_pmd_wp_zero_page_fallback(mm, vma,
+					address, pmd, haddr);
+		} else {
+			ret = do_huge_pmd_wp_page_fallback(mm, vma, address,
+					pmd, orig_pmd, page, haddr);
+			if (ret & VM_FAULT_OOM)
+				split_huge_page(page);
+			put_page(page);
+		}
 		goto out;
 	}
 	count_vm_event(THP_FAULT_ALLOC);
 
 	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
 		put_page(new_page);
-		split_huge_page(page);
-		put_page(page);
+		if (page) {
+			split_huge_page(page);
+			put_page(page);
+		}
 		ret |= VM_FAULT_OOM;
 		goto out;
 	}
 
-	copy_user_huge_page(new_page, page, haddr, vma, HPAGE_PMD_NR);
+	if (is_huge_zero_pmd(orig_pmd))
+		clear_huge_page(new_page, haddr, HPAGE_PMD_NR);
+	else
+		copy_user_huge_page(new_page, page, haddr, vma, HPAGE_PMD_NR);
 	__SetPageUptodate(new_page);
 
 	mmun_start = haddr;
@@ -1023,7 +1099,8 @@ int do_huge_pmd_wp_page(struct mm_struct
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 
 	spin_lock(&mm->page_table_lock);
-	put_page(page);
+	if (page)
+		put_page(page);
 	if (unlikely(!pmd_same(*pmd, orig_pmd))) {
 		spin_unlock(&mm->page_table_lock);
 		mem_cgroup_uncharge_page(new_page);
@@ -1031,14 +1108,18 @@ int do_huge_pmd_wp_page(struct mm_struct
 		goto out_mn;
 	} else {
 		pmd_t entry;
-		VM_BUG_ON(!PageHead(page));
 		entry = mk_huge_pmd(new_page, vma);
 		pmdp_clear_flush(vma, haddr, pmd);
 		page_add_new_anon_rmap(new_page, vma, haddr);
 		set_pmd_at(mm, haddr, pmd, entry);
 		update_mmu_cache_pmd(vma, address, pmd);
-		page_remove_rmap(page);
-		put_page(page);
+		if (is_huge_zero_pmd(orig_pmd))
+			add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR);
+		else {
+			VM_BUG_ON(!PageHead(page));
+			page_remove_rmap(page);
+			put_page(page);
+		}
 		ret |= VM_FAULT_WRITE;
 	}
 	spin_unlock(&mm->page_table_lock);
diff -puN mm/memory.c~thp-do_huge_pmd_wp_page-handle-huge-zero-page mm/memory.c
--- a/mm/memory.c~thp-do_huge_pmd_wp_page-handle-huge-zero-page
+++ a/mm/memory.c
@@ -724,13 +724,6 @@ static inline int is_zero_pfn(unsigned l
 }
 #endif
 
-#ifndef my_zero_pfn
-static inline unsigned long my_zero_pfn(unsigned long addr)
-{
-	return zero_pfn;
-}
-#endif
