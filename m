From: akpm@linux-foundation.org
Subject: + memory-unplug-v7-isolate_lru_page-fix.patch added to -mm tree
Date: Fri, 06 Jul 2007 15:31:41 -0700
Message-ID: <200707062231.l66MVfvc024139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55111 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754715AbXGFWbv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 18:31:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, clameter@sgi.com


The patch titled
     memory unplug: isolate_lru_page fix
has been added to the -mm tree.  Its filename is
     memory-unplug-v7-isolate_lru_page-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: memory unplug: isolate_lru_page fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

release_pages() in mm/swap.c changes page_count() to be 0 without removing
PageLRU flag...

This means isolate_lru_page() can see a page, PageLRU() &&
page_count(page)==0..  This is BUG.  (get_page() will be called against
count=0 page.)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/migrate.c~memory-unplug-v7-isolate_lru_page-fix mm/migrate.c
--- a/mm/migrate.c~memory-unplug-v7-isolate_lru_page-fix
+++ a/mm/migrate.c
@@ -49,9 +49,8 @@ int isolate_lru_page(struct page *page, 
 		struct zone *zone = page_zone(page);
 
 		spin_lock_irq(&zone->lru_lock);
-		if (PageLRU(page)) {
+		if (PageLRU(page) && get_page_unless_zero(page)) {
 			ret = 0;
-			get_page(page);
 			ClearPageLRU(page);
 			if (PageActive(page))
 				del_page_from_active_list(zone, page);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-v6-zonelist-fix-2.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
memory-unplug-v7-migration-by-kernel.patch
memory-unplug-v7-isolate_lru_page-fix.patch
memory-unplug-v7-memory-hotplug-cleanup.patch
memory-unplug-v7-page-isolation.patch
memory-unplug-v7-page-offline.patch
memory-unplug-v7-ia64-interface.patch
