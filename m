From: akpm@linux-foundation.org
Subject: + mm-when-migrate_pages-returns-0-all-pages-must-have-been-released.patch added to -mm tree
Date: Wed, 26 Jan 2011 15:10:32 -0800
Message-ID: <201101262310.p0QNAXwG010228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753537Ab1AZXLh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Jan 2011 18:11:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, cl@linux.com, mel@csn.ul.ie, minchan.kim@gmail.com


The patch titled
     mm: when migrate_pages returns 0, all pages must have been released
has been added to the -mm tree.  Its filename is
     mm-when-migrate_pages-returns-0-all-pages-must-have-been-released.patch

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
