From: akpm@linux-foundation.org
Subject: [merged] mm-migrate-one-less-atomic-operation.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:26:32 -0800
Message-ID: <20120111212632.9D4C41E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:40505 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab2AKV0d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:26:33 -0500
Received: by mail-yx0-f202.google.com with SMTP id m1so7293yen.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:26:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jacobo.giralt@gmail.com, jweiner@redhat.com, mel@csn.ul.ie, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: migrate: one less atomic operation
has been removed from the -mm tree.  Its filename was
     mm-migrate-one-less-atomic-operation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
