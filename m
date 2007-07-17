From: akpm@linux-foundation.org
Subject: + reiser4-fix-unix-file-readpages-filler.patch added to -mm tree
Date: Mon, 16 Jul 2007 17:22:13 -0700
Message-ID: <200707170022.l6H0MDax012546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60974 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754308AbXGQAWa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 20:22:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward@namesys.com


The patch titled
     reiser4: fix unix-file readpages filler
has been added to the -mm tree.  Its filename is
     reiser4-fix-unix-file-readpages-filler.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiser4: fix unix-file readpages filler
From: Edward Shishkin <edward@namesys.com>

Protect page (via incrementing page count) from being reclaimed when looking
for extent pointer in unix-file specific readpages filler.

Signed-off-by: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/file.c |   32 ++++++++++++++++++--------------
 1 files changed, 18 insertions(+), 14 deletions(-)

diff -puN fs/reiser4/plugin/file/file.c~reiser4-fix-unix-file-readpages-filler fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-fix-unix-file-readpages-filler
+++ a/fs/reiser4/plugin/file/file.c
@@ -1607,6 +1607,8 @@ static int uf_readpages_filler(void * da
 		unlock_page(page);
 		return 0;
 	}
+	page_cache_get(page);
+
 	if (rc->lh.node == 0) {
 		/* no twig lock  - have to do tree search. */
 		reiser4_key key;
@@ -1619,21 +1621,19 @@ static int uf_readpages_filler(void * da
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
@@ -1647,22 +1647,26 @@ static int uf_readpages_filler(void * da
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

reiser4.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
reiser4-fix-extent2tail.patch
reiser4-fix-read_tail.patch
reiser4-fix-unix-file-readpages-filler.patch
reiser4-fix-for-new-aops-patches.patch
git-block-vs-reiser4.patch
