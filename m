From: akpm@linux-foundation.org
Subject: + hfs-simplify-a-bit-checking-for-r-o.patch added to -mm tree
Date: Wed, 13 Jun 2012 15:36:07 -0700
Message-ID: <20120613223607.EBE2FA0137@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:60854 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab2FMWgI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 18:36:08 -0400
Received: by ghbz15 with SMTP id z15so100492ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 15:36:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: artem.bityutskiy@linux.intel.com, hch@lst.de, jack@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     Subject: hfs: simplify a bit checking for R/O
has been added to the -mm tree.  Its filename is
     hfs-simplify-a-bit-checking-for-r-o.patch

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
Subject: hfs: simplify a bit checking for R/O

We have the following pattern in 2 places in HFS

if (!RDONLY)
	hfs_mdb_commit();

This patch pushes the RDONLY check down to 'hfs_mdb_commit()'. This will
make the following patches a bit simpler.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/inode.c |    3 +--
 fs/hfs/mdb.c   |    3 +++
 fs/hfs/super.c |    3 +--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff -puN fs/hfs/inode.c~hfs-simplify-a-bit-checking-for-r-o fs/hfs/inode.c
--- a/fs/hfs/inode.c~hfs-simplify-a-bit-checking-for-r-o
+++ a/fs/hfs/inode.c
@@ -646,8 +646,7 @@ static int hfs_file_fsync(struct file *f
 	sb = inode->i_sb;
 	if (sb->s_dirt) {
 		sb->s_dirt = 0;
-		if (!(sb->s_flags & MS_RDONLY))
-			hfs_mdb_commit(sb);
+		hfs_mdb_commit(sb);
 	}
 	/* .. finally sync the buffers to disk */
 	err = sync_blockdev(sb->s_bdev);
diff -puN fs/hfs/mdb.c~hfs-simplify-a-bit-checking-for-r-o fs/hfs/mdb.c
--- a/fs/hfs/mdb.c~hfs-simplify-a-bit-checking-for-r-o
+++ a/fs/hfs/mdb.c
@@ -260,6 +260,9 @@ void hfs_mdb_commit(struct super_block *
 {
 	struct hfs_mdb *mdb = HFS_SB(sb)->mdb;
 
+	if (sb->s_flags & MS_RDONLY)
+		return;
+
 	lock_buffer(HFS_SB(sb)->mdb_bh);
 	if (test_and_clear_bit(HFS_FLG_MDB_DIRTY, &HFS_SB(sb)->flags)) {
 		/* These parameters may have been modified, so write them back */
diff -puN fs/hfs/super.c~hfs-simplify-a-bit-checking-for-r-o fs/hfs/super.c
--- a/fs/hfs/super.c~hfs-simplify-a-bit-checking-for-r-o
+++ a/fs/hfs/super.c
@@ -53,8 +53,7 @@ static void hfs_write_super(struct super
 	sb->s_dirt = 0;
 
 	/* sync everything to the buffers */
-	if (!(sb->s_flags & MS_RDONLY))
-		hfs_mdb_commit(sb);
+	hfs_mdb_commit(sb);
 }
 
 static int hfs_sync_fs(struct super_block *sb, int wait)
_
Subject: Subject: hfs: simplify a bit checking for R/O

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

linux-next.patch
hfs-push-lock_super-down.patch
hfs-get-rid-of-lock_super.patch
hfs-remove-extra-mdb-write-on-unmount.patch
hfs-simplify-a-bit-checking-for-r-o.patch
hfs-introduce-vfs-superblock-object-back-reference.patch
hfs-get-rid-of-hfs_sync_super.patch

