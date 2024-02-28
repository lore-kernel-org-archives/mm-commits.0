Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED1A71EDD
	for <mm-commits@vger.kernel.org>; Wed, 28 Feb 2024 18:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709146756; cv=none; b=f1bSukZmAV5sv1rcZM8eifol1yRNn9aOJkkxNe8ub2DafJJDan3GqniQUWp3Tc0uNrCHaH1ZoUwTZzHI1FwcXpcTL03iHmFokvCHZLepR6fzLLX2krfYSW2gjfiD7+GkAV5eNM8YJlOK23fhid4w/BUuxiZNPya17F2Cvqk6n1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709146756; c=relaxed/simple;
	bh=8RtyfYVyFrEhD1bxGarTWTcmT97GQe2fPUU4adNoQKc=;
	h=Date:To:From:Subject:Message-Id; b=ID/Bilb/JLAaEz28GsAMA2Xj/8+0v4DhzbJNBjjBEERfVd6lhetNTVecT6XIwMYOkrAC6p1gRDwmPi52IHSjHDPc5enJtgTYgOnKEAMBpckC0ZiIxt7c1bwuIUcIMZOCuyolhMtOHtgbEFqC0c59LBbXrOGd9yCgTtKAfn1FP2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xhKCEJfe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xhKCEJfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCD7C433C7;
	Wed, 28 Feb 2024 18:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709146755;
	bh=8RtyfYVyFrEhD1bxGarTWTcmT97GQe2fPUU4adNoQKc=;
	h=Date:To:From:Subject:From;
	b=xhKCEJfepkSbd/2fdMgklQ75PbLL5o9BoUblddzH1XaOKIBx4A37IQLWH41VdEqNo
	 UbSa/3ItU/KLcHH+pq+LETI6sS0qTTe75PQUZWh9eu/v6QcbagNkZaMMh0ZShxBLj2
	 ixCfwgNr3dYbv4R5nix4P40O1g3HSLiSOwoP66Dk=
Date: Wed, 28 Feb 2024 10:59:14 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-constify-more-page-folio-tests.patch added to mm-unstable branch
Message-Id: <20240228185915.6CCD7C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: constify more page/folio tests
has been added to the -mm mm-unstable branch.  Its filename is
     mm-constify-more-page-folio-tests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-constify-more-page-folio-tests.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: constify more page/folio tests
Date: Tue, 27 Feb 2024 19:23:34 +0000

Constify the flag tests that aren't automatically generated and the tests
that look like flag tests but are more complicated.

Link: https://lkml.kernel.org/r/20240227192337.757313-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   52 +++++++++++++++++------------------
 mm/hugetlb.c               |    4 +-
 2 files changed, 28 insertions(+), 28 deletions(-)

--- a/include/linux/page-flags.h~mm-constify-more-page-folio-tests
+++ a/include/linux/page-flags.h
@@ -558,13 +558,13 @@ PAGEFLAG_FALSE(HighMem, highmem)
 #endif
 
 #ifdef CONFIG_SWAP
-static __always_inline bool folio_test_swapcache(struct folio *folio)
+static __always_inline bool folio_test_swapcache(const struct folio *folio)
 {
 	return folio_test_swapbacked(folio) &&
-			test_bit(PG_swapcache, folio_flags(folio, 0));
+			test_bit(PG_swapcache, const_folio_flags(folio, 0));
 }
 
-static __always_inline bool PageSwapCache(struct page *page)
+static __always_inline bool PageSwapCache(const struct page *page)
 {
 	return folio_test_swapcache(page_folio(page));
 }
@@ -663,22 +663,22 @@ PAGEFLAG_FALSE(VmemmapSelfHosted, vmemma
  */
 #define PAGE_MAPPING_DAX_SHARED	((void *)0x1)
 
-static __always_inline bool folio_mapping_flags(struct folio *folio)
+static __always_inline bool folio_mapping_flags(const struct folio *folio)
 {
 	return ((unsigned long)folio->mapping & PAGE_MAPPING_FLAGS) != 0;
 }
 
-static __always_inline int PageMappingFlags(struct page *page)
+static __always_inline int PageMappingFlags(const struct page *page)
 {
 	return ((unsigned long)page->mapping & PAGE_MAPPING_FLAGS) != 0;
 }
 
-static __always_inline bool folio_test_anon(struct folio *folio)
+static __always_inline bool folio_test_anon(const struct folio *folio)
 {
 	return ((unsigned long)folio->mapping & PAGE_MAPPING_ANON) != 0;
 }
 
-static __always_inline bool PageAnon(struct page *page)
+static __always_inline bool PageAnon(const struct page *page)
 {
 	return folio_test_anon(page_folio(page));
 }
@@ -689,7 +689,7 @@ static __always_inline bool __folio_test
 			PAGE_MAPPING_MOVABLE;
 }
 
-static __always_inline int __PageMovable(struct page *page)
+static __always_inline int __PageMovable(const struct page *page)
 {
 	return ((unsigned long)page->mapping & PAGE_MAPPING_FLAGS) ==
 				PAGE_MAPPING_MOVABLE;
@@ -702,13 +702,13 @@ static __always_inline int __PageMovable
  * is found in VM_MERGEABLE vmas.  It's a PageAnon page, pointing not to any
  * anon_vma, but to that page's node of the stable tree.
  */
-static __always_inline bool folio_test_ksm(struct folio *folio)
+static __always_inline bool folio_test_ksm(const struct folio *folio)
 {
 	return ((unsigned long)folio->mapping & PAGE_MAPPING_FLAGS) ==
 				PAGE_MAPPING_KSM;
 }
 
-static __always_inline bool PageKsm(struct page *page)
+static __always_inline bool PageKsm(const struct page *page)
 {
 	return folio_test_ksm(page_folio(page));
 }
@@ -747,9 +747,9 @@ static inline bool folio_xor_flags_has_w
  * some of the bytes in it may be; see the is_partially_uptodate()
  * address_space operation.
  */
-static inline bool folio_test_uptodate(struct folio *folio)
+static inline bool folio_test_uptodate(const struct folio *folio)
 {
-	bool ret = test_bit(PG_uptodate, folio_flags(folio, 0));
+	bool ret = test_bit(PG_uptodate, const_folio_flags(folio, 0));
 	/*
 	 * Must ensure that the data we read out of the folio is loaded
 	 * _after_ we've loaded folio->flags to check the uptodate bit.
@@ -764,7 +764,7 @@ static inline bool folio_test_uptodate(s
 	return ret;
 }
 
-static inline int PageUptodate(struct page *page)
+static inline int PageUptodate(const struct page *page)
 {
 	return folio_test_uptodate(page_folio(page));
 }
@@ -806,9 +806,9 @@ void set_page_writeback(struct page *pag
 #define folio_start_writeback_keepwrite(folio)	\
 	__folio_start_writeback(folio, true)
 
-static __always_inline bool folio_test_head(struct folio *folio)
+static __always_inline bool folio_test_head(const struct folio *folio)
 {
-	return test_bit(PG_head, folio_flags(folio, FOLIO_PF_ANY));
+	return test_bit(PG_head, const_folio_flags(folio, FOLIO_PF_ANY));
 }
 
 static __always_inline int PageHead(const struct page *page)
@@ -827,7 +827,7 @@ CLEARPAGEFLAG(Head, head, PF_ANY)
  *
  * Return: True if the folio is larger than one page.
  */
-static inline bool folio_test_large(struct folio *folio)
+static inline bool folio_test_large(const struct folio *folio)
 {
 	return folio_test_head(folio);
 }
@@ -856,7 +856,7 @@ TESTPAGEFLAG_FALSE(LargeRmappable, large
 #define PG_head_mask ((1UL << PG_head))
 
 #ifdef CONFIG_HUGETLB_PAGE
-int PageHuge(struct page *page);
+int PageHuge(const struct page *page);
 SETPAGEFLAG(HugeTLB, hugetlb, PF_SECOND)
 CLEARPAGEFLAG(HugeTLB, hugetlb, PF_SECOND)
 
@@ -869,10 +869,10 @@ CLEARPAGEFLAG(HugeTLB, hugetlb, PF_SECON
  * Return: True for hugetlbfs folios, false for anon folios or folios
  * belonging to other filesystems.
  */
-static inline bool folio_test_hugetlb(struct folio *folio)
+static inline bool folio_test_hugetlb(const struct folio *folio)
 {
 	return folio_test_large(folio) &&
-		test_bit(PG_hugetlb, folio_flags(folio, 1));
+		test_bit(PG_hugetlb, const_folio_flags(folio, 1));
 }
 #else
 TESTPAGEFLAG_FALSE(Huge, hugetlb)
@@ -887,7 +887,7 @@ TESTPAGEFLAG_FALSE(Huge, hugetlb)
  * hugetlbfs pages, but not normal pages. PageTransHuge() can only be
  * called only in the core VM paths where hugetlbfs pages can't exist.
  */
-static inline int PageTransHuge(struct page *page)
+static inline int PageTransHuge(const struct page *page)
 {
 	VM_BUG_ON_PAGE(PageTail(page), page);
 	return PageHead(page);
@@ -898,7 +898,7 @@ static inline int PageTransHuge(struct p
  * and hugetlbfs pages, so it should only be called when it's known
  * that hugetlbfs pages aren't involved.
  */
-static inline int PageTransCompound(struct page *page)
+static inline int PageTransCompound(const struct page *page)
 {
 	return PageCompound(page);
 }
@@ -908,7 +908,7 @@ static inline int PageTransCompound(stru
  * and hugetlbfs pages, so it should only be called when it's known
  * that hugetlbfs pages aren't involved.
  */
-static inline int PageTransTail(struct page *page)
+static inline int PageTransTail(const struct page *page)
 {
 	return PageTail(page);
 }
@@ -972,7 +972,7 @@ static inline int page_type_has_type(uns
 	return (int)page_type < PAGE_MAPCOUNT_RESERVE;
 }
 
-static inline int page_has_type(struct page *page)
+static inline int page_has_type(const struct page *page)
 {
 	return page_type_has_type(page->page_type);
 }
@@ -1056,7 +1056,7 @@ extern bool is_free_buddy_page(struct pa
 
 PAGEFLAG(Isolated, isolated, PF_ANY);
 
-static __always_inline int PageAnonExclusive(struct page *page)
+static __always_inline int PageAnonExclusive(const struct page *page)
 {
 	VM_BUG_ON_PGFLAGS(!PageAnon(page), page);
 	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
@@ -1129,12 +1129,12 @@ static __always_inline void __ClearPageA
  * Determine if a page has private stuff, indicating that release routines
  * should be invoked upon it.
  */
-static inline int page_has_private(struct page *page)
+static inline int page_has_private(const struct page *page)
 {
 	return !!(page->flags & PAGE_FLAGS_PRIVATE);
 }
 
-static inline bool folio_has_private(struct folio *folio)
+static inline bool folio_has_private(const struct folio *folio)
 {
 	return page_has_private(&folio->page);
 }
--- a/mm/hugetlb.c~mm-constify-more-page-folio-tests
+++ a/mm/hugetlb.c
@@ -2164,9 +2164,9 @@ static bool prep_compound_gigantic_folio
  * transparent huge pages.  See the PageTransHuge() documentation for more
  * details.
  */
-int PageHuge(struct page *page)
+int PageHuge(const struct page *page)
 {
-	struct folio *folio;
+	const struct folio *folio;
 
 	if (!PageCompound(page))
 		return 0;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-support-order-1-folios-in-the-page-cache.patch
mm-make-folios_put-the-basis-of-release_pages.patch
mm-convert-free_unref_page_list-to-use-folios.patch
mm-add-free_unref_folios.patch
mm-use-folios_put-in-__folio_batch_release.patch
memcg-add-mem_cgroup_uncharge_folios.patch
mm-remove-use-of-folio-list-from-folios_put.patch
mm-use-free_unref_folios-in-put_pages_list.patch
mm-use-__page_cache_release-in-folios_put.patch
mm-handle-large-folios-in-free_unref_folios.patch
mm-allow-non-hugetlb-large-folios-to-be-batch-processed.patch
mm-free-folios-in-a-batch-in-shrink_folio_list.patch
mm-free-folios-directly-in-move_folios_to_lru.patch
memcg-remove-mem_cgroup_uncharge_list.patch
mm-remove-free_unref_page_list.patch
mm-remove-lru_to_page.patch
mm-convert-free_pages_and_swap_cache-to-use-folios_put.patch
mm-use-a-folio-in-__collapse_huge_page_copy_succeeded.patch
mm-convert-free_swap_cache-to-take-a-folio.patch
mm-use-folio-more-widely-in-__split_huge_page.patch
mm-separate-out-folio_flags-from-pageflags.patch
mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch
mm-remove-pageyoung-and-pageidle-definitions.patch
mm-add-__dump_folio.patch
mm-make-dump_page-take-a-const-argument.patch
mm-constify-testing-page-folio-flags.patch
mm-constify-more-page-folio-tests.patch
mm-remove-cast-from-page_to_nid.patch

