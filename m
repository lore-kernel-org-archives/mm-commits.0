Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7D78061B
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104121; cv=none; b=AIDbGlyhlij0OWz8E8aHK3VublrxCn+PVOeO2JMU5OccUAvHUPbaku7eABR6yXSU2SUm8c8zHeC4qgi0yJ75cRrW3P2XQ6uin603xw1BDUnaJj0wqu9ZC2Ba8LWscHE97W3H02A1AzKyRK9b8FJ2Earku5ZoL6ctabD5WyS2BNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104121; c=relaxed/simple;
	bh=9OsxaUyZvyqRSvMg36Afppsthv207ZGnn4ngu02WvbU=;
	h=Date:To:From:Subject:Message-Id; b=piABKttQjHwISektG5nWyQxMT4gQ7V7mmOe7DLUBzmlNr3dpntbXMyW+17qOx09zmkrt7sw9Uy3JOhiFJW1RmywLJPd5Wa/ofpErOTVCQrduAjscu3kzfokDdAOJGqaACkuiLCQg/ogY3XZf3gWZc/yXhN89AjshBOhU/r+Jyhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aLNxwJLu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aLNxwJLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F33EC113CD;
	Fri, 26 Apr 2024 04:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104120;
	bh=9OsxaUyZvyqRSvMg36Afppsthv207ZGnn4ngu02WvbU=;
	h=Date:To:From:Subject:From;
	b=aLNxwJLuQqkxWOuIVrQlPtKqXdXmnB515Og90o0Sn/zpRqHA/p9tWrUz8nl8auZhg
	 1iUqfNaxkkTxQxc/QA8j/wfJWEgunO/MnZz2S/YKnA3XbVjOcLAK51cQHfpPZxwVfb
	 IV0Zjzny6FT68MzEyMqUTcO1GfaDgdzU9APScB6g=
Date: Thu, 25 Apr 2024 21:02:00 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] khugepaged-remove-hpage-from-collapse_huge_page.patch removed from -mm tree
Message-Id: <20240426040200.9F33EC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: khugepaged: remove hpage from collapse_huge_page()
has been removed from the -mm tree.  Its filename was
     khugepaged-remove-hpage-from-collapse_huge_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: khugepaged: remove hpage from collapse_huge_page()
Date: Wed, 3 Apr 2024 18:18:32 +0100

Work purely in terms of the folio.  Removes a call to compound_head()
in put_page().

Link: https://lkml.kernel.org/r/20240403171838.1445826-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/mm/khugepaged.c~khugepaged-remove-hpage-from-collapse_huge_page
+++ a/mm/khugepaged.c
@@ -1082,7 +1082,6 @@ static int collapse_huge_page(struct mm_
 	pte_t *pte;
 	pgtable_t pgtable;
 	struct folio *folio;
-	struct page *hpage;
 	spinlock_t *pmd_ptl, *pte_ptl;
 	int result = SCAN_FAIL;
 	struct vm_area_struct *vma;
@@ -1099,7 +1098,6 @@ static int collapse_huge_page(struct mm_
 	mmap_read_unlock(mm);
 
 	result = alloc_charge_folio(&folio, mm, cc);
-	hpage = &folio->page;
 	if (result != SCAN_SUCCEED)
 		goto out_nolock;
 
@@ -1198,7 +1196,7 @@ static int collapse_huge_page(struct mm_
 	 */
 	anon_vma_unlock_write(vma->anon_vma);
 
-	result = __collapse_huge_page_copy(pte, hpage, pmd, _pmd,
+	result = __collapse_huge_page_copy(pte, &folio->page, pmd, _pmd,
 					   vma, address, pte_ptl,
 					   &compound_pagelist);
 	pte_unmap(pte);
@@ -1213,7 +1211,7 @@ static int collapse_huge_page(struct mm_
 	__folio_mark_uptodate(folio);
 	pgtable = pmd_pgtable(_pmd);
 
-	_pmd = mk_huge_pmd(hpage, vma->vm_page_prot);
+	_pmd = mk_huge_pmd(&folio->page, vma->vm_page_prot);
 	_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
 
 	spin_lock(pmd_ptl);
@@ -1225,14 +1223,14 @@ static int collapse_huge_page(struct mm_
 	update_mmu_cache_pmd(vma, address, pmd);
 	spin_unlock(pmd_ptl);
 
-	hpage = NULL;
+	folio = NULL;
 
 	result = SCAN_SUCCEED;
 out_up_write:
 	mmap_write_unlock(mm);
 out_nolock:
-	if (hpage)
-		put_page(hpage);
+	if (folio)
+		folio_put(folio);
 	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
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

