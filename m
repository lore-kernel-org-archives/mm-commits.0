From: akpm@linux-foundation.org
Subject: + qnx4fs-remove-remains-of-the-defunct-write-support.patch added to -mm tree
Date: Fri, 09 Oct 2009 16:24:23 -0700
Message-ID: <200910092324.n99NONld022499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753956AbZJIXZU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 19:25:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: al@alarsen.net, hch@lst.de, jkosina@suse.cz


The patch titled
     qnx4fs: remove remains of the (defunct) write support
has been added to the -mm tree.  Its filename is
     qnx4fs-remove-remains-of-the-defunct-write-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: qnx4fs: remove remains of the (defunct) write support
From: Anders Larsen <al@alarsen.net>

commit 945ffe54bbd56ceed62de3b908800fd7c6ffb284 ("qnx4: remove write support") removed the (defunct)
write support but missed a chunk of related, dead code.

Signed-off-by: Anders Larsen <al@alarsen.net>
Cc:  Jiri Kosina <jkosina@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

qnx4fs-remove-remains-of-the-defunct-write-support.patch

