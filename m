From: akpm@linux-foundation.org
Subject: +
 mm-compaction-add-an-is_via_compact_memory-helper-function.patch added to
 -mm tree
Date: Thu, 17 Sep 2015 14:39:41 -0700
Message-ID: <55fb331d.tE9SpDRKwkEzyItx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52360 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbbIQVjl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Sep 2015 17:39:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction.c: add an is_via_compact_memory() helper
has been added to the -mm tree.  Its filename is
     mm-compaction-add-an-is_via_compact_memory-helper-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-add-an-is_via_compact_memory-helper-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-add-an-is_via_compact_memory-helper-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: mm/compaction.c: add an is_via_compact_memory() helper

Introduce is_via_compact_memory() helper indicating compacting via
/proc/sys/vm/compact_memory to improve readability.

To catch this situation in __compaction_suitable, use order as parameter
directly instead of using struct compact_control.

This patch has no functional changes.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff -puN mm/compaction.c~mm-compaction-add-an-is_via_compact_memory-helper-function mm/compaction.c
--- a/mm/compaction.c~mm-compaction-add-an-is_via_compact_memory-helper-function
+++ a/mm/compaction.c
@@ -1197,6 +1197,15 @@ static isolate_migrate_t isolate_migrate
 	return cc->nr_migratepages ? ISOLATE_SUCCESS : ISOLATE_NONE;
 }
 
+/*
+ * order == -1 is expected when compacting via
+ * /proc/sys/vm/compact_memory
+ */
+static inline bool is_via_compact_memory(int order)
+{
+	return order == -1;
+}
+
 static int __compact_finished(struct zone *zone, struct compact_control *cc,
 			    const int migratetype)
 {
@@ -1223,11 +1232,7 @@ static int __compact_finished(struct zon
 		return COMPACT_COMPLETE;
 	}
 
-	/*
-	 * order == -1 is expected when compacting via
-	 * /proc/sys/vm/compact_memory
-	 */
-	if (cc->order == -1)
+	if (is_via_compact_memory(cc->order))
 		return COMPACT_CONTINUE;
 
 	/* Compaction run is not finished if the watermark is not met */
@@ -1290,11 +1295,7 @@ static unsigned long __compaction_suitab
 	int fragindex;
 	unsigned long watermark;
 
-	/*
-	 * order == -1 is expected when compacting via
-	 * /proc/sys/vm/compact_memory
-	 */
-	if (order == -1)
+	if (is_via_compact_memory(order))
 		return COMPACT_CONTINUE;
 
 	watermark = low_wmark_pages(zone);
@@ -1658,10 +1659,11 @@ static void __compact_pgdat(pg_data_t *p
 		 * this makes sure we compact the whole zone regardless of
 		 * cached scanner positions.
 		 */
-		if (cc->order == -1)
+		if (is_via_compact_memory(cc->order))
 			__reset_isolation_suitable(zone);
 
-		if (cc->order == -1 || !compaction_deferred(zone, cc->order))
+		if (is_via_compact_memory(cc->order) ||
+				!compaction_deferred(zone, cc->order))
 			compact_zone(zone, cc);
 
 		if (cc->order > 0) {
_

Patches currently in -mm which might be from bywxiaobai@163.com are

mm-page_alloc-remove-unused-parameter-in-init_currently_empty_zone.patch
mm-vmscan-make-inactive_anon_is_low_global-return-directly.patch
mm-oom_kill-introduce-is_sysrq_oom-helper.patch
mm-compaction-add-an-is_via_compact_memory-helper-function.patch

