From: akpm@linux-foundation.org
Subject: [merged]
 mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable.patch removed
 from -mm tree
Date: Fri, 06 Nov 2015 12:08:44 -0800
Message-ID: <563d08cc.JuwELrWrq3lc/EQf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966427AbbKFUIp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:08:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 00moses.alexander00@gmail.com, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.com, vbabka@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: fix types of some locals
has been removed from the -mm tree.  Its filename was
     mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandru Moise <00moses.alexander00@gmail.com>
Subject: mm/vmscan.c: fix types of some locals

In zone_reclaimable_pages(), `nr' is returned by a function which is
declared as returning "unsigned long", so declare it such.  Negative
values are meaningless here.

In zone_pagecache_reclaimable() we should also declare `delta' and
`nr_pagecache_reclaimable' as being unsigned longs because they're used to
store the values returned by zone_page_state() and
zone_unmapped_file_pages() which also happen to return unsigned integers.

[akpm@linux-foundation.org: make zone_pagecache_reclaimable() return ulong rather than long]
Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/vmscan.c~mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable mm/vmscan.c
--- a/mm/vmscan.c~mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable
+++ a/mm/vmscan.c
@@ -194,7 +194,7 @@ static bool sane_reclaim(struct scan_con
 
 static unsigned long zone_reclaimable_pages(struct zone *zone)
 {
-	int nr;
+	unsigned long nr;
 
 	nr = zone_page_state(zone, NR_ACTIVE_FILE) +
 	     zone_page_state(zone, NR_INACTIVE_FILE);
@@ -3693,10 +3693,10 @@ static inline unsigned long zone_unmappe
 }
 
 /* Work out how many page cache pages we can reclaim in this reclaim_mode */
-static long zone_pagecache_reclaimable(struct zone *zone)
+static unsigned long zone_pagecache_reclaimable(struct zone *zone)
 {
-	long nr_pagecache_reclaimable;
-	long delta = 0;
+	unsigned long nr_pagecache_reclaimable;
+	unsigned long delta = 0;
 
 	/*
 	 * If RECLAIM_UNMAP is set, then all file pages are considered
_

Patches currently in -mm which might be from 00moses.alexander00@gmail.com are


