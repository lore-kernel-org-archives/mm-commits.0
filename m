From: akpm@linux-foundation.org
Subject: [merged] ext2-report-metadata-errors-during-fsync.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:36:52 -0800
Message-ID: <200912162036.nBGKaq8m013272@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935474AbZLPUhC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:37:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, chris.mason@oracle.com, mm-commits@vger.kernel.org


The patch titled
     ext2: report metadata errors during fsync
has been removed from the -mm tree.  Its filename was
     ext2-report-metadata-errors-during-fsync.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2: report metadata errors during fsync
From: Jan Kara <jack@suse.cz>

When an IO error happens while writing metadata buffers, we should better
report it and call ext2_error since the filesystem is probably no longer
consistent.  Sometimes such IO errors happen while flushing thread does
background writeback, the buffer gets later evicted from memory, and thus
the only trace of the error remains as AS_EIO bit set in blockdevice's
mapping.  So we check this bit in ext2_fsync and report the error although
we cannot be really sure which buffer we failed to write.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/dir.c  |    2 +-
 fs/ext2/ext2.h |    1 +
 fs/ext2/file.c |   21 +++++++++++++++++++--
 3 files changed, 21 insertions(+), 3 deletions(-)

diff -puN fs/ext2/dir.c~ext2-report-metadata-errors-during-fsync fs/ext2/dir.c
--- a/fs/ext2/dir.c~ext2-report-metadata-errors-during-fsync
+++ a/fs/ext2/dir.c
@@ -721,5 +721,5 @@ const struct file_operations ext2_dir_op
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext2_compat_ioctl,
 #endif
-	.fsync		= simple_fsync,
+	.fsync		= ext2_fsync,
 };
diff -puN fs/ext2/ext2.h~ext2-report-metadata-errors-during-fsync fs/ext2/ext2.h
--- a/fs/ext2/ext2.h~ext2-report-metadata-errors-during-fsync
+++ a/fs/ext2/ext2.h
@@ -155,6 +155,7 @@ extern void ext2_write_super (struct sup
 extern const struct file_operations ext2_dir_operations;
 
 /* file.c */
+extern int ext2_fsync(struct file *file, struct dentry *dentry, int datasync);
 extern const struct inode_operations ext2_file_inode_operations;
 extern const struct file_operations ext2_file_operations;
 extern const struct file_operations ext2_xip_file_operations;
diff -puN fs/ext2/file.c~ext2-report-metadata-errors-during-fsync fs/ext2/file.c
--- a/fs/ext2/file.c~ext2-report-metadata-errors-during-fsync
+++ a/fs/ext2/file.c
@@ -19,6 +19,7 @@
  */
 
 #include <linux/time.h>
+#include <linux/pagemap.h>
 #include "ext2.h"
 #include "xattr.h"
 #include "acl.h"
@@ -38,6 +39,22 @@ static int ext2_release_file (struct ino
 	return 0;
 }
 
+int ext2_fsync(struct file *file, struct dentry *dentry, int datasync)
+{
+	int ret;
+	struct super_block *sb = dentry->d_inode->i_sb;
+	struct address_space *mapping = sb->s_bdev->bd_inode->i_mapping;
+
+	ret = simple_fsync(file, dentry, datasync);
+	if (ret == -EIO || test_and_clear_bit(AS_EIO, &mapping->flags)) {
+		/* We don't really know where the IO error happened... */
+		ext2_error(sb, __func__,
+			   "detected IO error when writing metadata buffers");
+		ret = -EIO;
+	}
+	return ret;
+}
+
 /*
  * We have mostly NULL's here: the current defaults are ok for
  * the ext2 filesystem.
@@ -55,7 +72,7 @@ const struct file_operations ext2_file_o
 	.mmap		= generic_file_mmap,
 	.open		= generic_file_open,
 	.release	= ext2_release_file,
-	.fsync		= simple_fsync,
+	.fsync		= ext2_fsync,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
 };
@@ -72,7 +89,7 @@ const struct file_operations ext2_xip_fi
 	.mmap		= xip_file_mmap,
 	.open		= generic_file_open,
 	.release	= ext2_release_file,
-	.fsync		= simple_fsync,
+	.fsync		= ext2_fsync,
 };
 #endif
 
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
reiserfs-truncate-blocks-not-used-by-a-write-v2.patch
linux-next.patch
reiser4-update-names-of-quota-methods.patch

