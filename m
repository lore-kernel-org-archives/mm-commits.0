From: akpm@linux-foundation.org
Subject: + mm-fix-a-comment-in-sys_swapon.patch added to -mm tree
Date: Mon, 10 Feb 2020 15:24:14 -0800
Message-ID: <20200210232414.29IyI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727422AbgBJXYP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 Feb 2020 18:24:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de


The patch titled
     Subject: mm/swapfile.c: fix a comment in sys_swapon()
has been added to the -mm tree.  Its filename is
     mm-fix-a-comment-in-sys_swapon.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-a-comment-in-sys_swapon.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-a-comment-in-sys_swapon.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-fix-a-comment-in-sys_swapon.patch
