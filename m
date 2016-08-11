From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-fix-wrong-initialization-when-sysctl_min_unmapped_ratio-changes.patch removed from -mm tree
Date: Thu, 11 Aug 2016 11:36:06 -0700
Message-ID: <57acc596.2gNn5xnc56NJcTWR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50699 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbcHKSgH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 14:36:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, hannes@cmpxchg.org, mgorman@techsingularity.net, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: fix wrong initialization when sysctl_min_unmapped_ratio changes
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-wrong-initialization-when-sysctl_min_unmapped_ratio-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_alloc.c: fix wrong initialization when sysctl_min_unmapped_ratio changes

Before resetting min_unmapped_pages, we need to initialize
min_unmapped_pages rather than min_slab_pages.

Fixes: a5f5f91da6 (mm: convert zone_reclaim to node_reclaim)
Link: http://lkml.kernel.org/r/1470724248-26780-1-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-fix-wrong-initialization-when-sysctl_min_unmapped_ratio-changes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fix-wrong-initialization-when-sysctl_min_unmapped_ratio-changes
+++ a/mm/page_alloc.c
@@ -6854,7 +6854,7 @@ int sysctl_min_unmapped_ratio_sysctl_han
 		return rc;
 
 	for_each_online_pgdat(pgdat)
-		pgdat->min_slab_pages = 0;
+		pgdat->min_unmapped_pages = 0;
 
 	for_each_zone(zone)
 		zone->zone_pgdat->min_unmapped_pages += (zone->managed_pages *
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are


