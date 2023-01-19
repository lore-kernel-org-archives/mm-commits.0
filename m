Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0ED3C004D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 22:49:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjASWtz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Jan 2023 17:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbjASWtT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2023 17:49:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144708A707
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 14:32:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3AF761D8F
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 22:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43581C433D2;
        Thu, 19 Jan 2023 22:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674167551;
        bh=sDjNY/HJQ6SOTskZyZPzGdyshyDEtrMV+4zTNCZ+/y0=;
        h=Date:To:From:Subject:From;
        b=Yfv7CXUjBokF1wU0fkxpNKc6mdqmP8/iNiGGHiLkO9xQqonomjptzdcpwRYCtEalV
         jNC+S24CgU+rsKxRU/XPM8voGyJPz4rVrYYBsxW2UJl+gsu4XqHvnzqU7MGOV/Dqgz
         w3uXe+KBwstoJEodsZuXYAUnQG7oImIYBjvOIo7w=
Date:   Thu, 19 Jan 2023 14:32:30 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-change-hugepage_add_new_anon_rmap-to-take-in-a-folio.patch added to mm-unstable branch
Message-Id: <20230119223231.43581C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: change hugepage_add_new_anon_rmap to take in a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-change-hugepage_add_new_anon_rmap-to-take-in-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-change-hugepage_add_new_anon_rmap-to-take-in-a-folio.patch

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
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: mm/rmap: change hugepage_add_new_anon_rmap to take in a folio
Date: Thu, 19 Jan 2023 13:14:41 -0800

Change hugepage_add_new_anon_rmap() to take in a folio directly.  While
adding a folio variable to the four call sites, convert page functions
with their folio equivalents.  This removes three callers of the Huge Page
macros which take in a page.

Link: https://lkml.kernel.org/r/20230119211446.54165-5-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/rmap.h~mm-rmap-change-hugepage_add_new_anon_rmap-to-take-in-a-folio
+++ a/include/linux/rmap.h
@@ -203,7 +203,7 @@ void page_remove_rmap(struct page *, str
 
 void hugepage_add_anon_rmap(struct page *, struct vm_area_struct *,
 		unsigned long address, rmap_t flags);
-void hugepage_add_new_anon_rmap(struct page *, struct vm_area_struct *,
+void hugepage_add_new_anon_rmap(struct folio *, struct vm_area_struct *,
 		unsigned long address);
 
 static inline void __page_dup_rmap(struct page *page, bool compound)
--- a/mm/hugetlb.c~mm-rmap-change-hugepage_add_new_anon_rmap-to-take-in-a-folio
+++ a/mm/hugetlb.c
@@ -4950,7 +4950,7 @@ hugetlb_install_folio(struct vm_area_str
 		     struct folio *new_folio)
 {
 	__folio_mark_uptodate(new_folio);
-	hugepage_add_new_anon_rmap(&new_folio->page, vma, addr);
+	hugepage_add_new_anon_rmap(new_folio, vma, addr);
 	set_huge_pte_at(vma->vm_mm, addr, ptep, make_huge_pte(vma, &new_folio->page, 1));
 	hugetlb_count_add(pages_per_huge_page(hstate_vma(vma)), vma->vm_mm);
 	folio_set_hugetlb_migratable(new_folio);
@@ -5479,6 +5479,7 @@ static vm_fault_t hugetlb_wp(struct mm_s
 	pte_t pte;
 	struct hstate *h = hstate_vma(vma);
 	struct page *old_page, *new_page;
+	struct folio *new_folio = NULL;
 	int outside_reserve = 0;
 	vm_fault_t ret = 0;
 	unsigned long haddr = address & huge_page_mask(h);
@@ -5590,6 +5591,9 @@ retry_avoidcopy:
 		goto out_release_old;
 	}
 
+	if (new_page)
+		new_folio = page_folio(new_page);
+
 	/*
 	 * When the original hugepage is shared one, it does not have
 	 * anon_vma prepared.
@@ -5599,9 +5603,9 @@ retry_avoidcopy:
 		goto out_release_all;
 	}
 
-	copy_user_huge_page(new_page, old_page, address, vma,
+	copy_user_huge_page(&new_folio->page, old_page, address, vma,
 			    pages_per_huge_page(h));
-	__SetPageUptodate(new_page);
+	__folio_mark_uptodate(new_folio);
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, haddr,
 				haddr + huge_page_size(h));
@@ -5618,10 +5622,10 @@ retry_avoidcopy:
 		huge_ptep_clear_flush(vma, haddr, ptep);
 		mmu_notifier_invalidate_range(mm, range.start, range.end);
 		page_remove_rmap(old_page, vma, true);
-		hugepage_add_new_anon_rmap(new_page, vma, haddr);
+		hugepage_add_new_anon_rmap(new_folio, vma, haddr);
 		set_huge_pte_at(mm, haddr, ptep,
-				make_huge_pte(vma, new_page, !unshare));
-		SetHPageMigratable(new_page);
+				make_huge_pte(vma, &new_folio->page, !unshare));
+		folio_set_hugetlb_migratable(new_folio);
 		/* Make the old page be freed below */
 		new_page = old_page;
 	}
@@ -5633,8 +5637,8 @@ out_release_all:
 	 * unshare)
 	 */
 	if (new_page != old_page)
-		restore_reserve_on_error(h, vma, haddr, new_page);
-	put_page(new_page);
+		restore_reserve_on_error(h, vma, haddr, &new_folio->page);
+	folio_put(new_folio);
 out_release_old:
 	put_page(old_page);
 
@@ -5756,6 +5760,7 @@ static vm_fault_t hugetlb_no_page(struct
 	int anon_rmap = 0;
 	unsigned long size;
 	struct page *page;
+	struct folio *folio = NULL;
 	pte_t new_pte;
 	spinlock_t *ptl;
 	unsigned long haddr = address & huge_page_mask(h);
@@ -5833,12 +5838,16 @@ static vm_fault_t hugetlb_no_page(struct
 				ret = 0;
 			goto out;
 		}
-		clear_huge_page(page, address, pages_per_huge_page(h));
-		__SetPageUptodate(page);
+
+		if (page)
+			folio = page_folio(page);
+
+		clear_huge_page(&folio->page, address, pages_per_huge_page(h));
+		__folio_mark_uptodate(folio);
 		new_page = true;
 
 		if (vma->vm_flags & VM_MAYSHARE) {
-			int err = hugetlb_add_to_page_cache(page, mapping, idx);
+			int err = hugetlb_add_to_page_cache(&folio->page, mapping, idx);
 			if (err) {
 				/*
 				 * err can't be -EEXIST which implies someone
@@ -5847,13 +5856,13 @@ static vm_fault_t hugetlb_no_page(struct
 				 * to the page cache. So it's safe to call
 				 * restore_reserve_on_error() here.
 				 */
-				restore_reserve_on_error(h, vma, haddr, page);
-				put_page(page);
+				restore_reserve_on_error(h, vma, haddr, &folio->page);
+				folio_put(folio);
 				goto out;
 			}
 			new_pagecache_page = true;
 		} else {
-			lock_page(page);
+			folio_lock(folio);
 			if (unlikely(anon_vma_prepare(vma))) {
 				ret = VM_FAULT_OOM;
 				goto backout_unlocked;
@@ -5861,12 +5870,13 @@ static vm_fault_t hugetlb_no_page(struct
 			anon_rmap = 1;
 		}
 	} else {
+		folio = page_folio(page);
 		/*
 		 * If memory error occurs between mmap() and fault, some process
 		 * don't have hwpoisoned swap entry for errored virtual address.
 		 * So we need to block hugepage fault by PG_hwpoison bit check.
 		 */
-		if (unlikely(PageHWPoison(page))) {
+		if (unlikely(folio_test_hwpoison(folio))) {
 			ret = VM_FAULT_HWPOISON_LARGE |
 				VM_FAULT_SET_HINDEX(hstate_index(h));
 			goto backout_unlocked;
@@ -5874,8 +5884,8 @@ static vm_fault_t hugetlb_no_page(struct
 
 		/* Check for page in userfault range. */
 		if (userfaultfd_minor(vma)) {
-			unlock_page(page);
-			put_page(page);
+			folio_unlock(folio);
+			folio_put(folio);
 			/* See comment in userfaultfd_missing() block above */
 			if (!hugetlb_pte_stable(h, mm, ptep, old_pte)) {
 				ret = 0;
@@ -5909,10 +5919,10 @@ static vm_fault_t hugetlb_no_page(struct
 		goto backout;
 
 	if (anon_rmap)
-		hugepage_add_new_anon_rmap(page, vma, haddr);
+		hugepage_add_new_anon_rmap(folio, vma, haddr);
 	else
-		page_dup_file_rmap(page, true);
-	new_pte = make_huge_pte(vma, page, ((vma->vm_flags & VM_WRITE)
+		page_dup_file_rmap(&folio->page, true);
+	new_pte = make_huge_pte(vma, &folio->page, ((vma->vm_flags & VM_WRITE)
 				&& (vma->vm_flags & VM_SHARED)));
 	/*
 	 * If this pte was previously wr-protected, keep it wr-protected even
@@ -5925,7 +5935,7 @@ static vm_fault_t hugetlb_no_page(struct
 	hugetlb_count_add(pages_per_huge_page(h), mm);
 	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
 		/* Optimization, do the COW without a second fault */
-		ret = hugetlb_wp(mm, vma, address, ptep, flags, page, ptl);
+		ret = hugetlb_wp(mm, vma, address, ptep, flags, &folio->page, ptl);
 	}
 
 	spin_unlock(ptl);
@@ -5936,9 +5946,9 @@ static vm_fault_t hugetlb_no_page(struct
 	 * been isolated for migration.
 	 */
 	if (new_page)
-		SetHPageMigratable(page);
+		folio_set_hugetlb_migratable(folio);
 
-	unlock_page(page);
+	folio_unlock(folio);
 out:
 	hugetlb_vma_unlock_read(vma);
 	mutex_unlock(&hugetlb_fault_mutex_table[hash]);
@@ -5948,10 +5958,10 @@ backout:
 	spin_unlock(ptl);
 backout_unlocked:
 	if (new_page && !new_pagecache_page)
-		restore_reserve_on_error(h, vma, haddr, page);
+		restore_reserve_on_error(h, vma, haddr, &folio->page);
 
-	unlock_page(page);
-	put_page(page);
+	folio_unlock(folio);
+	folio_put(folio);
 	goto out;
 }
 
@@ -6176,6 +6186,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 	spinlock_t *ptl;
 	int ret = -ENOMEM;
 	struct page *page;
+	struct folio *folio = NULL;
 	int writable;
 	bool page_in_pagecache = false;
 
@@ -6251,12 +6262,15 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 		*pagep = NULL;
 	}
 
+	if (page)
+		folio = page_folio(page);
+
 	/*
-	 * The memory barrier inside __SetPageUptodate makes sure that
+	 * The memory barrier inside __folio_mark_uptodate makes sure that
 	 * preceding stores to the page contents become visible before
 	 * the set_pte_at() write.
 	 */
-	__SetPageUptodate(page);
+	__folio_mark_uptodate(folio);
 
 	/* Add shared, newly allocated pages to the page cache. */
 	if (vm_shared && !is_continue) {
@@ -6271,7 +6285,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 		 * hugetlb_fault_mutex_table that here must be hold by
 		 * the caller.
 		 */
-		ret = hugetlb_add_to_page_cache(page, mapping, idx);
+		ret = hugetlb_add_to_page_cache(&folio->page, mapping, idx);
 		if (ret)
 			goto out_release_nounlock;
 		page_in_pagecache = true;
@@ -6280,7 +6294,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 	ptl = huge_pte_lock(h, dst_mm, dst_pte);
 
 	ret = -EIO;
-	if (PageHWPoison(page))
+	if (folio_test_hwpoison(folio))
 		goto out_release_unlock;
 
 	/*
@@ -6293,9 +6307,9 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 		goto out_release_unlock;
 
 	if (page_in_pagecache)
-		page_dup_file_rmap(page, true);
+		page_dup_file_rmap(&folio->page, true);
 	else
-		hugepage_add_new_anon_rmap(page, dst_vma, dst_addr);
+		hugepage_add_new_anon_rmap(folio, dst_vma, dst_addr);
 
 	/*
 	 * For either: (1) CONTINUE on a non-shared VMA, or (2) UFFDIO_COPY
@@ -6306,7 +6320,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 	else
 		writable = dst_vma->vm_flags & VM_WRITE;
 
-	_dst_pte = make_huge_pte(dst_vma, page, writable);
+	_dst_pte = make_huge_pte(dst_vma, &folio->page, writable);
 	/*
 	 * Always mark UFFDIO_COPY page dirty; note that this may not be
 	 * extremely important for hugetlbfs for now since swapping is not
@@ -6328,20 +6342,20 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 
 	spin_unlock(ptl);
 	if (!is_continue)
-		SetHPageMigratable(page);
+		folio_set_hugetlb_migratable(folio);
 	if (vm_shared || is_continue)
-		unlock_page(page);
+		folio_unlock(folio);
 	ret = 0;
 out:
 	return ret;
 out_release_unlock:
 	spin_unlock(ptl);
 	if (vm_shared || is_continue)
-		unlock_page(page);
+		folio_unlock(folio);
 out_release_nounlock:
 	if (!page_in_pagecache)
-		restore_reserve_on_error(h, dst_vma, dst_addr, page);
-	put_page(page);
+		restore_reserve_on_error(h, dst_vma, dst_addr, &folio->page);
+	folio_put(folio);
 	goto out;
 }
 #endif /* CONFIG_USERFAULTFD */
--- a/mm/rmap.c~mm-rmap-change-hugepage_add_new_anon_rmap-to-take-in-a-folio
+++ a/mm/rmap.c
@@ -2547,15 +2547,13 @@ void hugepage_add_anon_rmap(struct page
 				     !!(flags & RMAP_EXCLUSIVE));
 }
 
-void hugepage_add_new_anon_rmap(struct page *page,
+void hugepage_add_new_anon_rmap(struct folio *folio,
 			struct vm_area_struct *vma, unsigned long address)
 {
-	struct folio *folio = page_folio(page);
-
 	BUG_ON(address < vma->vm_start || address >= vma->vm_end);
 	/* increment count (starts at -1) */
 	atomic_set(&folio->_entire_mapcount, 0);
 	folio_clear_hugetlb_restore_reserve(folio);
-	__page_set_anon_rmap(folio, page, vma, address, 1);
+	__page_set_anon_rmap(folio, &folio->page, vma, address, 1);
 }
 #endif /* CONFIG_HUGETLB_PAGE */
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

mm-remove-the-hugetlb-field-from-struct-page.patch
mm-memory-failure-convert-__get_huge_page_for_hwpoison-to-folios.patch
mm-memory-failure-convert-try_memory_failure_hugetlb-to-folios.patch
mm-memory-failure-convert-hugetlb_clear_page_hwpoison-to-folios.patch
mm-memory-failure-convert-free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-raw_hwp_list_head-to-folios.patch
mm-memory-failure-convert-__free_raw_hwp_pages-to-folios.patch
mm-memory-failure-convert-hugetlb_set_page_hwpoison-to-folios.patch
mm-memory-failure-convert-unpoison_memory-to-folios.patch
mm-hugetlb-convert-isolate_hugetlb-to-folios.patch
mm-hugetlb-convert-__update_and_free_page-to-folios.patch
mm-hugetlb-convert-dequeue_hugetlb_page-functions-to-folios.patch
mm-hugetlb-convert-alloc_surplus_huge_page-to-folios.patch
mm-hugetlb-increase-use-of-folios-in-alloc_huge_page.patch
mm-hugetlb-convert-alloc_migrate_huge_page-to-folios.patch
mm-hugetlb-convert-restore_reserve_on_error-to-folios.patch
mm-hugetlb-convert-demote_free_huge_page-to-folios.patch
mm-hugetlb-convert-get_hwpoison_huge_page-to-folios.patch
mm-hugetlb-convert-hugetlb_install_page-to-folios.patch
mm-hugetlb-convert-hugetlbfs_pagecache_present-to-folios.patch
mm-hugetlb-convert-putback_active_hugepage-to-take-in-a-folio.patch
mm-rmap-change-hugepage_add_new_anon_rmap-to-take-in-a-folio.patch
mm-hugetlb-convert-alloc_huge_page-to-alloc_hugetlb_folio.patch
mm-hugetlb-convert-restore_reserve_on_error-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_add_to_page_cache-to-take-in-a-folio.patch
mm-hugetlb-convert-hugetlb_wp-to-take-in-a-folio.patch
documentation-mm-update-hugetlbfs-documentation-to-mention-alloc_hugetlb_folio.patch

