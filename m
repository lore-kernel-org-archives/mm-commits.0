From: akpm@linux-foundation.org
Subject: [merged]
 mm-move_pages-report-the-number-of-non-attempted-pages.patch removed from
 -mm tree
Date: Fri, 31 Jan 2020 15:16:48 -0800
Message-ID: <20200131231648.KiUlITy4c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXQu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:16:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com, stable@vger.kernel.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm: move_pages: report the number of non-attempted pages
has been removed from the -mm tree.  Its filename was
     mm-move_pages-report-the-number-of-non-attempted-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: move_pages: report the number of non-attempted pages

Since commit a49bd4d71637 ("mm, numa: rework do_pages_move"), the semantic
of move_pages() has changed to return the number of non-migrated pages if
they were result of a non-fatal reasons (usually a busy page).  This was
an unintentional change that hasn't been noticed except for LTP tests
which checked for the documented behavior.

There are two ways to go around this change.  We can even get back to the
original behavior and return -EAGAIN whenever migrate_pages is not able to
migrate pages due to non-fatal reasons.  Another option would be to simply
continue with the changed semantic and extend move_pages documentation to
clarify that -errno is returned on an invalid input or when migration
simply cannot succeed (e.g.  -ENOMEM, -EBUSY) or the number of pages that
couldn't have been migrated due to ephemeral reasons (e.g.  page is pinned
or locked for other reasons).

This patch implements the second option because this behavior is in place
for some time without anybody complaining and possibly new users depending
on it.  Also it allows to have a slightly easier error handling as the
caller knows that it is worth to retry when err > 0.

But since the new semantic would be aborted immediately if migration is
failed due to ephemeral reasons, need include the number of non-attempted
pages in the return value too.

Link: http://lkml.kernel.org/r/1580160527-109104-1-git-send-email-yang.shi@linux.alibaba.com
Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Wei Yang <richardw.yang@linux.intel.com>
Cc: <stable@vger.kernel.org>    [4.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~mm-move_pages-report-the-number-of-non-attempted-pages
+++ a/mm/migrate.c
@@ -1627,8 +1627,19 @@ static int do_pages_move(struct mm_struc
 			start = i;
 		} else if (node != current_node) {
 			err = do_move_pages_to_node(mm, &pagelist, current_node);
-			if (err)
+			if (err) {
+				/*
+				 * Positive err means the number of failed
+				 * pages to migrate.  Since we are going to
+				 * abort and return the number of non-migrated
+				 * pages, so need to incude the rest of the
+				 * nr_pages that have not been attempted as
+				 * well.
+				 */
+				if (err > 0)
+					err += nr_pages - i - 1;
 				goto out;
+			}
 			err = store_status(status, start, current_node, i - start);
 			if (err)
 				goto out;
@@ -1659,8 +1670,11 @@ static int do_pages_move(struct mm_struc
 			goto out_flush;
 
 		err = do_move_pages_to_node(mm, &pagelist, current_node);
-		if (err)
+		if (err) {
+			if (err > 0)
+				err += nr_pages - i - 1;
 			goto out;
+		}
 		if (i > start) {
 			err = store_status(status, start, current_node, i - start);
 			if (err)
@@ -1674,6 +1688,13 @@ out_flush:
 
 	/* Make sure we do not overwrite the existing error */
 	err1 = do_move_pages_to_node(mm, &pagelist, current_node);
+	/*
+	 * Don't have to report non-attempted pages here since:
+	 *     - If the above loop is done gracefully all pages have been
+	 *       attempted.
+	 *     - If the above loop is aborted it means a fatal error
+	 *       happened, should return ret.
+	 */
 	if (!err1)
 		err1 = store_status(status, start, current_node, i - start);
 	if (err >= 0)
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are
