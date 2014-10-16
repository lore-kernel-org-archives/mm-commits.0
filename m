From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-update-generic-gup-implementation-to-handle-hugepage-directory.patch
 removed from -mm tree
Date: Thu, 16 Oct 2014 12:50:44 -0700
Message-ID: <54402194.AwSJV13HBk3mv7zJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbaJPTuo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Oct 2014 15:50:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, benh@kernel.crashing.org, mpe@ellerman.id.au, steve.capper@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup.c: update generic gup implementation to handle hugepage directory
has been removed from the -mm tree.  Its filename was
     mm-update-generic-gup-implementation-to-handle-hugepage-directory.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/gup.c: update generic gup implementation to handle hugepage directory

Update generic gup implementation with powerpc specific details.  On
powerpc at pmd level we can have hugepte, normal pmd pointer or a pointer
to the hugepage directory.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    1 
 include/linux/mm.h      |   26 ++++++++
 mm/gup.c                |  113 ++++++++++++++++++--------------------
 3 files changed, 81 insertions(+), 59 deletions(-)

diff -puN include/linux/hugetlb.h~mm-update-generic-gup-implementation-to-handle-hugepage-directory include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-update-generic-gup-implementation-to-handle-hugepage-directory
+++ a/include/linux/hugetlb.h
@@ -138,6 +138,7 @@ static inline void hugetlb_show_meminfo(
 #define prepare_hugepage_range(file, addr, len)	(-EINVAL)
 #define pmd_huge(x)	0
 #define pud_huge(x)	0
+#define pgd_huge(x)	0
 #define is_hugepage_only_range(mm, addr, len)	0
 #define hugetlb_free_pgd_range(tlb, addr, end, floor, ceiling) ({BUG(); 0; })
 #define hugetlb_fault(mm, vma, addr, flags)	({ BUG(); 0; })
diff -puN include/linux/mm.h~mm-update-generic-gup-implementation-to-handle-hugepage-directory include/linux/mm.h
--- a/include/linux/mm.h~mm-update-generic-gup-implementation-to-handle-hugepage-directory
+++ a/include/linux/mm.h
@@ -1219,6 +1219,32 @@ long get_user_pages(struct task_struct *
 		    struct vm_area_struct **vmas);
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
+
+#ifdef CONFIG_HAVE_GENERIC_RCU_GUP
+#ifndef is_hugepd
+/*
+ * Some architectures support hugepage directory format that is
+ * required to support different hugetlbfs sizes.
+ */
+typedef struct { unsigned long pd; } hugepd_t;
+#define is_hugepd(hugepd) (0)
+#define __hugepd(x) ((hugepd_t) { (x) })
+static inline int gup_hugepd(hugepd_t hugepd, unsigned long addr,
+			     unsigned pdshift, unsigned long end,
+			     int write, struct page **pages, int *nr)
+{
+	return 0;
+}
+#else
+extern int gup_hugepd(hugepd_t hugepd, unsigned long addr,
+		      unsigned pdshift, unsigned long end,
+		      int write, struct page **pages, int *nr);
+#endif
+extern int gup_huge_pte(pte_t orig, pte_t *ptep, unsigned long addr,
+			unsigned long sz, unsigned long end, int write,
+			struct page **pages, int *nr);
+#endif
+
 struct kvec;
 int get_kernel_pages(const struct kvec *iov, int nr_pages, int write,
 			struct page **pages);
diff -puN mm/gup.c~mm-update-generic-gup-implementation-to-handle-hugepage-directory mm/gup.c
--- a/mm/gup.c~mm-update-generic-gup-implementation-to-handle-hugepage-directory
+++ a/mm/gup.c
@@ -786,65 +786,31 @@ static int gup_pte_range(pmd_t pmd, unsi
 }
 #endif /* __HAVE_ARCH_PTE_SPECIAL */
 
-static int gup_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
-		unsigned long end, int write, struct page **pages, int *nr)
+int gup_huge_pte(pte_t orig, pte_t *ptep, unsigned long addr,
+		 unsigned long sz, unsigned long end, int write,
+		 struct page **pages, int *nr)
 {
-	struct page *head, *page, *tail;
 	int refs;
+	unsigned long pte_end;
+	struct page *head, *page, *tail;
 
-	if (write && !pmd_write(orig))
-		return 0;
-
-	refs = 0;
-	head = pmd_page(orig);
-	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
-	tail = page;
-	do {
-		VM_BUG_ON_PAGE(compound_head(page) != head, page);
-		pages[*nr] = page;
-		(*nr)++;
-		page++;
-		refs++;
-	} while (addr += PAGE_SIZE, addr != end);
 
-	if (!page_cache_add_speculative(head, refs)) {
-		*nr -= refs;
+	if (write && !pte_write(orig))
 		return 0;
-	}
 
-	if (unlikely(pmd_val(orig) != pmd_val(*pmdp))) {
-		*nr -= refs;
-		while (refs--)
-			put_page(head);
+	if (!pte_present(orig))
 		return 0;
-	}
 
-	/*
-	 * Any tail pages need their mapcount reference taken before we
-	 * return. (This allows the THP code to bump their ref count when
-	 * they are split into base pages).
-	 */
-	while (refs--) {
-		if (PageTail(tail))
-			get_huge_page_tail(tail);
-		tail++;
-	}
-
-	return 1;
-}
-
-static int gup_huge_pud(pud_t orig, pud_t *pudp, unsigned long addr,
-		unsigned long end, int write, struct page **pages, int *nr)
-{
-	struct page *head, *page, *tail;
-	int refs;
+	pte_end = (addr + sz) & ~(sz-1);
+	if (pte_end < end)
+		end = pte_end;
 
-	if (write && !pud_write(orig))
-		return 0;
+	/* hugepages are never "special" */
+	VM_BUG_ON(!pfn_valid(pte_pfn(orig)));
 
 	refs = 0;
-	head = pud_page(orig);
-	page = head + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
+	head = pte_page(orig);
+	page = head + ((addr & (sz-1)) >> PAGE_SHIFT);
 	tail = page;
 	do {
 		VM_BUG_ON_PAGE(compound_head(page) != head, page);
@@ -859,13 +825,18 @@ static int gup_huge_pud(pud_t orig, pud_
 		return 0;
 	}
 
-	if (unlikely(pud_val(orig) != pud_val(*pudp))) {
+	if (unlikely(pte_val(orig) != pte_val(*ptep))) {
 		*nr -= refs;
 		while (refs--)
 			put_page(head);
 		return 0;
 	}
 
+	/*
+	 * Any tail pages need their mapcount reference taken before we
+	 * return. (This allows the THP code to bump their ref count when
+	 * they are split into base pages).
+	 */
 	while (refs--) {
 		if (PageTail(tail))
 			get_huge_page_tail(tail);
@@ -898,10 +869,19 @@ static int gup_pmd_range(pud_t pud, unsi
 			if (pmd_numa(pmd))
 				return 0;
 
-			if (!gup_huge_pmd(pmd, pmdp, addr, next, write,
-				pages, nr))
+			if (!gup_huge_pte(__pte(pmd_val(pmd)), (pte_t *)pmdp,
+					  addr, PMD_SIZE, next,
+					  write, pages, nr))
 				return 0;
 
+		} else if (unlikely(is_hugepd(__hugepd(pmd_val(pmd))))) {
+			/*
+			 * architecture have different format for hugetlbfs
+			 * pmd format and THP pmd format
+			 */
+			if (!gup_hugepd(__hugepd(pmd_val(pmd)), addr, PMD_SHIFT,
+					next, write, pages, nr))
+				return 0;
 		} else if (!gup_pte_range(pmd, addr, next, write, pages, nr))
 				return 0;
 	} while (pmdp++, addr = next, addr != end);
@@ -909,22 +889,27 @@ static int gup_pmd_range(pud_t pud, unsi
 	return 1;
 }
 
-static int gup_pud_range(pgd_t *pgdp, unsigned long addr, unsigned long end,
+static int gup_pud_range(pgd_t pgd, unsigned long addr, unsigned long end,
 		int write, struct page **pages, int *nr)
 {
 	unsigned long next;
 	pud_t *pudp;
 
-	pudp = pud_offset(pgdp, addr);
+	pudp = pud_offset(&pgd, addr);
 	do {
 		pud_t pud = ACCESS_ONCE(*pudp);
 
 		next = pud_addr_end(addr, end);
 		if (pud_none(pud))
 			return 0;
-		if (pud_huge(pud)) {
-			if (!gup_huge_pud(pud, pudp, addr, next, write,
-					pages, nr))
+		if (unlikely(pud_huge(pud))) {
+			if (!gup_huge_pte(__pte(pud_val(pud)), (pte_t *)pudp,
+					  addr, PUD_SIZE, next,
+					  write, pages, nr))
+				return 0;
+		} else if (unlikely(is_hugepd(__hugepd(pud_val(pud))))) {
+			if (!gup_hugepd(__hugepd(pud_val(pud)), addr, PUD_SHIFT,
+					next, write, pages, nr))
 				return 0;
 		} else if (!gup_pmd_range(pud, addr, next, write, pages, nr))
 			return 0;
@@ -970,10 +955,21 @@ int __get_user_pages_fast(unsigned long
 	local_irq_save(flags);
 	pgdp = pgd_offset(mm, addr);
 	do {
+		pgd_t pgd = ACCESS_ONCE(*pgdp);
+
 		next = pgd_addr_end(addr, end);
-		if (pgd_none(*pgdp))
+		if (pgd_none(pgd))
 			break;
-		else if (!gup_pud_range(pgdp, addr, next, write, pages, &nr))
+		if (unlikely(pgd_huge(pgd))) {
+			if (!gup_huge_pte(__pte(pgd_val(pgd)), (pte_t *)pgdp,
+					  addr, PGDIR_SIZE, next,
+					  write, pages, &nr))
+				break;
+		} else if (unlikely(is_hugepd(__hugepd(pgd_val(pgd))))) {
+			if (!gup_hugepd(__hugepd(pgd_val(pgd)), addr, PGDIR_SHIFT,
+					next, write, pages, &nr))
+				break;
+		} else if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
 			break;
 	} while (pgdp++, addr = next, addr != end);
 	local_irq_restore(flags);
@@ -1028,5 +1024,4 @@ int get_user_pages_fast(unsigned long st
 
 	return ret;
 }
