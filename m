From: akpm@linux-foundation.org
Subject: + vfs-factor-out-three-helpers-for-fibmap-fionbio-fioasync-file-ioctls.patch added to -mm tree
Date: Tue, 30 Oct 2007 15:53:21 -0700
Message-ID: <200710302253.l9UMrLTZ032151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33041 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753044AbXJ3Wxh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 18:53:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ezk@cs.sunysb.edu, hch@lst.de


The patch titled
     VFS: factor out three helpers for FIBMAP/FIONBIO/FIOASYNC file ioctls
has been added to the -mm tree.  Its filename is
     vfs-factor-out-three-helpers-for-fibmap-fionbio-fioasync-file-ioctls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: VFS: factor out three helpers for FIBMAP/FIONBIO/FIOASYNC file ioctls
From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ioctl.c |  129 +++++++++++++++++++++++++++++----------------------
 1 file changed, 75 insertions(+), 54 deletions(-)

diff -puN fs/ioctl.c~vfs-factor-out-three-helpers-for-fibmap-fionbio-fioasync-file-ioctls fs/ioctl.c
--- a/fs/ioctl.c~vfs-factor-out-three-helpers-for-fibmap-fionbio-fioasync-file-ioctls
+++ a/fs/ioctl.c
@@ -53,32 +53,34 @@ long vfs_ioctl(struct file *filp, unsign
 }
 EXPORT_SYMBOL_GPL(vfs_ioctl);
 
+static int ioctl_fibmap(struct file *filp, int __user *p)
+{
+	struct address_space *mapping = filp->f_mapping;
+	int res, block;
+
+	/* do we support this mess? */
+	if (!mapping->a_ops->bmap)
+		return -EINVAL;
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
+	res = get_user(block, p);
+	if (res)
+		return res;
+	lock_kernel();
+	res = mapping->a_ops->bmap(mapping, block);
+	unlock_kernel();
+	return put_user(res, p);
+}
+
 static int file_ioctl(struct file *filp, unsigned int cmd,
 		unsigned long arg)
 {
-	int error;
-	int block;
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	int __user *p = (int __user *)arg;
 
 	switch (cmd) {
 	case FIBMAP:
-	{
-		struct address_space *mapping = filp->f_mapping;
-		int res;
-		/* do we support this mess? */
-		if (!mapping->a_ops->bmap)
-			return -EINVAL;
-		if (!capable(CAP_SYS_RAWIO))
-			return -EPERM;
-		error = get_user(block, p);
-		if (error)
-			return error;
-		lock_kernel();
-		res = mapping->a_ops->bmap(mapping, block);
-		unlock_kernel();
-		return put_user(res, p);
-	}
+		return ioctl_fibmap(filp, p);
 	case FIGETBSZ:
 		return put_user(inode->i_sb->s_blocksize, p);
 	case FIONREAD:
@@ -88,6 +90,57 @@ static int file_ioctl(struct file *filp,
 	return vfs_ioctl(filp, cmd, arg);
 }
 
+static int ioctl_fionbio(struct file *filp, int __user *argp)
+{
+	unsigned int flag;
+	int on, error;
+
+	error = get_user(on, argp);
+	if (error)
+		return error;
+	flag = O_NONBLOCK;
+#ifdef __sparc__
+	/* SunOS compatibility item. */
+	if (O_NONBLOCK != O_NDELAY)
+		flag |= O_NDELAY;
+#endif
+	if (on)
+		filp->f_flags |= flag;
+	else
+		filp->f_flags &= ~flag;
+	return error;
+}
+
+static int ioctl_fioasync(unsigned int fd, struct file *filp,
+			  int __user *argp)
+{
+	unsigned int flag;
+	int on, error;
+
+	error = get_user(on, argp);
+	if (error)
+		return error;
+	flag = on ? FASYNC : 0;
+
+	/* Did FASYNC state change ? */
+	if ((flag ^ filp->f_flags) & FASYNC) {
+		if (filp->f_op && filp->f_op->fasync) {
+			lock_kernel();
+			error = filp->f_op->fasync(fd, filp, on);
+			unlock_kernel();
+		} else
+			error = -ENOTTY;
+	}
+	if (error)
+		return error;
+
+	if (on)
+		filp->f_flags |= FASYNC;
+	else
+		filp->f_flags &= ~FASYNC;
+	return error;
+}
+
 /*
  * When you add any new common ioctls to the switches above and below
  * please update compat_sys_ioctl() too.
@@ -98,8 +151,8 @@ static int file_ioctl(struct file *filp,
 int do_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 	     unsigned long arg)
 {
-	unsigned int flag;
-	int on, error = 0;
+	int error = 0;
+	int __user *argp = (int __user *)arg;
 
 	switch (cmd) {
 	case FIOCLEX:
@@ -111,43 +164,11 @@ int do_ioctl(struct file *filp, unsigned
 		break;
 
 	case FIONBIO:
-		error = get_user(on, (int __user *)arg);
-		if (error)
-			break;
-		flag = O_NONBLOCK;
-#ifdef __sparc__
-		/* SunOS compatibility item. */
-		if (O_NONBLOCK != O_NDELAY)
-			flag |= O_NDELAY;
-#endif
-		if (on)
-			filp->f_flags |= flag;
-		else
-			filp->f_flags &= ~flag;
+		error = ioctl_fionbio(filp, argp);
 		break;
 
 	case FIOASYNC:
-		error = get_user(on, (int __user *)arg);
-		if (error)
-			break;
-		flag = on ? FASYNC : 0;
-
-		/* Did FASYNC state change ? */
-		if ((flag ^ filp->f_flags) & FASYNC) {
-			if (filp->f_op && filp->f_op->fasync) {
-				lock_kernel();
-				error = filp->f_op->fasync(fd, filp, on);
-				unlock_kernel();
-			} else
-				error = -ENOTTY;
-		}
-		if (error != 0)
-			break;
-
-		if (on)
-			filp->f_flags |= FASYNC;
-		else
-			filp->f_flags &= ~FASYNC;
+		error = ioctl_fioasync(fd, filp, argp);
 		break;
 
 	case FIOQSIZE:
_

Patches currently in -mm which might be from ezk@cs.sunysb.edu are

origin.patch
vfs-apply-coding-standards-to-fs-ioctlc.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names.patch
vfs-factor-out-three-helpers-for-fibmap-fionbio-fioasync-file-ioctls.patch
git-unionfs.patch
