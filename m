From: akpm@linux-foundation.org
Subject: - reiserfs-use-open_bdev_excl.patch removed from -mm tree
Date: Thu, 01 May 2008 02:32:18 -0700
Message-ID: <200805010932.m419WI3j030974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757828AbYEAJcl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:32:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, chris.mason@oracle.com, edward.shishkin@gmail.com, jeffm@suse.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: use open_bdev_excl
has been removed from the -mm tree.  Its filename was
     reiserfs-use-open_bdev_excl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: use open_bdev_excl
From: Christoph Hellwig <hch@lst.de>

Use the proper helper to open a blockdevice by name for filesystem use,
this makes sure it's properly claimed (also added for open-by-number) and
gets rid of the struct file abuse.

Tested by mounting a reiserfs filesystem with external journal.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Acked-by: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/journal.c          |   50 ++++++++++++++-----------------
 include/linux/reiserfs_fs_sb.h |    1 
 2 files changed, 23 insertions(+), 28 deletions(-)

diff -puN fs/reiserfs/journal.c~reiserfs-use-open_bdev_excl fs/reiserfs/journal.c
--- a/fs/reiserfs/journal.c~reiserfs-use-open_bdev_excl
+++ a/fs/reiserfs/journal.c
@@ -2574,11 +2574,9 @@ static int release_journal_dev(struct su
 
 	result = 0;
 
-	if (journal->j_dev_file != NULL) {
-		result = filp_close(journal->j_dev_file, NULL);
-		journal->j_dev_file = NULL;
-		journal->j_dev_bd = NULL;
-	} else if (journal->j_dev_bd != NULL) {
+	if (journal->j_dev_bd != NULL) {
+		if (journal->j_dev_bd->bd_dev != super->s_dev)
+			bd_release(journal->j_dev_bd);
 		result = blkdev_put(journal->j_dev_bd);
 		journal->j_dev_bd = NULL;
 	}
@@ -2603,7 +2601,6 @@ static int journal_init_dev(struct super
 	result = 0;
 
 	journal->j_dev_bd = NULL;
-	journal->j_dev_file = NULL;
 	jdev = SB_ONDISK_JOURNAL_DEVICE(super) ?
 	    new_decode_dev(SB_ONDISK_JOURNAL_DEVICE(super)) : super->s_dev;
 
@@ -2620,35 +2617,34 @@ static int journal_init_dev(struct super
 					 "cannot init journal device '%s': %i",
 					 __bdevname(jdev, b), result);
 			return result;
-		} else if (jdev != super->s_dev)
+		} else if (jdev != super->s_dev) {
+			result = bd_claim(journal->j_dev_bd, journal);
+			if (result) {
+				blkdev_put(journal->j_dev_bd);
+				return result;
+			}
+
 			set_blocksize(journal->j_dev_bd, super->s_blocksize);
+		}
+
 		return 0;
 	}
 
-	journal->j_dev_file = filp_open(jdev_name, 0, 0);
-	if (!IS_ERR(journal->j_dev_file)) {
-		struct inode *jdev_inode = journal->j_dev_file->f_mapping->host;
-		if (!S_ISBLK(jdev_inode->i_mode)) {
-			reiserfs_warning(super, "journal_init_dev: '%s' is "
-					 "not a block device", jdev_name);
-			result = -ENOTBLK;
-			release_journal_dev(super, journal);
-		} else {
-			/* ok */
-			journal->j_dev_bd = I_BDEV(jdev_inode);
-			set_blocksize(journal->j_dev_bd, super->s_blocksize);
-			reiserfs_info(super,
-				      "journal_init_dev: journal device: %s\n",
-				      bdevname(journal->j_dev_bd, b));
-		}
-	} else {
-		result = PTR_ERR(journal->j_dev_file);
-		journal->j_dev_file = NULL;
+	journal->j_dev_bd = open_bdev_excl(jdev_name, 0, journal);
+	if (IS_ERR(journal->j_dev_bd)) {
+		result = PTR_ERR(journal->j_dev_bd);
+		journal->j_dev_bd = NULL;
 		reiserfs_warning(super,
 				 "journal_init_dev: Cannot open '%s': %i",
 				 jdev_name, result);
+		return result;
 	}
-	return result;
+
+	set_blocksize(journal->j_dev_bd, super->s_blocksize);
+	reiserfs_info(super,
+		      "journal_init_dev: journal device: %s\n",
+		      bdevname(journal->j_dev_bd, b));
+	return 0;
 }
 
 /**
diff -puN include/linux/reiserfs_fs_sb.h~reiserfs-use-open_bdev_excl include/linux/reiserfs_fs_sb.h
--- a/include/linux/reiserfs_fs_sb.h~reiserfs-use-open_bdev_excl
+++ a/include/linux/reiserfs_fs_sb.h
@@ -177,7 +177,6 @@ struct reiserfs_journal {
 	struct reiserfs_journal_cnode *j_last;	/* newest journal block */
 	struct reiserfs_journal_cnode *j_first;	/*  oldest journal block.  start here for traverse */
 
-	struct file *j_dev_file;
 	struct block_device *j_dev_bd;
 	int j_1st_reserved_block;	/* first block on s_dev of reserved area journal */
 
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
git-cifs.patch
git-unionfs.patch
git-xfs.patch
affs-fix-reservation-discarding.patch
vfs-kill-put_inode.patch

