From: akpm@linux-foundation.org
Subject: [merged] ufs-copy-symlink-data-into-the-correct-union-member.patch removed from -mm tree
Date: Mon, 30 Mar 2009 12:07:20 -0700
Message-ID: <200903301907.n2UJ7LLr019325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758042AbZC3TJR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 15:09:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: duaneg@dghda.com, mm-commits@vger.kernel.org


The patch titled
     ufs: copy symlink data into the correct union member
has been removed from the -mm tree.  Its filename was
     ufs-copy-symlink-data-into-the-correct-union-member.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ufs: copy symlink data into the correct union member
From: Duane Griffin <duaneg@dghda.com>

Copy symlink data into the union member it is accessed through.  Although
this shouldn't make a difference to behaviour it makes the code easier to
follow and grep through.  It may also prevent problems if the struct/union
definitions change in the future.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ufs/namei.c~ufs-copy-symlink-data-into-the-correct-union-member fs/ufs/namei.c
--- a/fs/ufs/namei.c~ufs-copy-symlink-data-into-the-correct-union-member
+++ a/fs/ufs/namei.c
@@ -147,7 +147,7 @@ static int ufs_symlink (struct inode * d
 	} else {
 		/* fast symlink */
 		inode->i_op = &ufs_fast_symlink_inode_operations;
-		memcpy((char*)&UFS_I(inode)->i_u1.i_data,symname,l);
+		memcpy(UFS_I(inode)->i_u1.i_symlink, symname, l);
 		inode->i_size = l-1;
 	}
 	mark_inode_dirty(inode);
_

Patches currently in -mm which might be from duaneg@dghda.com are

origin.patch
linux-next.patch

