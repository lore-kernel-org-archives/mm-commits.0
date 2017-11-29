From: akpm@linux-foundation.org
Subject: + ocfs2-nowait-aio-support-v2.patch added to -mm tree
Date: Wed, 29 Nov 2017 14:30:47 -0800
Message-ID: <5a1f3517.6co6vmeKHBCIY+Tc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49576 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750890AbdK2Wat (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 17:30:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject:  ocfs2-nowait-aio-support-v2
has been added to the -mm tree.  Its filename is
     ocfs2-nowait-aio-support-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-nowait-aio-support-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-nowait-aio-support-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gang He <ghe@suse.com>
Subject:  ocfs2-nowait-aio-support-v2

Return -EAGAIN if any of the following checks fail for
direct I/O with nowait flag:
Can not get the related locks immediately,
Blocks are not allocated at the write location, it will trigger
block allocation, this will block IO operations.

Link: http://lkml.kernel.org/r/1511944612-9629-4-git-send-email-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |   37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff -puN fs/ocfs2/file.c~ocfs2-nowait-aio-support-v2 fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-nowait-aio-support-v2
+++ a/fs/ocfs2/file.c
@@ -2136,9 +2136,10 @@ out:
 static int ocfs2_prepare_inode_for_write(struct file *file,
 					 loff_t pos, size_t count, int wait)
 {
-	int ret = 0, meta_level = 0;
+	int ret = 0, meta_level = 0, overwrite_io = 0;
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = d_inode(dentry);
+	struct buffer_head *di_bh = NULL;
 	loff_t end;
 
 	/*
@@ -2149,7 +2150,8 @@ static int ocfs2_prepare_inode_for_write
 		if (wait)
 			ret = ocfs2_inode_lock(inode, NULL, meta_level);
 		else
-			ret = ocfs2_try_inode_lock(inode, NULL, meta_level);
+			ret = ocfs2_try_inode_lock(inode,
+				overwrite_io ? NULL : &di_bh, meta_level);
 		if (ret < 0) {
 			meta_level = -1;
 			if (ret != -EAGAIN)
@@ -2157,6 +2159,28 @@ static int ocfs2_prepare_inode_for_write
 			goto out;
 		}
 
+		/*
+		 * Check if IO will overwrite allocated blocks in case
+		 * IOCB_NOWAIT flag is set.
+		 */
+		if (!wait && !overwrite_io) {
+			overwrite_io = 1;
+			if (!down_read_trylock(&OCFS2_I(inode)->ip_alloc_sem)) {
+				ret = -EAGAIN;
+				goto out_unlock;
+			}
+
+			ret = ocfs2_overwrite_io(inode, di_bh, pos, count);
+			brelse(di_bh);
+			di_bh = NULL;
+			up_read(&OCFS2_I(inode)->ip_alloc_sem);
+			if (ret < 0) {
+				if (ret != -EAGAIN)
+					mlog_errno(ret);
+				goto out_unlock;
+			}
+		}
+
 		/* Clear suid / sgid if necessary. We do this here
 		 * instead of later in the write path because
 		 * remove_suid() calls ->setattr without any hint that
@@ -2206,6 +2230,8 @@ out_unlock:
 	trace_ocfs2_prepare_inode_for_write(OCFS2_I(inode)->ip_blkno,
 					    pos, count, wait);
 
+	brelse(di_bh);
+
 	if (meta_level >= 0)
 		ocfs2_inode_unlock(inode, meta_level);
 
@@ -2297,13 +2323,6 @@ static ssize_t ocfs2_file_write_iter(str
 	}
 	count = ret;
 
-	if (direct_io && nowait) {
-		if (!ocfs2_overwrite_io(inode, iocb->ki_pos, count, 0)) {
-			ret = -EAGAIN;
-			goto out;
-		}
-	}
