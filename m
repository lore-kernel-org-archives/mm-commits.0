From: akpm@linux-foundation.org
Subject: + ext4-check-for-return-value-from-sb_set_blocksize.patch added to -mm tree
Date: Wed, 09 Jan 2008 21:21:45 -0800
Message-ID: <200801100521.m0A5LPBS006580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43307 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878AbYAJFVc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 00:21:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com


The patch titled
     ext4: check for return value from sb_set_blocksize
has been added to the -mm tree.  Its filename is
     ext4-check-for-return-value-from-sb_set_blocksize.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: check for return value from sb_set_blocksize
From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

sb_set_blocksize validates whether the specfied block size can be used by
the file system.  Make sure we fail mounting the file system if the
blocksize specfied cannot be used.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN fs/ext4/super.c~ext4-check-for-return-value-from-sb_set_blocksize fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-check-for-return-value-from-sb_set_blocksize
+++ a/fs/ext4/super.c
@@ -1793,7 +1793,6 @@ static int ext4_fill_super (struct super
 	unsigned long def_mount_opts;
 	struct inode *root;
 	int blocksize;
-	int hblock;
 	int db_count;
 	int i;
 	int needs_recovery;
@@ -1947,20 +1946,16 @@ static int ext4_fill_super (struct super
 		goto failed_mount;
 	}
 
-	hblock = bdev_hardsect_size(sb->s_bdev);
 	if (sb->s_blocksize != blocksize) {
-		/*
-		 * Make sure the blocksize for the filesystem is larger
-		 * than the hardware sectorsize for the machine.
-		 */
-		if (blocksize < hblock) {
-			printk(KERN_ERR "EXT4-fs: blocksize %d too small for "
-			       "device blocksize %d.\n", blocksize, hblock);
+
+		/* Validate the filesystem blocksize */
+		if (!sb_set_blocksize(sb, blocksize)) {
+			printk(KERN_ERR "EXT4-fs: bad block size %d.\n",
+					blocksize);
 			goto failed_mount;
 		}
 
 		brelse (bh);
-		sb_set_blocksize(sb, blocksize);
 		logical_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
 		offset = do_div(logical_sb_block, blocksize);
 		bh = sb_bread(sb, logical_sb_block);
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

ext2-return-after-ext2_error-in-case-of-failures.patch
ext2-change-the-default-behaviour-on-error.patch
add-buffer-head-related-helper-functions.patch
ext2-add-block-bitmap-validation.patch
ext3-add-block-bitmap-validation.patch
ext4-check-for-return-value-from-sb_set_blocksize.patch
ext3-return-after-ext3_error-in-case-of-failures.patch
ext3-change-the-default-behaviour-on-error.patch
