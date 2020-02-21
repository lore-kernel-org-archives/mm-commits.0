From: akpm@linux-foundation.org
Subject: [patch 09/15] mm/swapfile.c: fix a comment in sys_swapon()
Date: Thu, 20 Feb 2020 20:04:15 -0800
Message-ID: <20200221040415.SrM1B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729229AbgBUEEQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 Feb 2020 23:04:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, akpm@linux-foundation.org, mm-commits@vger.kernel.org, linux-mm@kvack.org, torvalds@linux-foundation.org

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
