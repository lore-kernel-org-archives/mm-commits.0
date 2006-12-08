From: akpm@osdl.org
Subject: - struct-path-convert-usb.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:05:23 -0800
Message-ID: <200612082005.kB8K5Nob002292@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57506 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426197AbWLHUF1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:05:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert usb
has been removed from the -mm tree.  Its filename was
     struct-path-convert-usb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert usb
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/core/inode.c            |    4 ++--
 drivers/usb/gadget/file_storage.c   |   16 ++++++++--------
 drivers/usb/misc/sisusbvga/sisusb.c |    2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/usb/core/inode.c~struct-path-convert-usb drivers/usb/core/inode.c
--- a/drivers/usb/core/inode.c~struct-path-convert-usb
+++ a/drivers/usb/core/inode.c
@@ -379,7 +379,7 @@ static loff_t default_file_lseek (struct
 {
 	loff_t retval = -EINVAL;
 
-	mutex_lock(&file->f_dentry->d_inode->i_mutex);
+	mutex_lock(&file->f_path.dentry->d_inode->i_mutex);
 	switch(orig) {
 	case 0:
 		if (offset > 0) {
@@ -396,7 +396,7 @@ static loff_t default_file_lseek (struct
 	default:
 		break;
 	}
-	mutex_unlock(&file->f_dentry->d_inode->i_mutex);
+	mutex_unlock(&file->f_path.dentry->d_inode->i_mutex);
 	return retval;
 }
 
diff -puN drivers/usb/gadget/file_storage.c~struct-path-convert-usb drivers/usb/gadget/file_storage.c
--- a/drivers/usb/gadget/file_storage.c~struct-path-convert-usb
+++ a/drivers/usb/gadget/file_storage.c
@@ -1909,10 +1909,10 @@ static int fsync_sub(struct lun *curlun)
 	if (!filp->f_op->fsync)
 		return -EINVAL;
 
-	inode = filp->f_dentry->d_inode;
+	inode = filp->f_path.dentry->d_inode;
 	mutex_lock(&inode->i_mutex);
 	rc = filemap_fdatawrite(inode->i_mapping);
-	err = filp->f_op->fsync(filp, filp->f_dentry, 1);
+	err = filp->f_op->fsync(filp, filp->f_path.dentry, 1);
 	if (!rc)
 		rc = err;
 	err = filemap_fdatawait(inode->i_mapping);
@@ -1950,7 +1950,7 @@ static int do_synchronize_cache(struct f
 static void invalidate_sub(struct lun *curlun)
 {
 	struct file	*filp = curlun->filp;
-	struct inode	*inode = filp->f_dentry->d_inode;
+	struct inode	*inode = filp->f_path.dentry->d_inode;
 	unsigned long	rc;
 
 	rc = invalidate_inode_pages(inode->i_mapping);
@@ -3526,8 +3526,8 @@ static int open_backing_file(struct lun 
 	if (!(filp->f_mode & FMODE_WRITE))
 		ro = 1;
 
-	if (filp->f_dentry)
-		inode = filp->f_dentry->d_inode;
+	if (filp->f_path.dentry)
+		inode = filp->f_path.dentry->d_inode;
 	if (inode && S_ISBLK(inode->i_mode)) {
 		if (bdev_read_only(inode->i_bdev))
 			ro = 1;
@@ -3606,7 +3606,7 @@ static ssize_t show_file(struct device *
 
 	down_read(&fsg->filesem);
 	if (backing_file_is_open(curlun)) {	// Get the complete pathname
-		p = d_path(curlun->filp->f_dentry, curlun->filp->f_vfsmnt,
+		p = d_path(curlun->filp->f_path.dentry, curlun->filp->f_path.mnt,
 				buf, PAGE_SIZE - 1);
 		if (IS_ERR(p))
 			rc = PTR_ERR(p);
@@ -4030,8 +4030,8 @@ static int __init fsg_bind(struct usb_ga
 		if (backing_file_is_open(curlun)) {
 			p = NULL;
 			if (pathbuf) {
-				p = d_path(curlun->filp->f_dentry,
-					curlun->filp->f_vfsmnt,
+				p = d_path(curlun->filp->f_path.dentry,
+					curlun->filp->f_path.mnt,
 					pathbuf, PATH_MAX);
 				if (IS_ERR(p))
 					p = NULL;
diff -puN drivers/usb/misc/sisusbvga/sisusb.c~struct-path-convert-usb drivers/usb/misc/sisusbvga/sisusb.c
--- a/drivers/usb/misc/sisusbvga/sisusb.c~struct-path-convert-usb
+++ a/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3168,7 +3168,7 @@ sisusb_compat_ioctl(struct file *f, unsi
 		case SISUSB_GET_CONFIG:
 		case SISUSB_COMMAND:
 			lock_kernel();
-			retval = sisusb_ioctl(f->f_dentry->d_inode, f, cmd, arg);
+			retval = sisusb_ioctl(f->f_path.dentry->d_inode, f, cmd, arg);
 			unlock_kernel();
 			return retval;
 
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-usb.patch
struct-path-convert-v4l.patch
struct-path-convert-video.patch
struct-path-convert-zorro.patch

