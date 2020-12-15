Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC04DC2BB9A
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4299224D2
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:13:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbgLODNo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:13:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728082AbgLODNX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:13:23 -0500
Date:   Mon, 14 Dec 2020 19:13:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001987;
        bh=8Im3z3k04oR89yDcwvjrpfi3ze8Z2vouQFIVKSFY7lY=;
        h=From:To:Subject:In-Reply-To:From;
        b=1a4YJ124L+ciq29yKrmfsRbXPxjanO0sLOXaQaMFmXheQpiWsBbmdgui9hYbCCOff
         Gf6wKF0os2ZnR3UKNdDGaouWMnv5gJP8FEa6I7T4IvimjsdzV43EwmUkCusMd+2kLu
         Ekm2plwqOQPwV/c1h12+xiatG6JhTWc1NrLtEEt8=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jack@suse.cz, linux-mm@kvack.org,
        mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org,
        shy828301@gmail.com, songliubraving@fb.com,
        torvalds@linux-foundation.org, willy@infradead.org, ziy@nvidia.com
Subject:  [patch 167/200] mm: migrate: simplify the logic for
 handling permanent failure
Message-ID: <20201215031306.nmBgLFfUb%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>
Subject: mm: migrate: simplify the logic for handling permanent failure

When unmap_and_move{_huge_page}() returns !-EAGAIN and
!MIGRATEPAGE_SUCCESS, the page would be put back to LRU or proper list if
it is non-LRU movable page.  But, the callers always call
putback_movable_pages() to put the failed pages back later on, so it seems
not very efficient to put every single page back immediately, and the code
looks convoluted.

Put the failed page on a separate list, then splice the list to migrate
list when all pages are tried.  It is the caller's responsibility to call
putback_movable_pages() to handle failures.  This also makes the code
simpler and more readable.

After the change the rules are:
    * Success: non hugetlb page will be freed, hugetlb page will be put
               back
    * -EAGAIN: stay on the from list
    * -ENOMEM: stay on the from list
    * Other errno: put on ret_pages list then splice to from list

The from list would be empty iff all pages are migrated successfully, it
was not so before.  This has no impact to current existing callsites.

Link: https://lkml.kernel.org/r/20201113205359.556831-3-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   68 +++++++++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 30 deletions(-)

--- a/mm/migrate.c~mm-migrate-simplify-the-logic-for-handling-permanent-failure
+++ a/mm/migrate.c
@@ -1168,7 +1168,8 @@ static int unmap_and_move(new_page_t get
 				   free_page_t put_new_page,
 				   unsigned long private, struct page *page,
 				   int force, enum migrate_mode mode,
-				   enum migrate_reason reason)
+				   enum migrate_reason reason,
+				   struct list_head *ret)
 {
 	int rc = MIGRATEPAGE_SUCCESS;
 	struct page *newpage = NULL;
@@ -1205,7 +1206,14 @@ out:
 		 * migrated will have kept its references and be restored.
 		 */
 		list_del(&page->lru);
+	}
 
+	/*
+	 * If migration is successful, releases reference grabbed during
+	 * isolation. Otherwise, restore the page to right list unless
+	 * we want to retry.
+	 */
+	if (rc == MIGRATEPAGE_SUCCESS) {
 		/*
 		 * Compaction can migrate also non-LRU pages which are
 		 * not accounted to NR_ISOLATED_*. They can be recognized
@@ -1214,35 +1222,16 @@ out:
 		if (likely(!__PageMovable(page)))
 			mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON +
 					page_is_file_lru(page), -thp_nr_pages(page));
-	}
 
-	/*
-	 * If migration is successful, releases reference grabbed during
-	 * isolation. Otherwise, restore the page to right list unless
-	 * we want to retry.
-	 */
-	if (rc == MIGRATEPAGE_SUCCESS) {
 		if (reason != MR_MEMORY_FAILURE)
 			/*
 			 * We release the page in page_handle_poison.
 			 */
 			put_page(page);
 	} else {
-		if (rc != -EAGAIN) {
-			if (likely(!__PageMovable(page))) {
-				putback_lru_page(page);
-				goto put_new;
-			}
+		if (rc != -EAGAIN)
+			list_add_tail(&page->lru, ret);
 
-			lock_page(page);
-			if (PageMovable(page))
-				putback_movable_page(page);
-			else
-				__ClearPageIsolated(page);
-			unlock_page(page);
-			put_page(page);
-		}
-put_new:
 		if (put_new_page)
 			put_new_page(newpage, private);
 		else
@@ -1273,7 +1262,8 @@ put_new:
 static int unmap_and_move_huge_page(new_page_t get_new_page,
 				free_page_t put_new_page, unsigned long private,
 				struct page *hpage, int force,
-				enum migrate_mode mode, int reason)
+				enum migrate_mode mode, int reason,
+				struct list_head *ret)
 {
 	int rc = -EAGAIN;
 	int page_was_mapped = 0;
@@ -1289,7 +1279,7 @@ static int unmap_and_move_huge_page(new_
 	 * kicking migration.
 	 */
 	if (!hugepage_migration_supported(page_hstate(hpage))) {
-		putback_active_hugepage(hpage);
+		list_move_tail(&hpage->lru, ret);
 		return -ENOSYS;
 	}
 
@@ -1374,8 +1364,10 @@ put_anon:
 out_unlock:
 	unlock_page(hpage);
 out:
-	if (rc != -EAGAIN)
+	if (rc == MIGRATEPAGE_SUCCESS)
 		putback_active_hugepage(hpage);
+	else if (rc != -EAGAIN && rc != MIGRATEPAGE_SUCCESS)
+		list_move_tail(&hpage->lru, ret);
 
 	/*
 	 * If migration was not successful and there's a freeing callback, use
@@ -1406,8 +1398,8 @@ out:
  *
  * The function returns after 10 attempts or if no pages are movable any more
  * because the list has become empty or no retryable pages exist any more.
- * The caller should call putback_movable_pages() to return pages to the LRU
- * or free list only if ret != 0.
+ * It is caller's responsibility to call putback_movable_pages() to return pages
+ * to the LRU or free list only if ret != 0.
  *
  * Returns the number of pages that were not migrated, or an error code.
  */
@@ -1428,6 +1420,7 @@ int migrate_pages(struct list_head *from
 	struct page *page2;
 	int swapwrite = current->flags & PF_SWAPWRITE;
 	int rc, nr_subpages;
+	LIST_HEAD(ret_pages);
 
 	if (!swapwrite)
 		current->flags |= PF_SWAPWRITE;
@@ -1450,12 +1443,21 @@ retry:
 			if (PageHuge(page))
 				rc = unmap_and_move_huge_page(get_new_page,
 						put_new_page, private, page,
-						pass > 2, mode, reason);
+						pass > 2, mode, reason,
+						&ret_pages);
 			else
 				rc = unmap_and_move(get_new_page, put_new_page,
 						private, page, pass > 2, mode,
-						reason);
-
+						reason, &ret_pages);
+			/*
+			 * The rules are:
+			 *	Success: non hugetlb page will be freed, hugetlb
+			 *		 page will be put back
+			 *	-EAGAIN: stay on the from list
+			 *	-ENOMEM: stay on the from list
+			 *	Other errno: put on ret_pages list then splice to
+			 *		     from list
+			 */
 			switch(rc) {
 			case -ENOMEM:
 				/*
@@ -1521,6 +1523,12 @@ retry:
 	nr_thp_failed += thp_retry;
 	rc = nr_failed;
 out:
+	/*
+	 * Put the permanent failure page back to migration list, they
+	 * will be put back to the right list by the caller.
+	 */
+	list_splice(&ret_pages, from);
+
 	count_vm_events(PGMIGRATE_SUCCESS, nr_succeeded);
 	count_vm_events(PGMIGRATE_FAIL, nr_failed);
 	count_vm_events(THP_MIGRATION_SUCCESS, nr_thp_succeeded);
_
