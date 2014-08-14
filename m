From: akpm@linux-foundation.org
Subject: + mm-page_alloc-determine-migratetype-only-once.patch added to
 -mm tree
Date: Thu, 14 Aug 2014 14:43:49 -0700
Message-ID: <53ed2d95.aSJxZW/LCs3JfJ9x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:57890 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbaHNVnu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Aug 2014 17:43:50 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so484425pab.2
        for <mm-commits@vger.kernel.org>; Thu, 14 Aug 2014 14:43:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, minchan@kernel.org, riel@redhat.com, rientjes@google.com, srivatsa.bhat@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: determine migratetype only once
has been added to the -mm tree.  Its filename is
     mm-page_alloc-determine-migratetype-only-once.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-determine-migratetype-only-once.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-determine-migratetype-only-once.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm: page_alloc: determine migratetype only once

The check for ALLOC_CMA in __alloc_pages_nodemask() derives migratetype
from gfp_mask in each retry pass, although the migratetype variable
already has the value determined and it does not change.  Use the variable
and perform the check only once.  Also convert #ifdef CONFIC_CMA to
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
@@ -2775,6 +2775,9 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	if (unlikely(!zonelist->_zonerefs->zone))
 		return NULL;
 
+	if (IS_ENABLED(CONFIG_CMA) && migratetype == MIGRATE_MOVABLE)
+		alloc_flags |= ALLOC_CMA;
+
 retry_cpuset:
 	cpuset_mems_cookie = read_mems_allowed_begin();
 
@@ -2786,10 +2789,6 @@ retry_cpuset:
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
mm-page_alloc-determine-migratetype-only-once.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch

