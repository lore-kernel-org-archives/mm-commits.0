From: akpm@linux-foundation.org
Subject: [merged] dax-add-dax_zero_page_range.patch removed from -mm tree
Date: Tue, 17 Feb 2015 12:06:02 -0800
Message-ID: <54e39f2a.VKiEtVeIJGBbsyst%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35279 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbbBQUGD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 15:06:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew.r.wilcox@intel.com, andreas.dilger@intel.com, axboe@kernel.dk, boaz@plexistor.com, david@fromorbit.com, hch@lst.de, jack@suse.cz, kirill.shutemov@linux.intel.com, mathieu.desnoyers@efficios.com, rdunlap@infradead.org, ross.zwisler@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: add dax_zero_page_range
has been removed from the -mm tree.  Its filename was
     dax-add-dax_zero_page_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: dax: add dax_zero_page_range

This new function allows us to support hole-punch for DAX files by zeroing
a partial page, as opposed to the dax_truncate_page() function which can
only truncate to the end of the page.  Reimplement dax_truncate_page() to
call dax_zero_page_range().

[ross.zwisler@linux.intel.com: ported to 3.13-rc2]
[akpm@linux-foundation.org: fix typos in comments]
Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Boaz Harrosh <boaz@plexistor.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/dax.txt |    1 
 fs/dax.c                          |   38 +++++++++++++++++++++++-----
 include/linux/fs.h                |    1 
 3 files changed, 34 insertions(+), 6 deletions(-)

diff -puN Documentation/filesystems/dax.txt~dax-add-dax_zero_page_range Documentation/filesystems/dax.txt
--- a/Documentation/filesystems/dax.txt~dax-add-dax_zero_page_range
+++ a/Documentation/filesystems/dax.txt
@@ -62,6 +62,7 @@ Filesystem support consists of
   for fault and page_mkwrite (which should probably call dax_fault() and
   dax_mkwrite(), passing the appropriate get_block() callback)
 - calling dax_truncate_page() instead of block_truncate_page() for DAX files
+- calling dax_zero_page_range() instead of zero_user() for DAX files
 - ensuring that there is sufficient locking between reads, writes,
   truncates and page faults
 
diff -puN fs/dax.c~dax-add-dax_zero_page_range fs/dax.c
--- a/fs/dax.c~dax-add-dax_zero_page_range
+++ a/fs/dax.c
@@ -464,31 +464,35 @@ int dax_fault(struct vm_area_struct *vma
 EXPORT_SYMBOL_GPL(dax_fault);
 
 /**
- * dax_truncate_page - handle a partial page being truncated in a DAX file
+ * dax_zero_page_range - zero a range within a page of a DAX file
  * @inode: The file being truncated
  * @from: The file offset that is being truncated to
+ * @length: The number of bytes to zero
  * @get_block: The filesystem method used to translate file offsets to blocks
  *
- * Similar to block_truncate_page(), this function can be called by a
- * filesystem when it is truncating an DAX file to handle the partial page.
+ * This function can be called by a filesystem when it is zeroing part of a
+ * page in a DAX file.  This is intended for hole-punch operations.  If
+ * you are truncating a file, the helper function dax_truncate_page() may be
+ * more convenient.
  *
  * We work in terms of PAGE_CACHE_SIZE here for commonality with
  * block_truncate_page(), but we could go down to PAGE_SIZE if the filesystem
  * took care of disposing of the unnecessary blocks.  Even if the filesystem
  * block size is smaller than PAGE_SIZE, we have to zero the rest of the page
- * since the file might be mmaped.
+ * since the file might be mmapped.
  */
-int dax_truncate_page(struct inode *inode, loff_t from, get_block_t get_block)
+int dax_zero_page_range(struct inode *inode, loff_t from, unsigned length,
+							get_block_t get_block)
 {
 	struct buffer_head bh;
 	pgoff_t index = from >> PAGE_CACHE_SHIFT;
 	unsigned offset = from & (PAGE_CACHE_SIZE-1);
-	unsigned length = PAGE_CACHE_ALIGN(from) - from;
 	int err;
 
 	/* Block boundary? Nothing to do */
 	if (!length)
 		return 0;
+	BUG_ON((offset + length) > PAGE_CACHE_SIZE);
 
 	memset(&bh, 0, sizeof(bh));
 	bh.b_size = PAGE_CACHE_SIZE;
@@ -505,4 +509,26 @@ int dax_truncate_page(struct inode *inod
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(dax_zero_page_range);
+
+/**
+ * dax_truncate_page - handle a partial page being truncated in a DAX file
+ * @inode: The file being truncated
+ * @from: The file offset that is being truncated to
+ * @get_block: The filesystem method used to translate file offsets to blocks
+ *
+ * Similar to block_truncate_page(), this function can be called by a
+ * filesystem when it is truncating a DAX file to handle the partial page.
+ *
+ * We work in terms of PAGE_CACHE_SIZE here for commonality with
+ * block_truncate_page(), but we could go down to PAGE_SIZE if the filesystem
+ * took care of disposing of the unnecessary blocks.  Even if the filesystem
+ * block size is smaller than PAGE_SIZE, we have to zero the rest of the page
+ * since the file might be mmapped.
+ */
+int dax_truncate_page(struct inode *inode, loff_t from, get_block_t get_block)
+{
+	unsigned length = PAGE_CACHE_ALIGN(from) - from;
+	return dax_zero_page_range(inode, from, length, get_block);
+}
 EXPORT_SYMBOL_GPL(dax_truncate_page);
diff -puN include/linux/fs.h~dax-add-dax_zero_page_range include/linux/fs.h
--- a/include/linux/fs.h~dax-add-dax_zero_page_range
+++ a/include/linux/fs.h
@@ -2589,6 +2589,7 @@ extern int nonseekable_open(struct inode
 ssize_t dax_do_io(int rw, struct kiocb *, struct inode *, struct iov_iter *,
 		loff_t, get_block_t, dio_iodone_t, int flags);
 int dax_clear_blocks(struct inode *, sector_t block, long size);
+int dax_zero_page_range(struct inode *, loff_t from, unsigned len, get_block_t);
 int dax_truncate_page(struct inode *, loff_t from, get_block_t);
 int dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t);
 #define dax_mkwrite(vma, vmf, gb)	dax_fault(vma, vmf, gb)
_

Patches currently in -mm which might be from matthew.r.wilcox@intel.com are

origin.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

