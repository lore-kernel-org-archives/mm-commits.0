From: akpm@linux-foundation.org
Subject: + ocfs2-use-bitmap_weight.patch added to -mm tree
Date: Fri, 20 Sep 2013 13:50:13 -0700
Message-ID: <523cb505.UVqV3sb9d1NEX7HZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab3ITUuO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Sep 2013 16:50:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, jlbec@evilplan.org, akinobu.mita@gmail.com

Subject: + ocfs2-use-bitmap_weight.patch added to -mm tree
To: akinobu.mita@gmail.com,jlbec@evilplan.org,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Fri, 20 Sep 2013 13:50:13 -0700


The patch titled
     Subject: ocfs2: use bitmap_weight()
has been added to the -mm tree.  Its filename is
     ocfs2-use-bitmap_weight.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-use-bitmap_weight.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-use-bitmap_weight.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: ocfs2: use bitmap_weight()
    
Use bitmap_weight() instead of reinventing the wheel.
    
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Joel Becker <jlbec@evilplan.org>
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
 
@@ -765,7 +757,7 @@ static void o2hb_set_quorum_device(struc
 	 * If global heartbeat active, unpin all regions if the
 	 * region count > CUT_OFF
 	 */
-	if (o2hb_pop_count(&o2hb_quorum_region_bitmap,
+	if (bitmap_weight(o2hb_quorum_region_bitmap,
 			   O2NM_MAX_REGIONS) > O2HB_PIN_CUT_OFF)
 		o2hb_region_unpin(NULL);
 unlock:
@@ -1829,7 +1821,7 @@ static ssize_t o2hb_region_dev_write(str
 	live_threshold = O2HB_LIVE_THRESHOLD;
 	if (o2hb_global_heartbeat_active()) {
 		spin_lock(&o2hb_live_lock);
-		if (o2hb_pop_count(&o2hb_region_bitmap, O2NM_MAX_REGIONS) == 1)
+		if (bitmap_weight(o2hb_region_bitmap, O2NM_MAX_REGIONS) == 1)
 			live_threshold <<= 1;
 		spin_unlock(&o2hb_live_lock);
 	}
@@ -2180,7 +2172,7 @@ static void o2hb_heartbeat_group_drop_it
 	if (!o2hb_dependent_users)
 		goto unlock;
 
-	if (o2hb_pop_count(&o2hb_quorum_region_bitmap,
+	if (bitmap_weight(o2hb_quorum_region_bitmap,
 			   O2NM_MAX_REGIONS) <= O2HB_PIN_CUT_OFF)
 		o2hb_region_pin(NULL);
 
@@ -2480,7 +2472,7 @@ static int o2hb_region_inc_user(const ch
 	if (o2hb_dependent_users > 1)
 		goto unlock;
 
-	if (o2hb_pop_count(&o2hb_quorum_region_bitmap,
+	if (bitmap_weight(o2hb_quorum_region_bitmap,
 			   O2NM_MAX_REGIONS) <= O2HB_PIN_CUT_OFF)
 		ret = o2hb_region_pin(NULL);
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

ocfs2-use-bitmap_weight.patch
ocfs2-use-find_last_bit.patch
linux-next.patch

