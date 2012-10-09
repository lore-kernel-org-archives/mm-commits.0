From: akpm@linux-foundation.org
Subject: [merged] thp-remove-assumptions-on-pgtable_t-type.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:08:25 -0700
Message-ID: <20121009180825.C5551100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:40159 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab2JISI1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:08:27 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so662168qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:08:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerald.schaefer@de.ibm.com, aarcange@redhat.com, ak@linux.intel.com, dhillf@gmail.com, heiko.carstens@de.ibm.com, hughd@google.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: remove assumptions on pgtable_t type
has been removed from the -mm tree.  Its filename was
     thp-remove-assumptions-on-pgtable_t-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: thp: remove assumptions on pgtable_t type

The thp page table pre-allocation code currently assumes that pgtable_t is
of type "struct page *".  This may not be true for all architectures, so
this patch removes that assumption by replacing the functions
prepare_pmd_huge_pte() and get_pmd_huge_pte() with two new functions that
can be defined architecture-specific.

It also removes two VM_BUG_ON checks for page_count() and page_mapcount()
operating on a pgtable_t.  Apart from the VM_BUG_ON removal, there will be
no functional change introduced by this patch.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |    8 +++++
 include/linux/huge_mm.h       |    1 
 mm/huge_memory.c              |   50 +++++---------------------------
 mm/pgtable-generic.c          |   39 ++++++++++++++++++++++++
 4 files changed, 55 insertions(+), 43 deletions(-)

diff -puN include/asm-generic/pgtable.h~thp-remove-assumptions-on-pgtable_t-type include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~thp-remove-assumptions-on-pgtable_t-type
+++ a/include/asm-generic/pgtable.h
@@ -162,6 +162,14 @@ extern void pmdp_splitting_flush(struct 
 				 unsigned long address, pmd_t *pmdp);
 #endif
 
+#ifndef __HAVE_ARCH_PGTABLE_DEPOSIT
+extern void pgtable_trans_huge_deposit(struct mm_struct *mm, pgtable_t pgtable);
+#endif
+
+#ifndef __HAVE_ARCH_PGTABLE_WITHDRAW
+extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm);
+#endif
+
 #ifndef __HAVE_ARCH_PTE_SAME
 static inline int pte_same(pte_t pte_a, pte_t pte_b)
 {
diff -puN include/linux/huge_mm.h~thp-remove-assumptions-on-pgtable_t-type include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-remove-assumptions-on-pgtable_t-type
+++ a/include/linux/huge_mm.h
@@ -11,7 +11,6 @@ extern int copy_huge_pmd(struct mm_struc
 extern int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			       unsigned long address, pmd_t *pmd,
 			       pmd_t orig_pmd);
-extern pgtable_t get_pmd_huge_pte(struct mm_struct *mm);
 extern struct page *follow_trans_huge_pmd(struct mm_struct *mm,
 					  unsigned long addr,
 					  pmd_t *pmd,
diff -puN mm/huge_memory.c~thp-remove-assumptions-on-pgtable_t-type mm/huge_memory.c
--- a/mm/huge_memory.c~thp-remove-assumptions-on-pgtable_t-type
+++ a/mm/huge_memory.c
@@ -598,19 +598,6 @@ out:
 }
 __setup("transparent_hugepage=", setup_transparent_hugepage);
 
-static void prepare_pmd_huge_pte(pgtable_t pgtable,
-				 struct mm_struct *mm)
-{
-	assert_spin_locked(&mm->page_table_lock);
-
-	/* FIFO */
-	if (!mm->pmd_huge_pte)
-		INIT_LIST_HEAD(&pgtable->lru);
-	else
-		list_add(&pgtable->lru, &mm->pmd_huge_pte->lru);
-	mm->pmd_huge_pte = pgtable;
-}
-
 static inline pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
 {
 	if (likely(vma->vm_flags & VM_WRITE))
@@ -652,7 +639,7 @@ static int __do_huge_pmd_anonymous_page(
 		 */
 		page_add_new_anon_rmap(page, vma, haddr);
 		set_pmd_at(mm, haddr, pmd, entry);
-		prepare_pmd_huge_pte(pgtable, mm);
+		pgtable_trans_huge_deposit(mm, pgtable);
 		add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR);
 		mm->nr_ptes++;
 		spin_unlock(&mm->page_table_lock);
@@ -778,7 +765,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 	pmdp_set_wrprotect(src_mm, addr, src_pmd);
 	pmd = pmd_mkold(pmd_wrprotect(pmd));
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
-	prepare_pmd_huge_pte(pgtable, dst_mm);
+	pgtable_trans_huge_deposit(dst_mm, pgtable);
 	dst_mm->nr_ptes++;
 
 	ret = 0;
@@ -789,25 +776,6 @@ out:
 	return ret;
 }
 
-/* no "address" argument so destroys page coloring of some arch */
-pgtable_t get_pmd_huge_pte(struct mm_struct *mm)
-{
-	pgtable_t pgtable;
-
-	assert_spin_locked(&mm->page_table_lock);
-
-	/* FIFO */
-	pgtable = mm->pmd_huge_pte;
-	if (list_empty(&pgtable->lru))
-		mm->pmd_huge_pte = NULL;
-	else {
-		mm->pmd_huge_pte = list_entry(pgtable->lru.next,
-					      struct page, lru);
-		list_del(&pgtable->lru);
-	}
-	return pgtable;
-}
-
 static int do_huge_pmd_wp_page_fallback(struct mm_struct *mm,
 					struct vm_area_struct *vma,
 					unsigned long address,
@@ -863,7 +831,7 @@ static int do_huge_pmd_wp_page_fallback(
 	pmdp_clear_flush_notify(vma, haddr, pmd);
 	/* leave pmd empty until pte is filled */
 
-	pgtable = get_pmd_huge_pte(mm);
+	pgtable = pgtable_trans_huge_withdraw(mm);
 	pmd_populate(mm, &_pmd, pgtable);
 
 	for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
@@ -1028,7 +996,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 	if (__pmd_trans_huge_lock(pmd, vma) == 1) {
 		struct page *page;
 		pgtable_t pgtable;
-		pgtable = get_pmd_huge_pte(tlb->mm);
+		pgtable = pgtable_trans_huge_withdraw(tlb->mm);
 		page = pmd_page(*pmd);
 		pmd_clear(pmd);
 		tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
@@ -1345,11 +1313,11 @@ static int __split_huge_page_map(struct 
 	pmd = page_check_address_pmd(page, mm, address,
 				     PAGE_CHECK_ADDRESS_PMD_SPLITTING_FLAG);
 	if (pmd) {
-		pgtable = get_pmd_huge_pte(mm);
+		pgtable = pgtable_trans_huge_withdraw(mm);
 		pmd_populate(mm, &_pmd, pgtable);
 
-		for (i = 0, haddr = address; i < HPAGE_PMD_NR;
-		     i++, haddr += PAGE_SIZE) {
+		haddr = address;
+		for (i = 0; i < HPAGE_PMD_NR; i++, haddr += PAGE_SIZE) {
 			pte_t *pte, entry;
 			BUG_ON(PageCompound(page+i));
 			entry = mk_pte(page + i, vma->vm_page_prot);
@@ -2017,8 +1985,6 @@ static void collapse_huge_page(struct mm
 	pte_unmap(pte);
 	__SetPageUptodate(new_page);
 	pgtable = pmd_pgtable(_pmd);
-	VM_BUG_ON(page_count(pgtable) != 1);
-	VM_BUG_ON(page_mapcount(pgtable) != 0);
 
 	_pmd = mk_pmd(new_page, vma->vm_page_prot);
 	_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
@@ -2036,7 +2002,7 @@ static void collapse_huge_page(struct mm
 	page_add_new_anon_rmap(new_page, vma, address);
 	set_pmd_at(mm, address, pmd, _pmd);
 	update_mmu_cache(vma, address, _pmd);
-	prepare_pmd_huge_pte(pgtable, mm);
+	pgtable_trans_huge_deposit(mm, pgtable);
 	spin_unlock(&mm->page_table_lock);
 
 	*hpage = NULL;
diff -puN mm/pgtable-generic.c~thp-remove-assumptions-on-pgtable_t-type mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~thp-remove-assumptions-on-pgtable_t-type
+++ a/mm/pgtable-generic.c
@@ -120,3 +120,42 @@ void pmdp_splitting_flush(struct vm_area
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
+
+#ifndef __HAVE_ARCH_PGTABLE_DEPOSIT
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+void pgtable_trans_huge_deposit(struct mm_struct *mm, pgtable_t pgtable)
+{
+	assert_spin_locked(&mm->page_table_lock);
+
+	/* FIFO */
+	if (!mm->pmd_huge_pte)
+		INIT_LIST_HEAD(&pgtable->lru);
+	else
+		list_add(&pgtable->lru, &mm->pmd_huge_pte->lru);
+	mm->pmd_huge_pte = pgtable;
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+#endif
+
+#ifndef __HAVE_ARCH_PGTABLE_WITHDRAW
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+/* no "address" argument so destroys page coloring of some arch */
+pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm)
+{
+	pgtable_t pgtable;
+
+	assert_spin_locked(&mm->page_table_lock);
+
+	/* FIFO */
+	pgtable = mm->pmd_huge_pte;
+	if (list_empty(&pgtable->lru))
+		mm->pmd_huge_pte = NULL;
+	else {
+		mm->pmd_huge_pte = list_entry(pgtable->lru.next,
+					      struct page, lru);
+		list_del(&pgtable->lru);
+	}
+	return pgtable;
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+#endif
_

Patches currently in -mm which might be from gerald.schaefer@de.ibm.com are

origin.patch
linux-next.patch

