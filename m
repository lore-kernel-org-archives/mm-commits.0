From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Date: Mon, 25 Sep 2017 13:56:38 -0700
Message-ID: <20170925205638.UB6kSaGpy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45328 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934254AbdIYU4j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Sep 2017 16:56:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/lustre/lustre/llite/llite_lib.c |    5 -----
 fs/affs/super.c                                 |    4 ----
 fs/btrfs/root-tree.c                            |    7 -------
 fs/btrfs/super.c                                |   10 ----------
 fs/ecryptfs/main.c                              |    4 ----
 fs/ext2/super.c                                 |    8 --------
 fs/ext4/super.c                                 |    8 --------
 fs/fat/inode.c                                  |    4 ----
 fs/fat/misc.c                                   |    4 ----
 fs/hfs/super.c                                  |    5 -----
 fs/hfsplus/super.c                              |    4 ----
 fs/jfs/super.c                                  |    8 --------
 fs/minix/inode.c                                |    4 ----
 fs/nfs/super.c                                  |    6 ------
 fs/nilfs2/super.c                               |    4 ----
 fs/ntfs/super.c                                 |    8 --------
 fs/ocfs2/super.c                                |    4 ----
 fs/reiserfs/super.c                             |    4 ----
 fs/ubifs/super.c                                |    5 -----
 fs/udf/super.c                                  |    4 ----
 fs/ufs/super.c                                  |    4 ----
 include/linux/fs.h                              |    4 ----
 22 files changed, 118 deletions(-)

diff -puN drivers/staging/lustre/lustre/llite/llite_lib.c~linux-next-git-rejects drivers/staging/lustre/lustre/llite/llite_lib.c
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c~linux-next-git-rejects
+++ a/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -2031,13 +2031,8 @@ int ll_remount_fs(struct super_block *sb
 	int err;
 	__u32 read_only;
 
-<<<<<<< HEAD
-	if ((bool)(*flags & MS_RDONLY) != sb_rdonly(sb)) {
-		read_only = *flags & MS_RDONLY;
-=======
 	if ((bool)(*flags & SB_RDONLY) != sb_rdonly(sb)) {
 		read_only = *flags & SB_RDONLY;
->>>>>>> linux-next/akpm-base
 		err = obd_set_info_async(NULL, sbi->ll_md_exp,
 					 sizeof(KEY_READ_ONLY),
 					 KEY_READ_ONLY, sizeof(read_only),
diff -puN fs/affs/super.c~linux-next-git-rejects fs/affs/super.c
--- a/fs/affs/super.c~linux-next-git-rejects
+++ a/fs/affs/super.c
@@ -596,11 +596,7 @@ affs_remount(struct super_block *sb, int
 	memcpy(sbi->s_volume, volume, 32);
 	spin_unlock(&sbi->symlink_lock);
 
-<<<<<<< HEAD
-	if ((bool)(*flags & MS_RDONLY) == sb_rdonly(sb))
-=======
 	if ((bool)(*flags & SB_RDONLY) == sb_rdonly(sb))
->>>>>>> linux-next/akpm-base
 		return 0;
 
 	if (*flags & SB_RDONLY)
diff -puN fs/btrfs/root-tree.c~linux-next-git-rejects fs/btrfs/root-tree.c
--- a/fs/btrfs/root-tree.c~linux-next-git-rejects
+++ a/fs/btrfs/root-tree.c
@@ -226,13 +226,6 @@ int btrfs_find_orphan_roots(struct btrfs
 	struct btrfs_root *root;
 	int err = 0;
 	int ret;
-<<<<<<< HEAD
-	bool can_recover = true;
-
-	if (sb_rdonly(fs_info->sb))
-		can_recover = false;
-=======
->>>>>>> linux-next/akpm-base
 
 	path = btrfs_alloc_path();
 	if (!path)
diff -puN fs/btrfs/super.c~linux-next-git-rejects fs/btrfs/super.c
--- a/fs/btrfs/super.c~linux-next-git-rejects
+++ a/fs/btrfs/super.c
@@ -1748,11 +1748,7 @@ static int btrfs_remount(struct super_bl
 	btrfs_resize_thread_pool(fs_info,
 		fs_info->thread_pool_size, old_thread_pool_size);
 
-<<<<<<< HEAD
-	if ((bool)(*flags & MS_RDONLY) == sb_rdonly(sb))
-=======
 	if ((bool)(*flags & SB_RDONLY) == sb_rdonly(sb))
->>>>>>> linux-next/akpm-base
 		goto out;
 
 	if (*flags & SB_RDONLY) {
@@ -1852,15 +1848,9 @@ out:
 	return 0;
 
 restore:
-<<<<<<< HEAD
-	/* We've hit an error - don't reset MS_RDONLY */
-	if (sb_rdonly(sb))
-		old_flags |= MS_RDONLY;
-=======
 	/* We've hit an error - don't reset SB_RDONLY */
 	if (sb_rdonly(sb))
 		old_flags |= SB_RDONLY;
->>>>>>> linux-next/akpm-base
 	sb->s_flags = old_flags;
 	fs_info->mount_opt = old_opts;
 	fs_info->compress_type = old_compress_type;
diff -puN fs/ecryptfs/main.c~linux-next-git-rejects fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~linux-next-git-rejects
+++ a/fs/ecryptfs/main.c
@@ -569,11 +569,7 @@ static struct dentry *ecryptfs_mount(str
 	 *   2) The ecryptfs_encrypted_view mount option is specified
 	 */
 	if (sb_rdonly(path.dentry->d_sb) || mount_crypt_stat->flags & ECRYPTFS_ENCRYPTED_VIEW_ENABLED)
-<<<<<<< HEAD
-		s->s_flags |= MS_RDONLY;
-=======
 		s->s_flags |= SB_RDONLY;
->>>>>>> linux-next/akpm-base
 
 	s->s_maxbytes = path.dentry->d_sb->s_maxbytes;
 	s->s_blocksize = path.dentry->d_sb->s_blocksize;
diff -puN fs/ext2/super.c~linux-next-git-rejects fs/ext2/super.c
--- a/fs/ext2/super.c~linux-next-git-rejects
+++ a/fs/ext2/super.c
@@ -1173,11 +1173,7 @@ static int ext2_fill_super(struct super_
 		ext2_msg(sb, KERN_WARNING,
 			"warning: mounting ext3 filesystem as ext2");
 	if (ext2_setup_super (sb, es, sb_rdonly(sb)))
-<<<<<<< HEAD
-		sb->s_flags |= MS_RDONLY;
-=======
 		sb->s_flags |= SB_RDONLY;
->>>>>>> linux-next/akpm-base
 	ext2_write_super(sb);
 	return 0;
 
@@ -1346,11 +1342,7 @@ static int ext2_remount (struct super_bl
 			 "dax flag with busy inodes while remounting");
 		sbi->s_mount_opt ^= EXT2_MOUNT_DAX;
 	}
-<<<<<<< HEAD
-	if ((bool)(*flags & MS_RDONLY) == sb_rdonly(sb)) {
-=======
 	if ((bool)(*flags & SB_RDONLY) == sb_rdonly(sb)) {
->>>>>>> linux-next/akpm-base
 		spin_unlock(&sbi->s_lock);
 		return 0;
 	}
diff -puN fs/ext4/super.c~linux-next-git-rejects fs/ext4/super.c
--- a/fs/ext4/super.c~linux-next-git-rejects
+++ a/fs/ext4/super.c
@@ -4196,11 +4196,7 @@ no_journal:
 	}
 
 	if (ext4_setup_super(sb, es, sb_rdonly(sb)))
-<<<<<<< HEAD
-		sb->s_flags |= MS_RDONLY;
-=======
 		sb->s_flags |= SB_RDONLY;
->>>>>>> linux-next/akpm-base
 
 	/* determine the minimum size of new large inodes, if present */
 	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE &&
@@ -5060,11 +5056,7 @@ static int ext4_remount(struct super_blo
 	if (*flags & SB_LAZYTIME)
 		sb->s_flags |= SB_LAZYTIME;
 
-<<<<<<< HEAD
-	if ((bool)(*flags & MS_RDONLY) != sb_rdonly(sb)) {
-=======
 	if ((bool)(*flags & SB_RDONLY) != sb_rdonly(sb)) {
->>>>>>> linux-next/akpm-base
 		if (sbi->s_mount_flags & EXT4_MF_FS_ABORTED) {
 			err = -EROFS;
 			goto restore_opts;
diff -puN fs/fat/inode.c~linux-next-git-rejects fs/fat/inode.c
--- a/fs/fat/inode.c~linux-next-git-rejects
+++ a/fs/fat/inode.c
@@ -786,11 +786,7 @@ static int fat_remount(struct super_bloc
 	sync_filesystem(sb);
 
 	/* make sure we update state on remount. */
-<<<<<<< HEAD
-	new_rdonly = *flags & MS_RDONLY;
-=======
 	new_rdonly = *flags & SB_RDONLY;
->>>>>>> linux-next/akpm-base
 	if (new_rdonly != sb_rdonly(sb)) {
 		if (new_rdonly)
 			fat_set_state(sb, 0, 0);
diff -puN fs/fat/misc.c~linux-next-git-rejects fs/fat/misc.c
--- a/fs/fat/misc.c~linux-next-git-rejects
+++ a/fs/fat/misc.c
@@ -33,11 +33,7 @@ void __fat_fs_error(struct super_block *
 	if (opts->errors == FAT_ERRORS_PANIC)
 		panic("FAT-fs (%s): fs panic from previous error\n", sb->s_id);
 	else if (opts->errors == FAT_ERRORS_RO && !sb_rdonly(sb)) {
-<<<<<<< HEAD
-		sb->s_flags |= MS_RDONLY;
-=======
 		sb->s_flags |= SB_RDONLY;
->>>>>>> linux-next/akpm-base
 		fat_msg(sb, KERN_ERR, "Filesystem has been set read-only");
 	}
 }
diff -puN fs/hfsplus/super.c~linux-next-git-rejects fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~linux-next-git-rejects
+++ a/fs/hfsplus/super.c
@@ -329,11 +329,7 @@ static int hfsplus_statfs(struct dentry
 static int hfsplus_remount(struct super_block *sb, int *flags, char *data)
 {
 	sync_filesystem(sb);
-<<<<<<< HEAD
-	if ((bool)(*flags & MS_RDONLY) == sb_rdonly(sb))
-=======
 	if ((bool)(*flags & SB_RDONLY) == sb_rdonly(sb))
->>>>>>> linux-next/akpm-base
 		return 0;
 	if (!(*flags & SB_RDONLY)) {
 		struct hfsplus_vh *vhdr = HFSPLUS_SB(sb)->s_vhdr;
diff -puN fs/hfs/super.c~linux-next-git-rejects fs/hfs/super.c
--- a/fs/hfs/super.c~linux-next-git-rejects
+++ a/fs/hfs/super.c
@@ -114,13 +114,8 @@ static int hfs_statfs(struct dentry *den
 static int hfs_remount(struct super_block *sb, int *flags, char *data)
 {
 	sync_filesystem(sb);
-<<<<<<< HEAD
-	*flags |= MS_NODIRATIME;
-	if ((bool)(*flags & MS_RDONLY) == sb_rdonly(sb))
-=======
 	*flags |= SB_NODIRATIME;
 	if ((bool)(*flags & SB_RDONLY) == sb_rdonly(sb))
->>>>>>> linux-next/akpm-base
 		return 0;
 	if (!(*flags & SB_RDONLY)) {
 		if (!(HFS_SB(sb)->mdb->drAtrb & cpu_to_be16(HFS_SB_ATTRIB_UNMNT))) {
diff -puN fs/jfs/super.c~linux-next-git-rejects fs/jfs/super.c
--- a/fs/jfs/super.c~linux-next-git-rejects
+++ a/fs/jfs/super.c
@@ -477,11 +477,7 @@ static int jfs_remount(struct super_bloc
 			return rc;
 	}
 
-<<<<<<< HEAD
-	if (sb_rdonly(sb) && !(*flags & MS_RDONLY)) {
-=======
 	if (sb_rdonly(sb) && !(*flags & SB_RDONLY)) {
->>>>>>> linux-next/akpm-base
 		/*
 		 * Invalidate any previously read metadata.  fsck may have
 		 * changed the on-disk data since we mounted r/o
@@ -497,11 +493,7 @@ static int jfs_remount(struct super_bloc
 		dquot_resume(sb, -1);
 		return ret;
 	}
-<<<<<<< HEAD
-	if (!sb_rdonly(sb) && (*flags & MS_RDONLY)) {
-=======
 	if (!sb_rdonly(sb) && (*flags & SB_RDONLY)) {
->>>>>>> linux-next/akpm-base
 		rc = dquot_suspend(sb, -1);
 		if (rc < 0)
 			return rc;
diff -puN fs/minix/inode.c~linux-next-git-rejects fs/minix/inode.c
--- a/fs/minix/inode.c~linux-next-git-rejects
+++ a/fs/minix/inode.c
@@ -125,11 +125,7 @@ static int minix_remount (struct super_b
 
 	sync_filesystem(sb);
 	ms = sbi->s_ms;
-<<<<<<< HEAD
-	if ((bool)(*flags & MS_RDONLY) == sb_rdonly(sb))
-=======
 	if ((bool)(*flags & SB_RDONLY) == sb_rdonly(sb))
->>>>>>> linux-next/akpm-base
 		return 0;
 	if (*flags & SB_RDONLY) {
 		if (ms->s_state & MINIX_VALID_FS ||
diff -puN fs/nfs/super.c~linux-next-git-rejects fs/nfs/super.c
--- a/fs/nfs/super.c~linux-next-git-rejects
+++ a/fs/nfs/super.c
@@ -813,15 +813,9 @@ int nfs_show_stats(struct seq_file *m, s
 	 */
 	seq_printf(m, "\n\topts:\t");
 	seq_puts(m, sb_rdonly(root->d_sb) ? "ro" : "rw");
-<<<<<<< HEAD
-	seq_puts(m, root->d_sb->s_flags & MS_SYNCHRONOUS ? ",sync" : "");
-	seq_puts(m, root->d_sb->s_flags & MS_NOATIME ? ",noatime" : "");
-	seq_puts(m, root->d_sb->s_flags & MS_NODIRATIME ? ",nodiratime" : "");
-=======
 	seq_puts(m, root->d_sb->s_flags & SB_SYNCHRONOUS ? ",sync" : "");
 	seq_puts(m, root->d_sb->s_flags & SB_NOATIME ? ",noatime" : "");
 	seq_puts(m, root->d_sb->s_flags & SB_NODIRATIME ? ",nodiratime" : "");
->>>>>>> linux-next/akpm-base
 	nfs_show_mount_options(m, nfss, 1);
 
 	seq_printf(m, "\n\tage:\t%lu", (jiffies - nfss->mount_time) / HZ);
diff -puN fs/nilfs2/super.c~linux-next-git-rejects fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~linux-next-git-rejects
+++ a/fs/nilfs2/super.c
@@ -1144,11 +1144,7 @@ static int nilfs_remount(struct super_bl
 		goto restore_opts;
 	}
 
-<<<<<<< HEAD
-	if ((bool)(*flags & MS_RDONLY) == sb_rdonly(sb))
-=======
 	if ((bool)(*flags & SB_RDONLY) == sb_rdonly(sb))
->>>>>>> linux-next/akpm-base
 		goto out;
 	if (*flags & SB_RDONLY) {
 		/* Shutting down log writer */
diff -puN fs/ntfs/super.c~linux-next-git-rejects fs/ntfs/super.c
--- a/fs/ntfs/super.c~linux-next-git-rejects
+++ a/fs/ntfs/super.c
@@ -487,11 +487,7 @@ static int ntfs_remount(struct super_blo
 	 * When remounting read-only, mark the volume clean if no volume errors
 	 * have occurred.
 	 */
-<<<<<<< HEAD
-	if (sb_rdonly(sb) && !(*flags & MS_RDONLY)) {
-=======
 	if (sb_rdonly(sb) && !(*flags & SB_RDONLY)) {
->>>>>>> linux-next/akpm-base
 		static const char *es = ".  Cannot remount read-write.";
 
 		/* Remounting read-write. */
@@ -552,11 +548,7 @@ static int ntfs_remount(struct super_blo
 			NVolSetErrors(vol);
 			return -EROFS;
 		}
-<<<<<<< HEAD
-	} else if (!sb_rdonly(sb) && (*flags & MS_RDONLY)) {
-=======
 	} else if (!sb_rdonly(sb) && (*flags & SB_RDONLY)) {
->>>>>>> linux-next/akpm-base
 		/* Remounting read-only. */
 		if (!NVolErrors(vol)) {
 			if (ntfs_clear_volume_flags(vol, VOLUME_IS_DIRTY))
diff -puN fs/ocfs2/super.c~linux-next-git-rejects fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~linux-next-git-rejects
+++ a/fs/ocfs2/super.c
@@ -675,11 +675,7 @@ static int ocfs2_remount(struct super_bl
 	}
 
 	/* We're going to/from readonly mode. */
-<<<<<<< HEAD
-	if ((bool)(*flags & MS_RDONLY) != sb_rdonly(sb)) {
-=======
 	if ((bool)(*flags & SB_RDONLY) != sb_rdonly(sb)) {
->>>>>>> linux-next/akpm-base
 		/* Disable quota accounting before remounting RO */
 		if (*flags & SB_RDONLY) {
 			ret = ocfs2_susp_quotas(osb, 0);
diff -puN fs/reiserfs/super.c~linux-next-git-rejects fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~linux-next-git-rejects
+++ a/fs/reiserfs/super.c
@@ -121,11 +121,7 @@ void reiserfs_schedule_old_flush(struct
 	 * Avoid scheduling flush when sb is being shut down. It can race
 	 * with journal shutdown and free still queued delayed work.
 	 */
-<<<<<<< HEAD
-	if (sb_rdonly(s) || !(s->s_flags & MS_ACTIVE))
-=======
 	if (sb_rdonly(s) || !(s->s_flags & SB_ACTIVE))
->>>>>>> linux-next/akpm-base
 		return;
 
 	spin_lock(&sbi->old_work_lock);
diff -puN fs/ubifs/super.c~linux-next-git-rejects fs/ubifs/super.c
--- a/fs/ubifs/super.c~linux-next-git-rejects
+++ a/fs/ubifs/super.c
@@ -1160,13 +1160,8 @@ static int mount_ubifs(struct ubifs_info
 	size_t sz;
 
 	c->ro_mount = !!sb_rdonly(c->vfs_sb);
-<<<<<<< HEAD
-	/* Suppress error messages while probing if MS_SILENT is set */
-	c->probing = !!(c->vfs_sb->s_flags & MS_SILENT);
-=======
 	/* Suppress error messages while probing if SB_SILENT is set */
 	c->probing = !!(c->vfs_sb->s_flags & SB_SILENT);
->>>>>>> linux-next/akpm-base
 
 	err = init_constants_early(c);
 	if (err)
diff -puN fs/udf/super.c~linux-next-git-rejects fs/udf/super.c
--- a/fs/udf/super.c~linux-next-git-rejects
+++ a/fs/udf/super.c
@@ -673,11 +673,7 @@ static int udf_remount_fs(struct super_b
 	sbi->s_dmode = uopt.dmode;
 	write_unlock(&sbi->s_cred_lock);
 
-<<<<<<< HEAD
-	if ((bool)(*flags & MS_RDONLY) == sb_rdonly(sb))
-=======
 	if ((bool)(*flags & SB_RDONLY) == sb_rdonly(sb))
->>>>>>> linux-next/akpm-base
 		goto out_unlock;
 
 	if (*flags & SB_RDONLY)
diff -puN fs/ufs/super.c~linux-next-git-rejects fs/ufs/super.c
--- a/fs/ufs/super.c~linux-next-git-rejects
+++ a/fs/ufs/super.c
@@ -1328,11 +1328,7 @@ static int ufs_remount (struct super_blo
 		return -EINVAL;
 	}
 
-<<<<<<< HEAD
-	if ((bool)(*mount_flags & MS_RDONLY) == sb_rdonly(sb)) {
-=======
 	if ((bool)(*mount_flags & SB_RDONLY) == sb_rdonly(sb)) {
->>>>>>> linux-next/akpm-base
 		UFS_SB(sb)->s_mount_opt = new_mount_opt;
 		mutex_unlock(&UFS_SB(sb)->s_lock);
 		return 0;
diff -puN include/linux/fs.h~linux-next-git-rejects include/linux/fs.h
--- a/include/linux/fs.h~linux-next-git-rejects
+++ a/include/linux/fs.h
@@ -1869,11 +1869,7 @@ struct super_operations {
  */
 #define __IS_FLG(inode, flg)	((inode)->i_sb->s_flags & (flg))
 
-<<<<<<< HEAD
-static inline bool sb_rdonly(const struct super_block *sb) { return sb->s_flags & MS_RDONLY; }
-=======
 static inline bool sb_rdonly(const struct super_block *sb) { return sb->s_flags & SB_RDONLY; }
->>>>>>> linux-next/akpm-base
 #define IS_RDONLY(inode)	sb_rdonly((inode)->i_sb)
 #define IS_SYNC(inode)		(__IS_FLG(inode, SB_SYNCHRONOUS) || \
 					((inode)->i_flags & S_SYNC))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

