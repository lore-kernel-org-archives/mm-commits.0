From: akpm@osdl.org
Subject: + reiser4-fix-write_extent-1.patch added to -mm tree
Date: Thu, 14 Dec 2006 00:23:23 -0800
Message-ID: <200612140823.kBE8NPKT004885@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59241 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbWLNIXj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 03:23:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward@namesys.com


The patch titled
     reiser4: fix write_extent
has been added to the -mm tree.  Its filename is
     reiser4-fix-write_extent-1.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

reiser4-vs-streamline-generic_file_-interfaces-and-filemap-fix.patch
reiser4-rename-generic_sounding_globalspatch.patch
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
reiser4-fix-write_extent.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
reiser4-use-null-for-pointers.patch

