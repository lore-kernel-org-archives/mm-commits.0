From: akpm@linux-foundation.org
Subject: + hfsplus-get-rid-of-write_super.patch added to -mm tree
Date: Thu, 21 Jun 2012 12:42:35 -0700
Message-ID: <20120621194235.ECE45A0329@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:39545 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab2FUTmi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 15:42:38 -0400
Received: by eaao13 with SMTP id o13so63352eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 12:42:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: artem.bityutskiy@linux.intel.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: hfsplus: get rid of write_super
has been added to the -mm tree.  Its filename is
     hfsplus-get-rid-of-write_super.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: hfsplus: get rid of write_super

Make hfsplus stop using the VFS '->write_super()' method along with the
's_dirt' superblock flag, because they are on their way out.

The whole "superblock write-out" VFS infrastructure is served by the
'sync_supers()' kernel thread, which wakes up every 5 (by default) seconds
and writes out all dirty superblocks using the '->write_super()' callback.
 But the problem with this thread is that it wastes power by waking up the
system every 5 seconds, even if there are no dirty superblocks, or there
are no client filesystems which would need this (e.g., btrfs does not use
'->write_super()').

So we want to kill the thread completely and thus we need to make
filesystems stop using the '->write_super()' VFS service, and then remove
it together with the kernel thread.

Tested using fsstress from the LTP project.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/bitmap.c     |    4 +--
 fs/hfsplus/dir.c        |    2 -
 fs/hfsplus/hfsplus_fs.h |    6 ++++-
 fs/hfsplus/inode.c      |    6 ++---
 fs/hfsplus/super.c      |   41 ++++++++++++++++++++++++++++++--------
 5 files changed, 44 insertions(+), 15 deletions(-)

diff -puN fs/hfsplus/bitmap.c~hfsplus-get-rid-of-write_super fs/hfsplus/bitmap.c
--- a/fs/hfsplus/bitmap.c~hfsplus-get-rid-of-write_super
+++ a/fs/hfsplus/bitmap.c
@@ -153,7 +153,7 @@ done:
 	kunmap(page);
 	*max = offset + (curr - pptr) * 32 + i - start;
 	sbi->free_blocks -= *max;
-	sb->s_dirt = 1;
+	hfsplus_mark_mdb_dirty(sb);
 	dprint(DBG_BITMAP, "-> %u,%u\n", start, *max);
 out:
 	mutex_unlock(&sbi->alloc_mutex);
@@ -228,7 +228,7 @@ out:
 	set_page_dirty(page);
 	kunmap(page);
 	sbi->free_blocks += len;
-	sb->s_dirt = 1;
+	hfsplus_mark_mdb_dirty(sb);
 	mutex_unlock(&sbi->alloc_mutex);
 
 	return 0;
diff -puN fs/hfsplus/dir.c~hfsplus-get-rid-of-write_super fs/hfsplus/dir.c
--- a/fs/hfsplus/dir.c~hfsplus-get-rid-of-write_super
+++ a/fs/hfsplus/dir.c
@@ -316,7 +316,7 @@ static int hfsplus_link(struct dentry *s
 	inode->i_ctime = CURRENT_TIME_SEC;
 	mark_inode_dirty(inode);
 	sbi->file_count++;
-	dst_dir->i_sb->s_dirt = 1;
+	hfsplus_mark_mdb_dirty(dst_dir->i_sb);
 out:
 	mutex_unlock(&sbi->vh_mutex);
 	return res;
diff -puN fs/hfsplus/hfsplus_fs.h~hfsplus-get-rid-of-write_super fs/hfsplus/hfsplus_fs.h
--- a/fs/hfsplus/hfsplus_fs.h~hfsplus-get-rid-of-write_super
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -153,8 +153,11 @@ struct hfsplus_sb_info {
 	gid_t gid;
 
 	int part, session;
-
 	unsigned long flags;
+
+	int work_queued;               /* non-zero delayed work is queued */
+	struct delayed_work sync_work; /* FS sync delayed work */
+	spinlock_t work_lock;          /* protects sync_work and work_queued */
 };
 
 #define HFSPLUS_SB_WRITEBACKUP	0
@@ -428,6 +431,7 @@ int hfsplus_show_options(struct seq_file
 
 /* super.c */
 struct inode *hfsplus_iget(struct super_block *, unsigned long);
+void hfsplus_mark_mdb_dirty(struct super_block *sb);
 
 /* tables.c */
 extern u16 hfsplus_case_fold_table[];
diff -puN fs/hfsplus/inode.c~hfsplus-get-rid-of-write_super fs/hfsplus/inode.c
--- a/fs/hfsplus/inode.c~hfsplus-get-rid-of-write_super
+++ a/fs/hfsplus/inode.c
@@ -431,7 +431,7 @@ struct inode *hfsplus_new_inode(struct s
 		sbi->file_count++;
 	insert_inode_hash(inode);
 	mark_inode_dirty(inode);
-	sb->s_dirt = 1;
+	hfsplus_mark_mdb_dirty(sb);
 
 	return inode;
 }
@@ -442,7 +442,7 @@ void hfsplus_delete_inode(struct inode *
 
 	if (S_ISDIR(inode->i_mode)) {
 		HFSPLUS_SB(sb)->folder_count--;
-		sb->s_dirt = 1;
+		hfsplus_mark_mdb_dirty(sb);
 		return;
 	}
 	HFSPLUS_SB(sb)->file_count--;
@@ -455,7 +455,7 @@ void hfsplus_delete_inode(struct inode *
 		inode->i_size = 0;
 		hfsplus_file_truncate(inode);
 	}
-	sb->s_dirt = 1;
+	hfsplus_mark_mdb_dirty(sb);
 }
 
 void hfsplus_inode_read_fork(struct inode *inode, struct hfsplus_fork_raw *fork)
diff -puN fs/hfsplus/super.c~hfsplus-get-rid-of-write_super fs/hfsplus/super.c
--- a/fs/hfsplus/super.c~hfsplus-get-rid-of-write_super
+++ a/fs/hfsplus/super.c
@@ -124,7 +124,7 @@ static int hfsplus_system_write_inode(st
 
 	if (fork->total_size != cpu_to_be64(inode->i_size)) {
 		set_bit(HFSPLUS_SB_WRITEBACKUP, &sbi->flags);
-		inode->i_sb->s_dirt = 1;
+		hfsplus_mark_mdb_dirty(inode->i_sb);
 	}
 	hfsplus_inode_write_fork(inode, fork);
 	if (tree)
@@ -173,7 +173,7 @@ static int hfsplus_sync_fs(struct super_
 
 	dprint(DBG_SUPER, "hfsplus_sync_fs\n");
 
-	sb->s_dirt = 0;
+	cancel_delayed_work(&sbi->sync_work);
 
 	/*
 	 * Explicitly write out the special metadata inodes.
@@ -226,12 +226,34 @@ out:
 	return error;
 }
 
-static void hfsplus_write_super(struct super_block *sb)
+static void delayed_sync_fs(struct work_struct *work)
 {
-	if (!(sb->s_flags & MS_RDONLY))
-		hfsplus_sync_fs(sb, 1);
-	else
-		sb->s_dirt = 0;
+	struct hfsplus_sb_info *sbi;
+
+	sbi = container_of(work, struct hfsplus_sb_info, sync_work.work);
+
+	spin_lock(&sbi->work_lock);
+	sbi->work_queued = 0;
+	spin_unlock(&sbi->work_lock);
+
+	hfsplus_sync_fs(sbi->alloc_file->i_sb, 1);
+}
+
+void hfsplus_mark_mdb_dirty(struct super_block *sb)
+{
+	struct hfsplus_sb_info *sbi = HFSPLUS_SB(sb);
+	unsigned long delay;
+
+	if (sb->s_flags & MS_RDONLY)
+	       return;
+
+	spin_lock(&sbi->work_lock);
+	if (!sbi->work_queued) {
+	       delay = msecs_to_jiffies(dirty_writeback_interval * 10);
+	       queue_delayed_work(system_long_wq, &sbi->sync_work, delay);
+	       sbi->work_queued = 1;
+	}
+	spin_unlock(&sbi->work_lock);
 }
 
 static void hfsplus_put_super(struct super_block *sb)
@@ -240,6 +262,8 @@ static void hfsplus_put_super(struct sup
 
 	dprint(DBG_SUPER, "hfsplus_put_super\n");
 
+	cancel_delayed_work_sync(&sbi->sync_work);
+
 	if (!(sb->s_flags & MS_RDONLY) && sbi->s_vhdr) {
 		struct hfsplus_vh *vhdr = sbi->s_vhdr;
 
@@ -325,7 +349,6 @@ static const struct super_operations hfs
 	.write_inode	= hfsplus_write_inode,
 	.evict_inode	= hfsplus_evict_inode,
 	.put_super	= hfsplus_put_super,
-	.write_super	= hfsplus_write_super,
 	.sync_fs	= hfsplus_sync_fs,
 	.statfs		= hfsplus_statfs,
 	.remount_fs	= hfsplus_remount,
@@ -352,6 +375,8 @@ static int hfsplus_fill_super(struct sup
 	sb->s_fs_info = sbi;
 	mutex_init(&sbi->alloc_mutex);
 	mutex_init(&sbi->vh_mutex);
+	spin_lock_init(&sbi->work_lock);
+	INIT_DELAYED_WORK(&sbi->sync_work, delayed_sync_fs);
 	hfsplus_fill_defaults(sbi);
 
 	err = -EINVAL;
_
Subject: Subject: hfsplus: get rid of write_super

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

linux-next.patch
hfs-push-lock_super-down.patch
hfs-get-rid-of-lock_super.patch
hfs-remove-extra-mdb-write-on-unmount.patch
hfs-simplify-a-bit-checking-for-r-o.patch
hfs-introduce-vfs-superblock-object-back-reference.patch
hfs-get-rid-of-hfs_sync_super.patch
hfs-get-rid-of-hfs_sync_super-checkpatch-fixes.patch
hfsplus-make-hfsplus_sync_fs-static.patch
hfsplus-amend-debugging-print.patch
hfsplus-remove-useless-check.patch
hfsplus-get-rid-of-write_super.patch

