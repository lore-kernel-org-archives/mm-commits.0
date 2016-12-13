From: akpm@linux-foundation.org
Subject: [patch 057/123] mm: don't cap request size based on read-ahead
 setting
Date: Mon, 12 Dec 2016 16:43:26 -0800
Message-ID: <584f442e.59wMvlODA4UMqtKJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41204 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932270AbcLMAn1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:43:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, axboe@fb.com, hannes@cmpxchg.org

From: Jens Axboe <axboe@fb.com>
Subject: mm: don't cap request size based on read-ahead setting

We ran into a funky issue, where someone doing 256K buffered reads saw
128K requests at the device level.  Turns out it is read-ahead capping the
request size, since we use 128K as the default setting.  This doesn't make
a lot of sense - if someone is issuing 256K reads, they should see 256K
reads, regardless of the read-ahead setting, if the underlying device can
support a 256K read in a single command.

This patch introduces a bdi hint, io_pages.  This is the soft max IO size
for the lower level, I've hooked it up to the bdev settings here. 
Read-ahead is modified to issue the maximum of the user request size, and
the read-ahead max size, but capped to the max request size on the device
side.  The latter is done to avoid reading ahead too much, if the
application asks for a huge read.  With this patch, the kernel behaves
like the application expects.

Link: http://lkml.kernel.org/r/1479498073-8657-1-git-send-email-axboe@fb.com
Signed-off-by: Jens Axboe <axboe@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-settings.c             |    1 
 block/blk-sysfs.c                |    1 
 include/linux/backing-dev-defs.h |    1 
 mm/readahead.c                   |   39 ++++++++++++++++++++---------
 4 files changed, 31 insertions(+), 11 deletions(-)

diff -puN block/blk-settings.c~mm-dont-cap-request-size-based-on-read-ahead-setting block/blk-settings.c
--- a/block/blk-settings.c~mm-dont-cap-request-size-based-on-read-ahead-setting
+++ a/block/blk-settings.c
@@ -249,6 +249,7 @@ void blk_queue_max_hw_sectors(struct req
 	max_sectors = min_not_zero(max_hw_sectors, limits->max_dev_sectors);
 	max_sectors = min_t(unsigned int, max_sectors, BLK_DEF_MAX_SECTORS);
 	limits->max_sectors = max_sectors;
+	q->backing_dev_info.io_pages = max_sectors >> (PAGE_SHIFT - 9);
 }
 EXPORT_SYMBOL(blk_queue_max_hw_sectors);
 
diff -puN block/blk-sysfs.c~mm-dont-cap-request-size-based-on-read-ahead-setting block/blk-sysfs.c
--- a/block/blk-sysfs.c~mm-dont-cap-request-size-based-on-read-ahead-setting
+++ a/block/blk-sysfs.c
@@ -212,6 +212,7 @@ queue_max_sectors_store(struct request_q
 
 	spin_lock_irq(q->queue_lock);
 	q->limits.max_sectors = max_sectors_kb << 1;
+	q->backing_dev_info.io_pages = max_sectors_kb >> (PAGE_SHIFT - 10);
 	spin_unlock_irq(q->queue_lock);
 
 	return ret;
diff -puN include/linux/backing-dev-defs.h~mm-dont-cap-request-size-based-on-read-ahead-setting include/linux/backing-dev-defs.h
--- a/include/linux/backing-dev-defs.h~mm-dont-cap-request-size-based-on-read-ahead-setting
+++ a/include/linux/backing-dev-defs.h
@@ -136,6 +136,7 @@ struct bdi_writeback {
 struct backing_dev_info {
 	struct list_head bdi_list;
 	unsigned long ra_pages;	/* max readahead in PAGE_SIZE units */
+	unsigned long io_pages;	/* max allowed IO size */
 	unsigned int capabilities; /* Device capabilities */
 	congested_fn *congested_fn; /* Function pointer if device is md/dm */
 	void *congested_data;	/* Pointer to aux data for congested func */
diff -puN mm/readahead.c~mm-dont-cap-request-size-based-on-read-ahead-setting mm/readahead.c
--- a/mm/readahead.c~mm-dont-cap-request-size-based-on-read-ahead-setting
+++ a/mm/readahead.c
@@ -207,12 +207,21 @@ out:
  * memory at once.
  */
 int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
-		pgoff_t offset, unsigned long nr_to_read)
+			       pgoff_t offset, unsigned long nr_to_read)
 {
+	struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
+	struct file_ra_state *ra = &filp->f_ra;
+	unsigned long max_pages;
+
 	if (unlikely(!mapping->a_ops->readpage && !mapping->a_ops->readpages))
 		return -EINVAL;
 
-	nr_to_read = min(nr_to_read, inode_to_bdi(mapping->host)->ra_pages);
+	/*
+	 * If the request exceeds the readahead window, allow the read to
+	 * be up to the optimal hardware IO size
+	 */
+	max_pages = max_t(unsigned long, bdi->io_pages, ra->ra_pages);
+	nr_to_read = min(nr_to_read, max_pages);
 	while (nr_to_read) {
 		int err;
 
@@ -369,10 +378,18 @@ ondemand_readahead(struct address_space
 		   bool hit_readahead_marker, pgoff_t offset,
 		   unsigned long req_size)
 {
-	unsigned long max = ra->ra_pages;
+	struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
+	unsigned long max_pages = ra->ra_pages;
 	pgoff_t prev_offset;
 
 	/*
+	 * If the request exceeds the readahead window, allow the read to
+	 * be up to the optimal hardware IO size
+	 */
+	if (req_size > max_pages && bdi->io_pages > max_pages)
+		max_pages = min(req_size, bdi->io_pages);
+
+	/*
 	 * start of file
 	 */
 	if (!offset)
@@ -385,7 +402,7 @@ ondemand_readahead(struct address_space
 	if ((offset == (ra->start + ra->size - ra->async_size) ||
 	     offset == (ra->start + ra->size))) {
 		ra->start += ra->size;
-		ra->size = get_next_ra_size(ra, max);
+		ra->size = get_next_ra_size(ra, max_pages);
 		ra->async_size = ra->size;
 		goto readit;
 	}
@@ -400,16 +417,16 @@ ondemand_readahead(struct address_space
 		pgoff_t start;
 
 		rcu_read_lock();
-		start = page_cache_next_hole(mapping, offset + 1, max);
+		start = page_cache_next_hole(mapping, offset + 1, max_pages);
 		rcu_read_unlock();
 
-		if (!start || start - offset > max)
+		if (!start || start - offset > max_pages)
 			return 0;
 
 		ra->start = start;
 		ra->size = start - offset;	/* old async_size */
 		ra->size += req_size;
-		ra->size = get_next_ra_size(ra, max);
+		ra->size = get_next_ra_size(ra, max_pages);
 		ra->async_size = ra->size;
 		goto readit;
 	}
@@ -417,7 +434,7 @@ ondemand_readahead(struct address_space
 	/*
 	 * oversize read
 	 */
-	if (req_size > max)
+	if (req_size > max_pages)
 		goto initial_readahead;
 
 	/*
@@ -433,7 +450,7 @@ ondemand_readahead(struct address_space
 	 * Query the page cache and look for the traces(cached history pages)
 	 * that a sequential stream would leave behind.
 	 */
-	if (try_context_readahead(mapping, ra, offset, req_size, max))
+	if (try_context_readahead(mapping, ra, offset, req_size, max_pages))
 		goto readit;
 
 	/*
@@ -444,7 +461,7 @@ ondemand_readahead(struct address_space
 
 initial_readahead:
 	ra->start = offset;
-	ra->size = get_init_ra_size(req_size, max);
+	ra->size = get_init_ra_size(req_size, max_pages);
 	ra->async_size = ra->size > req_size ? ra->size - req_size : ra->size;
 
 readit:
@@ -454,7 +471,7 @@ readit:
 	 * the resulted next readahead window into the current one.
 	 */
 	if (offset == ra->start && ra->size == ra->async_size) {
-		ra->async_size = get_next_ra_size(ra, max);
+		ra->async_size = get_next_ra_size(ra, max_pages);
 		ra->size += ra->async_size;
 	}
 
_
