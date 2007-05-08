From: akpm@linux-foundation.org
Subject: - readahead-state-based-method-routines.patch removed from -mm tree
Date: Tue, 08 May 2007 01:14:05 -0700
Message-ID: <200705080814.l488E5Vn018951@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934614AbXEHIOo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:14:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: state based method - routines
has been removed from the -mm tree.  Its filename was
     readahead-state-based-method-routines.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: state based method - routines
From: Wu Fengguang <wfg@mail.ustc.edu.cn>

Extend struct file_ra_state to support the adaptive read-ahead logic.
Also define some helpers for it.

Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |   57 +++++++++++++---
 mm/readahead.c     |  153 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 198 insertions(+), 12 deletions(-)

diff -puN include/linux/fs.h~readahead-state-based-method-routines include/linux/fs.h
--- a/include/linux/fs.h~readahead-state-based-method-routines
+++ a/include/linux/fs.h
@@ -692,22 +692,59 @@ struct fown_struct {
 
 /*
  * Track a single file's readahead state
+ *
+ * Diagram for the adaptive readahead logic:
+ *
+ *  |--------- old chunk ------->|-------------- new chunk -------------->|
+ *  +----------------------------+----------------------------------------+
+ *  |               #            |                  #                     |
+ *  +----------------------------+----------------------------------------+
+ *                  ^            ^                  ^                     ^
+ *  file_ra_state.la_index    .ra_index   .lookahead_index      .readahead_index
+ *
+ * Common used deduced sizes:
+ *                               |----------- readahead size ------------>|
+ *  +----------------------------+----------------------------------------+
+ *  |               #            |                  #                     |
+ *  +----------------------------+----------------------------------------+
+ *                  |------- invoke interval ------>|-- lookahead size -->|
  */
 struct file_ra_state {
-	unsigned long start;		/* Current window */
-	unsigned long size;
-	unsigned long flags;		/* ra flags RA_FLAG_xxx*/
-	unsigned long cache_hit;	/* cache hit count*/
-	unsigned long prev_index;	/* Cache last read() position */
-	unsigned long ahead_start;	/* Ahead window */
-	unsigned long ahead_size;
-	unsigned long ra_pages;		/* Maximum readahead window */
+	union {
+		struct { /* stock read-ahead */
+			unsigned long start;		/* Current window */
+			unsigned long size;
+			unsigned long ahead_start;	/* Ahead window */
+			unsigned long ahead_size;
+			unsigned long cache_hit;	/* cache hit count */
+		};
+#ifdef CONFIG_ADAPTIVE_READAHEAD
+		struct { /* adaptive read-ahead */
+			pgoff_t la_index;		/* old chunk */
+			pgoff_t ra_index;
+			pgoff_t lookahead_index;	/* new chunk */
+			pgoff_t readahead_index;
+
+			/*
+			 * Snapshot of the (node's) read-ahead aging value
+			 * on time of I/O submission.
+			 */
+			unsigned long age;
+		};
+#endif
+	};
+
+	/* mmap read-around */
 	unsigned long mmap_hit;		/* Cache hit stat for mmap accesses */
 	unsigned long mmap_miss;	/* Cache miss stat for mmap accesses */
 	unsigned int prev_offset;	/* Offset where last read() ended in a page */
+	unsigned long flags;	/* RA_FLAG_xxx | ra_class_old | ra_class_new */
+	unsigned long prev_index;	/* Cache last read() position */
+	unsigned long ra_pages;		/* Maximum readahead window */
 };
-#define RA_FLAG_MISS 0x01	/* a cache miss occured against this file */
-#define RA_FLAG_INCACHE 0x02	/* file is already in cache */
+#define RA_FLAG_MISS	(1UL<<31) /* a cache miss occured against this file */
+#define RA_FLAG_INCACHE	(1UL<<30) /* file is already in cache */
+#define RA_FLAG_MMAP	(1UL<<29) /* mmap page access */
 
 struct file {
 	/*
diff -puN mm/readahead.c~readahead-state-based-method-routines mm/readahead.c
--- a/mm/readahead.c~readahead-state-based-method-routines
+++ a/mm/readahead.c
@@ -780,6 +780,155 @@ out:
 	return nr_pages;
 }
 
+/*
+ * Some helpers for querying/building a read-ahead request.
+ *
+ * Diagram for some variable names used frequently:
+ *
+ *                                   |<------- la_size ------>|
+ *                  +-----------------------------------------+
+ *                  |                #                        |
+ *                  +-----------------------------------------+
+ *      ra_index -->|<---------------- ra_size -------------->|
+ *
+ */
+
+static enum ra_class ra_class_new(struct file_ra_state *ra)
+{
+	return ra->flags & RA_CLASS_MASK;
+}
+
+static inline enum ra_class ra_class_old(struct file_ra_state *ra)
+{
+	return (ra->flags >> RA_CLASS_SHIFT) & RA_CLASS_MASK;
+}
+
+static unsigned long ra_readahead_size(struct file_ra_state *ra)
+{
+	return ra->readahead_index - ra->ra_index;
+}
+
+static unsigned long ra_lookahead_size(struct file_ra_state *ra)
+{
+	return ra->readahead_index - ra->lookahead_index;
+}
+
+static unsigned long ra_invoke_interval(struct file_ra_state *ra)
+{
+	return ra->lookahead_index - ra->la_index;
+}
+
+/*
+ * Check if @index falls in the @ra request.
+ */
+static int ra_has_index(struct file_ra_state *ra, pgoff_t index)
+{
+	return (index >= ra->la_index &&
+		index <  ra->readahead_index);
+}
+
+/*
+ * Which method is issuing this read-ahead?
+ */
+static void ra_set_class(struct file_ra_state *ra, enum ra_class ra_class)
+{
+	unsigned long flags_mask;
+	unsigned long flags;
+	unsigned long old_ra_class;
+
+	flags_mask = ~(RA_CLASS_MASK | (RA_CLASS_MASK << RA_CLASS_SHIFT));
+	flags = ra->flags & flags_mask;
+
+	old_ra_class = ra_class_new(ra) << RA_CLASS_SHIFT;
+
+	ra->flags = flags | old_ra_class | ra_class;
+}
+
+/*
+ * Where is the old read-ahead and look-ahead?
+ */
+static void ra_set_index(struct file_ra_state *ra,
+					pgoff_t la_index, pgoff_t ra_index)
+{
+	ra->la_index = la_index;
+	ra->ra_index = ra_index;
+}
+
+/*
+ * Where is the new read-ahead and look-ahead?
+ */
+static void ra_set_size(struct file_ra_state *ra,
+				unsigned long ra_size, unsigned long la_size)
+{
+	ra->readahead_index = ra->ra_index + ra_size;
+	ra->lookahead_index = ra->readahead_index - la_size;
+}
+
+/*
+ * Submit IO for the read-ahead request in file_ra_state.
+ */
+static unsigned long ra_submit(struct file_ra_state *ra,
+			       struct address_space *mapping, struct file *filp)
+{
+	unsigned long ra_size;
+	unsigned long la_size;
+	pgoff_t eof;
+	int actual;
+
+	eof = /* it's a past-the-end index! */
+		DIV_ROUND_UP(i_size_read(mapping->host), PAGE_CACHE_SIZE);
+
+	if (unlikely(ra->ra_index >= eof))
+		return 0;
+
+	/*
+	 * Snap to EOF, if the request
+	 * 	- crossed the EOF boundary;
+	 * 	- is close to EOF(explained below).
+	 *
+	 * Imagine a file sized 18 pages, and we dicided to read-ahead the
+	 * first 16 pages. It is highly possible that in the near future we
+	 * will have to do another read-ahead for the remaining 2 pages,
+	 * which is an unfavorable small I/O.
+	 *
+	 * So we prefer to take a bit risk to enlarge the current read-ahead,
+	 * to eliminate possible future small I/O.
+	 */
+	if (ra->readahead_index + MIN_RA_PAGES
+				+ ra_readahead_size(ra) / 4 > eof) {
+		ra->readahead_index = eof;
+		if (ra->lookahead_index > eof)
+		    ra->lookahead_index = eof;
+	}
+
+	/* Take down the current read-ahead aging value. */
+	ra->age = nr_scanned_pages_node(numa_node_id());
+
+	ra_size = ra_readahead_size(ra);
+	la_size = ra_lookahead_size(ra);
+	actual = __do_page_cache_readahead(mapping, filp,
+					ra->ra_index, ra_size, la_size);
+
+#ifdef CONFIG_DEBUG_READAHEAD
+	if (ra->flags & RA_FLAG_MMAP)
+		ra_account(ra, RA_EVENT_READAHEAD_MMAP, actual);
+	if (ra->readahead_index == eof)
+		ra_account(ra, RA_EVENT_READAHEAD_EOF, actual);
+	if (la_size)
+		ra_account(ra, RA_EVENT_LOOKAHEAD, la_size);
+	if (ra_size > actual)
+		ra_account(ra, RA_EVENT_IO_CACHE_HIT, ra_size - actual);
+	ra_account(ra, RA_EVENT_READAHEAD, actual);
+
+	dprintk("readahead-%s(ino=%lu, index=%lu:%lu, size=%lu-%lu) = %d\n",
+			ra_class_name[ra_class_new(ra)],
+			mapping->host->i_ino, ra->la_index,
+			ra->ra_index, ra_size, la_size, actual);
+#endif /* CONFIG_DEBUG_READAHEAD */
+
+	return actual;
+}
+
 #endif /* CONFIG_ADAPTIVE_READAHEAD */
 
 /*
@@ -832,10 +981,10 @@ static void ra_account(struct file_ra_st
 		return;
 
 	if (e == RA_EVENT_READAHEAD_HIT && pages < 0) {
-		c = (ra->flags >> RA_CLASS_SHIFT) & RA_CLASS_MASK;
+		c = ra_class_old(ra);
 		pages = -pages;
 	} else if (ra)
-		c = ra->flags & RA_CLASS_MASK;
+		c = ra_class_new(ra);
 	else
 		c = RA_CLASS_NONE;
 
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
readahead-state-based-method-routines.patch
readahead-state-based-method.patch
readahead-state-based-method-check-node-id.patch
readahead-state-based-method-decouple-readahead_ratio-from-growth_limit.patch
readahead-state-based-method-cancel-lookahead-gracefully.patch
readahead-context-based-method.patch
readahead-initial-method-guiding-sizes.patch
readahead-initial-method-thrashing-guard-size.patch
readahead-initial-method-user-recommended-size.patch
readahead-initial-method.patch
readahead-backward-prefetching-method.patch
readahead-thrashing-recovery-method.patch
readahead-thrashing-recovery-method-check-unbalanced-aging.patch
readahead-thrashing-recovery-method-refill-holes.patch
readahead-call-scheme.patch
readahead-call-scheme-cleanup.patch
readahead-call-scheme-catch-thrashing-on-lookahead-time.patch
readahead-call-scheme-doc-fixes-for-readahead.patch
readahead-laptop-mode.patch
readahead-loop-case.patch
readahead-nfsd-case.patch
readahead-remove-parameter-ra_max-from-thrashing_recovery_readahead.patch
readahead-remove-parameter-ra_max-from-adjust_rala.patch
readahead-state-based-method-protect-against-tiny-size.patch
readahead-rename-state_based_readahead-to-clock_based_readahead.patch
readahead-account-i-o-block-times-for-stock-readahead.patch
readahead-rescue_pages-updates.patch
readahead-remove-noaction-shrink-events.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
readahead-partial-sendfile-fix.patch
readahead-turn-on-by-default.patch
