From: akpm@linux-foundation.org
Subject: [merged] userns-rename-is_owner_or_cap-to-inode_owner_or_capable.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:27:01 -0700
Message-ID: <201103250726.p2P7Qt6T026196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754197Ab1CYH1J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:27:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serge@hallyn.com, daniel.lezcano@free.fr, dhowells@redhat.com, ebiederm@xmission.com, jmorris@namei.org, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     userns: rename is_owner_or_cap to inode_owner_or_capable
has been removed from the -mm tree.  Its filename was
     userns-rename-is_owner_or_cap-to-inode_owner_or_capable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: userns: rename is_owner_or_cap to inode_owner_or_capable
From: "Serge E. Hallyn" <serge@hallyn.com>

And give it a kernel-doc comment.

[akpm@linux-foundation.org: btrfs changed in linux-next]
Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>
Acked-by: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/acl.c              |    2 +-
 fs/attr.c                |    4 ++--
 fs/btrfs/acl.c           |    2 +-
 fs/btrfs/ioctl.c         |    4 ++--
 fs/ext2/acl.c            |    2 +-
 fs/ext2/ioctl.c          |    6 +++---
 fs/ext3/acl.c            |    2 +-
 fs/ext3/ioctl.c          |    6 +++---
 fs/ext4/acl.c            |    2 +-
 fs/ext4/ioctl.c          |    8 ++++----
 fs/fcntl.c               |    2 +-
 fs/generic_acl.c         |    2 +-
 fs/gfs2/file.c           |    2 +-
 fs/hfsplus/ioctl.c       |    2 +-
 fs/inode.c               |   13 ++++++++-----
 fs/jffs2/acl.c           |    2 +-
 fs/jfs/ioctl.c           |    2 +-
 fs/jfs/xattr.c           |    2 +-
 fs/logfs/file.c          |    2 +-
 fs/namei.c               |    2 +-
 fs/nilfs2/ioctl.c        |    2 +-
 fs/ocfs2/acl.c           |    2 +-
 fs/ocfs2/ioctl.c         |    2 +-
 fs/reiserfs/ioctl.c      |    4 ++--
 fs/reiserfs/xattr_acl.c  |    2 +-
 fs/ubifs/ioctl.c         |    2 +-
 fs/utimes.c              |    2 +-
 fs/xattr.c               |    2 +-
 include/linux/fs.h       |    2 +-
 security/selinux/hooks.c |    2 +-
 30 files changed, 47 insertions(+), 44 deletions(-)

diff -puN fs/9p/acl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/9p/acl.c
--- a/fs/9p/acl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/9p/acl.c
@@ -323,7 +323,7 @@ static int v9fs_xattr_set_acl(struct den
 
 	if (S_ISLNK(inode->i_mode))
 		return -EOPNOTSUPP;
-	if (!is_owner_or_cap(inode))
+	if (!inode_owner_or_capable(inode))
 		return -EPERM;
 	if (value) {
 		/* update the cached acl value */
diff -puN fs/attr.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/attr.c
--- a/fs/attr.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/attr.c
@@ -59,7 +59,7 @@ int inode_change_ok(const struct inode *
 
 	/* Make sure a caller can chmod. */
 	if (ia_valid & ATTR_MODE) {
-		if (!is_owner_or_cap(inode))
+		if (!inode_owner_or_capable(inode))
 			return -EPERM;
 		/* Also check the setgid bit! */
 		if (!in_group_p((ia_valid & ATTR_GID) ? attr->ia_gid :
@@ -69,7 +69,7 @@ int inode_change_ok(const struct inode *
 
 	/* Check for setting the inode time. */
 	if (ia_valid & (ATTR_MTIME_SET | ATTR_ATIME_SET | ATTR_TIMES_SET)) {
-		if (!is_owner_or_cap(inode))
+		if (!inode_owner_or_capable(inode))
 			return -EPERM;
 	}
 
diff -puN fs/btrfs/acl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/btrfs/acl.c
--- a/fs/btrfs/acl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/btrfs/acl.c
@@ -170,7 +170,7 @@ static int btrfs_xattr_acl_set(struct de
 	int ret;
 	struct posix_acl *acl = NULL;
 
-	if (!is_owner_or_cap(dentry->d_inode))
+	if (!inode_owner_or_capable(dentry->d_inode))
 		return -EPERM;
 
 	if (!IS_POSIXACL(dentry->d_inode))
diff -puN fs/btrfs/ioctl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/btrfs/ioctl.c
--- a/fs/btrfs/ioctl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/btrfs/ioctl.c
@@ -158,7 +158,7 @@ static int btrfs_ioctl_setflags(struct f
 		      FS_SYNC_FL | FS_DIRSYNC_FL))
 		return -EOPNOTSUPP;
 
-	if (!is_owner_or_cap(inode))
+	if (!inode_owner_or_capable(inode))
 		return -EACCES;
 
 	mutex_lock(&inode->i_mutex);
@@ -1077,7 +1077,7 @@ static noinline int btrfs_ioctl_subvol_s
 	if (flags & ~BTRFS_SUBVOL_RDONLY)
 		return -EOPNOTSUPP;
 
-	if (!is_owner_or_cap(inode))
+	if (!inode_owner_or_capable(inode))
 		return -EACCES;
 
 	down_write(&root->fs_info->subvol_sem);
diff -puN fs/ext2/acl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/ext2/acl.c
--- a/fs/ext2/acl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/ext2/acl.c
@@ -406,7 +406,7 @@ ext2_xattr_set_acl(struct dentry *dentry
 		return -EINVAL;
 	if (!test_opt(dentry->d_sb, POSIX_ACL))
 		return -EOPNOTSUPP;
-	if (!is_owner_or_cap(dentry->d_inode))
+	if (!inode_owner_or_capable(dentry->d_inode))
 		return -EPERM;
 
 	if (value) {
diff -puN fs/ext2/ioctl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/ext2/ioctl.c
--- a/fs/ext2/ioctl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/ext2/ioctl.c
@@ -39,7 +39,7 @@ long ext2_ioctl(struct file *filp, unsig
 		if (ret)
 			return ret;
 
-		if (!is_owner_or_cap(inode)) {
+		if (!inode_owner_or_capable(inode)) {
 			ret = -EACCES;
 			goto setflags_out;
 		}
@@ -89,7 +89,7 @@ setflags_out:
 	case EXT2_IOC_GETVERSION:
 		return put_user(inode->i_generation, (int __user *) arg);
 	case EXT2_IOC_SETVERSION:
-		if (!is_owner_or_cap(inode))
+		if (!inode_owner_or_capable(inode))
 			return -EPERM;
 		ret = mnt_want_write(filp->f_path.mnt);
 		if (ret)
@@ -115,7 +115,7 @@ setflags_out:
 		if (!test_opt(inode->i_sb, RESERVATION) ||!S_ISREG(inode->i_mode))
 			return -ENOTTY;
 
-		if (!is_owner_or_cap(inode))
+		if (!inode_owner_or_capable(inode))
 			return -EACCES;
 
 		if (get_user(rsv_window_size, (int __user *)arg))
diff -puN fs/ext3/acl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/ext3/acl.c
--- a/fs/ext3/acl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/ext3/acl.c
@@ -435,7 +435,7 @@ ext3_xattr_set_acl(struct dentry *dentry
 		return -EINVAL;
 	if (!test_opt(inode->i_sb, POSIX_ACL))
 		return -EOPNOTSUPP;
-	if (!is_owner_or_cap(inode))
+	if (!inode_owner_or_capable(inode))
 		return -EPERM;
 
 	if (value) {
diff -puN fs/ext3/ioctl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/ext3/ioctl.c
--- a/fs/ext3/ioctl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/ext3/ioctl.c
@@ -38,7 +38,7 @@ long ext3_ioctl(struct file *filp, unsig
 		unsigned int oldflags;
 		unsigned int jflag;
 
-		if (!is_owner_or_cap(inode))
+		if (!inode_owner_or_capable(inode))
 			return -EACCES;
 
 		if (get_user(flags, (int __user *) arg))
@@ -123,7 +123,7 @@ flags_out:
 		__u32 generation;
 		int err;
 
-		if (!is_owner_or_cap(inode))
+		if (!inode_owner_or_capable(inode))
 			return -EPERM;
 
 		err = mnt_want_write(filp->f_path.mnt);
@@ -192,7 +192,7 @@ setversion_out:
 		if (err)
 			return err;
 
-		if (!is_owner_or_cap(inode)) {
+		if (!inode_owner_or_capable(inode)) {
 			err = -EACCES;
 			goto setrsvsz_out;
 		}
diff -puN fs/ext4/acl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/ext4/acl.c
--- a/fs/ext4/acl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/ext4/acl.c
@@ -433,7 +433,7 @@ ext4_xattr_set_acl(struct dentry *dentry
 		return -EINVAL;
 	if (!test_opt(inode->i_sb, POSIX_ACL))
 		return -EOPNOTSUPP;
-	if (!is_owner_or_cap(inode))
+	if (!inode_owner_or_capable(inode))
 		return -EPERM;
 
 	if (value) {
diff -puN fs/ext4/ioctl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/ext4/ioctl.c
--- a/fs/ext4/ioctl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/ext4/ioctl.c
@@ -38,7 +38,7 @@ long ext4_ioctl(struct file *filp, unsig
 		unsigned int oldflags;
 		unsigned int jflag;
 
-		if (!is_owner_or_cap(inode))
+		if (!inode_owner_or_capable(inode))
 			return -EACCES;
 
 		if (get_user(flags, (int __user *) arg))
@@ -146,7 +146,7 @@ flags_out:
 		__u32 generation;
 		int err;
 
-		if (!is_owner_or_cap(inode))
+		if (!inode_owner_or_capable(inode))
 			return -EPERM;
 
 		err = mnt_want_write(filp->f_path.mnt);
@@ -298,7 +298,7 @@ mext_out:
 	case EXT4_IOC_MIGRATE:
 	{
 		int err;
-		if (!is_owner_or_cap(inode))
+		if (!inode_owner_or_capable(inode))
 			return -EACCES;
 
 		err = mnt_want_write(filp->f_path.mnt);
@@ -320,7 +320,7 @@ mext_out:
 	case EXT4_IOC_ALLOC_DA_BLKS:
 	{
 		int err;
-		if (!is_owner_or_cap(inode))
+		if (!inode_owner_or_capable(inode))
 			return -EACCES;
 
 		err = mnt_want_write(filp->f_path.mnt);
diff -puN fs/fcntl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/fcntl.c
--- a/fs/fcntl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/fcntl.c
@@ -159,7 +159,7 @@ static int setfl(int fd, struct file * f
 
 	/* O_NOATIME can only be set by the owner or superuser */
 	if ((arg & O_NOATIME) && !(filp->f_flags & O_NOATIME))
-		if (!is_owner_or_cap(inode))
+		if (!inode_owner_or_capable(inode))
 			return -EPERM;
 
 	/* required for strict SunOS emulation */
diff -puN fs/generic_acl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/generic_acl.c
--- a/fs/generic_acl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/generic_acl.c
@@ -74,7 +74,7 @@ generic_acl_set(struct dentry *dentry, c
 		return -EINVAL;
 	if (S_ISLNK(inode->i_mode))
 		return -EOPNOTSUPP;
-	if (!is_owner_or_cap(inode))
+	if (!inode_owner_or_capable(inode))
 		return -EPERM;
 	if (value) {
 		acl = posix_acl_from_xattr(value, size);
diff -puN fs/gfs2/file.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/gfs2/file.c
--- a/fs/gfs2/file.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/gfs2/file.c
@@ -221,7 +221,7 @@ static int do_gfs2_set_flags(struct file
 		goto out_drop_write;
 
 	error = -EACCES;
-	if (!is_owner_or_cap(inode))
+	if (!inode_owner_or_capable(inode))
 		goto out;
 
 	error = 0;
diff -puN fs/hfsplus/ioctl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/hfsplus/ioctl.c
--- a/fs/hfsplus/ioctl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/hfsplus/ioctl.c
@@ -47,7 +47,7 @@ static int hfsplus_ioctl_setflags(struct
 	if (err)
 		goto out;
 
-	if (!is_owner_or_cap(inode)) {
+	if (!inode_owner_or_capable(inode)) {
 		err = -EACCES;
 		goto out_drop_write;
 	}
diff -puN fs/inode.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/inode.c
--- a/fs/inode.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/inode.c
@@ -1735,11 +1735,14 @@ void inode_init_owner(struct inode *inod
 }
 EXPORT_SYMBOL(inode_init_owner);
 
-/*
- * return true if current either has CAP_FOWNER to the
- * file, or owns the file.
+/**
+ * inode_owner_or_capable - check current task permissions to inode
+ * @inode: inode being checked
+ *
+ * Return true if current either has CAP_FOWNER to the inode, or
+ * owns the file.
  */
-bool is_owner_or_cap(const struct inode *inode)
+bool inode_owner_or_capable(const struct inode *inode)
 {
 	struct user_namespace *ns = inode_userns(inode);
 
@@ -1749,4 +1752,4 @@ bool is_owner_or_cap(const struct inode 
 		return true;
 	return false;
 }
-EXPORT_SYMBOL(is_owner_or_cap);
+EXPORT_SYMBOL(inode_owner_or_capable);
diff -puN fs/jffs2/acl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/jffs2/acl.c
--- a/fs/jffs2/acl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/jffs2/acl.c
@@ -402,7 +402,7 @@ static int jffs2_acl_setxattr(struct den
 
 	if (name[0] != '\0')
 		return -EINVAL;
-	if (!is_owner_or_cap(dentry->d_inode))
+	if (!inode_owner_or_capable(dentry->d_inode))
 		return -EPERM;
 
 	if (value) {
diff -puN fs/jfs/ioctl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/jfs/ioctl.c
--- a/fs/jfs/ioctl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/jfs/ioctl.c
@@ -72,7 +72,7 @@ long jfs_ioctl(struct file *filp, unsign
 		if (err)
 			return err;
 
-		if (!is_owner_or_cap(inode)) {
+		if (!inode_owner_or_capable(inode)) {
 			err = -EACCES;
 			goto setflags_out;
 		}
diff -puN fs/jfs/xattr.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/jfs/xattr.c
--- a/fs/jfs/xattr.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/jfs/xattr.c
@@ -678,7 +678,7 @@ static int can_set_system_xattr(struct i
 	struct posix_acl *acl;
 	int rc;
 
-	if (!is_owner_or_cap(inode))
+	if (!inode_owner_or_capable(inode))
 		return -EPERM;
 
 	/*
diff -puN fs/logfs/file.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/logfs/file.c
--- a/fs/logfs/file.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/logfs/file.c
@@ -196,7 +196,7 @@ long logfs_ioctl(struct file *file, unsi
 		if (IS_RDONLY(inode))
 			return -EROFS;
 
-		if (!is_owner_or_cap(inode))
+		if (!inode_owner_or_capable(inode))
 			return -EACCES;
 
 		err = get_user(flags, (int __user *)arg);
diff -puN fs/namei.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/namei.c
--- a/fs/namei.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/namei.c
@@ -2036,7 +2036,7 @@ static int may_open(struct path *path, i
 	}
 
 	/* O_NOATIME can only be set by the owner or superuser */
-	if (flag & O_NOATIME && !is_owner_or_cap(inode))
+	if (flag & O_NOATIME && !inode_owner_or_capable(inode))
 		return -EPERM;
 
 	/*
diff -puN fs/nilfs2/ioctl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/nilfs2/ioctl.c
@@ -113,7 +113,7 @@ static int nilfs_ioctl_setflags(struct i
 	unsigned int flags, oldflags;
 	int ret;
 
-	if (!is_owner_or_cap(inode))
+	if (!inode_owner_or_capable(inode))
 		return -EACCES;
 
 	if (get_user(flags, (int __user *)argp))
diff -puN fs/ocfs2/acl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/ocfs2/acl.c
--- a/fs/ocfs2/acl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/ocfs2/acl.c
@@ -497,7 +497,7 @@ static int ocfs2_xattr_set_acl(struct de
 	if (!(osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL))
 		return -EOPNOTSUPP;
 
-	if (!is_owner_or_cap(inode))
+	if (!inode_owner_or_capable(inode))
 		return -EPERM;
 
 	if (value) {
diff -puN fs/ocfs2/ioctl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/ocfs2/ioctl.c
--- a/fs/ocfs2/ioctl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/ocfs2/ioctl.c
@@ -82,7 +82,7 @@ static int ocfs2_set_inode_attr(struct i
 	}
 
 	status = -EACCES;
-	if (!is_owner_or_cap(inode))
+	if (!inode_owner_or_capable(inode))
 		goto bail_unlock;
 
 	if (!S_ISDIR(inode->i_mode))
diff -puN fs/reiserfs/ioctl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/reiserfs/ioctl.c
--- a/fs/reiserfs/ioctl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/reiserfs/ioctl.c
@@ -59,7 +59,7 @@ long reiserfs_ioctl(struct file *filp, u
 			if (err)
 				break;
 
-			if (!is_owner_or_cap(inode)) {
+			if (!inode_owner_or_capable(inode)) {
 				err = -EPERM;
 				goto setflags_out;
 			}
@@ -103,7 +103,7 @@ setflags_out:
 		err = put_user(inode->i_generation, (int __user *)arg);
 		break;
 	case REISERFS_IOC_SETVERSION:
-		if (!is_owner_or_cap(inode)) {
+		if (!inode_owner_or_capable(inode)) {
 			err = -EPERM;
 			break;
 		}
diff -puN fs/reiserfs/xattr_acl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/reiserfs/xattr_acl.c
--- a/fs/reiserfs/xattr_acl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/reiserfs/xattr_acl.c
@@ -26,7 +26,7 @@ posix_acl_set(struct dentry *dentry, con
 	size_t jcreate_blocks;
 	if (!reiserfs_posixacl(inode->i_sb))
 		return -EOPNOTSUPP;
-	if (!is_owner_or_cap(inode))
+	if (!inode_owner_or_capable(inode))
 		return -EPERM;
 
 	if (value) {
diff -puN fs/ubifs/ioctl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/ubifs/ioctl.c
--- a/fs/ubifs/ioctl.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/ubifs/ioctl.c
@@ -160,7 +160,7 @@ long ubifs_ioctl(struct file *file, unsi
 		if (IS_RDONLY(inode))
 			return -EROFS;
 
-		if (!is_owner_or_cap(inode))
+		if (!inode_owner_or_capable(inode))
 			return -EACCES;
 
 		if (get_user(flags, (int __user *) arg))
diff -puN fs/utimes.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/utimes.c
--- a/fs/utimes.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/utimes.c
@@ -95,7 +95,7 @@ static int utimes_common(struct path *pa
                 if (IS_IMMUTABLE(inode))
 			goto mnt_drop_write_and_out;
 
-		if (!is_owner_or_cap(inode)) {
+		if (!inode_owner_or_capable(inode)) {
 			error = inode_permission(inode, MAY_WRITE);
 			if (error)
 				goto mnt_drop_write_and_out;
diff -puN fs/xattr.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable fs/xattr.c
--- a/fs/xattr.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/fs/xattr.c
@@ -59,7 +59,7 @@ xattr_permission(struct inode *inode, co
 		if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
 			return -EPERM;
 		if (S_ISDIR(inode->i_mode) && (inode->i_mode & S_ISVTX) &&
-		    (mask & MAY_WRITE) && !is_owner_or_cap(inode))
+		    (mask & MAY_WRITE) && !inode_owner_or_capable(inode))
 			return -EPERM;
 	}
 
diff -puN include/linux/fs.h~userns-rename-is_owner_or_cap-to-inode_owner_or_capable include/linux/fs.h
--- a/include/linux/fs.h~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/include/linux/fs.h
@@ -1463,7 +1463,7 @@ enum {
  */
 extern struct user_namespace init_user_ns;
 #define inode_userns(inode) (&init_user_ns)
-extern bool is_owner_or_cap(const struct inode *inode);
+extern bool inode_owner_or_capable(const struct inode *inode);
 
 /* not quite ready to be deprecated, but... */
 extern void lock_super(struct super_block *);
diff -puN security/selinux/hooks.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable security/selinux/hooks.c
--- a/security/selinux/hooks.c~userns-rename-is_owner_or_cap-to-inode_owner_or_capable
+++ a/security/selinux/hooks.c
@@ -2725,7 +2725,7 @@ static int selinux_inode_setxattr(struct
 	if (!(sbsec->flags & SE_SBLABELSUPP))
 		return -EOPNOTSUPP;
 
-	if (!is_owner_or_cap(inode))
+	if (!inode_owner_or_capable(inode))
 		return -EPERM;
 
 	COMMON_AUDIT_DATA_INIT(&ad, FS);
_

Patches currently in -mm which might be from serge@hallyn.com are

origin.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch

