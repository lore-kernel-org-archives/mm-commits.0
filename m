From: akpm@linux-foundation.org
Subject: + reiserfs-eliminate-private-use-of-struct-file-in-xattr.patch added to -mm tree
Date: Tue, 27 Nov 2007 13:06:45 -0800
Message-ID: <200711272106.lARL6jUt030378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43286 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755484AbXK0VHB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 16:07:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeffm@suse.de, haveblue@us.ibm.com, hch@lst.de, jeffm@suse.com, mason@suse.com


The patch titled
     reiserfs: eliminate private use of struct file in xattr code
has been added to the -mm tree.  Its filename is
     reiserfs-eliminate-private-use-of-struct-file-in-xattr.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiserfs: eliminate private use of struct file in xattr code
From: Jeff Mahoney <jeffm@suse.de>

After several posts and bug reports regarding interaction with the NULL
nameidata, here's a patch to clean up the mess with struct file in the
reiserfs xattr code.

As observed in several of the posts, there's really no need for struct file
to exist in the xattr code.  It was really only passed around due to the
f_op->readdir() and a_ops->{prepare,commit}_write prototypes requiring it.

reiserfs_prepare_write() and reiserfs_commit_write() don't actually use the
struct file passed to it, and the xattr code uses a private version of
reiserfs_readdir() to enumerate the xattr directories.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Chris Mason <mason@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/xattr.c |  110 +++++++++++-------------------------------
 1 file changed, 30 insertions(+), 80 deletions(-)

diff -puN fs/reiserfs/xattr.c~reiserfs-eliminate-private-use-of-struct-file-in-xattr fs/reiserfs/xattr.c
--- a/fs/reiserfs/xattr.c~reiserfs-eliminate-private-use-of-struct-file-in-xattr
+++ a/fs/reiserfs/xattr.c
@@ -191,28 +191,11 @@ static struct dentry *get_xa_file_dentry
 	dput(xadir);
 	if (err)
 		xafile = ERR_PTR(err);
-	return xafile;
-}
-
-/* Opens a file pointer to the attribute associated with inode */
-static struct file *open_xa_file(const struct inode *inode, const char *name,
-				 int flags)
-{
-	struct dentry *xafile;
-	struct file *fp;
-
-	xafile = get_xa_file_dentry(inode, name, flags);
-	if (IS_ERR(xafile))
-		return ERR_PTR(PTR_ERR(xafile));
 	else if (!xafile->d_inode) {
 		dput(xafile);
-		return ERR_PTR(-ENODATA);
+		xafile = ERR_PTR(-ENODATA);
 	}
-
-	fp = dentry_open(xafile, NULL, O_RDWR);
-	/* dentry_open dputs the dentry if it fails */
-
-	return fp;
+	return xafile;
 }
 
 /*
@@ -228,9 +211,8 @@ static struct file *open_xa_file(const s
  * we're called with i_mutex held, so there are no worries about the directory
  * changing underneath us.
  */
-static int __xattr_readdir(struct file *filp, void *dirent, filldir_t filldir)
+static int __xattr_readdir(struct inode *inode, void *dirent, filldir_t filldir)
 {
-	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct cpu_key pos_key;	/* key of current position in the directory (key of directory entry) */
 	INITIALIZE_PATH(path_to_entry);
 	struct buffer_head *bh;
@@ -374,23 +356,16 @@ static int __xattr_readdir(struct file *
  *
  */
 static
-int xattr_readdir(struct file *file, filldir_t filler, void *buf)
+int xattr_readdir(struct inode *inode, filldir_t filler, void *buf)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	int res = -ENOTDIR;
-	if (!file->f_op || !file->f_op->readdir)
-		goto out;
+	int res = -ENOENT;
 	mutex_lock_nested(&inode->i_mutex, I_MUTEX_XATTR);
-//        down(&inode->i_zombie);
-	res = -ENOENT;
 	if (!IS_DEADDIR(inode)) {
 		lock_kernel();
-		res = __xattr_readdir(file, buf, filler);
+		res = __xattr_readdir(inode, buf, filler);
 		unlock_kernel();
 	}
-//        up(&inode->i_zombie);
 	mutex_unlock(&inode->i_mutex);
-      out:
 	return res;
 }
 
@@ -442,7 +417,7 @@ reiserfs_xattr_set(struct inode *inode, 
 		   size_t buffer_size, int flags)
 {
 	int err = 0;
-	struct file *fp;
+	struct dentry *dentry;
 	struct page *page;
 	char *data;
 	struct address_space *mapping;
@@ -460,18 +435,18 @@ reiserfs_xattr_set(struct inode *inode, 
 		xahash = xattr_hash(buffer, buffer_size);
 
       open_file:
-	fp = open_xa_file(inode, name, flags);
-	if (IS_ERR(fp)) {
-		err = PTR_ERR(fp);
+	dentry = get_xa_file_dentry(inode, name, flags);
+	if (IS_ERR(dentry)) {
+		err = PTR_ERR(dentry);
 		goto out;
 	}
 
-	xinode = fp->f_path.dentry->d_inode;
+	xinode = dentry->d_inode;
 	REISERFS_I(inode)->i_flags |= i_has_xattr_dir;
 
 	/* we need to copy it off.. */
 	if (xinode->i_nlink > 1) {
-		fput(fp);
+		dput(dentry);
 		err = reiserfs_xattr_del(inode, name);
 		if (err < 0)
 			goto out;
@@ -485,7 +460,7 @@ reiserfs_xattr_set(struct inode *inode, 
 	newattrs.ia_size = buffer_size;
 	newattrs.ia_valid = ATTR_SIZE | ATTR_CTIME;
 	mutex_lock_nested(&xinode->i_mutex, I_MUTEX_XATTR);
-	err = notify_change(fp->f_path.dentry, &newattrs);
+	err = notify_change(dentry, &newattrs);
 	if (err)
 		goto out_filp;
 
@@ -518,15 +493,14 @@ reiserfs_xattr_set(struct inode *inode, 
 			rxh->h_hash = cpu_to_le32(xahash);
 		}
 
-		err = reiserfs_prepare_write(fp, page, page_offset,
+		err = reiserfs_prepare_write(NULL, page, page_offset,
 					    page_offset + chunk + skip);
 		if (!err) {
 			if (buffer)
 				memcpy(data + skip, buffer + buffer_pos, chunk);
-			err =
-			    reiserfs_commit_write(fp, page, page_offset,
-						  page_offset + chunk +
-						  skip);
+			err = reiserfs_commit_write(NULL, page, page_offset,
+						    page_offset + chunk +
+						    skip);
 		}
 		unlock_page(page);
 		reiserfs_put_page(page);
@@ -548,7 +522,7 @@ reiserfs_xattr_set(struct inode *inode, 
 
       out_filp:
 	mutex_unlock(&xinode->i_mutex);
-	fput(fp);
+	dput(dentry);
 
       out:
 	return err;
@@ -562,7 +536,7 @@ reiserfs_xattr_get(const struct inode *i
 		   size_t buffer_size)
 {
 	ssize_t err = 0;
-	struct file *fp;
+	struct dentry *dentry;
 	size_t isize;
 	size_t file_pos = 0;
 	size_t buffer_pos = 0;
@@ -578,13 +552,13 @@ reiserfs_xattr_get(const struct inode *i
 	if (get_inode_sd_version(inode) == STAT_DATA_V1)
 		return -EOPNOTSUPP;
 
-	fp = open_xa_file(inode, name, FL_READONLY);
-	if (IS_ERR(fp)) {
-		err = PTR_ERR(fp);
+	dentry = get_xa_file_dentry(inode, name, FL_READONLY);
+	if (IS_ERR(dentry)) {
+		err = PTR_ERR(dentry);
 		goto out;
 	}
 
-	xinode = fp->f_path.dentry->d_inode;
+	xinode = dentry->d_inode;
 	isize = xinode->i_size;
 	REISERFS_I(inode)->i_flags |= i_has_xattr_dir;
 
@@ -652,7 +626,7 @@ reiserfs_xattr_get(const struct inode *i
 	}
 
       out_dput:
-	fput(fp);
+	dput(dentry);
 
       out:
 	return err;
@@ -742,7 +716,6 @@ reiserfs_delete_xattrs_filler(void *buf,
 /* This is called w/ inode->i_mutex downed */
 int reiserfs_delete_xattrs(struct inode *inode)
 {
-	struct file *fp;
 	struct dentry *dir, *root;
 	int err = 0;
 
@@ -763,15 +736,8 @@ int reiserfs_delete_xattrs(struct inode 
 		return 0;
 	}
 
-	fp = dentry_open(dir, NULL, O_RDWR);
-	if (IS_ERR(fp)) {
-		err = PTR_ERR(fp);
-		/* dentry_open dputs the dentry if it fails */
-		goto out;
-	}
-
 	lock_kernel();
-	err = xattr_readdir(fp, reiserfs_delete_xattrs_filler, dir);
+	err = xattr_readdir(dir->d_inode, reiserfs_delete_xattrs_filler, dir);
 	if (err) {
 		unlock_kernel();
 		goto out_dir;
@@ -791,7 +757,7 @@ int reiserfs_delete_xattrs(struct inode 
 	unlock_kernel();
 
       out_dir:
-	fput(fp);
+	dput(dir);
 
       out:
 	if (!err)
@@ -833,7 +799,6 @@ reiserfs_chown_xattrs_filler(void *buf, 
 
 int reiserfs_chown_xattrs(struct inode *inode, struct iattr *attrs)
 {
-	struct file *fp;
 	struct dentry *dir;
 	int err = 0;
 	struct reiserfs_chown_buf buf;
@@ -857,13 +822,6 @@ int reiserfs_chown_xattrs(struct inode *
 		goto out;
 	}
 
-	fp = dentry_open(dir, NULL, O_RDWR);
-	if (IS_ERR(fp)) {
-		err = PTR_ERR(fp);
-		/* dentry_open dputs the dentry if it fails */
-		goto out;
-	}
-
 	lock_kernel();
 
 	attrs->ia_valid &= (ATTR_UID | ATTR_GID | ATTR_CTIME);
@@ -871,7 +829,7 @@ int reiserfs_chown_xattrs(struct inode *
 	buf.attrs = attrs;
 	buf.inode = inode;
 
-	err = xattr_readdir(fp, reiserfs_chown_xattrs_filler, &buf);
+	err = xattr_readdir(dir->d_inode, reiserfs_chown_xattrs_filler, &buf);
 	if (err) {
 		unlock_kernel();
 		goto out_dir;
@@ -881,7 +839,7 @@ int reiserfs_chown_xattrs(struct inode *
 	unlock_kernel();
 
       out_dir:
-	fput(fp);
+	dput(dir);
 
       out:
 	attrs->ia_valid = ia_valid;
@@ -1029,7 +987,6 @@ reiserfs_listxattr_filler(void *buf, con
  */
 ssize_t reiserfs_listxattr(struct dentry * dentry, char *buffer, size_t size)
 {
-	struct file *fp;
 	struct dentry *dir;
 	int err = 0;
 	struct reiserfs_listxattr_buf buf;
@@ -1052,13 +1009,6 @@ ssize_t reiserfs_listxattr(struct dentry
 		goto out;
 	}
 
-	fp = dentry_open(dir, NULL, O_RDWR);
-	if (IS_ERR(fp)) {
-		err = PTR_ERR(fp);
-		/* dentry_open dputs the dentry if it fails */
-		goto out;
-	}
-
 	buf.r_buf = buffer;
 	buf.r_size = buffer ? size : 0;
 	buf.r_pos = 0;
@@ -1066,7 +1016,7 @@ ssize_t reiserfs_listxattr(struct dentry
 
 	REISERFS_I(dentry->d_inode)->i_flags |= i_has_xattr_dir;
 
-	err = xattr_readdir(fp, reiserfs_listxattr_filler, &buf);
+	err = xattr_readdir(dir->d_inode, reiserfs_listxattr_filler, &buf);
 	if (err)
 		goto out_dir;
 
@@ -1076,7 +1026,7 @@ ssize_t reiserfs_listxattr(struct dentry
 		err = buf.r_pos;
 
       out_dir:
-	fput(fp);
+	dput(dir);
 
       out:
 	reiserfs_read_unlock_xattr_i(dentry->d_inode);
_

Patches currently in -mm which might be from jeffm@suse.de are

reiserfs-eliminate-private-use-of-struct-file-in-xattr.patch
