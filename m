From: akpm@linux-foundation.org
Subject: + rename-setleast-to-generic_setlease.patch added to -mm tree
Date: Fri, 20 Jul 2007 14:27:07 -0700
Message-ID: <200707202127.l6KLR7Tk017284@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57952 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932389AbXGTV1i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 17:27:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, bfields@fieldses.org, swhiteho@redhat.com


The patch titled
     rename setleast to generic_setlease
has been added to the -mm tree.  Its filename is
     rename-setleast-to-generic_setlease.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rename setleast to generic_setlease
From: Christoph Hellwig <hch@lst.de>

Make it a little more clear that this is the default implemenation for
the setleast operation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/ops_file.c |    2 +-
 fs/locks.c         |    8 ++++----
 include/linux/fs.h |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/gfs2/ops_file.c~rename-setleast-to-generic_setlease fs/gfs2/ops_file.c
--- a/fs/gfs2/ops_file.c~rename-setleast-to-generic_setlease
+++ a/fs/gfs2/ops_file.c
@@ -513,7 +513,7 @@ static int gfs2_setlease(struct file *fi
 	 */
 	if (!sdp->sd_args.ar_localflocks)
 		return -EINVAL;
-	return setlease(file, arg, fl);
+	return generic_setlease(file, arg, fl);
 }
 
 /**
diff -puN fs/locks.c~rename-setleast-to-generic_setlease fs/locks.c
--- a/fs/locks.c~rename-setleast-to-generic_setlease
+++ a/fs/locks.c
@@ -1324,7 +1324,7 @@ int fcntl_getlease(struct file *filp)
 }
 
 /**
- *	setlease	-	sets a lease on an open file
+ *	generic_setlease	-	sets a lease on an open file
  *	@filp: file pointer
  *	@arg: type of lease to obtain
  *	@flp: input - file_lock to use, output - file_lock inserted
@@ -1334,7 +1334,7 @@ int fcntl_getlease(struct file *filp)
  *
  *	Called with kernel lock held.
  */
-int setlease(struct file *filp, long arg, struct file_lock **flp)
+int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
 {
 	struct file_lock *fl, **before, **my_before = NULL, *lease;
 	struct dentry *dentry = filp->f_path.dentry;
@@ -1419,7 +1419,7 @@ int setlease(struct file *filp, long arg
 out:
 	return error;
 }
-EXPORT_SYMBOL(setlease);
+EXPORT_SYMBOL(generic_setlease);
 
  /**
  *	vfs_setlease        -       sets a lease on an open file
@@ -1456,7 +1456,7 @@ int vfs_setlease(struct file *filp, long
 	if (filp->f_op && filp->f_op->setlease)
 		error = filp->f_op->setlease(filp, arg, lease);
 	else
-		error = setlease(filp, arg, lease);
+		error = generic_setlease(filp, arg, lease);
 	unlock_kernel();
 
 	return error;
diff -puN include/linux/fs.h~rename-setleast-to-generic_setlease include/linux/fs.h
--- a/include/linux/fs.h~rename-setleast-to-generic_setlease
+++ a/include/linux/fs.h
@@ -934,7 +934,7 @@ extern int vfs_cancel_lock(struct file *
 extern int flock_lock_file_wait(struct file *filp, struct file_lock *fl);
 extern int __break_lease(struct inode *inode, unsigned int flags);
 extern void lease_get_mtime(struct inode *, struct timespec *time);
-extern int setlease(struct file *, long, struct file_lock **);
+extern int generic_setlease(struct file *, long, struct file_lock **);
 extern int vfs_setlease(struct file *, long, struct file_lock **);
 extern int lease_modify(struct file_lock **, int);
 extern int lock_may_read(struct inode *, loff_t start, unsigned long count);
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
coda-remove-coda_store-coda_release-upcalls.patch
gdth-remove-redundant-pci-stuff.patch
gdth-remove-redundant-pci-stuff-update.patch
git-xfs.patch
remove-handle_mm_fault-export.patch
sysv-convert-to-new-aops.patch
kill-declare_mutex_locked.patch
remove-unneded-lock_kernel-in-driver-block-loopc.patch
loop-use-unlocked_ioctl.patch
rename-setleast-to-generic_setlease.patch
spufs-make-sure-context-are-scheduled-again-after-spu_acquire_saved.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
