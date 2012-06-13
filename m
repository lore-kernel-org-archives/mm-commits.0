From: akpm@linux-foundation.org
Subject: + hfs-push-lock_super-down.patch added to -mm tree
Date: Wed, 13 Jun 2012 15:36:00 -0700
Message-ID: <20120613223601.894BCA0137@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:65023 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab2FMWgE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 18:36:04 -0400
Received: by wgbdt11 with SMTP id dt11so63073wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 15:36:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: artem.bityutskiy@linux.intel.com, hch@lst.de, jack@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     Subject: hfs: push lock_super down
has been added to the -mm tree.  Its filename is
     hfs-push-lock_super-down.patch

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
Subject: Subject: hfs: push lock_super down

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

linux-next.patch
hfs-push-lock_super-down.patch
hfs-get-rid-of-lock_super.patch
hfs-remove-extra-mdb-write-on-unmount.patch
hfs-simplify-a-bit-checking-for-r-o.patch
hfs-introduce-vfs-superblock-object-back-reference.patch
hfs-get-rid-of-hfs_sync_super.patch

