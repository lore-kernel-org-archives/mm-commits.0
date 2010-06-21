From: akpm@linux-foundation.org
Subject: + sysvfs-fix-null-deref-when-allocating-new-inode.patch added to -mm tree
Date: Mon, 21 Jun 2010 15:40:54 -0700
Message-ID: <201006212240.o5LMes2t009357@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751731Ab0FUWlB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jun 2010 18:41:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lkundrak@v3.sk, hch@infradead.org, stable@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     sysvfs: fix NULL deref. when allocating new inode
has been added to the -mm tree.  Its filename is
     sysvfs-fix-null-deref-when-allocating-new-inode.patch

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
Subject: sysvfs: fix NULL deref. when allocating new inode
From: Lubomir Rintel <lkundrak@v3.sk>

A call to sysv_write_inode() in sysv_new_inode() to its new interface that
replaced wait flag with writeback structure.  This was broken by
a9185b41a4f84971b930c519f0c63bd450c4810d ("pass writeback_control to
->write_inode").

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@kernel.org>		[2.6.34.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysv/ialloc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/sysv/ialloc.c~sysvfs-fix-null-deref-when-allocating-new-inode fs/sysv/ialloc.c
--- a/fs/sysv/ialloc.c~sysvfs-fix-null-deref-when-allocating-new-inode
+++ a/fs/sysv/ialloc.c
@@ -25,6 +25,7 @@
 #include <linux/stat.h>
 #include <linux/string.h>
 #include <linux/buffer_head.h>
+#include <linux/writeback.h>
 #include "sysv.h"
 
 /* We don't trust the value of
@@ -139,6 +140,9 @@ struct inode * sysv_new_inode(const stru
 	struct inode *inode;
 	sysv_ino_t ino;
 	unsigned count;
+	struct writeback_control wbc = {
+		.sync_mode = WB_SYNC_NONE
+	};
 
 	inode = new_inode(sb);
 	if (!inode)
@@ -168,7 +172,7 @@ struct inode * sysv_new_inode(const stru
 	insert_inode_hash(inode);
 	mark_inode_dirty(inode);
 
-	sysv_write_inode(inode, 0);	/* ensure inode not allocated again */
+	sysv_write_inode(inode, &wbc);	/* ensure inode not allocated again */
 	mark_inode_dirty(inode);	/* cleared by sysv_write_inode() */
 	/* That's it. */
 	unlock_super(sb);
_

Patches currently in -mm which might be from lkundrak@v3.sk are

sysvfs-fix-null-deref-when-allocating-new-inode.patch

