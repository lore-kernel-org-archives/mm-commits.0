From: akpm@linux-foundation.org
Subject: [patch 008/127] fs/ocfs2/cluster: remove deprecated
 create_singlethread_workqueue()
Date: Fri, 07 Oct 2016 16:57:10 -0700
Message-ID: <57f83656.ts2ic6or0B6Tmd8Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38799 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932843AbcJGX5M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:57:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, bhaktipriya96@gmail.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, tj@kernel.org

From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Subject: fs/ocfs2/cluster: remove deprecated create_singlethread_workqueue()

The workqueue "o2net_wq" queues multiple work items viz
&old_sc->sc_shutdown_work, &sc->sc_rx_work, &sc->sc_connect_work which
require strict execution ordering. Hence, an ordered dedicated workqueue
has been used.

WQ_MEM_RECLAIM has been set to ensure forward progress under memory
pressure.

Link: http://lkml.kernel.org/r/ddc12e5766c79ba26f8a00d98049107f8a1d4866.1472590094.git.bhaktipriya96@gmail.com
Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ocfs2/cluster/tcp.c~fs-ocfs2-cluster-remove-deprecated-create_singlethread_workqueue fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~fs-ocfs2-cluster-remove-deprecated-create_singlethread_workqueue
+++ a/fs/ocfs2/cluster/tcp.c
@@ -2104,7 +2104,7 @@ int o2net_start_listening(struct o2nm_no
 	BUG_ON(o2net_listen_sock != NULL);
 
 	mlog(ML_KTHREAD, "starting o2net thread...\n");
-	o2net_wq = create_singlethread_workqueue("o2net");
+	o2net_wq = alloc_ordered_workqueue("o2net", WQ_MEM_RECLAIM);
 	if (o2net_wq == NULL) {
 		mlog(ML_ERROR, "unable to launch o2net thread\n");
 		return -ENOMEM; /* ? */
_
