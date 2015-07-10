From: akpm@linux-foundation.org
Subject: + ocfs2-fix-several-issues-of-append-dio.patch added to -mm tree
Date: Fri, 10 Jul 2015 14:34:25 -0700
Message-ID: <55a03a61.oVbyr6ro+/7/sFBV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60572 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932497AbbGJVe0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jul 2015 17:34:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jiangyiwen@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, wangww631@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: fix several issues of append dio
has been added to the -mm tree.  Its filename is
     ocfs2-fix-several-issues-of-append-dio.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-several-issues-of-append-dio.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-several-issues-of-append-dio.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2265,6 +2265,8 @@ static ssize_t ocfs2_file_write_iter(str
 			       OCFS2_MOUNT_COHERENCY_BUFFERED);
 	int unaligned_dio = 0;
 	int dropped_dio = 0;
+	int append_write = ((iocb->ki_pos + count) >=
+			i_size_read(inode) ? 1 : 0);
 
 	trace_ocfs2_file_aio_write(inode, file, file->f_path.dentry,
 		(unsigned long long)OCFS2_I(inode)->ip_blkno,
@@ -2284,8 +2286,9 @@ relock:
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

ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work.patch
ocfs2-fix-bug-in-ocfs2_downconvert_thread_do_work-v2.patch
ocfs2-fix-race-between-dio-and-recover-orphan.patch
ocfs2-fix-several-issues-of-append-dio.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed.patch
ocfs2-set-filesytem-read-only-when-ocfs2_delete_entry-failed-v2.patch
ocfs2-fix-race-between-crashed-dio-and-rm.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch

