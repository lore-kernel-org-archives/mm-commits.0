From: akpm@linux-foundation.org
Subject: - reiser4-use-generic-file-read-fix-readpages-unix-file.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:00:06 -0800
Message-ID: <200703060200.l26206AZ008700@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46611 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965683AbXCFCAU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:00:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward@namesys.com, zam@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: fix readpages unix-file
has been removed from the -mm tree.  Its filename was
     reiser4-use-generic-file-read-fix-readpages-unix-file.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: fix readpages unix-file
From: Edward Shishkin <edward@namesys.com>

. Fix bugs introduced by Zam's reiser4-use-generic-file-read.patch:
  1) jnode leak in a case when a file is built of tails:
     filemap_nopage->page_cache_readahead->reiser4_readpages->
     ->readpages_unix_file->uf_readpages_filler->jnode_of_page,
     then jput() does not evict the jnode.
  2) passing invalid address to jput() in the case of returned error.

Signed-off-by: Edward Shishkin <edward@namesys.com>
Cc: Alexander Zarochentsev <zam@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/plugin/file/file.c |   50 ++++++++++++++++----------------
 1 file changed, 26 insertions(+), 24 deletions(-)

diff -puN fs/reiser4/plugin/file/file.c~reiser4-use-generic-file-read-fix-readpages-unix-file fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-use-generic-file-read-fix-readpages-unix-file
+++ a/fs/reiser4/plugin/file/file.c
@@ -1589,7 +1589,7 @@ struct uf_readpages_context {
 };
 
 /* A callback function for readpages_unix_file/read_cache_pages.
- * It assumes that the file is build of extents.
+ * If the file is build of tails, then return error (-ENOENT).
  *
  * @data -- a pointer to reiser4_readpages_context object,
  *            to save the twig lock and the coord between
@@ -1610,11 +1610,6 @@ static int uf_readpages_filler(void * da
 		unlock_page(page);
 		return 0;
 	}
-	node = jnode_of_page(page);
-	if (unlikely(IS_ERR(node))) {
-		ret = PTR_ERR(node);
-		goto err;
-	}
 	if (rc->lh.node == 0) {
 		/* no twig lock  - have to do tree search. */
 		reiser4_key key;
@@ -1627,43 +1622,50 @@ static int uf_readpages_filler(void * da
 			&key, &rc->coord, &rc->lh,
 			ZNODE_READ_LOCK, FIND_EXACT,
 			TWIG_LEVEL, TWIG_LEVEL, CBK_UNIQUE, NULL);
+		if (ret)
+			return ret;
 		lock_page(page);
 		cbk_done = 1;
-		if (ret != 0)
-			goto err;
 	}
 	ret = zload(rc->coord.node);
-	if (ret)
-		goto err;
+	if (ret) {
+		unlock_page(page);
+		return ret;
+	}
 	if (!coord_is_existing_item(&rc->coord) ||
 	    !item_is_extent(&rc->coord)) {
 		zrelse(rc->coord.node);
-		ret = RETERR(-EIO);
-		goto err;
+		unlock_page(page);
+		return RETERR(-EIO);
 	}
 	ext = extent_by_coord(&rc->coord);
 	ext_index = extent_unit_index(&rc->coord);
-	if (page->index < ext_index || page->index >= ext_index + extent_get_width(ext))
-	{
-		/* the page index doesn't belong to the extent unit which the coord points to,
-		 *  -- release the lock and repeat with tree search. */
+	if (page->index < ext_index ||
+	    page->index >= ext_index + extent_get_width(ext)) {
+		/* the page index doesn't belong to the extent unit
+		   which the coord points to - release the lock and
+		   repeat with tree search. */
 		zrelse(rc->coord.node);
 		done_lh(&rc->lh);
-		/* we can be here after a CBK call only in case of corruption of the tree
-		 * or the tree lookup algorithm bug. */
+		/* we can be here after a CBK call only in case of
+		   corruption of the tree or the tree lookup algorithm bug. */
 		if (unlikely(cbk_done)) {
-			ret = RETERR(-EIO);
-			goto err;
+			unlock_page(page);
+			return RETERR(-EIO);
 		}
 		goto repeat;
 	}
-	ret = reiser4_do_readpage_extent(ext, page->index - ext_index, page);
-	zrelse(rc->coord.node);
-	if (ret) {
-err:
+	node = jnode_of_page(page);
+	if (unlikely(IS_ERR(node))) {
+		zrelse(rc->coord.node);
 		unlock_page(page);
+		return PTR_ERR(node);
 	}
+	ret = reiser4_do_readpage_extent(ext, page->index - ext_index, page);
 	jput(node);
+	zrelse(rc->coord.node);
+	if (ret)
+		unlock_page(page);
 	return ret;
 }
 
_

Patches currently in -mm which might be from edward@namesys.com are

reiser4.patch
reiser4-use-generic-file-read-fix-readpages-unix-file.patch
reiser4-format-subversion-numbers-heir-set-and-file-conversion.patch
reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress.patch
reiser4-cleanups-in-lzo-compression-library.patch
reiser4-get-rid-of-deprecated-crypto-api.patch
reiser4-get-rid-of-deprecated-crypto-api-build-fix.patch
reiser4-fix-missed-unlock-and-exit_context.patch
reiser4-use-list_head-instead-of-struct-blocknr.patch
reiser4-use-list_empty-instead-of-list_empty_careful-for.patch
reiser4-update-comments-fix-write-and-truncate-cryptcompress.patch
reiser4-temp-fix.patch
reiser4-fix-write_extent-1.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
reiser4-use-null-for-pointers.patch
reiser4-test_clear_page_dirty.patch
reiser4-fix-readpage_cryptcompress.patch
reiser4-improve-estimation-for-number-of-nodes-occupied.patch
reiser4-drop-check_cryptcompress.patch
reiser4-drop-unused-semaphores.patch
reiser4-use-dynamic-lattice-for-adaptive-compression.patch
reiser4-fix-freeze-and-corruption.patch
