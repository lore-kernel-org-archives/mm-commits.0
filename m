From: akpm@linux-foundation.org
Subject: + ocfs2-o2hb-fix-hb-hung-time.patch added to -mm tree
Date: Thu, 21 Jan 2016 16:01:52 -0800
Message-ID: <56a17170./9m2cLZ/7gLgmDBm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38259 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbcAVABx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 19:01:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: junxiao.bi@oracle.com, ghe@suse.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.de, rwxybh@126.com, ryan.ding@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: o2hb: fix hb hung time
has been added to the -mm tree.  Its filename is
     ocfs2-o2hb-fix-hb-hung-time.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-o2hb-fix-hb-hung-time.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-o2hb-fix-hb-hung-time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: ocfs2: o2hb: fix hb hung time

hr_last_timeout_start should be set as the last time where hb is still OK.
When hb write timeout, hung time will be (jiffies -
hr_last_timeout_start).

Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
Reviewed-by: Ryan Ding <ryan.ding@oracle.com>
Cc: Gang He <ghe@suse.com>
Cc: rwxybh <rwxybh@126.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/cluster/heartbeat.c~ocfs2-o2hb-fix-hb-hung-time fs/ocfs2/cluster/heartbeat.c
--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-o2hb-fix-hb-hung-time
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -357,7 +357,6 @@ static void o2hb_arm_timeout(struct o2hb
 		spin_unlock(&o2hb_live_lock);
 	}
 	cancel_delayed_work(&reg->hr_write_timeout_work);
-	reg->hr_last_timeout_start = jiffies;
 	schedule_delayed_work(&reg->hr_write_timeout_work,
 			      msecs_to_jiffies(O2HB_MAX_WRITE_TIMEOUT_MS));
 
@@ -1176,6 +1175,7 @@ static int o2hb_do_disk_heartbeat(struct
 	if (own_slot_ok) {
 		o2hb_set_quorum_device(reg);
 		o2hb_arm_timeout(reg);
+		reg->hr_last_timeout_start = jiffies;
 	}
 
 bail:
_

Patches currently in -mm which might be from junxiao.bi@oracle.com are

ocfs2-o2hb-add-negotiate-timer.patch
ocfs2-o2hb-add-nego_timeout-message.patch
ocfs2-o2hb-add-negotiate_approve-message.patch
ocfs2-o2hb-add-some-user-debug-log.patch
ocfs2-o2hb-dont-negotiate-if-last-hb-fail.patch
ocfs2-o2hb-fix-hb-hung-time.patch

