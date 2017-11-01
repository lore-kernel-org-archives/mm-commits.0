From: akpm@linux-foundation.org
Subject: + ocfs2-should-wait-dio-before-inode-lock-in-ocfs2_setattr.patch
 added to -mm tree
Date: Wed, 01 Nov 2017 13:48:26 -0700
Message-ID: <59fa331a.6FxMZu2EhnO9ZAPv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35300 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751985AbdKAUs1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Nov 2017 16:48:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.chen@huawei.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, piaojun@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: should wait dio before inode lock in ocfs2_setattr()
has been added to the -mm tree.  Its filename is
     ocfs2-should-wait-dio-before-inode-lock-in-ocfs2_setattr.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-should-wait-dio-before-inode-lock-in-ocfs2_setattr.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-should-wait-dio-before-inode-lock-in-ocfs2_setattr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
