From: akpm@linux-foundation.org
Subject: [merged] qnx4fs-remove-remains-of-the-defunct-write-support.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:41:23 -0800
Message-ID: <200912162041.nBGKfNDn013737@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965039AbZLPUlh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:41:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: al@alarsen.net, hch@lst.de, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     qnx4fs: remove remains of the (defunct) write support
has been removed from the -mm tree.  Its filename was
     qnx4fs-remove-remains-of-the-defunct-write-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: qnx4fs: remove remains of the (defunct) write support
From: Anders Larsen <al@alarsen.net>

commit 945ffe54bbd56ceed62de3b908800fd7c6ffb284 ("qnx4: remove write support") removed the (defunct)
write support but missed a chunk of related, dead code.

Signed-off-by: Anders Larsen <al@alarsen.net>
Cc: Jiri Kosina <jkosina@suse.cz>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/qnx4/bitmap.c |    7 -------
 fs/qnx4/inode.c  |   22 +---------------------
 2 files changed, 1 insertion(+), 28 deletions(-)

diff -puN fs/qnx4/bitmap.c~qnx4fs-remove-remains-of-the-defunct-write-support fs/qnx4/bitmap.c
--- a/fs/qnx4/bitmap.c~qnx4fs-remove-remains-of-the-defunct-write-support
+++ a/fs/qnx4/bitmap.c
@@ -17,13 +17,6 @@
 #include <linux/bitops.h>
 #include "qnx4.h"
 
-#if 0
-int qnx4_new_block(struct super_block *sb)
-{
-	return 0;
-}
-#endif  /*  0  */
-
 static void count_bits(register const char *bmPart, register int size,
 		       int *const tf)
 {
diff -puN fs/qnx4/inode.c~qnx4fs-remove-remains-of-the-defunct-write-support fs/qnx4/inode.c
--- a/fs/qnx4/inode.c~qnx4fs-remove-remains-of-the-defunct-write-support
+++ a/fs/qnx4/inode.c
@@ -64,25 +64,7 @@ static struct buffer_head *qnx4_getblk(s
 		result = sb_getblk(inode->i_sb, nr);
 		return result;
 	}
-	if (!create) {
-		return NULL;
-	}
-#if 0
-	tmp = qnx4_new_block(inode->i_sb);
-	if (!tmp) {
-		return NULL;
-	}
-	result = sb_getblk(inode->i_sb, tmp);
-	if (tst) {
-		qnx4_free_block(inode->i_sb, tmp);
-		brelse(result);
-		goto repeat;
-	}
-	tst = tmp;
-#endif
-	inode->i_ctime = CURRENT_TIME_SEC;
-	mark_inode_dirty(inode);
-	return result;
+	return NULL;
 }
 
 struct buffer_head *qnx4_bread(struct inode *inode, int block, int create)
@@ -113,8 +95,6 @@ static int qnx4_get_block( struct inode 
 	if ( phys ) {
 		// logical block is before EOF
 		map_bh(bh, inode->i_sb, phys);
-	} else if ( create ) {
-		// to be done.
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from al@alarsen.net are

origin.patch

