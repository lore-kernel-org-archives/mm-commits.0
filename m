From: akpm@linux-foundation.org
Subject: [merged] memory-hotplug-make-pages-from-movable-zone-always-isolatable.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:37:31 -0700
Message-ID: <200909222037.n8MKbVOI032008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752684AbZIVUmC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, cl@linux-foundation.org, mel@csn.ul.ie, yakui.zhao@intel.com, mm-commits@vger.kernel.org


The patch titled
     memory hotplug: make pages from movable zone always isolatable
has been removed from the -mm tree.  Its filename was
     memory-hotplug-make-pages-from-movable-zone-always-isolatable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory hotplug: make pages from movable zone always isolatable
From: Shaohua Li <shaohua.li@intel.com>

Pages on movable zone have two types, MIGRATE_MOVABLE and MIGRATE_RESERVE,
both them can be movable, because only movable memory allocation can get
pages from movable zone.  This makes pages in movable zone always be able
to migrate.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Yakui Zhao <yakui.zhao@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~memory-hotplug-make-pages-from-movable-zone-always-isolatable mm/page_alloc.c
--- a/mm/page_alloc.c~memory-hotplug-make-pages-from-movable-zone-always-isolatable
+++ a/mm/page_alloc.c
@@ -4906,13 +4906,16 @@ int set_migratetype_isolate(struct page 
 	struct zone *zone;
 	unsigned long flags;
 	int ret = -EBUSY;
+	int zone_idx;
 
 	zone = page_zone(page);
+	zone_idx = zone_idx(zone);
 	spin_lock_irqsave(&zone->lock, flags);
 	/*
 	 * In future, more migrate types will be able to be isolation target.
 	 */
-	if (get_pageblock_migratetype(page) != MIGRATE_MOVABLE)
+	if (get_pageblock_migratetype(page) != MIGRATE_MOVABLE &&
+	    zone_idx != ZONE_MOVABLE)
 		goto out;
 	set_pageblock_migratetype(page, MIGRATE_ISOLATE);
 	move_freepages_block(zone, page, MIGRATE_ISOLATE);
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch

