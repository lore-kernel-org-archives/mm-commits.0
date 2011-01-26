From: akpm@linux-foundation.org
Subject: + mm-when-migrate_pages-returns-0-all-pages-must-have-been-released-update.patch added to -mm tree
Date: Wed, 26 Jan 2011 15:37:22 -0800
Message-ID: <201101262337.p0QNbM19011415@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754147Ab1AZXiI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Jan 2011 18:38:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, aarcange@redhat.com, cl@linux.com, mel@csn.ul.ie


The patch titled
     mm-when-migrate_pages-returns-0-all-pages-must-have-been-released-update
has been added to the -mm tree.  Its filename is
     mm-when-migrate_pages-returns-0-all-pages-must-have-been-released-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
mm-when-migrate_pages-returns-0-all-pages-must-have-been-released-update.patch
mm-migration-fix-page-corruption-during-hugepage-migration.patch
mm-vmap-area-cache.patch
mm-compaction-check-migrate_pagess-return-value-instead-of-list_empty.patch

