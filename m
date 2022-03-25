Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4E95C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:43:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbiCYWpT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234045AbiCYWpC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:45:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1F820E951
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:43:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3518B82A35
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A142AC340ED;
        Fri, 25 Mar 2022 22:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248194;
        bh=WygTcE6giWwVgYnYeUJLJo/xY8L3ltaPQeBb/K1ZyGg=;
        h=Date:To:From:Subject:From;
        b=Lu4X4Eck9mrXadd0T3Ikh1Hky9sgciqDX8sf7MrJJcklJcPKcZsQjXEZrIqiGRJjm
         PQYmZMSq45Ft9uW7AV7kkd8APyaqOi61gh0ayWvfdAJbyO0BPSHIM+5JyRkuhstFe6
         ahZ+1LVWFy58ACGJdYGvDrwE+0jwJvWtRS+d1O9k=
Date:   Fri, 25 Mar 2022 15:43:14 -0700
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
Subject: [merged] mm-khugepaged-remove-reuse_swap_page-usage.patch removed from -mm tree
Message-Id: <20220325224314.A142AC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: remove reuse_swap_page() usage
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-remove-reuse_swap_page-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: Yang Shi <shy828301@gmail.com>
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


