From: akpm@linux-foundation.org
Subject: + fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs.patch added to -mm tree
Date: Tue, 12 Feb 2013 15:16:33 -0800
Message-ID: <20130212231633.8D87231C200@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:39633 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723Ab3BLXQf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Feb 2013 18:16:35 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so72293vbi.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Feb 2013 15:16:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, dchinner@redhat.com, jlbec@evilplan.org, marco.stornelli@gmail.com, mfasheh@suse.com, nikola.ciprich@linuxbox.cz, viro@ZenIV.linux.org.uk


The patch titled
     Subject: fs: return EAGAIN when O_NONBLOCK write should block on frozen fs
has been added to the -mm tree.  Its filename is
     fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Joel Becker <jlbec@evilplan.org>
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
@@ -1509,7 +1509,8 @@ static ssize_t btrfs_file_aio_write(stru
 	size_t count, ocount;
 	bool sync = (file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host);
 
-	sb_start_write(inode->i_sb);
+	if (!sb_start_file_write(file))
+		return -EAGAIN;
 
 	mutex_lock(&inode->i_mutex);
 
diff -puN fs/cifs/file.c~fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs fs/cifs/file.c
--- a/fs/cifs/file.c~fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs
+++ a/fs/cifs/file.c
@@ -2510,7 +2510,8 @@ cifs_writev(struct kiocb *iocb, const st
 
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
@@ -2247,7 +2247,8 @@ static ssize_t ocfs2_file_aio_write(stru
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
@@ -998,7 +998,8 @@ generic_file_splice_write(struct pipe_in
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
@@ -2527,7 +2527,8 @@ ssize_t generic_file_aio_write(struct ki
 
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
fs-change-return-values-from-eacces-to-eperm.patch
fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs.patch
fs-fix-hang-with-bsd-accounting-on-frozen-filesystem.patch
ocfs2-add-freeze-protection-to-ocfs2_file_splice_write.patch
bdi-allow-block-devices-to-say-that-they-require-stable-page-writes.patch
mm-only-enforce-stable-page-writes-if-the-backing-device-requires-it.patch
9pfs-fix-filesystem-to-wait-for-stable-page-writeback.patch
block-optionally-snapshot-page-contents-to-provide-stable-pages-during-write.patch
ocfs2-wait-for-page-writeback-to-provide-stable-pages.patch
ubifs-wait-for-page-writeback-to-provide-stable-pages.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
hfsplus-add-on-disk-layout-declarations-related-to-attributes-tree.patch
hfsplus-add-functionality-of-manipulating-by-records-in-attributes-tree.patch
hfsplus-rework-functionality-of-getting-setting-and-deleting-of-extended-attributes.patch
hfsplus-add-support-of-manipulation-by-attributes-file.patch
hfsplus-fix-issue-with-unzeroed-unused-b-tree-nodes.patch
ocfs2-fix-possible-use-after-free-with-aio.patch
fs-direct-ioc-fix-possible-use-after-free-with-aio.patch

