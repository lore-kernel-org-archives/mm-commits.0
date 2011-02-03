From: akpm@linux-foundation.org
Subject: [merged] mm-migration-fix-page-corruption-during-hugepage-migration.patch removed from -mm tree
Date: Thu, 03 Feb 2011 11:46:02 -0800
Message-ID: <201102031946.p13Jk2Lo020974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756730Ab1BCTqj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 14:46:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, aarcange@redhat.com, cl@linux.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm/migration: fix page corruption during hugepage migration
has been removed from the -mm tree.  Its filename was
     mm-migration-fix-page-corruption-during-hugepage-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/migration: fix page corruption during hugepage migration
From: Minchan Kim <minchan.kim@gmail.com>

If migrate_huge_page by memory-failure fails , it calls put_page in itself
to decrease page reference and caller of migrate_huge_page also calls
putback_lru_pages.  It can do double free of page so it can make page
corruption on page holder.

In addtion, clean of pages on caller is consistent behavior with
migrate_pages by cf608ac19c ("mm: compaction: fix COMPACTPAGEFAILED
counting").

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    5 ++++-
 mm/migrate.c        |    4 ----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff -puN mm/memory-failure.c~mm-migration-fix-page-corruption-during-hugepage-migration mm/memory-failure.c
--- a/mm/memory-failure.c~mm-migration-fix-page-corruption-during-hugepage-migration
+++ a/mm/memory-failure.c
@@ -1295,7 +1295,10 @@ static int soft_offline_huge_page(struct
 	ret = migrate_huge_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL, 0,
 				true);
 	if (ret) {
-		putback_lru_pages(&pagelist);
+		struct page *page1, *page2;
+		list_for_each_entry_safe(page1, page2, &pagelist, lru)
+			put_page(page1);
+
 		pr_debug("soft offline: %#lx: migration failed %d, type %lx\n",
 			 pfn, ret, page->flags);
 		if (ret > 0)
diff -puN mm/migrate.c~mm-migration-fix-page-corruption-during-hugepage-migration mm/migrate.c
--- a/mm/migrate.c~mm-migration-fix-page-corruption-during-hugepage-migration
+++ a/mm/migrate.c
@@ -980,10 +980,6 @@ int migrate_huge_pages(struct list_head 
 	}
 	rc = 0;
 out:
-
-	list_for_each_entry_safe(page, page2, from, lru)
-		put_page(page);
