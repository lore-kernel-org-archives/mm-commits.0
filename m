From: akpm@linux-foundation.org
Subject: + mm-compaction-cleanup-on-compaction_deferred.patch added to -mm tree
Date: Wed, 20 Jun 2012 13:53:36 -0700
Message-ID: <20120620205336.51D53A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:60614 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab2FTUxi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jun 2012 16:53:38 -0400
Received: by eeit10 with SMTP id t10so442539eei.1
        for <mm-commits@vger.kernel.org>; Wed, 20 Jun 2012 13:53:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shangw@linux.vnet.ibm.com, hannes@cmpxchg.org, minchan@kernel.org


The patch titled
     Subject: mm/compaction: cleanup on compaction_deferred
has been added to the -mm tree.  Its filename is
     mm-compaction-cleanup-on-compaction_deferred.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-cleanup-on-compaction_deferred include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-cleanup-on-compaction_deferred
+++ a/include/linux/compaction.h
@@ -77,7 +77,7 @@ static inline bool compaction_deferred(s
 	if (++zone->compact_considered > defer_limit)
 		zone->compact_considered = defer_limit;
 
-	return zone->compact_considered < (1UL << zone->compact_defer_shift);
+	return zone->compact_considered < defer_limit;
 }
 
 #else
@@ -104,7 +104,7 @@ static inline void defer_compaction(stru
 
 static inline bool compaction_deferred(struct zone *zone, int order)
 {
-	return 1;
+	return true;
 }
 
 #endif /* CONFIG_COMPACTION */
_
Subject: Subject: mm/compaction: cleanup on compaction_deferred

Patches currently in -mm which might be from shangw@linux.vnet.ibm.com are

mm-slab-remove-duplicate-check.patch
mm-buddy-cleanup-on-should_fail_alloc_page.patch
mm-compaction-cleanup-on-compaction_deferred.patch
mm-buddy-get-the-allownodes-for-dump-at-once.patch

