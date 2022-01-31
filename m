Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5E83C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 31 Jan 2022 19:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377351AbiAaToA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 14:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377365AbiAaTnu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 14:43:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87469C06173B
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 11:43:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DBF5ECE13C9
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 19:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFADC340E8;
        Mon, 31 Jan 2022 19:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643658226;
        bh=zT4jys86Dpsmp9LJm1dirFj7HKpWe/kDx0Q/BuGHhZk=;
        h=Date:From:To:Subject:From;
        b=a21jx8sopObmdE9XD99RQ6PHP5XEdQeaSpbXQPXm30K9spwPpka7JP6/ecmKpeSjX
         XV3vEGL6kBpCSWQeboNeZx/aIM42kA5TDfQh+Pre+Ob1qyXMAcTGx1q5YcpXIVP60R
         I5RZMj1A6KeyZKepiVPm3egzR8c7neDP9CdqnKSQ=
Date:   Mon, 31 Jan 2022 11:43:45 -0800
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
Subject:  + mm-khugepaged-remove-reuse_swap_page-usage.patch added
 to -mm tree
Message-ID: <20220131194345.2iuKoUaMa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: remove reuse_swap_page() usage
has been added to the -mm tree.  Its filename is
     mm-khugepaged-remove-reuse_swap_page-usage.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-khugepaged-remove-reuse_swap_page-usage.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-khugepaged-remove-reuse_swap_page-usage.patch

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
Subject: mm/khugepaged: remove reuse_swap_page() usage

reuse_swap_page() currently indicates if we can write to an anon page
without COW.  A COW is required if the page is shared by multiple
processes (either already mapped or via swap entries) or if there is
concurrent writeback that cannot tolerate concurrent page modifications.

However, in the context of khugepaged we're not actually going to write to
a read-only mapped page, we'll copy the page content to our newly
allocated THP and map that THP writable.  All we have to make sure is that
the read-only mapped page we're about to copy won't get reused by another
process sharing the page, otherwise, page content would get modified.  But
that is already guaranteed via multiple mechanisms (e.g., holding a
reference, holding the page lock, removing the rmap after copying the
page).

The swapcache handling was introduced in commit 10359213d05a ("mm:
incorporate read-only pages into transparent huge pages") and it sounds
like it merely wanted to mimic what do_swap_page() would do when trying to
map a page obtained via the swapcache writable.

As that logic is unnecessary, let's just remove it, removing the last user
of reuse_swap_page().

Link: https://lkml.kernel.org/r/20220131162940.210846-7-david@redhat.com
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

 include/trace/events/huge_memory.h |    1 -
 mm/khugepaged.c                    |   11 -----------
 2 files changed, 12 deletions(-)

--- a/include/trace/events/huge_memory.h~mm-khugepaged-remove-reuse_swap_page-usage
+++ a/include/trace/events/huge_memory.h
@@ -29,7 +29,6 @@
 	EM( SCAN_VMA_NULL,		"vma_null")			\
 	EM( SCAN_VMA_CHECK,		"vma_check_failed")		\
 	EM( SCAN_ADDRESS_RANGE,		"not_suitable_address_range")	\
-	EM( SCAN_SWAP_CACHE_PAGE,	"page_swap_cache")		\
 	EM( SCAN_DEL_PAGE_LRU,		"could_not_delete_page_from_lru")\
 	EM( SCAN_ALLOC_HUGE_PAGE_FAIL,	"alloc_huge_page_failed")	\
 	EM( SCAN_CGROUP_CHARGE_FAIL,	"ccgroup_charge_failed")	\
--- a/mm/khugepaged.c~mm-khugepaged-remove-reuse_swap_page-usage
+++ a/mm/khugepaged.c
@@ -46,7 +46,6 @@ enum scan_result {
 	SCAN_VMA_NULL,
 	SCAN_VMA_CHECK,
 	SCAN_ADDRESS_RANGE,
-	SCAN_SWAP_CACHE_PAGE,
 	SCAN_DEL_PAGE_LRU,
 	SCAN_ALLOC_HUGE_PAGE_FAIL,
 	SCAN_CGROUP_CHARGE_FAIL,
@@ -683,16 +682,6 @@ static int __collapse_huge_page_isolate(
 			result = SCAN_PAGE_COUNT;
 			goto out;
 		}
-		if (!pte_write(pteval) && PageSwapCache(page) &&
-				!reuse_swap_page(page)) {
-			/*
-			 * Page is in the swap cache and cannot be re-used.
-			 * It cannot be collapsed into a THP.
-			 */
-			unlock_page(page);
-			result = SCAN_SWAP_CACHE_PAGE;
-			goto out;
-		}
 
 		/*
 		 * Isolate the page to avoid collapsing an hugepage
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

