From: akpm@linux-foundation.org
Subject: [patch 006/162] mm, compaction: cover all compaction mode in
 compact_zone
Date: Fri, 20 May 2016 16:56:41 -0700
Message-ID: <573fa439.OsTtWdwI+gqDb9zo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbcETX4m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:56:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, js1304@gmail.com, mgorman@techsingularity.net, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vbabka@suse.cz, vdavydov@virtuozzo.com

From: Michal Hocko <mhocko@suse.com>
Subject: mm, compaction: cover all compaction mode in compact_zone

The compiler is complaining after "mm, compaction: change COMPACT_
constants into enum"

mm/compaction.c: In function `compact_zone':
mm/compaction.c:1350:2: warning: enumeration value `COMPACT_DEFERRED' not handled in switch [-Wswitch]
  switch (ret) {
  ^
mm/compaction.c:1350:2: warning: enumeration value `COMPACT_COMPLETE' not handled in switch [-Wswitch]
mm/compaction.c:1350:2: warning: enumeration value `COMPACT_NO_SUITABLE_PAGE' not handled in switch [-Wswitch]
mm/compaction.c:1350:2: warning: enumeration value `COMPACT_NOT_SUITABLE_ZONE' not handled in switch [-Wswitch]
mm/compaction.c:1350:2: warning: enumeration value `COMPACT_CONTENDED' not handled in switch [-Wswitch]

compaction_suitable is allowed to return only COMPACT_PARTIAL,
COMPACT_SKIPPED and COMPACT_CONTINUE so other cases are simply
impossible. Put a VM_BUG_ON to catch an impossible return value.

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

 mm/compaction.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN mm/compaction.c~mm-compaction-cover-all-compaction-mode-in-compact_zone mm/compaction.c
--- a/mm/compaction.c~mm-compaction-cover-all-compaction-mode-in-compact_zone
+++ a/mm/compaction.c
@@ -1383,15 +1383,12 @@ static enum compact_result compact_zone(
 
 	ret = compaction_suitable(zone, cc->order, cc->alloc_flags,
 							cc->classzone_idx);
-	switch (ret) {
-	case COMPACT_PARTIAL:
-	case COMPACT_SKIPPED:
-		/* Compaction is likely to fail */
+	/* Compaction is likely to fail */
+	if (ret == COMPACT_PARTIAL || ret == COMPACT_SKIPPED)
 		return ret;
-	case COMPACT_CONTINUE:
-		/* Fall through to compaction */
-		;
-	}
+
+	/* huh, compaction_suitable is returning something unexpected */
+	VM_BUG_ON(ret != COMPACT_CONTINUE);
 
 	/*
 	 * Clear pageblock skip if there were failures recently and compaction
_
