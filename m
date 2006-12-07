From: akpm@osdl.org
Subject: - swsusp-use-block-device-offsets-to-identify-swap-locations-rev-2.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:59:07 -0800
Message-ID: <200612072259.kB7Mx7bB029457@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50963 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163671AbWLGW7f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:59:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: use block device offsets to identify swap locations
has been removed from the -mm tree.  Its filename was
     swsusp-use-block-device-offsets-to-identify-swap-locations-rev-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: use block device offsets to identify swap locations
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Make swsusp use block device offsets instead of swap offsets to identify swap
locations and make it use the same code paths for writing as well as for
reading data.

This allows us to use the same code for handling swap files and swap
partitions and to simplify the code, eg.  by dropping rw_swap_page_sync().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/swap.h  |    3 
 kernel/power/power.h  |    2 
 kernel/power/swap.c   |  129 +++++++++++++++++++++-------------------
 kernel/power/swsusp.c |   10 +--
 kernel/power/user.c   |    7 +-
 mm/page_io.c          |   45 -------------
 mm/swapfile.c         |   17 +++++
 7 files changed, 96 insertions(+), 117 deletions(-)

diff -puN include/linux/swap.h~swsusp-use-block-device-offsets-to-identify-swap-locations-rev-2 include/linux/swap.h
--- a/include/linux/swap.h~swsusp-use-block-device-offsets-to-identify-swap-locations-rev-2
+++ a/include/linux/swap.h
@@ -218,8 +218,6 @@ extern void swap_unplug_io_fn(struct bac
 /* linux/mm/page_io.c */
 extern int swap_readpage(struct file *, struct page *);
 extern int swap_writepage(struct page *page, struct writeback_control *wbc);
-extern int rw_swap_page_sync(int rw, swp_entry_t entry, struct page *page,
-				struct bio **bio_chain);
 extern int end_swap_bio_read(struct bio *bio, unsigned int bytes_done, int err);
 
 /* linux/mm/swap_state.c */
@@ -250,6 +248,7 @@ extern void free_swap_and_cache(swp_entr
 extern int swap_type_of(dev_t, sector_t);
 extern unsigned int count_swap_pages(int, int);
 extern sector_t map_swap_page(struct swap_info_struct *, pgoff_t);
+extern sector_t swapdev_block(int, pgoff_t);
 extern struct swap_info_struct *get_swap_info_struct(unsigned);
 extern int can_share_swap_page(struct page *);
 extern int remove_exclusive_swap_page(struct page *);
diff -puN kernel/power/power.h~swsusp-use-block-device-offsets-to-identify-swap-locations-rev-2 kernel/power/power.h
--- a/kernel/power/power.h~swsusp-use-block-device-offsets-to-identify-swap-locations-rev-2
+++ a/kernel/power/power.h
@@ -146,7 +146,7 @@ struct bitmap_page {
 
 extern void free_bitmap(struct bitmap_page *bitmap);
 extern struct bitmap_page *alloc_bitmap(unsigned int nr_bits);
-extern unsigned long alloc_swap_page(int swap, struct bitmap_page *bitmap);
+extern sector_t alloc_swapdev_block(int swap, struct bitmap_page *bitmap);
 extern void free_all_swap_pages(int swap, struct bitmap_page *bitmap);
 
 extern int swsusp_check(void);
diff -puN kernel/power/swap.c~swsusp-use-block-device-offsets-to-identify-swap-locations-rev-2 kernel/power/swap.c
--- a/kernel/power/swap.c~swsusp-use-block-device-offsets-to-identify-swap-locations-rev-2
+++ a/kernel/power/swap.c
@@ -34,8 +34,8 @@ extern char resume_file[];
 #define SWSUSP_SIG	"S1SUSPEND"
 
 static struct swsusp_header {
-	char reserved[PAGE_SIZE - 20 - sizeof(swp_entry_t)];
-	swp_entry_t image;
+	char reserved[PAGE_SIZE - 20 - sizeof(sector_t)];
+	sector_t image;
 	char	orig_sig[10];
 	char	sig[10];
 } __attribute__((packed, aligned(PAGE_SIZE))) swsusp_header;
@@ -100,9 +100,9 @@ static int bio_read_page(pgoff_t page_of
 	return submit(READ, page_off, virt_to_page(addr), bio_chain);
 }
 
-static int bio_write_page(pgoff_t page_off, void *addr)
+static int bio_write_page(pgoff_t page_off, void *addr, struct bio **bio_chain)
 {
-	return submit(WRITE, page_off, virt_to_page(addr), NULL);
+	return submit(WRITE, page_off, virt_to_page(addr), bio_chain);
 }
 
 static int wait_on_bio_chain(struct bio **bio_chain)
@@ -157,22 +157,19 @@ static void show_speed(struct timeval *s
  * Saving part
  */
 
-static int mark_swapfiles(swp_entry_t start)
+static int mark_swapfiles(sector_t start)
 {
 	int error;
 
-	rw_swap_page_sync(READ, swp_entry(root_swap, 0),
-			  virt_to_page((unsigned long)&swsusp_header), NULL);
+	bio_read_page(0, &swsusp_header, NULL);
 	if (!memcmp("SWAP-SPACE",swsusp_header.sig, 10) ||
 	    !memcmp("SWAPSPACE2",swsusp_header.sig, 10)) {
 		memcpy(swsusp_header.orig_sig,swsusp_header.sig, 10);
 		memcpy(swsusp_header.sig,SWSUSP_SIG, 10);
 		swsusp_header.image = start;
-		error = rw_swap_page_sync(WRITE, swp_entry(root_swap, 0),
-				virt_to_page((unsigned long)&swsusp_header),
-				NULL);
+		error = bio_write_page(0, &swsusp_header, NULL);
 	} else {
-		pr_debug("swsusp: Partition is not swap space.\n");
+		printk(KERN_ERR "swsusp: Swap header not found!\n");
 		error = -ENODEV;
 	}
 	return error;
@@ -185,12 +182,21 @@ static int mark_swapfiles(swp_entry_t st
 
 static int swsusp_swap_check(void) /* This is called before saving image */
 {
-	int res = swap_type_of(swsusp_resume_device, 0);
+	int res;
+
+	res = swap_type_of(swsusp_resume_device, 0);
+	if (res < 0)
+		return res;
+
+	root_swap = res;
+	resume_bdev = open_by_devnum(swsusp_resume_device, FMODE_WRITE);
+	if (IS_ERR(resume_bdev))
+		return PTR_ERR(resume_bdev);
+
+	res = set_blocksize(resume_bdev, PAGE_SIZE);
+	if (res < 0)
+		blkdev_put(resume_bdev);
 
-	if (res >= 0) {
-		root_swap = res;
-		return 0;
-	}
 	return res;
 }
 
@@ -201,36 +207,26 @@ static int swsusp_swap_check(void) /* Th
  *	@bio_chain:	Link the next write BIO here
  */
 
-static int write_page(void *buf, unsigned long offset, struct bio **bio_chain)
+static int write_page(void *buf, sector_t offset, struct bio **bio_chain)
 {
-	swp_entry_t entry;
-	int error = -ENOSPC;
+	void *src;
 
-	if (offset) {
-		struct page *page = virt_to_page(buf);
+	if (!offset)
+		return -ENOSPC;
 
-		if (bio_chain) {
-			/*
-			 * Whether or not we successfully allocated a copy page,
-			 * we take a ref on the page here.  It gets undone in
-			 * wait_on_bio_chain().
-			 */
-			struct page *page_copy;
-			page_copy = alloc_page(GFP_ATOMIC);
-			if (page_copy == NULL) {
-				WARN_ON_ONCE(1);
-				bio_chain = NULL;	/* Go synchronous */
-				get_page(page);
-			} else {
-				memcpy(page_address(page_copy),
-					page_address(page), PAGE_SIZE);
-				page = page_copy;
-			}
+	if (bio_chain) {
+		src = (void *)__get_free_page(GFP_ATOMIC);
+		if (src) {
+			memcpy(src, buf, PAGE_SIZE);
+		} else {
+			WARN_ON_ONCE(1);
+			bio_chain = NULL;	/* Go synchronous */
+			src = buf;
 		}
-		entry = swp_entry(root_swap, offset);
-		error = rw_swap_page_sync(WRITE, entry, page, bio_chain);
+	} else {
+		src = buf;
 	}
-	return error;
+	return bio_write_page(offset, src, bio_chain);
 }
 
 /*
@@ -248,11 +244,11 @@ static int write_page(void *buf, unsigne
  *	at a time.
  */
 
-#define MAP_PAGE_ENTRIES	(PAGE_SIZE / sizeof(long) - 1)
+#define MAP_PAGE_ENTRIES	(PAGE_SIZE / sizeof(sector_t) - 1)
 
 struct swap_map_page {
-	unsigned long		entries[MAP_PAGE_ENTRIES];
-	unsigned long		next_swap;
+	sector_t entries[MAP_PAGE_ENTRIES];
+	sector_t next_swap;
 };
 
 /**
@@ -262,7 +258,7 @@ struct swap_map_page {
 
 struct swap_map_handle {
 	struct swap_map_page *cur;
-	unsigned long cur_swap;
+	sector_t cur_swap;
 	struct bitmap_page *bitmap;
 	unsigned int k;
 };
@@ -287,7 +283,7 @@ static int get_swap_writer(struct swap_m
 		release_swap_writer(handle);
 		return -ENOMEM;
 	}
-	handle->cur_swap = alloc_swap_page(root_swap, handle->bitmap);
+	handle->cur_swap = alloc_swapdev_block(root_swap, handle->bitmap);
 	if (!handle->cur_swap) {
 		release_swap_writer(handle);
 		return -ENOSPC;
@@ -300,11 +296,11 @@ static int swap_write_page(struct swap_m
 				struct bio **bio_chain)
 {
 	int error = 0;
-	unsigned long offset;
+	sector_t offset;
 
 	if (!handle->cur)
 		return -EINVAL;
-	offset = alloc_swap_page(root_swap, handle->bitmap);
+	offset = alloc_swapdev_block(root_swap, handle->bitmap);
 	error = write_page(buf, offset, bio_chain);
 	if (error)
 		return error;
@@ -313,7 +309,7 @@ static int swap_write_page(struct swap_m
 		error = wait_on_bio_chain(bio_chain);
 		if (error)
 			goto out;
-		offset = alloc_swap_page(root_swap, handle->bitmap);
+		offset = alloc_swapdev_block(root_swap, handle->bitmap);
 		if (!offset)
 			return -ENOSPC;
 		handle->cur->next_swap = offset;
@@ -413,37 +409,47 @@ int swsusp_write(void)
 	struct swsusp_info *header;
 	int error;
 
-	if ((error = swsusp_swap_check())) {
+	error = swsusp_swap_check();
+	if (error) {
 		printk(KERN_ERR "swsusp: Cannot find swap device, try "
 				"swapon -a.\n");
 		return error;
 	}
 	memset(&snapshot, 0, sizeof(struct snapshot_handle));
 	error = snapshot_read_next(&snapshot, PAGE_SIZE);
-	if (error < PAGE_SIZE)
-		return error < 0 ? error : -EFAULT;
+	if (error < PAGE_SIZE) {
+		if (error >= 0)
+			error = -EFAULT;
+
+		goto out;
+	}
 	header = (struct swsusp_info *)data_of(snapshot);
 	if (!enough_swap(header->pages)) {
 		printk(KERN_ERR "swsusp: Not enough free swap\n");
-		return -ENOSPC;
+		error = -ENOSPC;
+		goto out;
 	}
 	error = get_swap_writer(&handle);
 	if (!error) {
-		unsigned long start = handle.cur_swap;
+		sector_t start = handle.cur_swap;
+
 		error = swap_write_page(&handle, header, NULL);
 		if (!error)
 			error = save_image(&handle, &snapshot,
 					header->pages - 1);
+
 		if (!error) {
 			flush_swap_writer(&handle);
 			printk("S");
-			error = mark_swapfiles(swp_entry(root_swap, start));
+			error = mark_swapfiles(start);
 			printk("|\n");
 		}
 	}
 	if (error)
 		free_all_swap_pages(root_swap, handle.bitmap);
 	release_swap_writer(&handle);
+out:
+	swsusp_close();
 	return error;
 }
 
@@ -459,17 +465,18 @@ static void release_swap_reader(struct s
 	handle->cur = NULL;
 }
 
-static int get_swap_reader(struct swap_map_handle *handle,
-                                      swp_entry_t start)
+static int get_swap_reader(struct swap_map_handle *handle, sector_t start)
 {
 	int error;
 
-	if (!swp_offset(start))
+	if (!start)
 		return -EINVAL;
+
 	handle->cur = (struct swap_map_page *)get_zeroed_page(GFP_ATOMIC);
 	if (!handle->cur)
 		return -ENOMEM;
-	error = bio_read_page(swp_offset(start), handle->cur, NULL);
+
+	error = bio_read_page(start, handle->cur, NULL);
 	if (error) {
 		release_swap_reader(handle);
 		return error;
@@ -481,7 +488,7 @@ static int get_swap_reader(struct swap_m
 static int swap_read_page(struct swap_map_handle *handle, void *buf,
 				struct bio **bio_chain)
 {
-	unsigned long offset;
+	sector_t offset;
 	int error;
 
 	if (!handle->cur)
@@ -608,7 +615,7 @@ int swsusp_check(void)
 		if (!memcmp(SWSUSP_SIG, swsusp_header.sig, 10)) {
 			memcpy(swsusp_header.sig, swsusp_header.orig_sig, 10);
 			/* Reset swap signature now */
-			error = bio_write_page(0, &swsusp_header);
+			error = bio_write_page(0, &swsusp_header, NULL);
 		} else {
 			return -EINVAL;
 		}
diff -puN kernel/power/swsusp.c~swsusp-use-block-device-offsets-to-identify-swap-locations-rev-2 kernel/power/swsusp.c
--- a/kernel/power/swsusp.c~swsusp-use-block-device-offsets-to-identify-swap-locations-rev-2
+++ a/kernel/power/swsusp.c
@@ -134,18 +134,18 @@ static int bitmap_set(struct bitmap_page
 	return 0;
 }
 
-unsigned long alloc_swap_page(int swap, struct bitmap_page *bitmap)
+sector_t alloc_swapdev_block(int swap, struct bitmap_page *bitmap)
 {
 	unsigned long offset;
 
 	offset = swp_offset(get_swap_page_of_type(swap));
 	if (offset) {
-		if (bitmap_set(bitmap, offset)) {
+		if (bitmap_set(bitmap, offset))
 			swap_free(swp_entry(swap, offset));
-			offset = 0;
-		}
+		else
+			return swapdev_block(swap, offset);
 	}
-	return offset;
+	return 0;
 }
 
 void free_all_swap_pages(int swap, struct bitmap_page *bitmap)
diff -puN kernel/power/user.c~swsusp-use-block-device-offsets-to-identify-swap-locations-rev-2 kernel/power/user.c
--- a/kernel/power/user.c~swsusp-use-block-device-offsets-to-identify-swap-locations-rev-2
+++ a/kernel/power/user.c
@@ -126,7 +126,8 @@ static int snapshot_ioctl(struct inode *
 {
 	int error = 0;
 	struct snapshot_data *data;
-	loff_t offset, avail;
+	loff_t avail;
+	sector_t offset;
 
 	if (_IOC_TYPE(cmd) != SNAPSHOT_IOC_MAGIC)
 		return -ENOTTY;
@@ -240,10 +241,10 @@ static int snapshot_ioctl(struct inode *
 				break;
 			}
 		}
-		offset = alloc_swap_page(data->swap, data->bitmap);
+		offset = alloc_swapdev_block(data->swap, data->bitmap);
 		if (offset) {
 			offset <<= PAGE_SHIFT;
-			error = put_user(offset, (loff_t __user *)arg);
+			error = put_user(offset, (sector_t __user *)arg);
 		} else {
 			error = -ENOSPC;
 		}
diff -puN mm/page_io.c~swsusp-use-block-device-offsets-to-identify-swap-locations-rev-2 mm/page_io.c
--- a/mm/page_io.c~swsusp-use-block-device-offsets-to-identify-swap-locations-rev-2
+++ a/mm/page_io.c
@@ -147,48 +147,3 @@ int swap_readpage(struct file *file, str
 out:
 	return ret;
 }
-
-#ifdef CONFIG_SOFTWARE_SUSPEND
-/*
- * A scruffy utility function to read or write an arbitrary swap page
- * and wait on the I/O.  The caller must have a ref on the page.
- *
- * We use end_swap_bio_read() even for writes, because it happens to do what
- * we want.
- */
-int rw_swap_page_sync(int rw, swp_entry_t entry, struct page *page,
-			struct bio **bio_chain)
-{
-	struct bio *bio;
-	int ret = 0;
-	int bio_rw;
-
-	lock_page(page);
-
-	bio = get_swap_bio(GFP_KERNEL, entry.val, page, end_swap_bio_read);
-	if (bio == NULL) {
-		unlock_page(page);
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	bio_rw = rw;
-	if (!bio_chain)
-		bio_rw |= (1 << BIO_RW_SYNC);
-	if (bio_chain)
-		bio_get(bio);
-	submit_bio(bio_rw, bio);
-	if (bio_chain == NULL) {
-		wait_on_page_locked(page);
-
-		if (!PageUptodate(page) || PageError(page))
-			ret = -EIO;
-	}
-	if (bio_chain) {
-		bio->bi_private = *bio_chain;
-		*bio_chain = bio;
-	}
-out:
-	return ret;
-}
-#endif
diff -puN mm/swapfile.c~swsusp-use-block-device-offsets-to-identify-swap-locations-rev-2 mm/swapfile.c
--- a/mm/swapfile.c~swsusp-use-block-device-offsets-to-identify-swap-locations-rev-2
+++ a/mm/swapfile.c
@@ -945,6 +945,23 @@ sector_t map_swap_page(struct swap_info_
 	}
 }
 
+#ifdef CONFIG_SOFTWARE_SUSPEND
+/*
+ * Get the (PAGE_SIZE) block corresponding to given offset on the swapdev
+ * corresponding to given index in swap_info (swap type).
+ */
+sector_t swapdev_block(int swap_type, pgoff_t offset)
+{
+	struct swap_info_struct *sis;
+
+	if (swap_type >= nr_swapfiles)
+		return 0;
+
+	sis = swap_info + swap_type;
+	return (sis->flags & SWP_WRITEOK) ? map_swap_page(sis, offset) : 0;
+}
+#endif /* CONFIG_SOFTWARE_SUSPEND */
+
 /*
  * Free all of a swapdev's extent information
  */
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
md-change-lifetime-rules-for-md-devices.patch

