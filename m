From: akpm@linux-foundation.org
Subject: + ext3-avoid-printk-floods-in-the-face-of-directory-corruption.patch added to -mm tree
Date: Wed, 17 Sep 2008 12:31:04 -0700
Message-ID: <200809171931.m8HJV479026869@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36749 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752830AbYIQTb4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 15:31:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com, eugeneteo@kernel.sg, tytso@mit.edu


The patch titled
     ext3: avoid printk floods in the face of directory corruption
has been added to the -mm tree.  Its filename is
     ext3-avoid-printk-floods-in-the-face-of-directory-corruption.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: avoid printk floods in the face of directory corruption
From: Eric Sandeen <sandeen@redhat.com>

Note: some people thinks this represents a security bug, since it might
make the system go away while it is printing a large number of console
messages, especially if a serial console is involved.  Hence, it has been
assigned CVE-2008-3528, but it requires that the attacker either has
physical access to your machine to insert a USB disk with a corrupted
filesystem image (at which point why not just hit the power button), or is
otherwise able to convince the system administrator to mount an arbitrary
filesystem image (at which point why not just include a setuid shell or
world-writable hard disk device file or some such).  Me, I think they're
just being silly.

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

linux-next.patch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption.patch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption-checkpatch-fixes.patch
jbd-test-bh_write_eio-to-detect-errors-on-metadata-buffers.patch
ext3-avoid-printk-floods-in-the-face-of-directory-corruption.patch

