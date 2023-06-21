Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6E96EB64D7
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jun 2023 21:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjFUV4v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jun 2023 17:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjFUV4v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jun 2023 17:56:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3781AC
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 14:56:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF3CD616EA
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 21:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378B6C433C8;
        Wed, 21 Jun 2023 21:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687384608;
        bh=IdWV9YwKn/TKQtYE6pMf7sXp5vM4psl7X0VBF3qmNpk=;
        h=Date:To:From:Subject:From;
        b=G3kWoWx88lxsHnw15TBC5xlQvV93S41dMhml2W4fj4Un1VAPLCyGZi3dJaf9ZFbGf
         YXFiGkaNsQdDdUffppo8PgMODSRx/LunKxGmUjVxG/jKin1jJ7zje71vS0JhKKINHk
         L7RBPTXp4uXi/yVIahaQdw7P7isqCT9btO9/me2Q=
Date:   Wed, 21 Jun 2023 14:56:47 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        jgowans@amazon.com, baolin.wang@linux.alibaba.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-convert-to-use-a-folio-in-isolate_migratepages_block.patch added to mm-unstable branch
Message-Id: <20230621215648.378B6C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: convert to use a folio in isolate_migratepages_block()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-convert-to-use-a-folio-in-isolate_migratepages_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-convert-to-use-a-folio-in-isolate_migratepages_block.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: compaction: convert to use a folio in isolate_migratepages_block()
Date: Mon, 19 Jun 2023 19:07:17 +0800

Directly use a folio instead of page_folio() when page successfully
isolated (hugepage and movable page) and after folio_get_nontail_page(),
which removes several calls to compound_head().

Link: https://lkml.kernel.org/r/20230619110718.65679-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: James Gowans <jgowans@amazon.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   84 ++++++++++++++++++++++++----------------------
 1 file changed, 44 insertions(+), 40 deletions(-)

--- a/mm/compaction.c~mm-compaction-convert-to-use-a-folio-in-isolate_migratepages_block
+++ a/mm/compaction.c
@@ -822,6 +822,7 @@ isolate_migratepages_block(struct compac
 	struct lruvec *lruvec;
 	unsigned long flags = 0;
 	struct lruvec *locked = NULL;
+	struct folio *folio = NULL;
 	struct page *page = NULL, *valid_page = NULL;
 	struct address_space *mapping;
 	unsigned long start_pfn = low_pfn;
@@ -918,7 +919,7 @@ isolate_migratepages_block(struct compac
 		if (!valid_page && pageblock_aligned(low_pfn)) {
 			if (!isolation_suitable(cc, page)) {
 				low_pfn = end_pfn;
-				page = NULL;
+				folio = NULL;
 				goto isolate_abort;
 			}
 			valid_page = page;
@@ -950,7 +951,8 @@ isolate_migratepages_block(struct compac
 				 * Hugepage was successfully isolated and placed
 				 * on the cc->migratepages list.
 				 */
-				low_pfn += compound_nr(page) - 1;
+				folio = page_folio(page);
+				low_pfn += folio_nr_pages(folio) - 1;
 				goto isolate_success_no_list;
 			}
 
@@ -1018,8 +1020,10 @@ isolate_migratepages_block(struct compac
 					locked = NULL;
 				}
 
-				if (isolate_movable_page(page, mode))
+				if (isolate_movable_page(page, mode)) {
+					folio = page_folio(page);
 					goto isolate_success;
+				}
 			}
 
 			goto isolate_fail;
@@ -1030,7 +1034,8 @@ isolate_migratepages_block(struct compac
 		 * sure the page is not being freed elsewhere -- the
 		 * page release code relies on it.
 		 */
-		if (unlikely(!get_page_unless_zero(page)))
+		folio = folio_get_nontail_page(page);
+		if (unlikely(!folio))
 			goto isolate_fail;
 
 		/*
@@ -1038,8 +1043,8 @@ isolate_migratepages_block(struct compac
 		 * so avoid taking lru_lock and isolating it unnecessarily in an
 		 * admittedly racy check.
 		 */
-		mapping = page_mapping(page);
-		if (!mapping && (page_count(page) - 1) > total_mapcount(page))
+		mapping = folio_mapping(folio);
+		if (!mapping && (folio_ref_count(folio) - 1) > folio_mapcount(folio))
 			goto isolate_fail_put;
 
 		/*
@@ -1050,11 +1055,11 @@ isolate_migratepages_block(struct compac
 			goto isolate_fail_put;
 
 		/* Only take pages on LRU: a check now makes later tests safe */
-		if (!PageLRU(page))
+		if (!folio_test_lru(folio))
 			goto isolate_fail_put;
 
 		/* Compaction might skip unevictable pages but CMA takes them */
-		if (!(mode & ISOLATE_UNEVICTABLE) && PageUnevictable(page))
+		if (!(mode & ISOLATE_UNEVICTABLE) && folio_test_unevictable(folio))
 			goto isolate_fail_put;
 
 		/*
@@ -1063,10 +1068,10 @@ isolate_migratepages_block(struct compac
 		 * it will be able to migrate without blocking - clean pages
 		 * for the most part.  PageWriteback would require blocking.
 		 */
-		if ((mode & ISOLATE_ASYNC_MIGRATE) && PageWriteback(page))
+		if ((mode & ISOLATE_ASYNC_MIGRATE) && folio_test_writeback(folio))
 			goto isolate_fail_put;
 
-		if ((mode & ISOLATE_ASYNC_MIGRATE) && PageDirty(page)) {
+		if ((mode & ISOLATE_ASYNC_MIGRATE) && folio_test_dirty(folio)) {
 			bool migrate_dirty;
 
 			/*
@@ -1078,22 +1083,22 @@ isolate_migratepages_block(struct compac
 			 * the page lock until after the page is removed
 			 * from the page cache.
 			 */
-			if (!trylock_page(page))
+			if (!folio_trylock(folio))
 				goto isolate_fail_put;
 
-			mapping = page_mapping(page);
+			mapping = folio_mapping(folio);
 			migrate_dirty = !mapping ||
 					mapping->a_ops->migrate_folio;
-			unlock_page(page);
+			folio_unlock(folio);
 			if (!migrate_dirty)
 				goto isolate_fail_put;
 		}
 
-		/* Try isolate the page */
-		if (!TestClearPageLRU(page))
+		/* Try isolate the folio */
+		if (!folio_test_clear_lru(folio))
 			goto isolate_fail_put;
 
-		lruvec = folio_lruvec(page_folio(page));
+		lruvec = folio_lruvec(folio);
 
 		/* If we already hold the lock, we can skip some rechecking */
 		if (lruvec != locked) {
@@ -1103,7 +1108,7 @@ isolate_migratepages_block(struct compac
 			compact_lock_irqsave(&lruvec->lru_lock, &flags, cc);
 			locked = lruvec;
 
-			lruvec_memcg_debug(lruvec, page_folio(page));
+			lruvec_memcg_debug(lruvec, folio);
 
 			/*
 			 * Try get exclusive access under lock. If marked for
@@ -1119,34 +1124,33 @@ isolate_migratepages_block(struct compac
 			}
 
 			/*
-			 * Page become compound since the non-locked check,
-			 * and it's on LRU. It can only be a THP so the order
-			 * is safe to read and it's 0 for tail pages.
+			 * folio become large since the non-locked check,
+			 * and it's on LRU.
 			 */
-			if (unlikely(PageCompound(page) && !cc->alloc_contig)) {
-				low_pfn += compound_nr(page) - 1;
-				nr_scanned += compound_nr(page) - 1;
-				SetPageLRU(page);
+			if (unlikely(folio_test_large(folio) && !cc->alloc_contig)) {
+				low_pfn += folio_nr_pages(folio) - 1;
+				nr_scanned += folio_nr_pages(folio) - 1;
+				folio_set_lru(folio);
 				goto isolate_fail_put;
 			}
 		}
 
-		/* The whole page is taken off the LRU; skip the tail pages. */
-		if (PageCompound(page))
-			low_pfn += compound_nr(page) - 1;
+		/* The folio is taken off the LRU */
+		if (folio_test_large(folio))
+			low_pfn += folio_nr_pages(folio) - 1;
 
 		/* Successfully isolated */
-		del_page_from_lru_list(page, lruvec);
-		mod_node_page_state(page_pgdat(page),
-				NR_ISOLATED_ANON + page_is_file_lru(page),
-				thp_nr_pages(page));
+		lruvec_del_folio(lruvec, folio);
+		node_stat_mod_folio(folio,
+				NR_ISOLATED_ANON + folio_is_file_lru(folio),
+				folio_nr_pages(folio));
 
 isolate_success:
-		list_add(&page->lru, &cc->migratepages);
+		list_add(&folio->lru, &cc->migratepages);
 isolate_success_no_list:
-		cc->nr_migratepages += compound_nr(page);
-		nr_isolated += compound_nr(page);
-		nr_scanned += compound_nr(page) - 1;
+		cc->nr_migratepages += folio_nr_pages(folio);
+		nr_isolated += folio_nr_pages(folio);
+		nr_scanned += folio_nr_pages(folio) - 1;
 
 		/*
 		 * Avoid isolating too much unless this block is being
@@ -1168,7 +1172,7 @@ isolate_fail_put:
 			unlock_page_lruvec_irqrestore(locked, flags);
 			locked = NULL;
 		}
-		put_page(page);
+		folio_put(folio);
 
 isolate_fail:
 		if (!skip_on_failure && ret != -ENOMEM)
@@ -1209,14 +1213,14 @@ isolate_fail:
 	if (unlikely(low_pfn > end_pfn))
 		low_pfn = end_pfn;
 
-	page = NULL;
+	folio = NULL;
 
 isolate_abort:
 	if (locked)
 		unlock_page_lruvec_irqrestore(locked, flags);
-	if (page) {
-		SetPageLRU(page);
-		put_page(page);
+	if (folio) {
+		folio_set_lru(folio);
+		folio_put(folio);
 	}
 
 	/*
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-compaction-convert-to-use-a-folio-in-isolate_migratepages_block.patch
mm-kill-_page_to_lru_list.patch

