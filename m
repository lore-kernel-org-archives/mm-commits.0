From: akpm@linux-foundation.org
Subject: [patch 010/127] fs/ocfs2/dlm: remove deprecated
 create_singlethread_workqueue()
Date: Fri, 07 Oct 2016 16:57:17 -0700
Message-ID: <57f8365d.o/t1jXiGSE4czpN6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38812 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbcJGX5S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:57:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, bhaktipriya96@gmail.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, tj@kernel.org

From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Subject: fs/ocfs2/dlm: remove deprecated create_singlethread_workqueue()

The workqueue "dlm_worker" queues a single work item &dlm->dispatched_work
and thus it doesn't require execution ordering.  Hence, alloc_workqueue
has been used to replace the deprecated create_singlethread_workqueue
instance.

The WQ_MEM_RECLAIM flag has been set to ensure forward progress under
memory pressure.

Since there are fixed number of work items, explicit concurrency
limit is unnecessary here.

Link: http://lkml.kernel.org/r/2b5ad8d6688effe1a9ddb2bc2082d26fbbe00302.1472590094.git.bhaktipriya96@gmail.com
Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdomain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/dlm/dlmdomain.c~fs-ocfs2-dlm-remove-deprecated-create_singlethread_workqueue fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c~fs-ocfs2-dlm-remove-deprecated-create_singlethread_workqueue
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -1904,7 +1904,7 @@ static int dlm_join_domain(struct dlm_ct
 	}
 
 	snprintf(wq_name, O2NM_MAX_NAME_LEN, "dlm_wq-%s", dlm->name);
-	dlm->dlm_worker = create_singlethread_workqueue(wq_name);
+	dlm->dlm_worker = alloc_workqueue(wq_name, WQ_MEM_RECLAIM, 0);
 	if (!dlm->dlm_worker) {
 		status = -ENOMEM;
 		mlog_errno(status);
_
