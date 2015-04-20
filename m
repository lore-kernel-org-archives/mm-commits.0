From: akpm@linux-foundation.org
Subject: [merged]
 nilfs2-use-inode_set_flags-in-nilfs_set_inode_flags.patch removed from -mm
 tree
Date: Mon, 20 Apr 2015 12:18:57 -0700
Message-ID: <55355121.tUhPxWJMBoNtOmMP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40301 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbbDTTMg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:12:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: use inode_set_flags() in nilfs_set_inode_flags()
has been removed from the -mm tree.  Its filename was
     nilfs2-use-inode_set_flags-in-nilfs_set_inode_flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

