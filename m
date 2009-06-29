From: akpm@linux-foundation.org
Subject: + memory-hotplug-make-pages-from-movable-zone-always-isolatable.patch added to -mm tree
Date: Mon, 29 Jun 2009 12:49:54 -0700
Message-ID: <200906291949.n5TJnskH028775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753594AbZF2Tut (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 15:50:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, cl@linux-foundation.org, mel@csn.ul.ie, yakui.zhao@intel.com


The patch titled
     memory hotplug: make pages from movable zone always isolatable
has been added to the -mm tree.  Its filename is
     memory-hotplug-make-pages-from-movable-zone-always-isolatable.patch

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
@@ -4905,13 +4905,16 @@ int set_migratetype_isolate(struct page 
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

linux-next.patch
memory-hotplug-update-zone-pcp-at-memory-online.patch
memory-hotplug-exclude-isolated-page-from-pco-page-alloc.patch
memory-hotplug-make-pages-from-movable-zone-always-isolatable.patch
memory-hotplug-alloc-page-from-other-node-in-memory-online.patch
memory-hotplug-migrate-swap-cache-page.patch

