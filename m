From: akpm@linux-foundation.org
Subject: - mm-fix-pagecache-write-deadlocks-comment.patch removed from -mm tree
Date: Sun, 04 Feb 2007 01:07:57 -0800
Message-ID: <200702040907.l1497v7c026139@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34063 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222AbXBDJIB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 4 Feb 2007 04:08:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: fix pagecache write deadlocks (comment)
has been removed from the -mm tree.  Its filename was
     mm-fix-pagecache-write-deadlocks-comment.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: mm: fix pagecache write deadlocks (comment)
From: Nick Piggin <npiggin@suse.de>

Comment was not entirely clear about why we must eliminate all other
possibilities.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/filemap.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff -puN mm/filemap.c~mm-fix-pagecache-write-deadlocks-comment mm/filemap.c
--- a/mm/filemap.c~mm-fix-pagecache-write-deadlocks-comment
+++ a/mm/filemap.c
@@ -2157,12 +2157,19 @@ retry_noprogress:
 		if (!PageUptodate(page)) {
 			/*
 			 * If the page is not uptodate, we cannot allow a
-			 * partial commit_write, because that might expose
-			 * uninitialised data.
+			 * partial commit_write because when we unlock the
+			 * page below, someone else might bring it uptodate
+			 * and we lose our write. We cannot allow a full
+			 * commit_write, because that exposes uninitialised
+			 * data. We cannot zero the rest of the file and do
+			 * a full commit_write because that exposes transient
+			 * zeroes.
 			 *
-			 * We will enter the single-segment path below, which
-			 * should get the filesystem to bring the page
-			 * uputodate for us next time.
+			 * Abort the operation entirely with a zero length
+			 * commit_write. Retry.  We will enter the
+			 * single-segment path below, which should get the
+			 * filesystem to bring the page uputodate for us next
+			 * time.
 			 */
 			if (unlikely(copied != bytes))
 				copied = 0;
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-only-mm-debug-write-deadlocks.patch
mm-fix-pagecache-write-deadlocks.patch
mm-fix-pagecache-write-deadlocks-comment.patch
mm-fix-pagecache-write-deadlocks-mm-pagecache-write-deadlocks-efault-fix.patch
mm-fix-pagecache-write-deadlocks-zerolength-fix.patch
mm-fix-pagecache-write-deadlocks-stale-holes-fix.patch
fs-prepare_write-fixes.patch
fs-prepare_write-fixes-fuse-fix.patch
fs-prepare_write-fixes-jffs-fix.patch
fs-prepare_write-fixes-fat-fix.patch
fs-fix-cont-vs-deadlock-patches.patch
git-block.patch
buffer-memorder-fix.patch
sched-avoid-div-in-rebalance_tick.patch
fs-libfs-buffered-write-leak-fix.patch
mm-revert-generic_file_buffered_write-handle-zero-length-iovec-segments.patch
mm-revert-generic_file_buffered_write-deadlock-on-vectored-write.patch
mm-generic_file_buffered_write-cleanup.patch
mm-debug-write-deadlocks.patch
mm-be-sure-to-trim-blocks.patch
mm-cleanup-pagecache-insertion-operations.patch
mm-generic_file_buffered_write-iovec-cleanup.patch
