Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBAD1D54B
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 19:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712171142; cv=none; b=HHBJ44DlwgCIp9BdB8Q5CMG0Qx7rzO12ZmFQ0zr9S/dlLcyNge/Kvq1RzEYk8XXLaB8PxNIqXsofHmbZEmTKJ4mzEnowbLptkDxB9PvWOYBJZOeSF/Ye/QwORHMiYziJ0Qd5kAnkokKRTsCVID4YVouiXsXmfzv6c3ASz/HeOAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712171142; c=relaxed/simple;
	bh=9DI+4vvu0XaiD8H+O7KPXwEOWLO8E81YwoX3513wHxw=;
	h=Date:To:From:Subject:Message-Id; b=dWRPAjalydri63dQlc6XMtOlI4wBLmFik9SlZeJUgolJF8uxfJKJ0FUuBFPlzb/TQG2gkVJcnwX0fkXYFBYzbpwPvf7AXYRytoRPpG7JKDsi6gHY7LO9jbc0Nwzy1AKjQZqi161TaC1+25tX8gZt7jhmUHf6xIcNiyeSKC3WvyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QgaaAxj6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QgaaAxj6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2925C433C7;
	Wed,  3 Apr 2024 19:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712171141;
	bh=9DI+4vvu0XaiD8H+O7KPXwEOWLO8E81YwoX3513wHxw=;
	h=Date:To:From:Subject:From;
	b=QgaaAxj6v6wmVDd9hKyy08jO+DYhksRg+o36OGbMc4vN7mNxja/AleyU8Ve6ccviv
	 sUNYaWfZPb/BCxEvznxiYFmXztLjEXcehrMSqVEeKmxg40TT6rjlY7mmPGuVU18NNk
	 1ysW93vik6ZyGyVWSpF8Wf9RDF//shTKb0+HIvc4=
Date: Wed, 03 Apr 2024 12:05:40 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepaged-use-a-folio-throughout-collapse_file.patch added to mm-unstable branch
Message-Id: <20240403190541.D2925C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: khugepaged: use a folio throughout collapse_file()
has been added to the -mm mm-unstable branch.  Its filename is
     khugepaged-use-a-folio-throughout-collapse_file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepaged-use-a-folio-throughout-collapse_file.patch

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
Subject: khugepaged: use a folio throughout collapse_file()
Date: Wed, 3 Apr 2024 18:18:35 +0100

Pull folios from the page cache instead of pages.  Half of this work had
been done already, but we were still operating on pages for a large chunk
of this function.  There is no attempt in this patch to handle large
folios that are smaller than a THP; that will have to wait for a future
patch.

Link: https://lkml.kernel.org/r/20240403171838.1445826-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |  113 +++++++++++++++++++++-------------------------
 1 file changed, 54 insertions(+), 59 deletions(-)

--- a/mm/khugepaged.c~khugepaged-use-a-folio-throughout-collapse_file
+++ a/mm/khugepaged.c
@@ -1780,9 +1780,8 @@ static int collapse_file(struct mm_struc
 			 struct collapse_control *cc)
 {
 	struct address_space *mapping = file->f_mapping;
-	struct page *page;
-	struct page *tmp, *dst;
-	struct folio *folio, *new_folio;
+	struct page *dst;
+	struct folio *folio, *tmp, *new_folio;
 	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
@@ -1820,11 +1819,11 @@ static int collapse_file(struct mm_struc
 
 	for (index = start; index < end; index++) {
 		xas_set(&xas, index);
-		page = xas_load(&xas);
+		folio = xas_load(&xas);
 
 		VM_BUG_ON(index != xas.xa_index);
 		if (is_shmem) {
-			if (!page) {
+			if (!folio) {
 				/*
 				 * Stop if extent has been truncated or
 				 * hole-punched, and is now completely
@@ -1840,7 +1839,7 @@ static int collapse_file(struct mm_struc
 				continue;
 			}
 
-			if (xa_is_value(page) || !PageUptodate(page)) {
+			if (xa_is_value(folio) || !folio_test_uptodate(folio)) {
 				xas_unlock_irq(&xas);
 				/* swap in or instantiate fallocated page */
 				if (shmem_get_folio(mapping->host, index,
@@ -1850,28 +1849,27 @@ static int collapse_file(struct mm_struc
 				}
 				/* drain lru cache to help isolate_lru_page() */
 				lru_add_drain();
-				page = folio_file_page(folio, index);
-			} else if (trylock_page(page)) {
-				get_page(page);
+			} else if (folio_trylock(folio)) {
+				folio_get(folio);
 				xas_unlock_irq(&xas);
 			} else {
 				result = SCAN_PAGE_LOCK;
 				goto xa_locked;
 			}
 		} else {	/* !is_shmem */
-			if (!page || xa_is_value(page)) {
+			if (!folio || xa_is_value(folio)) {
 				xas_unlock_irq(&xas);
 				page_cache_sync_readahead(mapping, &file->f_ra,
 							  file, index,
 							  end - index);
 				/* drain lru cache to help isolate_lru_page() */
 				lru_add_drain();
-				page = find_lock_page(mapping, index);
-				if (unlikely(page == NULL)) {
+				folio = filemap_lock_folio(mapping, index);
+				if (unlikely(folio == NULL)) {
 					result = SCAN_FAIL;
 					goto xa_unlocked;
 				}
-			} else if (PageDirty(page)) {
+			} else if (folio_test_dirty(folio)) {
 				/*
 				 * khugepaged only works on read-only fd,
 				 * so this page is dirty because it hasn't
@@ -1889,12 +1887,12 @@ static int collapse_file(struct mm_struc
 				filemap_flush(mapping);
 				result = SCAN_FAIL;
 				goto xa_unlocked;
-			} else if (PageWriteback(page)) {
+			} else if (folio_test_writeback(folio)) {
 				xas_unlock_irq(&xas);
 				result = SCAN_FAIL;
 				goto xa_unlocked;
-			} else if (trylock_page(page)) {
-				get_page(page);
+			} else if (folio_trylock(folio)) {
+				folio_get(folio);
 				xas_unlock_irq(&xas);
 			} else {
 				result = SCAN_PAGE_LOCK;
@@ -1903,35 +1901,31 @@ static int collapse_file(struct mm_struc
 		}
 
 		/*
-		 * The page must be locked, so we can drop the i_pages lock
+		 * The folio must be locked, so we can drop the i_pages lock
 		 * without racing with truncate.
 		 */
-		VM_BUG_ON_PAGE(!PageLocked(page), page);
+		VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
-		/* make sure the page is up to date */
-		if (unlikely(!PageUptodate(page))) {
+		/* make sure the folio is up to date */
+		if (unlikely(!folio_test_uptodate(folio))) {
 			result = SCAN_FAIL;
 			goto out_unlock;
 		}
 
 		/*
 		 * If file was truncated then extended, or hole-punched, before
-		 * we locked the first page, then a THP might be there already.
+		 * we locked the first folio, then a THP might be there already.
 		 * This will be discovered on the first iteration.
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
 			goto out_unlock;
 		}
 
-		folio = page_folio(page);
-
 		if (folio_mapping(folio) != mapping) {
 			result = SCAN_TRUNCATED;
 			goto out_unlock;
@@ -1941,7 +1935,7 @@ static int collapse_file(struct mm_struc
 				  folio_test_writeback(folio))) {
 			/*
 			 * khugepaged only works on read-only fd, so this
-			 * page is dirty because it hasn't been flushed
+			 * folio is dirty because it hasn't been flushed
 			 * since first write.
 			 */
 			result = SCAN_FAIL;
@@ -1965,33 +1959,34 @@ static int collapse_file(struct mm_struc
 
 		xas_lock_irq(&xas);
 
-		VM_BUG_ON_PAGE(page != xa_load(xas.xa, index), page);
+		VM_BUG_ON_FOLIO(folio != xa_load(xas.xa, index), folio);
 
 		/*
-		 * We control three references to the page:
+		 * We control three references to the folio:
 		 *  - we hold a pin on it;
 		 *  - one reference from page cache;
-		 *  - one from isolate_lru_page;
-		 * If those are the only references, then any new usage of the
-		 * page will have to fetch it from the page cache. That requires
-		 * locking the page to handle truncate, so any new usage will be
-		 * blocked until we unlock page after collapse/during rollback.
+		 *  - one from lru_isolate_folio;
+		 * If those are the only references, then any new usage
+		 * of the folio will have to fetch it from the page
+		 * cache. That requires locking the folio to handle
+		 * truncate, so any new usage will be blocked until we
+		 * unlock folio after collapse/during rollback.
 		 */
-		if (page_count(page) != 3) {
+		if (folio_ref_count(folio) != 3) {
 			result = SCAN_PAGE_COUNT;
 			xas_unlock_irq(&xas);
-			putback_lru_page(page);
+			folio_putback_lru(folio);
 			goto out_unlock;
 		}
 
 		/*
-		 * Accumulate the pages that are being collapsed.
+		 * Accumulate the folios that are being collapsed.
 		 */
-		list_add_tail(&page->lru, &pagelist);
+		list_add_tail(&folio->lru, &pagelist);
 		continue;
 out_unlock:
-		unlock_page(page);
-		put_page(page);
+		folio_unlock(folio);
+		folio_put(folio);
 		goto xa_unlocked;
 	}
 
@@ -2030,17 +2025,17 @@ xa_unlocked:
 	}
 
 	/*
-	 * The old pages are locked, so they won't change anymore.
+	 * The old folios are locked, so they won't change anymore.
 	 */
 	index = start;
 	dst = folio_page(new_folio, 0);
-	list_for_each_entry(page, &pagelist, lru) {
-		while (index < page->index) {
+	list_for_each_entry(folio, &pagelist, lru) {
+		while (index < folio->index) {
 			clear_highpage(dst);
 			index++;
 			dst++;
 		}
-		if (copy_mc_highpage(dst, page) > 0) {
+		if (copy_mc_highpage(dst, folio_page(folio, 0)) > 0) {
 			result = SCAN_COPY_MC;
 			goto rollback;
 		}
@@ -2152,15 +2147,15 @@ immap_locked:
 	folio_unlock(new_folio);
 
 	/*
-	 * The collapse has succeeded, so free the old pages.
+	 * The collapse has succeeded, so free the old folios.
 	 */
-	list_for_each_entry_safe(page, tmp, &pagelist, lru) {
-		list_del(&page->lru);
-		page->mapping = NULL;
-		ClearPageActive(page);
-		ClearPageUnevictable(page);
-		unlock_page(page);
-		folio_put_refs(page_folio(page), 3);
+	list_for_each_entry_safe(folio, tmp, &pagelist, lru) {
+		list_del(&folio->lru);
+		folio->mapping = NULL;
+		folio_clear_active(folio);
+		folio_clear_unevictable(folio);
+		folio_unlock(folio);
+		folio_put_refs(folio, 3);
 	}
 
 	goto out;
@@ -2174,11 +2169,11 @@ rollback:
 		shmem_uncharge(mapping->host, nr_none);
 	}
 
-	list_for_each_entry_safe(page, tmp, &pagelist, lru) {
-		list_del(&page->lru);
-		unlock_page(page);
-		putback_lru_page(page);
-		put_page(page);
+	list_for_each_entry_safe(folio, tmp, &pagelist, lru) {
+		list_del(&folio->lru);
+		folio_unlock(folio);
+		folio_putback_lru(folio);
+		folio_put(folio);
 	}
 	/*
 	 * Undo the updates of filemap_nr_thps_inc for non-SHMEM
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

