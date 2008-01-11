From: akpm@linux-foundation.org
Subject: + udf-avoid-unnecessary-synchronous-writes.patch added to -mm tree
Date: Thu, 10 Jan 2008 16:42:07 -0800
Message-ID: <200801110042.m0B0g7Y8018085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49541 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754526AbYAKAmO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 19:42:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: efault@gmx.de, jack@suse.cz


The patch titled
     udf: avoid unnecessary synchronous writes
has been added to the -mm tree.  Its filename is
     udf-avoid-unnecessary-synchronous-writes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: udf: avoid unnecessary synchronous writes
From: Mike Galbraith <efault@gmx.de>

Fix udf_clear_inode() to request asynchronous writeout in icache reclaim
path.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/udf/inode.c~udf-avoid-unnecessary-synchronous-writes fs/udf/inode.c
--- a/fs/udf/inode.c~udf-avoid-unnecessary-synchronous-writes
+++ a/fs/udf/inode.c
@@ -117,7 +117,7 @@ void udf_clear_inode(struct inode *inode
 		udf_discard_prealloc(inode);
 		udf_truncate_tail_extent(inode);
 		unlock_kernel();
-		write_inode_now(inode, 1);
+		write_inode_now(inode, 0);
 	}
 	kfree(UDF_I_DATA(inode));
 	UDF_I_DATA(inode) = NULL;
_

Patches currently in -mm which might be from efault@gmx.de are

git-sched.patch
git-x86.patch
write_inode_now-avoid-unnecessary-synchronous-write.patch
udf-avoid-unnecessary-synchronous-writes.patch
