Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAFA5C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbiCYWpU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234007AbiCYWpC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:45:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC4420E95D
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:43:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40550B82A1E
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D383AC004DD;
        Fri, 25 Mar 2022 22:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248195;
        bh=MEuwbQu9JFVQiKEs33v7gwz7dN9V7cIdWVtnN+1FNpY=;
        h=Date:To:From:Subject:From;
        b=jWoFKZqcjr6WgrA8PNxzP2rSIu6ulqku/v+BNTlPyVl1zWG9416HXYVzs/DAHvUi+
         09RwFnIHUT9WIK4Sm9rWdzAH4+q9aGGzee50YQlaA1sguoR2+zPDr6wGoxluo3uOY8
         peVyX9cbpF3xzyx02MiLTGdHI+e/m5bbsQbheRuc=
Date:   Fri, 25 Mar 2022 15:43:15 -0700
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
Subject: [merged] mm-swapfile-remove-stale-reuse_swap_page.patch removed from -mm tree
Message-Id: <20220325224315.D383AC004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile: remove stale reuse_swap_page()
has been removed from the -mm tree.  Its filename was
     mm-swapfile-remove-stale-reuse_swap_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/swapfile: remove stale reuse_swap_page()

All users are gone, let's remove it.  We'll let SWP_STABLE_WRITES stick
around for now, as it might come in handy in the near future.

Link: https://lkml.kernel.org/r/20220131162940.210846-8-david@redhat.com
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

 include/linux/swap.h |    4 -
 mm/swapfile.c        |  104 -----------------------------------------
 2 files changed, 108 deletions(-)

--- a/include/linux/swap.h~mm-swapfile-remove-stale-reuse_swap_page
+++ a/include/linux/swap.h
@@ -515,7 +515,6 @@ extern int __swp_swapcount(swp_entry_t e
 extern int swp_swapcount(swp_entry_t entry);
 extern struct swap_info_struct *page_swap_info(struct page *);
 extern struct swap_info_struct *swp_swap_info(swp_entry_t entry);
-extern bool reuse_swap_page(struct page *);
 extern int try_to_free_swap(struct page *);
 struct backing_dev_info;
 extern int init_swap_address_space(unsigned int type, unsigned long nr_pages);
@@ -681,9 +680,6 @@ static inline int swp_swapcount(swp_entr
 	return 0;
 }
 
-#define reuse_swap_page(page) \
-	(page_trans_huge_mapcount(page) == 1)
-
 static inline int try_to_free_swap(struct page *page)
 {
 	return 0;
--- a/mm/swapfile.c~mm-swapfile-remove-stale-reuse_swap_page
+++ a/mm/swapfile.c
@@ -1167,16 +1167,6 @@ out:
 	return NULL;
 }
 
-static struct swap_info_struct *swap_info_get(swp_entry_t entry)
-{
-	struct swap_info_struct *p;
-
-	p = _swap_info_get(entry);
-	if (p)
-		spin_lock(&p->lock);
-	return p;
-}
-
 static struct swap_info_struct *swap_info_get_cont(swp_entry_t entry,
 					struct swap_info_struct *q)
 {
@@ -1601,100 +1591,6 @@ static bool page_swapped(struct page *pa
 	return false;
 }
 
-static int page_trans_huge_map_swapcount(struct page *page,
-					 int *total_swapcount)
-{
-	int i, map_swapcount, _total_swapcount;
-	unsigned long offset = 0;
-	struct swap_info_struct *si;
-	struct swap_cluster_info *ci = NULL;
-	unsigned char *map = NULL;
-	int swapcount = 0;
-
-	/* hugetlbfs shouldn't call it */
-	VM_BUG_ON_PAGE(PageHuge(page), page);
-
-	if (!IS_ENABLED(CONFIG_THP_SWAP) || likely(!PageTransCompound(page))) {
-		if (PageSwapCache(page))
-			swapcount = page_swapcount(page);
-		if (total_swapcount)
-			*total_swapcount = swapcount;
-		return swapcount + page_trans_huge_mapcount(page);
-	}
-
-	page = compound_head(page);
-
-	_total_swapcount = map_swapcount = 0;
-	if (PageSwapCache(page)) {
-		swp_entry_t entry;
-
-		entry.val = page_private(page);
-		si = _swap_info_get(entry);
-		if (si) {
-			map = si->swap_map;
-			offset = swp_offset(entry);
-		}
-	}
-	if (map)
-		ci = lock_cluster(si, offset);
-	for (i = 0; i < HPAGE_PMD_NR; i++) {
-		int mapcount = atomic_read(&page[i]._mapcount) + 1;
-		if (map) {
-			swapcount = swap_count(map[offset + i]);
-			_total_swapcount += swapcount;
-		}
-		map_swapcount = max(map_swapcount, mapcount + swapcount);
-	}
-	unlock_cluster(ci);
-
-	if (PageDoubleMap(page))
-		map_swapcount -= 1;
-
-	if (total_swapcount)
-		*total_swapcount = _total_swapcount;
-
-	return map_swapcount + compound_mapcount(page);
-}
-
-/*
- * We can write to an anon page without COW if there are no other references
- * to it.  And as a side-effect, free up its swap: because the old content
- * on disk will never be read, and seeking back there to write new content
- * later would only waste time away from clustering.
- */
-bool reuse_swap_page(struct page *page)
-{
-	int count, total_swapcount;
-
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	if (unlikely(PageKsm(page)))
-		return false;
-	count = page_trans_huge_map_swapcount(page, &total_swapcount);
-	if (count == 1 && PageSwapCache(page) &&
-	    (likely(!PageTransCompound(page)) ||
-	     /* The remaining swap count will be freed soon */
-	     total_swapcount == page_swapcount(page))) {
-		if (!PageWriteback(page)) {
-			page = compound_head(page);
-			delete_from_swap_cache(page);
-			SetPageDirty(page);
-		} else {
-			swp_entry_t entry;
-			struct swap_info_struct *p;
-
-			entry.val = page_private(page);
-			p = swap_info_get(entry);
-			if (p->flags & SWP_STABLE_WRITES) {
-				spin_unlock(&p->lock);
-				return false;
-			}
-			spin_unlock(&p->lock);
-		}
-	}
-
-	return count <= 1;
-}
-
 /*
  * If swap is getting full, or if there are no more mappings of this page,
  * then try_to_free_swap is called to free its swap space.
_

Patches currently in -mm which might be from david@redhat.com are


