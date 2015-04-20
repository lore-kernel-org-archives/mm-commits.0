From: akpm@linux-foundation.org
Subject: [merged] fs-hfsplus-atomically-set-inode-i_flags.patch removed
 from -mm tree
Date: Mon, 20 Apr 2015 12:19:08 -0700
Message-ID: <5535512c.aX2J9R3hWs7VSgxt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40316 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbbDTTMr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:12:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/hfsplus: atomically set inode->i_flags
has been removed from the -mm tree.  Its filename was
     fs-hfsplus-atomically-set-inode-i_flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/hfsplus: atomically set inode->i_flags

According to commit 5f16f3225b06 ("ext4: atomically set inode->i_flags in
ext4_set_inode_flags()").

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/ioctl.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN fs/hfsplus/ioctl.c~fs-hfsplus-atomically-set-inode-i_flags fs/hfsplus/ioctl.c
--- a/fs/hfsplus/ioctl.c~fs-hfsplus-atomically-set-inode-i_flags
+++ a/fs/hfsplus/ioctl.c
@@ -76,7 +76,7 @@ static int hfsplus_ioctl_setflags(struct
 {
 	struct inode *inode = file_inode(file);
 	struct hfsplus_inode_info *hip = HFSPLUS_I(inode);
-	unsigned int flags;
+	unsigned int flags, new_fl = 0;
 	int err = 0;
 
 	err = mnt_want_write_file(file);
@@ -110,14 +110,12 @@ static int hfsplus_ioctl_setflags(struct
 	}
 
 	if (flags & FS_IMMUTABLE_FL)
-		inode->i_flags |= S_IMMUTABLE;
-	else
-		inode->i_flags &= ~S_IMMUTABLE;
+		new_fl |= S_IMMUTABLE;
 
 	if (flags & FS_APPEND_FL)
-		inode->i_flags |= S_APPEND;
-	else
-		inode->i_flags &= ~S_APPEND;
+		new_fl |= S_APPEND;
+
+	inode_set_flags(inode, new_fl, S_IMMUTABLE | S_APPEND);
 
 	if (flags & FS_NODUMP_FL)
 		hip->userflags |= HFSPLUS_FLG_NODUMP;
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
linux-next.patch

