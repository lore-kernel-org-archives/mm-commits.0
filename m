From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-cleanup-on-compaction_deferred.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:13:27 -0700
Message-ID: <20120801201328.249135C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:51698 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUN3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:13:29 -0400
Received: by mail-ey0-f202.google.com with SMTP id o12so293205eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:13:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shangw@linux.vnet.ibm.com, hannes@cmpxchg.org, minchan@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: cleanup on compaction_deferred
has been removed from the -mm tree.  Its filename was
     mm-compaction-cleanup-on-compaction_deferred.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: mm/compaction: cleanup on compaction_deferred

When CONFIG_COMPACTION is enabled, compaction_deferred() tries to
recalculate the deferred limit again, which isn't necessary.

When CONFIG_COMPACTION is disabled, compaction_deferred() should return
"true" or "false" since it has "bool" for its return value.

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-cleanup-on-compaction_deferred include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-cleanup-on-compaction_deferred
+++ a/include/linux/compaction.h
@@ -58,7 +58,7 @@ static inline bool compaction_deferred(s
 	if (++zone->compact_considered > defer_limit)
 		zone->compact_considered = defer_limit;
 
-	return zone->compact_considered < (1UL << zone->compact_defer_shift);
+	return zone->compact_considered < defer_limit;
 }
 
 #else
@@ -85,7 +85,7 @@ static inline void defer_compaction(stru
 
 static inline bool compaction_deferred(struct zone *zone, int order)
 {
-	return 1;
+	return true;
 }
 
 #endif /* CONFIG_COMPACTION */
_

Patches currently in -mm which might be from shangw@linux.vnet.ibm.com are

origin.patch
mm-slab-remove-duplicate-check.patch

