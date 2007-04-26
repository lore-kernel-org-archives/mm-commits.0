From: akpm@linux-foundation.org
Subject: - unprivileged-mounts-add-user-mounts-to-the-kernel.patch removed from -mm tree
Date: Wed, 25 Apr 2007 18:56:55 -0700
Message-ID: <200704260156.l3Q1ut7j018381@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46130 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754041AbXDZB5O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 21:57:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, ebiederm@xmission.com, hch@lst.de, linuxram@us.ibm.com, serue@us.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     unprivileged mounts: add user mounts to the kernel
has been removed from the -mm tree.  Its filename was
     unprivileged-mounts-add-user-mounts-to-the-kernel.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: unprivileged mounts: add user mounts to the kernel
From: Miklos Szeredi <mszeredi@suse.cz>

This patchset adds support for keeping mount ownership information in the
kernel, and allow unprivileged mount(2) and umount(2) in certain cases.

The mount owner has the following privileges:

  - unmount the owned mount
  - create a submount under the owned mount

The sysadmin can set the owner explicitly on mount and remount.  When an
unprivileged user creates a mount, then the owner is automatically set to the
user.

The following use cases are envisioned:

1) Private namespace, with selected mounts owned by user.  E.g. 
   /home/$USER is a good candidate for allowing unpriv mounts and unmounts
   within.

2) Private namespace, with all mounts owned by user and having the "nosuid"
   flag.  User can mount and umount anywhere within the namespace, but suid
   programs will not work.

3) Global namespace, with a designated directory, which is a mount owned by
   the user.  E.g.  /mnt/users/$USER is set up so that it is bind mounted onto
   itself, and set to be owned by $USER.  The user can add/remove mounts only
   under this directory.

The following extra security measures are taken for unprivileged mounts:

 - usermounts are limited by a sysctl tunable
 - force "nosuid,nodev" mount options on the created mount




This patch:


A new mount flag, MS_SETUSER is used to make a mount owned by a user.  If this
flag is specified, then the owner will be set to the current real user id and
the mount will be marked with the MNT_USER flag.  On remount don't preserve
previous owner, and treat MS_SETUSER as for a new mount.  The MS_SETUSER flag
is ignored on mount move.

The MNT_USER flag is not copied on any kind of mount cloning: namespace
creation, binding or propagation.  For bind mounts the cloned mount(s) are set
to MNT_USER depending on the MS_SETUSER mount flag.  In all the other cases
MNT_USER is always cleared.

For MNT_USER mounts a "user=UID" option is added to /proc/PID/mounts.  This is
compatible with how mount ownership is stored in /etc/mtab.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c        |   39 +++++++++++++++++++++++++++++++--------
 fs/pnode.h            |    1 +
 include/linux/fs.h    |    1 +
 include/linux/mount.h |    3 +++
 4 files changed, 36 insertions(+), 8 deletions(-)

diff -puN fs/namespace.c~unprivileged-mounts-add-user-mounts-to-the-kernel fs/namespace.c
--- a/fs/namespace.c~unprivileged-mounts-add-user-mounts-to-the-kernel
+++ a/fs/namespace.c
@@ -227,6 +227,13 @@ static struct vfsmount *skip_mnt_tree(st
 	return p;
 }
 
+static void set_mnt_user(struct vfsmount *mnt)
+{
+	BUG_ON(mnt->mnt_flags & MNT_USER);
+	mnt->mnt_uid = current->uid;
+	mnt->mnt_flags |= MNT_USER;
+}
+
 static struct vfsmount *clone_mnt(struct vfsmount *old, struct dentry *root,
 					int flag)
 {
@@ -241,6 +248,11 @@ static struct vfsmount *clone_mnt(struct
 		mnt->mnt_mountpoint = mnt->mnt_root;
 		mnt->mnt_parent = mnt;
 
+		/* don't copy the MNT_USER flag */
+		mnt->mnt_flags &= ~MNT_USER;
+		if (flag & CL_SETUSER)
+			set_mnt_user(mnt);
+
 		if (flag & CL_SLAVE) {
 			list_add(&mnt->mnt_slave, &old->mnt_slave_list);
 			mnt->mnt_master = old;
@@ -403,6 +415,8 @@ static int show_vfsmnt(struct seq_file *
 		if (mnt->mnt_flags & fs_infop->flag)
 			seq_puts(m, fs_infop->str);
 	}
+	if (mnt->mnt_flags & MNT_USER)
+		seq_printf(m, ",user=%i", mnt->mnt_uid);
 	if (mnt->mnt_sb->s_op->show_options)
 		err = mnt->mnt_sb->s_op->show_options(m, mnt);
 	seq_puts(m, " 0 0\n");
@@ -923,8 +937,9 @@ static int do_change_type(struct nameida
 /*
  * do loopback mount.
  */
-static int do_loopback(struct nameidata *nd, char *old_name, int recurse)
+static int do_loopback(struct nameidata *nd, char *old_name, int flags)
 {
+	int clone_flags;
 	struct nameidata old_nd;
 	struct vfsmount *mnt = NULL;
 	int err = mount_is_safe(nd);
@@ -944,11 +959,12 @@ static int do_loopback(struct nameidata 
 	if (!check_mnt(nd->mnt) || !check_mnt(old_nd.mnt))
 		goto out;
 
+	clone_flags = (flags & MS_SETUSER) ? CL_SETUSER : 0;
 	err = -ENOMEM;
-	if (recurse)
-		mnt = copy_tree(old_nd.mnt, old_nd.dentry, 0);
+	if (flags & MS_REC)
+		mnt = copy_tree(old_nd.mnt, old_nd.dentry, clone_flags);
 	else
-		mnt = clone_mnt(old_nd.mnt, old_nd.dentry, 0);
+		mnt = clone_mnt(old_nd.mnt, old_nd.dentry, clone_flags);
 
 	if (!mnt)
 		goto out;
@@ -990,8 +1006,11 @@ static int do_remount(struct nameidata *
 
 	down_write(&sb->s_umount);
 	err = do_remount_sb(sb, flags, data, 0);
-	if (!err)
+	if (!err) {
 		nd->mnt->mnt_flags = mnt_flags;
+		if (flags & MS_SETUSER)
+			set_mnt_user(nd->mnt);
+	}
 	up_write(&sb->s_umount);
 	if (!err)
 		security_sb_post_remount(nd->mnt, flags, data);
@@ -1096,10 +1115,13 @@ static int do_new_mount(struct nameidata
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	mnt = do_kern_mount(type, flags, name, data);
+	mnt = do_kern_mount(type, flags & ~MS_SETUSER, name, data);
 	if (IS_ERR(mnt))
 		return PTR_ERR(mnt);
 
+	if (flags & MS_SETUSER)
+		set_mnt_user(mnt);
+
 	return do_add_mount(mnt, nd, mnt_flags, NULL);
 }
 
@@ -1130,7 +1152,8 @@ int do_add_mount(struct vfsmount *newmnt
 	if (S_ISLNK(newmnt->mnt_root->d_inode->i_mode))
 		goto unlock;
 
-	newmnt->mnt_flags = mnt_flags;
+	/* MNT_USER was set earlier */
+	newmnt->mnt_flags |= mnt_flags;
 	if ((err = graft_tree(newmnt, nd)))
 		goto unlock;
 
@@ -1450,7 +1473,7 @@ long do_mount(char *dev_name, char *dir_
 		retval = do_remount(&nd, flags & ~MS_REMOUNT, mnt_flags,
 				    data_page);
 	else if (flags & MS_BIND)
-		retval = do_loopback(&nd, dev_name, flags & MS_REC);
+		retval = do_loopback(&nd, dev_name, flags);
 	else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
 		retval = do_change_type(&nd, flags);
 	else if (flags & MS_MOVE)
diff -puN fs/pnode.h~unprivileged-mounts-add-user-mounts-to-the-kernel fs/pnode.h
--- a/fs/pnode.h~unprivileged-mounts-add-user-mounts-to-the-kernel
+++ a/fs/pnode.h
@@ -22,6 +22,7 @@
 #define CL_COPY_ALL 		0x04
 #define CL_MAKE_SHARED 		0x08
 #define CL_PROPAGATION 		0x10
+#define CL_SETUSER		0x20
 
 static inline void set_mnt_shared(struct vfsmount *mnt)
 {
diff -puN include/linux/fs.h~unprivileged-mounts-add-user-mounts-to-the-kernel include/linux/fs.h
--- a/include/linux/fs.h~unprivileged-mounts-add-user-mounts-to-the-kernel
+++ a/include/linux/fs.h
@@ -123,6 +123,7 @@ extern int dir_notify_enable;
 #define MS_SLAVE	(1<<19)	/* change to slave */
 #define MS_SHARED	(1<<20)	/* change to shared */
 #define MS_RELATIME	(1<<21)	/* Update atime relative to mtime/ctime. */
+#define MS_SETUSER	(1<<22) /* set mnt_uid to current user */
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
 
diff -puN include/linux/mount.h~unprivileged-mounts-add-user-mounts-to-the-kernel include/linux/mount.h
--- a/include/linux/mount.h~unprivileged-mounts-add-user-mounts-to-the-kernel
+++ a/include/linux/mount.h
@@ -30,6 +30,7 @@ struct mnt_namespace;
 #define MNT_RELATIME	0x20
 
 #define MNT_SHRINKABLE	0x100
+#define MNT_USER	0x200
 
 #define MNT_SHARED	0x1000	/* if the vfsmount is a shared mount */
 #define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
@@ -61,6 +62,8 @@ struct vfsmount {
 	atomic_t mnt_count;
 	int mnt_expiry_mark;		/* true if marked for expiry */
 	int mnt_pinned;
+
+	uid_t mnt_uid;			/* owner of the mount */
 };
 
 static inline struct vfsmount *mntget(struct vfsmount *mnt)
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
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-account-user-mounts-fix.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt-fix.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-allow-unprivileged-bind-mounts-fix.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
