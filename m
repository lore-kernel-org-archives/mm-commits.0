From: akpm@linux-foundation.org
Subject: - fs-fix-indentation-in-do_path_lookup.patch removed from -mm tree
Date: Wed, 09 May 2007 14:50:22 -0700
Message-ID: <200705092150.l49LoMMU002800@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757853AbXEIVuf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:50:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     fs: fix indentation in do_path_lookup
has been removed from the -mm tree.  Its filename was
     fs-fix-indentation-in-do_path_lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs: fix indentation in do_path_lookup
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/namei.c~fs-fix-indentation-in-do_path_lookup fs/namei.c
--- a/fs/namei.c~fs-fix-indentation-in-do_path_lookup
+++ a/fs/namei.c
@@ -1155,11 +1155,9 @@ static int fastcall do_path_lookup(int d
 	current->total_link_count = 0;
 	retval = link_path_walk(name, nd);
 out:
-	if (likely(retval == 0)) {
-		if (unlikely(!audit_dummy_context() && nd && nd->dentry &&
+	if (unlikely(!retval && !audit_dummy_context() && nd->dentry &&
 				nd->dentry->d_inode))
 		audit_inode(name, nd->dentry->d_inode);
-	}
 out_fail:
 	return retval;
 
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

origin.patch
git-unionfs.patch
