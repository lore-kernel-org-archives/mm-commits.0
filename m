From: akpm@linux-foundation.org
Subject: - reiser4-fix-write_extent-1.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:04:25 -0800
Message-ID: <200703060204.l2624PjE008807@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46776 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965712AbXCFCE3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:04:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: fix write_extent
has been removed from the -mm tree.  Its filename was
     reiser4-fix-write_extent-1.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: fix write_extent
From: Edward Shishkin <edward@namesys.com>

. Use set_page_writeback() instead of SetPageWriteback().
. Use end_page_writeback() instead of ClearPageWriteback().


Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/page_cache.c |    2 +-
 fs/reiser4/wander.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/reiser4/page_cache.c~reiser4-fix-write_extent-1 fs/reiser4/page_cache.c
--- a/fs/reiser4/page_cache.c~reiser4-fix-write_extent-1
+++ a/fs/reiser4/page_cache.c
@@ -409,7 +409,7 @@ int reiser4_page_io(struct page *page, j
 	bio = page_bio(page, node, rw, gfp);
 	if (!IS_ERR(bio)) {
 		if (rw == WRITE) {
-			SetPageWriteback(page);
+			set_page_writeback(page);
 			unlock_page(page);
 		}
 		reiser4_submit_bio(rw, bio);
diff -puN fs/reiser4/wander.c~reiser4-fix-write_extent-1 fs/reiser4/wander.c
--- a/fs/reiser4/wander.c~reiser4-fix-write_extent-1
+++ a/fs/reiser4/wander.c
@@ -557,7 +557,7 @@ static void undo_bio(struct bio *bio)
 		jnode *node;
 
 		pg = bio->bi_io_vec[i].bv_page;
-		ClearPageWriteback(pg);
+		end_page_writeback(pg);
 		node = jprivate(pg);
 		spin_lock_jnode(node);
 		JF_CLR(node, JNODE_WRITEBACK);
_

Patches currently in -mm which might be from edward@namesys.com are

reiser4.patch
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
