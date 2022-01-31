Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE058C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 31 Jan 2022 19:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377446AbiAaTn7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 14:43:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377363AbiAaTnu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 14:43:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52510C061714
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 11:43:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E380F61458
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 19:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78624C340EE;
        Mon, 31 Jan 2022 19:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643658228;
        bh=kS4KdRqoyecH3x6vjDq5btv5izfU9jwxdXnjJaJgRfQ=;
        h=Date:From:To:Subject:From;
        b=rlzfW0m2WUABBaZVSuAPsYzdk+xVQaKonFiwdDAjdxeplA6SHmPGSwoL97psHDahH
         0bEnP5sD6CpKj+/jr3vZerfdK7YkImA16iYDKQp3o+nDwaBwd7Y5dGUN4yX47NIi57
         mJGQ6hL1iIjRnzp8U320KmPrx/a0EDx7v92aupjk=
Date:   Mon, 31 Jan 2022 11:43:47 -0800
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
Subject:  + mm-swapfile-remove-stale-reuse_swap_page.patch added to
 -mm tree
Message-ID: <20220131194347.2sic9lBnv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile: remove stale reuse_swap_page()
has been added to the -mm tree.  Its filename is
     mm-swapfile-remove-stale-reuse_swap_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-swapfile-remove-stale-reuse_swap_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-swapfile-remove-stale-reuse_swap_page.patch

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
Subject: mm/swapfile: remove stale reuse_swap_page()

All users are gone, let's remove it.  We'll let SWP_STABLE_WRITES stick
around for now, as it might come in handy in the near future.

Link: https://lkml.kernel.org/r/20220131162940.210846-8-david@redhat.com
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

 include/linux/swap.h |    4 -
 mm/swapfile.c        |  104 -----------------------------------------
 2 files changed, 108 deletions(-)

--- a/include/linux/swap.h~mm-swapfile-remove-stale-reuse_swap_page
+++ a/include/linux/swap.h
@@ -514,7 +514,6 @@ extern int __swp_swapcount(swp_entry_t e
 extern int swp_swapcount(swp_entry_t entry);
 extern struct swap_info_struct *page_swap_info(struct page *);
 extern struct swap_info_struct *swp_swap_info(swp_entry_t entry);
-extern bool reuse_swap_page(struct page *);
 extern int try_to_free_swap(struct page *);
 struct backing_dev_info;
 extern int init_swap_address_space(unsigned int type, unsigned long nr_pages);
@@ -680,9 +679,6 @@ static inline int swp_swapcount(swp_entr
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

