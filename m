From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-migratec-wrap-do_move_pages_to_node-and-store_status.patch added to -mm
 tree
Date: Thu, 13 Feb 2020 18:52:52 -0800
Message-ID: <20200214025252.ynXM-25HO%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727604AbgBNCwy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 Feb 2020 21:52:54 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com


The patch titled
     Subject: mm/migrate.c: wrap do_move_pages_to_node() and store_status()
has been added to the -mm tree.  Its filename is
     mm-migratec-wrap-do_move_pages_to_node-and-store_status.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migratec-wrap-do_move_pages_to_node-and-store_status.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migratec-wrap-do_move_pages_to_node-and-store_status.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1583,6 +1583,29 @@ out:
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
@@ -1626,21 +1649,8 @@ static int do_pages_move(struct mm_struc
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
@@ -1669,13 +1679,8 @@ static int do_pages_move(struct mm_struc
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
@@ -1685,16 +1690,8 @@ out_flush:
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

mm-sparsemem-get-address-to-page-struct-instead-of-address-to-pfn.patch
mm-migratec-no-need-to-check-for-i-start-in-do_pages_move.patch
mm-migratec-wrap-do_move_pages_to_node-and-store_status.patch
mm-migratec-check-pagelist-in-move_pages_and_store_status.patch
mm-migratec-unify-not-queued-for-migration-handling-in-do_pages_move.patch
