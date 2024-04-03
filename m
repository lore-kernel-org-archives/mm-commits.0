Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E9B1D54B
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 19:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712171143; cv=none; b=Y81fimYKDQ9Rk5+OVgcHEthIrytMrH97JVa7GhfWzYNOhK/FoO9tRfbAnqoBWRL976ha0aqO4xgmznxIGgbPxLyNXrcDFib6cQJtx24ZbYqTgt9LILJ3oPmOxTndc9WhPu0BS+3a8ys3NELDRBujGFtx72vT6SxO8k1a8HU/d38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712171143; c=relaxed/simple;
	bh=Ddn4pWd6RzRJE/mfGydhPVP3gQYXZtOUh+AQ3+B3J9k=;
	h=Date:To:From:Subject:Message-Id; b=N8TDdhUrgvCw3oCpPwKMmqCL13Z9i/Ob4BH0zsFGS//hc4g8YYhmdE1dnfnGCNHNRbdUaY+HuUeE0XmuABhlZPM8VXMUxFBXZdYKjyF3zx4PvpYnBrVso3pGVtRmeghFXSImBJGQvjGuUU5IEWaiMAdBjQJqRXCKrB2xZOcOUKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sk6gKDmM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sk6gKDmM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB2DC433C7;
	Wed,  3 Apr 2024 19:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712171143;
	bh=Ddn4pWd6RzRJE/mfGydhPVP3gQYXZtOUh+AQ3+B3J9k=;
	h=Date:To:From:Subject:From;
	b=sk6gKDmMc6o3hZuCRnT6+b6oHhCu4eaxSXYO66lZv2MCPolOhZZ5Yxoufo/1ZwCpU
	 XjFkJ+B5fWbJb/ndt1+NyiCR7/MOi0C7jkoCDIDdNFSSv7KuWYkG9E3ImpXuEe8ji4
	 NdpEd/jhnYg2a6RyR5h2J0ecpF71+pG3en7SBF2A=
Date: Wed, 03 Apr 2024 12:05:42 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepaged-use-a-folio-throughout-hpage_collapse_scan_file.patch added to mm-unstable branch
Message-Id: <20240403190543.4FB2DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: khugepaged: use a folio throughout hpage_collapse_scan_file()
has been added to the -mm mm-unstable branch.  Its filename is
     khugepaged-use-a-folio-throughout-hpage_collapse_scan_file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepaged-use-a-folio-throughout-hpage_collapse_scan_file.patch

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
Subject: khugepaged: use a folio throughout hpage_collapse_scan_file()
Date: Wed, 3 Apr 2024 18:18:36 +0100

Replace the use of pages with folios.  Saves a few calls to
compound_head() and removes some uses of obsolete functions.

Link: https://lkml.kernel.org/r/20240403171838.1445826-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |    6 ++--
 mm/khugepaged.c                    |   33 +++++++++++++--------------
 2 files changed, 19 insertions(+), 20 deletions(-)

--- a/include/trace/events/huge_memory.h~khugepaged-use-a-folio-throughout-hpage_collapse_scan_file
+++ a/include/trace/events/huge_memory.h
@@ -174,10 +174,10 @@ TRACE_EVENT(mm_collapse_huge_page_swapin
 
 TRACE_EVENT(mm_khugepaged_scan_file,
 
-	TP_PROTO(struct mm_struct *mm, struct page *page, struct file *file,
+	TP_PROTO(struct mm_struct *mm, struct folio *folio, struct file *file,
 		 int present, int swap, int result),
 
-	TP_ARGS(mm, page, file, present, swap, result),
+	TP_ARGS(mm, folio, file, present, swap, result),
 
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
@@ -190,7 +190,7 @@ TRACE_EVENT(mm_khugepaged_scan_file,
 
 	TP_fast_assign(
 		__entry->mm = mm;
-		__entry->pfn = page ? page_to_pfn(page) : -1;
+		__entry->pfn = folio ? folio_pfn(folio) : -1;
 		__assign_str(filename, file->f_path.dentry->d_iname);
 		__entry->present = present;
 		__entry->swap = swap;
--- a/mm/khugepaged.c~khugepaged-use-a-folio-throughout-hpage_collapse_scan_file
+++ a/mm/khugepaged.c
@@ -2203,7 +2203,7 @@ static int hpage_collapse_scan_file(stru
 				    struct file *file, pgoff_t start,
 				    struct collapse_control *cc)
 {
-	struct page *page = NULL;
+	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;
 	XA_STATE(xas, &mapping->i_pages, start);
 	int present, swap;
@@ -2215,11 +2215,11 @@ static int hpage_collapse_scan_file(stru
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
 	rcu_read_lock();
-	xas_for_each(&xas, page, start + HPAGE_PMD_NR - 1) {
-		if (xas_retry(&xas, page))
+	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
+		if (xas_retry(&xas, folio))
 			continue;
 
-		if (xa_is_value(page)) {
+		if (xa_is_value(folio)) {
 			++swap;
 			if (cc->is_khugepaged &&
 			    swap > khugepaged_max_ptes_swap) {
@@ -2234,11 +2234,9 @@ static int hpage_collapse_scan_file(stru
 		 * TODO: khugepaged should compact smaller compound pages
 		 * into a PMD sized page
 		 */
-		if (PageTransCompound(page)) {
-			struct page *head = compound_head(page);
-
-			result = compound_order(head) == HPAGE_PMD_ORDER &&
-					head->index == start
+		if (folio_test_large(folio)) {
+			result = folio_order(folio) == HPAGE_PMD_ORDER &&
+					folio->index == start
 					/* Maybe PMD-mapped */
 					? SCAN_PTE_MAPPED_HUGEPAGE
 					: SCAN_PAGE_COMPOUND;
@@ -2251,28 +2249,29 @@ static int hpage_collapse_scan_file(stru
 			break;
 		}
 
-		node = page_to_nid(page);
+		node = folio_nid(folio);
 		if (hpage_collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
 			break;
 		}
 		cc->node_load[node]++;
 
-		if (!PageLRU(page)) {
+		if (!folio_test_lru(folio)) {
 			result = SCAN_PAGE_LRU;
 			break;
 		}
 
-		if (page_count(page) !=
-		    1 + page_mapcount(page) + page_has_private(page)) {
+		if (folio_ref_count(folio) !=
+		    1 + folio_mapcount(folio) + folio_test_private(folio)) {
 			result = SCAN_PAGE_COUNT;
 			break;
 		}
 
 		/*
-		 * We probably should check if the page is referenced here, but
-		 * nobody would transfer pte_young() to PageReferenced() for us.
-		 * And rmap walk here is just too costly...
+		 * We probably should check if the folio is referenced
+		 * here, but nobody would transfer pte_young() to
+		 * folio_test_referenced() for us.  And rmap walk here
+		 * is just too costly...
 		 */
 
 		present++;
@@ -2294,7 +2293,7 @@ static int hpage_collapse_scan_file(stru
 		}
 	}
 
-	trace_mm_khugepaged_scan_file(mm, page, file, present, swap, result);
+	trace_mm_khugepaged_scan_file(mm, folio, file, present, swap, result);
 	return result;
 }
 #else
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
mm-convert-arch_clear_hugepage_flags-to-take-a-folio-fix.patch
slub-remove-use-of-page-flags.patch
remove-references-to-page-flags-in-documentation.patch
proc-rewrite-stable_page_flags.patch
proc-rewrite-stable_page_flags-fix.patch
sparc-use-is_huge_zero_pmd.patch
mm-add-is_huge_zero_folio.patch
mm-add-pmd_folio.patch
mm-convert-migrate_vma_collect_pmd-to-use-a-folio.patch
mm-convert-huge_zero_page-to-huge_zero_folio.patch
mm-convert-do_huge_pmd_anonymous_page-to-huge_zero_folio.patch
dax-use-huge_zero_folio.patch
mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio.patch
mm-use-rwsem-assertion-macros-for-mmap_lock.patch
filemap-remove-__set_page_dirty.patch
mm-correct-page_mapped_in_vma-for-large-folios.patch
mm-remove-vma_address.patch
mm-rename-vma_pgoff_address-back-to-vma_address.patch
khugepaged-inline-hpage_collapse_alloc_folio.patch
khugepaged-convert-alloc_charge_hpage-to-alloc_charge_folio.patch
khugepaged-remove-hpage-from-collapse_huge_page.patch
khugepaged-pass-a-folio-to-__collapse_huge_page_copy.patch
khugepaged-remove-hpage-from-collapse_file.patch
khugepaged-use-a-folio-throughout-collapse_file.patch
khugepaged-use-a-folio-throughout-hpage_collapse_scan_file.patch

