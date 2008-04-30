From: akpm@linux-foundation.org
Subject: - vfs-fix-unconditional-write_super-call-in-file_fsync.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:41:32 -0700
Message-ID: <200804300541.m3U5fW9w029062@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753390AbYD3FmM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:42:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: fix unconditional write_super() call in file_fsync()
has been removed from the -mm tree.  Its filename was
     vfs-fix-unconditional-write_super-call-in-file_fsync.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: fix unconditional write_super() call in file_fsync()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

We need to check ->s_dirt before calling write_super().  It became the cause
of an unneeded write.

This bug was noticed by Sudhanshu Saxena.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/sync.c~vfs-fix-unconditional-write_super-call-in-file_fsync fs/sync.c
--- a/fs/sync.c~vfs-fix-unconditional-write_super-call-in-file_fsync
+++ a/fs/sync.c
@@ -64,7 +64,7 @@ int file_fsync(struct file *filp, struct
 	/* sync the superblock to buffers */
 	sb = inode->i_sb;
 	lock_super(sb);
-	if (sb->s_op->write_super)
+	if (sb->s_dirt && sb->s_op->write_super)
 		sb->s_op->write_super(sb);
 	unlock_super(sb);
 
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

origin.patch

