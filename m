From: akpm@linux-foundation.org
Subject: [merged] mm-remove-unevictable_migrate_page-function.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:54:38 -0800
Message-ID: <200912152154.nBFLsckQ015376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761271AbZLOVzL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:55:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, cl@linux-foundation.org, hugh.dickins@tiscali.co.uk, lee.schermerhorn@hp.com, mm-commits@vger.kernel.org


The patch titled
     mm: remove unevictable_migrate_page function
has been removed from the -mm tree.  Its filename was
     mm-remove-unevictable_migrate_page-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove unevictable_migrate_page function
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

unevictable_migrate_page() in mm/internal.h is a relic of the since
removed UNEVICTABLE_LRU Kconfig option.  This patch removes the function
and open codes the test in migrate_page_copy().

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   12 ------------
 mm/migrate.c  |    4 ++--
 2 files changed, 2 insertions(+), 14 deletions(-)

diff -puN mm/internal.h~mm-remove-unevictable_migrate_page-function mm/internal.h
--- a/mm/internal.h~mm-remove-unevictable_migrate_page-function
+++ a/mm/internal.h
@@ -63,18 +63,6 @@ static inline unsigned long page_order(s
 	return page_private(page);
 }
 
-/*
- * unevictable_migrate_page() called only from migrate_page_copy() to
- * migrate unevictable flag to new page.
- * Note that the old page has been isolated from the LRU lists at this
- * point so we don't need to worry about LRU statistics.
- */
-static inline void unevictable_migrate_page(struct page *new, struct page *old)
-{
-	if (TestClearPageUnevictable(old))
-		SetPageUnevictable(new);
-}
