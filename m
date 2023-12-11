Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011F84D582
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 17:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dAlWbhx4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57531C433C8;
	Mon, 11 Dec 2023 17:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702315418;
	bh=C+SK9hh7g1ALrP167/UnGiroVornwnvZeT++UO6TDhE=;
	h=Date:To:From:Subject:From;
	b=dAlWbhx40FnR8HrX2jQ+AQz5YZW3D/DsYcaJD/ckKMoHRIQRd6o5haRKlSGMLVDG1
	 W6lYGNZ/gv2xdB+OWrA5GIQnJLhGbgmezmoHgsykB04Y2PfDYEZtrWJ4egSuvUAtiM
	 SCL/FzdxvIUPYMsOFrwe2UU/6L+ZDykhZ8mWhtmE=
Date: Mon, 11 Dec 2023 09:23:37 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-unuse_pte-to-use-a-folio-throughout.patch added to mm-unstable branch
Message-Id: <20231211172338.57531C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert unuse_pte() to use a folio throughout
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-unuse_pte-to-use-a-folio-throughout.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-unuse_pte-to-use-a-folio-throughout.patch

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
Subject: mm: convert unuse_pte() to use a folio throughout
Date: Mon, 11 Dec 2023 16:22:08 +0000

Saves about eight calls to compound_head().

Link: https://lkml.kernel.org/r/20231211162214.2146080-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   47 +++++++++++++++++++++++++----------------------
 1 file changed, 25 insertions(+), 22 deletions(-)

--- a/mm/swapfile.c~mm-convert-unuse_pte-to-use-a-folio-throughout
+++ a/mm/swapfile.c
@@ -1741,21 +1741,25 @@ static inline int pte_same_as_swp(pte_t
 static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long addr, swp_entry_t entry, struct folio *folio)
 {
-	struct page *page = folio_file_page(folio, swp_offset(entry));
-	struct page *swapcache;
+	struct page *page;
+	struct folio *swapcache;
 	spinlock_t *ptl;
 	pte_t *pte, new_pte, old_pte;
-	bool hwpoisoned = PageHWPoison(page);
+	bool hwpoisoned = false;
 	int ret = 1;
 
-	swapcache = page;
+	swapcache = folio;
 	folio = ksm_might_need_to_copy(folio, vma, addr);
 	if (unlikely(!folio))
 		return -ENOMEM;
-	else if (unlikely(folio == ERR_PTR(-EHWPOISON)))
+	else if (unlikely(folio == ERR_PTR(-EHWPOISON))) {
+		hwpoisoned = true;
+		folio = swapcache;
+	}
+
+	page = folio_file_page(folio, swp_offset(entry));
+	if (PageHWPoison(page))
 		hwpoisoned = true;
-	else
-		page = folio_file_page(folio, swp_offset(entry));
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	if (unlikely(!pte || !pte_same_as_swp(ptep_get(pte),
@@ -1766,13 +1770,12 @@ static int unuse_pte(struct vm_area_stru
 
 	old_pte = ptep_get(pte);
 
-	if (unlikely(hwpoisoned || !PageUptodate(page))) {
+	if (unlikely(hwpoisoned || !folio_test_uptodate(folio))) {
 		swp_entry_t swp_entry;
 
 		dec_mm_counter(vma->vm_mm, MM_SWAPENTS);
 		if (hwpoisoned) {
-			swp_entry = make_hwpoison_entry(swapcache);
-			page = swapcache;
+			swp_entry = make_hwpoison_entry(page);
 		} else {
 			swp_entry = make_poisoned_swp_entry();
 		}
@@ -1786,7 +1789,7 @@ static int unuse_pte(struct vm_area_stru
 	 * when reading from swap. This metadata may be indexed by swap entry
 	 * so this must be called before swap_free().
 	 */
-	arch_swap_restore(entry, page_folio(page));
+	arch_swap_restore(entry, folio);
 
 	/* See do_swap_page() */
 	VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
@@ -1794,23 +1797,23 @@ static int unuse_pte(struct vm_area_stru
 
 	dec_mm_counter(vma->vm_mm, MM_SWAPENTS);
 	inc_mm_counter(vma->vm_mm, MM_ANONPAGES);
-	get_page(page);
-	if (page == swapcache) {
+	folio_get(folio);
+	if (folio == swapcache) {
 		rmap_t rmap_flags = RMAP_NONE;
 
 		/*
-		 * See do_swap_page(): PageWriteback() would be problematic.
-		 * However, we do a wait_on_page_writeback() just before this
-		 * call and have the page locked.
+		 * See do_swap_page(): writeback would be problematic.
+		 * However, we do a folio_wait_writeback() just before this
+		 * call and have the folio locked.
 		 */
-		VM_BUG_ON_PAGE(PageWriteback(page), page);
+		VM_BUG_ON_FOLIO(folio_test_writeback(folio), folio);
 		if (pte_swp_exclusive(old_pte))
 			rmap_flags |= RMAP_EXCLUSIVE;
 
 		page_add_anon_rmap(page, vma, addr, rmap_flags);
 	} else { /* ksm created a completely new copy */
-		page_add_new_anon_rmap(page, vma, addr);
-		lru_cache_add_inactive_or_unevictable(page, vma);
+		folio_add_new_anon_rmap(folio, vma, addr);
+		folio_add_lru_vma(folio, vma);
 	}
 	new_pte = pte_mkold(mk_pte(page, vma->vm_page_prot));
 	if (pte_swp_soft_dirty(old_pte))
@@ -1823,9 +1826,9 @@ setpte:
 out:
 	if (pte)
 		pte_unmap_unlock(pte, ptl);
-	if (page != swapcache) {
-		unlock_page(page);
-		put_page(page);
+	if (folio != swapcache) {
+		folio_unlock(folio);
+		folio_put(folio);
 	}
 	return ret;
 }
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
mm-simplify-the-assertions-in-unuse_pte.patch
mm-convert-unuse_pte-to-use-a-folio-throughout.patch
mm-remove-some-calls-to-page_add_new_anon_rmap.patch
mm-remove-stale-example-from-comment.patch
mm-remove-references-to-page_add_new_anon_rmap-in-comments.patch
mm-convert-migrate_vma_insert_page-to-use-a-folio.patch
mm-convert-collapse_huge_page-to-use-a-folio.patch
mm-remove-page_add_new_anon_rmap-and-lru_cache_add_inactive_or_unevictable.patch

