From: akpm@linux-foundation.org
Subject: [merged] fs-bufferc-remove-redundant-initialization-in-alloc_page_buffers.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:29:45 -0800
Message-ID: <20121214232945.AC17A82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:40898 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932741Ab2LNX3q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:29:46 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so408974qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:29:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clouds.yan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/buffer.c: remove redundant initialization in alloc_page_buffers()
has been removed from the -mm tree.  Its filename was
     fs-bufferc-remove-redundant-initialization-in-alloc_page_buffers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yan Hong <clouds.yan@gmail.com>
Subject: fs/buffer.c: remove redundant initialization in alloc_page_buffers()

buffer_head comes from kmem_cache_zalloc(), no need to zero its fields.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/buffer.c~fs-bufferc-remove-redundant-initialization-in-alloc_page_buffers fs/buffer.c
--- a/fs/buffer.c~fs-bufferc-remove-redundant-initialization-in-alloc_page_buffers
+++ a/fs/buffer.c
@@ -849,13 +849,10 @@ try_again:
 		if (!bh)
 			goto no_grow;
 
-		bh->b_bdev = NULL;
 		bh->b_this_page = head;
 		bh->b_blocknr = -1;
 		head = bh;
 
-		bh->b_state = 0;
-		atomic_set(&bh->b_count, 0);
 		bh->b_size = size;
 
 		/* Link the buffer to its page */
_

Patches currently in -mm which might be from clouds.yan@gmail.com are

origin.patch
fs-block_devc-need-not-to-check-inode-i_bdev-in-bd_forget.patch

