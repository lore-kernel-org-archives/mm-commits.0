From: akpm@linux-foundation.org
Subject: [merged]
 mm-migratec-unify-not-queued-for-migration-handling-in-do_pages_move.patch
 removed from -mm tree
Date: Tue, 07 Apr 2020 18:56:50 -0700
Message-ID: <20200408015650.sjAKmvcI_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbgDHB4v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:56:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com


The patch titled
     Subject: mm/migrate.c: unify "not queued for migration" handling in do_pages_move()
has been removed from the -mm tree.  Its filename was
     mm-migratec-unify-not-queued-for-migration-handling-in-do_pages_move.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richardw.yang@linux.intel.com>
Subject: mm/migrate.c: unify "not queued for migration" handling in do_pages_move()

It can currently happen that we store the status of a page twice:
* Once we detect that it is already on the target node
* Once we moved a bunch of pages, and a page that's already on the
  target node is contained in the current interval.

Let's simplify the code and always call do_move_pages_to_node() in case we
did not queue a page for migration.  Note that pages that are already on
the target node are not added to the pagelist and are, therefore, ignored
by do_move_pages_to_node() - there is no functional change.

The status of such a page is now only stored once.

[david@redhat.com rephrase changelog]
Link: http://lkml.kernel.org/r/20200214003017.25558-5-richardw.yang@linux.intel.com
Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/mm/migrate.c~mm-migratec-unify-not-queued-for-migration-handling-in-do_pages_move
+++ a/mm/migrate.c
@@ -1683,18 +1683,16 @@ static int do_pages_move(struct mm_struc
 		err = add_page_for_migration(mm, addr, current_node,
 				&pagelist, flags & MPOL_MF_MOVE_ALL);
 
-		if (!err) {
-			/* The page is already on the target node */
-			err = store_status(status, i, current_node, 1);
-			if (err)
-				goto out_flush;
-			continue;
-		} else if (err > 0) {
+		if (err > 0) {
 			/* The page is successfully queued for migration */
 			continue;
 		}
 
-		err = store_status(status, i, err, 1);
+		/*
+		 * If the page is already on the target node (!err), store the
+		 * node, otherwise, store the err.
+		 */
+		err = store_status(status, i, err ? : current_node, 1);
 		if (err)
 			goto out_flush;
 
_

Patches currently in -mm which might be from richardw.yang@linux.intel.com are
