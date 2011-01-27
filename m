From: akpm@linux-foundation.org
Subject: [withdrawn] mm-when-migrate_pages-returns-0-all-pages-must-have-been-released-update.patch removed from -mm tree
Date: Wed, 26 Jan 2011 16:19:32 -0800
Message-ID: <201101270019.p0R0JWbt013232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754459Ab1A0AUL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Jan 2011 19:20:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, aarcange@redhat.com, cl@linux.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm-when-migrate_pages-returns-0-all-pages-must-have-been-released-update
has been removed from the -mm tree.  Its filename was
     mm-when-migrate_pages-returns-0-all-pages-must-have-been-released-update.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-when-migrate_pages-returns-0-all-pages-must-have-been-released-update
From: Minchan Kim <minchan.kim@gmail.com>

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff -puN mm/migrate.c~mm-when-migrate_pages-returns-0-all-pages-must-have-been-released-update mm/migrate.c
--- a/mm/migrate.c~mm-when-migrate_pages-returns-0-all-pages-must-have-been-released-update
+++ a/mm/migrate.c
@@ -611,6 +611,14 @@ static int move_to_new_page(struct page 
 	return rc;
 }
 
+static void unmap_and_move_release_page(struct page *page)
+{
+	list_del(&page->lru);
+	dec_zone_page_state(page, NR_ISOLATED_ANON +
+			    page_is_file_cache(page));
+	putback_lru_page(page);
+}
+
 /*
  * Obtain the lock on page, remove all ptes and migrate the page
  * to the newly allocated page in newpage.
@@ -631,11 +639,14 @@ static int unmap_and_move(new_page_t get
 
 	if (page_count(page) == 1) {
 		/* page was freed from under us. So we are done. */
+		unmap_and_move_release_page(page);
 		goto move_newpage;
 	}
 	if (unlikely(PageTransHuge(page)))
-		if (unlikely(split_huge_page(page)))
+		if (unlikely(split_huge_page(page))) {
+			unmap_and_move_release_page(page);
 			goto move_newpage;
+		}
 
 	/* prepare cgroup just returns 0 or -ENOMEM */
 	rc = -EAGAIN;
@@ -772,7 +783,6 @@ uncharge:
 unlock:
 	unlock_page(page);
 
-move_newpage:
 	if (rc != -EAGAIN) {
  		/*
  		 * A page that has been migrated has all references
@@ -780,12 +790,11 @@ move_newpage:
  		 * migrated will have kepts its references and be
  		 * restored.
  		 */
- 		list_del(&page->lru);
-		dec_zone_page_state(page, NR_ISOLATED_ANON +
-				page_is_file_cache(page));
-		putback_lru_page(page);
+		unmap_and_move_release_page(page);
 	}
 
+move_newpage:
+
 	/*
 	 * Move the new page to the LRU. If migration was not successful
 	 * then this will free the page.
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
linux-next.patch
mm-when-migrate_pages-returns-0-all-pages-must-have-been-released.patch
mm-migration-fix-page-corruption-during-hugepage-migration.patch
mm-vmap-area-cache.patch
mm-compaction-check-migrate_pagess-return-value-instead-of-list_empty.patch

