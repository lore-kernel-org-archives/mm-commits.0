Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A35CCC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 31 Jan 2022 19:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377318AbiAaTnr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 14:43:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35488 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377351AbiAaTnk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 14:43:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A52936136F
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 19:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCB4C340E8;
        Mon, 31 Jan 2022 19:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643658218;
        bh=cAJoJxGwQMZQoO+PkDBiiNeYn/TxOuPqITOGQ7x1Gmk=;
        h=Date:From:To:Subject:From;
        b=LXwBxUeqmUnORVlulhdyac+7oWR4Lex4qGedgKP0kLYY3gcXxntKCnjCfndY4WS54
         lG+h0Va+t/MElhjAf7vnFMVr/EJ8ADRGY7lIhQ/of9ytA7x1pW0Scpm7JmN8Tj3IBq
         KkRmldJoIySm5K3GxrtZM+KYNqc+uLpbg8DLjKC4=
Date:   Mon, 31 Jan 2022 11:43:36 -0800
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
 mm-optimize-do_wp_page-for-fresh-pages-in-local-lru-pagevecs.patch added to
 -mm tree
Message-ID: <20220131194336.uuOrz8Ilx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: optimize do_wp_page() for fresh pages in local LRU pagevecs
has been added to the -mm tree.  Its filename is
     mm-optimize-do_wp_page-for-fresh-pages-in-local-lru-pagevecs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-optimize-do_wp_page-for-fresh-pages-in-local-lru-pagevecs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-optimize-do_wp_page-for-fresh-pages-in-local-lru-pagevecs.patch

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
Subject: mm: optimize do_wp_page() for fresh pages in local LRU pagevecs

For example, if a page just got swapped in via a read fault, the LRU
pagevecs might still hold a reference to the page.  If we trigger a write
fault on such a page, the additional reference from the LRU pagevecs will
prohibit reusing the page.

Let's conditionally drain the local LRU pagevecs when we stumble over a
!PageLRU() page.  We cannot easily drain remote LRU pagevecs and it might
not be desirable performance-wise.  Consequently, this will only avoid
copying in some cases.

Add a simple "page_count(page) > 3" check first but keep the
"page_count(page) > 1 + PageSwapCache(page)" check in place, as we want to
minimize cases where we remove a page from the swapcache but won't be able
to reuse it, for example, because another process has it mapped R/O, to
not affect reclaim.

We cannot easily handle the following cases and we will always have to
copy:

(1) The page is referenced in the LRU pagevecs of other CPUs. We really
    would have to drain the LRU pagevecs of all CPUs -- most probably
    copying is much cheaper.

(2) The page is already PageLRU() but is getting moved between LRU
    lists, for example, for activation (e.g., mark_page_accessed()),
    deactivation (MADV_COLD), or lazyfree (MADV_FREE). We'd have to
    drain mostly unconditionally, which might be bad performance-wise.
    Most probably this won't happen too often in practice.

Note that there are other reasons why an anon page might temporarily not
be PageLRU(): for example, compaction and migration have to isolate LRU
pages from the LRU lists first (isolate_lru_page()), moving them to
temporary local lists and clearing PageLRU() and holding an additional
reference on the page.  In that case, we'll always copy.

This change seems to be fairly effective with the reproducer [1] shared by
Nadav, as long as writeback is done synchronously, for example, using
zram.  However, with asynchronous writeback, we'll usually fail to free
the swapcache because the page is still under writeback: something we
cannot easily optimize for, and maybe it's not really relevant in
practice.

[1] https://lkml.kernel.org/r/0480D692-D9B2-429A-9A88-9BBA1331AC3A@gmail.com

Link: https://lkml.kernel.org/r/20220131162940.210846-3-david@redhat.com
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

 mm/memory.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-optimize-do_wp_page-for-fresh-pages-in-local-lru-pagevecs
+++ a/mm/memory.c
@@ -3298,7 +3298,15 @@ static vm_fault_t do_wp_page(struct vm_f
 		 *
 		 * PageKsm() doesn't necessarily raise the page refcount.
 		 */
-		if (PageKsm(page) || page_count(page) > 1 + PageSwapCache(page))
+		if (PageKsm(page) || page_count(page) > 3)
+			goto copy;
+		if (!PageLRU(page))
+			/*
+			 * Note: We cannot easily detect+handle references from
+			 * remote LRU pagevecs or references to PageLRU() pages.
+			 */
+			lru_add_drain();
+		if (page_count(page) > 1 + PageSwapCache(page))
 			goto copy;
 		if (!trylock_page(page))
 			goto copy;
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

