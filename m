From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-cluster-clean-up-unnecessary-assignment-for-ret.patch removed from
 -mm tree
Date: Wed, 27 Jul 2016 11:59:08 -0700
Message-ID: <5799047c.eicO4ACuPsV8gYSm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757863AbcG0S7J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 14:59:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: piaojun@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2/cluster: clean up unnecessary assignment for 'ret'
has been removed from the -mm tree.  Its filename was
     ocfs2-cluster-clean-up-unnecessary-assignment-for-ret.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: piaojun <piaojun@huawei.com>
Subject: ocfs2/cluster: clean up unnecessary assignment for 'ret'

Clean up unnecessary assignment for 'ret'.

Link: http://lkml.kernel.org/r/578C61F6.4080403@huawei.com
Signed-off-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/tcp.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/cluster/tcp.c~ocfs2-cluster-clean-up-unnecessary-assignment-for-ret fs/ocfs2/cluster/tcp.c
--- a/fs/ocfs2/cluster/tcp.c~ocfs2-cluster-clean-up-unnecessary-assignment-for-ret
+++ a/fs/ocfs2/cluster/tcp.c
@@ -1618,16 +1618,12 @@ static void o2net_start_connect(struct w
 
 	/* watch for racing with tearing a node down */
 	node = o2nm_get_node_by_num(o2net_num_from_nn(nn));
-	if (node == NULL) {
-		ret = 0;
+	if (node == NULL)
 		goto out;
-	}
 
 	mynode = o2nm_get_node_by_num(o2nm_this_node());
-	if (mynode == NULL) {
-		ret = 0;
+	if (mynode == NULL)
 		goto out;
-	}
 
 	spin_lock(&nn->nn_lock);
 	/*
_

Patches currently in -mm which might be from piaojun@huawei.com are

ocfs2-dlm-disable-bug_on-when-dlm_lock_res_dropping_ref-is-cleared-before-dlm_deref_lockres_done_handler.patch
ocfs2-dlm-solve-a-bug-when-deref-failed-in-dlm_drop_lockres_ref.patch
ocfs2-dlm-continue-to-purge-recovery-lockres-when-recovery-master-goes-down.patch

