From: akpm@osdl.org
Subject: + fsaio-aio-o_sync-filesystem-write.patch added to -mm tree
Date: Wed, 10 Jan 2007 23:21:30 -0800
Message-ID: <200701110721.l0B7LUXb019308@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38191 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965319AbXAKHWG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jan 2007 02:22:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: suparna@in.ibm.com, mingo@elte.hu


The patch titled
     fsaio: AIO O_SYNC filesystem write
has been added to the -mm tree.  Its filename is
     fsaio-aio-o_sync-filesystem-write.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fsaio: AIO O_SYNC filesystem write
From: Suparna Bhattacharya <suparna@in.ibm.com>

AIO support for O_SYNC buffered writes, built over O_SYNC-speedup.  It uses
the tagged radix tree lookups to writeout just the pages pertaining to this
request, and retries instead of blocking for writeback to complete on the same
range.  All the writeout is issued at the time of io submission, and there is
a check to make sure that retries skip over straight to the
wait_on_page_writeback_range.

Limitations: Extending file writes or hole overwrites with O_SYNC may still
block because we have yet to convert generic_osync_inode to be asynchronous. 
For non O_SYNC writes, writeout happens in the background and so typically
appears async to the caller except for memory throttling and non-block aligned
writes involving read-modify-write.

Signed-off-by: Suparna Bhattacharya <suparna@in.ibm.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/fs.h |   13 ++++++++-
 mm/filemap.c       |   59 +++++++++++++++++++++++++++++--------------
 2 files changed, 52 insertions(+), 20 deletions(-)

diff -puN include/linux/fs.h~fsaio-aio-o_sync-filesystem-write include/linux/fs.h
--- a/include/linux/fs.h~fsaio-aio-o_sync-filesystem-write
+++ a/include/linux/fs.h
@@ -280,6 +280,7 @@ extern int dir_notify_enable;
 #include <linux/prio_tree.h>
 #include <linux/init.h>
 #include <linux/pid.h>
+#include <linux/sched.h>
 #include <linux/mutex.h>
 
 #include <asm/atomic.h>
@@ -1595,8 +1596,16 @@ extern int filemap_fdatawait(struct addr
 extern int filemap_write_and_wait(struct address_space *mapping);
 extern int filemap_write_and_wait_range(struct address_space *mapping,
 				        loff_t lstart, loff_t lend);
-extern int wait_on_page_writeback_range(struct address_space *mapping,
-				pgoff_t start, pgoff_t end);
+extern int __wait_on_page_writeback_range(struct address_space *mapping,
+				pgoff_t start, pgoff_t end, wait_queue_t *wait);
+
+static inline int wait_on_page_writeback_range(struct address_space *mapping,
+				pgoff_t start, pgoff_t end)
+{
+	return __wait_on_page_writeback_range(mapping, start, end,
+		&current->__wait.wait);
+}
+
 extern int __filemap_fdatawrite_range(struct address_space *mapping,
 				loff_t start, loff_t end, int sync_mode);
 
diff -puN mm/filemap.c~fsaio-aio-o_sync-filesystem-write mm/filemap.c
--- a/mm/filemap.c~fsaio-aio-o_sync-filesystem-write
+++ a/mm/filemap.c
@@ -209,10 +209,11 @@ EXPORT_SYMBOL(filemap_flush);
  * @end:	ending page index
  *
  * Wait for writeback to complete against pages indexed by start->end
- * inclusive
+ * inclusive. In AIO context, this may queue an async notification
+ * and retry callback and return, instead of blocking the caller.
  */
-int wait_on_page_writeback_range(struct address_space *mapping,
-				pgoff_t start, pgoff_t end)
+int __wait_on_page_writeback_range(struct address_space *mapping,
+				pgoff_t start, pgoff_t end, wait_queue_t *wait)
 {
 	struct pagevec pvec;
 	int nr_pages;
@@ -224,20 +225,20 @@ int wait_on_page_writeback_range(struct 
 
 	pagevec_init(&pvec, 0);
 	index = start;
-	while ((index <= end) &&
+	while (!ret && (index <= end) &&
 			(nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
 			PAGECACHE_TAG_WRITEBACK,
 			min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1)) != 0) {
 		unsigned i;
 
-		for (i = 0; i < nr_pages; i++) {
+		for (i = 0; !ret && (i < nr_pages); i++) {
 			struct page *page = pvec.pages[i];
 
 			/* until radix tree lookup accepts end_index */
 			if (page->index > end)
 				continue;
 
-			wait_on_page_writeback(page);
+			ret = __wait_on_page_writeback(page, wait);
 			if (PageError(page))
 				ret = -EIO;
 		}
@@ -273,18 +274,26 @@ int sync_page_range(struct inode *inode,
 {
 	pgoff_t start = pos >> PAGE_CACHE_SHIFT;
 	pgoff_t end = (pos + count - 1) >> PAGE_CACHE_SHIFT;
-	int ret;
+	int ret = 0;
 
 	if (!mapping_cap_writeback_dirty(mapping) || !count)
 		return 0;
+	/* Already issued writeouts for this iocb ? */
+	if (unlikely(aio_restarted())) {
+		goto do_wait; /* just need to check if done */
+	}
 	ret = filemap_fdatawrite_range(mapping, pos, pos + count - 1);
-	if (ret == 0) {
+
+	if (ret >= 0) {
 		mutex_lock(&inode->i_mutex);
 		ret = generic_osync_inode(inode, mapping, OSYNC_METADATA);
 		mutex_unlock(&inode->i_mutex);
 	}
-	if (ret == 0)
-		ret = wait_on_page_writeback_range(mapping, start, end);
+do_wait:
+	if (ret >= 0) {
+		ret = __wait_on_page_writeback_range(mapping, start, end,
+			current->io_wait);
+	}
 	return ret;
 }
 EXPORT_SYMBOL(sync_page_range);
@@ -305,15 +314,22 @@ int sync_page_range_nolock(struct inode 
 {
 	pgoff_t start = pos >> PAGE_CACHE_SHIFT;
 	pgoff_t end = (pos + count - 1) >> PAGE_CACHE_SHIFT;
-	int ret;
+	int ret = 0;
 
 	if (!mapping_cap_writeback_dirty(mapping) || !count)
 		return 0;
+	/* Already issued writeouts for this iocb ? */
+	if (unlikely(aio_restarted())) {
+		goto do_wait; /* just need to check if done */
+	}
 	ret = filemap_fdatawrite_range(mapping, pos, pos + count - 1);
-	if (ret == 0)
+	if (ret >= 0)
 		ret = generic_osync_inode(inode, mapping, OSYNC_METADATA);
-	if (ret == 0)
-		ret = wait_on_page_writeback_range(mapping, start, end);
+do_wait:
+	if (ret >= 0) {
+		ret = __wait_on_page_writeback_range(mapping, start, end,
+			current->io_wait);
+	}
 	return ret;
 }
 EXPORT_SYMBOL(sync_page_range_nolock);
@@ -2177,7 +2193,7 @@ zero_length_segment:
 	 */
 	if (likely(status >= 0)) {
 		if (unlikely((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
-			if (!a_ops->writepage || !is_sync_kiocb(iocb))
+			if (!a_ops->writepage)
 				status = generic_osync_inode(inode, mapping,
 						OSYNC_METADATA|OSYNC_DATA);
 		}
@@ -2229,7 +2245,10 @@ __generic_file_aio_write_nolock(struct k
 		ocount -= iv->iov_len;	/* This segment is no good */
 		break;
 	}
-
+	if (unlikely(aio_restarted())) {
+		/* nothing to transfer, may just need to sync data */
+		return ocount;
+	}
 	count = ocount;
 	pos = *ppos;
 
@@ -2329,8 +2348,10 @@ ssize_t generic_file_aio_write_nolock(st
 		ssize_t err;
 
 		err = sync_page_range_nolock(inode, mapping, pos, ret);
-		if (err < 0)
+		if (err < 0) {
 			ret = err;
+			iocb->ki_pos = pos;
+		}
 	}
 	return ret;
 }
@@ -2355,8 +2376,10 @@ ssize_t generic_file_aio_write(struct ki
 		ssize_t err;
 
 		err = sync_page_range(inode, mapping, pos, ret);
-		if (err < 0)
+		if (err < 0) {
 			ret = err;
+			iocb->ki_pos = pos;
+		}
 	}
 	return ret;
 }
_

Patches currently in -mm which might be from suparna@in.ibm.com are

aio-fix-buggy-put_ioctx-call-in-aio_complete-v2.patch
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine.patch
fsaio-rename-__lock_page-to-lock_page_blocking.patch
fsaio-interfaces-to-initialize-and-to-test-a-wait-bit-key.patch
fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-aio-o_sync-filesystem-write.patch
aio-is-unlikely.patch
