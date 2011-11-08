From: akpm@linux-foundation.org
Subject: + mm-migrate-one-less-atomic-operation.patch added to -mm tree
Date: Tue, 08 Nov 2011 14:57:14 -0800
Message-ID: <201111082257.pA8MvEjO001821@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:13132 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab1KHW5o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2011 17:57:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jacobo.giralt@gmail.com, jweiner@redhat.com, mel@csn.ul.ie, minchan.kim@gmail.com


The patch titled
     Subject: mm: migrate: one less atomic operation
has been added to the -mm tree.  Its filename is
     mm-migrate-one-less-atomic-operation.patch

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
From: Jacobo Giralt <jacobo.giralt@gmail.com>
Subject: mm: migrate: one less atomic operation

migrate_page_move_mapping() drops a reference from the old page after
unfreezing its counter.  Both operations can be merged into a single
atomic operation by directly unfreezing to one less reference.

The same applies to migrate_huge_page_move_mapping().

Signed-off-by: Jacobo Giralt <jacobo.giralt@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN mm/migrate.c~mm-migrate-one-less-atomic-operation mm/migrate.c
--- a/mm/migrate.c~mm-migrate-one-less-atomic-operation
+++ a/mm/migrate.c
@@ -269,12 +269,12 @@ static int migrate_page_move_mapping(str
 
 	radix_tree_replace_slot(pslot, newpage);
 
-	page_unfreeze_refs(page, expected_count);
 	/*
-	 * Drop cache reference from old page.
+	 * Drop cache reference from old page by unfreezing
+	 * to one less reference.
 	 * We know this isn't the last reference.
 	 */
-	__put_page(page);
+	page_unfreeze_refs(page, expected_count - 1);
 
 	/*
 	 * If moved to a different zone then also account
@@ -334,9 +334,7 @@ int migrate_huge_page_move_mapping(struc
 
 	radix_tree_replace_slot(pslot, newpage);
 
-	page_unfreeze_refs(page, expected_count);
