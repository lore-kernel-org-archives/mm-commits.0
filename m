From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-add-an-is_via_compact_memory-helper-function.patch removed
 from -mm tree
Date: Fri, 06 Nov 2015 12:08:14 -0800
Message-ID: <563d08ae.ckbf5WFdxyLDQwxY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033688AbbKFUIO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:08:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, mgorman@techsingularity.net, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction.c: add an is_via_compact_memory() helper
has been removed from the -mm tree.  Its filename was
     mm-compaction-add-an-is_via_compact_memory-helper-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: mm/compaction.c: add an is_via_compact_memory() helper

Introduce is_via_compact_memory() helper indicating compacting via
/proc/sys/vm/compact_memory to improve readability.

To catch this situation in __compaction_suitable, use order as parameter
directly instead of using struct compact_control.

This patch has no functional changes.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Acked-by: David Rientjes <rientjes@google.com>
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

mm-oom_kill-introduce-is_sysrq_oom-helper.patch
fs-kdev_t-remove-unused-huge_valid_dev-function.patch
fs-kdev_t-old-new_valid_dev-can-be-boolean.patch
fs-vfs-remove-unnecessary-new_valid_dev-check.patch
fs-btrfs-remove-unnecessary-new_valid_dev-check.patch
fs-exofs-remove-unnecessary-new_valid_dev-check.patch
fs-ext2-remove-unnecessary-new_valid_dev-check.patch
fs-f2fs-remove-unnecessary-new_valid_dev-check.patch
fs-hpfs-remove-unnecessary-new_valid_dev-check.patch
fs-jfs-remove-unnecessary-new_valid_dev-check.patch
fs-ncpfs-remove-unnecessary-new_valid_dev-check.patch
fs-nilfs2-remove-unnecessary-new_valid_dev-check.patch
fs-reiserfs-remove-unnecessary-new_valid_dev-check.patch
fs-stat-remove-unnecessary-new_valid_dev-check.patch
fs-ubifs-remove-unnecessary-new_valid_dev-check.patch

