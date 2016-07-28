From: akpm@linux-foundation.org
Subject: [patch 048/101] mm: vmstat: replace __count_zone_vm_events with a zone id equivalent
Date: Thu, 28 Jul 2016 15:46:56 -0700
Message-ID: <579a8b60.dR5EmCv+qQsClHq+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57007 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbcG1Wq6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:46:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, riel@surriel.com, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm: vmstat: replace __count_zone_vm_events with a zone id equivalent

This is partially a preparation patch for more vmstat work but it also has
the slight advantage that __count_zid_vm_events is cheaper to calculate
than __count_zone_vm_events().

Link: http://lkml.kernel.org/r/1467970510-21195-32-git-send-email-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |    5 ++---
 mm/page_alloc.c        |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN include/linux/vmstat.h~mm-vmstat-replace-__count_zone_vm_events-with-a-zone-id-equivalent include/linux/vmstat.h
--- a/include/linux/vmstat.h~mm-vmstat-replace-__count_zone_vm_events-with-a-zone-id-equivalent
+++ a/include/linux/vmstat.h
@@ -101,9 +101,8 @@ static inline void vm_events_fold_cpu(in
 #define count_vm_vmacache_event(x) do {} while (0)
 #endif
 
-#define __count_zone_vm_events(item, zone, delta) \
-		__count_vm_events(item##_NORMAL - ZONE_NORMAL + \
-		zone_idx(zone), delta)
+#define __count_zid_vm_events(item, zid, delta) \
+	__count_vm_events(item##_NORMAL - ZONE_NORMAL + zid, delta)
 
 /*
  * Zone and node-based page accounting with per cpu differentials.
diff -puN mm/page_alloc.c~mm-vmstat-replace-__count_zone_vm_events-with-a-zone-id-equivalent mm/page_alloc.c
--- a/mm/page_alloc.c~mm-vmstat-replace-__count_zone_vm_events-with-a-zone-id-equivalent
+++ a/mm/page_alloc.c
@@ -2616,7 +2616,7 @@ struct page *buffered_rmqueue(struct zon
 					  get_pcppage_migratetype(page));
 	}
 
-	__count_zone_vm_events(PGALLOC, zone, 1 << order);
+	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
 	zone_statistics(preferred_zone, zone, gfp_flags);
 	local_irq_restore(flags);
 
_
