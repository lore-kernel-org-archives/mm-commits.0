From: akpm@linux-foundation.org
Subject: [merged] fat-simplify-writeback_inode.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:18:50 -0700
Message-ID: <20121005201851.0586D5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:59207 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757279Ab2JEUSx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:18:53 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so139610eek.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:18:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linkinjeon@gmail.com, amit.sahrawat83@gmail.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: simplify writeback_inode()
has been removed from the -mm tree.  Its filename was
     fat-simplify-writeback_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: fat: simplify writeback_inode()

[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN fs/fat/inode.c~fat-simplify-writeback_inode fs/fat/inode.c
--- a/fs/fat/inode.c~fat-simplify-writeback_inode
+++ a/fs/fat/inode.c
@@ -1463,18 +1463,14 @@ static int writeback_inode(struct inode 
 {
 
 	int ret;
-	struct address_space *mapping = inode->i_mapping;
-	struct writeback_control wbc = {
-	       .sync_mode = WB_SYNC_NONE,
-	      .nr_to_write = 0,
-	};
-	/* if we used WB_SYNC_ALL, sync_inode waits for the io for the
-	* inode to finish.  So WB_SYNC_NONE is sent down to sync_inode
+
+	/* if we used wait=1, sync_inode_metadata waits for the io for the
+	* inode to finish.  So wait=0 is sent down to sync_inode_metadata
 	* and filemap_fdatawrite is used for the data blocks
 	*/
-	ret = sync_inode(inode, &wbc);
+	ret = sync_inode_metadata(inode, 0);
 	if (!ret)
-	       ret = filemap_fdatawrite(mapping);
+		ret = filemap_fdatawrite(inode->i_mapping);
 	return ret;
 }
 
_

Patches currently in -mm which might be from linkinjeon@gmail.com are

origin.patch
linux-next.patch

