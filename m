From: akpm@linux-foundation.org
Subject: [merged] hfs-push-lock_super-down.patch removed from -mm tree
Date: Tue, 17 Jul 2012 13:04:19 -0700
Message-ID: <20120717200420.32C325C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:48048 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542Ab2GQUEW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jul 2012 16:04:22 -0400
Received: by mail-fa0-f74.google.com with SMTP id 25so47388fat.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jul 2012 13:04:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: artem.bityutskiy@linux.intel.com, hch@lst.de, jack@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfs: push lock_super down
has been removed from the -mm tree.  Its filename was
     hfs-push-lock_super-down.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: hfs: push lock_super down

This patchset makes the HFS file-system stop using the VFS
'->write_supers()' call-back and the '->s_dirt' superblock field because I
plan to remove them once all users are gone.

Like the other similar patchsets, we switch to a delayed job for writing
out the superblock instead of using the 's_dirt' flag.  Additionally, this
patchset includes several cleanups.

Reminder:

The goal is to get rid of the 'sync_supers()' kernel thread.  This kernel
thread wakes up every 5 seconds (by default) and calls '->write_super()'
for all mounted file-systems.  And the bad thing is that this is done even
if all the superblocks are clean.  Moreover, many file-systems do not even
need this end they do not register the '->write_super()' method at all
(e.g., btrfs).

So 'sync_supers()' most often just generates useless wake-ups and wastes
power.  I am trying to make all file-systems independent of
'->write_super()' and plan to remove 'sync_supers()' and '->write_super()'
completely once there are no more users.

Tested using the fsstress test from the LTP project.


This patch:

HFS uses 'lock_super()'/'unlock_super()' around 'hfs_mdb_commit()' in
order to serialize MDB (Master Directory Block) changes.  Push it down to
'hfs_mdb_commit()' in order to simplify the code a bit.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/inode.c |    2 --
 fs/hfs/mdb.c   |    2 ++
 fs/hfs/super.c |    4 ----
 3 files changed, 2 insertions(+), 6 deletions(-)

diff -puN fs/hfs/inode.c~hfs-push-lock_super-down fs/hfs/inode.c
--- a/fs/hfs/inode.c~hfs-push-lock_super-down
+++ a/fs/hfs/inode.c
@@ -645,11 +645,9 @@ static int hfs_file_fsync(struct file *f
 	/* sync the superblock to buffers */
 	sb = inode->i_sb;
 	if (sb->s_dirt) {
-		lock_super(sb);
 		sb->s_dirt = 0;
 		if (!(sb->s_flags & MS_RDONLY))
 			hfs_mdb_commit(sb);
-		unlock_super(sb);
 	}
 	/* .. finally sync the buffers to disk */
 	err = sync_blockdev(sb->s_bdev);
diff -puN fs/hfs/mdb.c~hfs-push-lock_super-down fs/hfs/mdb.c
--- a/fs/hfs/mdb.c~hfs-push-lock_super-down
+++ a/fs/hfs/mdb.c
@@ -260,6 +260,7 @@ void hfs_mdb_commit(struct super_block *
 {
 	struct hfs_mdb *mdb = HFS_SB(sb)->mdb;
 
+	lock_super(sb);
 	if (test_and_clear_bit(HFS_FLG_MDB_DIRTY, &HFS_SB(sb)->flags)) {
 		/* These parameters may have been modified, so write them back */
 		mdb->drLsMod = hfs_mtime();
@@ -317,6 +318,7 @@ void hfs_mdb_commit(struct super_block *
 			size -= len;
 		}
 	}
+	unlock_super(sb);
 }
 
 void hfs_mdb_close(struct super_block *sb)
diff -puN fs/hfs/super.c~hfs-push-lock_super-down fs/hfs/super.c
--- a/fs/hfs/super.c~hfs-push-lock_super-down
+++ a/fs/hfs/super.c
@@ -50,21 +50,17 @@ MODULE_LICENSE("GPL");
  */
 static void hfs_write_super(struct super_block *sb)
 {
-	lock_super(sb);
 	sb->s_dirt = 0;
 
 	/* sync everything to the buffers */
 	if (!(sb->s_flags & MS_RDONLY))
 		hfs_mdb_commit(sb);
-	unlock_super(sb);
 }
 
 static int hfs_sync_fs(struct super_block *sb, int wait)
 {
-	lock_super(sb);
 	hfs_mdb_commit(sb);
 	sb->s_dirt = 0;
-	unlock_super(sb);
 
 	return 0;
 }
_

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

linux-next.patch

