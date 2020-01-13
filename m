From: akpm@linux-foundation.org
Subject: +
 =?us-ascii?Q?ocfs2-use-ocfs2=5Fupdate=5Finode=5Ffsync=5Ftrans-to-access?=
 =?us-ascii?Q?-t=5Ftid-in-handle-h=5Ftransaction.patch?= added to -mm tree
Date: Mon, 13 Jan 2020 14:44:34 -0800
Message-ID: <20200113224434.CjCpw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgAMWof (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Jan 2020 17:44:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, piaojun@huawei.com, mark@fasheh.com, junxiao.bi@oracle.com, jlbec@evilplan.org, jiangqi903@gmail.com, ghe@suse.com, gechangwei@live.cn, wangyan122@huawei.com


The patch titled
     Subject: ocfs2: use ocfs2_update_inode_fsync_trans() to access t_tid in handle->h_transaction
has been added to the -mm tree.  Its filename is
     ocfs2-use-ocfs2_update_inode_fsync_trans-to-access-t_tid-in-handle-h_transaction.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-use-ocfs2_update_inode_fsync_trans-to-access-t_tid-in-handle-h_transaction.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-use-ocfs2_update_inode_fsync_trans-to-access-t_tid-in-handle-h_transaction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-fix-a-null-pointer-dereference-when-call-ocfs2_update_inode_fsync_trans.patch
ocfs2-use-ocfs2_update_inode_fsync_trans-to-access-t_tid-in-handle-h_transaction.patch
