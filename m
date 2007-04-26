From: akpm@linux-foundation.org
Subject: - unprivileged-mounts-allow-unprivileged-mounts.patch removed from -mm tree
Date: Wed, 25 Apr 2007 18:57:18 -0700
Message-ID: <200704260157.l3Q1vI0s018413@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423056AbXDZB5f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 21:57:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, ebiederm@xmission.com, hch@lst.de, linuxram@us.ibm.com, serue@us.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     unprivileged mounts: allow unprivileged mounts
has been removed from the -mm tree.  Its filename was
     unprivileged-mounts-allow-unprivileged-mounts.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: unprivileged mounts: allow unprivileged mounts
From: Miklos Szeredi <mszeredi@suse.cz>

Define a new fs flag FS_SAFE, which denotes, that unprivileged mounting of
this filesystem may not constitute a security problem.

Since most filesystems haven't been designed with unprivileged mounting in
mind, a thorough audit is needed before setting this flag.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c     |   48 ++++++++++++++++++++++++++++++++-----------
 include/linux/fs.h |    1 
 2 files changed, 37 insertions(+), 12 deletions(-)

diff -puN fs/namespace.c~unprivileged-mounts-allow-unprivileged-mounts fs/namespace.c
--- a/fs/namespace.c~unprivileged-mounts-allow-unprivileged-mounts
+++ a/fs/namespace.c
@@ -782,13 +782,17 @@ asmlinkage long sys_oldumount(char __use
  * - mountpoint is not a symlink or special file
  * - mountpoint is in a mount owned by the user
  */
-static bool permit_mount(struct nameidata *nd, int *flags)
+static bool permit_mount(struct nameidata *nd, struct file_system_type *type,
+			 int *flags)
 {
 	struct inode *inode = nd->dentry->d_inode;
 
 	if (capable(CAP_SYS_ADMIN))
 		return true;
 
+	if (type && !(type->fs_flags & FS_SAFE))
+		return false;
+
 	if (!S_ISDIR(inode->i_mode) && !S_ISREG(inode->i_mode))
 		return false;
 
@@ -1025,7 +1029,7 @@ static int do_loopback(struct nameidata 
 	struct vfsmount *mnt = NULL;
 	int err;
 
-	if (!permit_mount(nd, &flags))
+	if (!permit_mount(nd, NULL, &flags))
 		return -EPERM;
 	if (!old_name || !*old_name)
 		return -EINVAL;
@@ -1186,26 +1190,46 @@ out:
  * create a new mount for userspace and request it to be added into the
  * namespace's tree
  */
-static int do_new_mount(struct nameidata *nd, char *type, int flags,
+static int do_new_mount(struct nameidata *nd, char *fstype, int flags,
 			int mnt_flags, char *name, void *data)
 {
+	int err;
 	struct vfsmount *mnt;
+	struct file_system_type *type;
 
-	if (!type || !memchr(type, 0, PAGE_SIZE))
+	if (!fstype || !memchr(fstype, 0, PAGE_SIZE))
 		return -EINVAL;
 
-	/* we need capabilities... */
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	mnt = do_kern_mount(type, flags & ~MS_SETUSER, name, data);
-	if (IS_ERR(mnt))
+	type = get_fs_type(fstype);
+	if (!type)
+		return -ENODEV;
+
+	err = -EPERM;
+	if (!permit_mount(nd, type, &flags))
+		goto out_put_filesystem;
+
+	if (flags & MS_SETUSER) {
+		err = reserve_user_mount();
+		if (err)
+			goto out_put_filesystem;
+	}
+
+	mnt = vfs_kern_mount(type, flags & ~MS_SETUSER, name, data);
+	put_filesystem(type);
+	if (IS_ERR(mnt)) {
+		if (flags & MS_SETUSER)
+			dec_nr_user_mounts();
 		return PTR_ERR(mnt);
+	}
 
 	if (flags & MS_SETUSER)
-		set_mnt_user(mnt);
+		__set_mnt_user(mnt);
 
 	return do_add_mount(mnt, nd, mnt_flags, NULL);
+
+ out_put_filesystem:
+	put_filesystem(type);
+	return err;
 }
 
 /*
@@ -1235,7 +1259,7 @@ int do_add_mount(struct vfsmount *newmnt
 	if (S_ISLNK(newmnt->mnt_root->d_inode->i_mode))
 		goto unlock;
 
-	/* MNT_USER was set earlier */
+	/* some flags may have been set earlier */
 	newmnt->mnt_flags |= mnt_flags;
 	if ((err = graft_tree(newmnt, nd)))
 		goto unlock;
diff -puN include/linux/fs.h~unprivileged-mounts-allow-unprivileged-mounts include/linux/fs.h
--- a/include/linux/fs.h~unprivileged-mounts-allow-unprivileged-mounts
+++ a/include/linux/fs.h
@@ -96,6 +96,7 @@ extern int dir_notify_enable;
 #define FS_REQUIRES_DEV 1 
 #define FS_BINARY_MOUNTDATA 2
 #define FS_HAS_SUBTYPE 4
+#define FS_SAFE 8		/* Safe to mount by unprivileged users */
 #define FS_REVAL_DOT	16384	/* Check the paths ".", ".." for staleness */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move()
 					 * during rename() internally.
_

Patches currently in -mm which might be from mszeredi@suse.cz are

split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-filesystem-subtype-support.patch
add-file-position-info-to-proc.patch
add-file-position-info-to-proc-fix.patch
check-privileges-before-setting-mount-propagation.patch
consolidate-generic_writepages-and-mpage_writepages.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
