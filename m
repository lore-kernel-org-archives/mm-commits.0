From: akpm@linux-foundation.org
Subject: - unprivileged-mounts-account-user-mounts.patch removed from -mm tree
Date: Wed, 25 Apr 2007 18:57:00 -0700
Message-ID: <200704260157.l3Q1v0XP018387@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754632AbXDZB5S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 21:57:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, ebiederm@xmission.com, hch@lst.de, linuxram@us.ibm.com, serue@us.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     unprivileged mounts: account user mounts
has been removed from the -mm tree.  Its filename was
     unprivileged-mounts-account-user-mounts.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: unprivileged mounts: account user mounts
From: Miklos Szeredi <mszeredi@suse.cz>

Add sysctl variables for accounting and limiting the number of user
mounts.

The maximum number of user mounts is set to 1024 by default.  This
won't in itself enable user mounts, setting a mount to be owned by a
user is first needed

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    9 +++++++++
 fs/namespace.c                     |   24 ++++++++++++++++++++++++
 include/linux/fs.h                 |    3 +++
 include/linux/sysctl.h             |    2 ++
 kernel/sysctl.c                    |   16 ++++++++++++++++
 5 files changed, 54 insertions(+)

diff -puN Documentation/filesystems/proc.txt~unprivileged-mounts-account-user-mounts Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~unprivileged-mounts-account-user-mounts
+++ a/Documentation/filesystems/proc.txt
@@ -923,6 +923,15 @@ reaches aio-max-nr then io_setup will fa
 raising aio-max-nr does not result in the pre-allocation or re-sizing
 of any kernel data structures.
 
+nr_user_mounts and max_user_mounts
+----------------------------------
+
+These represent the number of "user" mounts and the maximum number of
+"user" mounts respectively.  User mounts may be created by
+unprivileged users.  User mounts may also be created with sysadmin
+privileges on behalf of a user, in which case nr_user_mounts may
+exceed max_user_mounts.
+
 2.2 /proc/sys/fs/binfmt_misc - Miscellaneous binary formats
 -----------------------------------------------------------
 
diff -puN fs/namespace.c~unprivileged-mounts-account-user-mounts fs/namespace.c
--- a/fs/namespace.c~unprivileged-mounts-account-user-mounts
+++ a/fs/namespace.c
@@ -39,6 +39,9 @@ static int hash_mask __read_mostly, hash
 static struct kmem_cache *mnt_cache __read_mostly;
 static struct rw_semaphore namespace_sem;
 
+int nr_user_mounts;
+int max_user_mounts = 1024;
+
 /* /sys/fs */
 decl_subsys(fs, NULL, NULL);
 EXPORT_SYMBOL_GPL(fs_subsys);
@@ -227,11 +230,30 @@ static struct vfsmount *skip_mnt_tree(st
 	return p;
 }
 
+static void dec_nr_user_mounts(void)
+{
+	spin_lock(&vfsmount_lock);
+	nr_user_mounts--;
+	spin_unlock(&vfsmount_lock);
+}
+
 static void set_mnt_user(struct vfsmount *mnt)
 {
 	BUG_ON(mnt->mnt_flags & MNT_USER);
 	mnt->mnt_uid = current->uid;
 	mnt->mnt_flags |= MNT_USER;
+	spin_lock(&vfsmount_lock);
+	nr_user_mounts++;
+	spin_unlock(&vfsmount_lock);
+}
+
+static void clear_mnt_user(struct vfsmount *mnt)
+{
+	if (mnt->mnt_flags & MNT_USER) {
+		mnt->mnt_uid = 0;
+		mnt->mnt_flags &= ~MNT_USER;
+		dec_nr_user_mounts();
+	}
 }
 
 static struct vfsmount *clone_mnt(struct vfsmount *old, struct dentry *root,
@@ -283,6 +305,7 @@ static inline void __mntput(struct vfsmo
 {
 	struct super_block *sb = mnt->mnt_sb;
 	dput(mnt->mnt_root);
+	clear_mnt_user(mnt);
 	free_vfsmnt(mnt);
 	deactivate_super(sb);
 }
@@ -1026,6 +1049,7 @@ static int do_remount(struct nameidata *
 	down_write(&sb->s_umount);
 	err = do_remount_sb(sb, flags, data, 0);
 	if (!err) {
+		clear_mnt_user(nd->mnt);
 		nd->mnt->mnt_flags = mnt_flags;
 		if (flags & MS_SETUSER)
 			set_mnt_user(nd->mnt);
diff -puN include/linux/fs.h~unprivileged-mounts-account-user-mounts include/linux/fs.h
--- a/include/linux/fs.h~unprivileged-mounts-account-user-mounts
+++ a/include/linux/fs.h
@@ -50,6 +50,9 @@ extern struct inodes_stat_t inodes_stat;
 
 extern int leases_enable, lease_break_time;
 
+extern int nr_user_mounts;
+extern int max_user_mounts;
+
 #ifdef CONFIG_DNOTIFY
 extern int dir_notify_enable;
 #endif
diff -puN include/linux/sysctl.h~unprivileged-mounts-account-user-mounts include/linux/sysctl.h
--- a/include/linux/sysctl.h~unprivileged-mounts-account-user-mounts
+++ a/include/linux/sysctl.h
@@ -819,6 +819,8 @@ enum
 	FS_AIO_NR=18,	/* current system-wide number of aio requests */
 	FS_AIO_MAX_NR=19,	/* system-wide maximum number of aio requests */
 	FS_INOTIFY=20,	/* inotify submenu */
+	FS_NR_USER_MOUNTS=21,	/* int:current number of user mounts */
+	FS_MAX_USER_MOUNTS=22,	/* int:maximum number of user mounts */
 	FS_OCFS2=988,	/* ocfs2 */
 };
 
diff -puN kernel/sysctl.c~unprivileged-mounts-account-user-mounts kernel/sysctl.c
--- a/kernel/sysctl.c~unprivileged-mounts-account-user-mounts
+++ a/kernel/sysctl.c
@@ -1028,6 +1028,22 @@ static ctl_table fs_table[] = {
 #endif	
 #endif
 	{
+		.ctl_name	= FS_NR_USER_MOUNTS,
+		.procname	= "nr_user_mounts",
+		.data		= &nr_user_mounts,
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= FS_MAX_USER_MOUNTS,
+		.procname	= "max_user_mounts",
+		.data		= &max_user_mounts,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
 		.ctl_name	= KERN_SETUID_DUMPABLE,
 		.procname	= "suid_dumpable",
 		.data		= &suid_dumpable,
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
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-account-user-mounts-fix.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt-fix.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-allow-unprivileged-bind-mounts-fix.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
