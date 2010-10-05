From: akpm@linux-foundation.org
Subject: + vfs-add-sb_force_remount_readonly-helper.patch added to -mm tree
Date: Tue, 05 Oct 2010 12:42:52 -0700
Message-ID: <201010051942.o95JgqFC015707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58668 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755979Ab0JETnE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 15:43:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     vfs: add sb_force_remount_readonly() helper
has been added to the -mm tree.  Its filename is
     vfs-add-sb_force_remount_readonly-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: add sb_force_remount_readonly() helper
From: Miklos Szeredi <mszeredi@suse.cz>

Add helper for filesystems to call when forcefully remounting read-only
(such as on filesystem errors).

Functionally this doesn't change anything.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/pohmelfs/net.c |    2 +-
 fs/affs/amigaffs.c             |    2 +-
 fs/ext2/super.c                |    2 +-
 fs/ext3/super.c                |    4 ++--
 fs/ext4/super.c                |    4 ++--
 fs/fat/misc.c                  |    2 +-
 fs/hpfs/super.c                |    2 +-
 fs/jfs/super.c                 |    2 +-
 fs/namespace.c                 |    6 ++++++
 fs/nilfs2/super.c              |    2 +-
 fs/ocfs2/super.c               |    2 +-
 fs/reiserfs/journal.c          |    2 +-
 fs/reiserfs/prints.c           |    4 ++--
 fs/ubifs/io.c                  |    2 +-
 fs/ufs/super.c                 |    4 ++--
 include/linux/fs.h             |    1 +
 16 files changed, 25 insertions(+), 18 deletions(-)

diff -puN drivers/staging/pohmelfs/net.c~vfs-add-sb_force_remount_readonly-helper drivers/staging/pohmelfs/net.c
--- a/drivers/staging/pohmelfs/net.c~vfs-add-sb_force_remount_readonly-helper
+++ a/drivers/staging/pohmelfs/net.c
@@ -673,7 +673,7 @@ static int pohmelfs_root_cap_response(st
 	psb->state_flags = cap->flags;
 
 	if (psb->state_flags & POHMELFS_FLAGS_RO) {
-		psb->sb->s_flags |= MS_RDONLY;
+		sb_force_remount_readonly(psb->sb);
 		printk(KERN_INFO "Mounting POHMELFS (%d) read-only.\n", psb->idx);
 	}
 
diff -puN fs/affs/amigaffs.c~vfs-add-sb_force_remount_readonly-helper fs/affs/amigaffs.c
--- a/fs/affs/amigaffs.c~vfs-add-sb_force_remount_readonly-helper
+++ a/fs/affs/amigaffs.c
@@ -458,7 +458,7 @@ affs_error(struct super_block *sb, const
 		function,ErrorBuffer);
 	if (!(sb->s_flags & MS_RDONLY))
 		printk(KERN_WARNING "AFFS: Remounting filesystem read-only\n");
-	sb->s_flags |= MS_RDONLY;
+	sb_force_remount_readonly(sb);
 }
 
 void
diff -puN fs/ext2/super.c~vfs-add-sb_force_remount_readonly-helper fs/ext2/super.c
--- a/fs/ext2/super.c~vfs-add-sb_force_remount_readonly-helper
+++ a/fs/ext2/super.c
@@ -69,7 +69,7 @@ void ext2_error (struct super_block * sb
 	if (test_opt(sb, ERRORS_RO)) {
 		ext2_msg(sb, KERN_CRIT,
 			     "error: remounting filesystem read-only");
-		sb->s_flags |= MS_RDONLY;
+		sb_force_remount_readonly(sb);
 	}
 }
 
diff -puN fs/ext3/super.c~vfs-add-sb_force_remount_readonly-helper fs/ext3/super.c
--- a/fs/ext3/super.c~vfs-add-sb_force_remount_readonly-helper
+++ a/fs/ext3/super.c
@@ -189,7 +189,7 @@ static void ext3_handle_error(struct sup
 	if (test_opt (sb, ERRORS_RO)) {
 		ext3_msg(sb, KERN_CRIT,
 			"error: remounting filesystem read-only");
-		sb->s_flags |= MS_RDONLY;
+		sb_force_remount_readonly(sb);
 	}
 	ext3_commit_super(sb, es, 1);
 	if (test_opt(sb, ERRORS_PANIC))
@@ -296,7 +296,7 @@ void ext3_abort (struct super_block * sb
 	ext3_msg(sb, KERN_CRIT,
 		"error: remounting filesystem read-only");
 	EXT3_SB(sb)->s_mount_state |= EXT3_ERROR_FS;
-	sb->s_flags |= MS_RDONLY;
+	sb_force_remount_readonly(sb);
 	set_opt(EXT3_SB(sb)->s_mount_opt, ABORT);
 	if (EXT3_SB(sb)->s_journal)
 		journal_abort(EXT3_SB(sb)->s_journal, -EIO);
diff -puN fs/ext4/super.c~vfs-add-sb_force_remount_readonly-helper fs/ext4/super.c
--- a/fs/ext4/super.c~vfs-add-sb_force_remount_readonly-helper
+++ a/fs/ext4/super.c
@@ -371,7 +371,7 @@ static void ext4_handle_error(struct sup
 	}
 	if (test_opt(sb, ERRORS_RO)) {
 		ext4_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
-		sb->s_flags |= MS_RDONLY;
+		sb_force_remount_readonly(sb);
 	}
 	if (test_opt(sb, ERRORS_PANIC))
 		panic("EXT4-fs (device %s): panic forced after error\n",
@@ -526,7 +526,7 @@ void __ext4_abort(struct super_block *sb
 
 	if ((sb->s_flags & MS_RDONLY) == 0) {
 		ext4_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
-		sb->s_flags |= MS_RDONLY;
+		sb_force_remount_readonly(sb);
 		EXT4_SB(sb)->s_mount_flags |= EXT4_MF_FS_ABORTED;
 		if (EXT4_SB(sb)->s_journal)
 			jbd2_journal_abort(EXT4_SB(sb)->s_journal, -EIO);
diff -puN fs/fat/misc.c~vfs-add-sb_force_remount_readonly-helper fs/fat/misc.c
--- a/fs/fat/misc.c~vfs-add-sb_force_remount_readonly-helper
+++ a/fs/fat/misc.c
@@ -38,7 +38,7 @@ void __fat_fs_error(struct super_block *
 	if (opts->errors == FAT_ERRORS_PANIC)
 		panic("FAT: fs panic from previous error\n");
 	else if (opts->errors == FAT_ERRORS_RO && !(s->s_flags & MS_RDONLY)) {
-		s->s_flags |= MS_RDONLY;
+		sb_force_remount_readonly(s);
 		printk(KERN_ERR "FAT: Filesystem has been set read-only\n");
 	}
 }
diff -puN fs/hpfs/super.c~vfs-add-sb_force_remount_readonly-helper fs/hpfs/super.c
--- a/fs/hpfs/super.c~vfs-add-sb_force_remount_readonly-helper
+++ a/fs/hpfs/super.c
@@ -71,7 +71,7 @@ void hpfs_error(struct super_block *s, c
 			else {
 				printk("; remounting read-only\n");
 				mark_dirty(s);
-				s->s_flags |= MS_RDONLY;
+				sb_force_remount_readonly(s);
 			}
 		} else if (s->s_flags & MS_RDONLY) printk("; going on - but anything won't be destroyed because it's read-only\n");
 		else printk("; corrupted filesystem mounted read/write - your computer will explode within 20 seconds ... but you wanted it so!\n");
diff -puN fs/jfs/super.c~vfs-add-sb_force_remount_readonly-helper fs/jfs/super.c
--- a/fs/jfs/super.c~vfs-add-sb_force_remount_readonly-helper
+++ a/fs/jfs/super.c
@@ -85,7 +85,7 @@ static void jfs_handle_error(struct supe
 		jfs_err("ERROR: (device %s): remounting filesystem "
 			"as read-only\n",
 			sb->s_id);
-		sb->s_flags |= MS_RDONLY;
+		sb_force_remount_readonly(sb);
 	}
 
 	/* nothing is done for continue beyond marking the superblock dirty */
diff -puN fs/namespace.c~vfs-add-sb_force_remount_readonly-helper fs/namespace.c
--- a/fs/namespace.c~vfs-add-sb_force_remount_readonly-helper
+++ a/fs/namespace.c
@@ -413,6 +413,12 @@ static int mnt_make_writable(struct vfsm
 	return err;
 }
 
+void sb_force_remount_readonly(struct super_block *sb)
+{
+	sb->s_flags |= MS_RDONLY;
+}
+EXPORT_SYMBOL(sb_force_remount_readonly);
+
 void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
 {
 	mnt->mnt_sb = sb;
diff -puN fs/nilfs2/super.c~vfs-add-sb_force_remount_readonly-helper fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~vfs-add-sb_force_remount_readonly-helper
+++ a/fs/nilfs2/super.c
@@ -124,7 +124,7 @@ void nilfs_error(struct super_block *sb,
 
 		if (nilfs_test_opt(sbi, ERRORS_RO)) {
 			printk(KERN_CRIT "Remounting filesystem read-only\n");
-			sb->s_flags |= MS_RDONLY;
+			sb_force_remount_readonly(sb);
 		}
 	}
 
diff -puN fs/ocfs2/super.c~vfs-add-sb_force_remount_readonly-helper fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~vfs-add-sb_force_remount_readonly-helper
+++ a/fs/ocfs2/super.c
@@ -2554,7 +2554,7 @@ static void ocfs2_handle_error(struct su
 	printk(KERN_CRIT "File system is now read-only due to the potential "
 	       "of on-disk corruption. Please run fsck.ocfs2 once the file "
 	       "system is unmounted.\n");
-	sb->s_flags |= MS_RDONLY;
+	sb_force_remount_readonly(sb);
 	ocfs2_set_ro_flag(osb, 0);
 }
 
diff -puN fs/reiserfs/journal.c~vfs-add-sb_force_remount_readonly-helper fs/reiserfs/journal.c
--- a/fs/reiserfs/journal.c~vfs-add-sb_force_remount_readonly-helper
+++ a/fs/reiserfs/journal.c
@@ -4317,7 +4317,7 @@ void reiserfs_abort_journal(struct super
 	if (!journal->j_errno)
 		journal->j_errno = errno;
 
-	sb->s_flags |= MS_RDONLY;
+	sb_force_remount_readonly(sb);
 	set_bit(J_ABORTED, &journal->j_state);
 
 #ifdef CONFIG_REISERFS_CHECK
diff -puN fs/reiserfs/prints.c~vfs-add-sb_force_remount_readonly-helper fs/reiserfs/prints.c
--- a/fs/reiserfs/prints.c~vfs-add-sb_force_remount_readonly-helper
+++ a/fs/reiserfs/prints.c
@@ -387,7 +387,7 @@ void __reiserfs_error(struct super_block
 		return;
 
 	reiserfs_info(sb, "Remounting filesystem read-only\n");
-	sb->s_flags |= MS_RDONLY;
+	sb_force_remount_readonly(sb);
 	reiserfs_abort_journal(sb, -EIO);
 }
 
@@ -406,7 +406,7 @@ void reiserfs_abort(struct super_block *
 	printk(KERN_CRIT "REISERFS abort (device %s): %s\n", sb->s_id,
 	       error_buf);
 
-	sb->s_flags |= MS_RDONLY;
+	sb_force_remount_readonly(sb);
 	reiserfs_abort_journal(sb, errno);
 }
 
diff -puN fs/ubifs/io.c~vfs-add-sb_force_remount_readonly-helper fs/ubifs/io.c
--- a/fs/ubifs/io.c~vfs-add-sb_force_remount_readonly-helper
+++ a/fs/ubifs/io.c
@@ -64,7 +64,7 @@ void ubifs_ro_mode(struct ubifs_info *c,
 	if (!c->ro_error) {
 		c->ro_error = 1;
 		c->no_chk_data_crc = 0;
-		c->vfs_sb->s_flags |= MS_RDONLY;
+		sb_force_remount_readonly(c->vfs_sb);
 		ubifs_warn("switched to read-only mode, error %d", err);
 		dbg_dump_stack();
 	}
diff -puN fs/ufs/super.c~vfs-add-sb_force_remount_readonly-helper fs/ufs/super.c
--- a/fs/ufs/super.c~vfs-add-sb_force_remount_readonly-helper
+++ a/fs/ufs/super.c
@@ -288,7 +288,7 @@ void ufs_error (struct super_block * sb,
 		usb1->fs_clean = UFS_FSBAD;
 		ubh_mark_buffer_dirty(USPI_UBH(uspi));
 		sb->s_dirt = 1;
-		sb->s_flags |= MS_RDONLY;
+		sb_force_remount_readonly(sb);
 	}
 	va_start (args, fmt);
 	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
@@ -325,7 +325,7 @@ void ufs_panic (struct super_block * sb,
 	va_start (args, fmt);
 	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
 	va_end (args);
-	sb->s_flags |= MS_RDONLY;
+	sb_force_remount_readonly(sb);
 	printk (KERN_CRIT "UFS-fs panic (device %s): %s: %s\n",
 		sb->s_id, function, error_buf);
 }
diff -puN include/linux/fs.h~vfs-add-sb_force_remount_readonly-helper include/linux/fs.h
--- a/include/linux/fs.h~vfs-add-sb_force_remount_readonly-helper
+++ a/include/linux/fs.h
@@ -2067,6 +2067,7 @@ extern const struct file_operations writ
 extern const struct file_operations rdwr_pipefifo_fops;
 
 extern int fs_may_remount_ro(struct super_block *);
+extern void sb_force_remount_readonly(struct super_block *);
 
 #ifdef CONFIG_BLOCK
 /*
_

Patches currently in -mm which might be from mszeredi@suse.cz are

linux-next.patch
vfs-fix-infinite-loop-caused-by-clone_mnt-race.patch
vfs-ignore-error-on-forced-remount.patch
vfs-fix-per-mount-read-write.patch
vfs-add-sb_force_remount_readonly-helper.patch
vfs-allow-mnt_want_write-to-sleep.patch
vfs-allow-mnt_want_write-to-sleep-fix.patch
vfs-keep-list-of-mounts-for-each-superblock.patch
vfs-protect-remounting-superblock-read-only.patch
vfs-fs_may_remount_ro-turn-unnecessary-check-into-a-warn_on.patch
vfs-mark-mounts-read-only-on-forced-remount.patch
fuse-use-clear_highpage-and-km_user0-instead-of-km_user1.patch
fuse-use-release_pages.patch

