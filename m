Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B3A6C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 21 Dec 2021 22:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234504AbhLUWyR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Dec 2021 17:54:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58222 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbhLUWyR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Dec 2021 17:54:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DE39B81A25
        for <mm-commits@vger.kernel.org>; Tue, 21 Dec 2021 22:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44A8C36AE8;
        Tue, 21 Dec 2021 22:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640127254;
        bh=j0LIwnzZbJcXlc6/361bd4mCfacYwO8ZVV0plR2gAuo=;
        h=Date:From:To:Subject:From;
        b=HfI2snEA+LFu2N7qcY4k2WoVbKG0X2/9lQc5DEOKgMUOcWeysMQ/OoARaZDAaBh7g
         sD1SGDvO8dwwrH70lAB+Rt3zeA2VuSVKqkek3t1+XzL23TFC4kO6uO4hLkGfEtUCj3
         GN8ho+A9kpAStKVJg8IW5Vn8blGAQVaIKo21XA1A=
Date:   Tue, 21 Dec 2021 14:54:14 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        torvalds@linux-foundation.org, david@redhat.com,
        willy@infradead.org
Subject:  +
 mm-remove-the-total_mapcount-argument-from-page_trans_huge_map_swapcount.patch
 added to -mm tree
Message-ID: <20211221225414.avDSv%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove the total_mapcount argument from page_trans_huge_map_swapcount()
has been added to the -mm tree.  Its filename is
     mm-remove-the-total_mapcount-argument-from-page_trans_huge_map_swapcount.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-the-total_mapcount-argument-from-page_trans_huge_map_swapcount.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-the-total_mapcount-argument-from-page_trans_huge_map_swapcount.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove the total_mapcount argument from page_trans_huge_map_swapcount()

Now that we don't report it to the caller of reuse_swap_page(), we don't
need to request it from page_trans_huge_map_swapcount().

Link: https://lkml.kernel.org/r/20211220205943.456187-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

--- a/mm/swapfile.c~mm-remove-the-total_mapcount-argument-from-page_trans_huge_map_swapcount
+++ a/mm/swapfile.c
@@ -1601,31 +1601,30 @@ static bool page_swapped(struct page *pa
 	return false;
 }
 
-static int page_trans_huge_map_swapcount(struct page *page, int *total_mapcount,
+static int page_trans_huge_map_swapcount(struct page *page,
 					 int *total_swapcount)
 {
-	int i, map_swapcount, _total_mapcount, _total_swapcount;
+	int i, map_swapcount, _total_swapcount;
 	unsigned long offset = 0;
 	struct swap_info_struct *si;
 	struct swap_cluster_info *ci = NULL;
 	unsigned char *map = NULL;
-	int mapcount, swapcount = 0;
+	int swapcount = 0;
 
 	/* hugetlbfs shouldn't call it */
 	VM_BUG_ON_PAGE(PageHuge(page), page);
 
 	if (!IS_ENABLED(CONFIG_THP_SWAP) || likely(!PageTransCompound(page))) {
-		mapcount = page_trans_huge_mapcount(page, total_mapcount);
 		if (PageSwapCache(page))
 			swapcount = page_swapcount(page);
 		if (total_swapcount)
 			*total_swapcount = swapcount;
-		return mapcount + swapcount;
+		return swapcount + page_trans_huge_mapcount(page, NULL);
 	}
 
 	page = compound_head(page);
 
-	_total_mapcount = _total_swapcount = map_swapcount = 0;
+	_total_swapcount = map_swapcount = 0;
 	if (PageSwapCache(page)) {
 		swp_entry_t entry;
 
@@ -1639,8 +1638,7 @@ static int page_trans_huge_map_swapcount
 	if (map)
 		ci = lock_cluster(si, offset);
 	for (i = 0; i < HPAGE_PMD_NR; i++) {
-		mapcount = atomic_read(&page[i]._mapcount) + 1;
-		_total_mapcount += mapcount;
+		int mapcount = atomic_read(&page[i]._mapcount) + 1;
 		if (map) {
 			swapcount = swap_count(map[offset + i]);
 			_total_swapcount += swapcount;
@@ -1648,19 +1646,14 @@ static int page_trans_huge_map_swapcount
 		map_swapcount = max(map_swapcount, mapcount + swapcount);
 	}
 	unlock_cluster(ci);
-	if (PageDoubleMap(page)) {
+
+	if (PageDoubleMap(page))
 		map_swapcount -= 1;
-		_total_mapcount -= HPAGE_PMD_NR;
-	}
-	mapcount = compound_mapcount(page);
-	map_swapcount += mapcount;
-	_total_mapcount += mapcount;
-	if (total_mapcount)
-		*total_mapcount = _total_mapcount;
+
 	if (total_swapcount)
 		*total_swapcount = _total_swapcount;
 
-	return map_swapcount;
+	return map_swapcount + compound_mapcount(page);
 }
 
 /*
@@ -1671,13 +1664,12 @@ static int page_trans_huge_map_swapcount
  */
 bool reuse_swap_page(struct page *page)
 {
-	int count, total_mapcount, total_swapcount;
+	int count, total_swapcount;
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	if (unlikely(PageKsm(page)))
 		return false;
-	count = page_trans_huge_map_swapcount(page, &total_mapcount,
-					      &total_swapcount);
+	count = page_trans_huge_map_swapcount(page, &total_swapcount);
 	if (count == 1 && PageSwapCache(page) &&
 	    (likely(!PageTransCompound(page)) ||
 	     /* The remaining swap count will be freed soon */
_

Patches currently in -mm which might be from willy@infradead.org are

mmfs-split-dump_mapping-out-from-dump_page.patch
mm-remove-last-argument-of-reuse_swap_page.patch
mm-remove-the-total_mapcount-argument-from-page_trans_huge_map_swapcount.patch
mm-remove-the-total_mapcount-argument-from-page_trans_huge_mapcount.patch

