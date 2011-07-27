From: akpm@linux-foundation.org
Subject: + mm-migration-clean-up-unmap_and_move.patch added to -mm tree
Date: Wed, 27 Jul 2011 13:12:27 -0700
Message-ID: <201107272012.p6RKCSkd005396@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753499Ab1G0UMm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 16:12:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, aarcange@redhat.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com


The patch titled
     mm: migration: clean up unmap_and_move()
has been added to the -mm tree.  Its filename is
     mm-migration-clean-up-unmap_and_move.patch

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
Subject: mm: migration: clean up unmap_and_move()
From: Minchan Kim <minchan.kim@gmail.com>

unmap_and_move() is one a big messy function.  Clean it up.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   75 ++++++++++++++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 35 deletions(-)

diff -puN mm/migrate.c~mm-migration-clean-up-unmap_and_move mm/migrate.c
--- a/mm/migrate.c~mm-migration-clean-up-unmap_and_move
+++ a/mm/migrate.c
@@ -621,38 +621,18 @@ static int move_to_new_page(struct page 
 	return rc;
 }
 
-/*
- * Obtain the lock on page, remove all ptes and migrate the page
- * to the newly allocated page in newpage.
- */
-static int unmap_and_move(new_page_t get_new_page, unsigned long private,
-			struct page *page, int force, bool offlining, bool sync)
+static int __unmap_and_move(struct page *page, struct page *newpage,
+				int force, bool offlining, bool sync)
 {
-	int rc = 0;
-	int *result = NULL;
-	struct page *newpage = get_new_page(page, private, &result);
+	int rc = -EAGAIN;
 	int remap_swapcache = 1;
 	int charge = 0;
 	struct mem_cgroup *mem;
 	struct anon_vma *anon_vma = NULL;
 
-	if (!newpage)
-		return -ENOMEM;
-
-	if (page_count(page) == 1) {
-		/* page was freed from under us. So we are done. */
-		goto move_newpage;
-	}
-	if (unlikely(PageTransHuge(page)))
-		if (unlikely(split_huge_page(page)))
-			goto move_newpage;
-
-	/* prepare cgroup just returns 0 or -ENOMEM */
-	rc = -EAGAIN;
-
 	if (!trylock_page(page)) {
 		if (!force || !sync)
-			goto move_newpage;
+			goto out;
 
 		/*
 		 * It's not safe for direct compaction to call lock_page.
@@ -668,7 +648,7 @@ static int unmap_and_move(new_page_t get
 		 * altogether.
 		 */
 		if (current->flags & PF_MEMALLOC)
-			goto move_newpage;
+			goto out;
 
 		lock_page(page);
 	}
@@ -785,27 +765,52 @@ uncharge:
 		mem_cgroup_end_migration(mem, page, newpage, rc == 0);
 unlock:
 	unlock_page(page);
+out:
+	return rc;
+}
+
+/*
+ * Obtain the lock on page, remove all ptes and migrate the page
+ * to the newly allocated page in newpage.
+ */
+static int unmap_and_move(new_page_t get_new_page, unsigned long private,
+			struct page *page, int force, bool offlining, bool sync)
+{
+	int rc = 0;
+	int *result = NULL;
+	struct page *newpage = get_new_page(page, private, &result);
 
-move_newpage:
+	if (!newpage)
+		return -ENOMEM;
+
+	if (page_count(page) == 1) {
+		/* page was freed from under us. So we are done. */
+		goto out;
+	}
+
+	if (unlikely(PageTransHuge(page)))
+		if (unlikely(split_huge_page(page)))
+			goto out;
+
+	rc = __unmap_and_move(page, newpage, force, offlining, sync);
+out:
 	if (rc != -EAGAIN) {
- 		/*
- 		 * A page that has been migrated has all references
- 		 * removed and will be freed. A page that has not been
- 		 * migrated will have kepts its references and be
- 		 * restored.
- 		 */
- 		list_del(&page->lru);
+		/*
+		 * A page that has been migrated has all references
+		 * removed and will be freed. A page that has not been
+		 * migrated will have kepts its references and be
+		 * restored.
+		 */
+		list_del(&page->lru);
 		dec_zone_page_state(page, NR_ISOLATED_ANON +
 				page_is_file_cache(page));
 		putback_lru_page(page);
 	}
-
 	/*
 	 * Move the new page to the LRU. If migration was not successful
 	 * then this will free the page.
 	 */
 	putback_lru_page(newpage);
