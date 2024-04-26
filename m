Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4BB8061B
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104122; cv=none; b=Jacu3rOjkNFA/pbYPFcswUBmOps7DXqLrLp8RY6MKC9SDEowOqaN/pL5WKf/8393XllVNktSyBf1jYlGqBeCzbcVMWZ75Yxwrtz29hdY7eh6kX6mQ7KiOtOrISRRycVj2IZFmg1EgcwM0VNdMP/HHZ1ksoEAXjNs/MlGAYdDK2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104122; c=relaxed/simple;
	bh=rIDkwadC5XhjWntJqid90FpXvz8ctKAuN27oH5nzOKc=;
	h=Date:To:From:Subject:Message-Id; b=geTKJyWPOV5TixxmbZjknkeO9y4+sSkKVLIqMhcsdTU96ToA9edCjfc7gg9QDkIB0eCL+v2FoBwTwaxCbwePUIvo5SFUAc36l17tTs3PZCTBO33ZdQhQd6IkFptdHakTXM/Ykgy633F+FrCujk1bSFzFSsTjdIMmi19RqYHibug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IJcUgbXo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IJcUgbXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E95C116B1;
	Fri, 26 Apr 2024 04:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104122;
	bh=rIDkwadC5XhjWntJqid90FpXvz8ctKAuN27oH5nzOKc=;
	h=Date:To:From:Subject:From;
	b=IJcUgbXoEf+gpydQj3SjjjYbVHmrS6coD+ruPsqK1V7cN4yz2FJhGoCtLHwtYHWA3
	 V71iXPcMQhKrNaPpPLDcbDXAN8Wb7ahnU1MIQI1nX63r0QmQcQlSOAWPczbiLtgzdT
	 8o/HvDOHjgpFq43t6z79Y+fjsjd02Tkcnlrvsf6A=
Date: Thu, 25 Apr 2024 21:02:02 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] khugepaged-remove-hpage-from-collapse_file.patch removed from -mm tree
Message-Id: <20240426040202.A1E95C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: khugepaged: remove hpage from collapse_file()
has been removed from the -mm tree.  Its filename was
     khugepaged-remove-hpage-from-collapse_file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: khugepaged: remove hpage from collapse_file()
Date: Wed, 3 Apr 2024 18:18:34 +0100

Use new_folio throughout where we had been using hpage.

Link: https://lkml.kernel.org/r/20240403171838.1445826-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
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

