From: akpm@linux-foundation.org
Subject: - fs-fix-__block_write_full_page-error-case-buffer-submission.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:45:25 -0800
Message-ID: <200702211045.l1LAjP1N006356@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46825 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932493AbXBUKp3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:45:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     fs: fix __block_write_full_page error case buffer submission
has been removed from the -mm tree.  Its filename was
     fs-fix-__block_write_full_page-error-case-buffer-submission.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs: fix __block_write_full_page error case buffer submission
From: Nick Piggin <npiggin@suse.de>

Andrew noticed that unlocking the page before submitting all buffers for
writeout could cause problems if the IO completes before we've finished
messing around with the page buffers, and they subsequently get freed.

Even if there were no bug, it is a good idea to bring the error case
into line with the common case here.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/buffer.c~fs-fix-__block_write_full_page-error-case-buffer-submission fs/buffer.c
--- a/fs/buffer.c~fs-fix-__block_write_full_page-error-case-buffer-submission
+++ a/fs/buffer.c
@@ -1743,7 +1743,6 @@ recover:
 	SetPageError(page);
 	BUG_ON(PageWriteback(page));
 	set_page_writeback(page);
-	unlock_page(page);
 	do {
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
@@ -1753,6 +1752,7 @@ recover:
 		}
 		bh = next;
 	} while (bh != head);
+	unlock_page(page);
 	goto done;
 }
 
_

Patches currently in -mm which might be from npiggin@suse.de are

git-block.patch
