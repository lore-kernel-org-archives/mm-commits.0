From: akpm@linux-foundation.org
Subject: + fs-bufferc-remove-unnecessary-init-operation-after-allocating-buffer_head.patch added to -mm tree
Date: Tue, 23 Apr 2013 15:29:16 -0700
Message-ID: <20130423222916.74A6C31C034@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:43221 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab3DWW3R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Apr 2013 18:29:17 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so127752ggm.5
        for <mm-commits@vger.kernel.org>; Tue, 23 Apr 2013 15:29:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: majianpeng@gmail.com, jack@suse.cz, tytso@mit.edu


The patch titled
     Subject: fs/buffer.c: remove unnecessary init operation after allocating buffer_head.
has been added to the -mm tree.  Its filename is
     fs-bufferc-remove-unnecessary-init-operation-after-allocating-buffer_head.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: majianpeng <majianpeng@gmail.com>
Subject: fs/buffer.c: remove unnecessary init operation after allocating buffer_head.

bh allocation uses kmem_cache_zalloc() so we needn't call 'init_buffer(bh,
NULL, NULL)' and perform other set-zero-operations.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c       |    2 --
 fs/jbd/journal.c  |    2 --
 fs/jbd2/journal.c |    2 --
 3 files changed, 6 deletions(-)

diff -puN fs/buffer.c~fs-bufferc-remove-unnecessary-init-operation-after-allocating-buffer_head fs/buffer.c
--- a/fs/buffer.c~fs-bufferc-remove-unnecessary-init-operation-after-allocating-buffer_head
+++ a/fs/buffer.c
@@ -865,8 +865,6 @@ try_again:
 
 		/* Link the buffer to its page */
 		set_bh_page(bh, page, offset);
-
-		init_buffer(bh, NULL, NULL);
 	}
 	return head;
 /*
diff -puN fs/jbd/journal.c~fs-bufferc-remove-unnecessary-init-operation-after-allocating-buffer_head fs/jbd/journal.c
--- a/fs/jbd/journal.c~fs-bufferc-remove-unnecessary-init-operation-after-allocating-buffer_head
+++ a/fs/jbd/journal.c
@@ -310,8 +310,6 @@ int journal_write_metadata_buffer(transa
 
 	new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
 	/* keep subsequent assertions sane */
-	new_bh->b_state = 0;
-	init_buffer(new_bh, NULL, NULL);
 	atomic_set(&new_bh->b_count, 1);
 	new_jh = journal_add_journal_head(new_bh);	/* This sleeps */
 
diff -puN fs/jbd2/journal.c~fs-bufferc-remove-unnecessary-init-operation-after-allocating-buffer_head fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~fs-bufferc-remove-unnecessary-init-operation-after-allocating-buffer_head
+++ a/fs/jbd2/journal.c
@@ -367,8 +367,6 @@ retry_alloc:
 	}
 
 	/* keep subsequent assertions sane */
-	new_bh->b_state = 0;
-	init_buffer(new_bh, NULL, NULL);
 	atomic_set(&new_bh->b_count, 1);
 	new_jh = jbd2_journal_add_journal_head(new_bh);	/* This sleeps */
 
_

Patches currently in -mm which might be from majianpeng@gmail.com are

linux-next.patch
fs-block_devc-fix-iov_shorten-criteria-in-blkdev_aio_read.patch
fs-bufferc-remove-unnecessary-init-operation-after-allocating-buffer_head.patch

