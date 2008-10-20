From: akpm@linux-foundation.org
Subject: - ext3-avoid-printk-floods-in-the-face-of-directory-corruption.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:36:06 -0700
Message-ID: <200810202036.m9KKa6En011304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753410AbYJTUiL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:38:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, eugeneteo@kernel.sg, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     ext3: avoid printk floods in the face of directory corruption
has been removed from the -mm tree.  Its filename was
     ext3-avoid-printk-floods-in-the-face-of-directory-corruption.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: avoid printk floods in the face of directory corruption
From: Eric Sandeen <sandeen@redhat.com>

A very large directory with many read failures (either due to storage
problems, or due to invalid size & blocks from corruption) will generate a
printk storm as the filesystem continues to try to read all the blocks. 
This flood of messages can tie up the box until it is complete - which may
be a very long time, especially for very large corrupted values.

This is fixed by only reporting the corruption once each time we try to
read the directory.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/dir.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN fs/ext3/dir.c~ext3-avoid-printk-floods-in-the-face-of-directory-corruption fs/ext3/dir.c
--- a/fs/ext3/dir.c~ext3-avoid-printk-floods-in-the-face-of-directory-corruption
+++ a/fs/ext3/dir.c
@@ -102,6 +102,7 @@ static int ext3_readdir(struct file * fi
 	int err;
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	int ret = 0;
+	int dir_has_error = 0;
 
 	sb = inode->i_sb;
 
@@ -148,9 +149,12 @@ static int ext3_readdir(struct file * fi
 		 * of recovering data when there's a bad sector
 		 */
 		if (!bh) {
-			ext3_error (sb, "ext3_readdir",
-				"directory #%lu contains a hole at offset %lu",
-				inode->i_ino, (unsigned long)filp->f_pos);
+			if (!dir_has_error) {
+				ext3_error(sb, __func__, "directory #%lu "
+					"contains a hole at offset %lld",
+					inode->i_ino, filp->f_pos);
+				dir_has_error = 1;
+			}
 			/* corrupt size?  Maybe no more blocks to read */
 			if (filp->f_pos > inode->i_blocks << 9)
 				break;
_

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch
linux-next.patch
jbd-test-bh_write_eio-to-detect-errors-on-metadata-buffers.patch

