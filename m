From: akpm@linux-foundation.org
Subject: [merged] ocfs2-use-bitmap_weight.patch removed from -mm tree
Date: Mon, 20 Aug 2012 12:56:26 -0700
Message-ID: <20120820195626.B65601E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-iy0-f202.google.com ([209.85.210.202]:47602 "EHLO
	mail-iy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab2HTT42 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 15:56:28 -0400
Received: by ialo24 with SMTP id o24so904828ial.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 12:56:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: use bitmap_weight()
has been removed from the -mm tree.  Its filename was
     ocfs2-use-bitmap_weight.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: ocfs2: use bitmap_weight()

Use bitmap_weight() instead of reinventing the wheel.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-use-bitmap_weight fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-use-bitmap_weight
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -35,6 +35,7 @@
 #include <linux/time.h>
 #include <linux/debugfs.h>
 #include <linux/slab.h>
+#include <linux/bitmap.h>
 
 #include "heartbeat.h"
 #include "tcp.h"
@@ -282,15 +283,6 @@ struct o2hb_bio_wait_ctxt {
 	int               wc_error;
 };
 
-static int o2hb_pop_count(void *map, int count)
-{
-	int i = -1, pop = 0;
-
-	while ((i = find_next_bit(map, count, i + 1)) < count)
-		pop++;
-	return pop;
-}
-
 static void o2hb_write_timeout(struct work_struct *work)
 {
 	int failed, quorum;
@@ -307,9 +299,9 @@ static void o2hb_write_timeout(struct wo
 		spin_lock_irqsave(&o2hb_live_lock, flags);
 		if (test_bit(reg->hr_region_num, o2hb_quorum_region_bitmap))
 			set_bit(reg->hr_region_num, o2hb_failed_region_bitmap);
-		failed = o2hb_pop_count(&o2hb_failed_region_bitmap,
+		failed = bitmap_weight(o2hb_failed_region_bitmap,
 					O2NM_MAX_REGIONS);
-		quorum = o2hb_pop_count(&o2hb_quorum_region_bitmap,
+		quorum = bitmap_weight(o2hb_quorum_region_bitmap,
 					O2NM_MAX_REGIONS);
 		spin_unlock_irqrestore(&o2hb_live_lock, flags);
 
@@ -771,7 +763,7 @@ static void o2hb_set_quorum_device(struc
 	 * If global heartbeat active, unpin all regions if the
 	 * region count > CUT_OFF
 	 */
-	if (o2hb_pop_count(&o2hb_quorum_region_bitmap,
+	if (bitmap_weight(o2hb_quorum_region_bitmap,
 			   O2NM_MAX_REGIONS) > O2HB_PIN_CUT_OFF)
 		o2hb_region_unpin(NULL);
 unlock:
@@ -1819,7 +1811,7 @@ static ssize_t o2hb_region_dev_write(str
 	live_threshold = O2HB_LIVE_THRESHOLD;
 	if (o2hb_global_heartbeat_active()) {
 		spin_lock(&o2hb_live_lock);
-		if (o2hb_pop_count(&o2hb_region_bitmap, O2NM_MAX_REGIONS) == 1)
+		if (bitmap_weight(o2hb_region_bitmap, O2NM_MAX_REGIONS) == 1)
 			live_threshold <<= 1;
 		spin_unlock(&o2hb_live_lock);
 	}
@@ -2170,7 +2162,7 @@ static void o2hb_heartbeat_group_drop_it
 	if (!o2hb_dependent_users)
 		goto unlock;
 
-	if (o2hb_pop_count(&o2hb_quorum_region_bitmap,
+	if (bitmap_weight(o2hb_quorum_region_bitmap,
 			   O2NM_MAX_REGIONS) <= O2HB_PIN_CUT_OFF)
 		o2hb_region_pin(NULL);
 
@@ -2464,7 +2456,7 @@ static int o2hb_region_inc_user(const ch
 	if (o2hb_dependent_users > 1)
 		goto unlock;
 
-	if (o2hb_pop_count(&o2hb_quorum_region_bitmap,
+	if (bitmap_weight(o2hb_quorum_region_bitmap,
 			   O2NM_MAX_REGIONS) <= O2HB_PIN_CUT_OFF)
 		ret = o2hb_region_pin(NULL);
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
string-do-not-export-memweight-to-userspace.patch
cciss-cleanup-bitops-usage.patch
cciss-use-check_signature.patch

