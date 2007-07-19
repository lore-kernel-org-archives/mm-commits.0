From: akpm@linux-foundation.org
Subject: - readahead-remove-the-old-algorithm.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:01:20 -0700
Message-ID: <200707192001.l6JK1KsL019528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47729 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932204AbXGSU3r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:29:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, linuxram@us.ibm.com, rusty@rustcorp.com.au, slpratt@austin.ibm.com, mm-commits@vger.kernel.org


The patch titled
     readahead: remove the old algorithm
has been removed from the -mm tree.  Its filename was
     readahead-remove-the-old-algorithm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: readahead: remove the old algorithm
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Remove the old readahead algorithm.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Steven Pratt <slpratt@austin.ibm.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |   11 -
 include/linux/mm.h |    7 
 mm/readahead.c     |  373 ++-----------------------------------------
 3 files changed, 26 insertions(+), 365 deletions(-)

diff -puN include/linux/fs.h~readahead-remove-the-old-algorithm include/linux/fs.h
--- a/include/linux/fs.h~readahead-remove-the-old-algorithm
+++ a/include/linux/fs.h
@@ -701,14 +701,6 @@ struct fown_struct {
  *  file_ra_state.la_index    .ra_index   .lookahead_index   .readahead_index
  */
 struct file_ra_state {
-	unsigned long start;		/* Current window */
-	unsigned long size;
-	unsigned long flags;		/* ra flags RA_FLAG_xxx*/
-	unsigned long cache_hit;	/* cache hit count*/
-	unsigned long prev_index;	/* Cache last read() position */
-	unsigned long ahead_start;	/* Ahead window */
-	unsigned long ahead_size;
-
 	pgoff_t la_index;               /* enqueue time */
 	pgoff_t ra_index;               /* begin offset */
 	pgoff_t lookahead_index;        /* time to do next readahead */
@@ -717,10 +709,9 @@ struct file_ra_state {
 	unsigned long ra_pages;		/* Maximum readahead window */
 	unsigned long mmap_hit;		/* Cache hit stat for mmap accesses */
 	unsigned long mmap_miss;	/* Cache miss stat for mmap accesses */
+	unsigned long prev_index;	/* Cache last read() position */
 	unsigned int prev_offset;	/* Offset where last read() ended in a page */
 };
-#define RA_FLAG_MISS 0x01	/* a cache miss occured against this file */
-#define RA_FLAG_INCACHE 0x02	/* file is already in cache */
 
 /*
  * Measuring read-ahead sizes.
diff -puN include/linux/mm.h~readahead-remove-the-old-algorithm include/linux/mm.h
--- a/include/linux/mm.h~readahead-remove-the-old-algorithm
+++ a/include/linux/mm.h
@@ -1144,13 +1144,6 @@ unsigned long page_cache_readahead_ondem
 			  struct page *page,
 			  pgoff_t offset,
 			  unsigned long size);
-unsigned long page_cache_readahead(struct address_space *mapping,
-			  struct file_ra_state *ra,
-			  struct file *filp,
-			  pgoff_t offset,
-			  unsigned long size);
-void handle_ra_miss(struct address_space *mapping, 
-		    struct file_ra_state *ra, pgoff_t offset);
 unsigned long max_sane_readahead(unsigned long nr);
 
 /* Do stack extension */
diff -puN mm/readahead.c~readahead-remove-the-old-algorithm mm/readahead.c
--- a/mm/readahead.c~readahead-remove-the-old-algorithm
+++ a/mm/readahead.c
@@ -49,82 +49,6 @@ file_ra_state_init(struct file_ra_state 
 }
 EXPORT_SYMBOL_GPL(file_ra_state_init);
 
-/*
- * Return max readahead size for this inode in number-of-pages.
- */
-static inline unsigned long get_max_readahead(struct file_ra_state *ra)
-{
-	return ra->ra_pages;
-}
-
-static inline unsigned long get_min_readahead(struct file_ra_state *ra)
-{
-	return MIN_RA_PAGES;
-}
-
-static inline void reset_ahead_window(struct file_ra_state *ra)
-{
-	/*
-	 * ... but preserve ahead_start + ahead_size value,
-	 * see 'recheck:' label in page_cache_readahead().
-	 * Note: We never use ->ahead_size as rvalue without
-	 * checking ->ahead_start != 0 first.
-	 */
-	ra->ahead_size += ra->ahead_start;
-	ra->ahead_start = 0;
-}
-
-static inline void ra_off(struct file_ra_state *ra)
-{
-	ra->start = 0;
-	ra->flags = 0;
-	ra->size = 0;
-	reset_ahead_window(ra);
-	return;
-}
-
-/*
- * Set the initial window size, round to next power of 2 and square
- * for small size, x 4 for medium, and x 2 for large
- * for 128k (32 page) max ra
- * 1-8 page = 32k initial, > 8 page = 128k initial
- */
-static unsigned long get_init_ra_size(unsigned long size, unsigned long max)
-{
-	unsigned long newsize = roundup_pow_of_two(size);
-
-	if (newsize <= max / 32)
-		newsize = newsize * 4;
-	else if (newsize <= max / 4)
-		newsize = newsize * 2;
-	else
-		newsize = max;
-	return newsize;
-}
-
-/*
- * Set the new window size, this is called only when I/O is to be submitted,
- * not for each call to readahead.  If a cache miss occured, reduce next I/O
- * size, else increase depending on how close to max we are.
- */
-static inline unsigned long get_next_ra_size(struct file_ra_state *ra)
-{
-	unsigned long max = get_max_readahead(ra);
-	unsigned long min = get_min_readahead(ra);
-	unsigned long cur = ra->size;
-	unsigned long newsize;
-
-	if (ra->flags & RA_FLAG_MISS) {
-		ra->flags &= ~RA_FLAG_MISS;
-		newsize = max((cur - 2), min);
-	} else if (cur < max / 16) {
-		newsize = 4 * cur;
-	} else {
-		newsize = 2 * cur;
-	}
-	return min(newsize, max);
-}
-
 #define list_to_page(head) (list_entry((head)->prev, struct page, lru))
 
 /**
@@ -201,66 +125,6 @@ out:
 }
 
 /*
- * Readahead design.
- *
- * The fields in struct file_ra_state represent the most-recently-executed
- * readahead attempt:
- *
- * start:	Page index at which we started the readahead
- * size:	Number of pages in that read
- *              Together, these form the "current window".
- *              Together, start and size represent the `readahead window'.
- * prev_index:  The page which the readahead algorithm most-recently inspected.
- *              It is mainly used to detect sequential file reading.
- *              If page_cache_readahead sees that it is again being called for
- *              a page which it just looked at, it can return immediately without
- *              making any state changes.
- * offset:      Offset in the prev_index where the last read ended - used for
- *              detection of sequential file reading.
- * ahead_start,
- * ahead_size:  Together, these form the "ahead window".
- * ra_pages:	The externally controlled max readahead for this fd.
- *
- * When readahead is in the off state (size == 0), readahead is disabled.
- * In this state, prev_index is used to detect the resumption of sequential I/O.
- *
- * The readahead code manages two windows - the "current" and the "ahead"
- * windows.  The intent is that while the application is walking the pages
- * in the current window, I/O is underway on the ahead window.  When the
- * current window is fully traversed, it is replaced by the ahead window
- * and the ahead window is invalidated.  When this copying happens, the
- * new current window's pages are probably still locked.  So
- * we submit a new batch of I/O immediately, creating a new ahead window.
- *
- * So:
- *
- *   ----|----------------|----------------|-----
- *       ^start           ^start+size
- *                        ^ahead_start     ^ahead_start+ahead_size
- *
- *         ^ When this page is read, we submit I/O for the
- *           ahead window.
- *
- * A `readahead hit' occurs when a read request is made against a page which is
- * the next sequential page. Ahead window calculations are done only when it
- * is time to submit a new IO.  The code ramps up the size agressively at first,
- * but slow down as it approaches max_readhead.
- *
- * Any seek/ramdom IO will result in readahead being turned off.  It will resume
- * at the first sequential access.
- *
- * There is a special-case: if the first page which the application tries to
- * read happens to be the first page of the file, it is assumed that a linear
- * read is about to happen and the window is immediately set to the initial size
- * based on I/O request size and the max_readahead.
- *
- * This function is to be called for every read request, rather than when
- * it is time to perform readahead.  It is called only once for the entire I/O
- * regardless of size unless readahead is unable to start enough I/O to satisfy
- * the request (I/O request > max_readahead).
- */
-
-/*
  * do_page_cache_readahead actually reads a chunk of disk.  It allocates all
  * the pages first, then submits them all for I/O. This avoids the very bad
  * behaviour which would occur if page allocations are causing VM writeback.
@@ -295,7 +159,7 @@ __do_page_cache_readahead(struct address
 	read_lock_irq(&mapping->tree_lock);
 	for (page_idx = 0; page_idx < nr_to_read; page_idx++) {
 		pgoff_t page_offset = offset + page_idx;
-		
+
 		if (page_offset > end_index)
 			break;
 
@@ -361,28 +225,6 @@ int force_page_cache_readahead(struct ad
 }
 
 /*
- * Check how effective readahead is being.  If the amount of started IO is
- * less than expected then the file is partly or fully in pagecache and
- * readahead isn't helping.
- *
- */
-static inline int check_ra_success(struct file_ra_state *ra,
-			unsigned long nr_to_read, unsigned long actual)
-{
-	if (actual == 0) {
-		ra->cache_hit += nr_to_read;
-		if (ra->cache_hit >= VM_MAX_CACHE_HIT) {
-			ra_off(ra);
-			ra->flags |= RA_FLAG_INCACHE;
-			return 0;
-		}
-	} else {
-		ra->cache_hit=0;
-	}
-	return 1;
-}
-
-/*
  * This version skips the IO if the queue is read-congested, and will tell the
  * block layer to abandon the readahead if request allocation would block.
  *
@@ -399,191 +241,6 @@ int do_page_cache_readahead(struct addre
 }
 
 /*
- * Read 'nr_to_read' pages starting at page 'offset'. If the flag 'block'
- * is set wait till the read completes.  Otherwise attempt to read without
- * blocking.
- * Returns 1 meaning 'success' if read is successful without switching off
- * readahead mode. Otherwise return failure.
- */
-static int
-blockable_page_cache_readahead(struct address_space *mapping, struct file *filp,
-			pgoff_t offset, unsigned long nr_to_read,
-			struct file_ra_state *ra, int block)
-{
-	int actual;
-
-	if (!block && bdi_read_congested(mapping->backing_dev_info))
-		return 0;
-
-	actual = __do_page_cache_readahead(mapping, filp, offset, nr_to_read, 0);
-
-	return check_ra_success(ra, nr_to_read, actual);
-}
-
-static int make_ahead_window(struct address_space *mapping, struct file *filp,
-				struct file_ra_state *ra, int force)
-{
-	int block, ret;
-
-	ra->ahead_size = get_next_ra_size(ra);
-	ra->ahead_start = ra->start + ra->size;
-
-	block = force || (ra->prev_index >= ra->ahead_start);
-	ret = blockable_page_cache_readahead(mapping, filp,
-			ra->ahead_start, ra->ahead_size, ra, block);
-
-	if (!ret && !force) {
-		/* A read failure in blocking mode, implies pages are
-		 * all cached. So we can safely assume we have taken
-		 * care of all the pages requested in this call.
-		 * A read failure in non-blocking mode, implies we are
-		 * reading more pages than requested in this call.  So
-		 * we safely assume we have taken care of all the pages
-		 * requested in this call.
-		 *
-		 * Just reset the ahead window in case we failed due to
-		 * congestion.  The ahead window will any way be closed
-		 * in case we failed due to excessive page cache hits.
-		 */
-		reset_ahead_window(ra);
-	}
-
-	return ret;
-}
-
-/**
- * page_cache_readahead - generic adaptive readahead
- * @mapping: address_space which holds the pagecache and I/O vectors
- * @ra: file_ra_state which holds the readahead state
- * @filp: passed on to ->readpage() and ->readpages()
- * @offset: start offset into @mapping, in PAGE_CACHE_SIZE units
- * @req_size: hint: total size of the read which the caller is performing in
- *            PAGE_CACHE_SIZE units
- *
- * page_cache_readahead() is the main function.  It performs the adaptive
- * readahead window size management and submits the readahead I/O.
- *
- * Note that @filp is purely used for passing on to the ->readpage[s]()
- * handler: it may refer to a different file from @mapping (so we may not use
- * @filp->f_mapping or @filp->f_path.dentry->d_inode here).
- * Also, @ra may not be equal to &@filp->f_ra.
- *
- */
-unsigned long
-page_cache_readahead(struct address_space *mapping, struct file_ra_state *ra,
-		     struct file *filp, pgoff_t offset, unsigned long req_size)
-{
-	unsigned long max, newsize;
-	int sequential;
-
-	/*
-	 * We avoid doing extra work and bogusly perturbing the readahead
-	 * window expansion logic.
-	 */
-	if (offset == ra->prev_index && --req_size)
-		++offset;
-
-	/* Note that prev_index == -1 if it is a first read */
-	sequential = (offset == ra->prev_index + 1);
-	ra->prev_index = offset;
-	ra->prev_offset = 0;
-
-	max = get_max_readahead(ra);
-	newsize = min(req_size, max);
-
-	/* No readahead or sub-page sized read or file already in cache */
-	if (newsize == 0 || (ra->flags & RA_FLAG_INCACHE))
-		goto out;
-
-	ra->prev_index += newsize - 1;
-
-	/*
-	 * Special case - first read at start of file. We'll assume it's
-	 * a whole-file read and grow the window fast.  Or detect first
-	 * sequential access
-	 */
-	if (sequential && ra->size == 0) {
-		ra->size = get_init_ra_size(newsize, max);
-		ra->start = offset;
-		if (!blockable_page_cache_readahead(mapping, filp, offset,
-							 ra->size, ra, 1))
-			goto out;
-
-		/*
-		 * If the request size is larger than our max readahead, we
-		 * at least want to be sure that we get 2 IOs in flight and
-		 * we know that we will definitly need the new I/O.
-		 * once we do this, subsequent calls should be able to overlap
-		 * IOs,* thus preventing stalls. so issue the ahead window
-		 * immediately.
-		 */
-		if (req_size >= max)
-			make_ahead_window(mapping, filp, ra, 1);
-
-		goto out;
-	}
-
-	/*
-	 * Now handle the random case:
-	 * partial page reads and first access were handled above,
-	 * so this must be the next page otherwise it is random
-	 */
-	if (!sequential) {
-		ra_off(ra);
-		blockable_page_cache_readahead(mapping, filp, offset,
-				 newsize, ra, 1);
-		goto out;
-	}
-
-	/*
-	 * If we get here we are doing sequential IO and this was not the first
-	 * occurence (ie we have an existing window)
-	 */
-	if (ra->ahead_start == 0) {	 /* no ahead window yet */
-		if (!make_ahead_window(mapping, filp, ra, 0))
-			goto recheck;
-	}
-
-	/*
-	 * Already have an ahead window, check if we crossed into it.
-	 * If so, shift windows and issue a new ahead window.
-	 * Only return the #pages that are in the current window, so that
-	 * we get called back on the first page of the ahead window which
-	 * will allow us to submit more IO.
-	 */
-	if (ra->prev_index >= ra->ahead_start) {
-		ra->start = ra->ahead_start;
-		ra->size = ra->ahead_size;
-		make_ahead_window(mapping, filp, ra, 0);
-recheck:
-		/* prev_index shouldn't overrun the ahead window */
-		ra->prev_index = min(ra->prev_index,
-			ra->ahead_start + ra->ahead_size - 1);
-	}
-
-out:
-	return ra->prev_index + 1;
-}
-EXPORT_SYMBOL_GPL(page_cache_readahead);
-
-/*
- * handle_ra_miss() is called when it is known that a page which should have
- * been present in the pagecache (we just did some readahead there) was in fact
- * not found.  This will happen if it was evicted by the VM (readahead
- * thrashing)
- *
- * Turn on the cache miss flag in the RA struct, this will cause the RA code
- * to reduce the RA size on the next read.
- */
-void handle_ra_miss(struct address_space *mapping,
-		struct file_ra_state *ra, pgoff_t offset)
-{
-	ra->flags |= RA_FLAG_MISS;
-	ra->flags &= ~RA_FLAG_INCACHE;
-	ra->cache_hit = 0;
-}
-
-/*
  * Given a desired number of PAGE_CACHE_SIZE readahead pages, return a
  * sensible upper limit.
  */
@@ -613,19 +270,39 @@ unsigned long ra_submit(struct file_ra_s
 EXPORT_SYMBOL_GPL(ra_submit);
 
 /*
+ * Set the initial window size, round to next power of 2 and square
+ * for small size, x 4 for medium, and x 2 for large
+ * for 128k (32 page) max ra
+ * 1-8 page = 32k initial, > 8 page = 128k initial
+ */
+static unsigned long get_init_ra_size(unsigned long size, unsigned long max)
+{
+	unsigned long newsize = roundup_pow_of_two(size);
+
+	if (newsize <= max / 32)
+		newsize = newsize * 4;
+	else if (newsize <= max / 4)
+		newsize = newsize * 2;
+	else
+		newsize = max;
+
+	return newsize;
+}
+
+/*
  *  Get the previous window size, ramp it up, and
  *  return it as the new window size.
  */
-static unsigned long get_next_ra_size2(struct file_ra_state *ra,
+static unsigned long get_next_ra_size(struct file_ra_state *ra,
 						unsigned long max)
 {
 	unsigned long cur = ra->readahead_index - ra->ra_index;
 	unsigned long newsize;
 
 	if (cur < max / 16)
-		newsize = cur * 4;
+		newsize = 4 * cur;
 	else
-		newsize = cur * 2;
+		newsize = 2 * cur;
 
 	return min(newsize, max);
 }
@@ -701,7 +378,7 @@ ondemand_readahead(struct address_space 
 	if (offset && (offset == ra->lookahead_index ||
 			offset == ra->readahead_index)) {
 		ra_index = ra->readahead_index;
-		ra_size = get_next_ra_size2(ra, max);
+		ra_size = get_next_ra_size(ra, max);
 		la_size = ra_size;
 		goto fill_ra;
 	}
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
