From: akpm@linux-foundation.org
Subject: - hugetlbfs-common-code-update-for-s390.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:53:51 -0700
Message-ID: <200804282153.m3SLrpTS017932@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965055AbYD1VyV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:54:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerald.schaefer@de.ibm.com, davem@davemloft.net, lethal@linux-sh.org, mingo@elte.hu, schwidefsky@de.ibm.com, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     hugetlbfs: common code update for s390
has been removed from the -mm tree.  Its filename was
     hugetlbfs-common-code-update-for-s390.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlbfs: common code update for s390
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

Huge ptes have a special type on s390 and cannot be handled with the standard
pte functions in certain cases, e.g.  because of a different location of the
invalid bit.  This patch adds some new architecture- specific functions to
hugetlb common code, as a prerequisite for the s390 large page support.

This won't affect other architectures in functionality, but I need to add some
new dummy inline functions to the headers.

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/hugetlb.h    |   37 ++++++++++++++++++++++++++++++++
 include/asm-powerpc/hugetlb.h |   37 ++++++++++++++++++++++++++++++++
 include/asm-sh/hugetlb.h      |   37 ++++++++++++++++++++++++++++++++
 include/asm-sparc64/hugetlb.h |   37 ++++++++++++++++++++++++++++++++
 include/asm-x86/hugetlb.h     |   37 ++++++++++++++++++++++++++++++++
 mm/hugetlb.c                  |   36 ++++++++++++++++++-------------
 6 files changed, 206 insertions(+), 15 deletions(-)

diff -puN include/asm-ia64/hugetlb.h~hugetlbfs-common-code-update-for-s390 include/asm-ia64/hugetlb.h
--- a/include/asm-ia64/hugetlb.h~hugetlbfs-common-code-update-for-s390
+++ a/include/asm-ia64/hugetlb.h
@@ -39,4 +39,41 @@ static inline void huge_ptep_clear_flush
 {
 }
 
+static inline int huge_pte_none(pte_t pte)
+{
+	return pte_none(pte);
+}
+
+static inline pte_t huge_pte_wrprotect(pte_t pte)
+{
+	return pte_wrprotect(pte);
+}
+
+static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
+					   unsigned long addr, pte_t *ptep)
+{
+	ptep_set_wrprotect(mm, addr, ptep);
+}
+
+static inline int huge_ptep_set_access_flags(struct vm_area_struct *vma,
+					     unsigned long addr, pte_t *ptep,
+					     pte_t pte, int dirty)
+{
+	return ptep_set_access_flags(vma, addr, ptep, pte, dirty);
+}
+
+static inline pte_t huge_ptep_get(pte_t *ptep)
+{
+	return *ptep;
+}
+
+static inline int arch_prepare_hugepage(struct page *page)
+{
+	return 0;
+}
+
+static inline void arch_release_hugepage(struct page *page)
+{
+}
+
 #endif /* _ASM_IA64_HUGETLB_H */
diff -puN include/asm-powerpc/hugetlb.h~hugetlbfs-common-code-update-for-s390 include/asm-powerpc/hugetlb.h
--- a/include/asm-powerpc/hugetlb.h~hugetlbfs-common-code-update-for-s390
+++ a/include/asm-powerpc/hugetlb.h
@@ -39,4 +39,41 @@ static inline void huge_ptep_clear_flush
 {
 }
 
+static inline int huge_pte_none(pte_t pte)
+{
+	return pte_none(pte);
+}
+
+static inline pte_t huge_pte_wrprotect(pte_t pte)
+{
+	return pte_wrprotect(pte);
+}
+
+static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
+					   unsigned long addr, pte_t *ptep)
+{
+	ptep_set_wrprotect(mm, addr, ptep);
+}
+
+static inline int huge_ptep_set_access_flags(struct vm_area_struct *vma,
+					     unsigned long addr, pte_t *ptep,
+					     pte_t pte, int dirty)
+{
+	return ptep_set_access_flags(vma, addr, ptep, pte, dirty);
+}
+
+static inline pte_t huge_ptep_get(pte_t *ptep)
+{
+	return *ptep;
+}
+
+static inline int arch_prepare_hugepage(struct page *page)
+{
+	return 0;
+}
+
+static inline void arch_release_hugepage(struct page *page)
+{
+}
+
 #endif /* _ASM_POWERPC_HUGETLB_H */
diff -puN include/asm-sh/hugetlb.h~hugetlbfs-common-code-update-for-s390 include/asm-sh/hugetlb.h
--- a/include/asm-sh/hugetlb.h~hugetlbfs-common-code-update-for-s390
+++ a/include/asm-sh/hugetlb.h
@@ -51,4 +51,41 @@ static inline void huge_ptep_clear_flush
 {
 }
 
+static inline int huge_pte_none(pte_t pte)
+{
+	return pte_none(pte);
+}
+
+static inline pte_t huge_pte_wrprotect(pte_t pte)
+{
+	return pte_wrprotect(pte);
+}
+
+static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
+					   unsigned long addr, pte_t *ptep)
+{
+	ptep_set_wrprotect(mm, addr, ptep);
+}
+
+static inline int huge_ptep_set_access_flags(struct vm_area_struct *vma,
+					     unsigned long addr, pte_t *ptep,
+					     pte_t pte, int dirty)
+{
+	return ptep_set_access_flags(vma, addr, ptep, pte, dirty);
+}
+
+static inline pte_t huge_ptep_get(pte_t *ptep)
+{
+	return *ptep;
+}
+
+static inline int arch_prepare_hugepage(struct page *page)
+{
+	return 0;
+}
+
+static inline void arch_release_hugepage(struct page *page)
+{
+}
+
 #endif /* _ASM_SH_HUGETLB_H */
diff -puN include/asm-sparc64/hugetlb.h~hugetlbfs-common-code-update-for-s390 include/asm-sparc64/hugetlb.h
--- a/include/asm-sparc64/hugetlb.h~hugetlbfs-common-code-update-for-s390
+++ a/include/asm-sparc64/hugetlb.h
@@ -44,4 +44,41 @@ static inline void huge_ptep_clear_flush
 {
 }
 
+static inline int huge_pte_none(pte_t pte)
+{
+	return pte_none(pte);
+}
+
+static inline pte_t huge_pte_wrprotect(pte_t pte)
+{
+	return pte_wrprotect(pte);
+}
+
+static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
+					   unsigned long addr, pte_t *ptep)
+{
+	ptep_set_wrprotect(mm, addr, ptep);
+}
+
+static inline int huge_ptep_set_access_flags(struct vm_area_struct *vma,
+					     unsigned long addr, pte_t *ptep,
+					     pte_t pte, int dirty)
+{
+	return ptep_set_access_flags(vma, addr, ptep, pte, dirty);
+}
+
+static inline pte_t huge_ptep_get(pte_t *ptep)
+{
+	return *ptep;
+}
+
+static inline int arch_prepare_hugepage(struct page *page)
+{
+	return 0;
+}
+
+static inline void arch_release_hugepage(struct page *page)
+{
+}
+
 #endif /* _ASM_SPARC64_HUGETLB_H */
diff -puN include/asm-x86/hugetlb.h~hugetlbfs-common-code-update-for-s390 include/asm-x86/hugetlb.h
--- a/include/asm-x86/hugetlb.h~hugetlbfs-common-code-update-for-s390
+++ a/include/asm-x86/hugetlb.h
@@ -51,4 +51,41 @@ static inline void huge_ptep_clear_flush
 {
 }
 
+static inline int huge_pte_none(pte_t pte)
+{
+	return pte_none(pte);
+}
+
+static inline pte_t huge_pte_wrprotect(pte_t pte)
+{
+	return pte_wrprotect(pte);
+}
+
+static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
+					   unsigned long addr, pte_t *ptep)
+{
+	ptep_set_wrprotect(mm, addr, ptep);
+}
+
+static inline int huge_ptep_set_access_flags(struct vm_area_struct *vma,
+					     unsigned long addr, pte_t *ptep,
+					     pte_t pte, int dirty)
+{
+	return ptep_set_access_flags(vma, addr, ptep, pte, dirty);
+}
+
+static inline pte_t huge_ptep_get(pte_t *ptep)
+{
+	return *ptep;
+}
+
+static inline int arch_prepare_hugepage(struct page *page)
+{
+	return 0;
+}
+
+static inline void arch_release_hugepage(struct page *page)
+{
+}
+
 #endif /* _ASM_X86_HUGETLB_H */
diff -puN mm/hugetlb.c~hugetlbfs-common-code-update-for-s390 mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlbfs-common-code-update-for-s390
+++ a/mm/hugetlb.c
@@ -132,6 +132,7 @@ static void update_and_free_page(struct 
 	}
 	set_compound_page_dtor(page, NULL);
 	set_page_refcounted(page);
+	arch_release_hugepage(page);
 	__free_pages(page, HUGETLB_PAGE_ORDER);
 }
 
@@ -201,6 +202,10 @@ static struct page *alloc_fresh_huge_pag
 		htlb_alloc_mask|__GFP_COMP|__GFP_THISNODE|__GFP_NOWARN,
 		HUGETLB_PAGE_ORDER);
 	if (page) {
+		if (arch_prepare_hugepage(page)) {
+			__free_pages(page, HUGETLB_PAGE_ORDER);
+			return 0;
+		}
 		set_compound_page_dtor(page, free_huge_page);
 		spin_lock(&hugetlb_lock);
 		nr_huge_pages++;
@@ -735,7 +740,7 @@ static pte_t make_huge_pte(struct vm_are
 		entry =
 		    pte_mkwrite(pte_mkdirty(mk_pte(page, vma->vm_page_prot)));
 	} else {
-		entry = pte_wrprotect(mk_pte(page, vma->vm_page_prot));
+		entry = huge_pte_wrprotect(mk_pte(page, vma->vm_page_prot));
 	}
 	entry = pte_mkyoung(entry);
 	entry = pte_mkhuge(entry);
@@ -748,8 +753,8 @@ static void set_huge_ptep_writable(struc
 {
 	pte_t entry;
 
-	entry = pte_mkwrite(pte_mkdirty(*ptep));
-	if (ptep_set_access_flags(vma, address, ptep, entry, 1)) {
+	entry = pte_mkwrite(pte_mkdirty(huge_ptep_get(ptep)));
+	if (huge_ptep_set_access_flags(vma, address, ptep, entry, 1)) {
 		update_mmu_cache(vma, address, entry);
 	}
 }
@@ -779,10 +784,10 @@ int copy_hugetlb_page_range(struct mm_st
 
 		spin_lock(&dst->page_table_lock);
 		spin_lock(&src->page_table_lock);
-		if (!pte_none(*src_pte)) {
+		if (!huge_pte_none(huge_ptep_get(src_pte))) {
 			if (cow)
-				ptep_set_wrprotect(src, addr, src_pte);
-			entry = *src_pte;
+				huge_ptep_set_wrprotect(src, addr, src_pte);
+			entry = huge_ptep_get(src_pte);
 			ptepage = pte_page(entry);
 			get_page(ptepage);
 			set_huge_pte_at(dst, addr, dst_pte, entry);
@@ -826,7 +831,7 @@ void __unmap_hugepage_range(struct vm_ar
 			continue;
 
 		pte = huge_ptep_get_and_clear(mm, address, ptep);
-		if (pte_none(pte))
+		if (huge_pte_none(pte))
 			continue;
 
 		page = pte_page(pte);
@@ -890,7 +895,7 @@ static int hugetlb_cow(struct mm_struct 
 	spin_lock(&mm->page_table_lock);
 
 	ptep = huge_pte_offset(mm, address & HPAGE_MASK);
-	if (likely(pte_same(*ptep, pte))) {
+	if (likely(pte_same(huge_ptep_get(ptep), pte))) {
 		/* Break COW */
 		huge_ptep_clear_flush(vma, address, ptep);
 		set_huge_pte_at(mm, address, ptep,
@@ -960,7 +965,7 @@ retry:
 		goto backout;
 
 	ret = 0;
-	if (!pte_none(*ptep))
+	if (!huge_pte_none(huge_ptep_get(ptep)))
 		goto backout;
 
 	new_pte = make_huge_pte(vma, page, ((vma->vm_flags & VM_WRITE)
@@ -1002,8 +1007,8 @@ int hugetlb_fault(struct mm_struct *mm, 
 	 * the same page in the page cache.
 	 */
 	mutex_lock(&hugetlb_instantiation_mutex);
-	entry = *ptep;
-	if (pte_none(entry)) {
+	entry = huge_ptep_get(ptep);
+	if (huge_pte_none(entry)) {
 		ret = hugetlb_no_page(mm, vma, address, ptep, write_access);
 		mutex_unlock(&hugetlb_instantiation_mutex);
 		return ret;
@@ -1013,7 +1018,7 @@ int hugetlb_fault(struct mm_struct *mm, 
 
 	spin_lock(&mm->page_table_lock);
 	/* Check for a racing update before calling hugetlb_cow */
-	if (likely(pte_same(entry, *ptep)))
+	if (likely(pte_same(entry, huge_ptep_get(ptep))))
 		if (write_access && !pte_write(entry))
 			ret = hugetlb_cow(mm, vma, address, ptep, entry);
 	spin_unlock(&mm->page_table_lock);
@@ -1043,7 +1048,8 @@ int follow_hugetlb_page(struct mm_struct
 		 */
 		pte = huge_pte_offset(mm, vaddr & HPAGE_MASK);
 
-		if (!pte || pte_none(*pte) || (write && !pte_write(*pte))) {
+		if (!pte || huge_pte_none(huge_ptep_get(pte)) ||
+		    (write && !pte_write(huge_ptep_get(pte)))) {
 			int ret;
 
 			spin_unlock(&mm->page_table_lock);
@@ -1059,7 +1065,7 @@ int follow_hugetlb_page(struct mm_struct
 		}
 
 		pfn_offset = (vaddr & ~HPAGE_MASK) >> PAGE_SHIFT;
-		page = pte_page(*pte);
+		page = pte_page(huge_ptep_get(pte));
 same_page:
 		if (pages) {
 			get_page(page);
@@ -1108,7 +1114,7 @@ void hugetlb_change_protection(struct vm
 			continue;
 		if (huge_pmd_unshare(mm, &address, ptep))
 			continue;
-		if (!pte_none(*ptep)) {
+		if (!huge_pte_none(huge_ptep_get(ptep))) {
 			pte = huge_ptep_get_and_clear(mm, address, ptep);
 			pte = pte_mkhuge(pte_modify(pte, newprot));
 			set_huge_pte_at(mm, address, ptep, pte);
_

Patches currently in -mm which might be from gerald.schaefer@de.ibm.com are

origin.patch

