From: akpm@linux-foundation.org
Subject: [wrecked] fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs.patch removed from -mm tree
Date: Mon, 08 Apr 2013 11:54:47 -0700
Message-ID: <20130408185447.8347C31C123@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f202.google.com ([209.85.210.202]:46844 "EHLO
	mail-ia0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935047Ab3DHSyt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Apr 2013 14:54:49 -0400
Received: by mail-ia0-f202.google.com with SMTP id p22so1543477iad.5
        for <mm-commits@vger.kernel.org>; Mon, 08 Apr 2013 11:54:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, dchinner@redhat.com, jlbec@evilplan.org, marco.stornelli@gmail.com, mfasheh@suse.com, nikola.ciprich@linuxbox.cz, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: return EAGAIN when O_NONBLOCK write should block on frozen fs
has been removed from the -mm tree.  Its filename was
     fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fs: return EAGAIN when O_NONBLOCK write should block on frozen fs

When user asks for O_NONBLOCK behavior for a file descriptor, return
EAGAIN instead of blocking on a frozen filesystem.

This is needed so we can fix a hang with BSD accounting on frozen
filesystems.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Acked-by: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: Marco Stornelli <marco.stornelli@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/btrfs/file.c    |    3 ++-
 fs/cifs/file.c     |    3 ++-
 fs/fuse/file.c     |    3 ++-
 fs/ntfs/file.c     |    3 ++-
 fs/ocfs2/file.c    |    3 ++-
 fs/splice.c        |    3 ++-
 fs/xfs/xfs_file.c  |    3 ++-
 include/linux/fs.h |   10 ++++++++++
 mm/filemap.c       |    3 ++-
 9 files changed, 26 insertions(+), 8 deletions(-)

diff -puN fs/btrfs/file.c~fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs fs/btrfs/file.c
--- a/fs/btrfs/file.c~fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs
+++ a/fs/btrfs/file.c
@@ -1514,7 +1514,8 @@ static ssize_t btrfs_file_aio_write(stru
 	size_t count, ocount;
 	bool sync = (file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host);
 
-	sb_start_write(inode->i_sb);
+	if (!sb_start_file_write(file))
+		return -EAGAIN;
 
 	mutex_lock(&inode->i_mutex);
 
diff -puN fs/cifs/file.c~fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs fs/cifs/file.c
--- a/fs/cifs/file.c~fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs
+++ a/fs/cifs/file.c
@@ -2515,7 +2515,8 @@ cifs_writev(struct kiocb *iocb, const st
 
 	BUG_ON(iocb->ki_pos != pos);
 
-	sb_start_write(inode->i_sb);
+	if (!sb_start_file_write(file))
+		return -EAGAIN;
 
 	/*
 	 * We need to hold the sem to be sure nobody modifies lock list
diff -puN fs/fuse/file.c~fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs fs/fuse/file.c
--- a/fs/fuse/file.c~fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs
+++ a/fs/fuse/file.c
@@ -971,7 +971,8 @@ static ssize_t fuse_file_aio_write(struc
 		return err;
 
 	count = ocount;
-	sb_start_write(inode->i_sb);
+	if (!sb_start_file_write(file))
+		return -EAGAIN;
 	mutex_lock(&inode->i_mutex);
 
 	/* We can write back this queue in page reclaim */
diff -puN fs/ntfs/file.c~fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs fs/ntfs/file.c
--- a/fs/ntfs/file.c~fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs
+++ a/fs/ntfs/file.c
@@ -2129,7 +2129,8 @@ static ssize_t ntfs_file_aio_write(struc
 
 	BUG_ON(iocb->ki_pos != pos);
 
-	sb_start_write(inode->i_sb);
+	if (!sb_start_file_write(file))
+		return -EAGAIN;
 	mutex_lock(&inode->i_mutex);
 	ret = ntfs_file_aio_write_nolock(iocb, iov, nr_segs, &iocb->ki_pos);
 	mutex_unlock(&inode->i_mutex);
diff -puN fs/ocfs2/file.c~fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs
+++ a/fs/ocfs2/file.c
@@ -2248,7 +2248,8 @@ static ssize_t ocfs2_file_aio_write(stru
 	if (iocb->ki_left == 0)
 		return 0;
 
-	sb_start_write(inode->i_sb);
+	if (!sb_start_file_write(file))
+		return -EAGAIN;
 
 	appending = file->f_flags & O_APPEND ? 1 : 0;
 	direct_io = file->f_flags & O_DIRECT ? 1 : 0;
diff -puN fs/splice.c~fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs fs/splice.c
--- a/fs/splice.c~fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs
+++ a/fs/splice.c
@@ -1001,7 +1001,8 @@ generic_file_splice_write(struct pipe_in
 	};
 	ssize_t ret;
 
-	sb_start_write(inode->i_sb);
+	if (!sb_start_file_write(out))
+		return -EAGAIN;
 
 	pipe_lock(pipe);
 
diff -puN fs/xfs/xfs_file.c~fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs fs/xfs/xfs_file.c
--- a/fs/xfs/xfs_file.c~fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs
+++ a/fs/xfs/xfs_file.c
@@ -775,7 +775,8 @@ xfs_file_aio_write(
 	if (ocount == 0)
 		return 0;
 
-	sb_start_write(inode->i_sb);
+	if (!sb_start_file_write(file))
+		return -EAGAIN;
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		ret = -EIO;
diff -puN include/linux/fs.h~fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs include/linux/fs.h
--- a/include/linux/fs.h~fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs
+++ a/include/linux/fs.h
@@ -1400,6 +1400,16 @@ static inline int sb_start_write_trylock
 	return __sb_start_write(sb, SB_FREEZE_WRITE, false);
 }
 
+/*
+ * sb_start_write() for writing into a file. When file has O_NONBLOCK set,
+ * we use trylock semantics, otherwise we block on frozen filesystem.
+ */
+static inline int sb_start_file_write(struct file *file)
+{
+	return __sb_start_write(file->f_mapping->host->i_sb, SB_FREEZE_WRITE,
+				!(file->f_flags & O_NONBLOCK));
+}
+
 /**
  * sb_start_pagefault - get write access to a superblock from a page fault
  * @sb: the super we write to
diff -puN mm/filemap.c~fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs mm/filemap.c
--- a/mm/filemap.c~fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs
+++ a/mm/filemap.c
@@ -2528,7 +2528,8 @@ ssize_t generic_file_aio_write(struct ki
 
 	BUG_ON(iocb->ki_pos != pos);
 
-	sb_start_write(inode->i_sb);
+	if (!sb_start_file_write(file))
+		return -EAGAIN;
 	mutex_lock(&inode->i_mutex);
 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
 	mutex_unlock(&inode->i_mutex);
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
fs-fix-hang-with-bsd-accounting-on-frozen-filesystem.patch
ocfs2-add-freeze-protection-to-ocfs2_file_splice_write.patch
direct-io-fix-boundary-block-handling.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix-fix.patch

