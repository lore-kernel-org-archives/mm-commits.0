From: akpm@linux-foundation.org
Subject: + mm-compaction-add-the-ultimate-direct-compaction-priority.patch added to -mm tree
Date: Thu, 11 Aug 2016 14:29:49 -0700
Message-ID: <57acee4d.j+MHVcP7wjoTnban%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbcHKV3u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 17:29:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: add the ultimate direct compaction priority
has been added to the -mm tree.  Its filename is
     mm-compaction-add-the-ultimate-direct-compaction-priority.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-add-the-ultimate-direct-compaction-priority.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-add-the-ultimate-direct-compaction-priority.patch

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
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
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
+		.whole_zone = (prio == COMPACT_PRIO_SYNC_FULL),
+		.ignore_skip_hint = (prio == COMPACT_PRIO_SYNC_FULL)
 	};
 	INIT_LIST_HEAD(&cc.freepages);
 	INIT_LIST_HEAD(&cc.migratepages);
@@ -1689,7 +1691,8 @@ enum compact_result try_to_compact_pages
 								ac->nodemask) {
 		enum compact_result status;
 
-		if (compaction_deferred(zone, order)) {
+		if (prio > COMPACT_PRIO_SYNC_FULL
+					&& compaction_deferred(zone, order)) {
 			rc = max_t(enum compact_result, COMPACT_DEFERRED, rc);
 			continue;
 		}
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions.patch
mm-compaction-cleanup-unused-functions.patch
mm-compaction-rename-compact_partial-to-compact_success.patch
mm-compaction-dont-recheck-watermarks-after-compact_success.patch
mm-compaction-add-the-ultimate-direct-compaction-priority.patch
mm-compaction-more-reliably-increase-direct-compaction-priority.patch
mm-compaction-use-correct-watermark-when-checking-compaction-success.patch
mm-compaction-create-compact_gap-wrapper.patch
mm-compaction-use-proper-alloc_flags-in-__compaction_suitable.patch
mm-compaction-require-only-min-watermarks-for-non-costly-orders.patch
mm-vmscan-make-compaction_ready-more-accurate-and-readable.patch

