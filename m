From: akpm@linux-foundation.org
Subject: + fs-bufferc-remove-redundant-initialization-in-alloc_page_buffers.patch added to -mm tree
Date: Tue, 27 Nov 2012 15:08:41 -0800
Message-ID: <20121127230842.A109420004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:42937 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab2K0XIo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Nov 2012 18:08:44 -0500
Received: by mail-wi0-f202.google.com with SMTP id cb5so413550wib.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Nov 2012 15:08:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clouds.yan@gmail.com


The patch titled
     Subject: fs/buffer.c: remove redundant initialization in alloc_page_buffers()
has been added to the -mm tree.  Its filename is
     fs-bufferc-remove-redundant-initialization-in-alloc_page_buffers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
fs-block_devc-need-not-to-check-inode-i_bdev-in-bd_forget.patch
writeback-fix-a-typo-in-comment.patch
fs-bufferc-do-not-inline-exported-function.patch
fs-bufferc-remove-redundant-initialization-in-alloc_page_buffers.patch

