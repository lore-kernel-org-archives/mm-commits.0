From: akpm@linux-foundation.org
Subject: [merged]
 mm-rename-various-offset-parameters-to-index.patch removed from -mm tree
Date: Tue, 02 Jun 2020 14:38:23 -0700
Message-ID: <20200602213823.SQGzs62Mp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgFBViZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:38:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darrick.wong@oracle.com, dchinner@redhat.com, ebiggers@google.com, gaoxiang25@huawei.com, hch@lst.de, jaegeuk@kernel.org, jhubbard@nvidia.com, johannes.thumshirn@wdc.com, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mhocko@suse.com, mm-commits@vger.kernel.org, mszeredi@redhat.com, william.kucharski@oracle.com, willy@infradead.org, xiyou.wangcong@gmail.com, yuchao0@huawei.com, ziy@nvidia.com


The patch titled
     Subject: mm: rename various 'offset' parameters to 'index'
has been removed from the -mm tree.  Its filename was
     mm-rename-various-offset-parameters-to-index.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: rename various 'offset' parameters to 'index'

The word 'offset' is used ambiguously to mean 'byte offset within a page',
'byte offset from the start of the file' and 'page offset from the start
of the file'.  Use 'index' to mean 'page offset from the start of the
file' throughout the readahead code.

Link: http://lkml.kernel.org/r/20200414150233.24495-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Cc: Chao Yu <yuchao0@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Gao Xiang <gaoxiang25@huawei.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   86 ++++++++++++++++++++++-------------------------
 1 file changed, 42 insertions(+), 44 deletions(-)

--- a/mm/readahead.c~mm-rename-various-offset-parameters-to-index
+++ a/mm/readahead.c
@@ -156,7 +156,7 @@ out:
  * We really don't want to intermingle reads and writes like that.
  */
 void __do_page_cache_readahead(struct address_space *mapping,
-		struct file *filp, pgoff_t offset, unsigned long nr_to_read,
+		struct file *filp, pgoff_t index, unsigned long nr_to_read,
 		unsigned long lookahead_size)
 {
 	struct inode *inode = mapping->host;
@@ -180,7 +180,7 @@ void __do_page_cache_readahead(struct ad
 	 * Preallocate as many pages as we will need.
 	 */
 	for (page_idx = 0; page_idx < nr_to_read; page_idx++) {
-		pgoff_t page_offset = offset + page_idx;
+		pgoff_t page_offset = index + page_idx;
 
 		if (page_offset > end_index)
 			break;
@@ -219,7 +219,7 @@ void __do_page_cache_readahead(struct ad
  * memory at once.
  */
 void force_page_cache_readahead(struct address_space *mapping,
-		struct file *filp, pgoff_t offset, unsigned long nr_to_read)
+		struct file *filp, pgoff_t index, unsigned long nr_to_read)
 {
 	struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
 	struct file_ra_state *ra = &filp->f_ra;
@@ -239,9 +239,9 @@ void force_page_cache_readahead(struct a
 
 		if (this_chunk > nr_to_read)
 			this_chunk = nr_to_read;
-		__do_page_cache_readahead(mapping, filp, offset, this_chunk, 0);
+		__do_page_cache_readahead(mapping, filp, index, this_chunk, 0);
 
-		offset += this_chunk;
+		index += this_chunk;
 		nr_to_read -= this_chunk;
 	}
 }
@@ -322,21 +322,21 @@ static unsigned long get_next_ra_size(st
  */
 
 /*
- * Count contiguously cached pages from @offset-1 to @offset-@max,
+ * Count contiguously cached pages from @index-1 to @index-@max,
  * this count is a conservative estimation of
  * 	- length of the sequential read sequence, or
  * 	- thrashing threshold in memory tight systems
  */
 static pgoff_t count_history_pages(struct address_space *mapping,
-				   pgoff_t offset, unsigned long max)
+				   pgoff_t index, unsigned long max)
 {
 	pgoff_t head;
 
 	rcu_read_lock();
-	head = page_cache_prev_miss(mapping, offset - 1, max);
+	head = page_cache_prev_miss(mapping, index - 1, max);
 	rcu_read_unlock();
 
-	return offset - 1 - head;
+	return index - 1 - head;
 }
 
 /*
@@ -344,13 +344,13 @@ static pgoff_t count_history_pages(struc
  */
 static int try_context_readahead(struct address_space *mapping,
 				 struct file_ra_state *ra,
-				 pgoff_t offset,
+				 pgoff_t index,
 				 unsigned long req_size,
 				 unsigned long max)
 {
 	pgoff_t size;
 
-	size = count_history_pages(mapping, offset, max);
+	size = count_history_pages(mapping, index, max);
 
 	/*
 	 * not enough history pages:
@@ -363,10 +363,10 @@ static int try_context_readahead(struct
 	 * starts from beginning of file:
 	 * it is a strong indication of long-run stream (or whole-file-read)
 	 */
-	if (size >= offset)
+	if (size >= index)
 		size *= 2;
 
-	ra->start = offset;
+	ra->start = index;
 	ra->size = min(size + req_size, max);
 	ra->async_size = 1;
 
@@ -378,13 +378,13 @@ static int try_context_readahead(struct
  */
 static void ondemand_readahead(struct address_space *mapping,
 		struct file_ra_state *ra, struct file *filp,
-		bool hit_readahead_marker, pgoff_t offset,
+		bool hit_readahead_marker, pgoff_t index,
 		unsigned long req_size)
 {
 	struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
 	unsigned long max_pages = ra->ra_pages;
 	unsigned long add_pages;
-	pgoff_t prev_offset;
+	pgoff_t prev_index;
 
 	/*
 	 * If the request exceeds the readahead window, allow the read to
@@ -396,15 +396,15 @@ static void ondemand_readahead(struct ad
 	/*
 	 * start of file
 	 */
-	if (!offset)
+	if (!index)
 		goto initial_readahead;
 
 	/*
-	 * It's the expected callback offset, assume sequential access.
+	 * It's the expected callback index, assume sequential access.
 	 * Ramp up sizes, and push forward the readahead window.
 	 */
-	if ((offset == (ra->start + ra->size - ra->async_size) ||
-	     offset == (ra->start + ra->size))) {
+	if ((index == (ra->start + ra->size - ra->async_size) ||
+	     index == (ra->start + ra->size))) {
 		ra->start += ra->size;
 		ra->size = get_next_ra_size(ra, max_pages);
 		ra->async_size = ra->size;
@@ -421,14 +421,14 @@ static void ondemand_readahead(struct ad
 		pgoff_t start;
 
 		rcu_read_lock();
-		start = page_cache_next_miss(mapping, offset + 1, max_pages);
+		start = page_cache_next_miss(mapping, index + 1, max_pages);
 		rcu_read_unlock();
 
-		if (!start || start - offset > max_pages)
+		if (!start || start - index > max_pages)
 			return;
 
 		ra->start = start;
-		ra->size = start - offset;	/* old async_size */
+		ra->size = start - index;	/* old async_size */
 		ra->size += req_size;
 		ra->size = get_next_ra_size(ra, max_pages);
 		ra->async_size = ra->size;
@@ -443,29 +443,29 @@ static void ondemand_readahead(struct ad
 
 	/*
 	 * sequential cache miss
-	 * trivial case: (offset - prev_offset) == 1
-	 * unaligned reads: (offset - prev_offset) == 0
+	 * trivial case: (index - prev_index) == 1
+	 * unaligned reads: (index - prev_index) == 0
 	 */
-	prev_offset = (unsigned long long)ra->prev_pos >> PAGE_SHIFT;
-	if (offset - prev_offset <= 1UL)
+	prev_index = (unsigned long long)ra->prev_pos >> PAGE_SHIFT;
+	if (index - prev_index <= 1UL)
 		goto initial_readahead;
 
 	/*
 	 * Query the page cache and look for the traces(cached history pages)
 	 * that a sequential stream would leave behind.
 	 */
-	if (try_context_readahead(mapping, ra, offset, req_size, max_pages))
+	if (try_context_readahead(mapping, ra, index, req_size, max_pages))
 		goto readit;
 
 	/*
 	 * standalone, small random read
 	 * Read as is, and do not pollute the readahead state.
 	 */
-	__do_page_cache_readahead(mapping, filp, offset, req_size, 0);
+	__do_page_cache_readahead(mapping, filp, index, req_size, 0);
 	return;
 
 initial_readahead:
-	ra->start = offset;
+	ra->start = index;
 	ra->size = get_init_ra_size(req_size, max_pages);
 	ra->async_size = ra->size > req_size ? ra->size - req_size : ra->size;
 
@@ -476,7 +476,7 @@ readit:
 	 * the resulted next readahead window into the current one.
 	 * Take care of maximum IO pages as above.
 	 */
-	if (offset == ra->start && ra->size == ra->async_size) {
+	if (index == ra->start && ra->size == ra->async_size) {
 		add_pages = get_next_ra_size(ra, max_pages);
 		if (ra->size + add_pages <= max_pages) {
 			ra->async_size = add_pages;
@@ -495,9 +495,8 @@ readit:
  * @mapping: address_space which holds the pagecache and I/O vectors
  * @ra: file_ra_state which holds the readahead state
  * @filp: passed on to ->readpage() and ->readpages()
- * @offset: start offset into @mapping, in pagecache page-sized units
- * @req_size: hint: total size of the read which the caller is performing in
- *            pagecache pages
+ * @index: Index of first page to be read.
+ * @req_count: Total number of pages being read by the caller.
  *
  * page_cache_sync_readahead() should be called when a cache miss happened:
  * it will submit the read.  The readahead logic may decide to piggyback more
@@ -506,7 +505,7 @@ readit:
  */
 void page_cache_sync_readahead(struct address_space *mapping,
 			       struct file_ra_state *ra, struct file *filp,
-			       pgoff_t offset, unsigned long req_size)
+			       pgoff_t index, unsigned long req_count)
 {
 	/* no read-ahead */
 	if (!ra->ra_pages)
@@ -517,12 +516,12 @@ void page_cache_sync_readahead(struct ad
 
 	/* be dumb */
 	if (filp && (filp->f_mode & FMODE_RANDOM)) {
-		force_page_cache_readahead(mapping, filp, offset, req_size);
+		force_page_cache_readahead(mapping, filp, index, req_count);
 		return;
 	}
 
 	/* do read-ahead */
-	ondemand_readahead(mapping, ra, filp, false, offset, req_size);
+	ondemand_readahead(mapping, ra, filp, false, index, req_count);
 }
 EXPORT_SYMBOL_GPL(page_cache_sync_readahead);
 
@@ -531,21 +530,20 @@ EXPORT_SYMBOL_GPL(page_cache_sync_readah
  * @mapping: address_space which holds the pagecache and I/O vectors
  * @ra: file_ra_state which holds the readahead state
  * @filp: passed on to ->readpage() and ->readpages()
- * @page: the page at @offset which has the PG_readahead flag set
- * @offset: start offset into @mapping, in pagecache page-sized units
- * @req_size: hint: total size of the read which the caller is performing in
- *            pagecache pages
+ * @page: The page at @index which triggered the readahead call.
+ * @index: Index of first page to be read.
+ * @req_count: Total number of pages being read by the caller.
  *
  * page_cache_async_readahead() should be called when a page is used which
- * has the PG_readahead flag; this is a marker to suggest that the application
+ * is marked as PageReadahead; this is a marker to suggest that the application
  * has used up enough of the readahead window that we should start pulling in
  * more pages.
  */
 void
 page_cache_async_readahead(struct address_space *mapping,
 			   struct file_ra_state *ra, struct file *filp,
-			   struct page *page, pgoff_t offset,
-			   unsigned long req_size)
+			   struct page *page, pgoff_t index,
+			   unsigned long req_count)
 {
 	/* no read-ahead */
 	if (!ra->ra_pages)
@@ -569,7 +567,7 @@ page_cache_async_readahead(struct addres
 		return;
 
 	/* do read-ahead */
-	ondemand_readahead(mapping, ra, filp, true, offset, req_size);
+	ondemand_readahead(mapping, ra, filp, true, index, req_count);
 }
 EXPORT_SYMBOL_GPL(page_cache_async_readahead);
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-simplify-calling-a-compound-page-destructor.patch
ipc-convert-ipcs_idr-to-xarray.patch
ipc-convert-ipcs_idr-to-xarray-update.patch
