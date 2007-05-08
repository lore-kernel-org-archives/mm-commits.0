From: akpm@linux-foundation.org
Subject: - fs-buffer-dont-pageuptodate-without-page-locked.patch removed from -mm tree
Date: Mon, 07 May 2007 17:02:00 -0700
Message-ID: <200705080002.l48020PW008811@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967318AbXEHACf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:02:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     fs: buffer don't PageUptodate without page locked
has been removed from the -mm tree.  Its filename was
     fs-buffer-dont-pageuptodate-without-page-locked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs: buffer don't PageUptodate without page locked
From: Nick Piggin <npiggin@suse.de>

__block_write_full_page is calling SetPageUptodate without the page locked. 
This is unusual, but not incorrect, as PG_writeback is still set.

However the next patch will require that SetPageUptodate always be called with
the page locked.  Simply don't bother setting the page uptodate in this case
(it is unusual that the write path does such a thing anyway).  Instead just
leave it to the read side to bring the page uptodate when it notices that all
buffers are uptodate.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff -puN fs/buffer.c~fs-buffer-dont-pageuptodate-without-page-locked fs/buffer.c
--- a/fs/buffer.c~fs-buffer-dont-pageuptodate-without-page-locked
+++ a/fs/buffer.c
@@ -1700,17 +1700,8 @@ done:
 		 * clean.  Someone wrote them back by hand with
 		 * ll_rw_block/submit_bh.  A rare case.
 		 */
-		int uptodate = 1;
-		do {
-			if (!buffer_uptodate(bh)) {
-				uptodate = 0;
-				break;
-			}
-			bh = bh->b_this_page;
-		} while (bh != head);
-		if (uptodate)
-			SetPageUptodate(page);
 		end_page_writeback(page);
+
 		/*
 		 * The page and buffer_heads can be released at any time from
 		 * here on.
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-more-rmap-checking.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
mm-document-fault_data-and-flags.patch
exec-fix-remove_arg_zero.patch
as-fix-antic_expire-check.patch
futex-restartable-futex_wait.patch
