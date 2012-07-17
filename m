From: akpm@linux-foundation.org
Subject: [merged] fs-ufs-get-rid-of-write_super.patch removed from -mm tree
Date: Tue, 17 Jul 2012 13:05:16 -0700
Message-ID: <20120717200516.AE33A100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:65360 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab2GQUFR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jul 2012 16:05:17 -0400
Received: by mail-yx0-f202.google.com with SMTP id l3so81417yen.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jul 2012 13:05:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: artem.bityutskiy@linux.intel.com, dushistov@mail.ru, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ufs: get rid of ->write_super()
has been removed from the -mm tree.  Its filename was
     fs-ufs-get-rid-of-write_super.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: fs/ufs: get rid of ->write_super()

Make UFS stop using the VFS '->write_super()' method along with the
's_dirt' superblock flag, because they are on their way out.

The way we implement this is that we schedule a delay job instead relying
on 's_dirt' and '->write_super()'.

The whole "superblock write-out" VFS infrastructure is served by the
'sync_supers()' kernel thread, which wakes up every 5 (by default) seconds
and writes out all dirty superblocks using the '->write_super()'
call-back.  But the problem with this thread is that it wastes power by
waking up the system every 5 seconds, even if there are no diry
superblocks, or there are no client file-systems which would need this
(e.g., btrfs does not use '->write_super()').  So we want to kill it
completely and thus, we need to make file-systems to stop using the
'->write_super()' VFS service, and then remove it together with the kernel
thread.

Tested using fsstress from the LTP project.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/balloc.c |    8 ++++----
 fs/ufs/ialloc.c |    4 ++--
 fs/ufs/super.c  |   40 ++++++++++++++++++++++++++++++----------
 fs/ufs/ufs.h    |    5 +++++
 fs/ufs/ufs_fs.h |    1 +
 5 files changed, 42 insertions(+), 16 deletions(-)

diff -puN fs/ufs/balloc.c~fs-ufs-get-rid-of-write_super fs/ufs/balloc.c
--- a/fs/ufs/balloc.c~fs-ufs-get-rid-of-write_super
+++ a/fs/ufs/balloc.c
@@ -116,7 +116,7 @@ void ufs_free_fragments(struct inode *in
 	ubh_mark_buffer_dirty (UCPI_UBH(ucpi));
 	if (sb->s_flags & MS_SYNCHRONOUS)
 		ubh_sync_block(UCPI_UBH(ucpi));
-	sb->s_dirt = 1;
+	ufs_mark_sb_dirty(sb);
 	
 	unlock_super (sb);
 	UFSD("EXIT\n");
@@ -214,7 +214,7 @@ do_more:
 		goto do_more;
 	}
 
-	sb->s_dirt = 1;
+	ufs_mark_sb_dirty(sb);
 	unlock_super (sb);
 	UFSD("EXIT\n");
 	return;
@@ -557,7 +557,7 @@ static u64 ufs_add_fragments(struct inod
 	ubh_mark_buffer_dirty (UCPI_UBH(ucpi));
 	if (sb->s_flags & MS_SYNCHRONOUS)
 		ubh_sync_block(UCPI_UBH(ucpi));
-	sb->s_dirt = 1;
+	ufs_mark_sb_dirty(sb);
 
 	UFSD("EXIT, fragment %llu\n", (unsigned long long)fragment);
 	
@@ -677,7 +677,7 @@ succed:
 	ubh_mark_buffer_dirty (UCPI_UBH(ucpi));
 	if (sb->s_flags & MS_SYNCHRONOUS)
 		ubh_sync_block(UCPI_UBH(ucpi));
-	sb->s_dirt = 1;
+	ufs_mark_sb_dirty(sb);
 
 	result += cgno * uspi->s_fpg;
 	UFSD("EXIT3, result %llu\n", (unsigned long long)result);
diff -puN fs/ufs/ialloc.c~fs-ufs-get-rid-of-write_super fs/ufs/ialloc.c
--- a/fs/ufs/ialloc.c~fs-ufs-get-rid-of-write_super
+++ a/fs/ufs/ialloc.c
@@ -116,7 +116,7 @@ void ufs_free_inode (struct inode * inod
 	if (sb->s_flags & MS_SYNCHRONOUS)
 		ubh_sync_block(UCPI_UBH(ucpi));
 	
-	sb->s_dirt = 1;
+	ufs_mark_sb_dirty(sb);
 	unlock_super (sb);
 	UFSD("EXIT\n");
 }
@@ -288,7 +288,7 @@ cg_found:
 	ubh_mark_buffer_dirty (UCPI_UBH(ucpi));
 	if (sb->s_flags & MS_SYNCHRONOUS)
 		ubh_sync_block(UCPI_UBH(ucpi));
-	sb->s_dirt = 1;
+	ufs_mark_sb_dirty(sb);
 
 	inode->i_ino = cg * uspi->s_ipg + bit;
 	inode_init_owner(inode, dir, mode);
diff -puN fs/ufs/super.c~fs-ufs-get-rid-of-write_super fs/ufs/super.c
--- a/fs/ufs/super.c~fs-ufs-get-rid-of-write_super
+++ a/fs/ufs/super.c
@@ -302,7 +302,7 @@ void ufs_error (struct super_block * sb,
 	if (!(sb->s_flags & MS_RDONLY)) {
 		usb1->fs_clean = UFS_FSBAD;
 		ubh_mark_buffer_dirty(USPI_UBH(uspi));
-		sb->s_dirt = 1;
+		ufs_mark_sb_dirty(sb);
 		sb->s_flags |= MS_RDONLY;
 	}
 	va_start (args, fmt);
@@ -334,7 +334,7 @@ void ufs_panic (struct super_block * sb,
 	if (!(sb->s_flags & MS_RDONLY)) {
 		usb1->fs_clean = UFS_FSBAD;
 		ubh_mark_buffer_dirty(USPI_UBH(uspi));
-		sb->s_dirt = 1;
+		ufs_mark_sb_dirty(sb);
 	}
 	va_start (args, fmt);
 	vsnprintf (error_buf, sizeof(error_buf), fmt, args);
@@ -715,7 +715,6 @@ static int ufs_sync_fs(struct super_bloc
 		ufs_set_fs_state(sb, usb1, usb3,
 				UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
 	ufs_put_cstotal(sb);
-	sb->s_dirt = 0;
 
 	UFSD("EXIT\n");
 	unlock_super(sb);
@@ -724,12 +723,31 @@ static int ufs_sync_fs(struct super_bloc
 	return 0;
 }
 
-static void ufs_write_super(struct super_block *sb)
+static void delayed_sync_fs(struct work_struct *work)
 {
-	if (!(sb->s_flags & MS_RDONLY))
-		ufs_sync_fs(sb, 1);
-	else
-		sb->s_dirt = 0;
+	struct ufs_sb_info *sbi;
+
+	sbi = container_of(work, struct ufs_sb_info, sync_work.work);
+
+	spin_lock(&sbi->work_lock);
+	sbi->work_queued = 0;
+	spin_unlock(&sbi->work_lock);
+
+	ufs_sync_fs(sbi->sb, 1);
+}
+
+void ufs_mark_sb_dirty(struct super_block *sb)
+{
+	struct ufs_sb_info *sbi = UFS_SB(sb);
+	unsigned long delay;
+
+	spin_lock(&sbi->work_lock);
+	if (!sbi->work_queued) {
+		delay = msecs_to_jiffies(dirty_writeback_interval * 10);
+		queue_delayed_work(system_long_wq, &sbi->sync_work, delay);
+		sbi->work_queued = 1;
+	}
+	spin_unlock(&sbi->work_lock);
 }
 
 static void ufs_put_super(struct super_block *sb)
@@ -740,6 +758,7 @@ static void ufs_put_super(struct super_b
 
 	if (!(sb->s_flags & MS_RDONLY))
 		ufs_put_super_internal(sb);
+	cancel_delayed_work_sync(&sbi->sync_work);
 
 	ubh_brelse_uspi(sbi->s_uspi);
 	kfree(sbi->s_uspi);
@@ -774,6 +793,7 @@ static int ufs_fill_super(struct super_b
 	if (!sbi)
 		goto failed_nomem;
 	sb->s_fs_info = sbi;
+	sbi->sb = sb;
 
 	UFSD("flag %u\n", (int)(sb->s_flags & MS_RDONLY));
 	
@@ -785,6 +805,8 @@ static int ufs_fill_super(struct super_b
 	}
 #endif
 	mutex_init(&sbi->mutex);
+	spin_lock_init(&sbi->work_lock);
+	INIT_DELAYED_WORK(&sbi->sync_work, delayed_sync_fs);
 	/*
 	 * Set default mount options
 	 * Parse mount options
@@ -1304,7 +1326,6 @@ static int ufs_remount (struct super_blo
 			ufs_set_fs_state(sb, usb1, usb3,
 				UFS_FSOK - fs32_to_cpu(sb, usb1->fs_time));
 		ubh_mark_buffer_dirty (USPI_UBH(uspi));
-		sb->s_dirt = 0;
 		sb->s_flags |= MS_RDONLY;
 	} else {
 	/*
@@ -1459,7 +1480,6 @@ static const struct super_operations ufs
 	.write_inode	= ufs_write_inode,
 	.evict_inode	= ufs_evict_inode,
 	.put_super	= ufs_put_super,
-	.write_super	= ufs_write_super,
 	.sync_fs	= ufs_sync_fs,
 	.statfs		= ufs_statfs,
 	.remount_fs	= ufs_remount,
diff -puN fs/ufs/ufs.h~fs-ufs-get-rid-of-write_super fs/ufs/ufs.h
--- a/fs/ufs/ufs.h~fs-ufs-get-rid-of-write_super
+++ a/fs/ufs/ufs.h
@@ -20,6 +20,10 @@ struct ufs_sb_info {
 	unsigned s_mount_opt;
 	struct mutex mutex;
 	struct task_struct *mutex_owner;
+	struct super_block *sb;
+	int work_queued; /* non-zero if the delayed work is queued */
+	struct delayed_work sync_work; /* FS sync delayed work */
+	spinlock_t work_lock; /* protects sync_work and work_queued */
 };
 
 struct ufs_inode_info {
@@ -123,6 +127,7 @@ extern __printf(3, 4)
 void ufs_error(struct super_block *, const char *, const char *, ...);
 extern __printf(3, 4)
 void ufs_panic(struct super_block *, const char *, const char *, ...);
+void ufs_mark_sb_dirty(struct super_block *sb);
 
 /* symlink.c */
 extern const struct inode_operations ufs_fast_symlink_inode_operations;
diff -puN fs/ufs/ufs_fs.h~fs-ufs-get-rid-of-write_super fs/ufs/ufs_fs.h
--- a/fs/ufs/ufs_fs.h~fs-ufs-get-rid-of-write_super
+++ a/fs/ufs/ufs_fs.h
@@ -34,6 +34,7 @@
 #include <linux/kernel.h>
 #include <linux/stat.h>
 #include <linux/fs.h>
+#include <linux/workqueue.h>
 
 #include <asm/div64.h>
 typedef __u64 __bitwise __fs64;
_

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

linux-next.patch

