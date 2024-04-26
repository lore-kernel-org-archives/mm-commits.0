Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81D780C0C
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104171; cv=none; b=S9GHfU3jTX7N7rGJ2lJPhgfKo+5TlcXsCiFXnF7x32fGQvlceO6qvVVH8fYyiDlBiY80Q0h26wl+HmIn99KM3ot58GFmX0u3df2BXxGdANBpKoeD6bJdcCmIoKR2MYYyxNtJ4+ib9Fi/61f1qve1/sFQf0olgjvHniYLUfVtc/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104171; c=relaxed/simple;
	bh=vFhfz98XnSUg6U8rcMHz+n3DIZP98vvcntfcu8zOm3U=;
	h=Date:To:From:Subject:Message-Id; b=QvcSk2KqrakZiD7kwR58GRyKKfXTH7i2HFaLGRL/jwEhaur/K8vTOxePoE1LMaahvl4ItotEEM0paQXPpsuQqYHiH1me1rEMp5OkVLbUEzl10lurhL2fc6OvLmWUUCcmGQUkGXDd1OoCfLTYVNHyv1S4BBJPPUJMBNaEHKchSxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PNjuyLZC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PNjuyLZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80695C113CD;
	Fri, 26 Apr 2024 04:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104171;
	bh=vFhfz98XnSUg6U8rcMHz+n3DIZP98vvcntfcu8zOm3U=;
	h=Date:To:From:Subject:From;
	b=PNjuyLZC0pEjojud1g+Pxp6neLKoggBsR/8dB+yxHiubszjXlklrlrT1Z8V4cM09i
	 iCqhlzdK7MRUeWODpxVAgpAfzb+/4omjbN07UnOW5oztFM18EFGC9yIZrSJY97gCUW
	 RTDomm5zkFFfEllQ42Fw46q8qqVF3Zyo1cP0LUTc=
Date: Thu, 25 Apr 2024 21:02:51 -0700
To: mm-commits@vger.kernel.org,p.raghav@samsung.com,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-pagecache_isize_extended-to-use-a-folio.patch removed from -mm tree
Message-Id: <20240426040251.80695C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert pagecache_isize_extended to use a folio
has been removed from the -mm tree.  Its filename was
     mm-convert-pagecache_isize_extended-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert pagecache_isize_extended to use a folio
Date: Fri, 5 Apr 2024 19:00:36 +0100

Remove four hidden calls to compound_head().  Also exit early if the
filesystem block size is >= PAGE_SIZE instead of just equal to PAGE_SIZE.

Link: https://lkml.kernel.org/r/20240405180038.2618624-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |   36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

--- a/mm/truncate.c~mm-convert-pagecache_isize_extended-to-use-a-folio
+++ a/mm/truncate.c
@@ -764,15 +764,15 @@ EXPORT_SYMBOL(truncate_setsize);
  * @from:	original inode size
  * @to:		new inode size
  *
- * Handle extension of inode size either caused by extending truncate or by
- * write starting after current i_size. We mark the page straddling current
- * i_size RO so that page_mkwrite() is called on the nearest write access to
- * the page.  This way filesystem can be sure that page_mkwrite() is called on
- * the page before user writes to the page via mmap after the i_size has been
- * changed.
+ * Handle extension of inode size either caused by extending truncate or
+ * by write starting after current i_size.  We mark the page straddling
+ * current i_size RO so that page_mkwrite() is called on the first
+ * write access to the page.  The filesystem will update its per-block
+ * information before user writes to the page via mmap after the i_size
+ * has been changed.
  *
  * The function must be called after i_size is updated so that page fault
- * coming after we unlock the page will already see the new i_size.
+ * coming after we unlock the folio will already see the new i_size.
  * The function must be called while we still hold i_rwsem - this not only
  * makes sure i_size is stable but also that userspace cannot observe new
  * i_size value before we are prepared to store mmap writes at new inode size.
@@ -781,31 +781,29 @@ void pagecache_isize_extended(struct ino
 {
 	int bsize = i_blocksize(inode);
 	loff_t rounded_from;
-	struct page *page;
-	pgoff_t index;
+	struct folio *folio;
 
 	WARN_ON(to > inode->i_size);
 
-	if (from >= to || bsize == PAGE_SIZE)
+	if (from >= to || bsize >= PAGE_SIZE)
 		return;
 	/* Page straddling @from will not have any hole block created? */
 	rounded_from = round_up(from, bsize);
 	if (to <= rounded_from || !(rounded_from & (PAGE_SIZE - 1)))
 		return;
 
-	index = from >> PAGE_SHIFT;
-	page = find_lock_page(inode->i_mapping, index);
-	/* Page not cached? Nothing to do */
-	if (!page)
+	folio = filemap_lock_folio(inode->i_mapping, from / PAGE_SIZE);
+	/* Folio not cached? Nothing to do */
+	if (IS_ERR(folio))
 		return;
 	/*
-	 * See clear_page_dirty_for_io() for details why set_page_dirty()
+	 * See folio_clear_dirty_for_io() for details why folio_mark_dirty()
 	 * is needed.
 	 */
-	if (page_mkclean(page))
-		set_page_dirty(page);
-	unlock_page(page);
-	put_page(page);
+	if (folio_mkclean(folio))
+		folio_mark_dirty(folio);
+	folio_unlock(folio);
+	folio_put(folio);
 }
 EXPORT_SYMBOL(pagecache_isize_extended);
 
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

