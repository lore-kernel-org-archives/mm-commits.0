From: akpm@linux-foundation.org
Subject: [merged] fs-bufferc-remove-unnecessary-init-operation-after-allocating-buffer_head.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:50:18 -0700
Message-ID: <20130430185018.7A1735A4088@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:33203 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758953Ab3D3SuT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:50:19 -0400
Received: by mail-vc0-f201.google.com with SMTP id gf12so86367vcb.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:50:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: majianpeng@gmail.com, jack@suse.cz, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/buffer.c: remove unnecessary init operation after allocating buffer_head.
has been removed from the -mm tree.  Its filename was
     fs-bufferc-remove-unnecessary-init-operation-after-allocating-buffer_head.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

