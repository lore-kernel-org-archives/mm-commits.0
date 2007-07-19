From: akpm@linux-foundation.org
Subject: - readahead-sanify-file_ra_state-names.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:01:30 -0700
Message-ID: <200707192001.l6JK1UYP019543@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45091 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757157AbXGSUXp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:23:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     readahead: sanify file_ra_state names
has been removed from the -mm tree.  Its filename was
     readahead-sanify-file_ra_state-names.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: readahead: sanify file_ra_state names
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Rename some file_ra_state variables and remove some accessors.

It results in much simpler code.
Kudos to Rusty!

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |   61 +++-----------------------------------
 mm/readahead.c     |   68 +++++++++++++++----------------------------
 2 files changed, 31 insertions(+), 98 deletions(-)

diff -puN include/linux/fs.h~readahead-sanify-file_ra_state-names include/linux/fs.h
--- a/include/linux/fs.h~readahead-sanify-file_ra_state-names
+++ a/include/linux/fs.h
@@ -695,16 +695,12 @@ struct fown_struct {
 
 /*
  * Track a single file's readahead state
- *
- *  ================#============|==================#==================|
- *                  ^            ^                  ^                  ^
- *  file_ra_state.la_index    .ra_index   .lookahead_index   .readahead_index
  */
 struct file_ra_state {
-	pgoff_t la_index;               /* enqueue time */
-	pgoff_t ra_index;               /* begin offset */
-	pgoff_t lookahead_index;        /* time to do next readahead */
-	pgoff_t readahead_index;        /* end offset */
+	pgoff_t start;                  /* where readahead started */
+	unsigned long size;             /* # of readahead pages */
+	unsigned long async_size;       /* do asynchronous readahead when
+					   there are only # of pages ahead */
 
 	unsigned long ra_pages;		/* Maximum readahead window */
 	unsigned long mmap_hit;		/* Cache hit stat for mmap accesses */
@@ -714,59 +710,14 @@ struct file_ra_state {
 };
 
 /*
- * Measuring read-ahead sizes.
- *
- *                  |----------- readahead size ------------>|
- *  ===#============|==================#=====================|
- *     |------- invoke interval ------>|-- lookahead size -->|
- */
-static inline unsigned long ra_readahead_size(struct file_ra_state *ra)
-{
-	return ra->readahead_index - ra->ra_index;
-}
-
-static inline unsigned long ra_lookahead_size(struct file_ra_state *ra)
-{
-	return ra->readahead_index - ra->lookahead_index;
-}
-
-static inline unsigned long ra_invoke_interval(struct file_ra_state *ra)
-{
-	return ra->lookahead_index - ra->la_index;
-}
-
-/*
  * Check if @index falls in the readahead windows.
  */
 static inline int ra_has_index(struct file_ra_state *ra, pgoff_t index)
 {
-	return (index >= ra->la_index &&
-		index <  ra->readahead_index);
-}
-
-/*
- * Where is the old read-ahead and look-ahead?
- */
-static inline void ra_set_index(struct file_ra_state *ra,
-				pgoff_t la_index, pgoff_t ra_index)
-{
-	ra->la_index = la_index;
-	ra->ra_index = ra_index;
+	return (index >= ra->start &&
+		index <  ra->start + ra->size);
 }
 
-/*
- * Where is the new read-ahead and look-ahead?
- */
-static inline void ra_set_size(struct file_ra_state *ra,
-				unsigned long ra_size, unsigned long la_size)
-{
-	ra->readahead_index = ra->ra_index + ra_size;
-	ra->lookahead_index = ra->ra_index + ra_size - la_size;
-}
-
-unsigned long ra_submit(struct file_ra_state *ra,
-		       struct address_space *mapping, struct file *filp);
-
 struct file {
 	/*
 	 * fu_list becomes invalid after file_free is called and queued via
diff -puN mm/readahead.c~readahead-sanify-file_ra_state-names mm/readahead.c
--- a/mm/readahead.c~readahead-sanify-file_ra_state-names
+++ a/mm/readahead.c
@@ -253,21 +253,16 @@ unsigned long max_sane_readahead(unsigne
 /*
  * Submit IO for the read-ahead request in file_ra_state.
  */
-unsigned long ra_submit(struct file_ra_state *ra,
+static unsigned long ra_submit(struct file_ra_state *ra,
 		       struct address_space *mapping, struct file *filp)
 {
-	unsigned long ra_size;
-	unsigned long la_size;
 	int actual;
 
-	ra_size = ra_readahead_size(ra);
-	la_size = ra_lookahead_size(ra);
 	actual = __do_page_cache_readahead(mapping, filp,
-					ra->ra_index, ra_size, la_size);
+					ra->start, ra->size, ra->async_size);
 
 	return actual;
 }
-EXPORT_SYMBOL_GPL(ra_submit);
 
 /*
  * Set the initial window size, round to next power of 2 and square
@@ -296,7 +291,7 @@ static unsigned long get_init_ra_size(un
 static unsigned long get_next_ra_size(struct file_ra_state *ra,
 						unsigned long max)
 {
-	unsigned long cur = ra->readahead_index - ra->ra_index;
+	unsigned long cur = ra->size;
 	unsigned long newsize;
 
 	if (cur < max / 16)
@@ -313,28 +308,21 @@ static unsigned long get_next_ra_size(st
  * The fields in struct file_ra_state represent the most-recently-executed
  * readahead attempt:
  *
- *                    |-------- last readahead window -------->|
- *       |-- application walking here -->|
- * ======#============|==================#=====================|
- *       ^la_index    ^ra_index          ^lookahead_index      ^readahead_index
- *
- * [ra_index, readahead_index) represents the last readahead window.
- *
- * [la_index, lookahead_index] is where the application would be walking(in
- * the common case of cache-cold sequential reads): the last window was
- * established when the application was at la_index, and the next window will
- * be bring in when the application reaches lookahead_index.
+ *                        |<----- async_size ---------|
+ *     |------------------- size -------------------->|
+ *     |==================#===========================|
+ *     ^start             ^page marked with PG_readahead
  *
  * To overlap application thinking time and disk I/O time, we do
  * `readahead pipelining': Do not wait until the application consumed all
  * readahead pages and stalled on the missing page at readahead_index;
- * Instead, submit an asynchronous readahead I/O as early as the application
- * reads on the page at lookahead_index. Normally lookahead_index will be
- * equal to ra_index, for maximum pipelining.
+ * Instead, submit an asynchronous readahead I/O as soon as there are
+ * only async_size pages left in the readahead window. Normally async_size
+ * will be equal to size, for maximum pipelining.
  *
  * In interleaved sequential reads, concurrent streams on the same fd can
  * be invalidating each other's readahead state. So we flag the new readahead
- * page at lookahead_index with PG_readahead, and use it as readahead
+ * page at (start+size-async_size) with PG_readahead, and use it as readahead
  * indicator. The flag won't be set on already cached pages, to avoid the
  * readahead-for-nothing fuss, saving pointless page cache lookups.
  *
@@ -363,24 +351,21 @@ ondemand_readahead(struct address_space 
 		   unsigned long req_size)
 {
 	unsigned long max;	/* max readahead pages */
-	pgoff_t ra_index;	/* readahead index */
-	unsigned long ra_size;	/* readahead size */
-	unsigned long la_size;	/* lookahead size */
 	int sequential;
 
 	max = ra->ra_pages;
 	sequential = (offset - ra->prev_index <= 1UL) || (req_size > max);
 
 	/*
-	 * Lookahead/readahead hit, assume sequential access.
+	 * It's the expected callback offset, assume sequential access.
 	 * Ramp up sizes, and push forward the readahead window.
 	 */
-	if (offset && (offset == ra->lookahead_index ||
-			offset == ra->readahead_index)) {
-		ra_index = ra->readahead_index;
-		ra_size = get_next_ra_size(ra, max);
-		la_size = ra_size;
-		goto fill_ra;
+	if (offset && (offset == (ra->start + ra->size - ra->async_size) ||
+			offset == (ra->start + ra->size))) {
+		ra->start += ra->size;
+		ra->size = get_next_ra_size(ra, max);
+		ra->async_size = ra->size;
+		goto readit;
 	}
 
 	/*
@@ -399,24 +384,21 @@ ondemand_readahead(struct address_space 
 	 * 	- oversize random read
 	 * Start readahead for it.
 	 */
-	ra_index = offset;
-	ra_size = get_init_ra_size(req_size, max);
-	la_size = ra_size > req_size ? ra_size - req_size : ra_size;
+	ra->start = offset;
+	ra->size = get_init_ra_size(req_size, max);
+	ra->async_size = ra->size > req_size ? ra->size - req_size : ra->size;
 
 	/*
-	 * Hit on a lookahead page without valid readahead state.
+	 * Hit on a marked page without valid readahead state.
 	 * E.g. interleaved reads.
 	 * Not knowing its readahead pos/size, bet on the minimal possible one.
 	 */
 	if (hit_readahead_marker) {
-		ra_index++;
-		ra_size = min(4 * ra_size, max);
+		ra->start++;
+		ra->size = get_next_ra_size(ra, max);
 	}
 
-fill_ra:
-	ra_set_index(ra, offset, ra_index);
-	ra_set_size(ra, ra_size, la_size);
-
+readit:
 	return ra_submit(ra, mapping, filp);
 }
 
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
