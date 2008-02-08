From: akpm@linux-foundation.org
Subject: - vfs-apply-coding-standards-to-fs-ioctlc.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:01:44 -0800
Message-ID: <200802080801.m1881Pm2013962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53492 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754485AbYBHIBp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:01:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ezk@cs.sunysb.edu, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     VFS: apply coding standards to fs/ioctl.c
has been removed from the -mm tree.  Its filename was
     vfs-apply-coding-standards-to-fs-ioctlc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: VFS: apply coding standards to fs/ioctl.c
From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ioctl.c |  168 ++++++++++++++++++++++++++-------------------------
 1 file changed, 86 insertions(+), 82 deletions(-)

diff -puN fs/ioctl.c~vfs-apply-coding-standards-to-fs-ioctlc fs/ioctl.c
--- a/fs/ioctl.c~vfs-apply-coding-standards-to-fs-ioctlc
+++ a/fs/ioctl.c
@@ -12,8 +12,8 @@
 #include <linux/fs.h>
 #include <linux/security.h>
 #include <linux/module.h>
+#include <linux/uaccess.h>
 
-#include <asm/uaccess.h>
 #include <asm/ioctls.h>
 
 static long do_ioctl(struct file *filp, unsigned int cmd,
@@ -45,31 +45,31 @@ static int file_ioctl(struct file *filp,
 {
 	int error;
 	int block;
-	struct inode * inode = filp->f_path.dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	int __user *p = (int __user *)arg;
 
 	switch (cmd) {
-		case FIBMAP:
-		{
-			struct address_space *mapping = filp->f_mapping;
-			int res;
-			/* do we support this mess? */
-			if (!mapping->a_ops->bmap)
-				return -EINVAL;
-			if (!capable(CAP_SYS_RAWIO))
-				return -EPERM;
-			if ((error = get_user(block, p)) != 0)
-				return error;
-
-			lock_kernel();
-			res = mapping->a_ops->bmap(mapping, block);
-			unlock_kernel();
-			return put_user(res, p);
-		}
-		case FIGETBSZ:
-			return put_user(inode->i_sb->s_blocksize, p);
-		case FIONREAD:
-			return put_user(i_size_read(inode) - filp->f_pos, p);
+	case FIBMAP:
+	{
+		struct address_space *mapping = filp->f_mapping;
+		int res;
+		/* do we support this mess? */
+		if (!mapping->a_ops->bmap)
+			return -EINVAL;
+		if (!capable(CAP_SYS_RAWIO))
+			return -EPERM;
+		error = get_user(block, p);
+		if (error)
+			return error;
+		lock_kernel();
+		res = mapping->a_ops->bmap(mapping, block);
+		unlock_kernel();
+		return put_user(res, p);
+	}
+	case FIGETBSZ:
+		return put_user(inode->i_sb->s_blocksize, p);
+	case FIONREAD:
+		return put_user(i_size_read(inode) - filp->f_pos, p);
 	}
 
 	return do_ioctl(filp, cmd, arg);
@@ -82,81 +82,85 @@ static int file_ioctl(struct file *filp,
  * vfs_ioctl() is not for drivers and not intended to be EXPORT_SYMBOL()'d.
  * It's just a simple helper for sys_ioctl and compat_sys_ioctl.
  */
-int vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd, unsigned long arg)
+int vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
+	      unsigned long arg)
 {
 	unsigned int flag;
 	int on, error = 0;
 
 	switch (cmd) {
-		case FIOCLEX:
-			set_close_on_exec(fd, 1);
+	case FIOCLEX:
+		set_close_on_exec(fd, 1);
+		break;
+
+	case FIONCLEX:
+		set_close_on_exec(fd, 0);
+		break;
+
+	case FIONBIO:
+		error = get_user(on, (int __user *)arg);
+		if (error)
 			break;
-
-		case FIONCLEX:
-			set_close_on_exec(fd, 0);
-			break;
-
-		case FIONBIO:
-			if ((error = get_user(on, (int __user *)arg)) != 0)
-				break;
-			flag = O_NONBLOCK;
+		flag = O_NONBLOCK;
 #ifdef __sparc__
-			/* SunOS compatibility item. */
-			if(O_NONBLOCK != O_NDELAY)
-				flag |= O_NDELAY;
+		/* SunOS compatibility item. */
+		if (O_NONBLOCK != O_NDELAY)
+			flag |= O_NDELAY;
 #endif
-			if (on)
-				filp->f_flags |= flag;
-			else
-				filp->f_flags &= ~flag;
-			break;
-
-		case FIOASYNC:
-			if ((error = get_user(on, (int __user *)arg)) != 0)
-				break;
-			flag = on ? FASYNC : 0;
-
-			/* Did FASYNC state change ? */
-			if ((flag ^ filp->f_flags) & FASYNC) {
-				if (filp->f_op && filp->f_op->fasync) {
-					lock_kernel();
-					error = filp->f_op->fasync(fd, filp, on);
-					unlock_kernel();
-				}
-				else error = -ENOTTY;
-			}
-			if (error != 0)
-				break;
-
-			if (on)
-				filp->f_flags |= FASYNC;
-			else
-				filp->f_flags &= ~FASYNC;
-			break;
-
-		case FIOQSIZE:
-			if (S_ISDIR(filp->f_path.dentry->d_inode->i_mode) ||
-			    S_ISREG(filp->f_path.dentry->d_inode->i_mode) ||
-			    S_ISLNK(filp->f_path.dentry->d_inode->i_mode)) {
-				loff_t res = inode_get_bytes(filp->f_path.dentry->d_inode);
-				error = copy_to_user((loff_t __user *)arg, &res, sizeof(res)) ? -EFAULT : 0;
-			}
-			else
+		if (on)
+			filp->f_flags |= flag;
+		else
+			filp->f_flags &= ~flag;
+		break;
+
+	case FIOASYNC:
+		error = get_user(on, (int __user *)arg);
+		if (error)
+			break;
+		flag = on ? FASYNC : 0;
+
+		/* Did FASYNC state change ? */
+		if ((flag ^ filp->f_flags) & FASYNC) {
+			if (filp->f_op && filp->f_op->fasync) {
+				lock_kernel();
+				error = filp->f_op->fasync(fd, filp, on);
+				unlock_kernel();
+			} else
 				error = -ENOTTY;
+		}
+		if (error != 0)
 			break;
-		default:
-			if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
-				error = file_ioctl(filp, cmd, arg);
-			else
-				error = do_ioctl(filp, cmd, arg);
-			break;
+
+		if (on)
+			filp->f_flags |= FASYNC;
+		else
+			filp->f_flags &= ~FASYNC;
+		break;
+
+	case FIOQSIZE:
+		if (S_ISDIR(filp->f_path.dentry->d_inode->i_mode) ||
+		    S_ISREG(filp->f_path.dentry->d_inode->i_mode) ||
+		    S_ISLNK(filp->f_path.dentry->d_inode->i_mode)) {
+			loff_t res =
+				inode_get_bytes(filp->f_path.dentry->d_inode);
+			error = copy_to_user((loff_t __user *)arg, &res,
+					     sizeof(res)) ? -EFAULT : 0;
+		} else
+			error = -ENOTTY;
+		break;
+	default:
+		if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
+			error = file_ioctl(filp, cmd, arg);
+		else
+			error = do_ioctl(filp, cmd, arg);
+		break;
 	}
 	return error;
 }
 
 asmlinkage long sys_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg)
 {
-	struct file * filp;
+	struct file *filp;
 	int error = -EBADF;
 	int fput_needed;
 
_

Patches currently in -mm which might be from ezk@cs.sunysb.edu are

origin.patch
git-unionfs.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
create-file_drop_write_access-helper.patch
fix-up-new-filp-allocators.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
use-struct-path-in-struct-svc_export-nfsd-fix-wrong-mnt_writer-count-in-rename.patch
