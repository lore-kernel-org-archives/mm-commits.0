From: akpm@linux-foundation.org
Subject: [merged]
 fs-ocfs2-dlmfs-remove-deprecated-create_singlethread_workqueue.patch
 removed from -mm tree
Date: Mon, 10 Oct 2016 15:42:29 -0700
Message-ID: <57fc1955.AN9/NsWLh07nfUlM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36583 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752237AbcJJWnj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:43:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhaktipriya96@gmail.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@versity.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ocfs2/dlmfs: remove deprecated create_singlethread_workqueue()
has been removed from the -mm tree.  Its filename was
     fs-ocfs2-dlmfs-remove-deprecated-create_singlethread_workqueue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Subject: fs/ocfs2/dlmfs: remove deprecated create_singlethread_workqueue()

The workqueue "user_dlm_worker" queues a single work item &lockres->l_work
per user_lock_res instance and hence it doesn't require execution
ordering.  Hence, alloc_workqueue has been used to replace the deprecated
create_singlethread_workqueue instance.

The WQ_MEM_RECLAIM flag has been set to ensure forward progress under
memory pressure.

Since there are fixed number of work items, explicit concurrency
limit is unnecessary here.

Link: http://lkml.kernel.org/r/9748136d3a3b18138ad1d6ba708367aa1fe9f98c.1472590094.git.bhaktipriya96@gmail.com
Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlmfs/dlmfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/dlmfs/dlmfs.c~fs-ocfs2-dlmfs-remove-deprecated-create_singlethread_workqueue fs/ocfs2/dlmfs/dlmfs.c
--- a/fs/ocfs2/dlmfs/dlmfs.c~fs-ocfs2-dlmfs-remove-deprecated-create_singlethread_workqueue
+++ a/fs/ocfs2/dlmfs/dlmfs.c
@@ -646,7 +646,7 @@ static int __init init_dlmfs_fs(void)
 	}
 	cleanup_inode = 1;
 
-	user_dlm_worker = create_singlethread_workqueue("user_dlm");
+	user_dlm_worker = alloc_workqueue("user_dlm", WQ_MEM_RECLAIM, 0);
 	if (!user_dlm_worker) {
 		status = -ENOMEM;
 		goto bail;
_

Patches currently in -mm which might be from bhaktipriya96@gmail.com are


