From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix.patch
 removed from -mm tree
Date: Thu, 05 Nov 2015 18:25:24 -0800
Message-ID: <563c0f94.nHXOXJGrU1kOqVHe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52393 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031154AbbKFCZZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 21:25:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, 00moses.alexander00@gmail.com, hannes@cmpxchg.org, mgorman@suse.de, mhocko@suse.cz, vbabka@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix.patch

This patch was dropped because it was folded into mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix

Make zone_pagecache_reclaimable() return ulong rather than long.  Negative
values are meainingless here and all zone_pagecache_reclaimable() callers
turn its retrun value into ulong anyway.

Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Alexandru Moise <00moses.alexander00@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix mm/vmscan.c
--- a/mm/vmscan.c~mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix
+++ a/mm/vmscan.c
@@ -3693,7 +3693,7 @@ static inline unsigned long zone_unmappe
 }
 
 /* Work out how many page cache pages we can reclaim in this reclaim_mode */
-static long zone_pagecache_reclaimable(struct zone *zone)
+static unsigned long zone_pagecache_reclaimable(struct zone *zone)
 {
 	unsigned long nr_pagecache_reclaimable;
 	unsigned long delta = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable.patch
mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix.patch
mm-vmstatc-uninline-node_page_state.patch
mm-vmstatc-uninline-node_page_state-fix.patch
mm-cmac-suppress-warning.patch
memcg-fix-thresholds-for-32b-architectures-fix-fix.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y-fix.patch

