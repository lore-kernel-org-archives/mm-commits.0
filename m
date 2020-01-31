From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?ocfs2-use-ocfs2=5Fupdate=5Finode=5Ffsync=5Ftrans-to-access?=
 =?US-ASCII?Q?-t=5Ftid-in-handle-h=5Ftransaction.patch?= removed from -mm
 tree
Date: Fri, 31 Jan 2020 15:17:12 -0800
Message-ID: <20200131231712.50w9xqFUh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXRN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:17:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gechangwei@live.cn, ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com, wangyan122@huawei.com


The patch titled
     Subject: ocfs2: use ocfs2_update_inode_fsync_trans() to access t_tid in handle->h_transaction
has been removed from the -mm tree.  Its filename was
     ocfs2-use-ocfs2_update_inode_fsync_trans-to-access-t_tid-in-handle-h_transaction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: wangyan <wangyan122@huawei.com>
Subject: ocfs2: use ocfs2_update_inode_fsync_trans() to access t_tid in handle->h_transaction

For the uniform format, we use ocfs2_update_inode_fsync_trans() to access
t_tid in handle->h_transaction

Link: http://lkml.kernel.org/r/6ff9a312-5f7d-0e27-fb51-bc4e062fcd97@huawei.com
Signed-off-by: Yan Wang <wangyan122@huawei.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/namei.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/ocfs2/namei.c~ocfs2-use-ocfs2_update_inode_fsync_trans-to-access-t_tid-in-handle-h_transaction
+++ a/fs/ocfs2/namei.c
@@ -586,8 +586,7 @@ static int __ocfs2_mknod_locked(struct i
 			mlog_errno(status);
 	}
 
-	oi->i_sync_tid = handle->h_transaction->t_tid;
-	oi->i_datasync_tid = handle->h_transaction->t_tid;
+	ocfs2_update_inode_fsync_trans(handle, inode, 1);
 
 leave:
 	if (status < 0) {
_

Patches currently in -mm which might be from wangyan122@huawei.com are
