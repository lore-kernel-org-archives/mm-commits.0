From: akpm@linux-foundation.org
Subject: - unprivileged-mounts-allow-unprivileged-bind-mounts.patch removed from -mm tree
Date: Wed, 25 Apr 2007 18:57:10 -0700
Message-ID: <200704260157.l3Q1vAa9018401@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423040AbXDZB50 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 21:57:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, ebiederm@xmission.com, hch@lst.de, linuxram@us.ibm.com, serue@us.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     unprivileged mounts: allow unprivileged bind mounts
has been removed from the -mm tree.  Its filename was
     unprivileged-mounts-allow-unprivileged-bind-mounts.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: unprivileged mounts: allow unprivileged bind mounts
From: Miklos Szeredi <mszeredi@suse.cz>

Allow bind mounts to unprivileged users if the following conditions are met:

  - mountpoint is not a symlink or special file
  - parent mount is owned by the user
  - the number of user mounts is below the maximum

Unprivileged mounts imply MS_SETUSER, and will also have the "nosuid" and
"nodev" mount flags set.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |   80 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 59 insertions(+), 21 deletions(-)

diff -puN fs/namespace.c~unprivileged-mounts-allow-unprivileged-bind-mounts fs/namespace.c
--- a/fs/namespace.c~unprivileged-mounts-allow-unprivileged-bind-mounts
+++ a/fs/namespace.c
@@ -237,11 +237,30 @@ static void dec_nr_user_mounts(void)
 	spin_unlock(&vfsmount_lock);
 }
 
-static void set_mnt_user(struct vfsmount *mnt)
+static int reserve_user_mount(void)
+{
+	int err = 0;
+	spin_lock(&vfsmount_lock);
+	if (nr_user_mounts >= max_user_mounts && !capable(CAP_SYS_ADMIN))
+		err = -EPERM;
+	else
+		nr_user_mounts++;
+	spin_unlock(&vfsmount_lock);
+	return err;
+}
+
+static void __set_mnt_user(struct vfsmount *mnt)
 {
 	BUG_ON(mnt->mnt_flags & MNT_USER);
 	mnt->mnt_uid = current->uid;
 	mnt->mnt_flags |= MNT_USER;
+	if (!capable(CAP_SYS_ADMIN))
+		mnt->mnt_flags |= MNT_NOSUID | MNT_NODEV;
+}
+
+static void set_mnt_user(struct vfsmount *mnt)
+{
+	__set_mnt_user(mnt);
 	spin_lock(&vfsmount_lock);
 	nr_user_mounts++;
 	spin_unlock(&vfsmount_lock);
@@ -260,10 +279,16 @@ static struct vfsmount *clone_mnt(struct
 					int flag)
 {
 	struct super_block *sb = old->mnt_sb;
-	struct vfsmount *mnt = alloc_vfsmnt(old->mnt_devname);
+	struct vfsmount *mnt;
 
+	if (flag & CL_SETUSER) {
+		int err = reserve_user_mount();
+		if (err)
+			return ERR_PTR(err);
+	}
+	mnt = alloc_vfsmnt(old->mnt_devname);
 	if (!mnt)
-		return ERR_PTR(-ENOMEM);
+		goto alloc_failed;
 
 	mnt->mnt_flags = old->mnt_flags;
 	atomic_inc(&sb->s_active);
@@ -275,7 +300,7 @@ static struct vfsmount *clone_mnt(struct
 	/* don't copy the MNT_USER flag */
 	mnt->mnt_flags &= ~MNT_USER;
 	if (flag & CL_SETUSER)
-		set_mnt_user(mnt);
+		__set_mnt_user(mnt);
 
 	if (flag & CL_SLAVE) {
 		list_add(&mnt->mnt_slave, &old->mnt_slave_list);
@@ -300,6 +325,11 @@ static struct vfsmount *clone_mnt(struct
 		spin_unlock(&vfsmount_lock);
 	}
 	return mnt;
+
+ alloc_failed:
+	if (flag & CL_SETUSER)
+		dec_nr_user_mounts();
+	return ERR_PTR(-ENOMEM);
 }
 
 static inline void __mntput(struct vfsmount *mnt)
@@ -746,22 +776,29 @@ asmlinkage long sys_oldumount(char __use
 
 #endif
 
-static int mount_is_safe(struct nameidata *nd)
+/*
+ * Conditions for unprivileged mounts are:
+ * - mountpoint is not a symlink or special file
+ * - mountpoint is in a mount owned by the user
+ */
+static bool permit_mount(struct nameidata *nd, int *flags)
 {
+	struct inode *inode = nd->dentry->d_inode;
+
 	if (capable(CAP_SYS_ADMIN))
-		return 0;
-	return -EPERM;
-#ifdef notyet
-	if (S_ISLNK(nd->dentry->d_inode->i_mode))
-		return -EPERM;
-	if (nd->dentry->d_inode->i_mode & S_ISVTX) {
-		if (current->uid != nd->dentry->d_inode->i_uid)
-			return -EPERM;
-	}
-	if (vfs_permission(nd, MAY_WRITE))
-		return -EPERM;
-	return 0;
-#endif
+		return true;
+
+	if (!S_ISDIR(inode->i_mode) && !S_ISREG(inode->i_mode))
+		return false;
+
+	if (!(nd->mnt->mnt_flags & MNT_USER))
+		return false;
+
+	if (nd->mnt->mnt_uid != current->uid)
+		return false;
+
+	*flags |= MS_SETUSER;
+	return true;
 }
 
 static int lives_below_in_same_fs(struct dentry *d, struct dentry *dentry)
@@ -985,9 +1022,10 @@ static int do_loopback(struct nameidata 
 	int clone_flags;
 	struct nameidata old_nd;
 	struct vfsmount *mnt = NULL;
-	int err = mount_is_safe(nd);
-	if (err)
-		return err;
+	int err;
+
+	if (!permit_mount(nd, &flags))
+		return -EPERM;
 	if (!old_name || !*old_name)
 		return -EINVAL;
 	err = path_lookup(old_name, LOOKUP_FOLLOW, &old_nd);
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
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-allow-unprivileged-bind-mounts-fix.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
