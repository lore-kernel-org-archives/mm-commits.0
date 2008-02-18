From: akpm@linux-foundation.org
Subject: + fs-block_devc-remove-if-0ed-code.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:11:38 -0800
Message-ID: <200802181012.m1IACZAO019585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55678 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755208AbYBRKNa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:13:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, pbadari@us.ibm.com


The patch titled
     fs/block_dev.c: remove #if 0'ed code
has been added to the -mm tree.  Its filename is
     fs-block_devc-remove-if-0ed-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/block_dev.c: remove #if 0'ed code
From: Adrian Bunk <bunk@kernel.org>

Commit b2e895dbd80c420bfc0937c3729b4afe073b3848 #if 0'ed this code stating:

<--  snip  -->

    [PATCH] revert blockdev direct io back to 2.6.19 version

    Andrew Vasquez is reporting as-iosched oopses and a 65% throughput
    slowdown due to the recent special-casing of direct-io against
    blockdevs.  We don't know why either of these things are occurring.

    The patch minimally reverts us back to the 2.6.19 code for a 2.6.20
    release.

<--  snip  -->

It has since been dead code, and unless someone wants to revive it now it's
time to remove it.

This patch also makes bio_release_pages() static again and removes the
ki_bio_count member from struct kiocb, reverting changes that had been done
for this dead code.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bio.c            |    2 
 fs/block_dev.c      |  197 ------------------------------------------
 include/linux/aio.h |    1 
 include/linux/bio.h |    1 
 4 files changed, 1 insertion(+), 200 deletions(-)

diff -puN fs/bio.c~fs-block_devc-remove-if-0ed-code fs/bio.c
--- a/fs/bio.c~fs-block_devc-remove-if-0ed-code
+++ a/fs/bio.c
@@ -903,7 +903,7 @@ void bio_set_pages_dirty(struct bio *bio
 	}
 }
 
-void bio_release_pages(struct bio *bio)
+static void bio_release_pages(struct bio *bio)
 {
 	struct bio_vec *bvec = bio->bi_io_vec;
 	int i;
diff -puN fs/block_dev.c~fs-block_devc-remove-if-0ed-code fs/block_dev.c
--- a/fs/block_dev.c~fs-block_devc-remove-if-0ed-code
+++ a/fs/block_dev.c
@@ -171,203 +171,6 @@ blkdev_direct_IO(int rw, struct kiocb *i
 				iov, offset, nr_segs, blkdev_get_blocks, NULL);
 }
 
-#if 0
-static void blk_end_aio(struct bio *bio, int error)
-{
-	struct kiocb *iocb = bio->bi_private;
-	atomic_t *bio_count = &iocb->ki_bio_count;
-
-	if (bio_data_dir(bio) == READ)
-		bio_check_pages_dirty(bio);
-	else {
-		bio_release_pages(bio);
-		bio_put(bio);
-	}
-
-	/* iocb->ki_nbytes stores error code from LLDD */
-	if (error)
-		iocb->ki_nbytes = -EIO;
-
-	if (atomic_dec_and_test(bio_count)) {
-		if ((long)iocb->ki_nbytes < 0)
-			aio_complete(iocb, iocb->ki_nbytes, 0);
-		else
-			aio_complete(iocb, iocb->ki_left, 0);
-	}
-
-	return 0;
-}
-
-#define VEC_SIZE	16
-struct pvec {
-	unsigned short nr;
-	unsigned short idx;
-	struct page *page[VEC_SIZE];
-};
-
-#define PAGES_SPANNED(addr, len)	\
-	(DIV_ROUND_UP((addr) + (len), PAGE_SIZE) - (addr) / PAGE_SIZE);
-
-/*
- * get page pointer for user addr, we internally cache struct page array for
- * (addr, count) range in pvec to avoid frequent call to get_user_pages.  If
- * internal page list is exhausted, a batch count of up to VEC_SIZE is used
- * to get next set of page struct.
- */
-static struct page *blk_get_page(unsigned long addr, size_t count, int rw,
-				 struct pvec *pvec)
-{
-	int ret, nr_pages;
-	if (pvec->idx == pvec->nr) {
-		nr_pages = PAGES_SPANNED(addr, count);
-		nr_pages = min(nr_pages, VEC_SIZE);
-		down_read(&current->mm->mmap_sem);
-		ret = get_user_pages(current, current->mm, addr, nr_pages,
-				     rw == READ, 0, pvec->page, NULL);
-		up_read(&current->mm->mmap_sem);
-		if (ret < 0)
-			return ERR_PTR(ret);
-		pvec->nr = ret;
-		pvec->idx = 0;
-	}
-	return pvec->page[pvec->idx++];
-}
-
-/* return a page back to pvec array */
-static void blk_unget_page(struct page *page, struct pvec *pvec)
-{
-	pvec->page[--pvec->idx] = page;
-}
-
-static ssize_t
-blkdev_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-		 loff_t pos, unsigned long nr_segs)
-{
-	struct inode *inode = iocb->ki_filp->f_mapping->host;
-	unsigned blkbits = blksize_bits(bdev_hardsect_size(I_BDEV(inode)));
-	unsigned blocksize_mask = (1 << blkbits) - 1;
-	unsigned long seg = 0;	/* iov segment iterator */
-	unsigned long nvec;	/* number of bio vec needed */
-	unsigned long cur_off;	/* offset into current page */
-	unsigned long cur_len;	/* I/O len of current page, up to PAGE_SIZE */
-
-	unsigned long addr;	/* user iovec address */
-	size_t count;		/* user iovec len */
-	size_t nbytes = iocb->ki_nbytes = iocb->ki_left; /* total xfer size */
-	loff_t size;		/* size of block device */
-	struct bio *bio;
-	atomic_t *bio_count = &iocb->ki_bio_count;
-	struct page *page;
-	struct pvec pvec;
-
-	pvec.nr = 0;
-	pvec.idx = 0;
-
-	if (pos & blocksize_mask)
-		return -EINVAL;
-
-	size = i_size_read(inode);
-	if (pos + nbytes > size) {
-		nbytes = size - pos;
-		iocb->ki_left = nbytes;
-	}
-
-	/*
-	 * check first non-zero iov alignment, the remaining
-	 * iov alignment is checked inside bio loop below.
-	 */
-	do {
-		addr = (unsigned long) iov[seg].iov_base;
-		count = min(iov[seg].iov_len, nbytes);
-		if (addr & blocksize_mask || count & blocksize_mask)
-			return -EINVAL;
-	} while (!count && ++seg < nr_segs);
-	atomic_set(bio_count, 1);
-
-	while (nbytes) {
-		/* roughly estimate number of bio vec needed */
-		nvec = (nbytes + PAGE_SIZE - 1) / PAGE_SIZE;
-		nvec = max(nvec, nr_segs - seg);
-		nvec = min(nvec, (unsigned long) BIO_MAX_PAGES);
-
-		/* bio_alloc should not fail with GFP_KERNEL flag */
-		bio = bio_alloc(GFP_KERNEL, nvec);
-		bio->bi_bdev = I_BDEV(inode);
-		bio->bi_end_io = blk_end_aio;
-		bio->bi_private = iocb;
-		bio->bi_sector = pos >> blkbits;
-same_bio:
-		cur_off = addr & ~PAGE_MASK;
-		cur_len = PAGE_SIZE - cur_off;
-		if (count < cur_len)
-			cur_len = count;
-
-		page = blk_get_page(addr, count, rw, &pvec);
-		if (unlikely(IS_ERR(page)))
-			goto backout;
-
-		if (bio_add_page(bio, page, cur_len, cur_off)) {
-			pos += cur_len;
-			addr += cur_len;
-			count -= cur_len;
-			nbytes -= cur_len;
-
-			if (count)
-				goto same_bio;
-			while (++seg < nr_segs) {
-				addr = (unsigned long) iov[seg].iov_base;
-				count = iov[seg].iov_len;
-				if (!count)
-					continue;
-				if (unlikely(addr & blocksize_mask ||
-					     count & blocksize_mask)) {
-					page = ERR_PTR(-EINVAL);
-					goto backout;
-				}
-				count = min(count, nbytes);
-				goto same_bio;
-			}
-		} else {
-			blk_unget_page(page, &pvec);
-		}
-
-		/* bio is ready, submit it */
-		if (rw == READ)
-			bio_set_pages_dirty(bio);
-		atomic_inc(bio_count);
-		submit_bio(rw, bio);
-	}
-
-completion:
-	iocb->ki_left -= nbytes;
-	nbytes = iocb->ki_left;
-	iocb->ki_pos += nbytes;
-
-	blk_run_address_space(inode->i_mapping);
-	if (atomic_dec_and_test(bio_count))
-		aio_complete(iocb, nbytes, 0);
-
-	return -EIOCBQUEUED;
-
-backout:
-	/*
-	 * back out nbytes count constructed so far for this bio,
-	 * we will throw away current bio.
-	 */
-	nbytes += bio->bi_size;
-	bio_release_pages(bio);
-	bio_put(bio);
-
-	/*
-	 * if no bio was submmitted, return the error code.
-	 * otherwise, proceed with pending I/O completion.
-	 */
-	if (atomic_read(bio_count) == 1)
-		return PTR_ERR(page);
-	goto completion;
-}
-#endif
-
 static int blkdev_writepage(struct page *page, struct writeback_control *wbc)
 {
 	return block_write_full_page(page, blkdev_get_block, wbc);
diff -puN include/linux/aio.h~fs-block_devc-remove-if-0ed-code include/linux/aio.h
--- a/include/linux/aio.h~fs-block_devc-remove-if-0ed-code
+++ a/include/linux/aio.h
@@ -105,7 +105,6 @@ struct kiocb {
 	wait_queue_t		ki_wait;
 	loff_t			ki_pos;
 
-	atomic_t		ki_bio_count;	/* num bio used for this iocb */
 	void			*private;
 	/* State that we remember to be able to restart/retry  */
 	unsigned short		ki_opcode;
diff -puN include/linux/bio.h~fs-block_devc-remove-if-0ed-code include/linux/bio.h
--- a/include/linux/bio.h~fs-block_devc-remove-if-0ed-code
+++ a/include/linux/bio.h
@@ -326,7 +326,6 @@ extern struct bio *bio_map_kern(struct r
 				gfp_t);
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
-extern void bio_release_pages(struct bio *bio);
 extern struct bio *bio_copy_user(struct request_queue *, unsigned long, unsigned int, int);
 extern int bio_uncopy_user(struct bio *);
 void zero_fill_bio(struct bio *bio);
_

Patches currently in -mm which might be from bunk@kernel.org are

git-acpi.patch
git-dvb.patch
git-gfs2-nmw.patch
proper-extern-for-gfs2-locking-dlm-mountcgdlm_ops.patch
gfs2-ops_filec-should-include-ops_inodeh.patch
git-kbuild.patch
mtdoopsc-make-struct-oops_cxt-static-again.patch
make-mtd-nand-cs553x_nandcpart_probes-static.patch
make-s2iocinit_tti-static.patch
git-nfsd.patch
git-ocfs2.patch
make-ocfs2_downconvert_thread-static.patch
ocfs-make-dlm_do_assert_master-static.patch
if-0-pci_cleanup_aer_correct_error_status.patch
pci_alloc_child_bus-mustnt-be-__devinit.patch
pci_scan_device-mustnt-be-__devinit.patch
pci_bus_size_cardbus-mustnt-be-__devinit.patch
pci_setup_bridge-mustnt-be-__devinit.patch
scsi-aic94xx-cleanups.patch
scsi-qlogicptic-section-fixes.patch
make-lpfc_disable_node-static.patch
if-0-ses_match_host.patch
scsi_transport_iscsic-make-2-functions-static.patch
remove-ps2esdi.patch
usb-make-usb_storage_onetouch-available-with-pm.patch
make-b43_mac_enablesuspend-static.patch
the-scheduled-ieee80211-softmac-removal.patch
the-scheduled-rc80211-simplec-removal.patch
ipwireless-remove-dead-code.patch
git-xtensa.patch
sparc-fix-build.patch
make-swap_pte_to_pagemap_entry-static.patch
fs-ramfs-extern-cleanup.patch
make-printk_recursion_bug_msg-static.patch
make-udf_error-static.patch
fs-hfsplus-proper-externs.patch
fs-freevxfs-proper-externs.patch
make-__put_super-static.patch
make-vfs_ioctl-static.patch
fs-fs-writeback-make-2-functions-static.patch
fs-drop_cachesc-make-2-functions-static.patch
fs-block_devc-remove-if-0ed-code.patch
fs-aioc-make-3-functions-static.patch
let-log_buf_shift-default-to-17.patch
fs-timerfdc-should-include-linux-syscallsh.patch
make-struct-def_blk_aops-static.patch
remove-generic_commit_write.patch
make-fs-bufferccont_expand_zero-static.patch
make-binfmt_flat-a-bool.patch
remove-mca_is_adapter_used.patch
remove-ecryptfs_header_cache_0.patch
make-ds1511_rtc_readset_time-static.patch
make-ext3_xattr_list-static.patch
make-cgroup_enable_task_cg_lists-static.patch
kernel-cpusetc-make-3-functions-static.patch
make-ext4_xattr_list-static.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
make-marker_debug-static.patch
reiser4.patch
