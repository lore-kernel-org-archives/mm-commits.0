From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-show-node_pages_scanned-per-node-not-zone-fix.patch removed from -mm
 tree
Date: Thu, 28 Jul 2016 15:00:22 -0700
Message-ID: <579a8076.uW5X/FrFeO5c5XrT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbcG1WAX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:00:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix node_pages_scanned
has been removed from the -mm tree.  Its filename was
     mm-show-node_pages_scanned-per-node-not-zone-fix.patch

This patch was dropped because it was folded into mm-show-node_pages_scanned-per-node-not-zone.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: fix node_pages_scanned

Use pgdat for node stat instead of zone->pgdat.

Link: http://lkml.kernel.org/r/20160716101431.GA10305@bbox
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-show-node_pages_scanned-per-node-not-zone-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-show-node_pages_scanned-per-node-not-zone-fix
+++ a/mm/page_alloc.c
@@ -4336,7 +4336,7 @@ void show_free_areas(unsigned int filter
 			K(node_page_state(pgdat, NR_SHMEM)),
 			K(node_page_state(pgdat, NR_WRITEBACK_TEMP)),
 			K(node_page_state(pgdat, NR_UNSTABLE_NFS)),
-			node_page_state(zone->zone_pgdat, NR_PAGES_SCANNED),
+			node_page_state(pgdat, NR_PAGES_SCANNED),
 			!pgdat_reclaimable(pgdat) ? "yes" : "no");
 	}
 
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-page_alloc-fix-dirtyable-highmem-calculation.patch
mm-show-node_pages_scanned-per-node-not-zone.patch
mm-add-per-zone-lru-list-stat.patch
mm-bail-out-in-shrin_inactive_list.patch

