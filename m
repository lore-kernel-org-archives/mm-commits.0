Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD662C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 03:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiKJDS6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 22:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiKJDS5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 22:18:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4F7D2C9
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 19:18:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4835561CE0
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2022 03:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B37BC433D6;
        Thu, 10 Nov 2022 03:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668050335;
        bh=sKqz3MxCsiFDP6MR1vZpJgIS4/FP+DjMpYIOCMUz52w=;
        h=Date:To:From:Subject:From;
        b=lkNWIYkoXXjXjILUymURKC9k/azDzNtTW0Z76sXkVkUHwDCQGZajxyruzsDfZ3zug
         o26sDXOM/6uhnwZz00AyDkMo7TzWcPk5Ha9sXq3rghLSRX8+Hfu6Hrh27Amcp3QwAo
         FGWosql/TKHlIjeMl+6ifMnwiumUU2cjhZsMqrt4=
Date:   Wed, 09 Nov 2022 19:18:54 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
        shy828301@gmail.com, osalvador@suse.de,
        baolin.wang@linux.alibaba.com, ying.huang@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + migrate-convert-unmap_and_move-to-use-folios.patch added to mm-unstable branch
Message-Id: <20221110031855.9B37BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: migrate: convert unmap_and_move() to use folios
has been added to the -mm mm-unstable branch.  Its filename is
     migrate-convert-unmap_and_move-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/migrate-convert-unmap_and_move-to-use-folios.patch

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

migrate-convert-unmap_and_move-to-use-folios.patch
migrate-convert-migrate_pages-to-use-folios.patch

