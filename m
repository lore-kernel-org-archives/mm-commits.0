Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D55DC46467
	for <mm-commits@archiver.kernel.org>; Mon, 16 Jan 2023 20:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbjAPUF5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Jan 2023 15:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbjAPUFv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jan 2023 15:05:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708AB2411D
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 12:05:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1082EB810F2
        for <mm-commits@vger.kernel.org>; Mon, 16 Jan 2023 20:05:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2955C433EF;
        Mon, 16 Jan 2023 20:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673899547;
        bh=z1Dtk9z9pwpRn8KNvrKaPSb7Jcg121WQEf9NJRbqaf0=;
        h=Date:To:From:Subject:From;
        b=DelN8dRTPgdEBqygPfpuUfPPtyzioy8pM0jDcov8CHgW/Vp/jGJYEmuAFKgS/fEpK
         HDhKDy79rqvbHwmydvXp+CL3pbSHagk7wL7Fai0JyWK9DhHjChsNbvdByqF3j8vV5b
         QIyeaCllfU6FGNXryK9V6qzHUaWqkb+kRfXPw7j0=
Date:   Mon, 16 Jan 2023 12:05:47 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-a-folio-in-copy_pte_range.patch added to mm-unstable branch
Message-Id: <20230116200547.A2955C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use a folio in copy_pte_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-a-folio-in-copy_pte_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-a-folio-in-copy_pte_range.patch

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
Subject: mm: use a folio in copy_pte_range()
Date: Mon, 16 Jan 2023 19:18:12 +0000

Allocate an order-0 folio instead of a page and pass it all the way down
the call chain.  Removes dozens of calls to compound_head().

Link: https://lkml.kernel.org/r/20230116191813.2145215-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/memory.c~mm-use-a-folio-in-copy_pte_range
+++ a/mm/memory.c
@@ -863,13 +863,13 @@ copy_nonpresent_pte(struct mm_struct *ds
 static inline int
 copy_present_page(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 		  pte_t *dst_pte, pte_t *src_pte, unsigned long addr, int *rss,
-		  struct page **prealloc, struct page *page)
+		  struct folio **prealloc, struct page *page)
 {
-	struct page *new_page;
+	struct folio *new_folio;
 	pte_t pte;
 
-	new_page = *prealloc;
-	if (!new_page)
+	new_folio = *prealloc;
+	if (!new_folio)
 		return -EAGAIN;
 
 	/*
@@ -877,14 +877,14 @@ copy_present_page(struct vm_area_struct
 	 * over and copy the page & arm it.
 	 */
 	*prealloc = NULL;
-	copy_user_highpage(new_page, page, addr, src_vma);
-	__SetPageUptodate(new_page);
-	page_add_new_anon_rmap(new_page, dst_vma, addr);
-	lru_cache_add_inactive_or_unevictable(new_page, dst_vma);
-	rss[mm_counter(new_page)]++;
+	copy_user_highpage(&new_folio->page, page, addr, src_vma);
+	__folio_mark_uptodate(new_folio);
+	folio_add_new_anon_rmap(new_folio, dst_vma, addr);
+	folio_add_lru_vma(new_folio, dst_vma);
+	rss[MM_ANONPAGES]++;
 
 	/* All done, just insert the new page copy in the child */
-	pte = mk_pte(new_page, dst_vma->vm_page_prot);
+	pte = mk_pte(&new_folio->page, dst_vma->vm_page_prot);
 	pte = maybe_mkwrite(pte_mkdirty(pte), dst_vma);
 	if (userfaultfd_pte_wp(dst_vma, *src_pte))
 		/* Uffd-wp needs to be delivered to dest pte as well */
@@ -900,7 +900,7 @@ copy_present_page(struct vm_area_struct
 static inline int
 copy_present_pte(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
 		 pte_t *dst_pte, pte_t *src_pte, unsigned long addr, int *rss,
-		 struct page **prealloc)
+		 struct folio **prealloc)
 {
 	struct mm_struct *src_mm = src_vma->vm_mm;
 	unsigned long vm_flags = src_vma->vm_flags;
@@ -922,11 +922,11 @@ copy_present_pte(struct vm_area_struct *
 			return copy_present_page(dst_vma, src_vma, dst_pte, src_pte,
 						 addr, rss, prealloc, page);
 		}
-		rss[mm_counter(page)]++;
+		rss[MM_ANONPAGES]++;
 	} else if (page) {
 		get_page(page);
 		page_dup_file_rmap(page, false);
-		rss[mm_counter(page)]++;
+		rss[mm_counter_file(page)]++;
 	}
 
 	/*
@@ -954,23 +954,22 @@ copy_present_pte(struct vm_area_struct *
 	return 0;
 }
 
-static inline struct page *
-page_copy_prealloc(struct mm_struct *src_mm, struct vm_area_struct *vma,
-		   unsigned long addr)
+static inline struct folio *page_copy_prealloc(struct mm_struct *src_mm,
+		struct vm_area_struct *vma, unsigned long addr)
 {
-	struct page *new_page;
+	struct folio *new_folio;
 
-	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, addr);
-	if (!new_page)
+	new_folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, vma, addr, false);
+	if (!new_folio)
 		return NULL;
 
-	if (mem_cgroup_charge(page_folio(new_page), src_mm, GFP_KERNEL)) {
-		put_page(new_page);
+	if (mem_cgroup_charge(new_folio, src_mm, GFP_KERNEL)) {
+		folio_put(new_folio);
 		return NULL;
 	}
-	cgroup_throttle_swaprate(new_page, GFP_KERNEL);
+	cgroup_throttle_swaprate(&new_folio->page, GFP_KERNEL);
 
-	return new_page;
+	return new_folio;
 }
 
 static int
@@ -986,7 +985,7 @@ copy_pte_range(struct vm_area_struct *ds
 	int progress, ret = 0;
 	int rss[NR_MM_COUNTERS];
 	swp_entry_t entry = (swp_entry_t){0};
-	struct page *prealloc = NULL;
+	struct folio *prealloc = NULL;
 
 again:
 	progress = 0;
@@ -1056,7 +1055,7 @@ again:
 			 * will allocate page according to address).  This
 			 * could only happen if one pinned pte changed.
 			 */
-			put_page(prealloc);
+			folio_put(prealloc);
 			prealloc = NULL;
 		}
 		progress += 8;
@@ -1093,7 +1092,7 @@ again:
 		goto again;
 out:
 	if (unlikely(prealloc))
-		put_page(prealloc);
+		folio_put(prealloc);
 	return ret;
 }
 
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-add-b_folio-as-an-alias-of-b_page.patch
buffer-replace-obvious-uses-of-b_page-with-b_folio.patch
buffer-use-b_folio-in-touch_buffer.patch
buffer-use-b_folio-in-end_buffer_async_read.patch
buffer-use-b_folio-in-end_buffer_async_write.patch
page_io-remove-buffer_head-include.patch
buffer-use-b_folio-in-mark_buffer_dirty.patch
gfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
jbd2-replace-obvious-uses-of-b_page-with-b_folio.patch
nilfs2-replace-obvious-uses-of-b_page-with-b_folio.patch
reiserfs-replace-obvious-uses-of-b_page-with-b_folio.patch
mpage-use-b_folio-in-do_mpage_readpage.patch
mm-memcg-add-folio_memcg_check.patch
mm-remove-folio_pincount_ptr-and-head_compound_pincount.patch
mm-convert-head_subpages_mapcount-into-folio_nr_pages_mapped.patch
doc-clarify-refcount-section-by-referring-to-folios-pages.patch
mm-convert-total_compound_mapcount-to-folio_total_mapcount.patch
mm-convert-page_remove_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_anon_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_file_rmap-to-use-a-folio-internally.patch
mm-add-folio_add_new_anon_rmap.patch
mm-add-folio_add_new_anon_rmap-fix-2.patch
page_alloc-use-folio-fields-directly.patch
mm-use-a-folio-in-hugepage_add_anon_rmap-and-hugepage_add_new_anon_rmap.patch
mm-use-entire_mapcount-in-__page_dup_rmap.patch
mm-debug-remove-call-to-head_compound_mapcount.patch
hugetlb-remove-uses-of-folio_mapcount_ptr.patch
mm-convert-page_mapcount-to-use-folio_entire_mapcount.patch
mm-remove-head_compound_mapcount-and-_ptr-functions.patch
mm-reimplement-compound_order.patch
mm-reimplement-compound_nr.patch
mm-reimplement-compound_nr-fix.patch
mm-convert-set_compound_page_dtor-and-set_compound_order-to-folios.patch
mm-convert-is_transparent_hugepage-to-use-a-folio.patch
mm-convert-destroy_large_folio-to-use-folio_dtor.patch
hugetlb-remove-uses-of-compound_dtor-and-compound_nr.patch
mm-remove-first-tail-page-members-from-struct-page.patch
doc-correct-struct-folio-kernel-doc.patch
mm-move-page-deferred_list-to-folio-_deferred_list.patch
mm-huge_memory-remove-page_deferred_list.patch
mm-huge_memory-convert-get_deferred_split_queue-to-take-a-folio.patch
mm-convert-deferred_split_huge_page-to-deferred_split_folio.patch
shmem-convert-shmem_write_end-to-use-a-folio.patch
mm-add-vma_alloc_zeroed_movable_folio.patch
mm-convert-do_anonymous_page-to-use-a-folio.patch
mm-convert-wp_page_copy-to-use-folios.patch
mm-use-a-folio-in-copy_pte_range.patch
mm-use-a-folio-in-copy_present_pte.patch
mm-fs-convert-inode_attach_wb-to-take-a-folio.patch
mm-convert-mem_cgroup_css_from_page-to-mem_cgroup_css_from_folio.patch
mm-remove-page_evictable.patch
mm-remove-mlock_vma_page.patch
mm-remove-munlock_vma_page.patch
mm-clean-up-mlock_page-munlock_page-references-in-comments.patch

