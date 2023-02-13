Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F97AC636CC
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 23:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbjBMX4M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbjBMXzo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 18:55:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C57271B
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 15:55:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55BCD6135C
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 23:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B8CC4339C;
        Mon, 13 Feb 2023 23:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676332537;
        bh=OFMmrtjW1qCl9t7fItv3AodxgEjVypl4LzqrP5THxww=;
        h=Date:To:From:Subject:From;
        b=mfQOCteczDVhY79O5cZO0X6r7q4avR27T8tKHSGbfWagAThDg1rrFyrTzTS8MU0d6
         POUYhCtGnRiswT4U6QIKC1mgMX00m1qRzd5ddsj+sidBsojwgLSTQXF56thx7l3Qk3
         VukEad9JW+RoRdxKVhecotjaXvx+SceK+bM5VyH4=
Date:   Mon, 13 Feb 2023 15:55:37 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-convert-putback_movable_pages-to-use-folios.patch removed from -mm tree
Message-Id: <20230213235537.A7B8CC4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/migrate: convert putback_movable_pages() to use folios
has been removed from the -mm tree.  Its filename was
     mm-migrate-convert-putback_movable_pages-to-use-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/migrate: convert putback_movable_pages() to use folios
Date: Mon, 30 Jan 2023 13:43:52 -0800

Removes 6 calls to compound_head(), and replaces putback_movable_page()
with putback_movable_folio() as well.

Link: https://lkml.kernel.org/r/20230130214352.40538-5-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/migrate.c~mm-migrate-convert-putback_movable_pages-to-use-folios
+++ a/mm/migrate.c
@@ -129,12 +129,12 @@ out:
 	return -EBUSY;
 }
 
-static void putback_movable_page(struct page *page)
+static void putback_movable_folio(struct folio *folio)
 {
-	const struct movable_operations *mops = page_movable_ops(page);
+	const struct movable_operations *mops = folio_movable_ops(folio);
 
-	mops->putback_page(page);
-	ClearPageIsolated(page);
+	mops->putback_page(&folio->page);
+	folio_clear_isolated(folio);
 }
 
 /*
@@ -147,33 +147,33 @@ static void putback_movable_page(struct
  */
 void putback_movable_pages(struct list_head *l)
 {
-	struct page *page;
-	struct page *page2;
+	struct folio *folio;
+	struct folio *folio2;
 
-	list_for_each_entry_safe(page, page2, l, lru) {
-		if (unlikely(PageHuge(page))) {
-			folio_putback_active_hugetlb(page_folio(page));
+	list_for_each_entry_safe(folio, folio2, l, lru) {
+		if (unlikely(folio_test_hugetlb(folio))) {
+			folio_putback_active_hugetlb(folio);
 			continue;
 		}
-		list_del(&page->lru);
+		list_del(&folio->lru);
 		/*
-		 * We isolated non-lru movable page so here we can use
-		 * __PageMovable because LRU page's mapping cannot have
+		 * We isolated non-lru movable folio so here we can use
+		 * __PageMovable because LRU folio's mapping cannot have
 		 * PAGE_MAPPING_MOVABLE.
 		 */
-		if (unlikely(__PageMovable(page))) {
-			VM_BUG_ON_PAGE(!PageIsolated(page), page);
-			lock_page(page);
-			if (PageMovable(page))
-				putback_movable_page(page);
+		if (unlikely(__folio_test_movable(folio))) {
+			VM_BUG_ON_FOLIO(!folio_test_isolated(folio), folio);
+			folio_lock(folio);
+			if (folio_test_movable(folio))
+				putback_movable_folio(folio);
 			else
-				ClearPageIsolated(page);
-			unlock_page(page);
-			put_page(page);
+				folio_clear_isolated(folio);
+			folio_unlock(folio);
+			folio_put(folio);
 		} else {
-			mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON +
-					page_is_file_lru(page), -thp_nr_pages(page));
-			putback_lru_page(page);
+			node_stat_mod_folio(folio, NR_ISOLATED_ANON +
+					folio_is_file_lru(folio), -folio_nr_pages(folio));
+			folio_putback_lru(folio);
 		}
 	}
 }
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


