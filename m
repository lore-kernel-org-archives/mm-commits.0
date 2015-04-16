From: akpm@linux-foundation.org
Subject: [merged] dax-unify-ext2-4_dax_file_operations.patch removed from
 -mm tree
Date: Thu, 16 Apr 2015 09:53:13 -0700
Message-ID: <552fe8f9.rINAS0MLCh9RmpZ6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42889 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbbDPQro (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:47:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: boaz@plexistor.com, dchinner@redhat.com, hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com, mgorman@suse.de, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: unify ext2/4_{dax,}_file_operations
has been removed from the -mm tree.  Its filename was
     dax-unify-ext2-4_dax_file_operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Boaz Harrosh <boaz@plexistor.com>
Subject: dax: unify ext2/4_{dax,}_file_operations

The original dax patchset split the ext2/4_file_operations because of the
two NULL splice_read/splice_write in the dax case.

In the vfs if splice_read/splice_write are NULL we then call
default_splice_read/write.

What we do here is make generic_file_splice_read aware of IS_DAX() so the
original ext2/4_file_operations can be used as is.

For write it appears that iter_file_splice_write is just fine.  It uses
the regular f_op->write(file,..) or new_sync_write(file, ...).

Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/ext2.h  |    1 -
 fs/ext2/file.c  |   18 ------------------
 fs/ext2/inode.c |    5 +----
 fs/ext2/namei.c |   10 ++--------
 fs/ext4/ext4.h  |    1 -
 fs/ext4/file.c  |   20 --------------------
 fs/ext4/inode.c |    5 +----
 fs/ext4/namei.c |   10 ++--------
 fs/splice.c     |    3 +++
 9 files changed, 9 insertions(+), 64 deletions(-)

diff -puN fs/ext2/ext2.h~dax-unify-ext2-4_dax_file_operations fs/ext2/ext2.h
--- a/fs/ext2/ext2.h~dax-unify-ext2-4_dax_file_operations
+++ a/fs/ext2/ext2.h
@@ -793,7 +793,6 @@ extern int ext2_fsync(struct file *file,
 		      int datasync);
 extern const struct inode_operations ext2_file_inode_operations;
 extern const struct file_operations ext2_file_operations;
-extern const struct file_operations ext2_dax_file_operations;
 
 /* inode.c */
 extern const struct address_space_operations ext2_aops;
diff -puN fs/ext2/file.c~dax-unify-ext2-4_dax_file_operations fs/ext2/file.c
--- a/fs/ext2/file.c~dax-unify-ext2-4_dax_file_operations
+++ a/fs/ext2/file.c
@@ -109,24 +109,6 @@ const struct file_operations ext2_file_o
 	.splice_write	= iter_file_splice_write,
 };
 
-#ifdef CONFIG_FS_DAX
-const struct file_operations ext2_dax_file_operations = {
-	.llseek		= generic_file_llseek,
-	.read		= new_sync_read,
-	.write		= new_sync_write,
-	.read_iter	= generic_file_read_iter,
-	.write_iter	= generic_file_write_iter,
-	.unlocked_ioctl = ext2_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl	= ext2_compat_ioctl,
-#endif
-	.mmap		= ext2_file_mmap,
-	.open		= dquot_file_open,
-	.release	= ext2_release_file,
-	.fsync		= ext2_fsync,
-};
-#endif
-
 const struct inode_operations ext2_file_inode_operations = {
 #ifdef CONFIG_EXT2_FS_XATTR
 	.setxattr	= generic_setxattr,
diff -puN fs/ext2/inode.c~dax-unify-ext2-4_dax_file_operations fs/ext2/inode.c
--- a/fs/ext2/inode.c~dax-unify-ext2-4_dax_file_operations
+++ a/fs/ext2/inode.c
@@ -1388,10 +1388,7 @@ struct inode *ext2_iget (struct super_bl
 
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &ext2_file_inode_operations;
-		if (test_opt(inode->i_sb, DAX)) {
-			inode->i_mapping->a_ops = &ext2_aops;
-			inode->i_fop = &ext2_dax_file_operations;
-		} else if (test_opt(inode->i_sb, NOBH)) {
+		if (test_opt(inode->i_sb, NOBH)) {
 			inode->i_mapping->a_ops = &ext2_nobh_aops;
 			inode->i_fop = &ext2_file_operations;
 		} else {
diff -puN fs/ext2/namei.c~dax-unify-ext2-4_dax_file_operations fs/ext2/namei.c
--- a/fs/ext2/namei.c~dax-unify-ext2-4_dax_file_operations
+++ a/fs/ext2/namei.c
@@ -104,10 +104,7 @@ static int ext2_create (struct inode * d
 		return PTR_ERR(inode);
 
 	inode->i_op = &ext2_file_inode_operations;
-	if (test_opt(inode->i_sb, DAX)) {
-		inode->i_mapping->a_ops = &ext2_aops;
-		inode->i_fop = &ext2_dax_file_operations;
-	} else if (test_opt(inode->i_sb, NOBH)) {
+	if (test_opt(inode->i_sb, NOBH)) {
 		inode->i_mapping->a_ops = &ext2_nobh_aops;
 		inode->i_fop = &ext2_file_operations;
 	} else {
@@ -125,10 +122,7 @@ static int ext2_tmpfile(struct inode *di
 		return PTR_ERR(inode);
 
 	inode->i_op = &ext2_file_inode_operations;
-	if (test_opt(inode->i_sb, DAX)) {
-		inode->i_mapping->a_ops = &ext2_aops;
-		inode->i_fop = &ext2_dax_file_operations;
-	} else if (test_opt(inode->i_sb, NOBH)) {
+	if (test_opt(inode->i_sb, NOBH)) {
 		inode->i_mapping->a_ops = &ext2_nobh_aops;
 		inode->i_fop = &ext2_file_operations;
 	} else {
diff -puN fs/ext4/ext4.h~dax-unify-ext2-4_dax_file_operations fs/ext4/ext4.h
--- a/fs/ext4/ext4.h~dax-unify-ext2-4_dax_file_operations
+++ a/fs/ext4/ext4.h
@@ -2593,7 +2593,6 @@ extern const struct file_operations ext4
 /* file.c */
 extern const struct inode_operations ext4_file_inode_operations;
 extern const struct file_operations ext4_file_operations;
-extern const struct file_operations ext4_dax_file_operations;
 extern loff_t ext4_llseek(struct file *file, loff_t offset, int origin);
 
 /* inline.c */
diff -puN fs/ext4/file.c~dax-unify-ext2-4_dax_file_operations fs/ext4/file.c
--- a/fs/ext4/file.c~dax-unify-ext2-4_dax_file_operations
+++ a/fs/ext4/file.c
@@ -625,26 +625,6 @@ const struct file_operations ext4_file_o
 	.fallocate	= ext4_fallocate,
 };
 
-#ifdef CONFIG_FS_DAX
-const struct file_operations ext4_dax_file_operations = {
-	.llseek		= ext4_llseek,
-	.read		= new_sync_read,
-	.write		= new_sync_write,
-	.read_iter	= generic_file_read_iter,
-	.write_iter	= ext4_file_write_iter,
-	.unlocked_ioctl = ext4_ioctl,
-#ifdef CONFIG_COMPAT
-	.compat_ioctl	= ext4_compat_ioctl,
-#endif
-	.mmap		= ext4_file_mmap,
-	.open		= ext4_file_open,
-	.release	= ext4_release_file,
-	.fsync		= ext4_sync_file,
-	/* Splice not yet supported with DAX */
-	.fallocate	= ext4_fallocate,
-};
-#endif
-
 const struct inode_operations ext4_file_inode_operations = {
 	.setattr	= ext4_setattr,
 	.getattr	= ext4_getattr,
diff -puN fs/ext4/inode.c~dax-unify-ext2-4_dax_file_operations fs/ext4/inode.c
--- a/fs/ext4/inode.c~dax-unify-ext2-4_dax_file_operations
+++ a/fs/ext4/inode.c
@@ -4090,10 +4090,7 @@ struct inode *ext4_iget(struct super_blo
 
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &ext4_file_inode_operations;
-		if (test_opt(inode->i_sb, DAX))
-			inode->i_fop = &ext4_dax_file_operations;
-		else
-			inode->i_fop = &ext4_file_operations;
+		inode->i_fop = &ext4_file_operations;
 		ext4_set_aops(inode);
 	} else if (S_ISDIR(inode->i_mode)) {
 		inode->i_op = &ext4_dir_inode_operations;
diff -puN fs/ext4/namei.c~dax-unify-ext2-4_dax_file_operations fs/ext4/namei.c
--- a/fs/ext4/namei.c~dax-unify-ext2-4_dax_file_operations
+++ a/fs/ext4/namei.c
@@ -2235,10 +2235,7 @@ retry:
 	err = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		inode->i_op = &ext4_file_inode_operations;
-		if (test_opt(inode->i_sb, DAX))
-			inode->i_fop = &ext4_dax_file_operations;
-		else
-			inode->i_fop = &ext4_file_operations;
+		inode->i_fop = &ext4_file_operations;
 		ext4_set_aops(inode);
 		err = ext4_add_nondir(handle, dentry, inode);
 		if (!err && IS_DIRSYNC(dir))
@@ -2302,10 +2299,7 @@ retry:
 	err = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		inode->i_op = &ext4_file_inode_operations;
-		if (test_opt(inode->i_sb, DAX))
-			inode->i_fop = &ext4_dax_file_operations;
-		else
-			inode->i_fop = &ext4_file_operations;
+		inode->i_fop = &ext4_file_operations;
 		ext4_set_aops(inode);
 		d_tmpfile(dentry, inode);
 		err = ext4_orphan_add(handle, inode);
diff -puN fs/splice.c~dax-unify-ext2-4_dax_file_operations fs/splice.c
--- a/fs/splice.c~dax-unify-ext2-4_dax_file_operations
+++ a/fs/splice.c
@@ -523,6 +523,9 @@ ssize_t generic_file_splice_read(struct
 	loff_t isize, left;
 	int ret;
 
+	if (IS_DAX(in->f_mapping->host))
+		return default_file_splice_read(in, ppos, pipe, len, flags);
+
 	isize = i_size_read(in->f_mapping->host);
 	if (unlikely(*ppos >= isize))
 		return 0;
_

Patches currently in -mm which might be from boaz@plexistor.com are

origin.patch
linux-next.patch
gitignore-ignore-tar.patch

