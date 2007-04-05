From: akpm@linux-foundation.org
Subject: - cifs-remove-unneeded-checks.patch removed from -mm tree
Date: Wed, 04 Apr 2007 18:59:51 -0700
Message-ID: <200704050159.l351xpKZ004735@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37995 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916AbXDECAJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 22:00:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, sfrench@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cifs: remove unneeded checks
has been removed from the -mm tree.  Its filename was
     cifs-remove-unneeded-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cifs: remove unneeded checks
From: Christoph Hellwig <hch@lst.de>

file->f_path.dentry or file->f_path.dentry.d_inode can't be NULL since at
least ten years, similar for all but very few arguments passed in from the
VFS.

Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/file.c |   53 +++++++++++++++--------------------------------
 1 file changed, 18 insertions(+), 35 deletions(-)

diff -puN fs/cifs/file.c~cifs-remove-unneeded-checks fs/cifs/file.c
--- a/fs/cifs/file.c~cifs-remove-unneeded-checks
+++ a/fs/cifs/file.c
@@ -352,8 +352,6 @@ static int cifs_reopen_file(struct inode
 	int disposition = FILE_OPEN;
 	__u16 netfid;
 
-	if (inode == NULL)
-		return -EBADF;
 	if (file->private_data) {
 		pCifsFile = (struct cifsFileInfo *)file->private_data;
 	} else
@@ -367,12 +365,6 @@ static int cifs_reopen_file(struct inode
 		return 0;
 	}
 
-	if (file->f_path.dentry == NULL) {
-		up(&pCifsFile->fh_sem);
-		cFYI(1, ("failed file reopen, no valid name if dentry freed"));
-		FreeXid(xid);
-		return -EBADF;
-	}
 	cifs_sb = CIFS_SB(inode->i_sb);
 	pTcon = cifs_sb->tcon;
 /* can not grab rename sem here because various ops, including
@@ -784,6 +776,7 @@ int cifs_lock(struct file *file, int cmd
 ssize_t cifs_user_write(struct file *file, const char __user *write_data,
 	size_t write_size, loff_t *poffset)
 {
+	struct inode *inode = file->f_path.dentry->d_inode;
 	int rc = 0;
 	unsigned int bytes_written = 0;
 	unsigned int total_written;
@@ -831,11 +824,6 @@ ssize_t cifs_user_write(struct file *fil
 					return -EBADF;
 			}
 			if (open_file->invalidHandle) {
-				if ((file->f_path.dentry == NULL) ||
-				    (file->f_path.dentry->d_inode == NULL)) {
-					FreeXid(xid);
-					return total_written;
-				}
 				/* we could deadlock if we called
 				   filemap_fdatawait from here so tell
 				   reopen_file not to flush data to server
@@ -868,21 +856,18 @@ ssize_t cifs_user_write(struct file *fil
 
 	cifs_stats_bytes_written(pTcon, total_written);
 
-	/* since the write may have blocked check these pointers again */
-	if ((file->f_path.dentry) && (file->f_path.dentry->d_inode)) {
-		struct inode *inode = file->f_path.dentry->d_inode;
 /* Do not update local mtime - server will set its actual value on write		
  *		inode->i_ctime = inode->i_mtime = 
  * 			current_fs_time(inode->i_sb);*/
-		if (total_written > 0) {
-			spin_lock(&inode->i_lock);
-			if (*poffset > file->f_path.dentry->d_inode->i_size)
-				i_size_write(file->f_path.dentry->d_inode,
-					*poffset);
-			spin_unlock(&inode->i_lock);
-		}
-		mark_inode_dirty_sync(file->f_path.dentry->d_inode);	
+	if (total_written > 0) {
+		spin_lock(&inode->i_lock);
+		if (*poffset > file->f_path.dentry->d_inode->i_size)
+			i_size_write(file->f_path.dentry->d_inode,
+				*poffset);
+		spin_unlock(&inode->i_lock);
 	}
+	mark_inode_dirty_sync(file->f_path.dentry->d_inode);
+
 	FreeXid(xid);
 	return total_written;
 }
@@ -988,19 +973,17 @@ static ssize_t cifs_write(struct file *f
 	cifs_stats_bytes_written(pTcon, total_written);
 
 	/* since the write may have blocked check these pointers again */
-	if ((file->f_path.dentry) && (file->f_path.dentry->d_inode)) {
 /*BB We could make this contingent on superblock ATIME flag too */
-/*		file->f_path.dentry->d_inode->i_ctime =
-		file->f_path.dentry->d_inode->i_mtime = CURRENT_TIME;*/
-		if (total_written > 0) {
-			spin_lock(&file->f_path.dentry->d_inode->i_lock);
-			if (*poffset > file->f_path.dentry->d_inode->i_size)
-				i_size_write(file->f_path.dentry->d_inode,
-					     *poffset);
-			spin_unlock(&file->f_path.dentry->d_inode->i_lock);
-		}
-		mark_inode_dirty_sync(file->f_path.dentry->d_inode);
+/*	file->f_path.dentry->d_inode->i_ctime =
+	file->f_path.dentry->d_inode->i_mtime = CURRENT_TIME;*/
+	if (total_written > 0) {
+		spin_lock(&file->f_path.dentry->d_inode->i_lock);
+		if (*poffset > file->f_path.dentry->d_inode->i_size)
+			i_size_write(file->f_path.dentry->d_inode,
+				     *poffset);
+		spin_unlock(&file->f_path.dentry->d_inode->i_lock);
 	}
+	mark_inode_dirty_sync(file->f_path.dentry->d_inode);
 	FreeXid(xid);
 	return total_written;
 }
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
git-cifs.patch
git-ocfs2.patch
mm-move-common-segment-checks-to-separate-helper-function-v7.patch
mm-move-common-segment-checks-to-separate-helper-function-v7-tidy.patch
simplify-the-stacktrace-code.patch
allow-access-to-proc-pid-fd-after-setuid.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
freevxfs-possible-null-pointer-dereference-fix.patch
vfs-remove-superflous-sb-==-null-checks.patch
nameic-remove-utterly-outdated-comment.patch
move-die-notifier-handling-to-common-code.patch
move-die-notifier-handling-to-common-code-fixes.patch
move-die-notifier-handling-to-common-code-fixes-2.patch
move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch
remove-do_sync_file_range.patch
remove-artificial-software-max_loop-limit.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch
aio-is-unlikely.patch
kprobes-use-hlist_for_each_entry.patch
kprobes-codingstyle-cleanups.patch
kprobes-kretprobes-simplifcations.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
ps3fb-thread-updates.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3av-misc-updates.patch
