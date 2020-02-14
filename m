From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-migratec-unify-not-queued-for-migration-handling-in-do_pages_move.patch
 added to -mm tree
Date: Thu, 13 Feb 2020 18:52:56 -0800
Message-ID: <20200214025256.ajzs5tnNQ%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727604AbgBNCw5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 Feb 2020 21:52:57 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, richardw.yang@linux.intel.com


The patch titled
     Subject: mm/migrate.c: unify "not queued for migration" handling in do_pages_move()
has been added to the -mm tree.  Its filename is
     mm-migratec-unify-not-queued-for-migration-handling-in-do_pages_move.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migratec-unify-not-queued-for-migration-handling-in-do_pages_move.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migratec-unify-not-queued-for-migration-handling-in-do_pages_move.patch

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
@@ -1664,18 +1664,16 @@ static int do_pages_move(struct mm_struc
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

mm-sparsemem-get-address-to-page-struct-instead-of-address-to-pfn.patch
mm-migratec-no-need-to-check-for-i-start-in-do_pages_move.patch
mm-migratec-wrap-do_move_pages_to_node-and-store_status.patch
mm-migratec-check-pagelist-in-move_pages_and_store_status.patch
mm-migratec-unify-not-queued-for-migration-handling-in-do_pages_move.patch
