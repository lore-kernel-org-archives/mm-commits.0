From: akpm@linux-foundation.org
Subject: + mm-postpone-migrated-page-mapping-reset.patch added to -mm tree
Date: Wed, 18 Jan 2012 15:22:03 -0800
Message-ID: <20120118232204.7BA245C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:54922 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab2ARXWG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2012 18:22:06 -0500
Received: by eekb15 with SMTP id b15so139703eek.1
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2012 15:22:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     Subject: mm: postpone migrated page mapping reset
has been added to the -mm tree.  Its filename is
     mm-postpone-migrated-page-mapping-reset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: mm: postpone migrated page mapping reset

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-fix-rss-count-leakage-during-migration.patch
mm-add-rss-counters-consistency-check.patch
mm-postpone-migrated-page-mapping-reset.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch

