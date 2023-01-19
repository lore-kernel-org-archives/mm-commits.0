Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAAD3C004D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 22:50:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbjASWt6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Jan 2023 17:49:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbjASWtY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2023 17:49:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1461F94CB3
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 14:32:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6170C61D61
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 22:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E35C433EF;
        Thu, 19 Jan 2023 22:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674167553;
        bh=harjOiaPjG7hnnrrwcQznhhwSaHF+BilcO26tMOeOjg=;
        h=Date:To:From:Subject:From;
        b=NVDYXOtRiQPRIilP5zdAzk+knCkz+6HUg1UjW4GQuGOtpdjWKUpE1aquKV55TjLMG
         fZ/VNimvkoeFot+nWBjwM5GtdNCRUasF1rK99fOsrcEvPDA1rzJZAQrZQ/Lh4aPLzs
         K/3og1tEXVc1Gy94Raphoq9+0x7Ew0+BWBn05xtc=
Date:   Thu, 19 Jan 2023 14:32:33 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, sidhartha.kumar@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-alloc_huge_page-to-alloc_hugetlb_folio.patch added to mm-unstable branch
Message-Id: <20230119223233.B6E35C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: convert alloc_huge_page to alloc_hugetlb_folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-convert-alloc_huge_page-to-alloc_hugetlb_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-alloc_huge_page-to-alloc_hugetlb_folio.patch

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
Subject: mm/hugetlb: convert alloc_huge_page to alloc_hugetlb_folio
Date: Thu, 19 Jan 2023 13:14:42 -0800

Change alloc_huge_page() to alloc_hugetlb_folio() by changing all callers
to handle the now folio return type of the function.  In this conversion,
alloc_huge_page_vma() is also changed to alloc_hugetlb_folio_vma().  Many
additions of the use of &folio->page are cleaned up in subsequent patches.

Link: https://lkml.kernel.org/r/20230119211446.54165-6-sidhartha.kumar@oracle.com
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/hugetlbfs/inode.c~mm-hugetlb-convert-alloc_huge_page-to-alloc_hugetlb_folio
+++ a/fs/hugetlbfs/inode.c
@@ -819,7 +819,7 @@ static long hugetlbfs_fallocate(struct f
 		 * This is supposed to be the vaddr where the page is being
 		 * faulted in, but we have no vaddr here.
 		 */
-		struct page *page;
+		struct folio *folio;
 		unsigned long addr;
 
 		cond_resched();
@@ -844,48 +844,48 @@ static long hugetlbfs_fallocate(struct f
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 		/* See if already present in mapping to avoid alloc/free */
-		page = find_get_page(mapping, index);
-		if (page) {
-			put_page(page);
+		folio = filemap_get_folio(mapping, index);
+		if (folio) {
+			folio_put(folio);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			hugetlb_drop_vma_policy(&pseudo_vma);
 			continue;
 		}
 
 		/*
-		 * Allocate page without setting the avoid_reserve argument.
+		 * Allocate folio without setting the avoid_reserve argument.
 		 * There certainly are no reserves associated with the
 		 * pseudo_vma.  However, there could be shared mappings with
 		 * reserves for the file at the inode level.  If we fallocate
-		 * pages in these areas, we need to consume the reserves
+		 * folios in these areas, we need to consume the reserves
 		 * to keep reservation accounting consistent.
 		 */
-		page = alloc_huge_page(&pseudo_vma, addr, 0);
+		folio = alloc_hugetlb_folio(&pseudo_vma, addr, 0);
 		hugetlb_drop_vma_policy(&pseudo_vma);
-		if (IS_ERR(page)) {
+		if (IS_ERR(folio)) {
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
-			error = PTR_ERR(page);
+			error = PTR_ERR(folio);
 			goto out;
 		}
-		clear_huge_page(page, addr, pages_per_huge_page(h));
-		__SetPageUptodate(page);
-		error = hugetlb_add_to_page_cache(page, mapping, index);
+		clear_huge_page(&folio->page, addr, pages_per_huge_page(h));
+		__folio_mark_uptodate(folio);
+		error = hugetlb_add_to_page_cache(&folio->page, mapping, index);
 		if (unlikely(error)) {
-			restore_reserve_on_error(h, &pseudo_vma, addr, page);
-			put_page(page);
+			restore_reserve_on_error(h, &pseudo_vma, addr, &folio->page);
+			folio_put(folio);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			goto out;
 		}
 
 		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 
-		SetHPageMigratable(page);
+		folio_set_hugetlb_migratable(folio);
 		/*
-		 * unlock_page because locked by hugetlb_add_to_page_cache()
-		 * put_page() due to reference from alloc_huge_page()
+		 * folio_unlock because locked by hugetlb_add_to_page_cache()
+		 * folio_put() due to reference from alloc_hugetlb_folio()
 		 */
-		unlock_page(page);
-		put_page(page);
+		folio_unlock(folio);
+		folio_put(folio);
 	}
 
 	if (!(mode & FALLOC_FL_KEEP_SIZE) && offset + len > inode->i_size)
--- a/include/linux/hugetlb.h~mm-hugetlb-convert-alloc_huge_page-to-alloc_hugetlb_folio
+++ a/include/linux/hugetlb.h
@@ -716,11 +716,11 @@ struct huge_bootmem_page {
 };
 
 int isolate_or_dissolve_huge_page(struct page *page, struct list_head *list);
-struct page *alloc_huge_page(struct vm_area_struct *vma,
+struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				unsigned long addr, int avoid_reserve);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask, gfp_t gfp_mask);
-struct page *alloc_huge_page_vma(struct hstate *h, struct vm_area_struct *vma,
+struct folio *alloc_hugetlb_folio_vma(struct hstate *h, struct vm_area_struct *vma,
 				unsigned long address);
 int hugetlb_add_to_page_cache(struct page *page, struct address_space *mapping,
 			pgoff_t idx);
@@ -1032,7 +1032,7 @@ static inline int isolate_or_dissolve_hu
 	return -ENOMEM;
 }
 
-static inline struct page *alloc_huge_page(struct vm_area_struct *vma,
+static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 					   unsigned long addr,
 					   int avoid_reserve)
 {
@@ -1046,7 +1046,7 @@ alloc_hugetlb_folio_nodemask(struct hsta
 	return NULL;
 }
 
-static inline struct page *alloc_huge_page_vma(struct hstate *h,
+static inline struct folio *alloc_hugetlb_folio_vma(struct hstate *h,
 					       struct vm_area_struct *vma,
 					       unsigned long address)
 {
--- a/mm/hugetlb.c~mm-hugetlb-convert-alloc_huge_page-to-alloc_hugetlb_folio
+++ a/mm/hugetlb.c
@@ -2493,7 +2493,7 @@ struct folio *alloc_hugetlb_folio_nodema
 }
 
 /* mempolicy aware migration callback */
-struct page *alloc_huge_page_vma(struct hstate *h, struct vm_area_struct *vma,
+struct folio *alloc_hugetlb_folio_vma(struct hstate *h, struct vm_area_struct *vma,
 		unsigned long address)
 {
 	struct mempolicy *mpol;
@@ -2507,7 +2507,7 @@ struct page *alloc_huge_page_vma(struct
 	folio = alloc_hugetlb_folio_nodemask(h, node, nodemask, gfp_mask);
 	mpol_cond_put(mpol);
 
-	return &folio->page;
+	return folio;
 }
 
 /*
@@ -2798,14 +2798,14 @@ static long vma_del_reservation(struct h
 
 /*
  * This routine is called to restore reservation information on error paths.
- * It should ONLY be called for pages allocated via alloc_huge_page(), and
- * the hugetlb mutex should remain held when calling this routine.
+ * It should ONLY be called for folios allocated via alloc_hugetlb_folio(),
+ * and the hugetlb mutex should remain held when calling this routine.
  *
  * It handles two specific cases:
  * 1) A reservation was in place and the page consumed the reservation.
  *    HPageRestoreReserve is set in the page.
  * 2) No reservation was in place for the page, so HPageRestoreReserve is
- *    not set.  However, alloc_huge_page always updates the reserve map.
+ *    not set.  However, alloc_hugetlb_folio always updates the reserve map.
  *
  * In case 1, free_huge_page later in the error path will increment the
  * global reserve count.  But, free_huge_page does not have enough context
@@ -2814,7 +2814,7 @@ static long vma_del_reservation(struct h
  * reserve count adjustments to be made by free_huge_page.  Make sure the
  * reserve map indicates there is a reservation present.
  *
- * In case 2, simply undo reserve map modifications done by alloc_huge_page.
+ * In case 2, simply undo reserve map modifications done by alloc_hugetlb_folio.
  */
 void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
 			unsigned long address, struct page *page)
@@ -2844,8 +2844,8 @@ void restore_reserve_on_error(struct hst
 		if (!rc) {
 			/*
 			 * This indicates there is an entry in the reserve map
-			 * not added by alloc_huge_page.  We know it was added
-			 * before the alloc_huge_page call, otherwise
+			 * not added by alloc_hugetlb_folio.  We know it was added
+			 * before the alloc_hugetlb_folio call, otherwise
 			 * hugetlb_restore_reserve would be set on the folio.
 			 * Remove the entry so that a subsequent allocation
 			 * does not consume a reservation.
@@ -3014,7 +3014,7 @@ int isolate_or_dissolve_huge_page(struct
 	return ret;
 }
 
-struct page *alloc_huge_page(struct vm_area_struct *vma,
+struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 				    unsigned long addr, int avoid_reserve)
 {
 	struct hugepage_subpool *spool = subpool_vma(vma);
@@ -3130,7 +3130,7 @@ struct page *alloc_huge_page(struct vm_a
 			hugetlb_cgroup_uncharge_folio_rsvd(hstate_index(h),
 					pages_per_huge_page(h), folio);
 	}
-	return &folio->page;
+	return folio;
 
 out_uncharge_cgroup:
 	hugetlb_cgroup_uncharge_cgroup(idx, pages_per_huge_page(h), h_cg);
@@ -5080,34 +5080,34 @@ again:
 			} else if (page_try_dup_anon_rmap(ptepage, true,
 							  src_vma)) {
 				pte_t src_pte_old = entry;
-				struct page *new;
+				struct folio *new_folio;
 
 				spin_unlock(src_ptl);
 				spin_unlock(dst_ptl);
 				/* Do not use reserve as it's private owned */
-				new = alloc_huge_page(dst_vma, addr, 1);
-				if (IS_ERR(new)) {
+				new_folio = alloc_hugetlb_folio(dst_vma, addr, 1);
+				if (IS_ERR(new_folio)) {
 					put_page(ptepage);
-					ret = PTR_ERR(new);
+					ret = PTR_ERR(new_folio);
 					break;
 				}
-				copy_user_huge_page(new, ptepage, addr, dst_vma,
+				copy_user_huge_page(&new_folio->page, ptepage, addr, dst_vma,
 						    npages);
 				put_page(ptepage);
 
-				/* Install the new huge page if src pte stable */
+				/* Install the new hugetlb folio if src pte stable */
 				dst_ptl = huge_pte_lock(h, dst, dst_pte);
 				src_ptl = huge_pte_lockptr(h, src, src_pte);
 				spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
 				entry = huge_ptep_get(src_pte);
 				if (!pte_same(src_pte_old, entry)) {
 					restore_reserve_on_error(h, dst_vma, addr,
-								new);
-					put_page(new);
+								&new_folio->page);
+					folio_put(new_folio);
 					/* huge_ptep of dst_pte won't change as in child */
 					goto again;
 				}
-				hugetlb_install_folio(dst_vma, dst_pte, addr, page_folio(new));
+				hugetlb_install_folio(dst_vma, dst_pte, addr, new_folio);
 				spin_unlock(src_ptl);
 				spin_unlock(dst_ptl);
 				continue;
@@ -5478,8 +5478,8 @@ static vm_fault_t hugetlb_wp(struct mm_s
 	const bool unshare = flags & FAULT_FLAG_UNSHARE;
 	pte_t pte;
 	struct hstate *h = hstate_vma(vma);
-	struct page *old_page, *new_page;
-	struct folio *new_folio = NULL;
+	struct page *old_page;
+	struct folio *new_folio;
 	int outside_reserve = 0;
 	vm_fault_t ret = 0;
 	unsigned long haddr = address & huge_page_mask(h);
@@ -5540,9 +5540,9 @@ retry_avoidcopy:
 	 * be acquired again before returning to the caller, as expected.
 	 */
 	spin_unlock(ptl);
-	new_page = alloc_huge_page(vma, haddr, outside_reserve);
+	new_folio = alloc_hugetlb_folio(vma, haddr, outside_reserve);
 
-	if (IS_ERR(new_page)) {
+	if (IS_ERR(new_folio)) {
 		/*
 		 * If a process owning a MAP_PRIVATE mapping fails to COW,
 		 * it is due to references held by a child and an insufficient
@@ -5587,13 +5587,9 @@ retry_avoidcopy:
 			return 0;
 		}
 
-		ret = vmf_error(PTR_ERR(new_page));
+		ret = vmf_error(PTR_ERR(new_folio));
 		goto out_release_old;
 	}
-
-	if (new_page)
-		new_folio = page_folio(new_page);
-
 	/*
 	 * When the original hugepage is shared one, it does not have
 	 * anon_vma prepared.
@@ -5627,7 +5623,7 @@ retry_avoidcopy:
 				make_huge_pte(vma, &new_folio->page, !unshare));
 		folio_set_hugetlb_migratable(new_folio);
 		/* Make the old page be freed below */
-		new_page = old_page;
+		new_folio = page_folio(old_page);
 	}
 	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(&range);
@@ -5636,7 +5632,7 @@ out_release_all:
 	 * No restore in case of successful pagetable update (Break COW or
 	 * unshare)
 	 */
-	if (new_page != old_page)
+	if (new_folio != page_folio(old_page))
 		restore_reserve_on_error(h, vma, haddr, &new_folio->page);
 	folio_put(new_folio);
 out_release_old:
@@ -5759,8 +5755,7 @@ static vm_fault_t hugetlb_no_page(struct
 	vm_fault_t ret = VM_FAULT_SIGBUS;
 	int anon_rmap = 0;
 	unsigned long size;
-	struct page *page;
-	struct folio *folio = NULL;
+	struct folio *folio;
 	pte_t new_pte;
 	spinlock_t *ptl;
 	unsigned long haddr = address & huge_page_mask(h);
@@ -5784,8 +5779,8 @@ static vm_fault_t hugetlb_no_page(struct
 	 * before we get page_table_lock.
 	 */
 	new_page = false;
-	page = find_lock_page(mapping, idx);
-	if (!page) {
+	folio = filemap_lock_folio(mapping, idx);
+	if (!folio) {
 		size = i_size_read(mapping->host) >> huge_page_shift(h);
 		if (idx >= size)
 			goto out;
@@ -5818,8 +5813,8 @@ static vm_fault_t hugetlb_no_page(struct
 							VM_UFFD_MISSING);
 		}
 
-		page = alloc_huge_page(vma, haddr, 0);
-		if (IS_ERR(page)) {
+		folio = alloc_hugetlb_folio(vma, haddr, 0);
+		if (IS_ERR(folio)) {
 			/*
 			 * Returning error will result in faulting task being
 			 * sent SIGBUS.  The hugetlb fault mutex prevents two
@@ -5833,15 +5828,11 @@ static vm_fault_t hugetlb_no_page(struct
 			 * sure there really is no pte entry.
 			 */
 			if (hugetlb_pte_stable(h, mm, ptep, old_pte))
-				ret = vmf_error(PTR_ERR(page));
+				ret = vmf_error(PTR_ERR(folio));
 			else
 				ret = 0;
 			goto out;
 		}
-
-		if (page)
-			folio = page_folio(page);
-
 		clear_huge_page(&folio->page, address, pages_per_huge_page(h));
 		__folio_mark_uptodate(folio);
 		new_page = true;
@@ -5870,7 +5861,6 @@ static vm_fault_t hugetlb_no_page(struct
 			anon_rmap = 1;
 		}
 	} else {
-		folio = page_folio(page);
 		/*
 		 * If memory error occurs between mmap() and fault, some process
 		 * don't have hwpoisoned swap entry for errored virtual address.
@@ -6185,15 +6175,14 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 	pte_t _dst_pte;
 	spinlock_t *ptl;
 	int ret = -ENOMEM;
-	struct page *page;
-	struct folio *folio = NULL;
+	struct folio *folio;
 	int writable;
 	bool page_in_pagecache = false;
 
 	if (is_continue) {
 		ret = -EFAULT;
-		page = find_lock_page(mapping, idx);
-		if (!page)
+		folio = filemap_lock_folio(mapping, idx);
+		if (!folio)
 			goto out;
 		page_in_pagecache = true;
 	} else if (!*pagep) {
@@ -6206,34 +6195,34 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 			goto out;
 		}
 
-		page = alloc_huge_page(dst_vma, dst_addr, 0);
-		if (IS_ERR(page)) {
+		folio = alloc_hugetlb_folio(dst_vma, dst_addr, 0);
+		if (IS_ERR(folio)) {
 			ret = -ENOMEM;
 			goto out;
 		}
 
-		ret = copy_huge_page_from_user(page,
+		ret = copy_huge_page_from_user(&folio->page,
 						(const void __user *) src_addr,
 						pages_per_huge_page(h), false);
 
 		/* fallback to copy_from_user outside mmap_lock */
 		if (unlikely(ret)) {
 			ret = -ENOENT;
-			/* Free the allocated page which may have
+			/* Free the allocated folio which may have
 			 * consumed a reservation.
 			 */
-			restore_reserve_on_error(h, dst_vma, dst_addr, page);
-			put_page(page);
+			restore_reserve_on_error(h, dst_vma, dst_addr, &folio->page);
+			folio_put(folio);
 
-			/* Allocate a temporary page to hold the copied
+			/* Allocate a temporary folio to hold the copied
 			 * contents.
 			 */
-			page = alloc_huge_page_vma(h, dst_vma, dst_addr);
-			if (!page) {
+			folio = alloc_hugetlb_folio_vma(h, dst_vma, dst_addr);
+			if (!folio) {
 				ret = -ENOMEM;
 				goto out;
 			}
-			*pagep = page;
+			*pagep = &folio->page;
 			/* Set the outparam pagep and return to the caller to
 			 * copy the contents outside the lock. Don't free the
 			 * page.
@@ -6249,22 +6238,18 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 			goto out;
 		}
 
-		page = alloc_huge_page(dst_vma, dst_addr, 0);
-		if (IS_ERR(page)) {
+		folio = alloc_hugetlb_folio(dst_vma, dst_addr, 0);
+		if (IS_ERR(folio)) {
 			put_page(*pagep);
 			ret = -ENOMEM;
 			*pagep = NULL;
 			goto out;
 		}
-		copy_user_huge_page(page, *pagep, dst_addr, dst_vma,
+		copy_user_huge_page(&folio->page, *pagep, dst_addr, dst_vma,
 				    pages_per_huge_page(h));
 		put_page(*pagep);
 		*pagep = NULL;
 	}
-
-	if (page)
-		folio = page_folio(page);
-
 	/*
 	 * The memory barrier inside __folio_mark_uptodate makes sure that
 	 * preceding stores to the page contents become visible before
@@ -6887,7 +6872,7 @@ bool hugetlb_reserve_pages(struct inode
 			/*
 			 * pages in this range were added to the reserve
 			 * map between region_chg and region_add.  This
-			 * indicates a race with alloc_huge_page.  Adjust
+			 * indicates a race with alloc_hugetlb_folio.  Adjust
 			 * the subpool and reserve counts modified above
 			 * based on the difference.
 			 */
--- a/mm/mempolicy.c~mm-hugetlb-convert-alloc_huge_page-to-alloc_hugetlb_folio
+++ a/mm/mempolicy.c
@@ -1218,9 +1218,11 @@ static struct page *new_page(struct page
 			break;
 	}
 
-	if (folio_test_hugetlb(src))
-		return alloc_huge_page_vma(page_hstate(&src->page),
+	if (folio_test_hugetlb(src)) {
+		dst = alloc_hugetlb_folio_vma(folio_hstate(src),
 				vma, address);
+		return &dst->page;
+	}
 
 	if (folio_test_large(src))
 		gfp = GFP_TRANSHUGE;
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

