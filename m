From: akpm@linux-foundation.org
Subject: +
 ocfs2-keep-the-trace-point-consistent-with-the-function-name.patch added to -mm tree
Date: Fri, 16 Feb 2018 15:32:43 -0800
Message-ID: <5a876a1b.j57DP5TGGz+y2x5u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57842 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750787AbeBPXcp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Feb 2018 18:32:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guojia12@huawei.com, alex.chen@huawei.com, ge.changwei@h3c.com, ghe@suse.com, jiangqi903@gmail.com, jiangyiwen@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, piaojun@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: keep the trace point consistent with the function name
has been added to the -mm tree.  Its filename is
     ocfs2-keep-the-trace-point-consistent-with-the-function-name.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-keep-the-trace-point-consistent-with-the-function-name.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-keep-the-trace-point-consistent-with-the-function-name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jia Guo <guojia12@huawei.com>
Subject: ocfs2: keep the trace point consistent with the function name

Keep the trace point consistent with the function name.

Link: http://lkml.kernel.org/r/02609aba-84b2-a22d-3f3b-bc1944b94260@huawei.com
Fixes: 3ef045c3d8ae ("ocfs2: switch to ->write_iter()")
Signed-off-by: Jia Guo <guojia12@huawei.com>
Reviewed-by: Jun Piao <piaojun@huawei.com>
Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>
Acked-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.h        |    2 +-
 fs/ocfs2/file.c        |    8 ++++----
 fs/ocfs2/ocfs2_trace.h |    6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/ocfs2/aops.h~ocfs2-keep-the-trace-point-consistent-with-the-function-name fs/ocfs2/aops.h
--- a/fs/ocfs2/aops.h~ocfs2-keep-the-trace-point-consistent-with-the-function-name
+++ a/fs/ocfs2/aops.h
@@ -78,7 +78,7 @@ static inline void ocfs2_iocb_set_rw_loc
 /*
  * Using a named enum representing lock types in terms of #N bit stored in
  * iocb->private, which is going to be used for communication between
- * ocfs2_dio_end_io() and ocfs2_file_aio_write/read().
+ * ocfs2_dio_end_io() and ocfs2_file_write/read_iter().
  */
 enum ocfs2_iocb_lock_bits {
 	OCFS2_IOCB_RW_LOCK = 0,
diff -puN fs/ocfs2/file.c~ocfs2-keep-the-trace-point-consistent-with-the-function-name fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-keep-the-trace-point-consistent-with-the-function-name
+++ a/fs/ocfs2/file.c
@@ -2257,7 +2257,7 @@ static ssize_t ocfs2_file_write_iter(str
 	int direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
 	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;
 
-	trace_ocfs2_file_aio_write(inode, file, file->f_path.dentry,
+	trace_ocfs2_file_write_iter(inode, file, file->f_path.dentry,
 		(unsigned long long)OCFS2_I(inode)->ip_blkno,
 		file->f_path.dentry->d_name.len,
 		file->f_path.dentry->d_name.name,
@@ -2405,7 +2405,7 @@ static ssize_t ocfs2_file_read_iter(stru
 	int direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
 	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;
 
-	trace_ocfs2_file_aio_read(inode, filp, filp->f_path.dentry,
+	trace_ocfs2_file_read_iter(inode, filp, filp->f_path.dentry,
 			(unsigned long long)OCFS2_I(inode)->ip_blkno,
 			filp->f_path.dentry->d_name.len,
 			filp->f_path.dentry->d_name.name,
@@ -2448,7 +2448,7 @@ static ssize_t ocfs2_file_read_iter(stru
 	 *
 	 * Take and drop the meta data lock to update inode fields
 	 * like i_size. This allows the checks down below
-	 * generic_file_aio_read() a chance of actually working.
+	 * generic_file_read_iter() a chance of actually working.
 	 */
 	ret = ocfs2_inode_lock_atime(inode, filp->f_path.mnt, &lock_level,
 				     !nowait);
@@ -2460,7 +2460,7 @@ static ssize_t ocfs2_file_read_iter(stru
 	ocfs2_inode_unlock(inode, lock_level);
 
 	ret = generic_file_read_iter(iocb, to);
-	trace_generic_file_aio_read_ret(ret);
+	trace_generic_file_read_iter_ret(ret);
 
 	/* buffered aio wouldn't have proper lock coverage today */
 	BUG_ON(ret == -EIOCBQUEUED && !(iocb->ki_flags & IOCB_DIRECT));
diff -puN fs/ocfs2/ocfs2_trace.h~ocfs2-keep-the-trace-point-consistent-with-the-function-name fs/ocfs2/ocfs2_trace.h
--- a/fs/ocfs2/ocfs2_trace.h~ocfs2-keep-the-trace-point-consistent-with-the-function-name
+++ a/fs/ocfs2/ocfs2_trace.h
@@ -1311,11 +1311,11 @@ DEFINE_OCFS2_FILE_OPS(ocfs2_file_release
 
 DEFINE_OCFS2_FILE_OPS(ocfs2_sync_file);
 
-DEFINE_OCFS2_FILE_OPS(ocfs2_file_aio_write);
+DEFINE_OCFS2_FILE_OPS(ocfs2_file_write_iter);
 
 DEFINE_OCFS2_FILE_OPS(ocfs2_file_splice_write);
 
-DEFINE_OCFS2_FILE_OPS(ocfs2_file_aio_read);
+DEFINE_OCFS2_FILE_OPS(ocfs2_file_read_iter);
 
 DEFINE_OCFS2_ULL_ULL_ULL_EVENT(ocfs2_truncate_file);
 
@@ -1467,7 +1467,7 @@ TRACE_EVENT(ocfs2_prepare_inode_for_writ
 		  __entry->saved_pos, __entry->count, __entry->wait)
 );
 
-DEFINE_OCFS2_INT_EVENT(generic_file_aio_read_ret);
+DEFINE_OCFS2_INT_EVENT(generic_file_read_iter_ret);
 
 /* End of trace events for fs/ocfs2/file.c. */
 
_

Patches currently in -mm which might be from guojia12@huawei.com are

ocfs2-keep-the-trace-point-consistent-with-the-function-name.patch

