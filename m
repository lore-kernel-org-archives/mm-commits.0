From: akpm@linux-foundation.org
Subject: [merged] mm-drop-tail-page-refcounting.patch removed from -mm
 tree
Date: Tue, 19 Jan 2016 12:01:53 -0800
Message-ID: <569e9631.LdkBo9UR7lozj4sF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932956AbcASUBy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:01:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: drop tail page refcounting
has been removed from the -mm tree.  Its filename was
     mm-drop-tail-page-refcounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: drop tail page refcounting

Tail page refcounting is utterly complicated and painful to support.

It uses ->_mapcount on tail pages to store how many times this page is
pinned. get_page() bumps ->_mapcount on tail page in addition to
->_count on head. This information is required by split_huge_page() to
be able to distribute pins from head of compound page to tails during
the split.

We will need ->_mapcount to account PTE mappings of subpages of the
compound page. We eliminate need in current meaning of ->_mapcount in
tail pages by forbidding split entirely if the page is pinned.

The only user of tail page refcounting is THP which is marked BROKEN for
now.

Let's drop all this mess. It makes get_page() and put_page() much
simpler.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/gup.c            |    4 
 arch/powerpc/mm/hugetlbpage.c |   13 -
 arch/s390/mm/gup.c            |   13 -
 arch/sparc/mm/gup.c           |   14 -
 arch/x86/mm/gup.c             |    4 
 include/linux/mm.h            |   47 +----
 include/linux/mm_types.h      |   17 -
 mm/gup.c                      |   34 ---
 mm/huge_memory.c              |   41 ----
 mm/hugetlb.c                  |    2 
 mm/internal.h                 |   44 -----
 mm/swap.c                     |  273 +-------------------------------
 12 files changed, 40 insertions(+), 466 deletions(-)

diff -puN arch/mips/mm/gup.c~mm-drop-tail-page-refcounting arch/mips/mm/gup.c
--- a/arch/mips/mm/gup.c~mm-drop-tail-page-refcounting
+++ a/arch/mips/mm/gup.c
@@ -87,8 +87,6 @@ static int gup_huge_pmd(pmd_t pmd, unsig
 	do {
 		VM_BUG_ON(compound_head(page) != head);
 		pages[*nr] = page;
-		if (PageTail(page))
-			get_huge_page_tail(page);
 		(*nr)++;
 		page++;
 		refs++;
@@ -153,8 +151,6 @@ static int gup_huge_pud(pud_t pud, unsig
 	do {
 		VM_BUG_ON(compound_head(page) != head);
 		pages[*nr] = page;
-		if (PageTail(page))
-			get_huge_page_tail(page);
 		(*nr)++;
 		page++;
 		refs++;
diff -puN arch/powerpc/mm/hugetlbpage.c~mm-drop-tail-page-refcounting arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~mm-drop-tail-page-refcounting
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -999,7 +999,7 @@ int gup_hugepte(pte_t *ptep, unsigned lo
 {
 	unsigned long mask;
 	unsigned long pte_end;
-	struct page *head, *page, *tail;
+	struct page *head, *page;
 	pte_t pte;
 	int refs;
 
@@ -1022,7 +1022,6 @@ int gup_hugepte(pte_t *ptep, unsigned lo
 	head = pte_page(pte);
 
 	page = head + ((addr & (sz-1)) >> PAGE_SHIFT);
-	tail = page;
 	do {
 		VM_BUG_ON(compound_head(page) != head);
 		pages[*nr] = page;
@@ -1044,15 +1043,5 @@ int gup_hugepte(pte_t *ptep, unsigned lo
 		return 0;
 	}
 
-	/*
-	 * Any tail page need their mapcount reference taken before we
-	 * return.
-	 */
-	while (refs--) {
-		if (PageTail(tail))
-			get_huge_page_tail(tail);
-		tail++;
-	}
-
 	return 1;
 }
diff -puN arch/s390/mm/gup.c~mm-drop-tail-page-refcounting arch/s390/mm/gup.c
--- a/arch/s390/mm/gup.c~mm-drop-tail-page-refcounting
+++ a/arch/s390/mm/gup.c
@@ -55,7 +55,7 @@ static inline int gup_huge_pmd(pmd_t *pm
 		unsigned long end, int write, struct page **pages, int *nr)
 {
 	unsigned long mask, result;
-	struct page *head, *page, *tail;
+	struct page *head, *page;
 	int refs;
 
 	result = write ? 0 : _SEGMENT_ENTRY_PROTECT;
@@ -67,7 +67,6 @@ static inline int gup_huge_pmd(pmd_t *pm
 	refs = 0;
 	head = pmd_page(pmd);
 	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
-	tail = page;
 	do {
 		VM_BUG_ON(compound_head(page) != head);
 		pages[*nr] = page;
@@ -88,16 +87,6 @@ static inline int gup_huge_pmd(pmd_t *pm
 		return 0;
 	}
 
-	/*
-	 * Any tail page need their mapcount reference taken before we
-	 * return.
-	 */
-	while (refs--) {
-		if (PageTail(tail))
-			get_huge_page_tail(tail);
-		tail++;
-	}
-
 	return 1;
 }
 
diff -puN arch/sparc/mm/gup.c~mm-drop-tail-page-refcounting arch/sparc/mm/gup.c
--- a/arch/sparc/mm/gup.c~mm-drop-tail-page-refcounting
+++ a/arch/sparc/mm/gup.c
@@ -56,8 +56,6 @@ static noinline int gup_pte_range(pmd_t
 			put_page(head);
 			return 0;
 		}
-		if (head != page)
-			get_huge_page_tail(page);
 
 		pages[*nr] = page;
 		(*nr)++;
@@ -70,7 +68,7 @@ static int gup_huge_pmd(pmd_t *pmdp, pmd
 			unsigned long end, int write, struct page **pages,
 			int *nr)
 {
-	struct page *head, *page, *tail;
+	struct page *head, *page;
 	int refs;
 
 	if (!(pmd_val(pmd) & _PAGE_VALID))
@@ -82,7 +80,6 @@ static int gup_huge_pmd(pmd_t *pmdp, pmd
 	refs = 0;
 	head = pmd_page(pmd);
 	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
-	tail = page;
 	do {
 		VM_BUG_ON(compound_head(page) != head);
 		pages[*nr] = page;
@@ -103,15 +100,6 @@ static int gup_huge_pmd(pmd_t *pmdp, pmd
 		return 0;
 	}
 
-	/* Any tail page need their mapcount reference taken before we
-	 * return.
-	 */
-	while (refs--) {
-		if (PageTail(tail))
-			get_huge_page_tail(tail);
-		tail++;
-	}
-
 	return 1;
 }
 
diff -puN arch/x86/mm/gup.c~mm-drop-tail-page-refcounting arch/x86/mm/gup.c
--- a/arch/x86/mm/gup.c~mm-drop-tail-page-refcounting
+++ a/arch/x86/mm/gup.c
@@ -136,8 +136,6 @@ static noinline int gup_huge_pmd(pmd_t p
 	do {
 		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 		pages[*nr] = page;
-		if (PageTail(page))
-			get_huge_page_tail(page);
 		(*nr)++;
 		page++;
 		refs++;
@@ -212,8 +210,6 @@ static noinline int gup_huge_pud(pud_t p
 	do {
 		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 		pages[*nr] = page;
-		if (PageTail(page))
-			get_huge_page_tail(page);
 		(*nr)++;
 		page++;
 		refs++;
diff -puN include/linux/mm.h~mm-drop-tail-page-refcounting include/linux/mm.h
--- a/include/linux/mm.h~mm-drop-tail-page-refcounting
+++ a/include/linux/mm.h
@@ -466,44 +466,9 @@ static inline int page_count(struct page
 	return atomic_read(&compound_head(page)->_count);
 }
 
-static inline bool __compound_tail_refcounted(struct page *page)
-{
-	return PageAnon(page) && !PageSlab(page) && !PageHeadHuge(page);
-}
-
-/*
- * This takes a head page as parameter and tells if the
- * tail page reference counting can be skipped.
- *
- * For this to be safe, PageSlab and PageHeadHuge must remain true on
- * any given page where they return true here, until all tail pins
- * have been released.
- */
-static inline bool compound_tail_refcounted(struct page *page)
-{
-	VM_BUG_ON_PAGE(!PageHead(page), page);
-	return __compound_tail_refcounted(page);
-}
-
-static inline void get_huge_page_tail(struct page *page)
-{
-	/*
-	 * __split_huge_page_refcount() cannot run from under us.
-	 */
-	VM_BUG_ON_PAGE(!PageTail(page), page);
-	VM_BUG_ON_PAGE(page_mapcount(page) < 0, page);
-	VM_BUG_ON_PAGE(atomic_read(&page->_count) != 0, page);
-	if (compound_tail_refcounted(compound_head(page)))
-		atomic_inc(&page->_mapcount);
-}
-
-extern bool __get_page_tail(struct page *page);
-
 static inline void get_page(struct page *page)
 {
-	if (unlikely(PageTail(page)))
-		if (likely(__get_page_tail(page)))
-			return;
+	page = compound_head(page);
 	/*
 	 * Getting a normal page or the head of a compound page
 	 * requires to already have an elevated page->_count.
@@ -528,7 +493,15 @@ static inline void init_page_count(struc
 	atomic_set(&page->_count, 1);
 }
 
-void put_page(struct page *page);
+void __put_page(struct page *page);
+
+static inline void put_page(struct page *page)
+{
+	page = compound_head(page);
+	if (put_page_testzero(page))
+		__put_page(page);
+}
+
 void put_pages_list(struct list_head *pages);
 
 void split_page(struct page *page, unsigned int order);
diff -puN include/linux/mm_types.h~mm-drop-tail-page-refcounting include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-drop-tail-page-refcounting
+++ a/include/linux/mm_types.h
@@ -81,20 +81,9 @@ struct page {
 
 				union {
 					/*
-					 * Count of ptes mapped in
-					 * mms, to show when page is
-					 * mapped & limit reverse map
-					 * searches.
-					 *
-					 * Used also for tail pages
-					 * refcounting instead of
-					 * _count. Tail pages cannot
-					 * be mapped and keeping the
-					 * tail page _count zero at
-					 * all times guarantees
-					 * get_page_unless_zero() will
-					 * never succeed on tail
-					 * pages.
+					 * Count of ptes mapped in mms, to show
+					 * when page is mapped & limit reverse
+					 * map searches.
 					 */
 					atomic_t _mapcount;
 
diff -puN mm/gup.c~mm-drop-tail-page-refcounting mm/gup.c
--- a/mm/gup.c~mm-drop-tail-page-refcounting
+++ a/mm/gup.c
@@ -130,7 +130,7 @@ retry:
 	}
 
 	if (flags & FOLL_GET)
-		get_page_foll(page);
+		get_page(page);
 	if (flags & FOLL_TOUCH) {
 		if ((flags & FOLL_WRITE) &&
 		    !pte_dirty(pte) && !PageDirty(page))
@@ -1153,7 +1153,7 @@ static int gup_pte_range(pmd_t pmd, unsi
 static int gup_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
 		unsigned long end, int write, struct page **pages, int *nr)
 {
-	struct page *head, *page, *tail;
+	struct page *head, *page;
 	int refs;
 
 	if (write && !pmd_write(orig))
@@ -1162,7 +1162,6 @@ static int gup_huge_pmd(pmd_t orig, pmd_
 	refs = 0;
 	head = pmd_page(orig);
 	page = head + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
-	tail = page;
 	do {
 		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 		pages[*nr] = page;
@@ -1183,24 +1182,13 @@ static int gup_huge_pmd(pmd_t orig, pmd_
 		return 0;
 	}
 
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
 	return 1;
 }
 
 static int gup_huge_pud(pud_t orig, pud_t *pudp, unsigned long addr,
 		unsigned long end, int write, struct page **pages, int *nr)
 {
-	struct page *head, *page, *tail;
+	struct page *head, *page;
 	int refs;
 
 	if (write && !pud_write(orig))
@@ -1209,7 +1197,6 @@ static int gup_huge_pud(pud_t orig, pud_
 	refs = 0;
 	head = pud_page(orig);
 	page = head + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
-	tail = page;
 	do {
 		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 		pages[*nr] = page;
@@ -1230,12 +1217,6 @@ static int gup_huge_pud(pud_t orig, pud_
 		return 0;
 	}
 
-	while (refs--) {
-		if (PageTail(tail))
-			get_huge_page_tail(tail);
-		tail++;
-	}
-
 	return 1;
 }
 
@@ -1244,7 +1225,7 @@ static int gup_huge_pgd(pgd_t orig, pgd_
 			struct page **pages, int *nr)
 {
 	int refs;
-	struct page *head, *page, *tail;
+	struct page *head, *page;
 
 	if (write && !pgd_write(orig))
 		return 0;
@@ -1252,7 +1233,6 @@ static int gup_huge_pgd(pgd_t orig, pgd_
 	refs = 0;
 	head = pgd_page(orig);
 	page = head + ((addr & ~PGDIR_MASK) >> PAGE_SHIFT);
-	tail = page;
 	do {
 		VM_BUG_ON_PAGE(compound_head(page) != head, page);
 		pages[*nr] = page;
@@ -1273,12 +1253,6 @@ static int gup_huge_pgd(pgd_t orig, pgd_
 		return 0;
 	}
 
-	while (refs--) {
-		if (PageTail(tail))
-			get_huge_page_tail(tail);
-		tail++;
-	}
-
 	return 1;
 }
 
diff -puN mm/huge_memory.c~mm-drop-tail-page-refcounting mm/huge_memory.c
--- a/mm/huge_memory.c~mm-drop-tail-page-refcounting
+++ a/mm/huge_memory.c
@@ -1038,37 +1038,6 @@ unlock:
 	spin_unlock(ptl);
 }
 
-/*
- * Save CONFIG_DEBUG_PAGEALLOC from faulting falsely on tail pages
- * during copy_user_huge_page()'s copy_page_rep(): in the case when
- * the source page gets split and a tail freed before copy completes.
- * Called under pmd_lock of checked pmd, so safe from splitting itself.
- */
-static void get_user_huge_page(struct page *page)
-{
-	if (IS_ENABLED(CONFIG_DEBUG_PAGEALLOC)) {
-		struct page *endpage = page + HPAGE_PMD_NR;
-
-		atomic_add(HPAGE_PMD_NR, &page->_count);
-		while (++page < endpage)
-			get_huge_page_tail(page);
-	} else {
-		get_page(page);
-	}
-}
-
-static void put_user_huge_page(struct page *page)
-{
-	if (IS_ENABLED(CONFIG_DEBUG_PAGEALLOC)) {
-		struct page *endpage = page + HPAGE_PMD_NR;
-
-		while (page < endpage)
-			put_page(page++);
-	} else {
-		put_page(page);
-	}
-}
-
 static int do_huge_pmd_wp_page_fallback(struct mm_struct *mm,
 					struct vm_area_struct *vma,
 					unsigned long address,
@@ -1221,7 +1190,7 @@ int do_huge_pmd_wp_page(struct mm_struct
 		ret |= VM_FAULT_WRITE;
 		goto out_unlock;
 	}
-	get_user_huge_page(page);
+	get_page(page);
 	spin_unlock(ptl);
 alloc:
 	if (transparent_hugepage_enabled(vma) &&
@@ -1242,7 +1211,7 @@ alloc:
 				split_huge_pmd(vma, pmd, address);
 				ret |= VM_FAULT_FALLBACK;
 			}
-			put_user_huge_page(page);
+			put_page(page);
 		}
 		count_vm_event(THP_FAULT_FALLBACK);
 		goto out;
@@ -1253,7 +1222,7 @@ alloc:
 		put_page(new_page);
 		if (page) {
 			split_huge_pmd(vma, pmd, address);
-			put_user_huge_page(page);
+			put_page(page);
 		} else
 			split_huge_pmd(vma, pmd, address);
 		ret |= VM_FAULT_FALLBACK;
@@ -1275,7 +1244,7 @@ alloc:
 
 	spin_lock(ptl);
 	if (page)
-		put_user_huge_page(page);
+		put_page(page);
 	if (unlikely(!pmd_same(*pmd, orig_pmd))) {
 		spin_unlock(ptl);
 		mem_cgroup_cancel_charge(new_page, memcg, true);
@@ -1360,7 +1329,7 @@ struct page *follow_trans_huge_pmd(struc
 	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
 	if (flags & FOLL_GET)
-		get_page_foll(page);
+		get_page(page);
 
 out:
 	return page;
diff -puN mm/hugetlb.c~mm-drop-tail-page-refcounting mm/hugetlb.c
--- a/mm/hugetlb.c~mm-drop-tail-page-refcounting
+++ a/mm/hugetlb.c
@@ -3865,7 +3865,7 @@ long follow_hugetlb_page(struct mm_struc
 same_page:
 		if (pages) {
 			pages[i] = mem_map_offset(page, pfn_offset);
-			get_page_foll(pages[i]);
+			get_page(pages[i]);
 		}
 
 		if (vmas)
diff -puN mm/internal.h~mm-drop-tail-page-refcounting mm/internal.h
--- a/mm/internal.h~mm-drop-tail-page-refcounting
+++ a/mm/internal.h
@@ -66,50 +66,6 @@ static inline void set_page_refcounted(s
 	set_page_count(page, 1);
 }
 
-static inline void __get_page_tail_foll(struct page *page,
-					bool get_page_head)
-{
-	/*
-	 * If we're getting a tail page, the elevated page->_count is
-	 * required only in the head page and we will elevate the head
-	 * page->_count and tail page->_mapcount.
-	 *
-	 * We elevate page_tail->_mapcount for tail pages to force
-	 * page_tail->_count to be zero at all times to avoid getting
-	 * false positives from get_page_unless_zero() with
-	 * speculative page access (like in
-	 * page_cache_get_speculative()) on tail pages.
-	 */
-	VM_BUG_ON_PAGE(atomic_read(&compound_head(page)->_count) <= 0, page);
-	if (get_page_head)
-		atomic_inc(&compound_head(page)->_count);
-	get_huge_page_tail(page);
-}
-
-/*
- * This is meant to be called as the FOLL_GET operation of
- * follow_page() and it must be called while holding the proper PT
- * lock while the pte (or pmd_trans_huge) is still mapping the page.
- */
-static inline void get_page_foll(struct page *page)
-{
-	if (unlikely(PageTail(page)))
-		/*
-		 * This is safe only because
-		 * __split_huge_page_refcount() can't run under
-		 * get_page_foll() because we hold the proper PT lock.
-		 */
-		__get_page_tail_foll(page, true);
-	else {
-		/*
-		 * Getting a normal page or the head of a compound page
-		 * requires to already have an elevated page->_count.
-		 */
-		VM_BUG_ON_PAGE(atomic_read(&page->_count) <= 0, page);
-		atomic_inc(&page->_count);
-	}
-}
-
 extern unsigned long highest_memmap_pfn;
 
 /*
diff -puN mm/swap.c~mm-drop-tail-page-refcounting mm/swap.c
--- a/mm/swap.c~mm-drop-tail-page-refcounting
+++ a/mm/swap.c
@@ -89,260 +89,14 @@ static void __put_compound_page(struct p
 	(*dtor)(page);
 }
 
-/**
- * Two special cases here: we could avoid taking compound_lock_irqsave
- * and could skip the tail refcounting(in _mapcount).
- *
- * 1. Hugetlbfs page:
- *
- *    PageHeadHuge will remain true until the compound page
- *    is released and enters the buddy allocator, and it could
- *    not be split by __split_huge_page_refcount().
- *
- *    So if we see PageHeadHuge set, and we have the tail page pin,
- *    then we could safely put head page.
- *
- * 2. Slab THP page:
- *
- *    PG_slab is cleared before the slab frees the head page, and
- *    tail pin cannot be the last reference left on the head page,
- *    because the slab code is free to reuse the compound page
- *    after a kfree/kmem_cache_free without having to check if
- *    there's any tail pin left.  In turn all tail pinsmust be always
- *    released while the head is still pinned by the slab code
- *    and so we know PG_slab will be still set too.
- *
- *    So if we see PageSlab set, and we have the tail page pin,
- *    then we could safely put head page.
- */
-static __always_inline
-void put_unrefcounted_compound_page(struct page *page_head, struct page *page)
-{
-	/*
-	 * If @page is a THP tail, we must read the tail page
-	 * flags after the head page flags. The
-	 * __split_huge_page_refcount side enforces write memory barriers
-	 * between clearing PageTail and before the head page
-	 * can be freed and reallocated.
-	 */
-	smp_rmb();
-	if (likely(PageTail(page))) {
-		/*
-		 * __split_huge_page_refcount cannot race
-		 * here, see the comment above this function.
-		 */
-		VM_BUG_ON_PAGE(!PageHead(page_head), page_head);
-		if (put_page_testzero(page_head)) {
-			/*
-			 * If this is the tail of a slab THP page,
-			 * the tail pin must not be the last reference
-			 * held on the page, because the PG_slab cannot
-			 * be cleared before all tail pins (which skips
-			 * the _mapcount tail refcounting) have been
-			 * released.
-			 *
-			 * If this is the tail of a hugetlbfs page,
-			 * the tail pin may be the last reference on
-			 * the page instead, because PageHeadHuge will
-			 * not go away until the compound page enters
-			 * the buddy allocator.
-			 */
-			VM_BUG_ON_PAGE(PageSlab(page_head), page_head);
-			__put_compound_page(page_head);
-		}
-	} else
-		/*
-		 * __split_huge_page_refcount run before us,
-		 * @page was a THP tail. The split @page_head
-		 * has been freed and reallocated as slab or
-		 * hugetlbfs page of smaller order (only
-		 * possible if reallocated as slab on x86).
-		 */
-		if (put_page_testzero(page))
-			__put_single_page(page);
-}
-
-static __always_inline
-void put_refcounted_compound_page(struct page *page_head, struct page *page)
-{
-	if (likely(page != page_head && get_page_unless_zero(page_head))) {
-		unsigned long flags;
-
-		/*
-		 * @page_head wasn't a dangling pointer but it may not
-		 * be a head page anymore by the time we obtain the
-		 * lock. That is ok as long as it can't be freed from
-		 * under us.
-		 */
-		flags = compound_lock_irqsave(page_head);
-		if (unlikely(!PageTail(page))) {
-			/* __split_huge_page_refcount run before us */
-			compound_unlock_irqrestore(page_head, flags);
-			if (put_page_testzero(page_head)) {
-				/*
-				 * The @page_head may have been freed
-				 * and reallocated as a compound page
-				 * of smaller order and then freed
-				 * again.  All we know is that it
-				 * cannot have become: a THP page, a
-				 * compound page of higher order, a
-				 * tail page.  That is because we
-				 * still hold the refcount of the
-				 * split THP tail and page_head was
-				 * the THP head before the split.
-				 */
-				if (PageHead(page_head))
-					__put_compound_page(page_head);
-				else
-					__put_single_page(page_head);
-			}
-out_put_single:
-			if (put_page_testzero(page))
-				__put_single_page(page);
-			return;
-		}
-		VM_BUG_ON_PAGE(page_head != compound_head(page), page);
-		/*
-		 * We can release the refcount taken by
-		 * get_page_unless_zero() now that
-		 * __split_huge_page_refcount() is blocked on the
-		 * compound_lock.
-		 */
-		if (put_page_testzero(page_head))
-			VM_BUG_ON_PAGE(1, page_head);
-		/* __split_huge_page_refcount will wait now */
-		VM_BUG_ON_PAGE(page_mapcount(page) <= 0, page);
-		atomic_dec(&page->_mapcount);
-		VM_BUG_ON_PAGE(atomic_read(&page_head->_count) <= 0, page_head);
-		VM_BUG_ON_PAGE(atomic_read(&page->_count) != 0, page);
-		compound_unlock_irqrestore(page_head, flags);
-
-		if (put_page_testzero(page_head)) {
-			if (PageHead(page_head))
-				__put_compound_page(page_head);
-			else
-				__put_single_page(page_head);
-		}
-	} else {
-		/* @page_head is a dangling pointer */
-		VM_BUG_ON_PAGE(PageTail(page), page);
-		goto out_put_single;
-	}
-}
-
-static void put_compound_page(struct page *page)
-{
-	struct page *page_head;
-
-	/*
-	 * We see the PageCompound set and PageTail not set, so @page maybe:
-	 *  1. hugetlbfs head page, or
-	 *  2. THP head page.
-	 */
-	if (likely(!PageTail(page))) {
-		if (put_page_testzero(page)) {
-			/*
-			 * By the time all refcounts have been released
-			 * split_huge_page cannot run anymore from under us.
-			 */
-			if (PageHead(page))
-				__put_compound_page(page);
-			else
-				__put_single_page(page);
-		}
-		return;
-	}
-
-	/*
-	 * We see the PageCompound set and PageTail set, so @page maybe:
-	 *  1. a tail hugetlbfs page, or
-	 *  2. a tail THP page, or
-	 *  3. a split THP page.
-	 *
-	 *  Case 3 is possible, as we may race with
-	 *  __split_huge_page_refcount tearing down a THP page.
-	 */
-	page_head = compound_head(page);
-	if (!__compound_tail_refcounted(page_head))
-		put_unrefcounted_compound_page(page_head, page);
-	else
-		put_refcounted_compound_page(page_head, page);
-}
-
-void put_page(struct page *page)
+void __put_page(struct page *page)
 {
 	if (unlikely(PageCompound(page)))
-		put_compound_page(page);
-	else if (put_page_testzero(page))
+		__put_compound_page(page);
+	else
 		__put_single_page(page);
 }
-EXPORT_SYMBOL(put_page);
-
-/*
- * This function is exported but must not be called by anything other
- * than get_page(). It implements the slow path of get_page().
- */
-bool __get_page_tail(struct page *page)
-{
-	/*
-	 * This takes care of get_page() if run on a tail page
-	 * returned by one of the get_user_pages/follow_page variants.
-	 * get_user_pages/follow_page itself doesn't need the compound
-	 * lock because it runs __get_page_tail_foll() under the
-	 * proper PT lock that already serializes against
-	 * split_huge_page().
-	 */
-	unsigned long flags;
-	bool got;
-	struct page *page_head = compound_head(page);
-
-	/* Ref to put_compound_page() comment. */
-	if (!__compound_tail_refcounted(page_head)) {
-		smp_rmb();
-		if (likely(PageTail(page))) {
-			/*
-			 * This is a hugetlbfs page or a slab
-			 * page. __split_huge_page_refcount
-			 * cannot race here.
-			 */
-			VM_BUG_ON_PAGE(!PageHead(page_head), page_head);
-			__get_page_tail_foll(page, true);
-			return true;
-		} else {
-			/*
-			 * __split_huge_page_refcount run
-			 * before us, "page" was a THP
-			 * tail. The split page_head has been
-			 * freed and reallocated as slab or
-			 * hugetlbfs page of smaller order
-			 * (only possible if reallocated as
-			 * slab on x86).
-			 */
-			return false;
-		}
-	}
-
-	got = false;
-	if (likely(page != page_head && get_page_unless_zero(page_head))) {
-		/*
-		 * page_head wasn't a dangling pointer but it
-		 * may not be a head page anymore by the time
-		 * we obtain the lock. That is ok as long as it
-		 * can't be freed from under us.
-		 */
-		flags = compound_lock_irqsave(page_head);
-		/* here __split_huge_page_refcount won't run anymore */
-		if (likely(PageTail(page))) {
-			__get_page_tail_foll(page, false);
-			got = true;
-		}
-		compound_unlock_irqrestore(page_head, flags);
-		if (unlikely(!got))
-			put_page(page_head);
-	}
-	return got;
-}
-EXPORT_SYMBOL(__get_page_tail);
+EXPORT_SYMBOL(__put_page);
 
 /**
  * put_pages_list() - release a list of pages
@@ -918,15 +672,6 @@ void release_pages(struct page **pages,
 	for (i = 0; i < nr; i++) {
 		struct page *page = pages[i];
 
-		if (unlikely(PageCompound(page))) {
-			if (zone) {
-				spin_unlock_irqrestore(&zone->lru_lock, flags);
-				zone = NULL;
-			}
-			put_compound_page(page);
-			continue;
-		}
-
 		/*
 		 * Make sure the IRQ-safe lock-holding time does not get
 		 * excessive with a continuous string of pages from the
@@ -937,9 +682,19 @@ void release_pages(struct page **pages,
 			zone = NULL;
 		}
 
+		page = compound_head(page);
 		if (!put_page_testzero(page))
 			continue;
 
+		if (PageCompound(page)) {
+			if (zone) {
+				spin_unlock_irqrestore(&zone->lru_lock, flags);
+				zone = NULL;
+			}
+			__put_compound_page(page);
+			continue;
+		}
+
 		if (PageLRU(page)) {
 			struct zone *pagezone = page_zone(page);
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
thp-add-debugfs-handle-to-split-all-huge-pages.patch
thp-increase-split_huge_page-success-rate.patch
thp-fix-split_huge_page-after-mremap-of-thp.patch
memblock-fix-section-mismatch.patch
mm-fix-locking-order-in-mm_take_all_locks.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

