From: akpm@linux-foundation.org
Subject: [merged] mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:13:34 -0700
Message-ID: <20120801201334.F0E7D1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:41190 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUNg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:13:36 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5410915obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:13:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, minchan@kernel.org, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clear pages_scanned only if draining a pcp adds pages to the buddy allocator again
has been removed from the -mm tree.  Its filename was
     mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: mm: clear pages_scanned only if draining a pcp adds pages to the buddy allocator again

commit 2ff754fa8f ("mm: clear pages_scanned only if draining a pcp adds
pages to the buddy allocator again") fixed one free_pcppages_bulk()
misuse.  But two another miuse still exist.

This patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again mm/page_alloc.c
--- a/mm/page_alloc.c~mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again
+++ a/mm/page_alloc.c
@@ -1158,8 +1158,10 @@ void drain_zone_pages(struct zone *zone,
 		to_drain = pcp->batch;
 	else
 		to_drain = pcp->count;
-	free_pcppages_bulk(zone, to_drain, pcp);
-	pcp->count -= to_drain;
+	if (to_drain > 0) {
+		free_pcppages_bulk(zone, to_drain, pcp);
+		pcp->count -= to_drain;
+	}
 	local_irq_restore(flags);
 }
 #endif
@@ -3915,7 +3917,8 @@ static int __zone_pcp_update(void *data)
 		pcp = &pset->pcp;
 
 		local_irq_save(flags);
-		free_pcppages_bulk(zone, pcp->count, pcp);
+		if (pcp->count > 0)
+			free_pcppages_bulk(zone, pcp->count, pcp);
 		setup_pageset(pset, batch);
 		local_irq_restore(flags);
 	}
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch

