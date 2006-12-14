From: akpm@osdl.org
Subject: - optimize-o_direct-on-block-device-v3.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:08:38 -0800
Message-ID: <200612140608.kBE68cAE001955@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52127 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbWLNGJR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:09:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenneth.w.chen@intel.com, hch@lst.de, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     optimize o_direct on block devices
has been removed from the -mm tree.  Its filename was
     optimize-o_direct-on-block-device-v3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: optimize o_direct on block devices
From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>

Implement block device specific .direct_IO method instead of going through
generic direct_io_worker for block device.

direct_io_worker() is fairly complex because it needs to handle O_DIRECT on
file system, where it needs to perform block allocation, hole detection,
extents file on write, and tons of other corner cases.  The end result is
that it takes tons of CPU time to submit an I/O.

For block device, the block allocation is much simpler and a tight triple
loop can be written to iterate each iovec and each page within the iovec in
order to construct/prepare bio structure and then subsequently submit it to
the block layer.  This significantly speeds up O_D on block device.

[akpm@osdl.org: small speedup]
Signed-off-by: Ken Chen <kenneth.w.chen@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/bio.c            |    2 
 fs/block_dev.c      |  204 ++++++++++++++++++++++++++++++++++++------
 include/linux/aio.h |    1 
 include/linux/bio.h |    1 
 4 files changed, 179 insertions(+), 29 deletions(-)

diff -puN fs/bio.c~optimize-o_direct-on-block-device-v3 fs/bio.c
--- a/fs/bio.c~optimize-o_direct-on-block-device-v3
+++ a/fs/bio.c
@@ -916,7 +916,7 @@ void bio_set_pages_dirty(struct bio *bio
 	}
 }
 
-static void bio_release_pages(struct bio *bio)
+void bio_release_pages(struct bio *bio)
 {
 	struct bio_vec *bvec = bio->bi_io_vec;
 	int i;
diff -puN fs/block_dev.c~optimize-o_direct-on-block-device-v3 fs/block_dev.c
--- a/fs/block_dev.c~optimize-o_direct-on-block-device-v3
+++ a/fs/block_dev.c
@@ -129,43 +129,191 @@ blkdev_get_block(struct inode *inode, se
 	return 0;
 }
 
-static int
-blkdev_get_blocks(struct inode *inode, sector_t iblock,
-		struct buffer_head *bh, int create)
-{
-	sector_t end_block = max_block(I_BDEV(inode));
-	unsigned long max_blocks = bh->b_size >> inode->i_blkbits;
-
-	if ((iblock + max_blocks) > end_block) {
-		max_blocks = end_block - iblock;
-		if ((long)max_blocks <= 0) {
-			if (create)
-				return -EIO;	/* write fully beyond EOF */
-			/*
-			 * It is a read which is fully beyond EOF.  We return
-			 * a !buffer_mapped buffer
-			 */
-			max_blocks = 0;
-		}
+static int blk_end_aio(struct bio *bio, unsigned int bytes_done, int error)
+{
+	struct kiocb *iocb = bio->bi_private;
+	atomic_t *bio_count = &iocb->ki_bio_count;
+
+	if (bio_data_dir(bio) == READ)
+		bio_check_pages_dirty(bio);
+	else {
+		bio_release_pages(bio);
+		bio_put(bio);
+	}
+
+	/* iocb->ki_nbytes stores error code from LLDD */
+	if (error)
+		iocb->ki_nbytes = -EIO;
+
+	if (atomic_dec_and_test(bio_count)) {
+		if (iocb->ki_nbytes < 0)
+			aio_complete(iocb, iocb->ki_nbytes, 0);
+		else
+			aio_complete(iocb, iocb->ki_left, 0);
 	}
 
-	bh->b_bdev = I_BDEV(inode);
-	bh->b_blocknr = iblock;
-	bh->b_size = max_blocks << inode->i_blkbits;
-	if (max_blocks)
-		set_buffer_mapped(bh);
 	return 0;
 }
 
+#define VEC_SIZE	16
+struct pvec {
+	unsigned short nr;
+	unsigned short idx;
+	struct page *page[VEC_SIZE];
+};
+
+#define PAGES_SPANNED(addr, len)	\
+	(DIV_ROUND_UP((addr) + (len), PAGE_SIZE) - (addr) / PAGE_SIZE);
+
+/*
+ * get page pointer for user addr, we internally cache struct page array for
+ * (addr, count) range in pvec to avoid frequent call to get_user_pages.  If
+ * internal page list is exhausted, a batch count of up to VEC_SIZE is used
+ * to get next set of page struct.
+ */
+static struct page *blk_get_page(unsigned long addr, size_t count, int rw,
+				 struct pvec *pvec)
+{
+	int ret, nr_pages;
+	if (pvec->idx == pvec->nr) {
+		nr_pages = PAGES_SPANNED(addr, count);
+		nr_pages = min(nr_pages, VEC_SIZE);
+		down_read(&current->mm->mmap_sem);
+		ret = get_user_pages(current, current->mm, addr, nr_pages,
+				     rw == READ, 0, pvec->page, NULL);
+		up_read(&current->mm->mmap_sem);
+		if (ret < 0)
+			return ERR_PTR(ret);
+		pvec->nr = ret;
+		pvec->idx = 0;
+	}
+	return pvec->page[pvec->idx++];
+}
+
 static ssize_t
 blkdev_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-			loff_t offset, unsigned long nr_segs)
+		 loff_t pos, unsigned long nr_segs)
 {
-	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_mapping->host;
+	struct inode *inode = iocb->ki_filp->f_mapping->host;
+	unsigned blkbits = blksize_bits(bdev_hardsect_size(I_BDEV(inode)));
+	unsigned blocksize_mask = (1 << blkbits) - 1;
+	unsigned long seg = 0;	/* iov segment iterator */
+	unsigned long nvec;	/* number of bio vec needed */
+	unsigned long cur_off;	/* offset into current page */
+	unsigned long cur_len;	/* I/O len of current page, up to PAGE_SIZE */
+
+	unsigned long addr;	/* user iovec address */
+	size_t count;		/* user iovec len */
+	size_t nbytes = iocb->ki_nbytes = iocb->ki_left; /* total xfer size */
+	loff_t size;		/* size of block device */
+	struct bio *bio;
+	atomic_t *bio_count = &iocb->ki_bio_count;
+	struct page *page;
+	struct pvec pvec;
+
+	pvec.nr = 0;
+	pvec.idx = 0;
 
-	return blockdev_direct_IO_no_locking(rw, iocb, inode, I_BDEV(inode),
-				iov, offset, nr_segs, blkdev_get_blocks, NULL);
+	if (pos & blocksize_mask)
+		return -EINVAL;
+
+	size = i_size_read(inode);
+	if (pos + nbytes > size) {
+		nbytes = size - pos;
+		iocb->ki_left = nbytes;
+	}
+
+	/*
+	 * check first non-zero iov alignment, the remaining
+	 * iov alignment is checked inside bio loop below.
+	 */
+	do {
+		addr = (unsigned long) iov[seg].iov_base;
+		count = min(iov[seg].iov_len, nbytes);
+		if (addr & blocksize_mask || count & blocksize_mask)
+			return -EINVAL;
+	} while (!count && ++seg < nr_segs);
+	atomic_set(bio_count, 1);
+
+	while (nbytes) {
+		/* roughly estimate number of bio vec needed */
+		nvec = (nbytes + PAGE_SIZE - 1) / PAGE_SIZE;
+		nvec = max(nvec, nr_segs - seg);
+		nvec = min(nvec, (unsigned long) BIO_MAX_PAGES);
+
+		/* bio_alloc should not fail with GFP_KERNEL flag */
+		bio = bio_alloc(GFP_KERNEL, nvec);
+		bio->bi_bdev = I_BDEV(inode);
+		bio->bi_end_io = blk_end_aio;
+		bio->bi_private = iocb;
+		bio->bi_sector = pos >> blkbits;
+same_bio:
+		cur_off = addr & ~PAGE_MASK;
+		cur_len = PAGE_SIZE - cur_off;
+		if (count < cur_len)
+			cur_len = count;
+
+		page = blk_get_page(addr, count, rw, &pvec);
+		if (unlikely(IS_ERR(page)))
+			goto backout;
+
+		if (bio_add_page(bio, page, cur_len, cur_off)) {
+			pos += cur_len;
+			addr += cur_len;
+			count -= cur_len;
+			nbytes -= cur_len;
+
+			if (count)
+				goto same_bio;
+			while (++seg < nr_segs) {
+				addr = (unsigned long) iov[seg].iov_base;
+				count = iov[seg].iov_len;
+				if (!count)
+					continue;
+				if (unlikely(addr & blocksize_mask ||
+					     count & blocksize_mask)) {
+					page = ERR_PTR(-EINVAL);
+					goto backout;
+				}
+				count = min(count, nbytes);
+				goto same_bio;
+			}
+		}
+
+		/* bio is ready, submit it */
+		if (rw == READ)
+			bio_set_pages_dirty(bio);
+		atomic_inc(bio_count);
+		submit_bio(rw, bio);
+	}
+
+completion:
+	iocb->ki_left -= nbytes;
+	nbytes = iocb->ki_left;
+	iocb->ki_pos += nbytes;
+
+	blk_run_address_space(inode->i_mapping);
+	if (atomic_dec_and_test(bio_count))
+		aio_complete(iocb, nbytes, 0);
+
+	return -EIOCBQUEUED;
+
+backout:
+	/*
+	 * back out nbytes count constructed so far for this bio,
+	 * we will throw away current bio.
+	 */
+	nbytes += bio->bi_size;
+	bio_release_pages(bio);
+	bio_put(bio);
+
+	/*
+	 * if no bio was submmitted, return the error code.
+	 * otherwise, proceed with pending I/O completion.
+	 */
+	if (atomic_read(bio_count) == 1)
+		return PTR_ERR(page);
+	goto completion;
 }
 
 static int blkdev_writepage(struct page *page, struct writeback_control *wbc)
diff -puN include/linux/aio.h~optimize-o_direct-on-block-device-v3 include/linux/aio.h
--- a/include/linux/aio.h~optimize-o_direct-on-block-device-v3
+++ a/include/linux/aio.h
@@ -105,6 +105,7 @@ struct kiocb {
 	wait_queue_t		ki_wait;
 	loff_t			ki_pos;
 
+	atomic_t		ki_bio_count;	/* num bio used for this iocb */
 	void			*private;
 	/* State that we remember to be able to restart/retry  */
 	unsigned short		ki_opcode;
diff -puN include/linux/bio.h~optimize-o_direct-on-block-device-v3 include/linux/bio.h
--- a/include/linux/bio.h~optimize-o_direct-on-block-device-v3
+++ a/include/linux/bio.h
@@ -309,6 +309,7 @@ extern struct bio *bio_map_kern(struct r
 				gfp_t);
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
+extern void bio_release_pages(struct bio *bio);
 extern struct bio *bio_copy_user(struct request_queue *, unsigned long, unsigned int, int);
 extern int bio_uncopy_user(struct bio *);
 void zero_fill_bio(struct bio *bio);
_

Patches currently in -mm which might be from kenneth.w.chen@intel.com are

mm-only-sched-add-a-few-scheduler-event-counters.patch

