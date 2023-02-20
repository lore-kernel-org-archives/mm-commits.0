Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B47FC6379F
	for <mm-commits@archiver.kernel.org>; Mon, 20 Feb 2023 20:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbjBTUrT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Feb 2023 15:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbjBTUrH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Feb 2023 15:47:07 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBC630FF
        for <mm-commits@vger.kernel.org>; Mon, 20 Feb 2023 12:47:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 32811CE10AC
        for <mm-commits@vger.kernel.org>; Mon, 20 Feb 2023 20:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D664C433D2;
        Mon, 20 Feb 2023 20:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676926022;
        bh=jSqCeK9+KztqpBNApjf5pfkKkqliU7K/Fr6BN8q58xU=;
        h=Date:To:From:Subject:From;
        b=qDT3PGPI+WJ44JQG+LzAA8bDnoOpuAMQP467lio/6+nOjm5l5G9M7NsiV1SwWhUh8
         aX3PIQGZLNGP55BJiEfMOxKKNGPy3Z/Mk5GR1m64aow06hn7trhYrKPae8PAzf8m9g
         gbQ9Cz7Wu0qujUqi56ZhB+NimRkycP3ZFSiZaS8w=
Date:   Mon, 20 Feb 2023 12:47:01 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        torvalds@linux-foundation.org, sj@kernel.org, david@redhat.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-change-to-return-bool-for-isolate_movable_page.patch removed from -mm tree
Message-Id: <20230220204702.6D664C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: change to return bool for isolate_movable_page()
has been removed from the -mm tree.  Its filename was
     mm-change-to-return-bool-for-isolate_movable_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: change to return bool for isolate_movable_page()
Date: Wed, 15 Feb 2023 18:39:37 +0800

Now the isolate_movable_page() can only return 0 or -EBUSY, and no users
will care about the negative return value, thus we can convert the
isolate_movable_page() to return a boolean value to make the code more
clear when checking the movable page isolation state.

No functional changes intended.

[akpm@linux-foundation.org: remove unneeded comment, per Matthew]
Link: https://lkml.kernel.org/r/cb877f73f4fff8d309611082ec740a7065b1ade0.1676424378.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/migrate.h~mm-change-to-return-bool-for-isolate_movable_page
+++ a/include/linux/migrate.h
@@ -71,7 +71,7 @@ extern int migrate_pages(struct list_hea
 		unsigned long private, enum migrate_mode mode, int reason,
 		unsigned int *ret_succeeded);
 extern struct page *alloc_migration_target(struct page *page, unsigned long private);
-extern int isolate_movable_page(struct page *page, isolate_mode_t mode);
+extern bool isolate_movable_page(struct page *page, isolate_mode_t mode);
 
 int migrate_huge_page_move_mapping(struct address_space *mapping,
 		struct folio *dst, struct folio *src);
@@ -92,8 +92,8 @@ static inline int migrate_pages(struct l
 static inline struct page *alloc_migration_target(struct page *page,
 		unsigned long private)
 	{ return NULL; }
-static inline int isolate_movable_page(struct page *page, isolate_mode_t mode)
-	{ return -EBUSY; }
+static inline bool isolate_movable_page(struct page *page, isolate_mode_t mode)
+	{ return false; }
 
 static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
 				  struct folio *dst, struct folio *src)
--- a/mm/compaction.c~mm-change-to-return-bool-for-isolate_movable_page
+++ a/mm/compaction.c
@@ -976,7 +976,7 @@ isolate_migratepages_block(struct compac
 					locked = NULL;
 				}
 
-				if (!isolate_movable_page(page, mode))
+				if (isolate_movable_page(page, mode))
 					goto isolate_success;
 			}
 
--- a/mm/memory-failure.c~mm-change-to-return-bool-for-isolate_movable_page
+++ a/mm/memory-failure.c
@@ -2515,8 +2515,8 @@ static bool isolate_page(struct page *pa
 		if (lru)
 			isolated = isolate_lru_page(page);
 		else
-			isolated = !isolate_movable_page(page,
-							 ISOLATE_UNEVICTABLE);
+			isolated = isolate_movable_page(page,
+							ISOLATE_UNEVICTABLE);
 
 		if (isolated) {
 			list_add(&page->lru, pagelist);
--- a/mm/memory_hotplug.c~mm-change-to-return-bool-for-isolate_movable_page
+++ a/mm/memory_hotplug.c
@@ -1668,18 +1668,18 @@ do_migrate_range(unsigned long start_pfn
 		 * We can skip free pages. And we can deal with pages on
 		 * LRU and non-lru movable pages.
 		 */
-		if (PageLRU(page)) {
+		if (PageLRU(page))
 			isolated = isolate_lru_page(page);
-			ret = isolated ? 0 : -EBUSY;
-		} else
-			ret = isolate_movable_page(page, ISOLATE_UNEVICTABLE);
-		if (!ret) { /* Success */
+		else
+			isolated = isolate_movable_page(page, ISOLATE_UNEVICTABLE);
+		if (isolated) {
 			list_add_tail(&page->lru, &source);
 			if (!__PageMovable(page))
 				inc_node_page_state(page, NR_ISOLATED_ANON +
 						    page_is_file_lru(page));
 
 		} else {
+			ret = -EBUSY;
 			if (__ratelimit(&migrate_rs)) {
 				pr_warn("failed to isolate pfn %lx\n", pfn);
 				dump_page(page, "isolation failed");
--- a/mm/migrate.c~mm-change-to-return-bool-for-isolate_movable_page
+++ a/mm/migrate.c
@@ -58,7 +58,7 @@
 
 #include "internal.h"
 
-int isolate_movable_page(struct page *page, isolate_mode_t mode)
+bool isolate_movable_page(struct page *page, isolate_mode_t mode)
 {
 	struct folio *folio = folio_get_nontail_page(page);
 	const struct movable_operations *mops;
@@ -119,14 +119,14 @@ int isolate_movable_page(struct page *pa
 	folio_set_isolated(folio);
 	folio_unlock(folio);
 
-	return 0;
+	return true;
 
 out_no_isolated:
 	folio_unlock(folio);
 out_putfolio:
 	folio_put(folio);
 out:
-	return -EBUSY;
+	return false;
 }
 
 static void putback_movable_folio(struct folio *folio)
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


