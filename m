From: akpm@linux-foundation.org
Subject: [merged] mm-when-migrate_pages-returns-0-all-pages-must-have-been-released.patch removed from -mm tree
Date: Thu, 03 Feb 2011 11:45:59 -0800
Message-ID: <201102031945.p13Jjxi2020965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45843 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756726Ab1BCTqi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 14:46:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, cl@linux.com, mel@csn.ul.ie, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: when migrate_pages returns 0, all pages must have been released
has been removed from the -mm tree.  Its filename was
     mm-when-migrate_pages-returns-0-all-pages-must-have-been-released.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: when migrate_pages returns 0, all pages must have been released
From: Andrea Arcangeli <aarcange@redhat.com>

In some cases migrate_pages could return zero while still leaving a few
pages in the pagelist (and some caller wouldn't notice it has to call
putback_lru_pages after commit cf608ac19c9 ("mm: compaction: fix
COMPACTPAGEFAILED counting")).

Add one missing putback_lru_pages not added by commit cf608ac19c95 ("mm:
compaction: fix COMPACTPAGEFAILED counting").

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    1 +
 mm/migrate.c        |    3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory-failure.c~mm-when-migrate_pages-returns-0-all-pages-must-have-been-released mm/memory-failure.c
--- a/mm/memory-failure.c~mm-when-migrate_pages-returns-0-all-pages-must-have-been-released
+++ a/mm/memory-failure.c
@@ -1419,6 +1419,7 @@ int soft_offline_page(struct page *page,
 		ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL,
 								0, true);
 		if (ret) {
+			putback_lru_pages(&pagelist);
 			pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
 				pfn, ret, page->flags);
 			if (ret > 0)
diff -puN mm/migrate.c~mm-when-migrate_pages-returns-0-all-pages-must-have-been-released mm/migrate.c
--- a/mm/migrate.c~mm-when-migrate_pages-returns-0-all-pages-must-have-been-released
+++ a/mm/migrate.c
@@ -772,6 +772,7 @@ uncharge:
 unlock:
 	unlock_page(page);
 
+move_newpage:
 	if (rc != -EAGAIN) {
  		/*
  		 * A page that has been migrated has all references
@@ -785,8 +786,6 @@ unlock:
 		putback_lru_page(page);
 	}
 
-move_newpage:
