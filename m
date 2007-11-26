From: akpm@linux-foundation.org
Subject: - unprivileged-mounts-account-user-mounts.patch removed from -mm tree
Date: Mon, 26 Nov 2007 11:35:36 -0800
Message-ID: <200711261935.lAQJZapM019235@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44987 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753830AbXKZTf7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 14:35:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, hch@lst.de, linuxram@us.ibm.com, mm-commits@vger.kernel.org


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

[akpm]
 - don't use enumerated sysctls

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    9 +++++++++
 fs/namespace.c                     |   24 ++++++++++++++++++++++++
 include/linux/fs.h                 |    3 +++
 kernel/sysctl.c                    |   16 ++++++++++++++++
 4 files changed, 52 insertions(+)

diff -puN Documentation/filesystems/proc.txt~unprivileged-mounts-account-user-mounts Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~unprivileged-mounts-account-user-mounts
+++ a/Documentation/filesystems/proc.txt
@@ -1004,6 +1004,15 @@ reaches aio-max-nr then io_setup will fa
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
@@ -40,6 +40,9 @@ static int hash_mask __read_mostly, hash
 static struct kmem_cache *mnt_cache __read_mostly;
 static struct rw_semaphore namespace_sem;
 
+int nr_user_mounts;
+int max_user_mounts = 1024;
+
 /* /sys/fs */
 struct kobject *fs_kobj;
 EXPORT_SYMBOL_GPL(fs_kobj);
@@ -228,11 +231,30 @@ static struct vfsmount *skip_mnt_tree(st
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
 	mnt->mnt_uid = current->fsuid;
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
@@ -284,6 +306,7 @@ static inline void __mntput(struct vfsmo
 {
 	struct super_block *sb = mnt->mnt_sb;
 	dput(mnt->mnt_root);
+	clear_mnt_user(mnt);
 	free_vfsmnt(mnt);
 	deactivate_super(sb);
 }
@@ -1024,6 +1047,7 @@ static int do_remount(struct nameidata *
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
diff -puN kernel/sysctl.c~unprivileged-mounts-account-user-mounts kernel/sysctl.c
--- a/kernel/sysctl.c~unprivileged-mounts-account-user-mounts
+++ a/kernel/sysctl.c
@@ -1210,6 +1210,22 @@ static struct ctl_table fs_table[] = {
 #endif	
 #endif
 	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "nr_user_mounts",
+		.data		= &nr_user_mounts,
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
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

fuse-fix-reading-past-eof.patch
fuse-cleanup-add-fuse_get_attr_version.patch
fuse-pass-open-flags-to-read-and-write.patch
fuse-fix-fuse_file_ops-sending.patch
fuse-fix-uninitialized-field-in-fuse_inode.patch
fuse-fix-attribute-caching-after-rename.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
