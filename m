From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-determine-migratetype-only-once.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 11:19:19 -0700
Message-ID: <543c17a7.nH8oLvMIqnqUTGHV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60272 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbaJMSTT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:19:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, minchan@kernel.org, riel@redhat.com, rientjes@google.com, srivatsa.bhat@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: determine migratetype only once
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-determine-migratetype-only-once.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: page_alloc: determine migratetype only once

The check for ALLOC_CMA in __alloc_pages_nodemask() derives migratetype
from gfp_mask in each retry pass, although the migratetype variable
already has the value determined and it does not change.  Use the variable
and perform the check only once.  Also convert #ifdef CONFIG_CMA to
IS_ENABLED.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-determine-migratetype-only-once mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-determine-migratetype-only-once
+++ a/mm/page_alloc.c
@@ -2776,6 +2776,9 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	if (unlikely(!zonelist->_zonerefs->zone))
 		return NULL;
 
+	if (IS_ENABLED(CONFIG_CMA) && migratetype == MIGRATE_MOVABLE)
+		alloc_flags |= ALLOC_CMA;
+
 retry_cpuset:
 	cpuset_mems_cookie = read_mems_allowed_begin();
 
@@ -2787,10 +2790,6 @@ retry_cpuset:
 		goto out;
 	classzone_idx = zonelist_zone_idx(preferred_zoneref);
 
-#ifdef CONFIG_CMA
-	if (allocflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
-		alloc_flags |= ALLOC_CMA;
-#endif
 	/* First allocation attempt */
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
 			zonelist, high_zoneidx, alloc_flags,
_

Patches currently in -mm which might be from vbabka@suse.cz are

origin.patch

