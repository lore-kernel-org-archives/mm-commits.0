From: akpm@linux-foundation.org
Subject: [patch 008/131] ocfs2: should wait dio before inode lock
 in ocfs2_setattr()
Date: Wed, 15 Nov 2017 17:31:40 -0800
Message-ID: <20171116013140._8Y3AY-GQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38312 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933442AbdKPBbm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:31:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.chen@huawei.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org, piaojun@huawei.com, stable@vger.kernel.org, torvalds@linux-foundation.org

From: alex chen <alex.chen@huawei.com>
Subject: ocfs2: should wait dio before inode lock in ocfs2_setattr()

we should wait dio requests to finish before inode lock in
ocfs2_setattr(), otherwise the following deadlock will happen:

process 1                  process 2                    process 3
truncate file 'A'          end_io of writing file 'A'   receiving the bast messages
ocfs2_setattr
 ocfs2_inode_lock_tracker
  ocfs2_inode_lock_full
 inode_dio_wait
  __inode_dio_wait
  -->waiting for all dio
  requests finish
                                                        dlm_proxy_ast_handler
                                                         dlm_do_local_bast
                                                          ocfs2_blocking_ast
                                                           ocfs2_generic_handle_bast
                                                            set OCFS2_LOCK_BLOCKED flag
                        dio_end_io
                         dio_bio_end_aio
                          dio_complete
                           ocfs2_dio_end_io
                            ocfs2_dio_end_io_write
                             ocfs2_inode_lock
                              __ocfs2_cluster_lock
                               ocfs2_wait_for_mask
                               -->waiting for OCFS2_LOCK_BLOCKED
                               flag to be cleared, that is waiting
                               for 'process 1' unlocking the inode lock
                           inode_dio_end
                           -->here dec the i_dio_count, but will never
                           be called, so a deadlock happened.

Link: http://lkml.kernel.org/r/59F81636.70508@huawei.com
Signed-off-by: Alex Chen <alex.chen@huawei.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Joseph Qi <jiangqi903@gmail.com>
Acked-by: Changwei Ge <ge.changwei@h3c.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/file.c~ocfs2-should-wait-dio-before-inode-lock-in-ocfs2_setattr fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-should-wait-dio-before-inode-lock-in-ocfs2_setattr
+++ a/fs/ocfs2/file.c
@@ -1161,6 +1161,13 @@ int ocfs2_setattr(struct dentry *dentry,
 	}
 	size_change = S_ISREG(inode->i_mode) && attr->ia_valid & ATTR_SIZE;
 	if (size_change) {
+		/*
+		 * Here we should wait dio to finish before inode lock
+		 * to avoid a deadlock between ocfs2_setattr() and
+		 * ocfs2_dio_end_io_write()
+		 */
+		inode_dio_wait(inode);
+
 		status = ocfs2_rw_lock(inode, 1);
 		if (status < 0) {
 			mlog_errno(status);
@@ -1200,8 +1207,6 @@ int ocfs2_setattr(struct dentry *dentry,
 		if (status)
 			goto bail_unlock;
 
-		inode_dio_wait(inode);
