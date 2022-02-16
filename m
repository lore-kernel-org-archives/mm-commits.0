Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5483BC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 16 Feb 2022 00:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245115AbiBPAaY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 19:30:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234692AbiBPAaR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 19:30:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98207F956A
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 16:30:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49581B81C01
        for <mm-commits@vger.kernel.org>; Wed, 16 Feb 2022 00:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019FDC340EB;
        Wed, 16 Feb 2022 00:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644971404;
        bh=plTPlCw0yVcMbCHIQnFcNahSbeFH+ZkBhL/FYKtnVz8=;
        h=Date:To:From:Subject:From;
        b=Pas5F0qTXaj2R/V0uZlUQ5tP4p2VmgnAxP0f+4bBVCLZU0dH0bCHWWPDqrOtIRf3U
         HzFJJrKX0jDpWY6eFrJiwNosXjlQCJlNDn00GPj0gUVCGVqKCU5eimAgq62GyxJkbK
         iiNY2zgkS/0r7eedpr7O/KAGzrofPdmqKt8NqbNE=
Date:   Tue, 15 Feb 2022 16:30:03 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, surenb@google.com, shakeelb@google.com,
        riel@surriel.com, mhocko@suse.com, kirill@shutemov.name,
        hannes@cmpxchg.org, gthelen@google.com, david@redhat.com,
        apopple@nvidia.com, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-munlock-delete-foll_mlock-and-foll_populate.patch added to -mm tree
Message-Id: <20220216003004.019FDC340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/munlock: delete FOLL_MLOCK and FOLL_POPULATE
has been added to the -mm tree.  Its filename is
     mm-munlock-delete-foll_mlock-and-foll_populate.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-munlock-delete-foll_mlock-and-foll_populate.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-munlock-delete-foll_mlock-and-foll_populate.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/munlock: delete FOLL_MLOCK and FOLL_POPULATE

If counting page mlocks, we must not double-count: follow_page_pte() can
tell if a page has already been Mlocked or not, but cannot tell if a pte
has already been counted or not: that will have to be done when the pte is
mapped in (which lru_cache_add_inactive_or_unevictable() already tracks
for new anon pages, but there's no such tracking yet for others).

Delete all the FOLL_MLOCK code - faulting in the missing pages will do all
that is necessary, without special mlock_vma_page() calls from here.

But then FOLL_POPULATE turns out to serve no purpose - it was there so
that its absence would tell faultin_page() not to faultin page when
setting up VM_LOCKONFAULT areas; but if there's no special work needed
here for mlock, then there's no work at all here for VM_LOCKONFAULT.

Have I got that right?  I've not looked into the history, but see that
FOLL_POPULATE goes back before VM_LOCKONFAULT: did it serve a different
purpose before?  Ah, yes, it was used to skip the old stack guard page.

And is it intentional that COW is not broken on existing pages when
setting up a VM_LOCKONFAULT area?  I can see that being argued either way,
and have no reason to disagree with current behaviour.

Link: https://lkml.kernel.org/r/cbed9c9f-1747-f06a-15ad-b2d9fb6025eb@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 --
 mm/gup.c           |   43 ++++++++-----------------------------------
 mm/huge_memory.c   |   33 ---------------------------------
 3 files changed, 8 insertions(+), 70 deletions(-)

--- a/include/linux/mm.h~mm-munlock-delete-foll_mlock-and-foll_populate
+++ a/include/linux/mm.h
@@ -2916,13 +2916,11 @@ struct page *follow_page(struct vm_area_
 #define FOLL_FORCE	0x10	/* get_user_pages read/write w/o permission */
 #define FOLL_NOWAIT	0x20	/* if a disk transfer is needed, start the IO
 				 * and return without waiting upon it */
-#define FOLL_POPULATE	0x40	/* fault in pages (with FOLL_MLOCK) */
 #define FOLL_NOFAULT	0x80	/* do not fault in pages */
 #define FOLL_HWPOISON	0x100	/* check page is hwpoisoned */
 #define FOLL_NUMA	0x200	/* force NUMA hinting page fault */
 #define FOLL_MIGRATION	0x400	/* wait for page to replace migration entry */
 #define FOLL_TRIED	0x800	/* a retry, previous pass started an IO */
-#define FOLL_MLOCK	0x1000	/* lock present pages */
 #define FOLL_REMOTE	0x2000	/* we are working on non-current tsk/mm */
 #define FOLL_COW	0x4000	/* internal GUP flag */
 #define FOLL_ANON	0x8000	/* don't do file mappings */
--- a/mm/gup.c~mm-munlock-delete-foll_mlock-and-foll_populate
+++ a/mm/gup.c
@@ -593,32 +593,6 @@ retry:
 		 */
 		mark_page_accessed(page);
 	}
-	if ((flags & FOLL_MLOCK) && (vma->vm_flags & VM_LOCKED)) {
-		/* Do not mlock pte-mapped THP */
-		if (PageTransCompound(page))
-			goto out;
-
-		/*
-		 * The preliminary mapping check is mainly to avoid the
-		 * pointless overhead of lock_page on the ZERO_PAGE
-		 * which might bounce very badly if there is contention.
-		 *
-		 * If the page is already locked, we don't need to
-		 * handle it now - vmscan will handle it later if and
-		 * when it attempts to reclaim the page.
-		 */
-		if (page->mapping && trylock_page(page)) {
-			lru_add_drain();  /* push cached pages to LRU */
-			/*
-			 * Because we lock page here, and migration is
-			 * blocked by the pte's page reference, and we
-			 * know the page is still mapped, we don't even
-			 * need to check for file-cache page truncation.
-			 */
-			mlock_vma_page(page);
-			unlock_page(page);
-		}
-	}
 out:
 	pte_unmap_unlock(ptep, ptl);
 	return page;
@@ -941,9 +915,6 @@ static int faultin_page(struct vm_area_s
 	unsigned int fault_flags = 0;
 	vm_fault_t ret;
 
-	/* mlock all present pages, but do not fault in new pages */
-	if ((*flags & (FOLL_POPULATE | FOLL_MLOCK)) == FOLL_MLOCK)
-		return -ENOENT;
 	if (*flags & FOLL_NOFAULT)
 		return -EFAULT;
 	if (*flags & FOLL_WRITE)
@@ -1194,8 +1165,6 @@ retry:
 			case -ENOMEM:
 			case -EHWPOISON:
 				goto out;
-			case -ENOENT:
-				goto next_page;
 			}
 			BUG();
 		} else if (PTR_ERR(page) == -EEXIST) {
@@ -1500,9 +1469,14 @@ long populate_vma_page_range(struct vm_a
 	VM_BUG_ON_VMA(end   > vma->vm_end, vma);
 	mmap_assert_locked(mm);
 
-	gup_flags = FOLL_TOUCH | FOLL_POPULATE | FOLL_MLOCK;
+	/*
+	 * Rightly or wrongly, the VM_LOCKONFAULT case has never used
+	 * faultin_page() to break COW, so it has no work to do here.
+	 */
 	if (vma->vm_flags & VM_LOCKONFAULT)
-		gup_flags &= ~FOLL_POPULATE;
+		return nr_pages;
+
+	gup_flags = FOLL_TOUCH;
 	/*
 	 * We want to touch writable mappings with a write fault in order
 	 * to break COW, except for shared mappings because these don't COW
@@ -1569,10 +1543,9 @@ long faultin_vma_page_range(struct vm_ar
 	 *	       in the page table.
 	 * FOLL_HWPOISON: Return -EHWPOISON instead of -EFAULT when we hit
 	 *		  a poisoned page.
-	 * FOLL_POPULATE: Always populate memory with VM_LOCKONFAULT.
 	 * !FOLL_FORCE: Require proper access permissions.
 	 */
-	gup_flags = FOLL_TOUCH | FOLL_POPULATE | FOLL_MLOCK | FOLL_HWPOISON;
+	gup_flags = FOLL_TOUCH | FOLL_HWPOISON;
 	if (write)
 		gup_flags |= FOLL_WRITE;
 
--- a/mm/huge_memory.c~mm-munlock-delete-foll_mlock-and-foll_populate
+++ a/mm/huge_memory.c
@@ -1389,39 +1389,6 @@ struct page *follow_trans_huge_pmd(struc
 	if (flags & FOLL_TOUCH)
 		touch_pmd(vma, addr, pmd, flags);
 
-	if ((flags & FOLL_MLOCK) && (vma->vm_flags & VM_LOCKED)) {
-		/*
-		 * We don't mlock() pte-mapped THPs. This way we can avoid
-		 * leaking mlocked pages into non-VM_LOCKED VMAs.
-		 *
-		 * For anon THP:
-		 *
-		 * In most cases the pmd is the only mapping of the page as we
-		 * break COW for the mlock() -- see gup_flags |= FOLL_WRITE for
-		 * writable private mappings in populate_vma_page_range().
-		 *
-		 * The only scenario when we have the page shared here is if we
-		 * mlocking read-only mapping shared over fork(). We skip
-		 * mlocking such pages.
-		 *
-		 * For file THP:
-		 *
-		 * We can expect PageDoubleMap() to be stable under page lock:
-		 * for file pages we set it in page_add_file_rmap(), which
-		 * requires page to be locked.
-		 */
-
-		if (PageAnon(page) && compound_mapcount(page) != 1)
-			goto skip_mlock;
-		if (PageDoubleMap(page) || !page->mapping)
-			goto skip_mlock;
-		if (!trylock_page(page))
-			goto skip_mlock;
-		if (page->mapping && !PageDoubleMap(page))
-			mlock_vma_page(page);
-		unlock_page(page);
-	}
-skip_mlock:
 	page += (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
 	VM_BUG_ON_PAGE(!PageCompound(page) && !is_zone_device_page(page), page);
 
_

Patches currently in -mm which might be from hughd@google.com are

mm-munlock-delete-page_mlock-and-all-its-works.patch
mm-munlock-delete-foll_mlock-and-foll_populate.patch
mm-munlock-delete-munlock_vma_pages_all-allow-oomreap.patch
mm-munlock-rmap-call-mlock_vma_page-munlock_vma_page.patch
mm-munlock-replace-clear_page_mlock-by-final-clearance.patch
mm-munlock-maintain-page-mlock_count-while-unevictable.patch
mm-munlock-mlock_pte_range-when-mlocking-or-munlocking.patch
mm-migrate-__unmap_and_move-push-good-newpage-to-lru.patch
mm-munlock-delete-smp_mb-from-__pagevec_lru_add_fn.patch
mm-munlock-mlock_page-munlock_page-batch-by-pagevec.patch
mm-munlock-page-migration-needs-mlock-pagevec-drained.patch
mm-thp-collapse_file-do-try_to_unmapttu_batch_flush.patch
mm-thp-shrink_page_list-avoid-splitting-vm_locked-thp.patch

