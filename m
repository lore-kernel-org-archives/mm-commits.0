From: akpm@linux-foundation.org
Subject: - fuse-fix-race-in-llseek.patch removed from -mm tree
Date: Thu, 01 May 2008 02:32:14 -0700
Message-ID: <200805010932.m419WEYd030968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756912AbYEAJcS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:32:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse: fix race in llseek
has been removed from the -mm tree.  Its filename was
     fuse-fix-race-in-llseek.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fuse: fix race in llseek
From: Miklos Szeredi <mszeredi@suse.cz>

Fuse doesn't use i_mutex to protect setting i_size, and so
generic_file_llseek() can be racy: it doesn't use i_size_read().

So do a fuse specific llseek method, which does use i_size_read().

[akpm@linux-foundation.org: make `retval' loff_t]
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff -puN fs/fuse/file.c~fuse-fix-race-in-llseek fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-fix-race-in-llseek
+++ a/fs/fuse/file.c
@@ -1431,8 +1431,33 @@ static sector_t fuse_bmap(struct address
 	return err ? 0 : outarg.block;
 }
 
+static loff_t fuse_file_llseek(struct file *file, loff_t offset, int origin)
+{
+	loff_t retval;
+	struct inode *inode = file->f_path.dentry->d_inode;
+
+	mutex_lock(&inode->i_mutex);
+	switch (origin) {
+	case SEEK_END:
+		offset += i_size_read(inode);
+		break;
+	case SEEK_CUR:
+		offset += file->f_pos;
+	}
+	retval = -EINVAL;
+	if (offset >= 0 && offset <= inode->i_sb->s_maxbytes) {
+		if (offset != file->f_pos) {
+			file->f_pos = offset;
+			file->f_version = 0;
+		}
+		retval = offset;
+	}
+	mutex_unlock(&inode->i_mutex);
+	return retval;
+}
+
 static const struct file_operations fuse_file_operations = {
-	.llseek		= generic_file_llseek,
+	.llseek		= fuse_file_llseek,
 	.read		= do_sync_read,
 	.aio_read	= fuse_file_aio_read,
 	.write		= do_sync_write,
@@ -1448,7 +1473,7 @@ static const struct file_operations fuse
 };
 
 static const struct file_operations fuse_direct_io_file_operations = {
-	.llseek		= generic_file_llseek,
+	.llseek		= fuse_file_llseek,
 	.read		= fuse_direct_read,
 	.write		= fuse_direct_write,
 	.open		= fuse_open,
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
vfs-fix-permission-checking-in-sys_utimensat.patch

