From: akpm@linux-foundation.org
Subject: - setup_per_zone_pages_min-take-zone-lock-instead-of-zone-lru_lock.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:33:59 -0700
Message-ID: <200810202033.m9KKXxwc010739@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755384AbYJTUr7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:47:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerald.schaefer@de.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     setup_per_zone_pages_min(): take zone->lock instead of zone->lru_lock
has been removed from the -mm tree.  Its filename was
     setup_per_zone_pages_min-take-zone-lock-instead-of-zone-lru_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: setup_per_zone_pages_min(): take zone->lock instead of zone->lru_lock
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

This replaces zone->lru_lock in setup_per_zone_pages_min() with zone->lock.
There seems to be no need for the lru_lock anymore, but there is a need for
zone->lock instead, because that function may call move_freepages() via
setup_zone_migrate_reserve().

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Tested-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~setup_per_zone_pages_min-take-zone-lock-instead-of-zone-lru_lock mm/page_alloc.c
--- a/mm/page_alloc.c~setup_per_zone_pages_min-take-zone-lock-instead-of-zone-lru_lock
+++ a/mm/page_alloc.c
@@ -4242,7 +4242,7 @@ void setup_per_zone_pages_min(void)
 	for_each_zone(zone) {
 		u64 tmp;
 
-		spin_lock_irqsave(&zone->lru_lock, flags);
+		spin_lock_irqsave(&zone->lock, flags);
 		tmp = (u64)pages_min * zone->present_pages;
 		do_div(tmp, lowmem_pages);
 		if (is_highmem(zone)) {
@@ -4274,7 +4274,7 @@ void setup_per_zone_pages_min(void)
 		zone->pages_low   = zone->pages_min + (tmp >> 2);
 		zone->pages_high  = zone->pages_min + (tmp >> 1);
 		setup_zone_migrate_reserve(zone);
-		spin_unlock_irqrestore(&zone->lru_lock, flags);
+		spin_unlock_irqrestore(&zone->lock, flags);
 	}
 
 	/* update totalreserve_pages */
_

Patches currently in -mm which might be from gerald.schaefer@de.ibm.com are

origin.patch

