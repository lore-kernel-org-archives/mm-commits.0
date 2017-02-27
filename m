From: akpm@linux-foundation.org
Subject: [merged]
 mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk.patch removed
 from -mm tree
Date: Mon, 27 Feb 2017 12:26:29 -0800
Message-ID: <58b48b75.SQtbDfH6FJiPRNl+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60498 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751649AbdB0U16 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:27:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert remove_migration_pte() to use page_vma_mapped_walk()
has been removed from the -mm tree.  Its filename was
     mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: convert remove_migration_pte() to use page_vma_mapped_walk()

remove_migration_pte() also can easily be converted to
page_vma_mapped_walk().

[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/20170129173858.45174-13-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |  108 +++++++++++++++++++------------------------------
 1 file changed, 44 insertions(+), 64 deletions(-)

diff -puN mm/migrate.c~mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk mm/migrate.c
--- a/mm/migrate.c~mm-convert-remove_migration_pte-to-use-page_vma_mapped_walk
+++ a/mm/migrate.c
@@ -193,82 +193,62 @@ void putback_movable_pages(struct list_h
 /*
  * Restore a potential migration pte to a working pte entry
  */
-static int remove_migration_pte(struct page *new, struct vm_area_struct *vma,
+static int remove_migration_pte(struct page *page, struct vm_area_struct *vma,
 				 unsigned long addr, void *old)
 {
-	struct mm_struct *mm = vma->vm_mm;
+	struct page_vma_mapped_walk pvmw = {
+		.page = old,
+		.vma = vma,
+		.address = addr,
+		.flags = PVMW_SYNC | PVMW_MIGRATION,
+	};
+	struct page *new;
+	pte_t pte;
 	swp_entry_t entry;
- 	pmd_t *pmd;
-	pte_t *ptep, pte;
- 	spinlock_t *ptl;
-
-	if (unlikely(PageHuge(new))) {
-		ptep = huge_pte_offset(mm, addr);
-		if (!ptep)
-			goto out;
-		ptl = huge_pte_lockptr(hstate_vma(vma), mm, ptep);
-	} else {
-		pmd = mm_find_pmd(mm, addr);
-		if (!pmd)
-			goto out;
 
-		ptep = pte_offset_map(pmd, addr);
+	VM_BUG_ON_PAGE(PageTail(page), page);
+	while (page_vma_mapped_walk(&pvmw)) {
+		new = page - pvmw.page->index +
+			linear_page_index(vma, pvmw.address);
+
+		get_page(new);
+		pte = pte_mkold(mk_pte(new, READ_ONCE(vma->vm_page_prot)));
+		if (pte_swp_soft_dirty(*pvmw.pte))
+			pte = pte_mksoft_dirty(pte);
 
 		/*
-		 * Peek to check is_swap_pte() before taking ptlock?  No, we
-		 * can race mremap's move_ptes(), which skips anon_vma lock.
+		 * Recheck VMA as permissions can change since migration started
 		 */
-
-		ptl = pte_lockptr(mm, pmd);
-	}
-
- 	spin_lock(ptl);
-	pte = *ptep;
-	if (!is_swap_pte(pte))
-		goto unlock;
-
-	entry = pte_to_swp_entry(pte);
-
-	if (!is_migration_entry(entry) ||
-	    migration_entry_to_page(entry) != old)
-		goto unlock;
-
-	get_page(new);
-	pte = pte_mkold(mk_pte(new, READ_ONCE(vma->vm_page_prot)));
-	if (pte_swp_soft_dirty(*ptep))
-		pte = pte_mksoft_dirty(pte);
-
-	/* Recheck VMA as permissions can change since migration started  */
-	if (is_write_migration_entry(entry))
-		pte = maybe_mkwrite(pte, vma);
+		entry = pte_to_swp_entry(*pvmw.pte);
+		if (is_write_migration_entry(entry))
+			pte = maybe_mkwrite(pte, vma);
 
 #ifdef CONFIG_HUGETLB_PAGE
-	if (PageHuge(new)) {
-		pte = pte_mkhuge(pte);
-		pte = arch_make_huge_pte(pte, vma, new, 0);
-	}
+		if (PageHuge(new)) {
+			pte = pte_mkhuge(pte);
+			pte = arch_make_huge_pte(pte, vma, new, 0);
+		}
 #endif
-	flush_dcache_page(new);
-	set_pte_at(mm, addr, ptep, pte);
+		flush_dcache_page(new);
+		set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
 
-	if (PageHuge(new)) {
-		if (PageAnon(new))
-			hugepage_add_anon_rmap(new, vma, addr);
+		if (PageHuge(new)) {
+			if (PageAnon(new))
+				hugepage_add_anon_rmap(new, vma, pvmw.address);
+			else
+				page_dup_rmap(new, true);
+		} else if (PageAnon(new))
+			page_add_anon_rmap(new, vma, pvmw.address, false);
 		else
-			page_dup_rmap(new, true);
-	} else if (PageAnon(new))
-		page_add_anon_rmap(new, vma, addr, false);
-	else
-		page_add_file_rmap(new, false);
-
-	if (vma->vm_flags & VM_LOCKED && !PageTransCompound(new))
-		mlock_vma_page(new);
