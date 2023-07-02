Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDBCFEB64D9
	for <mm-commits@archiver.kernel.org>; Sun,  2 Jul 2023 19:58:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbjGBT6t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 Jul 2023 15:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233251AbjGBT57 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 2 Jul 2023 15:57:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDC31FDA
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 12:55:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF82460C94
        for <mm-commits@vger.kernel.org>; Sun,  2 Jul 2023 19:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1868AC433C8;
        Sun,  2 Jul 2023 19:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688327703;
        bh=/91IFK1GDSU/PqEf2h3gBfeO9ByQ20prYe3p1Jdj9Jw=;
        h=Date:To:From:Subject:From;
        b=qkfbZ2wNSWBAjtmRWNicr50n7zKaCqhtqXLZZ3IPzXY+c54cwZlnVRNOgC+MMO5Bh
         P70j/Ku/u06suOuI+tqHBt6H9NfPrag6pl5mg69BYIcI1QhicEhGKD09sQki5Vlf5h
         PizFIMI4/VAPXxy2c83bt5Xa/Y61MM1F/znFfxRI=
Date:   Sun, 02 Jul 2023 12:55:02 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, rppt@kernel.org, mike.kravetz@oracle.com,
        lstoakes@gmail.com, kirill@shutemov.name, jthoughton@google.com,
        jhubbard@nvidia.com, jgg@nvidia.com, hughd@google.com,
        david@redhat.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-retire-follow_hugetlb_page.patch added to mm-unstable branch
Message-Id: <20230702195503.1868AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: retire follow_hugetlb_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-retire-follow_hugetlb_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-retire-follow_hugetlb_page.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/gup: retire follow_hugetlb_page()
Date: Wed, 28 Jun 2023 17:53:08 -0400

Now __get_user_pages() should be well prepared to handle thp completely,
as long as hugetlb gup requests even without the hugetlb's special path.

Time to retire follow_hugetlb_page().

Tweak misc comments to reflect reality of follow_hugetlb_page()'s removal.

Link: https://lkml.kernel.org/r/20230628215310.73782-7-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A . Shutemov <kirill@shutemov.name>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c        |    2 
 include/linux/hugetlb.h |   12 --
 mm/gup.c                |   19 ---
 mm/hugetlb.c            |  224 --------------------------------------
 4 files changed, 1 insertion(+), 256 deletions(-)

--- a/fs/userfaultfd.c~mm-gup-retire-follow_hugetlb_page
+++ a/fs/userfaultfd.c
@@ -424,7 +424,7 @@ vm_fault_t handle_userfault(struct vm_fa
 	 *
 	 * We also don't do userfault handling during
 	 * coredumping. hugetlbfs has the special
-	 * follow_hugetlb_page() to skip missing pages in the
+	 * hugetlb_follow_page_mask() to skip missing pages in the
 	 * FOLL_DUMP case, anon memory also checks for FOLL_DUMP with
 	 * the no_page_table() helper in follow_page_mask(), but the
 	 * shmem_vm_ops->fault method is invoked even during
--- a/include/linux/hugetlb.h~mm-gup-retire-follow_hugetlb_page
+++ a/include/linux/hugetlb.h
@@ -133,9 +133,6 @@ int copy_hugetlb_page_range(struct mm_st
 struct page *hugetlb_follow_page_mask(struct vm_area_struct *vma,
 				      unsigned long address, unsigned int flags,
 				      unsigned int *page_mask);
-long follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *,
-			 struct page **, unsigned long *, unsigned long *,
-			 long, unsigned int, int *);
 void unmap_hugepage_range(struct vm_area_struct *,
 			  unsigned long, unsigned long, struct page *,
 			  zap_flags_t);
@@ -305,15 +302,6 @@ static inline struct page *hugetlb_follo
 	BUILD_BUG(); /* should never be compiled in if !CONFIG_HUGETLB_PAGE*/
 }
 
-static inline long follow_hugetlb_page(struct mm_struct *mm,
-			struct vm_area_struct *vma, struct page **pages,
-			unsigned long *position, unsigned long *nr_pages,
-			long i, unsigned int flags, int *nonblocking)
-{
-	BUG();
-	return 0;
-}
-
 static inline int copy_hugetlb_page_range(struct mm_struct *dst,
 					  struct mm_struct *src,
 					  struct vm_area_struct *dst_vma,
--- a/mm/gup.c~mm-gup-retire-follow_hugetlb_page
+++ a/mm/gup.c
@@ -819,9 +819,6 @@ static struct page *follow_page_mask(str
 	 * Call hugetlb_follow_page_mask for hugetlb vmas as it will use
 	 * special hugetlb page table walking code.  This eliminates the
 	 * need to check for hugetlb entries in the general walking code.
-	 *
-	 * hugetlb_follow_page_mask is only for follow_page() handling here.
-	 * Ordinary GUP uses follow_hugetlb_page for hugetlb processing.
 	 */
 	if (is_vm_hugetlb_page(vma))
 		return hugetlb_follow_page_mask(vma, address, flags,
@@ -1186,22 +1183,6 @@ static long __get_user_pages(struct mm_s
 			ret = check_vma_flags(vma, gup_flags);
 			if (ret)
 				goto out;
-
-			if (is_vm_hugetlb_page(vma)) {
-				i = follow_hugetlb_page(mm, vma, pages,
-							&start, &nr_pages, i,
-							gup_flags, locked);
-				if (!*locked) {
-					/*
-					 * We've got a VM_FAULT_RETRY
-					 * and we've lost mmap_lock.
-					 * We must stop here.
-					 */
-					BUG_ON(gup_flags & FOLL_NOWAIT);
-					goto out;
-				}
-				continue;
-			}
 		}
 retry:
 		/*
--- a/mm/hugetlb.c~mm-gup-retire-follow_hugetlb_page
+++ a/mm/hugetlb.c
@@ -5721,7 +5721,6 @@ out_release_old:
 
 /*
  * Return whether there is a pagecache page to back given address within VMA.
- * Caller follow_hugetlb_page() holds page_table_lock so we cannot lock_page.
  */
 static bool hugetlbfs_pagecache_present(struct hstate *h,
 			struct vm_area_struct *vma, unsigned long address)
@@ -6422,37 +6421,6 @@ out_release_nounlock:
 }
 #endif /* CONFIG_USERFAULTFD */
 
-static void record_subpages(struct page *page, struct vm_area_struct *vma,
-			    int refs, struct page **pages)
-{
-	int nr;
-
-	for (nr = 0; nr < refs; nr++) {
-		if (likely(pages))
-			pages[nr] = nth_page(page, nr);
-	}
-}
-
-static inline bool __follow_hugetlb_must_fault(struct vm_area_struct *vma,
-					       unsigned int flags, pte_t *pte,
-					       bool *unshare)
-{
-	pte_t pteval = huge_ptep_get(pte);
-
-	*unshare = false;
-	if (is_swap_pte(pteval))
-		return true;
-	if (huge_pte_write(pteval))
-		return false;
-	if (flags & FOLL_WRITE)
-		return true;
-	if (gup_must_unshare(vma, flags, pte_page(pteval))) {
-		*unshare = true;
-		return true;
-	}
-	return false;
-}
-
 struct page *hugetlb_follow_page_mask(struct vm_area_struct *vma,
 				      unsigned long address, unsigned int flags,
 				      unsigned int *page_mask)
@@ -6524,198 +6492,6 @@ out_unlock:
 	return page;
 }
 
-long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
-			 struct page **pages, unsigned long *position,
-			 unsigned long *nr_pages, long i, unsigned int flags,
-			 int *locked)
-{
-	unsigned long pfn_offset;
-	unsigned long vaddr = *position;
-	unsigned long remainder = *nr_pages;
-	struct hstate *h = hstate_vma(vma);
-	int err = -EFAULT, refs;
-
-	while (vaddr < vma->vm_end && remainder) {
-		pte_t *pte;
-		spinlock_t *ptl = NULL;
-		bool unshare = false;
-		int absent;
-		struct page *page;
-
-		/*
-		 * If we have a pending SIGKILL, don't keep faulting pages and
-		 * potentially allocating memory.
-		 */
-		if (fatal_signal_pending(current)) {
-			remainder = 0;
-			break;
-		}
-
-		hugetlb_vma_lock_read(vma);
-		/*
-		 * Some archs (sparc64, sh*) have multiple pte_ts to
-		 * each hugepage.  We have to make sure we get the
-		 * first, for the page indexing below to work.
-		 *
-		 * Note that page table lock is not held when pte is null.
-		 */
-		pte = hugetlb_walk(vma, vaddr & huge_page_mask(h),
-				   huge_page_size(h));
-		if (pte)
-			ptl = huge_pte_lock(h, mm, pte);
-		absent = !pte || huge_pte_none(huge_ptep_get(pte));
-
-		/*
-		 * When coredumping, it suits get_dump_page if we just return
-		 * an error where there's an empty slot with no huge pagecache
-		 * to back it.  This way, we avoid allocating a hugepage, and
-		 * the sparse dumpfile avoids allocating disk blocks, but its
-		 * huge holes still show up with zeroes where they need to be.
-		 */
-		if (absent && (flags & FOLL_DUMP) &&
-		    !hugetlbfs_pagecache_present(h, vma, vaddr)) {
-			if (pte)
-				spin_unlock(ptl);
-			hugetlb_vma_unlock_read(vma);
-			remainder = 0;
-			break;
-		}
-
-		/*
-		 * We need call hugetlb_fault for both hugepages under migration
-		 * (in which case hugetlb_fault waits for the migration,) and
-		 * hwpoisoned hugepages (in which case we need to prevent the
-		 * caller from accessing to them.) In order to do this, we use
-		 * here is_swap_pte instead of is_hugetlb_entry_migration and
-		 * is_hugetlb_entry_hwpoisoned. This is because it simply covers
-		 * both cases, and because we can't follow correct pages
-		 * directly from any kind of swap entries.
-		 */
-		if (absent ||
-		    __follow_hugetlb_must_fault(vma, flags, pte, &unshare)) {
-			vm_fault_t ret;
-			unsigned int fault_flags = 0;
-
-			if (pte)
-				spin_unlock(ptl);
-			hugetlb_vma_unlock_read(vma);
-
-			if (flags & FOLL_WRITE)
-				fault_flags |= FAULT_FLAG_WRITE;
-			else if (unshare)
-				fault_flags |= FAULT_FLAG_UNSHARE;
-			if (locked) {
-				fault_flags |= FAULT_FLAG_ALLOW_RETRY |
-					FAULT_FLAG_KILLABLE;
-				if (flags & FOLL_INTERRUPTIBLE)
-					fault_flags |= FAULT_FLAG_INTERRUPTIBLE;
-			}
-			if (flags & FOLL_NOWAIT)
-				fault_flags |= FAULT_FLAG_ALLOW_RETRY |
-					FAULT_FLAG_RETRY_NOWAIT;
-			if (flags & FOLL_TRIED) {
-				/*
-				 * Note: FAULT_FLAG_ALLOW_RETRY and
-				 * FAULT_FLAG_TRIED can co-exist
-				 */
-				fault_flags |= FAULT_FLAG_TRIED;
-			}
-			ret = hugetlb_fault(mm, vma, vaddr, fault_flags);
-			if (ret & VM_FAULT_ERROR) {
-				err = vm_fault_to_errno(ret, flags);
-				remainder = 0;
-				break;
-			}
-			if (ret & VM_FAULT_RETRY) {
-				if (locked &&
-				    !(fault_flags & FAULT_FLAG_RETRY_NOWAIT))
-					*locked = 0;
-				*nr_pages = 0;
-				/*
-				 * VM_FAULT_RETRY must not return an
-				 * error, it will return zero
-				 * instead.
-				 *
-				 * No need to update "position" as the
-				 * caller will not check it after
-				 * *nr_pages is set to 0.
-				 */
-				return i;
-			}
-			continue;
-		}
-
-		pfn_offset = (vaddr & ~huge_page_mask(h)) >> PAGE_SHIFT;
-		page = pte_page(huge_ptep_get(pte));
-
-		VM_BUG_ON_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
-			       !PageAnonExclusive(page), page);
-
-		/*
-		 * If subpage information not requested, update counters
-		 * and skip the same_page loop below.
-		 */
-		if (!pages && !pfn_offset &&
-		    (vaddr + huge_page_size(h) < vma->vm_end) &&
-		    (remainder >= pages_per_huge_page(h))) {
-			vaddr += huge_page_size(h);
-			remainder -= pages_per_huge_page(h);
-			i += pages_per_huge_page(h);
-			spin_unlock(ptl);
-			hugetlb_vma_unlock_read(vma);
-			continue;
-		}
-
-		/* vaddr may not be aligned to PAGE_SIZE */
-		refs = min3(pages_per_huge_page(h) - pfn_offset, remainder,
-		    (vma->vm_end - ALIGN_DOWN(vaddr, PAGE_SIZE)) >> PAGE_SHIFT);
-
-		if (pages)
-			record_subpages(nth_page(page, pfn_offset),
-					vma, refs,
-					likely(pages) ? pages + i : NULL);
-
-		if (pages) {
-			/*
-			 * try_grab_folio() should always succeed here,
-			 * because: a) we hold the ptl lock, and b) we've just
-			 * checked that the huge page is present in the page
-			 * tables. If the huge page is present, then the tail
-			 * pages must also be present. The ptl prevents the
-			 * head page and tail pages from being rearranged in
-			 * any way. As this is hugetlb, the pages will never
-			 * be p2pdma or not longterm pinable. So this page
-			 * must be available at this point, unless the page
-			 * refcount overflowed:
-			 */
-			if (WARN_ON_ONCE(!try_grab_folio(pages[i], refs,
-							 flags))) {
-				spin_unlock(ptl);
-				hugetlb_vma_unlock_read(vma);
-				remainder = 0;
-				err = -ENOMEM;
-				break;
-			}
-		}
-
-		vaddr += (refs << PAGE_SHIFT);
-		remainder -= refs;
-		i += refs;
-
-		spin_unlock(ptl);
-		hugetlb_vma_unlock_read(vma);
-	}
-	*nr_pages = remainder;
-	/*
-	 * setting position is actually required only if remainder is
-	 * not zero but it's faster not to add a "if (remainder)"
-	 * branch.
-	 */
-	*position = vaddr;
-
-	return i ? i : err;
-}
-
 long hugetlb_change_protection(struct vm_area_struct *vma,
 		unsigned long address, unsigned long end,
 		pgprot_t newprot, unsigned long cp_flags)
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-handle-foll_dump-well-in-follow_page_mask.patch
mm-hugetlb-prepare-hugetlb_follow_page_mask-for-foll_pin.patch
mm-hugetlb-add-page_mask-for-hugetlb_follow_page_mask.patch
mm-gup-cleanup-next_page-handling.patch
mm-gup-accelerate-thp-gup-even-for-pages-=-null.patch
mm-gup-retire-follow_hugetlb_page.patch
selftests-mm-add-a-to-run_vmtestssh.patch
selftests-mm-add-gup-test-matrix-in-run_vmtestssh.patch

