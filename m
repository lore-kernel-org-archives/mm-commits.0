From: akpm@linux-foundation.org
Subject: [merged] vmstat-update-comment-regarding-stat_threshold.patch removed from -mm tree
Date: Mon, 18 Apr 2011 11:02:30 -0700
Message-ID: <201104181758.p3IHwfqh016058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756225Ab1DRSDu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 14:03:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, mm-commits@vger.kernel.org


The patch titled
     vmstat: update comment regarding stat_threshold
has been removed from the -mm tree.  Its filename was
     vmstat-update-comment-regarding-stat_threshold.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmstat: update comment regarding stat_threshold
From: Christoph Lameter <cl@linux.com>

Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/vmstat.c~vmstat-update-comment-regarding-stat_threshold mm/vmstat.c
--- a/mm/vmstat.c~vmstat-update-comment-regarding-stat_threshold
+++ a/mm/vmstat.c
@@ -321,9 +321,12 @@ static inline void mod_state(struct zone
 		/*
 		 * The fetching of the stat_threshold is racy. We may apply
 		 * a counter threshold to the wrong the cpu if we get
-		 * rescheduled while executing here. However, the following
-		 * will apply the threshold again and therefore bring the
-		 * counter under the threshold.
+		 * rescheduled while executing here. However, the next
+		 * counter update will apply the threshold again and
+		 * therefore bring the counter under the threshold again.
+		 *
+		 * Most of the time the thresholds are the same anyways
+		 * for all cpus in a zone.
 		 */
 		t = this_cpu_read(pcp->stat_threshold);
 
_

Patches currently in -mm which might be from cl@linux.com are

origin.patch
linux-next.patch
mm-remove-unused-zone_idx-variable-from-set_migratetype_isolate.patch
mm-increase-reclaim_distance-to-30.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur-fix.patch

