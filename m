Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0967134C7
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0MeLLNP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CBEBC433C8;
	Fri, 29 Dec 2023 20:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880016;
	bh=pMMCoLlZXcm5wQh3W2SFYRwIvrbelvZPFIzG1Jg7NnA=;
	h=Date:To:From:Subject:From;
	b=0MeLLNP21unkbZ9BOVz3dUPxnwxApyI11zgmsKrDG0Bux4WxYlMVW6/jIERFpjIEa
	 j0l2QPGyVc0UHppsJ1kSamBqgX+bib1IXEM/YHitWrWOqWJXKVv14pj+R70OoU4pfM
	 Q0acJeibvykasfpzQwdyaTW08XIHdwUwe+/3s5mM=
Date: Fri, 29 Dec 2023 12:00:15 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-return-a-folio-from-read_swap_cache_async.patch removed from -mm tree
Message-Id: <20231229200016.6CBEBC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: return a folio from read_swap_cache_async()
has been removed from the -mm tree.  Its filename was
     mm-return-a-folio-from-read_swap_cache_async.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

