From: akpm@linux-foundation.org
Subject: +
 ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io.patch added to
 -mm tree
Date: Tue, 23 Sep 2014 15:15:19 -0700
Message-ID: <5421f0f7.h5kQHaNfNjKTHeVY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38402 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943AbaIWWPU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Sep 2014 18:15:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangww631@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ] ocfs2: add and remove inode in orphan dir in ocfs2_direct_IO
has been added to the -mm tree.  Its filename is
     ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: WeiWei Wang <wangww631@huawei.com>
Subject: ] ocfs2: add and remove inode in orphan dir in ocfs2_direct_IO

Add the inode to orphan first, after direct-io write is finished, remove
the inode from orphan dir.  So the allocate blocks and change
inode->i_size will be safe.

Signed-off-by: Weiwei Wang <wangww631@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |  118 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 114 insertions(+), 4 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io
+++ a/fs/ocfs2/aops.c
@@ -47,6 +47,9 @@
 #include "ocfs2_trace.h"
 
 #include "buffer_head_io.h"
+#include "dir.h"
+#include "namei.h"
+#include "sysfile.h"
 
 static int ocfs2_symlink_get_block(struct inode *inode, sector_t iblock,
 				   struct buffer_head *bh_result, int create)
@@ -602,8 +605,16 @@ static ssize_t ocfs2_direct_IO(int rw,
 			       struct iov_iter *iter,
 			       loff_t offset)
 {
+	ssize_t ret = 0;
+	int status = 0;
+	int orphan = 0;
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file)->i_mapping->host;
+	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
+	struct buffer_head *di_bh = NULL;
+	handle_t *handle = NULL;
+	size_t count = iter->count;
+	journal_t *journal = osb->journal->j_journal;
 
 	/*
 	 * Fallback to buffered I/O if we see an inode without
@@ -616,10 +627,109 @@ static ssize_t ocfs2_direct_IO(int rw,
 	if (i_size_read(inode) <= offset)
 		return 0;
 
-	return __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev,
-				    iter, offset,
-				    ocfs2_direct_IO_get_blocks,
-				    ocfs2_dio_end_io, NULL, 0);
+	if (rw == WRITE) {
+		loff_t final_size = offset + count;
+		/*
+		 * when final_size > inode->i_size, inode->i_size will be
+		 * updated after direct write, so add the inode to orphan
+		 * dir first.
+		 */
+		if (final_size > i_size_read(inode)) {
+			handle = ocfs2_start_trans(osb,
+					OCFS2_INODE_ADD_TO_ORPHAN_CREDITS);
+			if (IS_ERR(handle)) {
+				status = PTR_ERR(handle);
+				goto out;
+			}
+			status = ocfs2_add_inode_to_orphan(osb, handle, inode);
+			if (status < 0)
+				goto out;
+
+			orphan = 1;
+			ocfs2_commit_trans(osb, handle);
+			handle = NULL;
+		}
+	}
+
+	if (rw == READ)
+		ret = __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev,
+					iter, offset,
+					ocfs2_direct_IO_get_blocks,
+					ocfs2_dio_end_io, NULL, 0);
+	else {
+		ret =  blockdev_direct_IO(rw, iocb, inode,
+					iter, offset,
+					ocfs2_direct_IO_get_blocks);
+
+		if (unlikely((rw & WRITE) && ret < 0)) {
+			loff_t isize = i_size_read(inode);
+
+			if (offset + count  > isize) {
+				status = ocfs2_inode_lock(inode, &di_bh, 1);
+				if (status < 0) {
+					mlog_errno(status);
+					goto out;
+				}
+				if (isize == i_size_read(inode))
+					ocfs2_truncate_file(inode, di_bh,
+							    isize);
+
+				ocfs2_inode_unlock(inode, 1);
+				brelse(di_bh);
+				di_bh = NULL;
+
+				status = jbd2_journal_force_commit(journal);
+				if (status < 0)
+					mlog_errno(status);
+			}
+		}
+	}
+
+	if (orphan) {
+		handle = ocfs2_start_trans(osb,
+					OCFS2_INODE_DEL_FROM_ORPHAN_CREDITS);
+		if (IS_ERR(handle)) {
+			status = PTR_ERR(handle);
+			goto out;
+		}
+
+		status = ocfs2_del_inode_from_orphan(osb, handle, inode);
+		if (status < 0)
+			goto out;
+
+		/* after update the inode->i_size, call
+		 * jbd2_journal_force_commit to flush the journal to disk */
+		if (ret > 0) {
+			loff_t end = offset + ret;
+
+			if (end > i_size_read(inode)) {
+				status = ocfs2_inode_lock(inode, &di_bh, 1);
+				if (status < 0) {
+					mlog_errno(status);
+					goto out;
+				}
+				status = ocfs2_set_inode_size(handle, inode,
+							      di_bh, end);
+				if (status < 0)
+					mlog_errno(status);
+				ocfs2_inode_unlock(inode, 1);
+				brelse(di_bh);
+			}
+		}
+		ocfs2_commit_trans(osb, handle);
+		handle = NULL;
+
+		status = jbd2_journal_force_commit(journal);
+		if (status < 0)
+			mlog_errno(status);
+	}
+
+out:
+	if (status < 0)
+		ret = status;
+	if (handle)
+		ocfs2_commit_trans(osb, handle);
+	return ret;
 }
 
 static void ocfs2_figure_cluster_boundaries(struct ocfs2_super *osb,
_

Patches currently in -mm which might be from wangww631@huawei.com are

ocfs2-eliminate-the-static-flag-of-some-functions.patch
ocfs2-add-two-functions-of-add-and-remove-inode-in-orphan-dir.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans.patch
ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io.patch
ocfs2-allocate-blocks-in-ocfs2_direct_io_get_blocks.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-appending.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes.patch

