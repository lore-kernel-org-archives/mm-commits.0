From: akpm@linux-foundation.org
Subject: +
 ocfs2-fix-null-pointer-dereference-when-dismount-and-ocfs2rec-simultaneously.patch added to -mm tree
Date: Fri, 27 Dec 2013 14:09:48 -0800
Message-ID: <52bdfaac.cPTTdgYBURZEpLMC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60188 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab3L0WJt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Dec 2013 17:09:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xuejiufei@huawei.com, mfasheh@suse.com, joseph.qi@huawei.com, jlbec@evilplan.org, jiangyiwen@huawei.com

Subject: + ocfs2-fix-null-pointer-dereference-when-dismount-and-ocfs2rec-simultaneously.patch added to -mm tree
To: jiangyiwen@huawei.com,jlbec@evilplan.org,joseph.qi@huawei.com,mfasheh@suse.com,xuejiufei@huawei.com
From: akpm@linux-foundation.org
Date: Fri, 27 Dec 2013 14:09:48 -0800


The patch titled
     Subject: ocfs2: fix NULL pointer dereference when dismount and ocfs2rec simultaneously
has been added to the -mm tree.  Its filename is
     ocfs2-fix-null-pointer-dereference-when-dismount-and-ocfs2rec-simultaneously.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-null-pointer-dereference-when-dismount-and-ocfs2rec-simultaneously.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-null-pointer-dereference-when-dismount-and-ocfs2rec-simultaneously.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yiwen Jiang <jiangyiwen@huawei.com>
Subject: ocfs2: fix NULL pointer dereference when dismount and ocfs2rec simultaneously

2 nodes cluster, say Node A and Node B, mount the same ocfs2 volume, and
create a file 1.

Node A			Node B
open 1, get open lock
                        rm 1, and then add 1 to orphan_dir
storage link down,
o2hb_write_timeout
->o2quo_disk_timeout
->emergency_restart
                        at the moment, Node B dismount and do
			ocfs2rec simultaneously
                        1) ocfs2_dismount_volume
			->ocfs2_recovery_exit
			->wait_event(osb->recovery_event)
			->flush_workqueue(ocfs2_wq)
			2) ocfs2rec
			->queue_work(&journal->j_recovery_work)
                        ->ocfs2_recover_orphans
			->ocfs2_commit_truncate
                        ->queue_delayed_work(&osb->osb_truncate_log_wq)

In ocfs2_recovery_exit, it flushes workqueue and then releases system
inodes.  When doing ocfs2rec, it will call ocfs2_flush_truncate_log which
will try to get sys_root_inode, and NULL pointer dereference occurs.

Signed-off-by: Yiwen Jiang <jiangyiwen@huawei.com>
Signed-off-by: joyce <xuejiufei@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/super.c~ocfs2-fix-null-pointer-dereference-when-dismount-and-ocfs2rec-simultaneously fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~ocfs2-fix-null-pointer-dereference-when-dismount-and-ocfs2rec-simultaneously
+++ a/fs/ocfs2/super.c
@@ -1945,11 +1945,15 @@ static void ocfs2_dismount_volume(struct
 
 	ocfs2_shutdown_local_alloc(osb);
 
-	ocfs2_truncate_log_shutdown(osb);
