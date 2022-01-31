Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CED1C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 31 Jan 2022 19:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377365AbiAaToA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 14:44:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35664 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377371AbiAaTnv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 14:43:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC3EA61458
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 19:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75665C340E8;
        Mon, 31 Jan 2022 19:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643658230;
        bh=EIKDEjTdCu/+K6lB6iv2WJKB8B5+/iLnySI5xXy+4As=;
        h=Date:From:To:Subject:From;
        b=UvqmDR12MEVzOE4yGfCZywTN/AD1+MykKNEp+SdQaDWxQbgRU1oH0468OacXAI6Zd
         +mH7tZ2VMNWZFusJAc49H5b2lHLBs8NKYlccuQAyEVawMa2iXdp48Yx3MnOS4PibOz
         u93s9CeHrVqBCi4f8lWHZTGyQtZIz88qNzBIJ7Ko=
Date:   Mon, 31 Jan 2022 11:43:49 -0800
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
 mm-huge_memory-remove-stale-page_trans_huge_mapcount.patch added to -mm
 tree
Message-ID: <20220131194349.cpEBmZNGH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: remove stale page_trans_huge_mapcount()
has been added to the -mm tree.  Its filename is
     mm-huge_memory-remove-stale-page_trans_huge_mapcount.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-huge_memory-remove-stale-page_trans_huge_mapcount.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-huge_memory-remove-stale-page_trans_huge_mapcount.patch

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
Subject: mm/huge_memory: remove stale page_trans_huge_mapcount()

All users are gone, let's remove it.

Link: https://lkml.kernel.org/r/20220131162940.210846-9-david@redhat.com
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

 include/linux/mm.h |    5 ----
 mm/huge_memory.c   |   48 -------------------------------------------
 2 files changed, 53 deletions(-)

--- a/include/linux/mm.h~mm-huge_memory-remove-stale-page_trans_huge_mapcount
+++ a/include/linux/mm.h
@@ -820,16 +820,11 @@ static inline int page_mapcount(struct p
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 int total_mapcount(struct page *page);
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
@@ -2523,54 +2523,6 @@ int total_mapcount(struct page *page)
 	return ret;
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
 bool can_split_huge_page(struct page *page, int *pextra_pins)
 {
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

