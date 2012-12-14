From: akpm@linux-foundation.org
Subject: [merged] thp-avoid-race-on-multiple-parallel-page-faults-to-the-same-page.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:27:49 -0800
Message-ID: <20121214232749.9E74E82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:52387 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab2LNX1v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:27:51 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so409401ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:27:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, jslaby@suse.cz, lliubbo@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: avoid race on multiple parallel page faults to the same page
has been removed from the -mm tree.  Its filename was
     thp-avoid-race-on-multiple-parallel-page-faults-to-the-same-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: avoid race on multiple parallel page faults to the same page

pmd value is stable only with mm->page_table_lock taken. After taking
the lock we need to check that nobody modified the pmd before changing it.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Reviewed-by: Bob Liu <lliubbo@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff -puN mm/huge_memory.c~thp-avoid-race-on-multiple-parallel-page-faults-to-the-same-page mm/huge_memory.c
--- a/mm/huge_memory.c~thp-avoid-race-on-multiple-parallel-page-faults-to-the-same-page
+++ a/mm/huge_memory.c
@@ -769,17 +769,20 @@ static inline struct page *alloc_hugepag
 }
 #endif
 
-static void set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
+static bool set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long haddr, pmd_t *pmd,
 		unsigned long zero_pfn)
 {
 	pmd_t entry;
+	if (!pmd_none(*pmd))
+		return false;
 	entry = pfn_pmd(zero_pfn, vma->vm_page_prot);
 	entry = pmd_wrprotect(entry);
 	entry = pmd_mkhuge(entry);
 	set_pmd_at(mm, haddr, pmd, entry);
 	pgtable_trans_huge_deposit(mm, pgtable);
 	mm->nr_ptes++;
+	return true;
 }
 
 int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
@@ -799,6 +802,7 @@ int do_huge_pmd_anonymous_page(struct mm
 				transparent_hugepage_use_zero_page()) {
 			pgtable_t pgtable;
 			unsigned long zero_pfn;
+			bool set;
 			pgtable = pte_alloc_one(mm, haddr);
 			if (unlikely(!pgtable))
 				return VM_FAULT_OOM;
@@ -809,9 +813,13 @@ int do_huge_pmd_anonymous_page(struct mm
 				goto out;
 			}
 			spin_lock(&mm->page_table_lock);
-			set_huge_zero_page(pgtable, mm, vma, haddr, pmd,
+			set = set_huge_zero_page(pgtable, mm, vma, haddr, pmd,
 					zero_pfn);
 			spin_unlock(&mm->page_table_lock);
+			if (!set) {
+				pte_free(mm, pgtable);
+				put_huge_zero_page();
+			}
 			return 0;
 		}
 		page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
@@ -885,14 +893,16 @@ int copy_huge_pmd(struct mm_struct *dst_
 	 */
 	if (is_huge_zero_pmd(pmd)) {
 		unsigned long zero_pfn;
+		bool set;
 		/*
 		 * get_huge_zero_page() will never allocate a new page here,
 		 * since we already have a zero page to copy. It just takes a
 		 * reference.
 		 */
 		zero_pfn = get_huge_zero_page();
-		set_huge_zero_page(pgtable, dst_mm, vma, addr, dst_pmd,
+		set = set_huge_zero_page(pgtable, dst_mm, vma, addr, dst_pmd,
 				zero_pfn);
+		BUG_ON(!set); /* unexpected !pmd_none(dst_pmd) */
 		ret = 0;
 		goto out_unlock;
 	}
@@ -949,7 +959,7 @@ unlock:
 
 static int do_huge_pmd_wp_zero_page_fallback(struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long address,
-		pmd_t *pmd, unsigned long haddr)
+		pmd_t *pmd, pmd_t orig_pmd, unsigned long haddr)
 {
 	pgtable_t pgtable;
 	pmd_t _pmd;
@@ -978,6 +988,9 @@ static int do_huge_pmd_wp_zero_page_fall
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 
 	spin_lock(&mm->page_table_lock);
+	if (unlikely(!pmd_same(*pmd, orig_pmd)))
+		goto out_free_page;
+
 	pmdp_clear_flush(vma, haddr, pmd);
 	/* leave pmd empty until pte is filled */
 
@@ -1010,6 +1023,12 @@ static int do_huge_pmd_wp_zero_page_fall
 	ret |= VM_FAULT_WRITE;
 out:
 	return ret;
+out_free_page:
+	spin_unlock(&mm->page_table_lock);
+	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
+	mem_cgroup_uncharge_page(page);
+	put_page(page);
+	goto out;
 }
 
 static int do_huge_pmd_wp_page_fallback(struct mm_struct *mm,
@@ -1156,7 +1175,7 @@ alloc:
 		count_vm_event(THP_FAULT_FALLBACK);
 		if (is_huge_zero_pmd(orig_pmd)) {
 			ret = do_huge_pmd_wp_zero_page_fallback(mm, vma,
-					address, pmd, haddr);
+					address, pmd, orig_pmd, haddr);
 		} else {
 			ret = do_huge_pmd_wp_page_fallback(mm, vma, address,
 					pmd, orig_pmd, page, haddr);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
linux-next.patch
x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch

