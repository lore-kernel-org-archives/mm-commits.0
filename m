From: akpm@linux-foundation.org
Subject: [patch 017/126] ocfs2/cluster: clean up unnecessary assignment
 for 'ret'
Date: Tue, 26 Jul 2016 15:21:47 -0700
Message-ID: <5797e27b.cFj9EHMENKdWVLee%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56495 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048AbcGZWVt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:21:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, piaojun@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de

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
