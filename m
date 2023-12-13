Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438778183A
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 23:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IcVf86HK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F564C433C8;
	Wed, 13 Dec 2023 23:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702509137;
	bh=Hayc4SiCHmefvVbvfaM0GvPGmE7lqrQf9EGxNqdojm8=;
	h=Date:To:From:Subject:From;
	b=IcVf86HKew5yf5tnRH4ONk5bruNf1LAwnvpjz/EEz2doXS2ruiV/Xgfc6TCoUUpM5
	 56ZIsu5g/c98yQE2gcIyNkF1o4RqbNB9IR3OB5QSFaagJsIJnkRNLQKaDeVnPYbNuu
	 9DNFkhKcQT8LnScf6Qu5nVqleT4OdCMFK4m3r/0E=
Date: Wed, 13 Dec 2023 15:12:16 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-return-a-folio-from-read_swap_cache_async.patch added to mm-unstable branch
Message-Id: <20231213231217.0F564C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: return a folio from read_swap_cache_async()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-return-a-folio-from-read_swap_cache_async.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-return-a-folio-from-read_swap_cache_async.patch

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
Subject: mm: return a folio from read_swap_cache_async()
Date: Wed, 13 Dec 2023 21:58:41 +0000

The only two callers simply call put_page() on the page returned, so
they're happier calling folio_put().  Saves two calls to compound_head().

Link: https://lkml.kernel.org/r/20231213215842.671461-13-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c    |   22 +++++++++++-----------
 mm/swap.h       |    7 +++----
 mm/swap_state.c |    8 ++++----
 3 files changed, 18 insertions(+), 19 deletions(-)

--- a/mm/madvise.c~mm-return-a-folio-from-read_swap_cache_async
+++ a/mm/madvise.c
@@ -180,7 +180,7 @@ static int swapin_walk_pmd_entry(pmd_t *
 	for (addr = start; addr < end; addr += PAGE_SIZE) {
 		pte_t pte;
 		swp_entry_t entry;
-		struct page *page;
+		struct folio *folio;
 
 		if (!ptep++) {
 			ptep = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
@@ -198,10 +198,10 @@ static int swapin_walk_pmd_entry(pmd_t *
 		pte_unmap_unlock(ptep, ptl);
 		ptep = NULL;
 
-		page = read_swap_cache_async(entry, GFP_HIGHUSER_MOVABLE,
+		folio = read_swap_cache_async(entry, GFP_HIGHUSER_MOVABLE,
 					     vma, addr, &splug);
-		if (page)
-			put_page(page);
+		if (folio)
+			folio_put(folio);
 	}
 
 	if (ptep)
@@ -223,17 +223,17 @@ static void shmem_swapin_range(struct vm
 {
 	XA_STATE(xas, &mapping->i_pages, linear_page_index(vma, start));
 	pgoff_t end_index = linear_page_index(vma, end) - 1;
-	struct page *page;
+	struct folio *folio;
 	struct swap_iocb *splug = NULL;
 
 	rcu_read_lock();
-	xas_for_each(&xas, page, end_index) {
+	xas_for_each(&xas, folio, end_index) {
 		unsigned long addr;
 		swp_entry_t entry;
 
-		if (!xa_is_value(page))
+		if (!xa_is_value(folio))
 			continue;
-		entry = radix_to_swp_entry(page);
+		entry = radix_to_swp_entry(folio);
 		/* There might be swapin error entries in shmem mapping. */
 		if (non_swap_entry(entry))
 			continue;
@@ -243,10 +243,10 @@ static void shmem_swapin_range(struct vm
 		xas_pause(&xas);
 		rcu_read_unlock();
 
-		page = read_swap_cache_async(entry, mapping_gfp_mask(mapping),
+		folio = read_swap_cache_async(entry, mapping_gfp_mask(mapping),
 					     vma, addr, &splug);
-		if (page)
-			put_page(page);
+		if (folio)
+			folio_put(folio);
 
 		rcu_read_lock();
 	}
--- a/mm/swap.h~mm-return-a-folio-from-read_swap_cache_async
+++ a/mm/swap.h
@@ -46,10 +46,9 @@ struct folio *swap_cache_get_folio(swp_e
 struct folio *filemap_get_incore_folio(struct address_space *mapping,
 		pgoff_t index);
 
-struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
-				   struct vm_area_struct *vma,
-				   unsigned long addr,
-				   struct swap_iocb **plug);
+struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
+		struct vm_area_struct *vma, unsigned long addr,
+		struct swap_iocb **plug);
 struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_flags,
 		struct mempolicy *mpol, pgoff_t ilx, bool *new_page_allocated,
 		bool skip_if_exists);
--- a/mm/swap_state.c~mm-return-a-folio-from-read_swap_cache_async
+++ a/mm/swap_state.c
@@ -533,9 +533,9 @@ fail_put_swap:
  * __read_swap_cache_async() call them and swap_read_folio() holds the
  * swap cache folio lock.
  */
-struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
-				   struct vm_area_struct *vma,
-				   unsigned long addr, struct swap_iocb **plug)
+struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
+		struct vm_area_struct *vma, unsigned long addr,
+		struct swap_iocb **plug)
 {
 	bool page_allocated;
 	struct mempolicy *mpol;
@@ -549,7 +549,7 @@ struct page *read_swap_cache_async(swp_e
 
 	if (page_allocated)
 		swap_read_folio(folio, false, plug);
-	return folio_file_page(folio, swp_offset(entry));
+	return folio;
 }
 
 static unsigned int __swapin_nr_pages(unsigned long prev_offset,
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch
mm-convert-ksm_might_need_to_copy-to-work-on-folios.patch
mm-remove-pageanonexclusive-assertions-in-unuse_pte.patch
mm-convert-unuse_pte-to-use-a-folio-throughout.patch
mm-remove-some-calls-to-page_add_new_anon_rmap.patch
mm-remove-stale-example-from-comment.patch
mm-remove-references-to-page_add_new_anon_rmap-in-comments.patch
mm-convert-migrate_vma_insert_page-to-use-a-folio.patch
mm-convert-collapse_huge_page-to-use-a-folio.patch
mm-remove-page_add_new_anon_rmap-and-lru_cache_add_inactive_or_unevictable.patch
mm-return-the-folio-from-__read_swap_cache_async.patch
mm-pass-a-folio-to-__swap_writepage.patch
mm-pass-a-folio-to-swap_writepage_fs.patch
mm-pass-a-folio-to-swap_writepage_bdev_sync.patch
mm-pass-a-folio-to-swap_writepage_bdev_async.patch
mm-pass-a-folio-to-swap_readpage_fs.patch
mm-pass-a-folio-to-swap_readpage_bdev_sync.patch
mm-pass-a-folio-to-swap_readpage_bdev_async.patch
mm-convert-swap_page_sector-to-swap_folio_sector.patch
mm-convert-swap_readpage-to-swap_read_folio.patch
mm-remove-page_swap_info.patch
mm-return-a-folio-from-read_swap_cache_async.patch
mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio.patch

