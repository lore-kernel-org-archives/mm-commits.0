Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66137FBAC
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104123; cv=none; b=gyjnTpOo9Vmz5z2bAPKkpwrJv1omaozcEAru9E3FE5aRbGR4e7rqBg29qbYqKQSzFUzSku8D4avBv0pT2j2S7uLQVdRPx/sqcnbmPgt6Twh0iiqLE+inaLlIGWrOREa7Uih+9NnELXThN95uTASe1vjGII/tGD3/FN35ZMCDFYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104123; c=relaxed/simple;
	bh=+gHKmMjlNx5+GS2cVrOpN/X0DOoA6TrSuA03CQHVIoE=;
	h=Date:To:From:Subject:Message-Id; b=gkSJqYxcKHAU5Wc7G3tq753v4k7R0fmrbUYmxd83fEgOcPUtjolJshrvJrfXxf53JnmR20RCO4SKQG+zI6bWyH2RfTjKZTXzQKZ4oztkCfOKnSa4ZHETSwgyeOTnsrwGBK1O9ZNQDJBO0z0544+AleAlS2ev1ThbYDK3HopVhKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a3DzAMot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a3DzAMot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C02EC113CD;
	Fri, 26 Apr 2024 04:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104123;
	bh=+gHKmMjlNx5+GS2cVrOpN/X0DOoA6TrSuA03CQHVIoE=;
	h=Date:To:From:Subject:From;
	b=a3DzAMotIBBP1qQESTHqQNKgxXbUjj/Dx5Ex0Svp0jaiMj8AH05f4AUX1fM1O2xAd
	 u1aHEhP6s6dCrbq5lx7oMRktfpgH2Xp8ekRXzFIT7KQ54kz2eki4yx+0t6+lW70XhF
	 2Ggf2qSYwhxv1VdNLwapruRqUawKopApTmg98bLM=
Date: Thu, 25 Apr 2024 21:02:03 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] khugepaged-use-a-folio-throughout-collapse_file.patch removed from -mm tree
Message-Id: <20240426040203.9C02EC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: khugepaged: use a folio throughout collapse_file()
has been removed from the -mm tree.  Its filename was
     khugepaged-use-a-folio-throughout-collapse_file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: khugepaged: use a folio throughout collapse_file()
Date: Wed, 3 Apr 2024 18:18:35 +0100

Pull folios from the page cache instead of pages.  Half of this work had
been done already, but we were still operating on pages for a large chunk
of this function.  There is no attempt in this patch to handle large
folios that are smaller than a THP; that will have to wait for a future
patch.

[willy@infradead.org: the unlikely() is embedded in IS_ERR()]
  Link: https://lkml.kernel.org/r/ZhIWX8K0E2tSyMSr@casper.infradead.org
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
+				if (IS_ERR(folio)) {
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

doc-improve-the-description-of-__folio_mark_dirty.patch
buffer-add-kernel-doc-for-block_dirty_folio.patch
buffer-add-kernel-doc-for-try_to_free_buffers.patch
buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch
buffer-add-kernel-doc-for-brelse-and-__brelse.patch
buffer-add-kernel-doc-for-bforget-and-__bforget.patch
buffer-improve-bdev_getblk-documentation.patch
doc-split-bufferrst-out-of-api-summaryrst.patch
doc-split-bufferrst-out-of-api-summaryrst-fix.patch
mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill.patch
mm-memory-failure-pass-addr-to-__add_to_kill.patch
mm-return-the-address-from-page_mapped_in_vma.patch
mm-make-page_mapped_in_vma-conditional-on-config_memory_failure.patch
mm-memory-failure-convert-shake_page-to-shake_folio.patch
mm-convert-hugetlb_page_mapping_lock_write-to-folio.patch
mm-memory-failure-convert-memory_failure-to-use-a-folio.patch
mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio.patch
mm-memory-failure-add-some-folio-conversions-to-unpoison_memory.patch
mm-memory-failure-use-folio-functions-throughout-collect_procs.patch
mm-memory-failure-pass-the-folio-to-collect_procs_ksm.patch
fscrypt-convert-bh_get_inode_and_lblk_num-to-use-a-folio.patch
f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio.patch
memory-failure-remove-calls-to-page_mapping.patch
migrate-expand-the-use-of-folio-in-__migrate_device_pages.patch
userfault-expand-folio-use-in-mfill_atomic_install_pte.patch
mm-remove-page_mapping.patch
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch
mm-simplify-thp_vma_allowable_order.patch

