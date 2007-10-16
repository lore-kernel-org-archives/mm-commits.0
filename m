From: akpm@linux-foundation.org
Subject: - readahead-compacting-file_ra_state.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:30:51 -0700
Message-ID: <200710162030.l9GKUpcA014441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55012 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966311AbXJPVtV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:49:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, andi@firstfloor.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     readahead: compacting file_ra_state
has been removed from the -mm tree.  Its filename was
     readahead-compacting-file_ra_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: readahead: compacting file_ra_state
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Use 'unsigned int' instead of 'unsigned long' for readahead sizes.

This helps reduce memory consumption on 64bit CPU when a lot of files are
opened.

CC: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    8 ++++----
 mm/readahead.c     |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/fs.h~readahead-compacting-file_ra_state include/linux/fs.h
--- a/include/linux/fs.h~readahead-compacting-file_ra_state
+++ a/include/linux/fs.h
@@ -697,12 +697,12 @@ struct fown_struct {
  * Track a single file's readahead state
  */
 struct file_ra_state {
-	pgoff_t start;                  /* where readahead started */
-	unsigned long size;             /* # of readahead pages */
-	unsigned long async_size;       /* do asynchronous readahead when
+	pgoff_t start;			/* where readahead started */
+	unsigned int size;		/* # of readahead pages */
+	unsigned int async_size;	/* do asynchronous readahead when
 					   there are only # of pages ahead */
 
-	unsigned long ra_pages;		/* Maximum readahead window */
+	unsigned int ra_pages;		/* Maximum readahead window */
 	unsigned long mmap_hit;		/* Cache hit stat for mmap accesses */
 	unsigned long mmap_miss;	/* Cache miss stat for mmap accesses */
 	unsigned long prev_index;	/* Cache last read() position */
diff -puN mm/readahead.c~readahead-compacting-file_ra_state mm/readahead.c
--- a/mm/readahead.c~readahead-compacting-file_ra_state
+++ a/mm/readahead.c
@@ -351,7 +351,7 @@ ondemand_readahead(struct address_space 
 		   bool hit_readahead_marker, pgoff_t offset,
 		   unsigned long req_size)
 {
-	unsigned long max;	/* max readahead pages */
+	int max;	/* max readahead pages */
 	int sequential;
 
 	max = ra->ra_pages;
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
