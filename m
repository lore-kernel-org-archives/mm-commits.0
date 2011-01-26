From: akpm@linux-foundation.org
Subject: + mm-migration-fix-page-corruption-during-hugepage-migration.patch added to -mm tree
Date: Wed, 26 Jan 2011 15:10:35 -0800
Message-ID: <201101262310.p0QNAZsZ010231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44742 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753537Ab1AZXLp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Jan 2011 18:11:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, aarcange@redhat.com, cl@linux.com, mel@csn.ul.ie


The patch titled
     mm/migration: fix page corruption during hugepage migration
has been added to the -mm tree.  Its filename is
     mm-migration-fix-page-corruption-during-hugepage-migration.patch

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
