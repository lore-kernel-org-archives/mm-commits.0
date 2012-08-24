From: akpm@linux-foundation.org
Subject: + block-replace-__getblk_slow-misfix-by-grow_dev_page-fix.patch added to -mm tree
Date: Fri, 24 Aug 2012 15:40:07 -0700
Message-ID: <20120824224007.D442B1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:58852 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab2HXWkI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 18:40:08 -0400
Received: by yhl10 with SMTP id 10so341465yhl.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 15:40:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, axboe@kernel.dk, jmoyer@redhat.com, stable@vger.kernel.org, torsten.hilbrich@secunet.com


The patch titled
     Subject: block: replace __getblk_slow misfix by grow_dev_page fix
has been added to the -mm tree.  Its filename is
     block-replace-__getblk_slow-misfix-by-grow_dev_page-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: block: replace __getblk_slow misfix by grow_dev_page fix

Commit 91f68c89d8f3 ("block: fix infinite loop in __getblk_slow") is not
good: a successful call to grow_buffers() cannot guarantee that the page
won't be reclaimed before the immediate next call to __find_get_block(),
which is why there was always a loop there.

Yesterday I got "EXT4-fs error (device loop0): __ext4_get_inode_loc:3595:
inode #19278: block 664: comm cc1: unable to read itable block" on
console, which pointed to this commit.

I've been trying to bisect for weeks, why kbuild-on-ext4-on-loop-on-tmpfs
sometimes fails from a missing header file, under memory pressure on ppc
G5.  I've never seen this on x86, and I've never seen it on 3.5-rc7
itself, despite that commit being in there: bisection pointed to an
irrelevant pinctrl merge, but hard to tell when failure takes between 18
minutes and 38 hours (but so far it's happened quicker on 3.6-rc2).

(I've since found such __ext4_get_inode_loc errors in /var/log/messages
from previous weeks: why the message never appeared on console until
yesterday morning is a mystery for another day.)

Revert 91f68c89d8f3, restoring __getblk_slow() to how it was (plus a
checkpatch nitfix).  Simplify the interface between grow_buffers() and
grow_dev_page(), and avoid the infinite loop beyond end of device by
instead checking init_page_buffers()'s end_block there (I presume that's
more efficient than a repeated call to blkdev_max_block()), returning
-ENXIO to __getblk_slow() in that case.

And remove akpm's ten-year-old "__getblk() cannot fail ...  weird"
comment, but that is worrying: are all users of __getblk() really now
prepared for a NULL bh beyond end of device, or will some oops??

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org> # 3.0 3.2 3.4 3.5
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Tested-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   66 ++++++++++++++++++++++----------------------------
 1 file changed, 30 insertions(+), 36 deletions(-)

diff -puN fs/buffer.c~block-replace-__getblk_slow-misfix-by-grow_dev_page-fix fs/buffer.c
--- a/fs/buffer.c~block-replace-__getblk_slow-misfix-by-grow_dev_page-fix
+++ a/fs/buffer.c
@@ -914,7 +914,7 @@ link_dev_buffers(struct page *page, stru
 /*
  * Initialise the state of a blockdev page's buffers.
  */ 
-static void
+static sector_t
 init_page_buffers(struct page *page, struct block_device *bdev,
 			sector_t block, int size)
 {
@@ -936,33 +936,41 @@ init_page_buffers(struct page *page, str
 		block++;
 		bh = bh->b_this_page;
 	} while (bh != head);
+
+	/*
+	 * Caller needs to validate requested block against end of device.
+	 */
+	return end_block;
 }
 
 /*
  * Create the page-cache page that contains the requested block.
  *
- * This is user purely for blockdev mappings.
+ * This is used purely for blockdev mappings.
  */
-static struct page *
+static int
 grow_dev_page(struct block_device *bdev, sector_t block,
-		pgoff_t index, int size)
+		pgoff_t index, int size, int sizebits)
 {
 	struct inode *inode = bdev->bd_inode;
 	struct page *page;
 	struct buffer_head *bh;
+	sector_t end_block;
+	int ret = 0;		/* Will call free_more_memory() */
 
 	page = find_or_create_page(inode->i_mapping, index,
 		(mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS)|__GFP_MOVABLE);
 	if (!page)
-		return NULL;
+		return ret;
 
 	BUG_ON(!PageLocked(page));
 
 	if (page_has_buffers(page)) {
 		bh = page_buffers(page);
 		if (bh->b_size == size) {
-			init_page_buffers(page, bdev, block, size);
-			return page;
+			end_block = init_page_buffers(page, bdev,
+						index << sizebits, size);
+			goto done;
 		}
 		if (!try_to_free_buffers(page))
 			goto failed;
@@ -982,14 +990,14 @@ grow_dev_page(struct block_device *bdev,
 	 */
 	spin_lock(&inode->i_mapping->private_lock);
 	link_dev_buffers(page, bh);
-	init_page_buffers(page, bdev, block, size);
+	end_block = init_page_buffers(page, bdev, index << sizebits, size);
 	spin_unlock(&inode->i_mapping->private_lock);
-	return page;
-
+done:
+	ret = (block < end_block) ? 1 : -ENXIO;
 failed:
 	unlock_page(page);
 	page_cache_release(page);
-	return NULL;
+	return ret;
 }
 
 /*
@@ -999,7 +1007,6 @@ failed:
 static int
 grow_buffers(struct block_device *bdev, sector_t block, int size)
 {
-	struct page *page;
 	pgoff_t index;
 	int sizebits;
 
@@ -1023,22 +1030,14 @@ grow_buffers(struct block_device *bdev, 
 			bdevname(bdev, b));
 		return -EIO;
 	}
-	block = index << sizebits;
+
 	/* Create a page with the proper size buffers.. */
-	page = grow_dev_page(bdev, block, index, size);
-	if (!page)
-		return 0;
-	unlock_page(page);
-	page_cache_release(page);
-	return 1;
+	return grow_dev_page(bdev, block, index, size, sizebits);
 }
 
 static struct buffer_head *
 __getblk_slow(struct block_device *bdev, sector_t block, int size)
 {
-	int ret;
-	struct buffer_head *bh;
-
 	/* Size must be multiple of hard sectorsize */
 	if (unlikely(size & (bdev_logical_block_size(bdev)-1) ||
 			(size < 512 || size > PAGE_SIZE))) {
@@ -1051,21 +1050,20 @@ __getblk_slow(struct block_device *bdev,
 		return NULL;
 	}
 
-retry:
-	bh = __find_get_block(bdev, block, size);
-	if (bh)
-		return bh;
+	for (;;) {
+		struct buffer_head *bh;
+		int ret;
 
-	ret = grow_buffers(bdev, block, size);
-	if (ret == 0) {
-		free_more_memory();
-		goto retry;
-	} else if (ret > 0) {
 		bh = __find_get_block(bdev, block, size);
 		if (bh)
 			return bh;
+
+		ret = grow_buffers(bdev, block, size);
+		if (ret < 0)
+			return NULL;
+		if (ret == 0)
+			free_more_memory();
 	}
-	return NULL;
 }
 
 /*
@@ -1321,10 +1319,6 @@ EXPORT_SYMBOL(__find_get_block);
  * which corresponds to the passed block_device, block and size. The
  * returned buffer has its reference count incremented.
  *
- * __getblk() cannot fail - it just keeps trying.  If you pass it an
- * illegal block number, __getblk() will happily return a buffer_head
- * which represents the non-existent block.  Very weird.
- *
  * __getblk() will lock up the machine if grow_dev_page's try_to_free_buffers()
  * attempt is failing.  FIXME, perhaps?
  */
_

Patches currently in -mm which might be from hughd@google.com are

block-replace-__getblk_slow-misfix-by-grow_dev_page-fix.patch
x86-pat-remove-the-dependency-on-vm_pgoff-in-track-untrack-pfn-vma-routines.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
mm-x86-pat-rework-linear-pfn-mmap-tracking.patch
mm-introduce-arch-specific-vma-flag-vm_arch_1.patch
mm-kill-vma-flag-vm_insertpage.patch
mm-kill-vma-flag-vm_can_nonlinear.patch
mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file.patch
mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas.patch
mm-prepare-vm_dontdump-for-using-in-drivers.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch
mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
mm-mmu_notifier-init-notifier-if-necessary.patch
thp-fix-the-count-of-thp_collapse_alloc.patch
thp-remove-unnecessary-check-in-start_khugepaged.patch
thp-move-khugepaged_mutex-out-of-khugepaged.patch
thp-remove-unnecessary-khugepaged_thread-check.patch
thp-remove-wake_up_interruptible-in-the-exit-path.patch
thp-remove-some-code-depend-on-config_numa.patch
thp-merge-page-pre-alloc-in-khugepaged_loop-into-khugepaged_do_scan.patch
thp-release-page-in-page-pre-alloc-path.patch
thp-introduce-khugepaged_prealloc_page-and-khugepaged_alloc_page.patch
thp-remove-khugepaged_loop.patch
thp-use-khugepaged_enabled-to-remove-duplicate-code.patch
thp-remove-unnecessary-set_recommended_min_free_kbytes.patch
prio_tree-debugging-patch.patch

