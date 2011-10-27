From: akpm@linux-foundation.org
Subject: [merged] loop-remove-the-incorrect-write_begin-write_end-shortcut.patch removed from -mm tree
Date: Thu, 27 Oct 2011 16:08:32 -0700
Message-ID: <201110272308.p9RN8WXa017235@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:22364 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab1J0XIw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2011 19:08:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@infradead.org, axboe@kernel.dk, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Subject: loop: remove the incorrect write_begin/write_end shortcut
has been removed from the -mm tree.  Its filename was
     loop-remove-the-incorrect-write_begin-write_end-shortcut.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Christoph Hellwig <hch@infradead.org>
Subject: loop: remove the incorrect write_begin/write_end shortcut

Currently the loop device tries to call directly into
write_begin/write_end instead of going through ->write if it can.  This is
a fairly nasty shortcut as write_begin and write_end are only callbacks
for the generic write code and expect to be called with filesystem
specific locks held.

This code currently causes various issues for clustered filesystems as it
doesn't take the required cluster locks, and it also causes issues for XFS
as it doesn't properly lock against the swapext ioctl as called by the
defragmentation tools.  This in case causes data corruption if
defragmentation hits a busy loop device in the wrong time window, as
reported by RH QA.

The reason why we have this shortcut is that it saves a data copy when
doing a transformation on the loop device, which is the technical term for
using cryptoloop (or an XOR transformation).  Given that cryptoloop has
been deprecated in favour of dm-crypt my opinion is that we should simply
drop this shortcut instead of finding complicated ways to to introduce a
formal interface for this shortcut.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |  135 ++++++-----------------------------------
 include/linux/loop.h |    1 
 2 files changed, 23 insertions(+), 113 deletions(-)

diff -puN drivers/block/loop.c~loop-remove-the-incorrect-write_begin-write_end-shortcut drivers/block/loop.c
--- a/drivers/block/loop.c~loop-remove-the-incorrect-write_begin-write_end-shortcut
+++ a/drivers/block/loop.c
@@ -215,74 +215,6 @@ lo_do_transfer(struct loop_device *lo, i
 }
 
 /**
- * do_lo_send_aops - helper for writing data to a loop device
- *
- * This is the fast version for backing filesystems which implement the address
- * space operations write_begin and write_end.
- */
-static int do_lo_send_aops(struct loop_device *lo, struct bio_vec *bvec,
-		loff_t pos, struct page *unused)
-{
-	struct file *file = lo->lo_backing_file; /* kudos to NFsckingS */
-	struct address_space *mapping = file->f_mapping;
-	pgoff_t index;
-	unsigned offset, bv_offs;
-	int len, ret;
-
-	mutex_lock(&mapping->host->i_mutex);
-	index = pos >> PAGE_CACHE_SHIFT;
-	offset = pos & ((pgoff_t)PAGE_CACHE_SIZE - 1);
-	bv_offs = bvec->bv_offset;
-	len = bvec->bv_len;
-	while (len > 0) {
-		sector_t IV;
-		unsigned size, copied;
-		int transfer_result;
-		struct page *page;
-		void *fsdata;
-
-		IV = ((sector_t)index << (PAGE_CACHE_SHIFT - 9))+(offset >> 9);
-		size = PAGE_CACHE_SIZE - offset;
-		if (size > len)
-			size = len;
-
-		ret = pagecache_write_begin(file, mapping, pos, size, 0,
-							&page, &fsdata);
-		if (ret)
-			goto fail;
-
-		file_update_time(file);
-
-		transfer_result = lo_do_transfer(lo, WRITE, page, offset,
-				bvec->bv_page, bv_offs, size, IV);
-		copied = size;
-		if (unlikely(transfer_result))
-			copied = 0;
-
-		ret = pagecache_write_end(file, mapping, pos, size, copied,
-							page, fsdata);
-		if (ret < 0 || ret != copied)
-			goto fail;
-
-		if (unlikely(transfer_result))
-			goto fail;
-
-		bv_offs += copied;
-		len -= copied;
-		offset = 0;
-		index++;
-		pos += copied;
-	}
-	ret = 0;
-out:
-	mutex_unlock(&mapping->host->i_mutex);
-	return ret;
-fail:
-	ret = -1;
-	goto out;
-}
-
-/**
  * __do_lo_send_write - helper for writing data to a loop device
  *
  * This helper just factors out common code between do_lo_send_direct_write()
@@ -309,10 +241,8 @@ static int __do_lo_send_write(struct fil
 /**
  * do_lo_send_direct_write - helper for writing data to a loop device
  *
- * This is the fast, non-transforming version for backing filesystems which do
- * not implement the address space operations write_begin and write_end.
- * It uses the write file operation which should be present on all writeable
- * filesystems.
+ * This is the fast, non-transforming version that does not need double
+ * buffering.
  */
 static int do_lo_send_direct_write(struct loop_device *lo,
 		struct bio_vec *bvec, loff_t pos, struct page *page)
@@ -328,15 +258,9 @@ static int do_lo_send_direct_write(struc
 /**
  * do_lo_send_write - helper for writing data to a loop device
  *
- * This is the slow, transforming version for filesystems which do not
- * implement the address space operations write_begin and write_end.  It
- * uses the write file operation which should be present on all writeable
- * filesystems.
- *
- * Using fops->write is slower than using aops->{prepare,commit}_write in the
- * transforming case because we need to double buffer the data as we cannot do
- * the transformations in place as we do not have direct access to the
- * destination pages of the backing file.
+ * This is the slow, transforming version that needs to double buffer the
+ * data as it cannot do the transformations in place without having direct
+ * access to the destination pages of the backing file.
  */
 static int do_lo_send_write(struct loop_device *lo, struct bio_vec *bvec,
 		loff_t pos, struct page *page)
@@ -362,17 +286,16 @@ static int lo_send(struct loop_device *l
 	struct page *page = NULL;
 	int i, ret = 0;
 
-	do_lo_send = do_lo_send_aops;
-	if (!(lo->lo_flags & LO_FLAGS_USE_AOPS)) {
+	if (lo->transfer != transfer_none) {
+		page = alloc_page(GFP_NOIO | __GFP_HIGHMEM);
+		if (unlikely(!page))
+			goto fail;
+		kmap(page);
+		do_lo_send = do_lo_send_write;
+	} else {
 		do_lo_send = do_lo_send_direct_write;
-		if (lo->transfer != transfer_none) {
-			page = alloc_page(GFP_NOIO | __GFP_HIGHMEM);
-			if (unlikely(!page))
-				goto fail;
-			kmap(page);
-			do_lo_send = do_lo_send_write;
-		}
 	}
+
 	bio_for_each_segment(bvec, bio, i) {
 		ret = do_lo_send(lo, bvec, pos, page);
 		if (ret < 0)
@@ -922,35 +845,23 @@ static int loop_set_fd(struct loop_devic
 	mapping = file->f_mapping;
 	inode = mapping->host;
 
-	if (!(file->f_mode & FMODE_WRITE))
-		lo_flags |= LO_FLAGS_READ_ONLY;
-
 	error = -EINVAL;
-	if (S_ISREG(inode->i_mode) || S_ISBLK(inode->i_mode)) {
-		const struct address_space_operations *aops = mapping->a_ops;
-
-		if (aops->write_begin)
-			lo_flags |= LO_FLAGS_USE_AOPS;
-		if (!(lo_flags & LO_FLAGS_USE_AOPS) && !file->f_op->write)
-			lo_flags |= LO_FLAGS_READ_ONLY;
+	if (!S_ISREG(inode->i_mode) && !S_ISBLK(inode->i_mode))
+		goto out_putf;
 
-		lo_blocksize = S_ISBLK(inode->i_mode) ?
-			inode->i_bdev->bd_block_size : PAGE_SIZE;
+	if (!(file->f_mode & FMODE_WRITE) || !(mode & FMODE_WRITE) ||
+	    !file->f_op->write)
+		lo_flags |= LO_FLAGS_READ_ONLY;
 
-		error = 0;
-	} else {
-		goto out_putf;
-	}
+	lo_blocksize = S_ISBLK(inode->i_mode) ?
+		inode->i_bdev->bd_block_size : PAGE_SIZE;
 
+	error = -EFBIG;
 	size = get_loop_size(lo, file);
-
-	if ((loff_t)(sector_t)size != size) {
-		error = -EFBIG;
+	if ((loff_t)(sector_t)size != size)
 		goto out_putf;
-	}
 
-	if (!(mode & FMODE_WRITE))
-		lo_flags |= LO_FLAGS_READ_ONLY;
+	error = 0;
 
 	set_device_ro(bdev, (lo_flags & LO_FLAGS_READ_ONLY) != 0);
 
diff -puN include/linux/loop.h~loop-remove-the-incorrect-write_begin-write_end-shortcut include/linux/loop.h
--- a/include/linux/loop.h~loop-remove-the-incorrect-write_begin-write_end-shortcut
+++ a/include/linux/loop.h
@@ -73,7 +73,6 @@ struct loop_device {
  */
 enum {
 	LO_FLAGS_READ_ONLY	= 1,
-	LO_FLAGS_USE_AOPS	= 2,
 	LO_FLAGS_AUTOCLEAR	= 4,
 	LO_FLAGS_PARTSCAN	= 8,
 };
_

Patches currently in -mm which might be from hch@infradead.org are

origin.patch
linux-next.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch
xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch
ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch
mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch

