Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAC37442F
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 20:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711486006; cv=none; b=hw5U04ZZb1rahhqzzjGdoBg9Sb+TNCwHHyCQ1Bj7aSK9g5IbGXE+HzW68zL15EXzXZ6IOlY2sSdlwjrs05cJ1sbjI0dnWHVo3/pMT52/c5VtBDrYTsG5n4DCCe8K2EUL8xE4myW0fxb90GMit1lut7qS2EvfZTqEcT1puvahgA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711486006; c=relaxed/simple;
	bh=sT55g5VqWKiWJ0P3xMuu4jlWV3XuyxCb5P7Cuo50894=;
	h=Date:To:From:Subject:Message-Id; b=VI36dapVnZFAVpGyNTxBzF9MUq0WsUBe7ADVP0GL9QrPUvSXzAk3LTPG3v9M59UwTeFjQM2kIEG/gPuJpmoXDbeQz0KfShTkC/GkMOyo074O8RJF09UpDlaf3oGndjbwIX3H1pxBAl9W0+3H5pgb1OiHQ1jgEeEEdM/CSUO66Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dviLOhsd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dviLOhsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFB9C433F1;
	Tue, 26 Mar 2024 20:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711486006;
	bh=sT55g5VqWKiWJ0P3xMuu4jlWV3XuyxCb5P7Cuo50894=;
	h=Date:To:From:Subject:From;
	b=dviLOhsdV3ii5dqFQODMNu3mCKGzDQ9Gzxl5GufJB8Qtba1Y43BuTfo3Z7Kc9lgiQ
	 E63hrmRorcIhqavGEjE+rh+GmxY60Lm5vKOV9k94hzax5hG5j4c8pTdOQHm4qZAn8S
	 q9GV0kO9gvxbixHFiihftXygVHJQYLy+caoo3LNM=
Date: Tue, 26 Mar 2024 13:46:45 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-huge_zero_page-to-huge_zero_folio.patch added to mm-unstable branch
Message-Id: <20240326204645.ECFB9C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert huge_zero_page to huge_zero_folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-huge_zero_page-to-huge_zero_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-huge_zero_page-to-huge_zero_folio.patch

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
Subject: mm: convert huge_zero_page to huge_zero_folio
Date: Tue, 26 Mar 2024 20:28:25 +0000

With all callers of is_huge_zero_page() converted, we can now switch the
huge_zero_page itself from being a compound page to a folio.

Link: https://lkml.kernel.org/r/20240326202833.523759-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   21 ++++++++-------------
 mm/huge_memory.c        |   28 ++++++++++++++--------------
 2 files changed, 22 insertions(+), 27 deletions(-)

--- a/include/linux/huge_mm.h~mm-convert-huge_zero_page-to-huge_zero_folio
+++ a/include/linux/huge_mm.h
@@ -348,17 +348,12 @@ struct page *follow_devmap_pud(struct vm
 
 vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf);
 
-extern struct page *huge_zero_page;
+extern struct folio *huge_zero_folio;
 extern unsigned long huge_zero_pfn;
 
-static inline bool is_huge_zero_page(const struct page *page)
-{
-	return READ_ONCE(huge_zero_page) == page;
-}
-
 static inline bool is_huge_zero_folio(const struct folio *folio)
 {
-	return READ_ONCE(huge_zero_page) == &folio->page;
+	return READ_ONCE(huge_zero_folio) == folio;
 }
 
 static inline bool is_huge_zero_pmd(pmd_t pmd)
@@ -371,9 +366,14 @@ static inline bool is_huge_zero_pud(pud_
 	return false;
 }
 
-struct page *mm_get_huge_zero_page(struct mm_struct *mm);
+struct folio *mm_get_huge_zero_folio(struct mm_struct *mm);
 void mm_put_huge_zero_page(struct mm_struct *mm);
 
+static inline struct page *mm_get_huge_zero_page(struct mm_struct *mm)
+{
+	return &mm_get_huge_zero_folio(mm)->page;
+}
+
 #define mk_huge_pmd(page, prot) pmd_mkhuge(mk_pmd(page, prot))
 
 static inline bool thp_migration_supported(void)
@@ -485,11 +485,6 @@ static inline vm_fault_t do_huge_pmd_num
 	return 0;
 }
 
-static inline bool is_huge_zero_page(const struct page *page)
-{
-	return false;
-}
-
 static inline bool is_huge_zero_folio(const struct folio *folio)
 {
 	return false;
--- a/mm/huge_memory.c~mm-convert-huge_zero_page-to-huge_zero_folio
+++ a/mm/huge_memory.c
@@ -74,7 +74,7 @@ static unsigned long deferred_split_scan
 					 struct shrink_control *sc);
 
 static atomic_t huge_zero_refcount;
-struct page *huge_zero_page __read_mostly;
+struct folio *huge_zero_folio __read_mostly;
 unsigned long huge_zero_pfn __read_mostly = ~0UL;
 unsigned long huge_anon_orders_always __read_mostly;
 unsigned long huge_anon_orders_madvise __read_mostly;
@@ -192,24 +192,24 @@ unsigned long __thp_vma_allowable_orders
 
 static bool get_huge_zero_page(void)
 {
-	struct page *zero_page;
+	struct folio *zero_folio;
 retry:
 	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
 		return true;
 
-	zero_page = alloc_pages((GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE,
+	zero_folio = folio_alloc((GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE,
 			HPAGE_PMD_ORDER);
-	if (!zero_page) {
+	if (!zero_folio) {
 		count_vm_event(THP_ZERO_PAGE_ALLOC_FAILED);
 		return false;
 	}
 	preempt_disable();
-	if (cmpxchg(&huge_zero_page, NULL, zero_page)) {
+	if (cmpxchg(&huge_zero_folio, NULL, zero_folio)) {
 		preempt_enable();
-		__free_pages(zero_page, compound_order(zero_page));
+		folio_put(zero_folio);
 		goto retry;
 	}
-	WRITE_ONCE(huge_zero_pfn, page_to_pfn(zero_page));
+	WRITE_ONCE(huge_zero_pfn, folio_pfn(zero_folio));
 
 	/* We take additional reference here. It will be put back by shrinker */
 	atomic_set(&huge_zero_refcount, 2);
@@ -227,10 +227,10 @@ static void put_huge_zero_page(void)
 	BUG_ON(atomic_dec_and_test(&huge_zero_refcount));
 }
 
-struct page *mm_get_huge_zero_page(struct mm_struct *mm)
+struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
 {
 	if (test_bit(MMF_HUGE_ZERO_PAGE, &mm->flags))
-		return READ_ONCE(huge_zero_page);
+		return READ_ONCE(huge_zero_folio);
 
 	if (!get_huge_zero_page())
 		return NULL;
@@ -238,7 +238,7 @@ struct page *mm_get_huge_zero_page(struc
 	if (test_and_set_bit(MMF_HUGE_ZERO_PAGE, &mm->flags))
 		put_huge_zero_page();
 
-	return READ_ONCE(huge_zero_page);
+	return READ_ONCE(huge_zero_folio);
 }
 
 void mm_put_huge_zero_page(struct mm_struct *mm)
@@ -258,10 +258,10 @@ static unsigned long shrink_huge_zero_pa
 				       struct shrink_control *sc)
 {
 	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
-		struct page *zero_page = xchg(&huge_zero_page, NULL);
-		BUG_ON(zero_page == NULL);
+		struct folio *zero_folio = xchg(&huge_zero_folio, NULL);
+		BUG_ON(zero_folio == NULL);
 		WRITE_ONCE(huge_zero_pfn, ~0UL);
-		__free_pages(zero_page, compound_order(zero_page));
+		folio_put(zero_folio);
 		return HPAGE_PMD_NR;
 	}
 
@@ -1340,7 +1340,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 		 * since we already have a zero page to copy. It just takes a
 		 * reference.
 		 */
-		mm_get_huge_zero_page(dst_mm);
+		mm_get_huge_zero_folio(dst_mm);
 		goto out_zero_page;
 	}
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-free-up-pg_slab-fix.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch
sh-remove-use-of-pg_arch_1-on-individual-pages.patch
xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch
mm-make-page_ext_get-take-a-const-argument.patch
mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch
mm-make-is_free_buddy_page-take-a-const-argument.patch
mm-make-page_mapped-take-a-const-argument.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch
slub-remove-use-of-page-flags.patch
remove-references-to-page-flags-in-documentation.patch
proc-rewrite-stable_page_flags.patch
sparc-use-is_huge_zero_pmd.patch
mm-add-is_huge_zero_folio.patch
mm-add-pmd_folio.patch
mm-convert-migrate_vma_collect_pmd-to-use-a-folio.patch
mm-convert-huge_zero_page-to-huge_zero_folio.patch
mm-convert-do_huge_pmd_anonymous_page-to-huge_zero_folio.patch
dax-use-huge_zero_folio.patch
mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio.patch

