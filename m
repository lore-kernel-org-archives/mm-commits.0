Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A4DDC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:06:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiANWGz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiANWGy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:06:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57883C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:06:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 183A2B8262F
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C86FC36AE9;
        Fri, 14 Jan 2022 22:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198011;
        bh=VwBhdtaeRanacG0TzN0ZeUWC+8LPKCJXuMh5hJT7s+c=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=n7OGRrNUOtfTuZ6J4uwB08uOzSZNUN1AUqxvhd+zjk7G8mWPWva+qkNApSqz88GpO
         +RpHkH4NTmE0R1mtMByk/4BrIAv1dWr2vKx6nXis/8AQVy65NsaOC3pzPnMKmrQM0U
         3WQQOzbwPifMtXK3lPQoFihELKR52cjWzOljsWQM=
Date:   Fri, 14 Jan 2022 14:06:51 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [patch 071/146] mm: remove the total_mapcount argument
 from page_trans_huge_mapcount()
Message-ID: <20220114220651.8nMOH5xMP%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove the total_mapcount argument from page_trans_huge_mapcount()

All callers pass NULL, so we can stop calculating the value we would store
in it.

Link: https://lkml.kernel.org/r/20211220205943.456187-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h   |   10 +++-------
 include/linux/swap.h |    2 +-
 mm/huge_memory.c     |   30 ++++++++++--------------------
 mm/swapfile.c        |    2 +-
 4 files changed, 15 insertions(+), 29 deletions(-)

--- a/include/linux/mm.h~mm-remove-the-total_mapcount-argument-from-page_trans_huge_mapcount
+++ a/include/linux/mm.h
@@ -799,19 +799,15 @@ static inline int page_mapcount(struct p
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 int total_mapcount(struct page *page);
-int page_trans_huge_mapcount(struct page *page, int *total_mapcount);
+int page_trans_huge_mapcount(struct page *page);
 #else
 static inline int total_mapcount(struct page *page)
 {
 	return page_mapcount(page);
 }
-static inline int page_trans_huge_mapcount(struct page *page,
-					   int *total_mapcount)
+static inline int page_trans_huge_mapcount(struct page *page)
 {
-	int mapcount = page_mapcount(page);
-	if (total_mapcount)
-		*total_mapcount = mapcount;
-	return mapcount;
+	return page_mapcount(page);
 }
 #endif
 
--- a/include/linux/swap.h~mm-remove-the-total_mapcount-argument-from-page_trans_huge_mapcount
+++ a/include/linux/swap.h
@@ -681,7 +681,7 @@ static inline int swp_swapcount(swp_entr
 }
 
 #define reuse_swap_page(page) \
-	(page_trans_huge_mapcount(page, NULL) == 1)
+	(page_trans_huge_mapcount(page) == 1)
 
 static inline int try_to_free_swap(struct page *page)
 {
--- a/mm/huge_memory.c~mm-remove-the-total_mapcount-argument-from-page_trans_huge_mapcount
+++ a/mm/huge_memory.c
@@ -2542,38 +2542,28 @@ int total_mapcount(struct page *page)
  * need full accuracy to avoid breaking page pinning, because
  * page_trans_huge_mapcount() is slower than page_mapcount().
  */
-int page_trans_huge_mapcount(struct page *page, int *total_mapcount)
+int page_trans_huge_mapcount(struct page *page)
 {
-	int i, ret, _total_mapcount, mapcount;
+	int i, ret;
 
 	/* hugetlbfs shouldn't call it */
 	VM_BUG_ON_PAGE(PageHuge(page), page);
 
-	if (likely(!PageTransCompound(page))) {
-		mapcount = atomic_read(&page->_mapcount) + 1;
-		if (total_mapcount)
-			*total_mapcount = mapcount;
-		return mapcount;
-	}
+	if (likely(!PageTransCompound(page)))
+		return atomic_read(&page->_mapcount) + 1;
 
 	page = compound_head(page);
 
-	_total_mapcount = ret = 0;
+	ret = 0;
 	for (i = 0; i < thp_nr_pages(page); i++) {
-		mapcount = atomic_read(&page[i]._mapcount) + 1;
+		int mapcount = atomic_read(&page[i]._mapcount) + 1;
 		ret = max(ret, mapcount);
-		_total_mapcount += mapcount;
 	}
-	if (PageDoubleMap(page)) {
+
+	if (PageDoubleMap(page))
 		ret -= 1;
-		_total_mapcount -= thp_nr_pages(page);
-	}
-	mapcount = compound_mapcount(page);
-	ret += mapcount;
-	_total_mapcount += mapcount;
-	if (total_mapcount)
-		*total_mapcount = _total_mapcount;
-	return ret;
+
+	return ret + compound_mapcount(page);
 }
 
 /* Racy check whether the huge page can be split */
--- a/mm/swapfile.c~mm-remove-the-total_mapcount-argument-from-page_trans_huge_mapcount
+++ a/mm/swapfile.c
@@ -1619,7 +1619,7 @@ static int page_trans_huge_map_swapcount
 			swapcount = page_swapcount(page);
 		if (total_swapcount)
 			*total_swapcount = swapcount;
-		return swapcount + page_trans_huge_mapcount(page, NULL);
+		return swapcount + page_trans_huge_mapcount(page);
 	}
 
 	page = compound_head(page);
_
