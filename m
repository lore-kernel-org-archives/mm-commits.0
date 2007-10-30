From: akpm@linux-foundation.org
Subject: + vfs-swap-do_ioctl-and-vfs_ioctl-names.patch added to -mm tree
Date: Tue, 30 Oct 2007 15:53:18 -0700
Message-ID: <200710302253.l9UMrIOf032148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40761 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752479AbXJ3Wxf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 18:53:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ezk@cs.sunysb.edu, hch@lst.de


The patch titled
     VFS: swap do_ioctl and vfs_ioctl names
has been added to the -mm tree.  Its filename is
     vfs-swap-do_ioctl-and-vfs_ioctl-names.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: VFS: swap do_ioctl and vfs_ioctl names
From: Erez Zadok <ezk@cs.sunysb.edu>

Rename old vfs_ioctl to do_ioctl, because the comment above it clearly
indicates that it is an internal function not to be exported to modules;
therefore it should have a more traditional do_XXX name.  The new do_ioctl
is exported in fs.h but not to modules.

Rename the old do_ioctl to vfs_ioctl because the names vfs_XXX should
preferably be reserved to callable VFS functions which modules may call, as
many other vfs_XXX functions already do.  Export the new vfs_ioctl to GPL
modules so others can use it (including Unionfs and eCryptfs).  Add DocBook
for new vfs_ioctl.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat_ioctl.c  |    2 +-
 fs/ioctl.c         |   29 +++++++++++++++++++++--------
 include/linux/fs.h |    4 +++-
 3 files changed, 25 insertions(+), 10 deletions(-)

diff -puN fs/compat_ioctl.c~vfs-swap-do_ioctl-and-vfs_ioctl-names fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~vfs-swap-do_ioctl-and-vfs_ioctl-names
+++ a/fs/compat_ioctl.c
@@ -2972,7 +2972,7 @@ asmlinkage long compat_sys_ioctl(unsigne
 	}
 
  do_ioctl:
-	error = vfs_ioctl(filp, fd, cmd, arg);
+	error = do_ioctl(filp, fd, cmd, arg);
  out_fput:
 	fput_light(filp, fput_needed);
  out:
diff -puN fs/ioctl.c~vfs-swap-do_ioctl-and-vfs_ioctl-names fs/ioctl.c
--- a/fs/ioctl.c~vfs-swap-do_ioctl-and-vfs_ioctl-names
+++ a/fs/ioctl.c
@@ -16,8 +16,20 @@
 
 #include <asm/ioctls.h>
 
-static long do_ioctl(struct file *filp, unsigned int cmd,
-		unsigned long arg)
+/**
+ * vfs_ioctl - call filesystem specific ioctl methods
+ * @filp: [in]     open file to invoke ioctl method on
+ * @cmd:  [in]     ioctl command to execute
+ * @arg:  [in/out] command-specific argument for ioctl
+ *
+ * Invokes filesystem specific ->unlocked_ioctl, if one exists; otherwise
+ * invokes * filesystem specific ->ioctl method.  If neither method exists,
+ * returns -ENOTTY.
+ *
+ * Returns 0 on success, -errno on error.
+ */
+long vfs_ioctl(struct file *filp, unsigned int cmd,
+	       unsigned long arg)
 {
 	int error = -ENOTTY;
 
@@ -39,6 +51,7 @@ static long do_ioctl(struct file *filp, 
  out:
 	return error;
 }
+EXPORT_SYMBOL_GPL(vfs_ioctl);
 
 static int file_ioctl(struct file *filp, unsigned int cmd,
 		unsigned long arg)
@@ -72,18 +85,18 @@ static int file_ioctl(struct file *filp,
 		return put_user(i_size_read(inode) - filp->f_pos, p);
 	}
 
-	return do_ioctl(filp, cmd, arg);
+	return vfs_ioctl(filp, cmd, arg);
 }
 
 /*
  * When you add any new common ioctls to the switches above and below
  * please update compat_sys_ioctl() too.
  *
- * vfs_ioctl() is not for drivers and not intended to be EXPORT_SYMBOL()'d.
+ * do_ioctl() is not for drivers and not intended to be EXPORT_SYMBOL()'d.
  * It's just a simple helper for sys_ioctl and compat_sys_ioctl.
  */
-int vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
-	      unsigned long arg)
+int do_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
+	     unsigned long arg)
 {
 	unsigned int flag;
 	int on, error = 0;
@@ -152,7 +165,7 @@ int vfs_ioctl(struct file *filp, unsigne
 		if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
 		else
-			error = do_ioctl(filp, cmd, arg);
+			error = vfs_ioctl(filp, cmd, arg);
 		break;
 	}
 	return error;
@@ -172,7 +185,7 @@ asmlinkage long sys_ioctl(unsigned int f
 	if (error)
 		goto out_fput;
 
-	error = vfs_ioctl(filp, fd, cmd, arg);
+	error = do_ioctl(filp, fd, cmd, arg);
  out_fput:
 	fput_light(filp, fput_needed);
  out:
diff -puN include/linux/fs.h~vfs-swap-do_ioctl-and-vfs_ioctl-names include/linux/fs.h
--- a/include/linux/fs.h~vfs-swap-do_ioctl-and-vfs_ioctl-names
+++ a/include/linux/fs.h
@@ -1924,7 +1924,9 @@ extern int vfs_stat_fd(int dfd, char __u
 extern int vfs_lstat_fd(int dfd, char __user *, struct kstat *);
 extern int vfs_fstat(unsigned int, struct kstat *);
 
-extern int vfs_ioctl(struct file *, unsigned int, unsigned int, unsigned long);
+extern long vfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
+extern int do_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
+		    unsigned long arg);
 
 extern void get_filesystem(struct file_system_type *fs);
 extern void put_filesystem(struct file_system_type *fs);
_

Patches currently in -mm which might be from ezk@cs.sunysb.edu are

origin.patch
vfs-apply-coding-standards-to-fs-ioctlc.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names.patch
vfs-factor-out-three-helpers-for-fibmap-fionbio-fioasync-file-ioctls.patch
git-unionfs.patch
