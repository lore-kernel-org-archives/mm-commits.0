From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-elevate-write-count-for-ioctls.patch removed from -mm tree
Date: Wed, 26 Mar 2008 11:40:43 -0700
Message-ID: <200803261840.m2QIehJ2028691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759386AbYCZSqS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 14:46:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, hch@lst.de, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: elevate write count for ioctls()
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-elevate-write-count-for-ioctls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: r/o bind mounts: elevate write count for ioctls()
From: Dave Hansen <haveblue@us.ibm.com>

Some ioctl()s can cause writes to the filesystem.  Take these, and make them
use mnt_want/drop_write() instead.

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/ioctl.c              |   49 ++++++++++-----
 fs/ext3/ioctl.c              |  103 +++++++++++++++++++++------------
 fs/fat/file.c                |   12 ++-
 fs/hfsplus/ioctl.c           |   40 ++++++++----
 fs/jfs/ioctl.c               |   35 +++++++----
 fs/ocfs2/ioctl.c             |   11 +--
 fs/reiserfs/ioctl.c          |   65 +++++++++++++-------
 fs/xfs/linux-2.6/xfs_ioctl.c |   15 +++-
 8 files changed, 213 insertions(+), 117 deletions(-)

diff -puN fs/ext2/ioctl.c~r-o-bind-mounts-elevate-write-count-for-ioctls fs/ext2/ioctl.c
--- a/fs/ext2/ioctl.c~r-o-bind-mounts-elevate-write-count-for-ioctls
+++ a/fs/ext2/ioctl.c
@@ -12,6 +12,7 @@
 #include <linux/time.h>
 #include <linux/sched.h>
 #include <linux/compat.h>
+#include <linux/mount.h>
 #include <linux/smp_lock.h>
 #include <asm/current.h>
 #include <asm/uaccess.h>
@@ -23,6 +24,7 @@ long ext2_ioctl(struct file *filp, unsig
 	struct ext2_inode_info *ei = EXT2_I(inode);
 	unsigned int flags;
 	unsigned short rsv_window_size;
+	int ret;
 
 	ext2_debug ("cmd = %u, arg = %lu\n", cmd, arg);
 
@@ -34,14 +36,19 @@ long ext2_ioctl(struct file *filp, unsig
 	case EXT2_IOC_SETFLAGS: {
 		unsigned int oldflags;
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
-
-		if (!is_owner_or_cap(inode))
-			return -EACCES;
+		ret = mnt_want_write(filp->f_vfsmnt);
+		if (ret)
+			return ret;
+
+		if (!is_owner_or_cap(inode)) {
+			ret = -EACCES;
+			goto setflags_out;
+		}
 
-		if (get_user(flags, (int __user *) arg))
-			return -EFAULT;
+		if (get_user(flags, (int __user *) arg)) {
+			ret = -EFAULT;
+			goto setflags_out;
+		}
 
 		if (!S_ISDIR(inode->i_mode))
 			flags &= ~EXT2_DIRSYNC_FL;
@@ -50,7 +57,8 @@ long ext2_ioctl(struct file *filp, unsig
 		/* Is it quota file? Do not allow user to mess with it */
 		if (IS_NOQUOTA(inode)) {
 			mutex_unlock(&inode->i_mutex);
-			return -EPERM;
+			ret = -EPERM;
+			goto setflags_out;
 		}
 		oldflags = ei->i_flags;
 
@@ -63,7 +71,8 @@ long ext2_ioctl(struct file *filp, unsig
 		if ((flags ^ oldflags) & (EXT2_APPEND_FL | EXT2_IMMUTABLE_FL)) {
 			if (!capable(CAP_LINUX_IMMUTABLE)) {
 				mutex_unlock(&inode->i_mutex);
-				return -EPERM;
+				ret = -EPERM;
+				goto setflags_out;
 			}
 		}
 
@@ -75,20 +84,26 @@ long ext2_ioctl(struct file *filp, unsig
 		ext2_set_inode_flags(inode);
 		inode->i_ctime = CURRENT_TIME_SEC;
 		mark_inode_dirty(inode);
-		return 0;
+setflags_out:
+		mnt_drop_write(filp->f_vfsmnt);
+		return ret;
 	}
 	case EXT2_IOC_GETVERSION:
 		return put_user(inode->i_generation, (int __user *) arg);
 	case EXT2_IOC_SETVERSION:
 		if (!is_owner_or_cap(inode))
 			return -EPERM;
-		if (IS_RDONLY(inode))
-			return -EROFS;
-		if (get_user(inode->i_generation, (int __user *) arg))
-			return -EFAULT;	
-		inode->i_ctime = CURRENT_TIME_SEC;
-		mark_inode_dirty(inode);
-		return 0;
+		ret = mnt_want_write(filp->f_vfsmnt);
+		if (ret)
+			return ret;
+		if (get_user(inode->i_generation, (int __user *) arg)) {
+			ret = -EFAULT;
+		} else {
+			inode->i_ctime = CURRENT_TIME_SEC;
+			mark_inode_dirty(inode);
+		}
+		mnt_drop_write(filp->f_vfsmnt);
+		return ret;
 	case EXT2_IOC_GETRSVSZ:
 		if (test_opt(inode->i_sb, RESERVATION)
 			&& S_ISREG(inode->i_mode)
diff -puN fs/ext3/ioctl.c~r-o-bind-mounts-elevate-write-count-for-ioctls fs/ext3/ioctl.c
--- a/fs/ext3/ioctl.c~r-o-bind-mounts-elevate-write-count-for-ioctls
+++ a/fs/ext3/ioctl.c
@@ -12,6 +12,7 @@
 #include <linux/capability.h>
 #include <linux/ext3_fs.h>
 #include <linux/ext3_jbd.h>
+#include <linux/mount.h>
 #include <linux/time.h>
 #include <linux/compat.h>
 #include <linux/smp_lock.h>
@@ -38,14 +39,19 @@ int ext3_ioctl (struct inode * inode, st
 		unsigned int oldflags;
 		unsigned int jflag;
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
+		err = mnt_want_write(filp->f_vfsmnt);
+		if (err)
+			return err;
 
-		if (!is_owner_or_cap(inode))
-			return -EACCES;
+		if (!is_owner_or_cap(inode)) {
+			err = -EACCES;
+			goto flags_out;
+		}
 
-		if (get_user(flags, (int __user *) arg))
-			return -EFAULT;
+		if (get_user(flags, (int __user *) arg)) {
+			err = -EFAULT;
+			goto flags_out;
+		}
 
 		if (!S_ISDIR(inode->i_mode))
 			flags &= ~EXT3_DIRSYNC_FL;
@@ -54,7 +60,8 @@ int ext3_ioctl (struct inode * inode, st
 		/* Is it quota file? Do not allow user to mess with it */
 		if (IS_NOQUOTA(inode)) {
 			mutex_unlock(&inode->i_mutex);
-			return -EPERM;
+			err = -EPERM;
+			goto flags_out;
 		}
 		oldflags = ei->i_flags;
 
@@ -70,7 +77,8 @@ int ext3_ioctl (struct inode * inode, st
 		if ((flags ^ oldflags) & (EXT3_APPEND_FL | EXT3_IMMUTABLE_FL)) {
 			if (!capable(CAP_LINUX_IMMUTABLE)) {
 				mutex_unlock(&inode->i_mutex);
-				return -EPERM;
+				err = -EPERM;
+				goto flags_out;
 			}
 		}
 
@@ -81,7 +89,8 @@ int ext3_ioctl (struct inode * inode, st
 		if ((jflag ^ oldflags) & (EXT3_JOURNAL_DATA_FL)) {
 			if (!capable(CAP_SYS_RESOURCE)) {
 				mutex_unlock(&inode->i_mutex);
-				return -EPERM;
+				err = -EPERM;
+				goto flags_out;
 			}
 		}
 
@@ -89,7 +98,8 @@ int ext3_ioctl (struct inode * inode, st
 		handle = ext3_journal_start(inode, 1);
 		if (IS_ERR(handle)) {
 			mutex_unlock(&inode->i_mutex);
-			return PTR_ERR(handle);
+			err = PTR_ERR(handle);
+			goto flags_out;
 		}
 		if (IS_SYNC(inode))
 			handle->h_sync = 1;
@@ -115,6 +125,8 @@ flags_err:
 		if ((jflag ^ oldflags) & (EXT3_JOURNAL_DATA_FL))
 			err = ext3_change_inode_journal_flag(inode, jflag);
 		mutex_unlock(&inode->i_mutex);
+flags_out:
+		mnt_drop_write(filp->f_vfsmnt);
 		return err;
 	}
 	case EXT3_IOC_GETVERSION:
@@ -129,14 +141,18 @@ flags_err:
 
 		if (!is_owner_or_cap(inode))
 			return -EPERM;
-		if (IS_RDONLY(inode))
-			return -EROFS;
-		if (get_user(generation, (int __user *) arg))
-			return -EFAULT;
-
+		err = mnt_want_write(filp->f_vfsmnt);
+		if (err)
+			return err;
+		if (get_user(generation, (int __user *) arg)) {
+			err = -EFAULT;
+			goto setversion_out;
+		}
 		handle = ext3_journal_start(inode, 1);
-		if (IS_ERR(handle))
-			return PTR_ERR(handle);
+		if (IS_ERR(handle)) {
+			err = PTR_ERR(handle);
+			goto setversion_out;
+		}
 		err = ext3_reserve_inode_write(handle, inode, &iloc);
 		if (err == 0) {
 			inode->i_ctime = CURRENT_TIME_SEC;
@@ -144,6 +160,8 @@ flags_err:
 			err = ext3_mark_iloc_dirty(handle, inode, &iloc);
 		}
 		ext3_journal_stop(handle);
+setversion_out:
+		mnt_drop_write(filp->f_vfsmnt);
 		return err;
 	}
 #ifdef CONFIG_JBD_DEBUG
@@ -179,18 +197,24 @@ flags_err:
 		}
 		return -ENOTTY;
 	case EXT3_IOC_SETRSVSZ: {
+		int err;
 
 		if (!test_opt(inode->i_sb, RESERVATION) ||!S_ISREG(inode->i_mode))
 			return -ENOTTY;
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
+		err = mnt_want_write(filp->f_vfsmnt);
+		if (err)
+			return err;
 
-		if (!is_owner_or_cap(inode))
-			return -EACCES;
+		if (!is_owner_or_cap(inode)) {
+			err = -EACCES;
+			goto setrsvsz_out;
+		}
 
-		if (get_user(rsv_window_size, (int __user *)arg))
-			return -EFAULT;
+		if (get_user(rsv_window_size, (int __user *)arg)) {
+			err = -EFAULT;
+			goto setrsvsz_out;
+		}
 
 		if (rsv_window_size > EXT3_MAX_RESERVE_BLOCKS)
 			rsv_window_size = EXT3_MAX_RESERVE_BLOCKS;
@@ -208,7 +232,9 @@ flags_err:
 			rsv->rsv_goal_size = rsv_window_size;
 		}
 		mutex_unlock(&ei->truncate_mutex);
-		return 0;
+setrsvsz_out:
+		mnt_drop_write(filp->f_vfsmnt);
+		return err;
 	}
 	case EXT3_IOC_GROUP_EXTEND: {
 		ext3_fsblk_t n_blocks_count;
@@ -218,17 +244,20 @@ flags_err:
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
-
-		if (get_user(n_blocks_count, (__u32 __user *)arg))
-			return -EFAULT;
+		err = mnt_want_write(filp->f_vfsmnt);
+		if (err)
+			return err;
 
+		if (get_user(n_blocks_count, (__u32 __user *)arg)) {
+			err = -EFAULT;
+			goto group_extend_out;
+		}
 		err = ext3_group_extend(sb, EXT3_SB(sb)->s_es, n_blocks_count);
 		journal_lock_updates(EXT3_SB(sb)->s_journal);
 		journal_flush(EXT3_SB(sb)->s_journal);
 		journal_unlock_updates(EXT3_SB(sb)->s_journal);
-
+group_extend_out:
+		mnt_drop_write(filp->f_vfsmnt);
 		return err;
 	}
 	case EXT3_IOC_GROUP_ADD: {
@@ -239,18 +268,22 @@ flags_err:
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
+		err = mnt_want_write(filp->f_vfsmnt);
+		if (err)
+			return err;
 
 		if (copy_from_user(&input, (struct ext3_new_group_input __user *)arg,
-				sizeof(input)))
-			return -EFAULT;
+				sizeof(input))) {
+			err = -EFAULT;
+			goto group_add_out;
+		}
 
 		err = ext3_group_add(sb, &input);
 		journal_lock_updates(EXT3_SB(sb)->s_journal);
 		journal_flush(EXT3_SB(sb)->s_journal);
 		journal_unlock_updates(EXT3_SB(sb)->s_journal);
-
+group_add_out:
+		mnt_drop_write(filp->f_vfsmnt);
 		return err;
 	}
 
diff -puN fs/fat/file.c~r-o-bind-mounts-elevate-write-count-for-ioctls fs/fat/file.c
--- a/fs/fat/file.c~r-o-bind-mounts-elevate-write-count-for-ioctls
+++ a/fs/fat/file.c
@@ -8,6 +8,7 @@
 
 #include <linux/capability.h>
 #include <linux/module.h>
+#include <linux/mount.h>
 #include <linux/time.h>
 #include <linux/msdos_fs.h>
 #include <linux/smp_lock.h>
@@ -46,10 +47,9 @@ int fat_generic_ioctl(struct inode *inod
 
 		mutex_lock(&inode->i_mutex);
 
-		if (IS_RDONLY(inode)) {
-			err = -EROFS;
-			goto up;
-		}
+		err = mnt_want_write(filp->f_vfsmnt);
+		if (err)
+			goto up_no_drop_write;
 
 		/*
 		 * ATTR_VOLUME and ATTR_DIR cannot be changed; this also
@@ -105,7 +105,9 @@ int fat_generic_ioctl(struct inode *inod
 
 		MSDOS_I(inode)->i_attrs = attr & ATTR_UNUSED;
 		mark_inode_dirty(inode);
-	up:
+up:
+		mnt_drop_write(filp->f_vfsmnt);
+up_no_drop_write:
 		mutex_unlock(&inode->i_mutex);
 		return err;
 	}
diff -puN fs/hfsplus/ioctl.c~r-o-bind-mounts-elevate-write-count-for-ioctls fs/hfsplus/ioctl.c
--- a/fs/hfsplus/ioctl.c~r-o-bind-mounts-elevate-write-count-for-ioctls
+++ a/fs/hfsplus/ioctl.c
@@ -14,6 +14,7 @@
 
 #include <linux/capability.h>
 #include <linux/fs.h>
+#include <linux/mount.h>
 #include <linux/sched.h>
 #include <linux/xattr.h>
 #include <asm/uaccess.h>
@@ -35,25 +36,32 @@ int hfsplus_ioctl(struct inode *inode, s
 			flags |= FS_NODUMP_FL; /* EXT2_NODUMP_FL */
 		return put_user(flags, (int __user *)arg);
 	case HFSPLUS_IOC_EXT2_SETFLAGS: {
-		if (IS_RDONLY(inode))
-			return -EROFS;
-
-		if (!is_owner_or_cap(inode))
-			return -EACCES;
-
-		if (get_user(flags, (int __user *)arg))
-			return -EFAULT;
-
+		int err = 0;
+		err = mnt_want_write(filp->f_vfsmnt);
+		if (err)
+			return err;
+
+		if (!is_owner_or_cap(inode)) {
+			err = -EACCES;
+			goto setflags_out;
+		}
+		if (get_user(flags, (int __user *)arg)) {
+			err = -EFAULT;
+			goto setflags_out;
+		}
 		if (flags & (FS_IMMUTABLE_FL|FS_APPEND_FL) ||
 		    HFSPLUS_I(inode).rootflags & (HFSPLUS_FLG_IMMUTABLE|HFSPLUS_FLG_APPEND)) {
-			if (!capable(CAP_LINUX_IMMUTABLE))
-				return -EPERM;
+			if (!capable(CAP_LINUX_IMMUTABLE)) {
+				err = -EPERM;
+				goto setflags_out;
+			}
 		}
 
 		/* don't silently ignore unsupported ext2 flags */
-		if (flags & ~(FS_IMMUTABLE_FL|FS_APPEND_FL|FS_NODUMP_FL))
-			return -EOPNOTSUPP;
-
+		if (flags & ~(FS_IMMUTABLE_FL|FS_APPEND_FL|FS_NODUMP_FL)) {
+			err = -EOPNOTSUPP;
+			goto setflags_out;
+		}
 		if (flags & FS_IMMUTABLE_FL) { /* EXT2_IMMUTABLE_FL */
 			inode->i_flags |= S_IMMUTABLE;
 			HFSPLUS_I(inode).rootflags |= HFSPLUS_FLG_IMMUTABLE;
@@ -75,7 +83,9 @@ int hfsplus_ioctl(struct inode *inode, s
 
 		inode->i_ctime = CURRENT_TIME_SEC;
 		mark_inode_dirty(inode);
-		return 0;
+setflags_out:
+		mnt_drop_write(filp->f_vfsmnt);
+		return err;
 	}
 	default:
 		return -ENOTTY;
diff -puN fs/jfs/ioctl.c~r-o-bind-mounts-elevate-write-count-for-ioctls fs/jfs/ioctl.c
--- a/fs/jfs/ioctl.c~r-o-bind-mounts-elevate-write-count-for-ioctls
+++ a/fs/jfs/ioctl.c
@@ -8,6 +8,7 @@
 #include <linux/fs.h>
 #include <linux/ctype.h>
 #include <linux/capability.h>
+#include <linux/mount.h>
 #include <linux/time.h>
 #include <linux/sched.h>
 #include <asm/current.h>
@@ -65,23 +66,30 @@ long jfs_ioctl(struct file *filp, unsign
 		return put_user(flags, (int __user *) arg);
 	case JFS_IOC_SETFLAGS: {
 		unsigned int oldflags;
+		int err;
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
-
-		if (!is_owner_or_cap(inode))
-			return -EACCES;
-
-		if (get_user(flags, (int __user *) arg))
-			return -EFAULT;
+		err = mnt_want_write(filp->f_vfsmnt);
+		if (err)
+			return err;
+
+		if (!is_owner_or_cap(inode)) {
+			err = -EACCES;
+			goto setflags_out;
+		}
+		if (get_user(flags, (int __user *) arg)) {
+			err = -EFAULT;
+			goto setflags_out;
+		}
 
 		flags = jfs_map_ext2(flags, 1);
 		if (!S_ISDIR(inode->i_mode))
 			flags &= ~JFS_DIRSYNC_FL;
 
 		/* Is it quota file? Do not allow user to mess with it */
-		if (IS_NOQUOTA(inode))
-			return -EPERM;
+		if (IS_NOQUOTA(inode)) {
+			err = -EPERM;
+			goto setflags_out;
+		}
 
 		/* Lock against other parallel changes of flags */
 		mutex_lock(&inode->i_mutex);
@@ -98,7 +106,8 @@ long jfs_ioctl(struct file *filp, unsign
 			(JFS_APPEND_FL | JFS_IMMUTABLE_FL))) {
 			if (!capable(CAP_LINUX_IMMUTABLE)) {
 				mutex_unlock(&inode->i_mutex);
-				return -EPERM;
+				err = -EPERM;
+				goto setflags_out;
 			}
 		}
 
@@ -110,7 +119,9 @@ long jfs_ioctl(struct file *filp, unsign
 		mutex_unlock(&inode->i_mutex);
 		inode->i_ctime = CURRENT_TIME_SEC;
 		mark_inode_dirty(inode);
-		return 0;
+setflags_out:
+		mnt_drop_write(filp->f_vfsmnt);
+		return err;
 	}
 	default:
 		return -ENOTTY;
diff -puN fs/ocfs2/ioctl.c~r-o-bind-mounts-elevate-write-count-for-ioctls fs/ocfs2/ioctl.c
--- a/fs/ocfs2/ioctl.c~r-o-bind-mounts-elevate-write-count-for-ioctls
+++ a/fs/ocfs2/ioctl.c
@@ -60,10 +60,6 @@ static int ocfs2_set_inode_attr(struct i
 		goto bail;
 	}
 
-	status = -EROFS;
-	if (IS_RDONLY(inode))
-		goto bail_unlock;
-
 	status = -EACCES;
 	if (!is_owner_or_cap(inode))
 		goto bail_unlock;
@@ -134,8 +130,13 @@ long ocfs2_ioctl(struct file *filp, unsi
 		if (get_user(flags, (int __user *) arg))
 			return -EFAULT;
 
-		return ocfs2_set_inode_attr(inode, flags,
+		status = mnt_want_write(filp->f_vfsmnt);
+		if (status)
+			return status;
+		status = ocfs2_set_inode_attr(inode, flags,
 			OCFS2_FL_MODIFIABLE);
+		mnt_drop_write(filp->f_vfsmnt);
+		return status;
 	case OCFS2_IOC_RESVSP:
 	case OCFS2_IOC_RESVSP64:
 	case OCFS2_IOC_UNRESVSP:
diff -puN fs/reiserfs/ioctl.c~r-o-bind-mounts-elevate-write-count-for-ioctls fs/reiserfs/ioctl.c
--- a/fs/reiserfs/ioctl.c~r-o-bind-mounts-elevate-write-count-for-ioctls
+++ a/fs/reiserfs/ioctl.c
@@ -4,6 +4,7 @@
 
 #include <linux/capability.h>
 #include <linux/fs.h>
+#include <linux/mount.h>
 #include <linux/reiserfs_fs.h>
 #include <linux/time.h>
 #include <asm/uaccess.h>
@@ -25,6 +26,7 @@ int reiserfs_ioctl(struct inode *inode, 
 		   unsigned long arg)
 {
 	unsigned int flags;
+	int err = 0;
 
 	switch (cmd) {
 	case REISERFS_IOC_UNPACK:
@@ -48,50 +50,67 @@ int reiserfs_ioctl(struct inode *inode, 
 			if (!reiserfs_attrs(inode->i_sb))
 				return -ENOTTY;
 
-			if (IS_RDONLY(inode))
-				return -EROFS;
-
-			if (!is_owner_or_cap(inode))
-				return -EPERM;
-
-			if (get_user(flags, (int __user *)arg))
-				return -EFAULT;
-
-			/* Is it quota file? Do not allow user to mess with it. */
-			if (IS_NOQUOTA(inode))
-				return -EPERM;
+			err = mnt_want_write(filp->f_vfsmnt);
+			if (err)
+				return err;
+
+			if (!is_owner_or_cap(inode)) {
+				err = -EPERM;
+				goto setflags_out;
+			}
+			if (get_user(flags, (int __user *)arg)) {
+				err = -EFAULT;
+				goto setflags_out;
+			}
+			/*
+			 * Is it quota file? Do not allow user to mess with it
+			 */
+			if (IS_NOQUOTA(inode)) {
+				err = -EPERM;
+				goto setflags_out;
+			}
 			if (((flags ^ REISERFS_I(inode)->
 			      i_attrs) & (REISERFS_IMMUTABLE_FL |
 					  REISERFS_APPEND_FL))
-			    && !capable(CAP_LINUX_IMMUTABLE))
-				return -EPERM;
-
+			    && !capable(CAP_LINUX_IMMUTABLE)) {
+				err = -EPERM;
+				goto setflags_out;
+			}
 			if ((flags & REISERFS_NOTAIL_FL) &&
 			    S_ISREG(inode->i_mode)) {
 				int result;
 
 				result = reiserfs_unpack(inode, filp);
-				if (result)
-					return result;
+				if (result) {
+					err = result;
+					goto setflags_out;
+				}
 			}
 			sd_attrs_to_i_attrs(flags, inode);
 			REISERFS_I(inode)->i_attrs = flags;
 			inode->i_ctime = CURRENT_TIME_SEC;
 			mark_inode_dirty(inode);
-			return 0;
+setflags_out:
+			mnt_drop_write(filp->f_vfsmnt);
+			return err;
 		}
 	case REISERFS_IOC_GETVERSION:
 		return put_user(inode->i_generation, (int __user *)arg);
 	case REISERFS_IOC_SETVERSION:
 		if (!is_owner_or_cap(inode))
 			return -EPERM;
-		if (IS_RDONLY(inode))
-			return -EROFS;
-		if (get_user(inode->i_generation, (int __user *)arg))
-			return -EFAULT;
+		err = mnt_want_write(filp->f_vfsmnt);
+		if (err)
+			return err;
+		if (get_user(inode->i_generation, (int __user *)arg)) {
+			err = -EFAULT;
+			goto setversion_out;
+		}
 		inode->i_ctime = CURRENT_TIME_SEC;
 		mark_inode_dirty(inode);
-		return 0;
+setversion_out:
+		mnt_drop_write(filp->f_vfsmnt);
+		return err;
 	default:
 		return -ENOTTY;
 	}
diff -puN fs/xfs/linux-2.6/xfs_ioctl.c~r-o-bind-mounts-elevate-write-count-for-ioctls fs/xfs/linux-2.6/xfs_ioctl.c
--- a/fs/xfs/linux-2.6/xfs_ioctl.c~r-o-bind-mounts-elevate-write-count-for-ioctls
+++ a/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -535,8 +535,6 @@ xfs_attrmulti_attr_set(
 	char			*kbuf;
 	int			error = EFAULT;
 
-	if (IS_RDONLY(inode))
-		return -EROFS;
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		return EPERM;
 	if (len > XATTR_SIZE_MAX)
@@ -562,8 +560,6 @@ xfs_attrmulti_attr_remove(
 	char			*name,
 	__uint32_t		flags)
 {
-	if (IS_RDONLY(inode))
-		return -EROFS;
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		return EPERM;
 	return xfs_attr_remove(XFS_I(inode), name, flags);
@@ -573,6 +569,7 @@ STATIC int
 xfs_attrmulti_by_handle(
 	xfs_mount_t		*mp,
 	void			__user *arg,
+	struct file		*parfilp,
 	struct inode		*parinode)
 {
 	int			error;
@@ -626,13 +623,21 @@ xfs_attrmulti_by_handle(
 					&ops[i].am_length, ops[i].am_flags);
 			break;
 		case ATTR_OP_SET:
+			ops[i].am_error = mnt_want_write(parfilp->f_vfsmnt);
+			if (ops[i].am_error)
+				break;
 			ops[i].am_error = xfs_attrmulti_attr_set(inode,
 					attr_name, ops[i].am_attrvalue,
 					ops[i].am_length, ops[i].am_flags);
+			mnt_drop_write(parfilp->f_vfsmnt);
 			break;
 		case ATTR_OP_REMOVE:
+			ops[i].am_error = mnt_want_write(parfilp->f_vfsmnt);
+			if (ops[i].am_error)
+				break;
 			ops[i].am_error = xfs_attrmulti_attr_remove(inode,
 					attr_name, ops[i].am_flags);
+			mnt_drop_write(parfilp->f_vfsmnt);
 			break;
 		default:
 			ops[i].am_error = EINVAL;
@@ -1131,7 +1136,7 @@ xfs_ioctl(
 		return xfs_attrlist_by_handle(mp, arg, inode);
 
 	case XFS_IOC_ATTRMULTI_BY_HANDLE:
-		return xfs_attrmulti_by_handle(mp, arg, inode);
+		return xfs_attrmulti_by_handle(mp, arg, filp, inode);
 
 	case XFS_IOC_SWAPEXT: {
 		error = xfs_swapext((struct xfs_swapext __user *)arg);
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

git-vfs.patch
hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages.patch
mm-make-mem_map-allocation-continuous.patch
vfs-create-proc-pid-mountinfo.patch
vfs-mountinfo-mm-fix.patch
vfs-pnode-cleanup.patch
vfs-mountinfo-stable-peer-group-id.patch
vfs-mountinfo-show-dominating-group-id.patch
vfs-optimization-to-proc-pid-mountinfo-patch.patch
vfs-mountinfo-only-show-mounts-under-tasks-root.patch
kprobes-prevent-probing-of-preempt_schedule.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
reiser4.patch
page-owner-tracking-leak-detector.patch

