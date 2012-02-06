From: akpm@linux-foundation.org
Subject: [merged] mm-postpone-migrated-page-mapping-reset.patch removed from -mm tree
Date: Mon, 06 Feb 2012 12:31:19 -0800
Message-ID: <20120206203119.694B4A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:38571 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab2BFUbU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 15:31:20 -0500
Received: by yhgm50 with SMTP id m50so682825yhg.1
        for <mm-commits@vger.kernel.org>; Mon, 06 Feb 2012 12:31:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: postpone migrated page mapping reset
has been removed from the -mm tree.  Its filename was
     mm-postpone-migrated-page-mapping-reset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: postpone migrated page mapping reset

Postpone resetting page->mapping until the final remove_migration_ptes(). 
Otherwise the expression PageAnon(migration_entry_to_page(entry)) does not
work.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-postpone-migrated-page-mapping-reset mm/migrate.c
--- a/mm/migrate.c~mm-postpone-migrated-page-mapping-reset
+++ a/mm/migrate.c
@@ -445,7 +445,6 @@ void migrate_page_copy(struct page *newp
 	ClearPageSwapCache(page);
 	ClearPagePrivate(page);
 	set_page_private(page, 0);
-	page->mapping = NULL;
 
 	/*
 	 * If any waiters have accumulated on the new page then
@@ -667,6 +666,7 @@ static int move_to_new_page(struct page 
 	} else {
 		if (remap_swapcache)
 			remove_migration_ptes(page, newpage);
+		page->mapping = NULL;
 	}
 
 	unlock_page(newpage);
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-add-rss-counters-consistency-check.patch
mm-make-get_mm_counter-static-inline.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch

