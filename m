Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C7AC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 31 Jan 2022 19:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377363AbiAaToB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 14:44:01 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:38266 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377403AbiAaTnz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 14:43:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E21FBCE13CD
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 19:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D50C340E8;
        Mon, 31 Jan 2022 19:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643658232;
        bh=n7LsqGG0QoyFsYZ+BK8atcZoxl19gawx31+t2i7BkL4=;
        h=Date:From:To:Subject:From;
        b=aIxAm07iLfUv5i2v0ovja1MyiF/vR6GBNk+fXrCv/RuBCM+p4SXseDlBmGwBhVqbJ
         L8fbm6pLcVZg7uHxiXffnYTftzeulbZy9OyeSt9IfpIK7A8IcV1H1PgT2Z21siNJ3+
         NGmBZIFacvZYE0G2EBojIEw8+UwxNetHyB/f1YCc=
Date:   Mon, 31 Jan 2022 11:43:50 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, david@redhat.com, ddutile@redhat.com,
        guro@fb.com, hch@lst.de, hughd@google.com, jack@suse.cz,
        jannh@google.com, jgg@nvidia.com, jhubbard@nvidia.com,
        kirill.shutemov@linux.intel.com, mhocko@kernel.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        nadav.amit@gmail.com, oleg@redhat.com, peterx@redhat.com,
        riel@surriel.com, rientjes@google.com, rppt@linux.ibm.com,
        shakeelb@google.com, shy828301@gmail.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org,
        zhangliang5@huawei.com
Subject:  +
 mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd.patch added
 to -mm tree
Message-ID: <20220131194350.mx2cEibZH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: remove stale locking logic from __split_huge_pmd()
has been added to the -mm tree.  Its filename is
     mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/huge_memory: remove stale locking logic from __split_huge_pmd()

Let's remove the stale logic that was required for reuse_swap_page().

Link: https://lkml.kernel.org/r/20220131162940.210846-10-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Liang Zhang <zhangliang5@huawei.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   32 +-------------------------------
 1 file changed, 1 insertion(+), 31 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd
+++ a/mm/huge_memory.c
@@ -2152,8 +2152,6 @@ void __split_huge_pmd(struct vm_area_str
 {
 	spinlock_t *ptl;
 	struct mmu_notifier_range range;
-	bool do_unlock_page = false;
-	pmd_t _pmd;
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
 				address & HPAGE_PMD_MASK,
@@ -2172,35 +2170,9 @@ void __split_huge_pmd(struct vm_area_str
 			goto out;
 	}
 
-repeat:
 	if (pmd_trans_huge(*pmd)) {
-		if (!page) {
+		if (!page)
 			page = pmd_page(*pmd);
-			/*
-			 * An anonymous page must be locked, to ensure that a
-			 * concurrent reuse_swap_page() sees stable mapcount;
-			 * but reuse_swap_page() is not used on shmem or file,
-			 * and page lock must not be taken when zap_pmd_range()
-			 * calls __split_huge_pmd() while i_mmap_lock is held.
-			 */
-			if (PageAnon(page)) {
-				if (unlikely(!trylock_page(page))) {
-					get_page(page);
-					_pmd = *pmd;
-					spin_unlock(ptl);
-					lock_page(page);
-					spin_lock(ptl);
-					if (unlikely(!pmd_same(*pmd, _pmd))) {
-						unlock_page(page);
-						put_page(page);
-						page = NULL;
-						goto repeat;
-					}
-					put_page(page);
-				}
-				do_unlock_page = true;
-			}
-		}
 		if (PageMlocked(page))
 			clear_page_mlock(page);
 	} else if (!(pmd_devmap(*pmd) || is_pmd_migration_entry(*pmd)))
@@ -2208,8 +2180,6 @@ repeat:
 	__split_huge_pmd_locked(vma, pmd, range.start, freeze);
 out:
 	spin_unlock(ptl);
-	if (do_unlock_page)
-		unlock_page(page);
 	/*
 	 * No need to double call mmu_notifier->invalidate_range() callback.
 	 * They are 3 cases to consider inside __split_huge_pmd_locked():
_

Patches currently in -mm which might be from david@redhat.com are

mm-optimize-do_wp_page-for-exclusive-pages-in-the-swapcache.patch
mm-optimize-do_wp_page-for-fresh-pages-in-local-lru-pagevecs.patch
mm-slightly-clarify-ksm-logic-in-do_swap_page.patch
mm-streamline-cow-logic-in-do_swap_page.patch
mm-huge_memory-streamline-cow-logic-in-do_huge_pmd_wp_page.patch
mm-khugepaged-remove-reuse_swap_page-usage.patch
mm-swapfile-remove-stale-reuse_swap_page.patch
mm-huge_memory-remove-stale-page_trans_huge_mapcount.patch
mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd.patch
proc-vmcore-fix-possible-deadlock-on-concurrent-mmap-and-read.patch

