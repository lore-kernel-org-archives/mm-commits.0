From: akpm@linux-foundation.org
Subject: + nilfs2-use-inode_set_flags-in-nilfs_set_inode_flags.patch added to -mm tree
Date: Wed, 08 Apr 2015 16:09:52 -0700
Message-ID: <5525b540.gsYj5CIghYkkW1Ww%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794AbbDHXJx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Apr 2015 19:09:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: use inode_set_flags() in nilfs_set_inode_flags()
has been added to the -mm tree.  Its filename is
     nilfs2-use-inode_set_flags-in-nilfs_set_inode_flags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-use-inode_set_flags-in-nilfs_set_inode_flags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-use-inode_set_flags-in-nilfs_set_inode_flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: use inode_set_flags() in nilfs_set_inode_flags()

Use inode_set_flags() to atomically set i_flags instead of clearing out
the S_IMMUTABLE, S_APPEND, etc.  flags and then setting them from the
FS_IMMUTABLE_FL, FS_APPEND_FL flags to avoid a race where an immutable
file has the immutable flag cleared for a brief window of time.

This is a similar fix to commit 5f16f3225b06 ("ext4: atomically set
inode->i_flags in ext4_set_inode_flags()").

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN fs/nilfs2/inode.c~nilfs2-use-inode_set_flags-in-nilfs_set_inode_flags fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~nilfs2-use-inode_set_flags-in-nilfs_set_inode_flags
+++ a/fs/nilfs2/inode.c
@@ -443,19 +443,20 @@ struct inode *nilfs_new_inode(struct ino
 void nilfs_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = NILFS_I(inode)->i_flags;
+	unsigned int new_fl = 0;
 
-	inode->i_flags &= ~(S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME |
-			    S_DIRSYNC);
 	if (flags & FS_SYNC_FL)
-		inode->i_flags |= S_SYNC;
+		new_fl |= S_SYNC;
 	if (flags & FS_APPEND_FL)
-		inode->i_flags |= S_APPEND;
+		new_fl |= S_APPEND;
 	if (flags & FS_IMMUTABLE_FL)
-		inode->i_flags |= S_IMMUTABLE;
+		new_fl |= S_IMMUTABLE;
 	if (flags & FS_NOATIME_FL)
-		inode->i_flags |= S_NOATIME;
+		new_fl |= S_NOATIME;
 	if (flags & FS_DIRSYNC_FL)
-		inode->i_flags |= S_DIRSYNC;
+		new_fl |= S_DIRSYNC;
+	inode_set_flags(inode, new_fl, S_SYNC | S_APPEND | S_IMMUTABLE |
+			S_NOATIME | S_DIRSYNC);
 }
 
 int nilfs_read_inode_common(struct inode *inode,
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-do-not-use-async-write-flag-for-segment-summary-buffers.patch
nilfs2-use-set_mask_bits-for-operations-on-buffer-state-bitmap.patch
nilfs2-use-bgl_lock_ptr.patch
nilfs2-unify-type-of-key-arguments-in-bmap-interface.patch
nilfs2-add-bmap-function-to-seek-a-valid-key.patch
nilfs2-add-bmap-function-to-seek-a-valid-key-fix.patch
nilfs2-add-helper-to-find-existent-block-on-metadata-file.patch
nilfs2-improve-execution-time-of-nilfs_ioctl_get_cpinfo-ioctl.patch
nilfs2-fix-gcc-warning-at-nilfs_checkpoint_is_mounted.patch
nilfs2-put-out-gfp-mask-manipulation-from-nilfs_set_inode_flags.patch
nilfs2-use-inode_set_flags-in-nilfs_set_inode_flags.patch

