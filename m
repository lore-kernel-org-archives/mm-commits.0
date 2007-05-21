From: akpm@linux-foundation.org
Subject: + md-change-bitmap_unplug-and-others-to-void-functions.patch added to -mm tree
Date: Sun, 20 May 2007 21:34:17 -0700
Message-ID: <200705210434.l4L4YGWr002467@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46049 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757081AbXEUEf0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 00:35:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: change bitmap_unplug and others to void functions
has been added to the -mm tree.  Its filename is
     md-change-bitmap_unplug-and-others-to-void-functions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: change bitmap_unplug and others to void functions
From: NeilBrown <neilb@suse.de>

bitmap_unplug only ever returns 0, so it may as well be void.  Two callers try
to print a message if it returns non-zero, but that message is already printed
by bitmap_file_kick.

write_page returns an error which is not consistently checked.  It always
causes BITMAP_WRITE_ERROR to be set on an error, and that can more
conveniently be checked.

When the return of write_page is checked, an error causes bitmap_file_kick to
be called - so move that call into write_page - and protect against recursive
calls into bitmap_file_kick.

bitmap_update_sb returns an error that is never checked.

So make these 'void' and be consistent about checking the bit.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bitmap.c         |  144 +++++++++++++++++-----------------
 drivers/md/md.c             |    3 
 drivers/md/raid1.c          |    3 
 drivers/md/raid10.c         |    3 
 include/linux/raid/bitmap.h |    6 -
 5 files changed, 80 insertions(+), 79 deletions(-)

diff -puN drivers/md/bitmap.c~md-change-bitmap_unplug-and-others-to-void-functions drivers/md/bitmap.c
--- a/drivers/md/bitmap.c~md-change-bitmap_unplug-and-others-to-void-functions
+++ a/drivers/md/bitmap.c
@@ -305,10 +305,11 @@ static int write_sb_page(struct bitmap *
 	return 0;
 }
 
+static void bitmap_file_kick(struct bitmap *bitmap);
 /*
  * write out a page to a file
  */
-static int write_page(struct bitmap *bitmap, struct page *page, int wait)
+static void write_page(struct bitmap *bitmap, struct page *page, int wait)
 {
 	struct buffer_head *bh;
 
@@ -316,27 +317,26 @@ static int write_page(struct bitmap *bit
 		switch (write_sb_page(bitmap, page, wait)) {
 		case -EINVAL:
 			bitmap->flags |= BITMAP_WRITE_ERROR;
-			return -EIO;
 		}
-		return 0;
-	}
+	} else {
 
-	bh = page_buffers(page);
+		bh = page_buffers(page);
 
-	while (bh && bh->b_blocknr) {
-		atomic_inc(&bitmap->pending_writes);
-		set_buffer_locked(bh);
-		set_buffer_mapped(bh);
-		submit_bh(WRITE, bh);
-		bh = bh->b_this_page;
-	}
+		while (bh && bh->b_blocknr) {
+			atomic_inc(&bitmap->pending_writes);
+			set_buffer_locked(bh);
+			set_buffer_mapped(bh);
+			submit_bh(WRITE, bh);
+			bh = bh->b_this_page;
+		}
 
-	if (wait) {
-		wait_event(bitmap->write_wait,
-			   atomic_read(&bitmap->pending_writes)==0);
-		return (bitmap->flags & BITMAP_WRITE_ERROR) ? -EIO : 0;
+		if (wait) {
+			wait_event(bitmap->write_wait,
+				   atomic_read(&bitmap->pending_writes)==0);
+		}
 	}
-	return 0;
+	if (bitmap->flags & BITMAP_WRITE_ERROR)
+		bitmap_file_kick(bitmap);
 }
 
 static void end_bitmap_write(struct buffer_head *bh, int uptodate)
@@ -456,17 +456,17 @@ out:
  */
 
 /* update the event counter and sync the superblock to disk */
-int bitmap_update_sb(struct bitmap *bitmap)
+void bitmap_update_sb(struct bitmap *bitmap)
 {
 	bitmap_super_t *sb;
 	unsigned long flags;
 
 	if (!bitmap || !bitmap->mddev) /* no bitmap for this array */
-		return 0;
+		return;
 	spin_lock_irqsave(&bitmap->lock, flags);
 	if (!bitmap->sb_page) { /* no superblock */
 		spin_unlock_irqrestore(&bitmap->lock, flags);
-		return 0;
+		return;
 	}
 	spin_unlock_irqrestore(&bitmap->lock, flags);
 	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
@@ -474,7 +474,7 @@ int bitmap_update_sb(struct bitmap *bitm
 	if (!bitmap->mddev->degraded)
 		sb->events_cleared = cpu_to_le64(bitmap->mddev->events);
 	kunmap_atomic(sb, KM_USER0);
-	return write_page(bitmap, bitmap->sb_page, 1);
+	write_page(bitmap, bitmap->sb_page, 1);
 }
 
 /* print out the bitmap file superblock */
@@ -603,20 +603,22 @@ enum bitmap_mask_op {
 	MASK_UNSET
 };
 
-/* record the state of the bitmap in the superblock */
-static void bitmap_mask_state(struct bitmap *bitmap, enum bitmap_state bits,
-				enum bitmap_mask_op op)
+/* record the state of the bitmap in the superblock.  Return the old value */
+static int bitmap_mask_state(struct bitmap *bitmap, enum bitmap_state bits,
+			     enum bitmap_mask_op op)
 {
 	bitmap_super_t *sb;
 	unsigned long flags;
+	int old;
 
 	spin_lock_irqsave(&bitmap->lock, flags);
 	if (!bitmap->sb_page) { /* can't set the state */
 		spin_unlock_irqrestore(&bitmap->lock, flags);
-		return;
+		return 0;
 	}
 	spin_unlock_irqrestore(&bitmap->lock, flags);
 	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
+	old = le32_to_cpu(sb->state) & bits;
 	switch (op) {
 		case MASK_SET: sb->state |= cpu_to_le32(bits);
 				break;
@@ -625,6 +627,7 @@ static void bitmap_mask_state(struct bit
 		default: BUG();
 	}
 	kunmap_atomic(sb, KM_USER0);
+	return old;
 }
 
 /*
@@ -718,18 +721,23 @@ static void bitmap_file_kick(struct bitm
 {
 	char *path, *ptr = NULL;
 
-	bitmap_mask_state(bitmap, BITMAP_STALE, MASK_SET);
-	bitmap_update_sb(bitmap);
-
-	if (bitmap->file) {
-		path = kmalloc(PAGE_SIZE, GFP_KERNEL);
-		if (path)
-			ptr = file_path(bitmap->file, path, PAGE_SIZE);
-
-		printk(KERN_ALERT "%s: kicking failed bitmap file %s from array!\n",
-		       bmname(bitmap), ptr ? ptr : "");
+	if (bitmap_mask_state(bitmap, BITMAP_STALE, MASK_SET) == 0) {
+		bitmap_update_sb(bitmap);
 
-		kfree(path);
+		if (bitmap->file) {
+			path = kmalloc(PAGE_SIZE, GFP_KERNEL);
+			if (path)
+				ptr = file_path(bitmap->file, path, PAGE_SIZE);
+
+			printk(KERN_ALERT
+			      "%s: kicking failed bitmap file %s from array!\n",
+			      bmname(bitmap), ptr ? ptr : "");
+
+			kfree(path);
+		} else
+			printk(KERN_ALERT
+			       "%s: disabling internal bitmap due to errors\n",
+			       bmname(bitmap));
 	}
 
 	bitmap_file_put(bitmap);
@@ -800,16 +808,15 @@ static void bitmap_file_set_bit(struct b
 /* this gets called when the md device is ready to unplug its underlying
  * (slave) device queues -- before we let any writes go down, we need to
  * sync the dirty pages of the bitmap file to disk */
-int bitmap_unplug(struct bitmap *bitmap)
+void bitmap_unplug(struct bitmap *bitmap)
 {
 	unsigned long i, flags;
 	int dirty, need_write;
 	struct page *page;
 	int wait = 0;
-	int err;
 
 	if (!bitmap)
-		return 0;
+		return;
 
 	/* look at each page to see if there are any set bits that need to be
 	 * flushed out to disk */
@@ -817,7 +824,7 @@ int bitmap_unplug(struct bitmap *bitmap)
 		spin_lock_irqsave(&bitmap->lock, flags);
 		if (!bitmap->filemap) {
 			spin_unlock_irqrestore(&bitmap->lock, flags);
-			return 0;
+			return;
 		}
 		page = bitmap->filemap[i];
 		dirty = test_page_attr(bitmap, page, BITMAP_PAGE_DIRTY);
@@ -829,7 +836,7 @@ int bitmap_unplug(struct bitmap *bitmap)
 		spin_unlock_irqrestore(&bitmap->lock, flags);
 
 		if (dirty | need_write)
-			err = write_page(bitmap, page, 0);
+			write_page(bitmap, page, 0);
 	}
 	if (wait) { /* if any writes were performed, we need to wait on them */
 		if (bitmap->file)
@@ -840,7 +847,6 @@ int bitmap_unplug(struct bitmap *bitmap)
 	}
 	if (bitmap->flags & BITMAP_WRITE_ERROR)
 		bitmap_file_kick(bitmap);
-	return 0;
 }
 
 static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int needed);
@@ -889,21 +895,21 @@ static int bitmap_init_from_disk(struct 
 			bmname(bitmap),
 			(unsigned long) i_size_read(file->f_mapping->host),
 			bytes + sizeof(bitmap_super_t));
-		goto out;
+		goto err;
 	}
 
 	ret = -ENOMEM;
 
 	bitmap->filemap = kmalloc(sizeof(struct page *) * num_pages, GFP_KERNEL);
 	if (!bitmap->filemap)
-		goto out;
+		goto err;
 
 	/* We need 4 bits per page, rounded up to a multiple of sizeof(unsigned long) */
 	bitmap->filemap_attr = kzalloc(
 		roundup( DIV_ROUND_UP(num_pages*4, 8), sizeof(unsigned long)),
 		GFP_KERNEL);
 	if (!bitmap->filemap_attr)
-		goto out;
+		goto err;
 
 	oldindex = ~0L;
 
@@ -936,7 +942,7 @@ static int bitmap_init_from_disk(struct 
 			}
 			if (IS_ERR(page)) { /* read error */
 				ret = PTR_ERR(page);
-				goto out;
+				goto err;
 			}
 
 			oldindex = index;
@@ -951,11 +957,13 @@ static int bitmap_init_from_disk(struct 
 				memset(paddr + offset, 0xff,
 				       PAGE_SIZE - offset);
 				kunmap_atomic(paddr, KM_USER0);
-				ret = write_page(bitmap, page, 1);
-				if (ret) {
+				write_page(bitmap, page, 1);
+
+				ret = -EIO;
+				if (bitmap->flags & BITMAP_WRITE_ERROR) {
 					/* release, page not in filemap yet */
 					put_page(page);
-					goto out;
+					goto err;
 				}
 			}
 
@@ -987,11 +995,15 @@ static int bitmap_init_from_disk(struct 
 		md_wakeup_thread(bitmap->mddev->thread);
 	}
 
-out:
 	printk(KERN_INFO "%s: bitmap initialized from disk: "
-		"read %lu/%lu pages, set %lu bits, status: %d\n",
-		bmname(bitmap), bitmap->file_pages, num_pages, bit_cnt, ret);
+		"read %lu/%lu pages, set %lu bits\n",
+		bmname(bitmap), bitmap->file_pages, num_pages, bit_cnt);
+
+	return 0;
 
+ err:
+	printk(KERN_INFO "%s: bitmap initialisation failed: %d\n",
+	       bmname(bitmap), ret);
 	return ret;
 }
 
@@ -1028,19 +1040,18 @@ static bitmap_counter_t *bitmap_get_coun
  *			out to disk
  */
 
-int bitmap_daemon_work(struct bitmap *bitmap)
+void bitmap_daemon_work(struct bitmap *bitmap)
 {
 	unsigned long j;
 	unsigned long flags;
 	struct page *page = NULL, *lastpage = NULL;
-	int err = 0;
 	int blocks;
 	void *paddr;
 
 	if (bitmap == NULL)
-		return 0;
+		return;
 	if (time_before(jiffies, bitmap->daemon_lastrun + bitmap->daemon_sleep*HZ))
-		return 0;
+		return;
 	bitmap->daemon_lastrun = jiffies;
 
 	for (j = 0; j < bitmap->chunks; j++) {
@@ -1063,14 +1074,8 @@ int bitmap_daemon_work(struct bitmap *bi
 					clear_page_attr(bitmap, page, BITMAP_PAGE_NEEDWRITE);
 
 				spin_unlock_irqrestore(&bitmap->lock, flags);
-				if (need_write) {
-					switch (write_page(bitmap, page, 0)) {
-					case 0:
-						break;
-					default:
-						bitmap_file_kick(bitmap);
-					}
-				}
+				if (need_write)
+					write_page(bitmap, page, 0);
 				continue;
 			}
 
@@ -1079,13 +1084,11 @@ int bitmap_daemon_work(struct bitmap *bi
 				if (test_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE)) {
 					clear_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
 					spin_unlock_irqrestore(&bitmap->lock, flags);
-					err = write_page(bitmap, lastpage, 0);
+					write_page(bitmap, lastpage, 0);
 				} else {
 					set_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
 					spin_unlock_irqrestore(&bitmap->lock, flags);
 				}
-				if (err)
-					bitmap_file_kick(bitmap);
 			} else
 				spin_unlock_irqrestore(&bitmap->lock, flags);
 			lastpage = page;
@@ -1128,14 +1131,13 @@ int bitmap_daemon_work(struct bitmap *bi
 		if (test_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE)) {
 			clear_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
 			spin_unlock_irqrestore(&bitmap->lock, flags);
-			err = write_page(bitmap, lastpage, 0);
+			write_page(bitmap, lastpage, 0);
 		} else {
 			set_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
 			spin_unlock_irqrestore(&bitmap->lock, flags);
 		}
 	}
 
-	return err;
 }
 
 static bitmap_counter_t *bitmap_get_counter(struct bitmap *bitmap,
@@ -1548,7 +1550,9 @@ int bitmap_create(mddev_t *mddev)
 
 	mddev->thread->timeout = bitmap->daemon_sleep * HZ;
 
-	return bitmap_update_sb(bitmap);
+	bitmap_update_sb(bitmap);
+
+	return (bitmap->flags & BITMAP_WRITE_ERROR) ? -EIO : 0;
 
  error:
 	bitmap_free(bitmap);
diff -puN drivers/md/md.c~md-change-bitmap_unplug-and-others-to-void-functions drivers/md/md.c
--- a/drivers/md/md.c~md-change-bitmap_unplug-and-others-to-void-functions
+++ a/drivers/md/md.c
@@ -1640,7 +1640,6 @@ static void sync_sbs(mddev_t * mddev, in
 
 static void md_update_sb(mddev_t * mddev, int force_change)
 {
-	int err;
 	struct list_head *tmp;
 	mdk_rdev_t *rdev;
 	int sync_req;
@@ -1727,7 +1726,7 @@ repeat:
 		"md: updating %s RAID superblock on device (in sync %d)\n",
 		mdname(mddev),mddev->in_sync);
 
-	err = bitmap_update_sb(mddev->bitmap);
+	bitmap_update_sb(mddev->bitmap);
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		char b[BDEVNAME_SIZE];
 		dprintk(KERN_INFO "md: ");
diff -puN drivers/md/raid10.c~md-change-bitmap_unplug-and-others-to-void-functions drivers/md/raid10.c
--- a/drivers/md/raid10.c~md-change-bitmap_unplug-and-others-to-void-functions
+++ a/drivers/md/raid10.c
@@ -1510,8 +1510,7 @@ static void raid10d(mddev_t *mddev)
 			blk_remove_plug(mddev->queue);
 			spin_unlock_irqrestore(&conf->device_lock, flags);
 			/* flush any pending bitmap writes to disk before proceeding w/ I/O */
-			if (bitmap_unplug(mddev->bitmap) != 0)
-				printk("%s: bitmap file write failed!\n", mdname(mddev));
+			bitmap_unplug(mddev->bitmap);
 
 			while (bio) { /* submit pending writes */
 				struct bio *next = bio->bi_next;
diff -puN drivers/md/raid1.c~md-change-bitmap_unplug-and-others-to-void-functions drivers/md/raid1.c
--- a/drivers/md/raid1.c~md-change-bitmap_unplug-and-others-to-void-functions
+++ a/drivers/md/raid1.c
@@ -1519,8 +1519,7 @@ static void raid1d(mddev_t *mddev)
 			blk_remove_plug(mddev->queue);
 			spin_unlock_irqrestore(&conf->device_lock, flags);
 			/* flush any pending bitmap writes to disk before proceeding w/ I/O */
-			if (bitmap_unplug(mddev->bitmap) != 0)
-				printk("%s: bitmap file write failed!\n", mdname(mddev));
+			bitmap_unplug(mddev->bitmap);
 
 			while (bio) { /* submit pending writes */
 				struct bio *next = bio->bi_next;
diff -puN include/linux/raid/bitmap.h~md-change-bitmap_unplug-and-others-to-void-functions include/linux/raid/bitmap.h
--- a/include/linux/raid/bitmap.h~md-change-bitmap_unplug-and-others-to-void-functions
+++ a/include/linux/raid/bitmap.h
@@ -262,7 +262,7 @@ int  bitmap_active(struct bitmap *bitmap
 
 char *file_path(struct file *file, char *buf, int count);
 void bitmap_print_sb(struct bitmap *bitmap);
-int bitmap_update_sb(struct bitmap *bitmap);
+void bitmap_update_sb(struct bitmap *bitmap);
 
 int  bitmap_setallbits(struct bitmap *bitmap);
 void bitmap_write_all(struct bitmap *bitmap);
@@ -278,8 +278,8 @@ int bitmap_start_sync(struct bitmap *bit
 void bitmap_end_sync(struct bitmap *bitmap, sector_t offset, int *blocks, int aborted);
 void bitmap_close_sync(struct bitmap *bitmap);
 
-int bitmap_unplug(struct bitmap *bitmap);
-int bitmap_daemon_work(struct bitmap *bitmap);
+void bitmap_unplug(struct bitmap *bitmap);
+void bitmap_daemon_work(struct bitmap *bitmap);
 #endif
 
 #endif
_

Patches currently in -mm which might be from neilb@suse.de are

git-md-accel.patch
md-avoid-overflow-in-raid0-calculation-with-large-components.patch
md-dont-write-more-than-is-required-of-the-last-page-of-a-bitmap.patch
md-fix-bug-with-linear-hot-add-and-elsewhere.patch
knfsd-exportfs-add-exportfsh-header.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
knfsd-exportfs-add-procedural-interface-for-nfsd.patch
knfsd-exportfs-remove-call-macro.patch
knfsd-exportfs-untangle-isdir-logic-in-find_exported_dentry.patch
knfsd-exportfs-move-acceptable-check-into-find_acceptable_alias.patch
knfsd-exportfs-add-find_disconnected_root-helper.patch
knfsd-exportfs-split-out-reconnecting-a-dentry-from-find_exported_dentry.patch
nfsd-warning-fix.patch
use-menuconfig-objects-ii-md.patch
md-improve-message-about-invalid-superblock-during-autodetect.patch
md-improve-the-is_mddev_idle-test-fix.patch
md-check-that-internal-bitmap-does-not-overlap-other-data.patch
md-change-bitmap_unplug-and-others-to-void-functions.patch
