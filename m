From: akpm@linux-foundation.org
Subject: [merged] hfs-simplify-a-bit-checking-for-r-o.patch removed from -mm tree
Date: Tue, 17 Jul 2012 13:04:29 -0700
Message-ID: <20120717200429.BA12B1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:61738 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585Ab2GQUEb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jul 2012 16:04:31 -0400
Received: by qabg24 with SMTP id g24so87559qab.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jul 2012 13:04:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: artem.bityutskiy@linux.intel.com, hch@lst.de, jack@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfs: simplify a bit checking for R/O
has been removed from the -mm tree.  Its filename was
     hfs-simplify-a-bit-checking-for-r-o.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

linux-next.patch

