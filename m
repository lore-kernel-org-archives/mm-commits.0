Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7421BC4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbiLAAFr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiLAADu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:03:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938B387CB7
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B641B81D83
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049C7C433D6;
        Thu,  1 Dec 2022 00:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852904;
        bh=W1YKewHboJRwKfQJ+oKN2xXg9W7vx0y3cPUKBhJ0h0o=;
        h=Date:To:From:Subject:From;
        b=xjH1RmxmtL6Qs8kUxzADpCgSjRRbHp5u36YqO64FXbEcqE8z4xLpZRxMkHVTQafVD
         dwYCRLEW7iM3fN+fU4mCqYob4t3tQ6Mvl7Tb8lcUkj0j9vZp6rd3kmixZf64PQJK/Q
         GSIQMhpAQkMmfnUfYyl0VovEEHiXbLG6dSp8S1KY=
Date:   Wed, 30 Nov 2022 16:01:43 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        shy828301@gmail.com, osalvador@suse.de,
        baolin.wang@linux.alibaba.com, ying.huang@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] migrate-convert-unmap_and_move-to-use-folios.patch removed from -mm tree
Message-Id: <20221201000144.049C7C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: migrate: convert unmap_and_move() to use folios
has been removed from the -mm tree.  Its filename was
     migrate-convert-unmap_and_move-to-use-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: migrate: convert unmap_and_move() to use folios
Date: Wed, 9 Nov 2022 09:23:47 +0800

Patch series "migrate: convert migrate_pages()/unmap_and_move() to use
folios", v2.

The conversion is quite straightforward, just replace the page API to the
corresponding folio API.  migrate_pages() and unmap_and_move() mostly work
with folios (head pages) only.


This patch (of 2):

Quite straightforward, the page functions are converted to corresponding
folio functions.  Same for comments.

Link: https://lkml.kernel.org/r/20221109012348.93849-1-ying.huang@intel.com
Link: https://lkml.kernel.org/r/20221109012348.93849-2-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   54 ++++++++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

--- a/mm/migrate.c~migrate-convert-unmap_and_move-to-use-folios
+++ a/mm/migrate.c
@@ -1150,79 +1150,79 @@ out:
 }
 
 /*
- * Obtain the lock on page, remove all ptes and migrate the page
- * to the newly allocated page in newpage.
+ * Obtain the lock on folio, remove all ptes and migrate the folio
+ * to the newly allocated folio in dst.
  */
 static int unmap_and_move(new_page_t get_new_page,
 				   free_page_t put_new_page,
-				   unsigned long private, struct page *page,
+				   unsigned long private, struct folio *src,
 				   int force, enum migrate_mode mode,
 				   enum migrate_reason reason,
 				   struct list_head *ret)
 {
-	struct folio *dst, *src = page_folio(page);
+	struct folio *dst;
 	int rc = MIGRATEPAGE_SUCCESS;
 	struct page *newpage = NULL;
 
-	if (!thp_migration_supported() && PageTransHuge(page))
+	if (!thp_migration_supported() && folio_test_transhuge(src))
 		return -ENOSYS;
 
-	if (page_count(page) == 1) {
-		/* Page was freed from under us. So we are done. */
-		ClearPageActive(page);
-		ClearPageUnevictable(page);
+	if (folio_ref_count(src) == 1) {
+		/* Folio was freed from under us. So we are done. */
+		folio_clear_active(src);
+		folio_clear_unevictable(src);
 		/* free_pages_prepare() will clear PG_isolated. */
 		goto out;
 	}
 
-	newpage = get_new_page(page, private);
+	newpage = get_new_page(&src->page, private);
 	if (!newpage)
 		return -ENOMEM;
 	dst = page_folio(newpage);
 
-	newpage->private = 0;
+	dst->private = 0;
 	rc = __unmap_and_move(src, dst, force, mode);
 	if (rc == MIGRATEPAGE_SUCCESS)
-		set_page_owner_migrate_reason(newpage, reason);
+		set_page_owner_migrate_reason(&dst->page, reason);
 
 out:
 	if (rc != -EAGAIN) {
 		/*
-		 * A page that has been migrated has all references
-		 * removed and will be freed. A page that has not been
+		 * A folio that has been migrated has all references
+		 * removed and will be freed. A folio that has not been
 		 * migrated will have kept its references and be restored.
 		 */
-		list_del(&page->lru);
+		list_del(&src->lru);
 	}
 
 	/*
 	 * If migration is successful, releases reference grabbed during
-	 * isolation. Otherwise, restore the page to right list unless
+	 * isolation. Otherwise, restore the folio to right list unless
 	 * we want to retry.
 	 */
 	if (rc == MIGRATEPAGE_SUCCESS) {
 		/*
-		 * Compaction can migrate also non-LRU pages which are
+		 * Compaction can migrate also non-LRU folios which are
 		 * not accounted to NR_ISOLATED_*. They can be recognized
-		 * as __PageMovable
+		 * as __folio_test_movable
 		 */
-		if (likely(!__PageMovable(page)))
-			mod_node_page_state(page_pgdat(page), NR_ISOLATED_ANON +
-					page_is_file_lru(page), -thp_nr_pages(page));
+		if (likely(!__folio_test_movable(src)))
+			mod_node_page_state(folio_pgdat(src), NR_ISOLATED_ANON +
+					folio_is_file_lru(src), -folio_nr_pages(src));
 
 		if (reason != MR_MEMORY_FAILURE)
 			/*
-			 * We release the page in page_handle_poison.
+			 * We release the folio in page_handle_poison.
 			 */
-			put_page(page);
+			folio_put(src);
 	} else {
 		if (rc != -EAGAIN)
-			list_add_tail(&page->lru, ret);
+			list_add_tail(&src->lru, ret);
 
 		if (put_new_page)
-			put_new_page(newpage, private);
+			put_new_page(&dst->page, private);
 		else
-			put_page(newpage);
+			folio_put(dst);
 	}
 
 	return rc;
@@ -1459,7 +1459,7 @@ thp_subpage_migration:
 						&ret_pages);
 			else
 				rc = unmap_and_move(get_new_page, put_new_page,
-						private, page, pass > 2, mode,
+						private, page_folio(page), pass > 2, mode,
 						reason, &ret_pages);
 			/*
 			 * The rules are:
_

Patches currently in -mm which might be from ying.huang@intel.com are


