From: akpm@linux-foundation.org
Subject: [merged]
 fs-ocfs2-super-remove-deprecated-create_singlethread_workqueue.patch
 removed from -mm tree
Date: Mon, 10 Oct 2016 15:42:35 -0700
Message-ID: <57fc195b.jeczGB9xGDufhQ9+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36591 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752257AbcJJWnj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:43:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhaktipriya96@gmail.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@versity.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ocfs2/super: remove deprecated create_singlethread_workqueue()
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-super-remove-deprecated-create_singlethread_workqueue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Subject: fs/ocfs2/super: remove deprecated create_singlethread_workqueue()

The workqueue "ocfs2_wq" queues multiple work items viz
&osb->la_enable_wq, &journal->j_recovery_work, &os->os_orphan_scan_work,
&osb->osb_truncate_log_wq which require strict execution ordering.  Hence,
an ordered dedicated workqueue has been used.

WQ_MEM_RECLAIM has been set to ensure forward progress under memory
pressure because the workqueue is being used on a memory reclaim path.

Link: http://lkml.kernel.org/r/66279de510a7f4cfc6e386d99b7e04b3f65fb11b.1472590094.git.bhaktipriya96@gmail.com
Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/super.c~fs-ocfs2-super-remove-deprecated-create_singlethread_workqueue fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~fs-ocfs2-super-remove-deprecated-create_singlethread_workqueue
+++ a/fs/ocfs2/super.c
@@ -2329,7 +2329,7 @@ static int ocfs2_initialize_super(struct
 	}
 	cleancache_init_shared_fs(sb);
 
-	osb->ocfs2_wq = create_singlethread_workqueue("ocfs2_wq");
+	osb->ocfs2_wq = alloc_ordered_workqueue("ocfs2_wq", WQ_MEM_RECLAIM);
 	if (!osb->ocfs2_wq) {
 		status = -ENOMEM;
 		mlog_errno(status);
_

Patches currently in -mm which might be from bhaktipriya96@gmail.com are


