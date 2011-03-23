From: akpm@linux-foundation.org
Subject: [merged] fsh-remove-8-bytes-of-padding-from-block_device-on-64bit-builds.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:38:34 -0700
Message-ID: <201103232042.p2NKgABQ028728@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933519Ab1CWUza (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@rsk.demon.co.uk, axboe@kernel.dk, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs.h: remove 8 bytes of padding from block_device on 64bit builds
has been removed from the -mm tree.  Its filename was
     fsh-remove-8-bytes-of-padding-from-block_device-on-64bit-builds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs.h: remove 8 bytes of padding from block_device on 64bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>

Re-ordering struct block_inode to remove 8 bytes of padding on 64 bit
builds, which also shrinks bdev_inode by 8 bytes (776 -> 768) allowing it
to fit into one fewer cache lines.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/fs.h~fsh-remove-8-bytes-of-padding-from-block_device-on-64bit-builds include/linux/fs.h
--- a/include/linux/fs.h~fsh-remove-8-bytes-of-padding-from-block_device-on-64bit-builds
+++ a/include/linux/fs.h
@@ -662,9 +662,9 @@ struct address_space {
 
 struct block_device {
 	dev_t			bd_dev;  /* not a kdev_t - it's a search key */
+	int			bd_openers;
 	struct inode *		bd_inode;	/* will die */
 	struct super_block *	bd_super;
-	int			bd_openers;
 	struct mutex		bd_mutex;	/* open/close mutex */
 	struct list_head	bd_inodes;
 	void *			bd_claiming;
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

origin.patch
linux-next.patch

