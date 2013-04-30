From: akpm@linux-foundation.org
Subject: [merged] mm-rewrite-the-comment-over-migrate_pages-more-comprehensibly.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:49:10 -0700
Message-ID: <20130430184910.7F00831C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:40470 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab3D3StL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:49:11 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so85038ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:49:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srivatsa.bhat@linux.vnet.ibm.com, cl@linux.com, hughd@google.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rewrite the comment over migrate_pages() more comprehensibly
has been removed from the -mm tree.  Its filename was
     mm-rewrite-the-comment-over-migrate_pages-more-comprehensibly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: mm: rewrite the comment over migrate_pages() more comprehensibly

The comment over migrate_pages() looks quite weird, and makes it hard
to grasp what it is trying to say. Rewrite it more comprehensibly.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff -puN mm/migrate.c~mm-rewrite-the-comment-over-migrate_pages-more-comprehensibly mm/migrate.c
--- a/mm/migrate.c~mm-rewrite-the-comment-over-migrate_pages-more-comprehensibly
+++ a/mm/migrate.c
@@ -973,19 +973,23 @@ out:
 }
 
 /*
- * migrate_pages
+ * migrate_pages - migrate the pages specified in a list, to the free pages
+ *		   supplied as the target for the page migration
  *
- * The function takes one list of pages to migrate and a function
- * that determines from the page to be migrated and the private data
- * the target of the move and allocates the page.
+ * @from:		The list of pages to be migrated.
+ * @get_new_page:	The function used to allocate free pages to be used
+ *			as the target of the page migration.
+ * @private:		Private data to be passed on to get_new_page()
+ * @mode:		The migration mode that specifies the constraints for
+ *			page migration, if any.
+ * @reason:		The reason for page migration.
  *
- * The function returns after 10 attempts or if no pages
- * are movable anymore because to has become empty
- * or no retryable pages exist anymore.
- * Caller should call putback_lru_pages to return pages to the LRU
+ * The function returns after 10 attempts or if no pages are movable any more
+ * because the list has become empty or no retryable pages exist any more.
+ * The caller should call putback_lru_pages() to return pages to the LRU
  * or free list only if ret != 0.
  *
- * Return: Number of pages not migrated or error code.
+ * Returns the number of pages that were not migrated, or an error code.
  */
 int migrate_pages(struct list_head *from, new_page_t get_new_page,
 		unsigned long private, enum migrate_mode mode, int reason)
_

Patches currently in -mm which might be from srivatsa.bhat@linux.vnet.ibm.com are

origin.patch
linux-next.patch
lockdep-introduce-lock_acquire_exclusive-shared-helper-macros.patch
lglock-update-lockdep-annotations-to-report-recursive-local-locks.patch

