From: akpm@linux-foundation.org
Subject: + cifs-remove-unneeded-checks.patch added to -mm tree
Date: Sun, 11 Mar 2007 00:57:40 -0800
Message-ID: <200703110857.l2B8vd3W008237@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40491 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbXCKI5u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 04:57:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, sfrench@us.ibm.com


The patch titled
     cifs: remove unneeded checks
has been added to the -mm tree.  Its filename is
     cifs-remove-unneeded-checks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cifs: remove unneeded checks
From: Christoph Hellwig <hch@lst.de>

file->f_path.dentry or file->f_path.dentry.d_inode can't be NULL since at
least ten years, similar for all but very few arguments passed in from the
VFS.

Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifsfs.c  |    3 -
 fs/cifs/file.c    |   82 ++++++++++----------------------------------
 fs/cifs/readdir.c |   27 +-------------
 3 files changed, 24 insertions(+), 88 deletions(-)

diff -puN fs/cifs/cifsfs.c~cifs-remove-unneeded-checks fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~cifs-remove-unneeded-checks
+++ a/fs/cifs/cifsfs.c
@@ -529,8 +529,7 @@ static loff_t cifs_llseek(struct file *f
 		/* some applications poll for the file length in this strange
 		   way so we must seek to end on non-oplocked files by
 		   setting the revalidate time to zero */
-		if(file->f_path.dentry->d_inode)		
-			CIFS_I(file->f_path.dentry->d_inode)->time = 0;
+		CIFS_I(file->f_path.dentry->d_inode)->time = 0;
 
 		retval = cifs_revalidate(file->f_path.dentry);
 		if (retval < 0)
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
@@ -792,12 +785,7 @@ ssize_t cifs_user_write(struct file *fil
 	int xid, long_op;
 	struct cifsFileInfo *open_file;
 
-	if (file->f_path.dentry == NULL)
-		return -EBADF;
-
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
-	if (cifs_sb == NULL)
-		return -EBADF;
 
 	pTcon = cifs_sb->tcon;
 
@@ -807,14 +795,9 @@ ssize_t cifs_user_write(struct file *fil
 
 	if (file->private_data == NULL)
 		return -EBADF;
-	else
-		open_file = (struct cifsFileInfo *) file->private_data;
+	open_file = (struct cifsFileInfo *) file->private_data;
 	
 	xid = GetXid();
-	if (file->f_path.dentry->d_inode == NULL) {
-		FreeXid(xid);
-		return -EBADF;
-	}
 
 	if (*poffset > file->f_path.dentry->d_inode->i_size)
 		long_op = 2; /* writes past end of file can take a long time */
@@ -841,11 +824,6 @@ ssize_t cifs_user_write(struct file *fil
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
@@ -878,21 +856,18 @@ ssize_t cifs_user_write(struct file *fil
 
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
@@ -908,12 +883,7 @@ static ssize_t cifs_write(struct file *f
 	int xid, long_op;
 	struct cifsFileInfo *open_file;
 
-	if (file->f_path.dentry == NULL)
-		return -EBADF;
-
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
-	if (cifs_sb == NULL)
-		return -EBADF;
 
 	pTcon = cifs_sb->tcon;
 
@@ -922,14 +892,9 @@ static ssize_t cifs_write(struct file *f
 
 	if (file->private_data == NULL)
 		return -EBADF;
-	else
-		open_file = (struct cifsFileInfo *)file->private_data;
+	open_file = (struct cifsFileInfo *)file->private_data;
 	
 	xid = GetXid();
-	if (file->f_path.dentry->d_inode == NULL) {
-		FreeXid(xid);
-		return -EBADF;
-	}
 
 	if (*poffset > file->f_path.dentry->d_inode->i_size)
 		long_op = 2; /* writes past end of file can take a long time */
@@ -957,11 +922,6 @@ static ssize_t cifs_write(struct file *f
 					return -EBADF;
 			}
 			if (open_file->invalidHandle) {
-				if ((file->f_path.dentry == NULL) ||
-				   (file->f_path.dentry->d_inode == NULL)) {
-					FreeXid(xid);
-					return total_written;
-				}
 				/* we could deadlock if we called
 				   filemap_fdatawait from here so tell
 				   reopen_file not to flush data to 
@@ -1013,19 +973,17 @@ static ssize_t cifs_write(struct file *f
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
diff -puN fs/cifs/readdir.c~cifs-remove-unneeded-checks fs/cifs/readdir.c
--- a/fs/cifs/readdir.c~cifs-remove-unneeded-checks
+++ a/fs/cifs/readdir.c
@@ -440,9 +440,6 @@ static int initiate_cifs_search(const in
 	cifsFile->invalidHandle = TRUE;
 	cifsFile->srch_inf.endOfSearch = FALSE;
 
-	if(file->f_path.dentry == NULL)
-		return -ENOENT;
-
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 	if(cifs_sb == NULL)
 		return -EINVAL;
@@ -614,20 +611,10 @@ static int cifs_entry_is_dot(char *curre
    whether we can use the cached search results from the previous search */
 static int is_dir_changed(struct file * file)
 {
-	struct inode * inode;
-	struct cifsInodeInfo *cifsInfo;
-
-	if(file->f_path.dentry == NULL)
-		return 0;
-
-	inode = file->f_path.dentry->d_inode;
-
-	if(inode == NULL)
-		return 0;
-
-	cifsInfo = CIFS_I(inode);
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct cifsInodeInfo *cifsInfo = CIFS_I(inode);
 
-	if(cifsInfo->time == 0)
+	if (cifsInfo->time == 0)
 		return 1; /* directory was changed, perhaps due to unlink */
 	else
 		return 0;
@@ -847,9 +834,6 @@ static int cifs_filldir(char *pfindEntry
 	if((scratch_buf == NULL) || (pfindEntry == NULL) || (pCifsF == NULL))
 		return -ENOENT;
 
-	if(file->f_path.dentry == NULL)
-		return -ENOENT;
-
 	rc = cifs_entry_is_dot(pfindEntry,pCifsF);
 	/* skip . and .. since we added them first */
 	if(rc != 0) 
@@ -993,11 +977,6 @@ int cifs_readdir(struct file *file, void
 
 	xid = GetXid();
 
-	if(file->f_path.dentry == NULL) {
-		FreeXid(xid);
-		return -EIO;
-	}
-
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 	pTcon = cifs_sb->tcon;
 	if(pTcon == NULL)
_

Patches currently in -mm which might be from hch@lst.de are

ufs2-tindirect-truncate-fix.patch
cifs-remove-unneeded-checks.patch
xfs-use-xfs_get_buf_noaddr-for-iclogs.patch
xfs-stop-using-kmalloc-in-xfs_buf_get_noaddr.patch
xfs-stop-using-kmalloc-in-xfs_buf_get_noaddr-fix.patch
simplify-the-stacktrace-code.patch
allow-access-to-proc-pid-fd-after-setuid.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
freevxfs-possible-null-pointer-dereference-fix.patch
vfs-remove-superflous-sb-==-null-checks.patch
nameic-remove-utterly-outdated-comment.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch
aio-is-unlikely.patch
ps3fb-thread-updates.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3av-misc-updates.patch
