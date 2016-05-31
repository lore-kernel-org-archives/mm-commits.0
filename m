From: akpm@linux-foundation.org
Subject: [merged] ocfs2-o2hb-fix-hb-hung-time.patch removed from -mm tree
Date: Tue, 31 May 2016 10:50:16 -0700
Message-ID: <574dced8.DOv4O8Op7LzjQ/20%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47428 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949AbcEaRuR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 13:50:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, rwxybh@126.com, ryan.ding@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: o2hb: fix hb hung time
has been removed from the -mm tree.  Its filename was
     ocfs2-o2hb-fix-hb-hung-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: o2hb: fix hb hung time

hr_last_timeout_start should be set as the last time where hb is still OK.
When hb write timeout, hung time will be (jiffies -
hr_last_timeout_start).

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Ryan Ding <ryan.ding@oracle.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Cc: Gang He <ghe@suse.com>
Cc: rwxybh <rwxybh@126.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-o2hb-fix-hb-hung-time fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-o2hb-fix-hb-hung-time
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -356,7 +356,6 @@ static void o2hb_arm_timeout(struct o2hb
 		spin_unlock(&o2hb_live_lock);
 	}
 	cancel_delayed_work(&reg->hr_write_timeout_work);
-	reg->hr_last_timeout_start = jiffies;
 	schedule_delayed_work(&reg->hr_write_timeout_work,
 			      msecs_to_jiffies(O2HB_MAX_WRITE_TIMEOUT_MS));
 
@@ -1174,6 +1173,7 @@ static int o2hb_do_disk_heartbeat(struct
 	if (own_slot_ok) {
 		o2hb_set_quorum_device(reg);
 		o2hb_arm_timeout(reg);
+		reg->hr_last_timeout_start = jiffies;
 	}
 
 bail:
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are


