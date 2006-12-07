From: akpm@osdl.org
Subject: - swsusp-rearrange-swap-handling-code.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:59:05 -0800
Message-ID: <200612072259.kB7Mx53e029453@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50960 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163668AbWLGW7f (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:59:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     swsusp: rearrange swap-handling code
has been removed from the -mm tree.  Its filename was
     swsusp-rearrange-swap-handling-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: swsusp: rearrange swap-handling code
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Rearrange the code in kernel/power/swap.c so that the next patch is more
readable.

[This patch only moves the existing code.]

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/power/swap.c |  221 +++++++++++++++++++++---------------------
 1 file changed, 112 insertions(+), 109 deletions(-)

diff -puN kernel/power/swap.c~swsusp-rearrange-swap-handling-code kernel/power/swap.c
--- a/kernel/power/swap.c~swsusp-rearrange-swap-handling-code
+++ a/kernel/power/swap.c
@@ -41,10 +41,121 @@ static struct swsusp_header {
 } __attribute__((packed, aligned(PAGE_SIZE))) swsusp_header;
 
 /*
- * Saving part...
+ * General things
  */
 
 static unsigned short root_swap = 0xffff;
+static struct block_device *resume_bdev;
+
+/**
+ *	submit - submit BIO request.
+ *	@rw:	READ or WRITE.
+ *	@off	physical offset of page.
+ *	@page:	page we're reading or writing.
+ *	@bio_chain: list of pending biod (for async reading)
+ *
+ *	Straight from the textbook - allocate and initialize the bio.
+ *	If we're reading, make sure the page is marked as dirty.
+ *	Then submit it and, if @bio_chain == NULL, wait.
+ */
+static int submit(int rw, pgoff_t page_off, struct page *page,
+			struct bio **bio_chain)
+{
+	struct bio *bio;
+
+	bio = bio_alloc(GFP_ATOMIC, 1);
+	if (!bio)
+		return -ENOMEM;
+	bio->bi_sector = page_off * (PAGE_SIZE >> 9);
+	bio->bi_bdev = resume_bdev;
+	bio->bi_end_io = end_swap_bio_read;
+
+	if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
+		printk("swsusp: ERROR: adding page to bio at %ld\n", page_off);
+		bio_put(bio);
+		return -EFAULT;
+	}
+
+	lock_page(page);
+	bio_get(bio);
+
+	if (bio_chain == NULL) {
+		submit_bio(rw | (1 << BIO_RW_SYNC), bio);
+		wait_on_page_locked(page);
+		if (rw == READ)
+			bio_set_pages_dirty(bio);
+		bio_put(bio);
+	} else {
+		if (rw == READ)
+			get_page(page);	/* These pages are freed later */
+		bio->bi_private = *bio_chain;
+		*bio_chain = bio;
+		submit_bio(rw | (1 << BIO_RW_SYNC), bio);
+	}
+	return 0;
+}
+
+static int bio_read_page(pgoff_t page_off, void *addr, struct bio **bio_chain)
+{
+	return submit(READ, page_off, virt_to_page(addr), bio_chain);
+}
+
+static int bio_write_page(pgoff_t page_off, void *addr)
+{
+	return submit(WRITE, page_off, virt_to_page(addr), NULL);
+}
+
+static int wait_on_bio_chain(struct bio **bio_chain)
+{
+	struct bio *bio;
+	struct bio *next_bio;
+	int ret = 0;
+
+	if (bio_chain == NULL)
+		return 0;
+
+	bio = *bio_chain;
+	if (bio == NULL)
+		return 0;
+	while (bio) {
+		struct page *page;
+
+		next_bio = bio->bi_private;
+		page = bio->bi_io_vec[0].bv_page;
+		wait_on_page_locked(page);
+		if (!PageUptodate(page) || PageError(page))
+			ret = -EIO;
+		put_page(page);
+		bio_put(bio);
+		bio = next_bio;
+	}
+	*bio_chain = NULL;
+	return ret;
+}
+
+static void show_speed(struct timeval *start, struct timeval *stop,
+			unsigned nr_pages, char *msg)
+{
+	s64 elapsed_centisecs64;
+	int centisecs;
+	int k;
+	int kps;
+
+	elapsed_centisecs64 = timeval_to_ns(stop) - timeval_to_ns(start);
+	do_div(elapsed_centisecs64, NSEC_PER_SEC / 100);
+	centisecs = elapsed_centisecs64;
+	if (centisecs == 0)
+		centisecs = 1;	/* avoid div-by-zero */
+	k = nr_pages * (PAGE_SIZE / 1024);
+	kps = (k * 100) / centisecs;
+	printk("%s %d kbytes in %d.%02d seconds (%d.%02d MB/s)\n", msg, k,
+			centisecs / 100, centisecs % 100,
+			kps / 1000, (kps % 1000) / 10);
+}
+
+/*
+ * Saving part
+ */
 
 static int mark_swapfiles(swp_entry_t start)
 {
@@ -166,26 +277,6 @@ static void release_swap_writer(struct s
 	handle->bitmap = NULL;
 }
 
-static void show_speed(struct timeval *start, struct timeval *stop,
-			unsigned nr_pages, char *msg)
-{
-	s64 elapsed_centisecs64;
-	int centisecs;
-	int k;
-	int kps;
-
-	elapsed_centisecs64 = timeval_to_ns(stop) - timeval_to_ns(start);
-	do_div(elapsed_centisecs64, NSEC_PER_SEC / 100);
-	centisecs = elapsed_centisecs64;
-	if (centisecs == 0)
-		centisecs = 1;	/* avoid div-by-zero */
-	k = nr_pages * (PAGE_SIZE / 1024);
-	kps = (k * 100) / centisecs;
-	printk("%s %d kbytes in %d.%02d seconds (%d.%02d MB/s)\n", msg, k,
-			centisecs / 100, centisecs % 100,
-			kps / 1000, (kps % 1000) / 10);
-}
-
 static int get_swap_writer(struct swap_map_handle *handle)
 {
 	handle->cur = (struct swap_map_page *)get_zeroed_page(GFP_KERNEL);
@@ -205,34 +296,6 @@ static int get_swap_writer(struct swap_m
 	return 0;
 }
 
-static int wait_on_bio_chain(struct bio **bio_chain)
-{
-	struct bio *bio;
-	struct bio *next_bio;
-	int ret = 0;
-
-	if (bio_chain == NULL)
-		return 0;
-
-	bio = *bio_chain;
-	if (bio == NULL)
-		return 0;
-	while (bio) {
-		struct page *page;
-
-		next_bio = bio->bi_private;
-		page = bio->bi_io_vec[0].bv_page;
-		wait_on_page_locked(page);
-		if (!PageUptodate(page) || PageError(page))
-			ret = -EIO;
-		put_page(page);
-		bio_put(bio);
-		bio = next_bio;
-	}
-	*bio_chain = NULL;
-	return ret;
-}
-
 static int swap_write_page(struct swap_map_handle *handle, void *buf,
 				struct bio **bio_chain)
 {
@@ -384,66 +447,6 @@ int swsusp_write(void)
 	return error;
 }
 
-static struct block_device *resume_bdev;
-
-/**
- *	submit - submit BIO request.
- *	@rw:	READ or WRITE.
- *	@off	physical offset of page.
- *	@page:	page we're reading or writing.
- *	@bio_chain: list of pending biod (for async reading)
- *
- *	Straight from the textbook - allocate and initialize the bio.
- *	If we're reading, make sure the page is marked as dirty.
- *	Then submit it and, if @bio_chain == NULL, wait.
- */
-static int submit(int rw, pgoff_t page_off, struct page *page,
-			struct bio **bio_chain)
-{
-	struct bio *bio;
-
-	bio = bio_alloc(GFP_ATOMIC, 1);
-	if (!bio)
-		return -ENOMEM;
-	bio->bi_sector = page_off * (PAGE_SIZE >> 9);
-	bio->bi_bdev = resume_bdev;
-	bio->bi_end_io = end_swap_bio_read;
-
-	if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
-		printk("swsusp: ERROR: adding page to bio at %ld\n", page_off);
-		bio_put(bio);
-		return -EFAULT;
-	}
-
-	lock_page(page);
-	bio_get(bio);
-
-	if (bio_chain == NULL) {
-		submit_bio(rw | (1 << BIO_RW_SYNC), bio);
-		wait_on_page_locked(page);
-		if (rw == READ)
-			bio_set_pages_dirty(bio);
-		bio_put(bio);
-	} else {
-		if (rw == READ)
-			get_page(page);	/* These pages are freed later */
-		bio->bi_private = *bio_chain;
-		*bio_chain = bio;
-		submit_bio(rw | (1 << BIO_RW_SYNC), bio);
-	}
-	return 0;
-}
-
-static int bio_read_page(pgoff_t page_off, void *addr, struct bio **bio_chain)
-{
-	return submit(READ, page_off, virt_to_page(addr), bio_chain);
-}
-
-static int bio_write_page(pgoff_t page_off, void *addr)
-{
-	return submit(WRITE, page_off, virt_to_page(addr), NULL);
-}
-
 /**
  *	The following functions allow us to read data using a swap map
  *	in a file-alike way
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
md-change-lifetime-rules-for-md-devices.patch

