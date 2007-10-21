From: akpm@linux-foundation.org
Subject: - reiser4-fix-unix-file-readpages-filler.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:47:05 -0700
Message-ID: <200710212347.l9LNl5Jc000637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37185 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751203AbXJUXrn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:47:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: fix unix-file readpages filler
has been removed from the -mm tree.  Its filename was
     reiser4-fix-unix-file-readpages-filler.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: fix unix-file readpages filler
From: Edward Shishkin <edward@namesys.com>

Protect page (via incrementing page count) from being reclaimed when looking
for extent pointer in unix-file specific readpages filler.

Signed-off-by: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/file.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff -puN fs/reiser4/plugin/file/file.c~reiser4-fix-unix-file-readpages-filler fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-fix-unix-file-readpages-filler
+++ a/fs/reiser4/plugin/file/file.c
@@ -1608,6 +1608,8 @@ static int uf_readpages_filler(void * da
 		unlock_page(page);
 		return 0;
 	}
+	page_cache_get(page);
+
 	if (rc->lh.node == 0) {
 		/* no twig lock  - have to do tree search. */
 		reiser4_key key;
@@ -1620,21 +1622,19 @@ static int uf_readpages_filler(void * da
 			&key, &rc->coord, &rc->lh,
 			ZNODE_READ_LOCK, FIND_EXACT,
 			TWIG_LEVEL, TWIG_LEVEL, CBK_UNIQUE, NULL);
-		if (ret)
-			return ret;
+		if (unlikely(ret))
+			goto exit;
 		lock_page(page);
 		cbk_done = 1;
 	}
 	ret = zload(rc->coord.node);
-	if (ret) {
-		unlock_page(page);
-		return ret;
-	}
+	if (unlikely(ret))
+		goto unlock;
 	if (!coord_is_existing_item(&rc->coord) ||
 	    !item_is_extent(&rc->coord)) {
 		zrelse(rc->coord.node);
-		unlock_page(page);
-		return RETERR(-EIO);
+		ret = RETERR(-EIO);
+		goto unlock;
 	}
 	ext = extent_by_coord(&rc->coord);
 	ext_index = extent_unit_index(&rc->coord);
@@ -1648,22 +1648,26 @@ static int uf_readpages_filler(void * da
 		/* we can be here after a CBK call only in case of
 		   corruption of the tree or the tree lookup algorithm bug. */
 		if (unlikely(cbk_done)) {
-			unlock_page(page);
-			return RETERR(-EIO);
+			ret = RETERR(-EIO);
+			goto unlock;
 		}
 		goto repeat;
 	}
 	node = jnode_of_page(page);
 	if (unlikely(IS_ERR(node))) {
 		zrelse(rc->coord.node);
-		unlock_page(page);
-		return PTR_ERR(node);
+		ret = PTR_ERR(node);
+		goto unlock;
 	}
 	ret = reiser4_do_readpage_extent(ext, page->index - ext_index, page);
 	jput(node);
 	zrelse(rc->coord.node);
-	if (ret)
-		unlock_page(page);
+	if (likely(!ret))
+		goto exit;
+ unlock:
+	unlock_page(page);
+ exit:
+	page_cache_release(page);
 	return ret;
 }
 
_

Patches currently in -mm which might be from edward@namesys.com are

origin.patch
reiser4.patch
reiser4-fix-unix-file-readpages-filler.patch
reiser4-fix-readpage_unix_file.patch
reiser4-fix-for-new-aops-patches.patch
reiser4-do-not-allocate-struct-file-on-stack.patch
git-block-vs-reiser4.patch
reiser4-cryptcompress-misc-fixups.patch
reiser4-cryptcompress-misc-fixups-2.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
reiser4-change-error-code-base.patch
reiser4-use-lzo-library-functions.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
git-nfsd-broke-reiser4.patch
