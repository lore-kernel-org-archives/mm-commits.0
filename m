Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9E612E46
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j+siMEM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1557EC433C7;
	Fri, 29 Dec 2023 19:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879980;
	bh=F1RyxRUZ2ihNAmYYL+KbhSNpjrtc0KKyh6CR8qBGtpg=;
	h=Date:To:From:Subject:From;
	b=j+siMEM4uZLnNvPnaGgBtPV9W6e+QQwSdA7Vie419qMB2DG8PcmmT9WDBcX3u828X
	 zfRRrDpFeFU7QDIIhEpjWWlYod7hEeAVJUCPvCe0mr19T2vNUoKohTzu6tdY6Xsp79
	 fKbx3WLdLg1UqinfHTKK+kLKClXnvD1WNcv8LbgI=
Date: Fri, 29 Dec 2023 11:59:39 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-ksm_might_need_to_copy-to-work-on-folios.patch removed from -mm tree
Message-Id: <20231229195940.1557EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert ksm_might_need_to_copy() to work on folios
has been removed from the -mm tree.  Its filename was
     mm-convert-ksm_might_need_to_copy-to-work-on-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert ksm_might_need_to_copy() to work on folios
Date: Mon, 11 Dec 2023 16:22:06 +0000

Patch series "Finish two folio conversions".

Most callers of page_add_new_anon_rmap() and
lru_cache_add_inactive_or_unevictable() have been converted to their folio
equivalents, but there are still a few stragglers.  There's a bit of
preparatory work in ksm and unuse_pte(), but after that it's pretty
mechanical.


This patch (of 9):

Accept a folio as an argument and return a folio result.  Removes a call
to compound_head() in do_swap_page(), and prevents folio & page from
getting out of sync in unuse_pte().

Reviewed-by: David Hildenbrand <david@redhat.com>
[willy@infradead.org: fix smatch warning]
  Link: https://lkml.kernel.org/r/ZXnPtblC6A1IkyAB@casper.infradead.org
[david@redhat.com: only adjust the page if the folio changed]
  Link: https://lkml.kernel.org/r/6a8f2110-fa91-4c10-9eae-88315309a6e3@redhat.com
Link: https://lkml.kernel.org/r/20231211162214.2146080-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20231211162214.2146080-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h |    6 +++---
 mm/ksm.c            |   21 +++++++++++----------
 mm/memory.c         |   11 +++++++----
 mm/swapfile.c       |    8 +++++---
 4 files changed, 26 insertions(+), 20 deletions(-)

--- a/include/linux/ksm.h~mm-convert-ksm_might_need_to_copy-to-work-on-folios
+++ a/include/linux/ksm.h
@@ -76,7 +76,7 @@ static inline void ksm_exit(struct mm_st
  * We'd like to make this conditional on vma->vm_flags & VM_MERGEABLE,
  * but what if the vma was unmerged while the page was swapped out?
  */
-struct page *ksm_might_need_to_copy(struct page *page,
+struct folio *ksm_might_need_to_copy(struct folio *folio,
 			struct vm_area_struct *vma, unsigned long addr);
 
 void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc);
@@ -129,10 +129,10 @@ static inline int ksm_madvise(struct vm_
 	return 0;
 }
 
-static inline struct page *ksm_might_need_to_copy(struct page *page,
+static inline struct folio *ksm_might_need_to_copy(struct folio *folio,
 			struct vm_area_struct *vma, unsigned long addr)
 {
-	return page;
+	return folio;
 }
 
 static inline void rmap_walk_ksm(struct folio *folio,
--- a/mm/ksm.c~mm-convert-ksm_might_need_to_copy-to-work-on-folios
+++ a/mm/ksm.c
@@ -2873,30 +2873,30 @@ void __ksm_exit(struct mm_struct *mm)
 	trace_ksm_exit(mm);
 }
 
-struct page *ksm_might_need_to_copy(struct page *page,
+struct folio *ksm_might_need_to_copy(struct folio *folio,
 			struct vm_area_struct *vma, unsigned long addr)
 {
-	struct folio *folio = page_folio(page);
+	struct page *page = folio_page(folio, 0);
 	struct anon_vma *anon_vma = folio_anon_vma(folio);
 	struct folio *new_folio;
 
 	if (folio_test_large(folio))
-		return page;
+		return folio;
 
 	if (folio_test_ksm(folio)) {
 		if (folio_stable_node(folio) &&
 		    !(ksm_run & KSM_RUN_UNMERGE))
-			return page;	/* no need to copy it */
+			return folio;	/* no need to copy it */
 	} else if (!anon_vma) {
-		return page;		/* no need to copy it */
+		return folio;		/* no need to copy it */
 	} else if (folio->index == linear_page_index(vma, addr) &&
 			anon_vma->root == vma->anon_vma->root) {
-		return page;		/* still no need to copy it */
+		return folio;		/* still no need to copy it */
 	}
 	if (PageHWPoison(page))
 		return ERR_PTR(-EHWPOISON);
 	if (!folio_test_uptodate(folio))
-		return page;		/* let do_swap_page report the error */
+		return folio;		/* let do_swap_page report the error */
 
 	new_folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, addr, false);
 	if (new_folio &&
@@ -2905,9 +2905,10 @@ struct page *ksm_might_need_to_copy(stru
 		new_folio = NULL;
 	}
 	if (new_folio) {
-		if (copy_mc_user_highpage(&new_folio->page, page, addr, vma)) {
+		if (copy_mc_user_highpage(folio_page(new_folio, 0), page,
+								addr, vma)) {
 			folio_put(new_folio);
-			memory_failure_queue(page_to_pfn(page), 0);
+			memory_failure_queue(folio_pfn(folio), 0);
 			return ERR_PTR(-EHWPOISON);
 		}
 		folio_set_dirty(new_folio);
@@ -2918,7 +2919,7 @@ struct page *ksm_might_need_to_copy(stru
 #endif
 	}
 
-	return new_folio ? &new_folio->page : NULL;
+	return new_folio;
 }
 
 void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
--- a/mm/memory.c~mm-convert-ksm_might_need_to_copy-to-work-on-folios
+++ a/mm/memory.c
@@ -3942,15 +3942,18 @@ vm_fault_t do_swap_page(struct vm_fault
 		 * page->index of !PageKSM() pages would be nonlinear inside the
 		 * anon VMA -- PageKSM() is lost on actual swapout.
 		 */
-		page = ksm_might_need_to_copy(page, vma, vmf->address);
-		if (unlikely(!page)) {
+		folio = ksm_might_need_to_copy(folio, vma, vmf->address);
+		if (unlikely(!folio)) {
 			ret = VM_FAULT_OOM;
+			folio = swapcache;
 			goto out_page;
-		} else if (unlikely(PTR_ERR(page) == -EHWPOISON)) {
+		} else if (unlikely(folio == ERR_PTR(-EHWPOISON))) {
 			ret = VM_FAULT_HWPOISON;
+			folio = swapcache;
 			goto out_page;
 		}
-		folio = page_folio(page);
+		if (folio != swapcache)
+			page = folio_page(folio, 0);
 
 		/*
 		 * If we want to map a page that's in the swapcache writable, we
--- a/mm/swapfile.c~mm-convert-ksm_might_need_to_copy-to-work-on-folios
+++ a/mm/swapfile.c
@@ -1749,11 +1749,13 @@ static int unuse_pte(struct vm_area_stru
 	int ret = 1;
 
 	swapcache = page;
-	page = ksm_might_need_to_copy(page, vma, addr);
-	if (unlikely(!page))
+	folio = ksm_might_need_to_copy(folio, vma, addr);
+	if (unlikely(!folio))
 		return -ENOMEM;
-	else if (unlikely(PTR_ERR(page) == -EHWPOISON))
+	else if (unlikely(folio == ERR_PTR(-EHWPOISON)))
 		hwpoisoned = true;
+	else
+		page = folio_file_page(folio, swp_offset(entry));
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	if (unlikely(!pte || !pte_same_as_swp(ptep_get(pte),
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

