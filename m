Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D28D8C55ABD
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 23:42:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 882A722260
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 23:42:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="RbrRnbh1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbgKMXmd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Nov 2020 18:42:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:53490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726020AbgKMXmd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Nov 2020 18:42:33 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEBC22225E;
        Fri, 13 Nov 2020 23:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605310952;
        bh=NmWqDcA3m8Al1eRUpmFzlfX8sqd9ZTVNc40HIXlU26o=;
        h=Date:From:To:Subject:From;
        b=RbrRnbh1YbrBkP6vWAcXicM8jYpDVOJtLmxPqyu22Du0oGrpXc4pRx1iWm0qcTMwB
         h70tS+TawNn/uHbxl//6lvkvmKfrmmLroydrG97p+PUwkx3Y3AcYmiIh9njQcHEsbU
         8On/aIROQDJUFDdL/sFlEVgUDC4WXz1cGvy6A62c=
Date:   Fri, 13 Nov 2020 15:42:31 -0800
From:   akpm@linux-foundation.org
To:     jack@suse.cz, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        songliubraving@fb.com, willy@infradead.org, ziy@nvidia.com
Subject:  +
 mm-migrate-simplify-the-logic-for-handling-permanent-failure.patch added to
 -mm tree
Message-ID: <20201113234231.IIRD1bYL1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: simplify the logic for handling permanent failure
has been added to the -mm tree.  Its filename is
     mm-migrate-simplify-the-logic-for-handling-permanent-failure.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-simplify-the-logic-for-handling-permanent-failure.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-simplify-the-logic-for-handling-permanent-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from shy828301@gmail.com are

mm-truncate_complete_page-is-not-existed-anymore.patch
mm-migrate-simplify-the-logic-for-handling-permanent-failure.patch
mm-migrate-skip-shared-exec-thp-for-numa-balancing.patch
mm-migrate-clean-up-migrate_prep_local.patch
mm-migrate-return-enosys-if-thp-migration-is-unsupported.patch

