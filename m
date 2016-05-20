From: akpm@linux-foundation.org
Subject: [patch 009/162] mm, compaction: update compaction_result ordering
Date: Fri, 20 May 2016 16:56:50 -0700
Message-ID: <573fa442.jp6fr09D5qWd2VzL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbcETX4w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:56:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, js1304@gmail.com, mgorman@techsingularity.net, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vbabka@suse.cz, vdavydov@virtuozzo.com

From: Michal Hocko <mhocko@suse.com>
Subject: mm, compaction: update compaction_result ordering

compaction_result will be used as the primary feedback channel for
compaction users.  At the same time try_to_compact_pages (and potentially
others) assume a certain ordering where a more specific feedback takes
precendence.  This gets a bit awkward when we have conflicting feedback
from different zones.  E.g one returing COMPACT_COMPLETE meaning the full
zone has been scanned without any outcome while other returns with
COMPACT_PARTIAL aka made some progress.  The caller should get
COMPACT_PARTIAL because that means that the compaction still can make some
progress.  The same applies for COMPACT_PARTIAL vs. 
COMPACT_PARTIAL_SKIPPED.  Reorder PARTIAL to be the largest one so the
larger the value is the more progress we have done.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-update-compaction_result-ordering include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-update-compaction_result-ordering
+++ a/include/linux/compaction.h
@@ -4,6 +4,8 @@
 /* Return values for compact_zone() and try_to_compact_pages() */
 /* When adding new states, please adjust include/trace/events/compaction.h */
 enum compact_result {
+	/* For more detailed tracepoint output - internal to compaction */
+	COMPACT_NOT_SUITABLE_ZONE,
 	/*
 	 * compaction didn't start as it was not possible or direct reclaim
 	 * was more suitable
@@ -11,30 +13,34 @@ enum compact_result {
 	COMPACT_SKIPPED,
 	/* compaction didn't start as it was deferred due to past failures */
 	COMPACT_DEFERRED,
+
 	/* compaction not active last round */
 	COMPACT_INACTIVE = COMPACT_DEFERRED,
 
+	/* For more detailed tracepoint output - internal to compaction */
+	COMPACT_NO_SUITABLE_PAGE,
 	/* compaction should continue to another pageblock */
 	COMPACT_CONTINUE,
+
 	/*
-	 * direct compaction partially compacted a zone and there are suitable
-	 * pages
+	 * The full zone was compacted scanned but wasn't successfull to compact
+	 * suitable pages.
 	 */
-	COMPACT_PARTIAL,
+	COMPACT_COMPLETE,
 	/*
 	 * direct compaction has scanned part of the zone but wasn't successfull
 	 * to compact suitable pages.
 	 */
 	COMPACT_PARTIAL_SKIPPED,
+
+	/* compaction terminated prematurely due to lock contentions */
+	COMPACT_CONTENDED,
+
 	/*
-	 * The full zone was compacted scanned but wasn't successfull to compact
-	 * suitable pages.
+	 * direct compaction partially compacted a zone and there might be
+	 * suitable pages
 	 */
-	COMPACT_COMPLETE,
-	/* For more detailed tracepoint output */
-	COMPACT_NO_SUITABLE_PAGE,
-	COMPACT_NOT_SUITABLE_ZONE,
-	COMPACT_CONTENDED,
+	COMPACT_PARTIAL,
 };
 
 /* Used to signal whether compaction detected need_sched() or lock contention */
_
