From: akpm@linux-foundation.org
Subject: [merged]
 mm-migratec-wrap-do_move_pages_to_node-and-store_status.patch removed from
 -mm tree
Date: Tue, 07 Apr 2020 18:56:46 -0700
Message-ID: <20200408015646.4HPnopLJv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbgDHB4s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:56:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com


The patch titled
     Subject: mm/migrate.c: wrap do_move_pages_to_node() and store_status()
has been removed from the -mm tree.  Its filename was
     mm-migratec-wrap-do_move_pages_to_node-and-store_status.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: mm/migrate.c: wrap do_move_pages_to_node() and store_status()

Usually, do_move_pages_to_node() and store_status() are used in
combination.  We have three similar call sites.

Let's provide a wrapper for both function calls -
move_pages_and_store_status - to make the calling code easier to maintain
and fix (as noted by Yang Shi, the return value handling of
do_move_pages_to_node() has a flaw).

[david@redhat.com rephrase changelog]
Link: http://lkml.kernel.org/r/20200214003017.25558-3-richardw.yang@linux.intel.com
Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   61 +++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 32 deletions(-)

--- a/mm/migrate.c~mm-migratec-wrap-do_move_pages_to_node-and-store_status
+++ a/mm/migrate.c
@@ -1602,6 +1602,29 @@ out:
 	return err;
 }
 
+static int move_pages_and_store_status(struct mm_struct *mm, int node,
+		struct list_head *pagelist, int __user *status,
+		int start, int i, unsigned long nr_pages)
+{
+	int err;
+
+	err = do_move_pages_to_node(mm, pagelist, node);
+	if (err) {
+		/*
+		 * Positive err means the number of failed
+		 * pages to migrate.  Since we are going to
+		 * abort and return the number of non-migrated
+		 * pages, so need to incude the rest of the
+		 * nr_pages that have not been attempted as
+		 * well.
+		 */
+		if (err > 0)
+			err += nr_pages - i - 1;
+		return err;
+	}
+	return store_status(status, start, node, i - start);
+}
+
 /*
  * Migrate an array of page address onto an array of nodes and fill
  * the corresponding array of status.
@@ -1645,21 +1668,8 @@ static int do_pages_move(struct mm_struc
 			current_node = node;
 			start = i;
 		} else if (node != current_node) {
-			err = do_move_pages_to_node(mm, &pagelist, current_node);
-			if (err) {
-				/*
-				 * Positive err means the number of failed
-				 * pages to migrate.  Since we are going to
-				 * abort and return the number of non-migrated
-				 * pages, so need to incude the rest of the
-				 * nr_pages that have not been attempted as
-				 * well.
-				 */
-				if (err > 0)
-					err += nr_pages - i - 1;
-				goto out;
-			}
-			err = store_status(status, start, current_node, i - start);
+			err = move_pages_and_store_status(mm, current_node,
+					&pagelist, status, start, i, nr_pages);
 			if (err)
 				goto out;
 			start = i;
@@ -1688,13 +1698,8 @@ static int do_pages_move(struct mm_struc
 		if (err)
 			goto out_flush;
 
-		err = do_move_pages_to_node(mm, &pagelist, current_node);
-		if (err) {
-			if (err > 0)
-				err += nr_pages - i - 1;
-			goto out;
-		}
-		err = store_status(status, start, current_node, i - start);
+		err = move_pages_and_store_status(mm, current_node, &pagelist,
+				status, start, i, nr_pages);
 		if (err)
 			goto out;
 		current_node = NUMA_NO_NODE;
@@ -1704,16 +1709,8 @@ out_flush:
 		return err;
 
 	/* Make sure we do not overwrite the existing error */
-	err1 = do_move_pages_to_node(mm, &pagelist, current_node);
-	/*
-	 * Don't have to report non-attempted pages here since:
-	 *     - If the above loop is done gracefully all pages have been
-	 *       attempted.
-	 *     - If the above loop is aborted it means a fatal error
-	 *       happened, should return ret.
-	 */
-	if (!err1)
-		err1 = store_status(status, start, current_node, i - start);
+	err1 = move_pages_and_store_status(mm, current_node, &pagelist,
+				status, start, i, nr_pages);
 	if (err >= 0)
 		err = err1;
 out:
_

Patches currently in -mm which might be from richardw.yang@linux.intel.com are
