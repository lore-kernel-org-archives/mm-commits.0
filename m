From: akpm@linux-foundation.org
Subject: - splice-dont-steal.patch removed from -mm tree
Date: Thu, 29 Mar 2007 00:42:44 -0700
Message-ID: <200703290742.l2T7giFu030328@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46163 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964806AbXC2Hmw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 03:42:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     splice: dont steal
has been removed from the -mm tree.  Its filename was
     splice-dont-steal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: splice: dont steal
From: Nick Piggin <npiggin@suse.de>

Stealing pages with splice is problematic because we cannot just insert an
uptodate page into the pagecache and hope the filesystem can take care of
it later.

We also cannot just ClearPageUptodate, then hope prepare_write does not
write anything into the page, because I don't think prepare_write gives
that guarantee.

Remove support for SPLICE_F_MOVE for now.  If we really want to bring it
back, we might be able to do so with a the new filesystem buffered write
aops APIs I'm working on.  If we really don't want to bring it back, then
we should decide that sooner rather than later, and remove the flag and all
the stealing infrastructure before anybody starts using it.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c |  101 ++++++++++++++++++--------------------------------
 1 file changed, 38 insertions(+), 63 deletions(-)

diff -puN fs/splice.c~splice-dont-steal fs/splice.c
--- a/fs/splice.c~splice-dont-steal
+++ a/fs/splice.c
@@ -576,76 +576,51 @@ static int pipe_to_file(struct pipe_inod
 	if (this_len + offset > PAGE_CACHE_SIZE)
 		this_len = PAGE_CACHE_SIZE - offset;
 
-	/*
-	 * Reuse buf page, if SPLICE_F_MOVE is set and we are doing a full
-	 * page.
-	 */
-	if ((sd->flags & SPLICE_F_MOVE) && this_len == PAGE_CACHE_SIZE) {
+find_page:
+	page = find_lock_page(mapping, index);
+	if (!page) {
+		ret = -ENOMEM;
+		page = page_cache_alloc_cold(mapping);
+		if (unlikely(!page))
+			goto out_ret;
+
 		/*
-		 * If steal succeeds, buf->page is now pruned from the
-		 * pagecache and we can reuse it. The page will also be
-		 * locked on successful return.
+		 * This will also lock the page
 		 */
-		if (buf->ops->steal(pipe, buf))
-			goto find_page;
-
-		page = buf->page;
-		if (add_to_page_cache(page, mapping, index, GFP_KERNEL)) {
-			unlock_page(page);
-			goto find_page;
-		}
-
-		page_cache_get(page);
+		ret = add_to_page_cache_lru(page, mapping, index,
+					    GFP_KERNEL);
+		if (unlikely(ret))
+			goto out;
+	}
 
-		if (!(buf->flags & PIPE_BUF_FLAG_LRU))
-			lru_cache_add(page);
-	} else {
-find_page:
-		page = find_lock_page(mapping, index);
-		if (!page) {
-			ret = -ENOMEM;
-			page = page_cache_alloc_cold(mapping);
-			if (unlikely(!page))
-				goto out_ret;
-
-			/*
-			 * This will also lock the page
-			 */
-			ret = add_to_page_cache_lru(page, mapping, index,
-						    GFP_KERNEL);
+	/*
+	 * We get here with the page locked. If the page is also
+	 * uptodate, we don't need to do more. If it isn't, we
+	 * may need to bring it in if we are not going to overwrite
+	 * the full page.
+	 */
+	if (!PageUptodate(page)) {
+		if (this_len < PAGE_CACHE_SIZE) {
+			ret = mapping->a_ops->readpage(file, page);
 			if (unlikely(ret))
 				goto out;
-		}
 
-		/*
-		 * We get here with the page locked. If the page is also
-		 * uptodate, we don't need to do more. If it isn't, we
-		 * may need to bring it in if we are not going to overwrite
-		 * the full page.
-		 */
-		if (!PageUptodate(page)) {
-			if (this_len < PAGE_CACHE_SIZE) {
-				ret = mapping->a_ops->readpage(file, page);
-				if (unlikely(ret))
-					goto out;
-
-				lock_page(page);
-
-				if (!PageUptodate(page)) {
-					/*
-					 * Page got invalidated, repeat.
-					 */
-					if (!page->mapping) {
-						unlock_page(page);
-						page_cache_release(page);
-						goto find_page;
-					}
-					ret = -EIO;
-					goto out;
+			lock_page(page);
+
+			if (!PageUptodate(page)) {
+				/*
+				 * Page got invalidated, repeat.
+				 */
+				if (!page->mapping) {
+					unlock_page(page);
+					page_cache_release(page);
+					goto find_page;
 				}
-			} else
-				SetPageUptodate(page);
-		}
+				ret = -EIO;
+				goto out;
+			}
+		} else
+			SetPageUptodate(page);
 	}
 
 	ret = mapping->a_ops->prepare_write(file, page, offset, offset+this_len);
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
