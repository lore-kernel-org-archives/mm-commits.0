Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5884AC433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EE8864F1B
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbhBXUIr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:08:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:59402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235289AbhBXUIT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:08:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 199E264EC3;
        Wed, 24 Feb 2021 20:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197283;
        bh=gVElk86W0iovkBG5MvbBrGnab76DsuQO3EEOO4hWJfM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vWxkBcUMJH4Xnkkfz1FRjD4bIN3o+7GLfmEBKFdUJpBA6HXrOmlpVbO6AgcJ0zzRQ
         E2pP3cnN/1uckK2DJ7bjq7eKa7Ku4nnH60FPcxvawM1akH+VDfGUBHt2o+s9vXB+rF
         +KD1pTnwCb5mkfpcoJIUH3sw6oY0q2zd4Xc2cpKQ=
Date:   Wed, 24 Feb 2021 12:08:01 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        hughd@google.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, willy@infradead.org, yuzhao@google.com
Subject:  [patch 133/173] mm/vmscan: __isolate_lru_page_prepare()
 cleanup
Message-ID: <20210224200801.zJa7Eq7jv%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/vmscan: __isolate_lru_page_prepare() cleanup

The function just returns 2 results, so using a 'switch' to deal with its
result is unnecessary.  Also simplify it to a bool func as Vlastimil
suggested.

Also remove 'goto' by reusing list_move(), and take Matthew Wilcox's
suggestion to update comments in function.

Link: https://lkml.kernel.org/r/728874d7-2d93-4049-68c1-dcc3b2d52ccd@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 -
 mm/compaction.c      |    2 -
 mm/vmscan.c          |   68 ++++++++++++++++++-----------------------
 3 files changed, 33 insertions(+), 39 deletions(-)

--- a/include/linux/swap.h~mm-vmscan-__isolate_lru_page_prepare-clean-up
+++ a/include/linux/swap.h
@@ -356,7 +356,7 @@ extern void lru_cache_add_inactive_or_un
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
-extern int __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode);
+extern bool __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode);
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 						  unsigned long nr_pages,
 						  gfp_t gfp_mask,
--- a/mm/compaction.c~mm-vmscan-__isolate_lru_page_prepare-clean-up
+++ a/mm/compaction.c
@@ -988,7 +988,7 @@ isolate_migratepages_block(struct compac
 		if (unlikely(!get_page_unless_zero(page)))
 			goto isolate_fail;
 
-		if (__isolate_lru_page_prepare(page, isolate_mode) != 0)
+		if (!__isolate_lru_page_prepare(page, isolate_mode))
 			goto isolate_fail_put;
 
 		/* Try isolate the page */
--- a/mm/vmscan.c~mm-vmscan-__isolate_lru_page_prepare-clean-up
+++ a/mm/vmscan.c
@@ -1539,19 +1539,17 @@ unsigned int reclaim_clean_pages_from_li
  * page:	page to consider
  * mode:	one of the LRU isolation modes defined above
  *
- * returns 0 on success, -ve errno on failure.
+ * returns true on success, false on failure.
  */
-int __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode)
+bool __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode)
 {
-	int ret = -EBUSY;
-
 	/* Only take pages on the LRU. */
 	if (!PageLRU(page))
-		return ret;
+		return false;
 
 	/* Compaction should not handle unevictable pages but CMA can do so */
 	if (PageUnevictable(page) && !(mode & ISOLATE_UNEVICTABLE))
-		return ret;
+		return false;
 
 	/*
 	 * To minimise LRU disruption, the caller can indicate that it only
@@ -1564,7 +1562,7 @@ int __isolate_lru_page_prepare(struct pa
 	if (mode & ISOLATE_ASYNC_MIGRATE) {
 		/* All the caller can do on PageWriteback is block */
 		if (PageWriteback(page))
-			return ret;
+			return false;
 
 		if (PageDirty(page)) {
 			struct address_space *mapping;
@@ -1580,20 +1578,20 @@ int __isolate_lru_page_prepare(struct pa
 			 * from the page cache.
 			 */
 			if (!trylock_page(page))
-				return ret;
+				return false;
 
 			mapping = page_mapping(page);
 			migrate_dirty = !mapping || mapping->a_ops->migratepage;
 			unlock_page(page);
 			if (!migrate_dirty)
-				return ret;
+				return false;
 		}
 	}
 
 	if ((mode & ISOLATE_UNMAPPED) && page_mapped(page))
-		return ret;
+		return false;
 
-	return 0;
+	return true;
 }
 
 /*
@@ -1677,35 +1675,31 @@ static unsigned long isolate_lru_pages(u
 		 * only when the page is being freed somewhere else.
 		 */
 		scan += nr_pages;
-		switch (__isolate_lru_page_prepare(page, mode)) {
-		case 0:
-			/*
-			 * Be careful not to clear PageLRU until after we're
-			 * sure the page is not being freed elsewhere -- the
-			 * page release code relies on it.
-			 */
-			if (unlikely(!get_page_unless_zero(page)))
-				goto busy;
+		if (!__isolate_lru_page_prepare(page, mode)) {
+			/* It is being freed elsewhere */
+			list_move(&page->lru, src);
+			continue;
+		}
+		/*
+		 * Be careful not to clear PageLRU until after we're
+		 * sure the page is not being freed elsewhere -- the
+		 * page release code relies on it.
+		 */
+		if (unlikely(!get_page_unless_zero(page))) {
+			list_move(&page->lru, src);
+			continue;
+		}
 
-			if (!TestClearPageLRU(page)) {
-				/*
-				 * This page may in other isolation path,
-				 * but we still hold lru_lock.
-				 */
-				put_page(page);
-				goto busy;
-			}
-
-			nr_taken += nr_pages;
-			nr_zone_taken[page_zonenum(page)] += nr_pages;
-			list_move(&page->lru, dst);
-			break;
-
-		default:
-busy:
-			/* else it is being freed elsewhere */
+		if (!TestClearPageLRU(page)) {
+			/* Another thread is already isolating this page */
+			put_page(page);
 			list_move(&page->lru, src);
+			continue;
 		}
+
+		nr_taken += nr_pages;
+		nr_zone_taken[page_zonenum(page)] += nr_pages;
+		list_move(&page->lru, dst);
 	}
 
 	/*
_
