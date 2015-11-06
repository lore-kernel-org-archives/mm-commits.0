From: akpm@linux-foundation.org
Subject: [merged]
 fs-global-sync-to-not-clear-error-status-of-individual-inodes.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:08:16 -0800
Message-ID: <563d08b0./883hhiVZVqdawWv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033689AbbKFUIR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:08:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: j-nomura@ce.jp.nec.com, ak@linux.intel.com, david@fromorbit.com, fengguang.wu@gmail.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap.c: make global sync not clear error status of individual inodes
has been removed from the -mm tree.  Its filename was
     fs-global-sync-to-not-clear-error-status-of-individual-inodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: mm/filemap.c: make global sync not clear error status of individual inodes

filemap_fdatawait() is a function to wait for on-going writeback to
complete but also consume and clear error status of the mapping set during
writeback.

The latter functionality is critical for applications to detect writeback
error with system calls like fsync(2)/fdatasync(2).

However filemap_fdatawait() is also used by sync(2) or FIFREEZE ioctl,
which don't check error status of individual mappings.

As a result, fsync() may not be able to detect writeback error if events
happen in the following order:

   Application                    System admin
   ----------------------------------------------------------
   write data on page cache
                                  Run sync command
                                  writeback completes with error
                                  filemap_fdatawait() clears error
   fsync returns success
   (but the data is not on disk)

This patch adds filemap_fdatawait_keep_errors() for call sites where
writeback error is not handled so that they don't clear error status.

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: Fengguang Wu <fengguang.wu@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c  |    7 +++-
 fs/sync.c          |    7 +++-
 include/linux/fs.h |    1 
 mm/filemap.c       |   67 ++++++++++++++++++++++++++++++++++---------
 4 files changed, 67 insertions(+), 15 deletions(-)

diff -puN fs/fs-writeback.c~fs-global-sync-to-not-clear-error-status-of-individual-inodes fs/fs-writeback.c
--- a/fs/fs-writeback.c~fs-global-sync-to-not-clear-error-status-of-individual-inodes
+++ a/fs/fs-writeback.c
@@ -2149,7 +2149,12 @@ static void wait_sb_inodes(struct super_
 		iput(old_inode);
 		old_inode = inode;
 
-		filemap_fdatawait(mapping);
+		/*
+		 * We keep the error status of individual mapping so that
+		 * applications can catch the writeback error using fsync(2).
+		 * See filemap_fdatawait_keep_errors() for details.
+		 */
+		filemap_fdatawait_keep_errors(mapping);
 
 		cond_resched();
 
diff -puN fs/sync.c~fs-global-sync-to-not-clear-error-status-of-individual-inodes fs/sync.c
--- a/fs/sync.c~fs-global-sync-to-not-clear-error-status-of-individual-inodes
+++ a/fs/sync.c
@@ -86,7 +86,12 @@ static void fdatawrite_one_bdev(struct b
 
 static void fdatawait_one_bdev(struct block_device *bdev, void *arg)
 {
-	filemap_fdatawait(bdev->bd_inode->i_mapping);
+	/*
+	 * We keep the error status of individual mapping so that
+	 * applications can catch the writeback error using fsync(2).
+	 * See filemap_fdatawait_keep_errors() for details.
+	 */
+	filemap_fdatawait_keep_errors(bdev->bd_inode->i_mapping);
 }
 
 /*
diff -puN include/linux/fs.h~fs-global-sync-to-not-clear-error-status-of-individual-inodes include/linux/fs.h
--- a/include/linux/fs.h~fs-global-sync-to-not-clear-error-status-of-individual-inodes
+++ a/include/linux/fs.h
@@ -2422,6 +2422,7 @@ extern int write_inode_now(struct inode
 extern int filemap_fdatawrite(struct address_space *);
 extern int filemap_flush(struct address_space *);
 extern int filemap_fdatawait(struct address_space *);
+extern void filemap_fdatawait_keep_errors(struct address_space *);
 extern int filemap_fdatawait_range(struct address_space *, loff_t lstart,
 				   loff_t lend);
 extern int filemap_write_and_wait(struct address_space *mapping);
diff -puN mm/filemap.c~fs-global-sync-to-not-clear-error-status-of-individual-inodes mm/filemap.c
--- a/mm/filemap.c~fs-global-sync-to-not-clear-error-status-of-individual-inodes
+++ a/mm/filemap.c
@@ -331,23 +331,14 @@ int filemap_flush(struct address_space *
 }
 EXPORT_SYMBOL(filemap_flush);
 
-/**
- * filemap_fdatawait_range - wait for writeback to complete
- * @mapping:		address space structure to wait for
- * @start_byte:		offset in bytes where the range starts
- * @end_byte:		offset in bytes where the range ends (inclusive)
- *
- * Walk the list of under-writeback pages of the given address space
- * in the given range and wait for all of them.
- */
-int filemap_fdatawait_range(struct address_space *mapping, loff_t start_byte,
-			    loff_t end_byte)
+static int __filemap_fdatawait_range(struct address_space *mapping,
+				     loff_t start_byte, loff_t end_byte)
 {
 	pgoff_t index = start_byte >> PAGE_CACHE_SHIFT;
 	pgoff_t end = end_byte >> PAGE_CACHE_SHIFT;
 	struct pagevec pvec;
 	int nr_pages;
-	int ret2, ret = 0;
+	int ret = 0;
 
 	if (end_byte < start_byte)
 		goto out;
@@ -374,6 +365,29 @@ int filemap_fdatawait_range(struct addre
 		cond_resched();
 	}
 out:
+	return ret;
+}
+
+/**
+ * filemap_fdatawait_range - wait for writeback to complete
+ * @mapping:		address space structure to wait for
+ * @start_byte:		offset in bytes where the range starts
+ * @end_byte:		offset in bytes where the range ends (inclusive)
+ *
+ * Walk the list of under-writeback pages of the given address space
+ * in the given range and wait for all of them.  Check error status of
+ * the address space and return it.
+ *
+ * Since the error status of the address space is cleared by this function,
+ * callers are responsible for checking the return value and handling and/or
+ * reporting the error.
+ */
+int filemap_fdatawait_range(struct address_space *mapping, loff_t start_byte,
+			    loff_t end_byte)
+{
+	int ret, ret2;
+
+	ret = __filemap_fdatawait_range(mapping, start_byte, end_byte);
 	ret2 = filemap_check_errors(mapping);
 	if (!ret)
 		ret = ret2;
@@ -383,11 +397,38 @@ out:
 EXPORT_SYMBOL(filemap_fdatawait_range);
 
 /**
+ * filemap_fdatawait_keep_errors - wait for writeback without clearing errors
+ * @mapping: address space structure to wait for
+ *
+ * Walk the list of under-writeback pages of the given address space
+ * and wait for all of them.  Unlike filemap_fdatawait(), this function
+ * does not clear error status of the address space.
+ *
+ * Use this function if callers don't handle errors themselves.  Expected
+ * call sites are system-wide / filesystem-wide data flushers: e.g. sync(2),
+ * fsfreeze(8)
+ */
+void filemap_fdatawait_keep_errors(struct address_space *mapping)
+{
+	loff_t i_size = i_size_read(mapping->host);
+
+	if (i_size == 0)
+		return;
+
+	__filemap_fdatawait_range(mapping, 0, i_size - 1);
+}
+
+/**
  * filemap_fdatawait - wait for all under-writeback pages to complete
  * @mapping: address space structure to wait for
  *
  * Walk the list of under-writeback pages of the given address space
- * and wait for all of them.
+ * and wait for all of them.  Check error status of the address space
+ * and return it.
+ *
+ * Since the error status of the address space is cleared by this function,
+ * callers are responsible for checking the return value and handling and/or
+ * reporting the error.
  */
 int filemap_fdatawait(struct address_space *mapping)
 {
_

Patches currently in -mm which might be from j-nomura@ce.jp.nec.com are


