From: akpm@linux-foundation.org
Subject: + hfs-get-rid-of-lock_super.patch added to -mm tree
Date: Wed, 13 Jun 2012 15:36:03 -0700
Message-ID: <20120613223603.E2BBBA0137@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:63685 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab2FMWgF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 18:36:05 -0400
Received: by qabg24 with SMTP id g24so211005qab.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 15:36:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: artem.bityutskiy@linux.intel.com, hch@lst.de, jack@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     Subject: hfs: get rid of lock_super
has been added to the -mm tree.  Its filename is
     hfs-get-rid-of-lock_super.patch

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
Subject: Subject: hfs: get rid of lock_super

Patches currently in -mm which might be from artem.bityutskiy@linux.intel.com are

linux-next.patch
hfs-push-lock_super-down.patch
hfs-get-rid-of-lock_super.patch
hfs-remove-extra-mdb-write-on-unmount.patch
hfs-simplify-a-bit-checking-for-r-o.patch
hfs-introduce-vfs-superblock-object-back-reference.patch
hfs-get-rid-of-hfs_sync_super.patch

