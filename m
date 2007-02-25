From: akpm@linux-foundation.org
Subject: + fs-buffer-dont-pageuptodate-without-page-locked.patch added to -mm tree
Date: Sun, 25 Feb 2007 04:09:09 -0800
Message-ID: <200702251209.l1PC9Bfb028989@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33926 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964821AbXBYMJV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Feb 2007 07:09:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, hugh@veritas.com


The patch titled
     fs: buffer don't PageUptodate without page locked
has been added to the -mm tree.  Its filename is
     fs-buffer-dont-pageuptodate-without-page-locked.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1692,17 +1692,8 @@ done:
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

git-block.patch
mm-remove-gcc-workaround.patch
mm-more-rmap-checking.patch
mm-make-read_cache_page-synchronous.patch
fs-buffer-dont-pageuptodate-without-page-locked.patch
fs-introduce-some-page-buffer-invariants.patch
