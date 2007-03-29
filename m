From: akpm@linux-foundation.org
Subject: - splice-dont-readpage.patch removed from -mm tree
Date: Thu, 29 Mar 2007 00:42:47 -0700
Message-ID: <200703290742.l2T7glue030333@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46169 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964974AbXC2Hmy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 03:42:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     splice: don't readpage
has been removed from the -mm tree.  Its filename was
     splice-dont-readpage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: splice: don't readpage
From: Nick Piggin <npiggin@suse.de>

Splice does not need to readpage to bring the page uptodate before writing
to it, because prepare_write will take care of that for us.

Splice is also wrong to SetPageUptodate before the page is actually
uptodate.  This results in the old uninitialised memory leak.  This gets
fixed as a matter of course when removing the readpage logic.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c |   30 ------------------------------
 1 file changed, 30 deletions(-)

diff -puN fs/splice.c~splice-dont-readpage fs/splice.c
--- a/fs/splice.c~splice-dont-readpage
+++ a/fs/splice.c
@@ -593,36 +593,6 @@ find_page:
 			goto out;
 	}
 
-	/*
-	 * We get here with the page locked. If the page is also
-	 * uptodate, we don't need to do more. If it isn't, we
-	 * may need to bring it in if we are not going to overwrite
-	 * the full page.
-	 */
-	if (!PageUptodate(page)) {
-		if (this_len < PAGE_CACHE_SIZE) {
-			ret = mapping->a_ops->readpage(file, page);
-			if (unlikely(ret))
-				goto out;
-
-			lock_page(page);
-
-			if (!PageUptodate(page)) {
-				/*
-				 * Page got invalidated, repeat.
-				 */
-				if (!page->mapping) {
-					unlock_page(page);
-					page_cache_release(page);
-					goto find_page;
-				}
-				ret = -EIO;
-				goto out;
-			}
-		} else
-			SetPageUptodate(page);
-	}
-
 	ret = mapping->a_ops->prepare_write(file, page, offset, offset+this_len);
 	if (unlikely(ret)) {
 		loff_t isize = i_size_read(mapping->host);
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
holepunch-fix-disconnected-pages-after-second-truncate.patch
holepunch-fix-mmap_sem-i_mutex-deadlock.patch
mm-remove-gcc-workaround.patch
mm-more-rmap-checking.patch
mm-make-read_cache_page-synchronous.patch
fs-buffer-dont-pageuptodate-without-page-locked.patch
mm-simplify-filemap_nopage.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
mm-filemapc-fix-mark_page_accessed-logic.patch
exec-fix-remove_arg_zero.patch
exec-fix-remove_arg_zero-add-comment.patch
as-fix-antic_expire-check.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
