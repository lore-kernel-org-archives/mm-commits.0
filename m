From: akpm@linux-foundation.org
Subject: + fs-fix-__block_write_full_page-error-case-buffer-submission.patch added to -mm tree
Date: Tue, 06 Feb 2007 00:44:12 -0800
Message-ID: <200702060844.l168iCC3014133@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55349 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbXBFIoQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 03:44:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     fs: fix __block_write_full_page error case buffer submission
has been added to the -mm tree.  Its filename is
     fs-fix-__block_write_full_page-error-case-buffer-submission.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1741,7 +1741,6 @@ recover:
 	SetPageError(page);
 	BUG_ON(PageWriteback(page));
 	set_page_writeback(page);
-	unlock_page(page);
 	do {
 		struct buffer_head *next = bh->b_this_page;
 		if (buffer_async_write(bh)) {
@@ -1751,6 +1750,7 @@ recover:
 		}
 		bh = next;
 	} while (bh != head);
+	unlock_page(page);
 	goto done;
 }
 
_

Patches currently in -mm which might be from npiggin@suse.de are

git-block.patch
mm-vm_insert_pfn.patch
mm-vm_insert_pfn-tidy.patch
buffer-memorder-fix.patch
fs-fix-__block_write_full_page-error-case-buffer-submission.patch
sched-avoid-div-in-rebalance_tick.patch
