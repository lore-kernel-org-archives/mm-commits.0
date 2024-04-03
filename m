Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB4B1D54B
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 19:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712171140; cv=none; b=O4HjZs1ylKWuCi7hsN08eV4FSRAEfBBD3AI563bRxD/zWKRV982OsNMFrcOIPUcEBakO4Zw8s1KBYSaG++3vofqpoKdElek1vWonmOcm20ffKZ7lU09gYSRO1guwWKqfXOzAgkz6BsBEtPDHWowPz35/O+6+2Pwd7eN8HZnvvPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712171140; c=relaxed/simple;
	bh=vmFpJm45fH7TIwtQcEiyrfhSUD7s/sw0dJPuHVDcJT4=;
	h=Date:To:From:Subject:Message-Id; b=PgPwSk8/M5zBivT5Kn6oSsSfdcsnt0QGyh5x39ErYFnU6/JzsMR+rgj0TmtWpP2ln27kyM56ZGi8AQa6TW5IULopSQiEktD5TAPzz0yWmPiB8X/uUUJZCmHvyNu4cvaFCkCuTDU+oz5dAAluIg56FNOe7Nx+WzAf+vA01N5xTs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qoFCpCfO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qoFCpCfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D424C433C7;
	Wed,  3 Apr 2024 19:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712171140;
	bh=vmFpJm45fH7TIwtQcEiyrfhSUD7s/sw0dJPuHVDcJT4=;
	h=Date:To:From:Subject:From;
	b=qoFCpCfOdQN6/qwXii+wAlGVxgazj6o9ask9ZBju7VhYYkozjkfKKGSGxAVLpqU3+
	 uC/gEmQGlWHgJIZlfbUeCtLPO9Sro+zRCYGSgX9QpeVdpPpM2w54O+nibhJTwbeMj0
	 joU5Q7hvudd7VWFlMGnEAqpPHArghCfJGjRq5bI4=
Date: Wed, 03 Apr 2024 12:05:39 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepaged-remove-hpage-from-collapse_file.patch added to mm-unstable branch
Message-Id: <20240403190540.2D424C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: khugepaged: remove hpage from collapse_file()
has been added to the -mm mm-unstable branch.  Its filename is
     khugepaged-remove-hpage-from-collapse_file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepaged-remove-hpage-from-collapse_file.patch

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
Subject: khugepaged: remove hpage from collapse_file()
Date: Wed, 3 Apr 2024 18:18:34 +0100

Use new_folio throughout where we had been using hpage.

Link: https://lkml.kernel.org/r/20240403171838.1445826-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/huge_memory.h |    6 +-
 mm/khugepaged.c                    |   77 +++++++++++++--------------
 2 files changed, 42 insertions(+), 41 deletions(-)

--- a/include/trace/events/huge_memory.h~khugepaged-remove-hpage-from-collapse_file
+++ a/include/trace/events/huge_memory.h
@@ -207,10 +207,10 @@ TRACE_EVENT(mm_khugepaged_scan_file,
 );
 
 TRACE_EVENT(mm_khugepaged_collapse_file,
-	TP_PROTO(struct mm_struct *mm, struct page *hpage, pgoff_t index,
+	TP_PROTO(struct mm_struct *mm, struct folio *new_folio, pgoff_t index,
 			bool is_shmem, unsigned long addr, struct file *file,
 			int nr, int result),
-	TP_ARGS(mm, hpage, index, addr, is_shmem, file, nr, result),
+	TP_ARGS(mm, new_folio, index, addr, is_shmem, file, nr, result),
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
 		__field(unsigned long, hpfn)
@@ -224,7 +224,7 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
 
 	TP_fast_assign(
 		__entry->mm = mm;
-		__entry->hpfn = hpage ? page_to_pfn(hpage) : -1;
+		__entry->hpfn = new_folio ? folio_pfn(new_folio) : -1;
 		__entry->index = index;
 		__entry->addr = addr;
 		__entry->is_shmem = is_shmem;
--- a/mm/khugepaged.c~khugepaged-remove-hpage-from-collapse_file
+++ a/mm/khugepaged.c
@@ -1780,30 +1780,27 @@ static int collapse_file(struct mm_struc
 			 struct collapse_control *cc)
 {
 	struct address_space *mapping = file->f_mapping;
-	struct page *hpage;
 	struct page *page;
-	struct page *tmp;
+	struct page *tmp, *dst;
 	struct folio *folio, *new_folio;
 	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
 	int nr_none = 0, result = SCAN_SUCCEED;
 	bool is_shmem = shmem_file(file);
-	int nr = 0;
 
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
 	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
 
 	result = alloc_charge_folio(&new_folio, mm, cc);
-	hpage = &new_folio->page;
 	if (result != SCAN_SUCCEED)
 		goto out;
 
-	__SetPageLocked(hpage);
+	__folio_set_locked(new_folio);
 	if (is_shmem)
-		__SetPageSwapBacked(hpage);
-	hpage->index = start;
-	hpage->mapping = mapping;
+		__folio_set_swapbacked(new_folio);
+	new_folio->index = start;
+	new_folio->mapping = mapping;
 
 	/*
 	 * Ensure we have slots for all the pages in the range.  This is
@@ -2036,20 +2033,24 @@ xa_unlocked:
 	 * The old pages are locked, so they won't change anymore.
 	 */
 	index = start;
+	dst = folio_page(new_folio, 0);
 	list_for_each_entry(page, &pagelist, lru) {
 		while (index < page->index) {
-			clear_highpage(hpage + (index % HPAGE_PMD_NR));
+			clear_highpage(dst);
 			index++;
+			dst++;
 		}
-		if (copy_mc_highpage(hpage + (page->index % HPAGE_PMD_NR), page) > 0) {
+		if (copy_mc_highpage(dst, page) > 0) {
 			result = SCAN_COPY_MC;
 			goto rollback;
 		}
 		index++;
+		dst++;
 	}
 	while (index < end) {
-		clear_highpage(hpage + (index % HPAGE_PMD_NR));
+		clear_highpage(dst);
 		index++;
+		dst++;
 	}
 
 	if (nr_none) {
@@ -2077,16 +2078,17 @@ xa_unlocked:
 		}
 
 		/*
-		 * If userspace observed a missing page in a VMA with a MODE_MISSING
-		 * userfaultfd, then it might expect a UFFD_EVENT_PAGEFAULT for that
-		 * page. If so, we need to roll back to avoid suppressing such an
-		 * event. Since wp/minor userfaultfds don't give userspace any
-		 * guarantees that the kernel doesn't fill a missing page with a zero
-		 * page, so they don't matter here.
+		 * If userspace observed a missing page in a VMA with
+		 * a MODE_MISSING userfaultfd, then it might expect a
+		 * UFFD_EVENT_PAGEFAULT for that page. If so, we need to
+		 * roll back to avoid suppressing such an event. Since
+		 * wp/minor userfaultfds don't give userspace any
+		 * guarantees that the kernel doesn't fill a missing
+		 * page with a zero page, so they don't matter here.
 		 *
-		 * Any userfaultfds registered after this point will not be able to
-		 * observe any missing pages due to the previously inserted retry
-		 * entries.
+		 * Any userfaultfds registered after this point will
+		 * not be able to observe any missing pages due to the
+		 * previously inserted retry entries.
 		 */
 		vma_interval_tree_foreach(vma, &mapping->i_mmap, start, end) {
 			if (userfaultfd_missing(vma)) {
@@ -2111,33 +2113,32 @@ immap_locked:
 		xas_lock_irq(&xas);
 	}
 
-	folio = page_folio(hpage);
-	nr = folio_nr_pages(folio);
 	if (is_shmem)
-		__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, nr);
+		__lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);
 	else
-		__lruvec_stat_mod_folio(folio, NR_FILE_THPS, nr);
+		__lruvec_stat_mod_folio(new_folio, NR_FILE_THPS, HPAGE_PMD_NR);
 
 	if (nr_none) {
-		__lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr_none);
+		__lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, nr_none);
 		/* nr_none is always 0 for non-shmem. */
-		__lruvec_stat_mod_folio(folio, NR_SHMEM, nr_none);
+		__lruvec_stat_mod_folio(new_folio, NR_SHMEM, nr_none);
 	}
 
 	/*
-	 * Mark hpage as uptodate before inserting it into the page cache so
-	 * that it isn't mistaken for an fallocated but unwritten page.
+	 * Mark new_folio as uptodate before inserting it into the
+	 * page cache so that it isn't mistaken for an fallocated but
+	 * unwritten page.
 	 */
-	folio_mark_uptodate(folio);
-	folio_ref_add(folio, HPAGE_PMD_NR - 1);
+	folio_mark_uptodate(new_folio);
+	folio_ref_add(new_folio, HPAGE_PMD_NR - 1);
 
 	if (is_shmem)
-		folio_mark_dirty(folio);
-	folio_add_lru(folio);
+		folio_mark_dirty(new_folio);
+	folio_add_lru(new_folio);
 
 	/* Join all the small entries into a single multi-index entry. */
 	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
-	xas_store(&xas, folio);
+	xas_store(&xas, new_folio);
 	WARN_ON_ONCE(xas_error(&xas));
 	xas_unlock_irq(&xas);
 
@@ -2148,7 +2149,7 @@ immap_locked:
 	retract_page_tables(mapping, start);
 	if (cc && !cc->is_khugepaged)
 		result = SCAN_PTE_MAPPED_HUGEPAGE;
-	folio_unlock(folio);
+	folio_unlock(new_folio);
 
 	/*
 	 * The collapse has succeeded, so free the old pages.
@@ -2193,13 +2194,13 @@ rollback:
 		smp_mb();
 	}
 
-	hpage->mapping = NULL;
+	new_folio->mapping = NULL;
 
-	unlock_page(hpage);
-	put_page(hpage);
+	folio_unlock(new_folio);
+	folio_put(new_folio);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
-	trace_mm_khugepaged_collapse_file(mm, hpage, index, is_shmem, addr, file, nr, result);
+	trace_mm_khugepaged_collapse_file(mm, new_folio, index, is_shmem, addr, file, HPAGE_PMD_NR, result);
 	return result;
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

