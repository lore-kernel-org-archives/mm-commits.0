Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83141C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbiCYWpR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234042AbiCYWpC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:45:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5195420DB2E
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:43:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7BB7B82A2F
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:43:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732CCC340ED;
        Fri, 25 Mar 2022 22:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248189;
        bh=cXG0gMT0hCtlOK5sR/FLPFP0IReE3/Cx2pzjNJgVoLU=;
        h=Date:To:From:Subject:From;
        b=LalL042MsP/mq0Pog+q24yLGw0uySDOy2DJRz6gtCHvGwnoQciOkgNCll+vTObgfD
         +NqTSZz1mlST5lQ8/M5WBjUAncfREFisH9OfRuytvEx4vjWRhlSx2Meqbid1pnAvAw
         A9t780+ru6bl+3i+0uXpAoZG/mj7Enk6FGNGyPD8=
Date:   Fri, 25 Mar 2022 15:43:08 -0700
To:     mm-commits@vger.kernel.org, zhangliang5@huawei.com,
        willy@infradead.org, vbabka@suse.cz, shy828301@gmail.com,
        shakeelb@google.com, rppt@linux.ibm.com, roman.gushchin@linux.dev,
        rientjes@google.com, riel@surriel.com, peterx@redhat.com,
        oleg@redhat.com, nadav.amit@gmail.com, mike.kravetz@oracle.com,
        mhocko@kernel.org, kirill.shutemov@linux.intel.com,
        jhubbard@nvidia.com, jgg@nvidia.com, jannh@google.com,
        jack@suse.cz, hughd@google.com, hch@lst.de, ddutile@redhat.com,
        aarcange@redhat.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-optimize-do_wp_page-for-fresh-pages-in-local-lru-pagevecs.patch removed from -mm tree
Message-Id: <20220325224309.732CCC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: optimize do_wp_page() for fresh pages in local LRU pagevecs
has been removed from the -mm tree.  Its filename was
     mm-optimize-do_wp_page-for-fresh-pages-in-local-lru-pagevecs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Vlastimil Babka <vbabka@suse.cz>
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
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-optimize-do_wp_page-for-fresh-pages-in-local-lru-pagevecs
+++ a/mm/memory.c
@@ -3294,7 +3294,15 @@ static vm_fault_t do_wp_page(struct vm_f
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


