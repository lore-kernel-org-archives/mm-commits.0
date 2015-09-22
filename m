From: akpm@linux-foundation.org
Subject: + mm-compaction-disginguish-contended-status-in-tracepoints.patch added to -mm tree
Date: Tue, 22 Sep 2015 12:57:56 -0700
Message-ID: <5601b2c4.EeR5w7yho5tCoNML%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933576AbbIVT55 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Sep 2015 15:57:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mgorman@suse.de, mingo@redhat.com, rientjes@google.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: distinguish contended status in tracepoints
has been added to the -mm tree.  Its filename is
     mm-compaction-disginguish-contended-status-in-tracepoints.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-disginguish-contended-status-in-tracepoints.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-disginguish-contended-status-in-tracepoints.patch

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
Subject: mm, compaction: distinguish contended status in tracepoints

Compaction returns prematurely with COMPACT_PARTIAL when contended or has
fatal signal pending.  This is ok for the callers, but might be misleading
in the traces, as the usual reason to return COMPACT_PARTIAL is that we
think the allocation should succeed.  After this patch we distinguish the
premature ending condition in the mm_compaction_finished and
mm_compaction_end tracepoints.

The contended status covers the following reasons:
- lock contention or need_resched() detected in async compaction
- fatal signal pending
- too many pages isolated in the zone (only for async compaction)
Further distinguishing the exact reason seems unnecessary for now.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h        |    1 +
 include/trace/events/compaction.h |    3 ++-
 mm/compaction.c                   |    9 ++++++---
 3 files changed, 9 insertions(+), 4 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-disginguish-contended-status-in-tracepoints include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-disginguish-contended-status-in-tracepoints
+++ a/include/linux/compaction.h
@@ -15,6 +15,7 @@
 /* For more detailed tracepoint output */
 #define COMPACT_NO_SUITABLE_PAGE	5
 #define COMPACT_NOT_SUITABLE_ZONE	6
+#define COMPACT_CONTENDED		7
 /* When adding new states, please adjust include/trace/events/compaction.h */
 
 /* Used to signal whether compaction detected need_sched() or lock contention */
diff -puN include/trace/events/compaction.h~mm-compaction-disginguish-contended-status-in-tracepoints include/trace/events/compaction.h
--- a/include/trace/events/compaction.h~mm-compaction-disginguish-contended-status-in-tracepoints
+++ a/include/trace/events/compaction.h
@@ -16,7 +16,8 @@
 	EM( COMPACT_PARTIAL,		"partial")		\
 	EM( COMPACT_COMPLETE,		"complete")		\
 	EM( COMPACT_NO_SUITABLE_PAGE,	"no_suitable_page")	\
-	EMe(COMPACT_NOT_SUITABLE_ZONE,	"not_suitable_zone")
+	EM( COMPACT_NOT_SUITABLE_ZONE,	"not_suitable_zone")	\
+	EMe(COMPACT_CONTENDED,		"contended")
 
 #ifdef CONFIG_ZONE_DMA
 #define IFDEF_ZONE_DMA(X) X
diff -puN mm/compaction.c~mm-compaction-disginguish-contended-status-in-tracepoints mm/compaction.c
--- a/mm/compaction.c~mm-compaction-disginguish-contended-status-in-tracepoints
+++ a/mm/compaction.c
@@ -1202,7 +1202,7 @@ static int __compact_finished(struct zon
 	unsigned long watermark;
 
 	if (cc->contended || fatal_signal_pending(current))
-		return COMPACT_PARTIAL;
+		return COMPACT_CONTENDED;
 
 	/* Compaction run completes if the migrate and free scanner meet */
 	if (compact_scanners_met(cc)) {
@@ -1393,7 +1393,7 @@ static int compact_zone(struct zone *zon
 
 		switch (isolate_migratepages(zone, cc)) {
 		case ISOLATE_ABORT:
-			ret = COMPACT_PARTIAL;
+			ret = COMPACT_CONTENDED;
 			putback_movable_pages(&cc->migratepages);
 			cc->nr_migratepages = 0;
 			goto out;
@@ -1424,7 +1424,7 @@ static int compact_zone(struct zone *zon
 			 * and we want compact_finished() to detect it
 			 */
 			if (err == -ENOMEM && !compact_scanners_met(cc)) {
-				ret = COMPACT_PARTIAL;
+				ret = COMPACT_CONTENDED;
 				goto out;
 			}
 		}
@@ -1477,6 +1477,9 @@ out:
 	trace_mm_compaction_end(start_pfn, cc->migrate_pfn,
 				cc->free_pfn, end_pfn, sync, ret);
 
+	if (ret == COMPACT_CONTENDED)
+		ret = COMPACT_PARTIAL;
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-migrate-count-pages-failing-all-retries-in-vmstat-and-tracepoint.patch
mm-compaction-export-tracepoints-status-strings-to-userspace.patch
mm-compaction-export-tracepoints-zone-names-to-userspace.patch
mm-compaction-disginguish-contended-status-in-tracepoints.patch

