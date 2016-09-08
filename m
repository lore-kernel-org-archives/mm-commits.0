From: akpm@linux-foundation.org
Subject: +
 mm-compaction-make-full-priority-ignore-pageblock-suitability.patch added
 to -mm tree
Date: Thu, 08 Sep 2016 16:41:14 -0700
Message-ID: <57d1f71a.Fj6hADSTAjF85HD4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47502 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751672AbcIHXlQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2016 19:41:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, Ralf-Peter.Rohbeck@quantum.com, a.miskiewicz@gmail.com, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@kernel.org, mhocko@suse.com, olaf@aepfle.de, penguin-kernel@i-love.sakura.ne.jp, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: make full priority ignore pageblock suitability
has been added to the -mm tree.  Its filename is
     mm-compaction-make-full-priority-ignore-pageblock-suitability.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-make-full-priority-ignore-pageblock-suitability.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-make-full-priority-ignore-pageblock-suitability.patch

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
Subject: mm, compaction: make full priority ignore pageblock suitability

Several people have reported premature OOMs for order-2 allocations
(stack) due to OOM rework in 4.7.  In the scenario (parallel kernel build
and dd writing to two drives) many pageblocks get marked as Unmovable and
compaction free scanner struggles to isolate free pages.  Joonsoo Kim
pointed out that the free scanner skips pageblocks that are not movable to
prevent filling them and forcing non-movable allocations to fallback to
other pageblocks.  Such heuristic makes sense to help prevent long-term
fragmentation, but premature OOMs are relatively more urgent problem.  As
a compromise, this patch disables the heuristic only for the ultimate
compaction priority.

Link: http://lkml.kernel.org/r/20160906135258.18335-5-vbabka@suse.cz
Reported-by: Ralf-Peter Rohbeck <Ralf-Peter.Rohbeck@quantum.com>
Reported-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Reported-by: Olaf Hering <olaf@aepfle.de>
Suggested-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   11 ++++++++---
 mm/internal.h   |    1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

diff -puN mm/compaction.c~mm-compaction-make-full-priority-ignore-pageblock-suitability mm/compaction.c
--- a/mm/compaction.c~mm-compaction-make-full-priority-ignore-pageblock-suitability
+++ a/mm/compaction.c
@@ -997,8 +997,12 @@ isolate_migratepages_range(struct compac
 #ifdef CONFIG_COMPACTION
 
 /* Returns true if the page is within a block suitable for migration to */
-static bool suitable_migration_target(struct page *page)
+static bool suitable_migration_target(struct compact_control *cc,
+							struct page *page)
 {
+	if (cc->ignore_block_suitable)
+		return true;
+
 	/* If the page is a large free page, then disallow migration */
 	if (PageBuddy(page)) {
 		/*
@@ -1083,7 +1087,7 @@ static void isolate_freepages(struct com
 			continue;
 
 		/* Check the block is suitable for migration */
-		if (!suitable_migration_target(page))
+		if (!suitable_migration_target(cc, page))
 			continue;
 
 		/* If isolation recently failed, do not retry */
@@ -1656,7 +1660,8 @@ static enum compact_result compact_zone_
 		.classzone_idx = classzone_idx,
 		.direct_compaction = true,
 		.whole_zone = (prio == MIN_COMPACT_PRIORITY),
-		.ignore_skip_hint = (prio == MIN_COMPACT_PRIORITY)
+		.ignore_skip_hint = (prio == MIN_COMPACT_PRIORITY),
+		.ignore_block_suitable = (prio == MIN_COMPACT_PRIORITY)
 	};
 	INIT_LIST_HEAD(&cc.freepages);
 	INIT_LIST_HEAD(&cc.migratepages);
diff -puN mm/internal.h~mm-compaction-make-full-priority-ignore-pageblock-suitability mm/internal.h
--- a/mm/internal.h~mm-compaction-make-full-priority-ignore-pageblock-suitability
+++ a/mm/internal.h
@@ -178,6 +178,7 @@ struct compact_control {
 	unsigned long last_migrated_pfn;/* Not yet flushed page being freed */
 	enum migrate_mode mode;		/* Async or sync migration mode */
 	bool ignore_skip_hint;		/* Scan blocks even if marked skip */
+	bool ignore_block_suitable;	/* Scan blocks considered unsuitable */
 	bool direct_compaction;		/* False from kcompactd or /proc/... */
 	bool whole_zone;		/* Whole zone should/has been scanned */
 	int order;			/* order a direct compactor needs */
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions.patch
mm-compaction-cleanup-unused-functions.patch
mm-compaction-rename-compact_partial-to-compact_success.patch
mm-compaction-dont-recheck-watermarks-after-compact_success.patch
mm-compaction-add-the-ultimate-direct-compaction-priority.patch
mm-compaction-add-the-ultimate-direct-compaction-priority-fix.patch
mm-compaction-use-correct-watermark-when-checking-compaction-success.patch
mm-compaction-create-compact_gap-wrapper.patch
mm-compaction-create-compact_gap-wrapper-fix.patch
mm-compaction-use-proper-alloc_flags-in-__compaction_suitable.patch
mm-compaction-require-only-min-watermarks-for-non-costly-orders.patch
mm-compaction-require-only-min-watermarks-for-non-costly-orders-fix.patch
mm-vmscan-make-compaction_ready-more-accurate-and-readable.patch
revert-mm-oom-prevent-premature-oom-killer-invocation-for-high-order-request.patch
mm-compaction-more-reliably-increase-direct-compaction-priority.patch
mm-compaction-restrict-full-priority-to-non-costly-orders.patch
mm-compaction-make-full-priority-ignore-pageblock-suitability.patch

