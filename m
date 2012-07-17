From: akpm@linux-foundation.org
Subject: [merged] hfs-get-rid-of-lock_super.patch removed from -mm tree
Date: Tue, 17 Jul 2012 13:04:23 -0700
Message-ID: <20120717200423.B8AC01E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:65360 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594Ab2GQUEY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jul 2012 16:04:24 -0400
Received: by yenl3 with SMTP id l3so81417yen.1
        for <mm-commits@vger.kernel.org>; Tue, 17 Jul 2012 13:04:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: artem.bityutskiy@linux.intel.com, hch@lst.de, jack@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: hfs: get rid of lock_super
has been removed from the -mm tree.  Its filename was
     hfs-get-rid-of-lock_super.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: hfs: get rid of lock_super

Stop using lock_super for serializing the MDB changes - use the
buffer-head own lock instead.  Tested with fsstress.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/mdb.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN fs/hfs/mdb.c~hfs-get-rid-of-lock_super fs/hfs/mdb.c
--- a/fs/hfs/mdb.c~hfs-get-rid-of-lock_super
+++ a/fs/hfs/mdb.c
@@ -260,7 +260,7 @@ void hfs_mdb_commit(struct super_block *
 {
 	struct hfs_mdb *mdb = HFS_SB(sb)->mdb;
 
-	lock_super(sb);
+	lock_buffer(HFS_SB(sb)->mdb_bh);
 	if (test_and_clear_bit(HFS_FLG_MDB_DIRTY, &HFS_SB(sb)->flags)) {
 		/* These parameters may have been modified, so write them back */
 		mdb->drLsMod = hfs_mtime();
@@ -284,9 +284,13 @@ void hfs_mdb_commit(struct super_block *
 				     &mdb->drXTFlSize, NULL);
 		hfs_inode_write_fork(HFS_SB(sb)->cat_tree->inode, mdb->drCTExtRec,
 				     &mdb->drCTFlSize, NULL);
+
+		lock_buffer(HFS_SB(sb)->alt_mdb_bh);
 		memcpy(HFS_SB(sb)->alt_mdb, HFS_SB(sb)->mdb, HFS_SECTOR_SIZE);
 		HFS_SB(sb)->alt_mdb->drAtrb |= cpu_to_be16(HFS_SB_ATTRIB_UNMNT);
 		HFS_SB(sb)->alt_mdb->drAtrb &= cpu_to_be16(~HFS_SB_ATTRIB_INCNSTNT);
+		unlock_buffer(HFS_SB(sb)->alt_mdb_bh);
+
 		mark_buffer_dirty(HFS_SB(sb)->alt_mdb_bh);
 		sync_dirty_buffer(HFS_SB(sb)->alt_mdb_bh);
 	}
@@ -309,7 +313,11 @@ void hfs_mdb_commit(struct super_block *
 				break;
 			}
 			len = min((int)sb->s_blocksize - off, size);
+
+			lock_buffer(bh);
 			memcpy(bh->b_data + off, ptr, len);
+			unlock_buffer(bh);
+
 			mark_buffer_dirty(bh);
 			brelse(bh);
 			block++;
@@ -318,7 +326,7 @@ void hfs_mdb_commit(struct super_block *
 			size -= len;
 		}
 	}
-	unlock_super(sb);
+	unlock_buffer(HFS_SB(sb)->mdb_bh);
 }
 
 void hfs_mdb_close(struct super_block *sb)
_

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

linux-next.patch

