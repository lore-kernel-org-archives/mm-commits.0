From: akpm@linux-foundation.org
Subject: [merged] mm-fix-a-comment-in-sys_swapon.patch removed
 from -mm tree
Date: Sun, 23 Feb 2020 16:44:49 -0800
Message-ID: <20200224004449.5jY_lr4mh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbgBXAou (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 23 Feb 2020 19:44:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile.c: fix a comment in sys_swapon()
has been removed from the -mm tree.  Its filename was
     mm-fix-a-comment-in-sys_swapon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm/swapfile.c: fix a comment in sys_swapon()

claim_swapfile now always takes i_rwsem.

Link: http://lkml.kernel.org/r/20200114161225.309792-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-fix-a-comment-in-sys_swapon
+++ a/mm/swapfile.c
@@ -3157,7 +3157,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 	mapping = swap_file->f_mapping;
 	inode = mapping->host;
 
-	/* If S_ISREG(inode->i_mode) will do inode_lock(inode); */
+	/* will take i_rwsem; */
 	error = claim_swapfile(p, inode);
 	if (unlikely(error))
 		goto bad_swap;
_

Patches currently in -mm which might be from hch@lst.de are
