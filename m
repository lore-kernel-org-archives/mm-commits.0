From: akpm@linux-foundation.org
Subject: [merged] ocfs2-fix-several-issues-of-append-dio.patch removed
 from -mm tree
Date: Tue, 08 Sep 2015 11:01:59 -0700
Message-ID: <55ef2297.tiX3vKhlFgu0pilC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58743 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039AbbIHSCA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:02:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jiangyiwen@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, wangww631@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix several issues of append dio
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-several-issues-of-append-dio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: fix several issues of append dio

1) Take rw EX lock in case of append dio.
2) Explicitly treat the error code -EIOCBQUEUED as normal.
3) Set di_bh to NULL after brelse if it may be used again later.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Yiwen Jiang <jiangyiwen@huawei.com>
Cc: Weiwei Wang <wangww631@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    7 ++++++-
 fs/ocfs2/file.c |    5 ++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-fix-several-issues-of-append-dio fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-fix-several-issues-of-append-dio
+++ a/fs/ocfs2/aops.c
@@ -860,7 +860,8 @@ static ssize_t ocfs2_direct_IO_write(str
 	written = __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev, iter,
 				       offset, ocfs2_direct_IO_get_blocks,
 				       ocfs2_dio_end_io, NULL, 0);
-	if (unlikely(written < 0)) {
+	/* overwrite aio may return -EIOCBQUEUED, and it is not an error */
+	if ((written < 0) && (written != -EIOCBQUEUED)) {
 		loff_t i_size = i_size_read(inode);
 
 		if (offset + count > i_size) {
@@ -879,12 +880,14 @@ static ssize_t ocfs2_direct_IO_write(str
 
 					ocfs2_inode_unlock(inode, 1);
 					brelse(di_bh);
+					di_bh = NULL;
 					goto clean_orphan;
 				}
 			}
 
 			ocfs2_inode_unlock(inode, 1);
 			brelse(di_bh);
+			di_bh = NULL;
 
 			ret = jbd2_journal_force_commit(journal);
 			if (ret < 0)
@@ -939,10 +942,12 @@ clean_orphan:
 		if (tmp_ret < 0) {
 			ret = tmp_ret;
 			mlog_errno(ret);
+			brelse(di_bh);
 			goto out;
 		}
 
 		ocfs2_inode_unlock(inode, 1);
+		brelse(di_bh);
 
 		tmp_ret = jbd2_journal_force_commit(journal);
 		if (tmp_ret < 0) {
diff -puN fs/ocfs2/file.c~ocfs2-fix-several-issues-of-append-dio fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-fix-several-issues-of-append-dio
+++ a/fs/ocfs2/file.c
@@ -2271,6 +2271,8 @@ static ssize_t ocfs2_file_write_iter(str
 			       OCFS2_MOUNT_COHERENCY_BUFFERED);
 	int unaligned_dio = 0;
 	int dropped_dio = 0;
+	int append_write = ((iocb->ki_pos + count) >=
+			i_size_read(inode) ? 1 : 0);
 
 	trace_ocfs2_file_aio_write(inode, file, file->f_path.dentry,
 		(unsigned long long)OCFS2_I(inode)->ip_blkno,
@@ -2290,8 +2292,9 @@ relock:
 	/*
 	 * Concurrent O_DIRECT writes are allowed with
 	 * mount_option "coherency=buffered".
+	 * For append write, we must take rw EX.
 	 */
-	rw_level = (!direct_io || full_coherency);
+	rw_level = (!direct_io || full_coherency || append_write);
 
 	ret = ocfs2_rw_lock(inode, rw_level);
 	if (ret < 0) {
_

Patches currently in -mm which might be from joseph.qi@huawei.com are


