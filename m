From: akpm@linux-foundation.org
Subject: [patch 020/127] mm, compaction: add the ultimate direct
 compaction priority
Date: Fri, 07 Oct 2016 16:57:47 -0700
Message-ID: <57f8367b.1llwX6gkFeBHyu4R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38885 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbcJGX5t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:57:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vbabka@suse.cz, iamjoonsoo.kim@lge.com, lstoakes@gmail.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, rientjes@google.com

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: add the ultimate direct compaction priority

During reclaim/compaction loop, it's desirable to get a final answer from
unsuccessful compaction so we can either fail the allocation or invoke the
OOM killer.  However, heuristics such as deferred compaction or pageblock
skip bits can cause compaction to skip parts or whole zones and lead to
premature OOM's, failures or excessive reclaim/compaction retries.

To remedy this, we introduce a new direct compaction priority called
COMPACT_PRIO_SYNC_FULL, which instructs direct compaction to:

- ignore deferred compaction status for a zone
- ignore pageblock skip hints
- ignore cached scanner positions and scan the whole zone

The new priority should get eventually picked up by should_compact_retry()
and this should improve success rates for costly allocations using
__GFP_REPEAT, such as hugetlbfs allocations, and reduce some corner-case
OOM's for non-costly allocations.

Link: http://lkml.kernel.org/r/20160810091226.6709-6-vbabka@suse.cz
[vbabka@suse.cz: use the MIN_COMPACT_PRIORITY alias]
  Link: http://lkml.kernel.org/r/d443b884-87e7-1c93-8684-3a3a35759fb1@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    3 ++-
 mm/compaction.c            |    5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-add-the-ultimate-direct-compaction-priority include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-add-the-ultimate-direct-compaction-priority
+++ a/include/linux/compaction.h
@@ -6,8 +6,9 @@
  * Lower value means higher priority, analogically to reclaim priority.
  */
 enum compact_priority {
+	COMPACT_PRIO_SYNC_FULL,
+	MIN_COMPACT_PRIORITY = COMPACT_PRIO_SYNC_FULL,
 	COMPACT_PRIO_SYNC_LIGHT,
-	MIN_COMPACT_PRIORITY = COMPACT_PRIO_SYNC_LIGHT,
 	DEF_COMPACT_PRIORITY = COMPACT_PRIO_SYNC_LIGHT,
 	COMPACT_PRIO_ASYNC,
 	INIT_COMPACT_PRIORITY = COMPACT_PRIO_ASYNC
diff -puN mm/compaction.c~mm-compaction-add-the-ultimate-direct-compaction-priority mm/compaction.c
--- a/mm/compaction.c~mm-compaction-add-the-ultimate-direct-compaction-priority
+++ a/mm/compaction.c
@@ -1644,6 +1644,8 @@ static enum compact_result compact_zone_
 		.alloc_flags = alloc_flags,
 		.classzone_idx = classzone_idx,
 		.direct_compaction = true,
+		.whole_zone = (prio == MIN_COMPACT_PRIORITY),
+		.ignore_skip_hint = (prio == MIN_COMPACT_PRIORITY)
 	};
 	INIT_LIST_HEAD(&cc.freepages);
 	INIT_LIST_HEAD(&cc.migratepages);
@@ -1689,7 +1691,8 @@ enum compact_result try_to_compact_pages
 								ac->nodemask) {
 		enum compact_result status;
 
-		if (compaction_deferred(zone, order)) {
+		if (prio > MIN_COMPACT_PRIORITY
+					&& compaction_deferred(zone, order)) {
 			rc = max_t(enum compact_result, COMPACT_DEFERRED, rc);
 			continue;
 		}
_
