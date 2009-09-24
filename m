From: akpm@linux-foundation.org
Subject: [merged] fs-inodec-add-dev-id-and-inode-number-for-debugging-in-init_special_inode.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:38:00 -0700
Message-ID: <200909241938.n8OJc0bN005744@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53563 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754065AbZIXTl4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:41:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mkatiyar@gmail.com, adilger@sun.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs/inode.c: add dev-id and inode number for debugging in init_special_inode()
has been removed from the -mm tree.  Its filename was
     fs-inodec-add-dev-id-and-inode-number-for-debugging-in-init_special_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/inode.c: add dev-id and inode number for debugging in init_special_inode()
From: Manish Katiyar <mkatiyar@gmail.com>

Add device-id and inode number for better debugging.  This was suggested
by Andreas in one of the threads
http://article.gmane.org/gmane.comp.file-systems.ext4/12062 .

"If anyone has a chance, fixing this error message to be not-useless would
be good...  Including the device name and the inode number would help
track down the source of the problem."

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/inode.c~fs-inodec-add-dev-id-and-inode-number-for-debugging-in-init_special_inode fs/inode.c
--- a/fs/inode.c~fs-inodec-add-dev-id-and-inode-number-for-debugging-in-init_special_inode
+++ a/fs/inode.c
@@ -1594,7 +1594,8 @@ void init_special_inode(struct inode *in
 	else if (S_ISSOCK(mode))
 		inode->i_fop = &bad_sock_fops;
 	else
-		printk(KERN_DEBUG "init_special_inode: bogus i_mode (%o)\n",
-		       mode);
+		printk(KERN_DEBUG "init_special_inode: bogus i_mode (%o) for"
+				  " inode %s:%lu\n", mode, inode->i_sb->s_id,
+				  inode->i_ino);
 }
 EXPORT_SYMBOL(init_special_inode);
_

Patches currently in -mm which might be from mkatiyar@gmail.com are

origin.patch

