From: akpm@linux-foundation.org
Subject: - readahead-mmap-read-around-simplification.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:30:54 -0700
Message-ID: <200710162030.l9GKUs1d014444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34630 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965914AbXJPVoS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:44:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     readahead: mmap read-around simplification
has been removed from the -mm tree.  Its filename was
     readahead-mmap-read-around-simplification.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: readahead: mmap read-around simplification
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Fold file_ra_state.mmap_hit into file_ra_state.mmap_miss and make it an int.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    3 +--
 mm/filemap.c       |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN include/linux/fs.h~readahead-mmap-read-around-simplification include/linux/fs.h
--- a/include/linux/fs.h~readahead-mmap-read-around-simplification
+++ a/include/linux/fs.h
@@ -703,8 +703,7 @@ struct file_ra_state {
 					   there are only # of pages ahead */
 
 	unsigned int ra_pages;		/* Maximum readahead window */
-	unsigned long mmap_hit;		/* Cache hit stat for mmap accesses */
-	unsigned long mmap_miss;	/* Cache miss stat for mmap accesses */
+	int mmap_miss;			/* Cache miss stat for mmap accesses */
 	unsigned long prev_index;	/* Cache last read() position */
 	unsigned int prev_offset;	/* Offset where last read() ended in a page */
 };
diff -puN mm/filemap.c~readahead-mmap-read-around-simplification mm/filemap.c
--- a/mm/filemap.c~readahead-mmap-read-around-simplification
+++ a/mm/filemap.c
@@ -1349,7 +1349,7 @@ retry_find:
 		 * Do we miss much more than hit in this file? If so,
 		 * stop bothering with read-ahead. It will only hurt.
 		 */
-		if (ra->mmap_miss > ra->mmap_hit + MMAP_LOTSAMISS)
+		if (ra->mmap_miss > MMAP_LOTSAMISS)
 			goto no_cached_page;
 
 		/*
@@ -1375,7 +1375,7 @@ retry_find:
 	}
 
 	if (!did_readaround)
-		ra->mmap_hit++;
+		ra->mmap_miss--;
 
 	/*
 	 * We have a locked page in the page cache, now we need to check
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
maps-pssproportional-set-size-accounting-in-smaps.patch
convert-ill-defined-log2-to-ilog2.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
writeback-fix-time-ordering-of-the-per-superblock-inode-lists-8.patch
writeback-fix-ntfs-with-sb_has_dirty_inodes.patch
writeback-remove-pages_skipped-accounting-in-__block_write_full_page.patch
writeback-remove-pages_skipped-accounting-in-__block_write_full_page-fix.patch
writeback-introduce-writeback_controlmore_io-to-indicate-more-io.patch
writeback-remove-unnecessary-wait-in-throttle_vm_writeout.patch
