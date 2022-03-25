Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28299C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234045AbiCYWpT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234046AbiCYWpC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:45:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2FF20E95E
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:43:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C0AAB82A36
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DBCC340ED;
        Fri, 25 Mar 2022 22:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248197;
        bh=TRyO5krPR9ugWONbD07ikj7eH5w/C9o7DlHMdi+nXy0=;
        h=Date:To:From:Subject:From;
        b=z10hKz4g+aZUqM5iBypnEZ2TO/EfzRHcNfyokFBpeXlKqV0Ex29qv6JyFA9opXNO3
         kXkbGNTC4/0rk2l2/BV8dXevVpPyb8VayO6ilfaymUqJQn+EqSeKjNhe7uYyfO/OQq
         vLPGwGobxhhxbhYvICbL63G8p43t/jAsIy+00PJw=
Date:   Fri, 25 Mar 2022 15:43:16 -0700
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
Subject: [merged] mm-huge_memory-remove-stale-page_trans_huge_mapcount.patch removed from -mm tree
Message-Id: <20220325224317.18DBCC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: remove stale page_trans_huge_mapcount()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-remove-stale-page_trans_huge_mapcount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/huge_memory: remove stale page_trans_huge_mapcount()

All users are gone, let's remove it.

Link: https://lkml.kernel.org/r/20220131162940.210846-9-david@redhat.com
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

 include/linux/mm.h |    5 ----
 mm/huge_memory.c   |   48 -------------------------------------------
 2 files changed, 53 deletions(-)

--- a/include/linux/mm.h~mm-huge_memory-remove-stale-page_trans_huge_mapcount
+++ a/include/linux/mm.h
@@ -834,16 +834,11 @@ static inline int total_mapcount(struct
 	return folio_mapcount(page_folio(page));
 }
 
-int page_trans_huge_mapcount(struct page *page);
 #else
 static inline int total_mapcount(struct page *page)
 {
 	return page_mapcount(page);
 }
-static inline int page_trans_huge_mapcount(struct page *page)
-{
-	return page_mapcount(page);
-}
 #endif
 
 static inline struct page *virt_to_head_page(const void *x)
--- a/mm/huge_memory.c~mm-huge_memory-remove-stale-page_trans_huge_mapcount
+++ a/mm/huge_memory.c
@@ -2483,54 +2483,6 @@ static void __split_huge_page(struct pag
 	}
 }
 
-/*
- * This calculates accurately how many mappings a transparent hugepage
- * has (unlike page_mapcount() which isn't fully accurate). This full
- * accuracy is primarily needed to know if copy-on-write faults can
- * reuse the page and change the mapping to read-write instead of
- * copying them. At the same time this returns the total_mapcount too.
- *
- * The function returns the highest mapcount any one of the subpages
- * has. If the return value is one, even if different processes are
- * mapping different subpages of the transparent hugepage, they can
- * all reuse it, because each process is reusing a different subpage.
- *
- * The total_mapcount is instead counting all virtual mappings of the
- * subpages. If the total_mapcount is equal to "one", it tells the
- * caller all mappings belong to the same "mm" and in turn the
- * anon_vma of the transparent hugepage can become the vma->anon_vma
- * local one as no other process may be mapping any of the subpages.
- *
- * It would be more accurate to replace page_mapcount() with
- * page_trans_huge_mapcount(), however we only use
- * page_trans_huge_mapcount() in the copy-on-write faults where we
- * need full accuracy to avoid breaking page pinning, because
- * page_trans_huge_mapcount() is slower than page_mapcount().
- */
-int page_trans_huge_mapcount(struct page *page)
-{
-	int i, ret;
-
-	/* hugetlbfs shouldn't call it */
-	VM_BUG_ON_PAGE(PageHuge(page), page);
-
-	if (likely(!PageTransCompound(page)))
-		return atomic_read(&page->_mapcount) + 1;
-
-	page = compound_head(page);
-
-	ret = 0;
-	for (i = 0; i < thp_nr_pages(page); i++) {
-		int mapcount = atomic_read(&page[i]._mapcount) + 1;
-		ret = max(ret, mapcount);
-	}
-
-	if (PageDoubleMap(page))
-		ret -= 1;
-
-	return ret + compound_mapcount(page);
-}
-
 /* Racy check whether the huge page can be split */
 bool can_split_folio(struct folio *folio, int *pextra_pins)
 {
_

Patches currently in -mm which might be from david@redhat.com are


