From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:33:03 -0800
Message-ID: <200702150833.l1F8X3TT024595@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39543 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965299AbXBOIex (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:34:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, miklos@szeredi.hu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: r/o bind mounts: elevate write count for some ioctls
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: r/o bind mounts: r/o bind mounts: elevate write count for some ioctls
From: Dave Hansen <hansendc@us.ibm.com>

Some ioctl()s can cause writes to the filesystem.  Take these, and make them
use mnt_want/drop_write() instead.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/ioctl.c              |   60 ++++++++++++------
 fs/ext3/ioctl.c              |  104 ++++++++++++++++++++------------
 fs/ext4/ioctl.c              |  106 ++++++++++++++++++++-------------
 fs/fat/file.c                |    9 +-
 fs/hfsplus/ioctl.c           |   39 +++++++-----
 fs/jfs/ioctl.c               |   32 ++++++---
 fs/ocfs2/ioctl.c             |   11 +--
 fs/reiserfs/ioctl.c          |   52 ++++++++++------
 fs/xfs/linux-2.6/xfs_ioctl.c |   12 ++-
 fs/xfs/linux-2.6/xfs_iops.c  |    7 --
 fs/xfs/linux-2.6/xfs_lrw.c   |    9 ++
 11 files changed, 276 insertions(+), 165 deletions(-)

diff -puN fs/ext2/ioctl.c~r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls fs/ext2/ioctl.c
--- a/fs/ext2/ioctl.c~r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls
+++ a/fs/ext2/ioctl.c
@@ -23,6 +23,7 @@ int ext2_ioctl (struct inode * inode, st
 	struct ext2_inode_info *ei = EXT2_I(inode);
 	unsigned int flags;
 	unsigned short rsv_window_size;
+	int ret = 0;
 
 	ext2_debug ("cmd = %u, arg = %lu\n", cmd, arg);
 
@@ -33,14 +34,19 @@ int ext2_ioctl (struct inode * inode, st
 	case EXT2_IOC_SETFLAGS: {
 		unsigned int oldflags;
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
-
-		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
-			return -EACCES;
+		ret = mnt_want_write(filp->f_vfsmnt);
+		if (ret)
+			return ret;
+
+		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER)) {
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
@@ -57,7 +63,8 @@ int ext2_ioctl (struct inode * inode, st
 		if ((flags ^ oldflags) & (EXT2_APPEND_FL | EXT2_IMMUTABLE_FL)) {
 			if (!capable(CAP_LINUX_IMMUTABLE)) {
 				mutex_unlock(&inode->i_mutex);
-				return -EPERM;
+				ret = -EPERM;
+				goto setflags_out;
 			}
 		}
 
@@ -69,19 +76,24 @@ int ext2_ioctl (struct inode * inode, st
 		ext2_set_inode_flags(inode);
 		inode->i_ctime = CURRENT_TIME_SEC;
 		mark_inode_dirty(inode);
-		return 0;
+	setflags_out:
+		mnt_drop_write(filp->f_vfsmnt);
+		return ret;
 	}
 	case EXT2_IOC_GETVERSION:
 		return put_user(inode->i_generation, (int __user *) arg);
 	case EXT2_IOC_SETVERSION:
 		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
 			return -EPERM;
-		if (IS_RDONLY(inode))
-			return -EROFS;
-		if (get_user(inode->i_generation, (int __user *) arg))
-			return -EFAULT;	
+		ret = mnt_want_write(filp->f_vfsmnt);
+		if (get_user(inode->i_generation, (int __user *) arg)) {
+			ret = -EFAULT;
+			goto setversion_out;
+		}
 		inode->i_ctime = CURRENT_TIME_SEC;
 		mark_inode_dirty(inode);
+	setversion_out:
+		mnt_drop_write(filp->f_vfsmnt);
 		return 0;
 	case EXT2_IOC_GETRSVSZ:
 		if (test_opt(inode->i_sb, RESERVATION)
@@ -96,14 +108,20 @@ int ext2_ioctl (struct inode * inode, st
 		if (!test_opt(inode->i_sb, RESERVATION) ||!S_ISREG(inode->i_mode))
 			return -ENOTTY;
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
+		ret = mnt_want_write(filp->f_vfsmnt);
+		if (ret)
+			return ret;
+
+		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER)) {
+			ret = -EACCES;
+			goto setrsvsz_out;
+		}
 
-		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
-			return -EACCES;
 
-		if (get_user(rsv_window_size, (int __user *)arg))
-			return -EFAULT;
+		if (get_user(rsv_window_size, (int __user *)arg)) {
+			ret = -EFAULT;
+			goto setrsvsz_out;
+		}
 
 		if (rsv_window_size > EXT2_MAX_RESERVE_BLOCKS)
 			rsv_window_size = EXT2_MAX_RESERVE_BLOCKS;
@@ -125,7 +143,9 @@ int ext2_ioctl (struct inode * inode, st
 			rsv->rsv_goal_size = rsv_window_size;
 		}
 		mutex_unlock(&ei->truncate_mutex);
-		return 0;
+	setrsvsz_out:
+		mnt_drop_write(filp->f_vfsmnt);
+		return ret;
 	}
 	default:
 		return -ENOTTY;
diff -puN fs/ext3/ioctl.c~r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls fs/ext3/ioctl.c
--- a/fs/ext3/ioctl.c~r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls
+++ a/fs/ext3/ioctl.c
@@ -32,20 +32,24 @@ int ext3_ioctl (struct inode * inode, st
 		return put_user(flags, (int __user *) arg);
 	case EXT3_IOC_SETFLAGS: {
 		handle_t *handle = NULL;
-		int err;
+		int err = 0;
 		struct ext3_iloc iloc;
 		unsigned int oldflags;
 		unsigned int jflag;
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
-
-		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
-			return -EACCES;
+		err = mnt_want_write(filp->f_vfsmnt);
+		if (err)
+			return err;
 
-		if (get_user(flags, (int __user *) arg))
-			return -EFAULT;
+		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER)) {
+			err = -EACCES;
+			goto flags_out;
+		}
 
+		if (get_user(flags, (int __user *) arg)) {
+			err = -EFAULT;
+			goto flags_out;
+		}
 		if (!S_ISDIR(inode->i_mode))
 			flags &= ~EXT3_DIRSYNC_FL;
 
@@ -64,7 +68,8 @@ int ext3_ioctl (struct inode * inode, st
 		if ((flags ^ oldflags) & (EXT3_APPEND_FL | EXT3_IMMUTABLE_FL)) {
 			if (!capable(CAP_LINUX_IMMUTABLE)) {
 				mutex_unlock(&inode->i_mutex);
-				return -EPERM;
+				err = -EPERM;
+				goto flags_out;
 			}
 		}
 
@@ -75,7 +80,8 @@ int ext3_ioctl (struct inode * inode, st
 		if ((jflag ^ oldflags) & (EXT3_JOURNAL_DATA_FL)) {
 			if (!capable(CAP_SYS_RESOURCE)) {
 				mutex_unlock(&inode->i_mutex);
-				return -EPERM;
+				err = -EPERM;
+				goto flags_out;
 			}
 		}
 
@@ -83,7 +89,8 @@ int ext3_ioctl (struct inode * inode, st
 		handle = ext3_journal_start(inode, 1);
 		if (IS_ERR(handle)) {
 			mutex_unlock(&inode->i_mutex);
-			return PTR_ERR(handle);
+			err = PTR_ERR(handle);
+			goto flags_out;
 		}
 		if (IS_SYNC(inode))
 			handle->h_sync = 1;
@@ -109,6 +116,8 @@ flags_err:
 		if ((jflag ^ oldflags) & (EXT3_JOURNAL_DATA_FL))
 			err = ext3_change_inode_journal_flag(inode, jflag);
 		mutex_unlock(&inode->i_mutex);
+	flags_out:
+		mnt_drop_write(filp->f_vfsmnt);
 		return err;
 	}
 	case EXT3_IOC_GETVERSION:
@@ -123,14 +132,18 @@ flags_err:
 
 		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
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
@@ -138,6 +151,8 @@ flags_err:
 			err = ext3_mark_iloc_dirty(handle, inode, &iloc);
 		}
 		ext3_journal_stop(handle);
+	setversion_out:
+		mnt_drop_write(filp->f_vfsmnt);
 		return err;
 	}
 #ifdef CONFIG_JBD_DEBUG
@@ -173,19 +188,23 @@ flags_err:
 		}
 		return -ENOTTY;
 	case EXT3_IOC_SETRSVSZ: {
+		int err;
 
 		if (!test_opt(inode->i_sb, RESERVATION) ||!S_ISREG(inode->i_mode))
 			return -ENOTTY;
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
-
-		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
-			return -EACCES;
-
-		if (get_user(rsv_window_size, (int __user *)arg))
-			return -EFAULT;
+		err = mnt_want_write(filp->f_vfsmnt);
+		if (err)
+			return err;
 
+		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER)) {
+			err = -EACCES;
+			goto setrsvsz_out;
+		}
+		if (get_user(rsv_window_size, (int __user *)arg)) {
+			err = -EFAULT;
+			goto setrsvsz_out;
+		}
 		if (rsv_window_size > EXT3_MAX_RESERVE_BLOCKS)
 			rsv_window_size = EXT3_MAX_RESERVE_BLOCKS;
 
@@ -202,7 +221,9 @@ flags_err:
 			rsv->rsv_goal_size = rsv_window_size;
 		}
 		mutex_unlock(&ei->truncate_mutex);
-		return 0;
+	setrsvsz_out:
+		mnt_drop_write(filp->f_vfsmnt);
+		return err;
 	}
 	case EXT3_IOC_GROUP_EXTEND: {
 		ext3_fsblk_t n_blocks_count;
@@ -212,17 +233,20 @@ flags_err:
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
-
-		if (get_user(n_blocks_count, (__u32 __user *)arg))
-			return -EFAULT;
+                err = mnt_want_write(filp->f_vfsmnt);
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
+	group_extend_out:
+		mnt_drop_write(filp->f_vfsmnt);
 		return err;
 	}
 	case EXT3_IOC_GROUP_ADD: {
@@ -233,18 +257,22 @@ flags_err:
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
+                err = mnt_want_write(filp->f_vfsmnt);
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
+	group_add_out:
+		mnt_drop_write(filp->f_vfsmnt);
 		return err;
 	}
 
diff -puN fs/ext4/ioctl.c~r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls fs/ext4/ioctl.c
--- a/fs/ext4/ioctl.c~r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls
+++ a/fs/ext4/ioctl.c
@@ -32,20 +32,24 @@ int ext4_ioctl (struct inode * inode, st
 		return put_user(flags, (int __user *) arg);
 	case EXT4_IOC_SETFLAGS: {
 		handle_t *handle = NULL;
-		int err;
+		int err = 0;
 		struct ext4_iloc iloc;
 		unsigned int oldflags;
 		unsigned int jflag;
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
-
-		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
-			return -EACCES;
+		err = mnt_want_write(filp->f_vfsmnt);
+		if (err)
+			return err;
 
-		if (get_user(flags, (int __user *) arg))
-			return -EFAULT;
+		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER)) {
+			err = -EACCES;
+			goto flags_out;
+		}
 
+		if (get_user(flags, (int __user *) arg)) {
+			err = -EFAULT;
+			goto flags_out;
+		}
 		if (!S_ISDIR(inode->i_mode))
 			flags &= ~EXT4_DIRSYNC_FL;
 
@@ -64,7 +68,8 @@ int ext4_ioctl (struct inode * inode, st
 		if ((flags ^ oldflags) & (EXT4_APPEND_FL | EXT4_IMMUTABLE_FL)) {
 			if (!capable(CAP_LINUX_IMMUTABLE)) {
 				mutex_unlock(&inode->i_mutex);
-				return -EPERM;
+				err = -EPERM;
+				goto flags_out;
 			}
 		}
 
@@ -75,7 +80,8 @@ int ext4_ioctl (struct inode * inode, st
 		if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL)) {
 			if (!capable(CAP_SYS_RESOURCE)) {
 				mutex_unlock(&inode->i_mutex);
-				return -EPERM;
+				err = -EPERM;
+				goto flags_out;
 			}
 		}
 
@@ -83,7 +89,8 @@ int ext4_ioctl (struct inode * inode, st
 		handle = ext4_journal_start(inode, 1);
 		if (IS_ERR(handle)) {
 			mutex_unlock(&inode->i_mutex);
-			return PTR_ERR(handle);
+			err = PTR_ERR(handle);
+			goto flags_out;
 		}
 		if (IS_SYNC(inode))
 			handle->h_sync = 1;
@@ -103,12 +110,14 @@ flags_err:
 		ext4_journal_stop(handle);
 		if (err) {
 			mutex_unlock(&inode->i_mutex);
-			return err;
+			goto flags_out;
 		}
 
 		if ((jflag ^ oldflags) & (EXT4_JOURNAL_DATA_FL))
 			err = ext4_change_inode_journal_flag(inode, jflag);
 		mutex_unlock(&inode->i_mutex);
+flags_out:
+		mnt_drop_write(filp->f_vfsmnt);
 		return err;
 	}
 	case EXT4_IOC_GETVERSION:
@@ -123,14 +132,18 @@ flags_err:
 
 		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
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
 		handle = ext4_journal_start(inode, 1);
-		if (IS_ERR(handle))
-			return PTR_ERR(handle);
+		if (IS_ERR(handle)) {
+			err = PTR_ERR(handle);
+			goto setversion_out;
+		}
 		err = ext4_reserve_inode_write(handle, inode, &iloc);
 		if (err == 0) {
 			inode->i_ctime = CURRENT_TIME_SEC;
@@ -138,6 +151,8 @@ flags_err:
 			err = ext4_mark_iloc_dirty(handle, inode, &iloc);
 		}
 		ext4_journal_stop(handle);
+setversion_out:
+		mnt_drop_write(filp->f_vfsmnt);
 		return err;
 	}
 #ifdef CONFIG_JBD_DEBUG
@@ -173,19 +188,23 @@ flags_err:
 		}
 		return -ENOTTY;
 	case EXT4_IOC_SETRSVSZ: {
+		int err;
 
 		if (!test_opt(inode->i_sb, RESERVATION) ||!S_ISREG(inode->i_mode))
 			return -ENOTTY;
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
-
-		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
-			return -EACCES;
-
-		if (get_user(rsv_window_size, (int __user *)arg))
-			return -EFAULT;
+		err = mnt_want_write(filp->f_vfsmnt);
+		if (err)
+			return err;
 
+		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER)) {
+			err = -EACCES;
+			goto setrsvsz_out;
+		}
+		if (get_user(rsv_window_size, (int __user *)arg)) {
+			err = -EFAULT;
+			goto setrsvsz_out;
+		}
 		if (rsv_window_size > EXT4_MAX_RESERVE_BLOCKS)
 			rsv_window_size = EXT4_MAX_RESERVE_BLOCKS;
 
@@ -202,7 +221,9 @@ flags_err:
 			rsv->rsv_goal_size = rsv_window_size;
 		}
 		mutex_unlock(&ei->truncate_mutex);
-		return 0;
+setrsvsz_out:
+		mnt_drop_write(filp->f_vfsmnt);
+		return err;
 	}
 	case EXT4_IOC_GROUP_EXTEND: {
 		ext4_fsblk_t n_blocks_count;
@@ -212,17 +233,21 @@ flags_err:
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
 		err = ext4_group_extend(sb, EXT4_SB(sb)->s_es, n_blocks_count);
 		jbd2_journal_lock_updates(EXT4_SB(sb)->s_journal);
 		jbd2_journal_flush(EXT4_SB(sb)->s_journal);
 		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
 
+	group_extend_out:
+		mnt_drop_write(filp->f_vfsmnt);
 		return err;
 	}
 	case EXT4_IOC_GROUP_ADD: {
@@ -233,18 +258,21 @@ flags_err:
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
+		err = mnt_want_write(filp->f_vfsmnt);
+		if (err)
+			return err;
 
 		if (copy_from_user(&input, (struct ext4_new_group_input __user *)arg,
-				sizeof(input)))
-			return -EFAULT;
-
+				sizeof(input))) {
+			err = -EFAULT;
+			goto group_add_out;
+		}
 		err = ext4_group_add(sb, &input);
 		jbd2_journal_lock_updates(EXT4_SB(sb)->s_journal);
 		jbd2_journal_flush(EXT4_SB(sb)->s_journal);
 		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
-
+	group_add_out:
+		mnt_drop_write(filp->f_vfsmnt);
 		return err;
 	}
 
diff -puN fs/fat/file.c~r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls fs/fat/file.c
--- a/fs/fat/file.c~r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls
+++ a/fs/fat/file.c
@@ -46,10 +46,9 @@ int fat_generic_ioctl(struct inode *inod
 
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
@@ -106,6 +105,8 @@ int fat_generic_ioctl(struct inode *inod
 		MSDOS_I(inode)->i_attrs = attr & ATTR_UNUSED;
 		mark_inode_dirty(inode);
 	up:
+		mnt_drop_write(filp->f_vfsmnt);
+	up_no_drop_write:
 		mutex_unlock(&inode->i_mutex);
 		return err;
 	}
diff -puN fs/hfsplus/ioctl.c~r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls fs/hfsplus/ioctl.c
--- a/fs/hfsplus/ioctl.c~r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls
+++ a/fs/hfsplus/ioctl.c
@@ -35,25 +35,32 @@ int hfsplus_ioctl(struct inode *inode, s
 			flags |= FS_NODUMP_FL; /* EXT2_NODUMP_FL */
 		return put_user(flags, (int __user *)arg);
 	case HFSPLUS_IOC_EXT2_SETFLAGS: {
-		if (IS_RDONLY(inode))
-			return -EROFS;
-
-		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
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
+		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER)) {
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
@@ -75,7 +82,9 @@ int hfsplus_ioctl(struct inode *inode, s
 
 		inode->i_ctime = CURRENT_TIME_SEC;
 		mark_inode_dirty(inode);
-		return 0;
+	setflags_out:
+		mnt_drop_write(filp->f_vfsmnt);
+		return err;
 	}
 	default:
 		return -ENOTTY;
diff -puN fs/jfs/ioctl.c~r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls fs/jfs/ioctl.c
--- a/fs/jfs/ioctl.c~r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls
+++ a/fs/jfs/ioctl.c
@@ -64,16 +64,20 @@ int jfs_ioctl(struct inode * inode, stru
 		return put_user(flags, (int __user *) arg);
 	case JFS_IOC_SETFLAGS: {
 		unsigned int oldflags;
+		int err;
 
-		if (IS_RDONLY(inode))
-			return -EROFS;
-
-		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
-			return -EACCES;
-
-		if (get_user(flags, (int __user *) arg))
-			return -EFAULT;
-
+		err = mnt_want_write(filp->f_vfsmnt);
+		if (err)
+			return err;
+
+		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER)) {
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
@@ -87,8 +91,10 @@ int jfs_ioctl(struct inode * inode, stru
 		if ((oldflags & JFS_IMMUTABLE_FL) ||
 			((flags ^ oldflags) &
 			(JFS_APPEND_FL | JFS_IMMUTABLE_FL))) {
-			if (!capable(CAP_LINUX_IMMUTABLE))
-				return -EPERM;
+			if (!capable(CAP_LINUX_IMMUTABLE)) {
+				err = -EPERM;
+				goto setflags_out;
+			}
 		}
 
 		flags = flags & JFS_FL_USER_MODIFIABLE;
@@ -98,7 +104,9 @@ int jfs_ioctl(struct inode * inode, stru
 		jfs_set_inode_flags(inode);
 		inode->i_ctime = CURRENT_TIME_SEC;
 		mark_inode_dirty(inode);
-		return 0;
+	setflags_out:
+		mnt_drop_write(filp->f_vfsmnt);
+		return err;
 	}
 	default:
 		return -ENOTTY;
diff -puN fs/ocfs2/ioctl.c~r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls fs/ocfs2/ioctl.c
--- a/fs/ocfs2/ioctl.c~r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls
+++ a/fs/ocfs2/ioctl.c
@@ -56,10 +56,6 @@ static int ocfs2_set_inode_attr(struct i
 		goto bail;
 	}
 
-	status = -EROFS;
-	if (IS_RDONLY(inode))
-		goto bail_unlock;
-
 	status = -EACCES;
 	if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
 		goto bail_unlock;
@@ -127,8 +123,13 @@ int ocfs2_ioctl(struct inode * inode, st
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
 	default:
 		return -ENOTTY;
 	}
diff -puN fs/reiserfs/ioctl.c~r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls fs/reiserfs/ioctl.c
--- a/fs/reiserfs/ioctl.c~r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls
+++ a/fs/reiserfs/ioctl.c
@@ -25,6 +25,7 @@ int reiserfs_ioctl(struct inode *inode, 
 		   unsigned long arg)
 {
 	unsigned int flags;
+	int err = 0;
 
 	switch (cmd) {
 	case REISERFS_IOC_UNPACK:
@@ -48,48 +49,61 @@ int reiserfs_ioctl(struct inode *inode, 
 			if (!reiserfs_attrs(inode->i_sb))
 				return -ENOTTY;
 
-			if (IS_RDONLY(inode))
-				return -EROFS;
+			err = mnt_want_write(filp->f_vfsmnt);
+			if (err)
+				return err;
 
 			if ((current->fsuid != inode->i_uid)
-			    && !capable(CAP_FOWNER))
-				return -EPERM;
-
-			if (get_user(flags, (int __user *)arg))
-				return -EFAULT;
-
+			    && !capable(CAP_FOWNER)) {
+				err = -EPERM;
+				goto setflags_out;
+			}
+			if (get_user(flags, (int __user *)arg)) {
+				err = -EFAULT;
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
+	setflags_out:
+			mnt_drop_write(filp->f_vfsmnt);
+			return err;
 		}
 	case REISERFS_IOC_GETVERSION:
 		return put_user(inode->i_generation, (int __user *)arg);
 	case REISERFS_IOC_SETVERSION:
 		if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
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
+	setversion_out:
+		mnt_drop_write(filp->f_vfsmnt);
+		return err;
 	default:
 		return -ENOTTY;
 	}
diff -puN fs/xfs/linux-2.6/xfs_ioctl.c~r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls fs/xfs/linux-2.6/xfs_ioctl.c
--- a/fs/xfs/linux-2.6/xfs_ioctl.c~r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls
+++ a/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -526,8 +526,6 @@ xfs_attrmulti_attr_set(
 	char			*kbuf;
 	int			error = EFAULT;
 
-	if (IS_RDONLY(&vp->v_inode))
-		return -EROFS;
 	if (IS_IMMUTABLE(&vp->v_inode) || IS_APPEND(&vp->v_inode))
 		return EPERM;
 	if (len > XATTR_SIZE_MAX)
@@ -553,8 +551,6 @@ xfs_attrmulti_attr_remove(
 	char			*name,
 	__uint32_t		flags)
 {
-	if (IS_RDONLY(&vp->v_inode))
-		return -EROFS;
 	if (IS_IMMUTABLE(&vp->v_inode) || IS_APPEND(&vp->v_inode))
 		return EPERM;
 	return bhv_vop_attr_remove(vp, name, flags, NULL);
@@ -618,13 +614,21 @@ xfs_attrmulti_by_handle(
 					&ops[i].am_length, ops[i].am_flags);
 			break;
 		case ATTR_OP_SET:
+			ops[i].am_error = mnt_want_write(parfilp->f_vfsmnt);
+			if (ops[i].am_error)
+				break;
 			ops[i].am_error = xfs_attrmulti_attr_set(vp,
 					attr_name, ops[i].am_attrvalue,
 					ops[i].am_length, ops[i].am_flags);
+			mnt_drop_write(parfilp->f_vfsmnt);
 			break;
 		case ATTR_OP_REMOVE:
+			ops[i].am_error = mnt_want_write(parfilp->f_vfsmnt);
+			if (ops[i].am_error)
+				break;
 			ops[i].am_error = xfs_attrmulti_attr_remove(vp,
 					attr_name, ops[i].am_flags);
+			mnt_drop_write(parfilp->f_vfsmnt);
 			break;
 		default:
 			ops[i].am_error = EINVAL;
diff -puN fs/xfs/linux-2.6/xfs_iops.c~r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls fs/xfs/linux-2.6/xfs_iops.c
--- a/fs/xfs/linux-2.6/xfs_iops.c~r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls
+++ a/fs/xfs/linux-2.6/xfs_iops.c
@@ -156,13 +156,6 @@ xfs_ichgtime_fast(
 	 */
 	ASSERT((flags & XFS_ICHGTIME_ACC) == 0);
 
-	/*
-	 * We're not supposed to change timestamps in readonly-mounted
-	 * filesystems.  Throw it away if anyone asks us.
-	 */
-	if (unlikely(IS_RDONLY(inode)))
-		return;
-
 	if (flags & XFS_ICHGTIME_MOD) {
 		tvp = &inode->i_mtime;
 		ip->i_d.di_mtime.t_sec = (__int32_t)tvp->tv_sec;
diff -puN fs/xfs/linux-2.6/xfs_lrw.c~r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls fs/xfs/linux-2.6/xfs_lrw.c
--- a/fs/xfs/linux-2.6/xfs_lrw.c~r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls
+++ a/fs/xfs/linux-2.6/xfs_lrw.c
@@ -761,11 +761,16 @@ start:
 			goto start;
 		}
 	}
-
-	if (likely(!(ioflags & IO_INVIS))) {
+	/*
+ 	 * We're not supposed to change timestamps in readonly-mounted
+	 * filesystems.  Throw it away if anyone asks us.
+ 	 */
+	if (likely(!(ioflags & IO_INVIS) &&
+	    !mnt_want_write(file->f_vfsmnt))) {
 		file_update_time(file);
 		xfs_ichgtime_fast(xip, inode,
 				  XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+		mnt_drop_write(file->f_vfsmnt);
 	}
 
 	/*
_

Patches currently in -mm which might be from hansendc@us.ibm.com are

r-o-bind-mounts-r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
r-o-bind-mounts-elevate-writer-count-for-chown-and-friends.patch
r-o-bind-mounts-make-access-use-mnt-check.patch
r-o-bind-mounts-elevate-mnt-writers-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls.patch
r-o-bind-mounts-elevate-mount-count-for-extended-attributes.patch
r-o-bind-mounts-elevate-write-count-for-file_update_time.patch
r-o-bind-mounts-mount_is_safe-add-comment.patch
r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime.patch
r-o-bind-mounts-elevate-write-count-over-calls-to-vfs_rename.patch
r-o-bind-mounts-elevate-write-count-files-are-opened.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-sb.patch
r-o-bind-mounts-elevate-writer-count-for-do_sys_truncate.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime.patch
r-o-bind-mounts-sys_mknodat-elevate-write-count-for-vfs_mknod-create.patch
r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers.patch
r-o-bind-mounts-do_rmdir-elevate-write-count.patch
r-o-bind-mounts-elevate-writer-count-for-custom-struct_file.patch
r-o-bind-mounts-remove-is_rdonly-from-permission.patch
r-o-bind-mounts-reiser4-remove-is_rdonly-checks.patch
