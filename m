Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2202C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 31 Jan 2022 19:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377303AbiAaTns (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 14:43:48 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:38108 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377468AbiAaTnn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 14:43:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CD2C4CE13A0
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 19:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA71C340E8;
        Mon, 31 Jan 2022 19:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643658220;
        bh=L8Q9CYcJl2G1Se8CWx94KM1s+FGzh9vo/rAqwIiHIiU=;
        h=Date:From:To:Subject:From;
        b=2kGBcrvgvuEtWCdkdBaNgRS0OmBG8zunWA3Xf+61rF5fBI6bv06nQ9fNhQG37B+Gm
         sxxhQ2HWJBCRRERQGkmfs5ABIlAwGyIRInOYsk/NaYqoeCOpGJBLcuvVZybET4uuUk
         VRGvqjbux4W613yKAyDI3OsZ+e+bUkaQwMTNl9Rg=
Date:   Mon, 31 Jan 2022 11:43:38 -0800
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
Subject:  + mm-slightly-clarify-ksm-logic-in-do_swap_page.patch
 added to -mm tree
Message-ID: <20220131194338.mnafSfYoM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slightly clarify KSM logic in do_swap_page()
has been added to the -mm tree.  Its filename is
     mm-slightly-clarify-ksm-logic-in-do_swap_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slightly-clarify-ksm-logic-in-do_swap_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slightly-clarify-ksm-logic-in-do_swap_page.patch

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
Subject: mm: slightly clarify KSM logic in do_swap_page()

Let's make it clearer that KSM might only have to copy a page in case we
have a page in the swapcache, not if we allocated a fresh page and
bypassed the swapcache.  While at it, add a comment why this is usually
necessary and merge the two swapcache conditions.

Link: https://lkml.kernel.org/r/20220131162940.210846-4-david@redhat.com
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

 mm/memory.c |   36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

--- a/mm/memory.c~mm-slightly-clarify-ksm-logic-in-do_swap_page
+++ a/mm/memory.c
@@ -3615,21 +3615,29 @@ vm_fault_t do_swap_page(struct vm_fault
 		goto out_release;
 	}
 
-	/*
-	 * Make sure try_to_free_swap or reuse_swap_page or swapoff did not
-	 * release the swapcache from under us.  The page pin, and pte_same
-	 * test below, are not enough to exclude that.  Even if it is still
-	 * swapcache, we need to check that the page's swap has not changed.
-	 */
-	if (unlikely((!PageSwapCache(page) ||
-			page_private(page) != entry.val)) && swapcache)
-		goto out_page;
+	if (swapcache) {
+		/*
+		 * Make sure try_to_free_swap or reuse_swap_page or swapoff did
+		 * not release the swapcache from under us.  The page pin, and
+		 * pte_same test below, are not enough to exclude that.  Even if
+		 * it is still swapcache, we need to check that the page's swap
+		 * has not changed.
+		 */
+		if (unlikely(!PageSwapCache(page) ||
+			     page_private(page) != entry.val))
+			goto out_page;
 
-	page = ksm_might_need_to_copy(page, vma, vmf->address);
-	if (unlikely(!page)) {
-		ret = VM_FAULT_OOM;
-		page = swapcache;
-		goto out_page;
+		/*
+		 * KSM sometimes has to copy on read faults, for example, if
+		 * page->index of !PageKSM() pages would be nonlinear inside the
+		 * anon VMA -- PageKSM() is lost on actual swapout.
+		 */
+		page = ksm_might_need_to_copy(page, vma, vmf->address);
+		if (unlikely(!page)) {
+			ret = VM_FAULT_OOM;
+			page = swapcache;
+			goto out_page;
+		}
 	}
 
 	cgroup_throttle_swaprate(page, GFP_KERNEL);
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

