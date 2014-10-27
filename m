From: akpm@linux-foundation.org
Subject: +
 mm-update-generic-gup-implementation-to-handle-hugepage-directory.patch
 added to -mm tree
Date: Mon, 27 Oct 2014 16:05:01 -0700
Message-ID: <544ecf9d.tFu+1hAOow0//SLK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41076 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaJ0XFD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Oct 2014 19:05:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, aarcange@redhat.com, benh@kernel.crashing.org, mpe@ellerman.id.au, steve.capper@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: update generic gup implementation to handle hugepage directory
has been added to the -mm tree.  Its filename is
     mm-update-generic-gup-implementation-to-handle-hugepage-directory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-update-generic-gup-implementation-to-handle-hugepage-directory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-update-generic-gup-implementation-to-handle-hugepage-directory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm: update generic gup implementation to handle hugepage directory

Update generic gup implementation with powerpc specific details.  On
powerpc at pmd level we can have hugepte, normal pmd pointer or a pointer
to the hugepage directory.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable.h   |    2 
 arch/arm64/include/asm/pgtable.h |    2 
 arch/powerpc/include/asm/page.h  |    1 
 include/linux/hugetlb.h          |   30 +++++++
 include/linux/mm.h               |    7 +
 mm/gup.c                         |  113 +++++++++++++----------------
 6 files changed, 96 insertions(+), 59 deletions(-)

diff -puN arch/arm/include/asm/pgtable.h~mm-update-generic-gup-implementation-to-handle-hugepage-directory arch/arm/include/asm/pgtable.h
--- a/arch/arm/include/asm/pgtable.h~mm-update-generic-gup-implementation-to-handle-hugepage-directory
+++ a/arch/arm/include/asm/pgtable.h
@@ -181,6 +181,8 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD
 /* to find an entry in a kernel page-table-directory */
 #define pgd_offset_k(addr)	pgd_offset(&init_mm, addr)
 
+#define pgd_huge(pgd)		(0)
+
 #define pmd_none(pmd)		(!pmd_val(pmd))
 #define pmd_present(pmd)	(pmd_val(pmd))
 
diff -puN arch/arm64/include/asm/pgtable.h~mm-update-generic-gup-implementation-to-handle-hugepage-directory arch/arm64/include/asm/pgtable.h
--- a/arch/arm64/include/asm/pgtable.h~mm-update-generic-gup-implementation-to-handle-hugepage-directory
+++ a/arch/arm64/include/asm/pgtable.h
@@ -464,6 +464,8 @@ static inline pmd_t pmd_modify(pmd_t pmd
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 extern pgd_t idmap_pg_dir[PTRS_PER_PGD];
 
+#define pgd_huge(pgd)		(0)
+
 /*
  * Encode and decode a swap entry:
  *	bits 0-1:	present (must be zero)
diff -puN arch/powerpc/include/asm/page.h~mm-update-generic-gup-implementation-to-handle-hugepage-directory arch/powerpc/include/asm/page.h
--- a/arch/powerpc/include/asm/page.h~mm-update-generic-gup-implementation-to-handle-hugepage-directory
+++ a/arch/powerpc/include/asm/page.h
@@ -380,6 +380,7 @@ static inline int hugepd_ok(hugepd_t hpd
 #endif
 
 #define is_hugepd(pdep)               (hugepd_ok(*((hugepd_t *)(pdep))))
+#define pgd_huge pgd_huge
 int pgd_huge(pgd_t pgd);
 #else /* CONFIG_HUGETLB_PAGE */
 #define is_hugepd(pdep)			0
diff -puN include/linux/hugetlb.h~mm-update-generic-gup-implementation-to-handle-hugepage-directory include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-update-generic-gup-implementation-to-handle-hugepage-directory
+++ a/include/linux/hugetlb.h
@@ -175,6 +175,36 @@ static inline void __unmap_hugepage_rang
 }
 
 #endif /* !CONFIG_HUGETLB_PAGE */
+/*
+ * hugepages at page global directory. If arch support
+ * hugepages at pgd level, they need to define this.
+ */
+#ifndef pgd_huge
+#define pgd_huge(x)	0
+#endif
+
+#ifndef is_hugepd
+/*
+ * Some architectures requires a hugepage directory format that is
+ * required to support multiple hugepage sizes. For example
+ * a4fe3ce7699bfe1bd88f816b55d42d8fe1dac655 introduced the same
+ * on powerpc. This allows for a more flexible hugepage pagetable
+ * layout.
+ */
+typedef struct { unsigned long pd; } hugepd_t;
+#define is_hugepd(hugepd) (0)
+#define __hugepd(x) ((hugepd_t) { (x) })
+static inline int gup_huge_pd(hugepd_t hugepd, unsigned long addr,
+			      unsigned pdshift, unsigned long end,
+			      int write, struct page **pages, int *nr)
+{
+	return 0;
+}
+#else
+extern int gup_huge_pd(hugepd_t hugepd, unsigned long addr,
+		       unsigned pdshift, unsigned long end,
+		       int write, struct page **pages, int *nr);
+#endif
 
 #define HUGETLB_ANON_FILE "anon_hugepage"
 
diff -puN include/linux/mm.h~mm-update-generic-gup-implementation-to-handle-hugepage-directory include/linux/mm.h
--- a/include/linux/mm.h~mm-update-generic-gup-implementation-to-handle-hugepage-directory
+++ a/include/linux/mm.h
@@ -1220,6 +1220,13 @@ long get_user_pages(struct task_struct *
 		    struct vm_area_struct **vmas);
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
+
+#ifdef CONFIG_HAVE_GENERIC_RCU_GUP
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
+			if (!gup_huge_pd(__hugepd(pmd_val(pmd)), addr,
+					 PMD_SHIFT, next, write, pages, nr))
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
+			if (!gup_huge_pd(__hugepd(pud_val(pud)), addr,
+					 PUD_SHIFT, next, write, pages, nr))
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
+			if (!gup_huge_pd(__hugepd(pgd_val(pgd)), addr,
+					 PGDIR_SHIFT, next, write, pages, &nr))
+				break;
+		} else if (!gup_pud_range(pgd, addr, next, write, pages, &nr))
 			break;
 	} while (pgdp++, addr = next, addr != end);
 	local_irq_restore(flags);
@@ -1028,5 +1024,4 @@ int get_user_pages_fast(unsigned long st
 
 	return ret;
 }
