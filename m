From: akpm@linux-foundation.org
Subject: - udf-avoid-unnecessary-synchronous-writes.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:17:51 -0800
Message-ID: <200802082017.m18KHWjO010832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57015 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753641AbYBHUqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:46:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: efault@gmx.de, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     udf: avoid unnecessary synchronous writes
has been removed from the -mm tree.  Its filename was
     udf-avoid-unnecessary-synchronous-writes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -119,7 +119,7 @@ void udf_clear_inode(struct inode *inode
 		udf_discard_prealloc(inode);
 		udf_truncate_tail_extent(inode);
 		unlock_kernel();
-		write_inode_now(inode, 1);
+		write_inode_now(inode, 0);
 	}
 	iinfo = UDF_I(inode);
 	kfree(iinfo->i_ext.i_data);
_

Patches currently in -mm which might be from efault@gmx.de are

origin.patch
