From: akpm@linux-foundation.org
Subject: - readahead-data-structure-and-routines.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:01:08 -0700
Message-ID: <200707192001.l6JK18bQ019513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38719 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932151AbXGSU2o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:28:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, linuxram@us.ibm.com, rusty@rustcorp.com.au, slpratt@austin.ibm.com, mm-commits@vger.kernel.org


The patch titled
     readahead: data structure and routines
has been removed from the -mm tree.  Its filename was
     readahead-data-structure-and-routines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: readahead: data structure and routines
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Extend struct file_ra_state to support the on-demand readahead logic.  Also
define some helpers for it.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Steven Pratt <slpratt@austin.ibm.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |   64 +++++++++++++++++++++++++++++++++++++++++++
 mm/readahead.c     |   19 ++++++++++++
 2 files changed, 83 insertions(+)

diff -puN include/linux/fs.h~readahead-data-structure-and-routines include/linux/fs.h
--- a/include/linux/fs.h~readahead-data-structure-and-routines
+++ a/include/linux/fs.h
@@ -695,6 +695,10 @@ struct fown_struct {
 
 /*
  * Track a single file's readahead state
+ *
+ *  ================#============|==================#==================|
+ *                  ^            ^                  ^                  ^
+ *  file_ra_state.la_index    .ra_index   .lookahead_index   .readahead_index
  */
 struct file_ra_state {
 	unsigned long start;		/* Current window */
@@ -704,6 +708,12 @@ struct file_ra_state {
 	unsigned long prev_index;	/* Cache last read() position */
 	unsigned long ahead_start;	/* Ahead window */
 	unsigned long ahead_size;
+
+	pgoff_t la_index;               /* enqueue time */
+	pgoff_t ra_index;               /* begin offset */
+	pgoff_t lookahead_index;        /* time to do next readahead */
+	pgoff_t readahead_index;        /* end offset */
+
 	unsigned long ra_pages;		/* Maximum readahead window */
 	unsigned long mmap_hit;		/* Cache hit stat for mmap accesses */
 	unsigned long mmap_miss;	/* Cache miss stat for mmap accesses */
@@ -712,6 +722,60 @@ struct file_ra_state {
 #define RA_FLAG_MISS 0x01	/* a cache miss occured against this file */
 #define RA_FLAG_INCACHE 0x02	/* file is already in cache */
 
+/*
+ * Measuring read-ahead sizes.
+ *
+ *                  |----------- readahead size ------------>|
+ *  ===#============|==================#=====================|
+ *     |------- invoke interval ------>|-- lookahead size -->|
+ */
+static inline unsigned long ra_readahead_size(struct file_ra_state *ra)
+{
+	return ra->readahead_index - ra->ra_index;
+}
+
+static inline unsigned long ra_lookahead_size(struct file_ra_state *ra)
+{
+	return ra->readahead_index - ra->lookahead_index;
+}
+
+static inline unsigned long ra_invoke_interval(struct file_ra_state *ra)
+{
+	return ra->lookahead_index - ra->la_index;
+}
+
+/*
+ * Check if @index falls in the readahead windows.
+ */
+static inline int ra_has_index(struct file_ra_state *ra, pgoff_t index)
+{
+	return (index >= ra->la_index &&
+		index <  ra->readahead_index);
+}
+
+/*
+ * Where is the old read-ahead and look-ahead?
+ */
+static inline void ra_set_index(struct file_ra_state *ra,
+				pgoff_t la_index, pgoff_t ra_index)
+{
+	ra->la_index = la_index;
+	ra->ra_index = ra_index;
+}
+
+/*
+ * Where is the new read-ahead and look-ahead?
+ */
+static inline void ra_set_size(struct file_ra_state *ra,
+				unsigned long ra_size, unsigned long la_size)
+{
+	ra->readahead_index = ra->ra_index + ra_size;
+	ra->lookahead_index = ra->ra_index + ra_size - la_size;
+}
+
+unsigned long ra_submit(struct file_ra_state *ra,
+		       struct address_space *mapping, struct file *filp);
+
 struct file {
 	/*
 	 * fu_list becomes invalid after file_free is called and queued via
diff -puN mm/readahead.c~readahead-data-structure-and-routines mm/readahead.c
--- a/mm/readahead.c~readahead-data-structure-and-routines
+++ a/mm/readahead.c
@@ -592,3 +592,22 @@ unsigned long max_sane_readahead(unsigne
 	return min(nr, (node_page_state(numa_node_id(), NR_INACTIVE)
 		+ node_page_state(numa_node_id(), NR_FREE_PAGES)) / 2);
 }
+
+/*
+ * Submit IO for the read-ahead request in file_ra_state.
+ */
+unsigned long ra_submit(struct file_ra_state *ra,
+		       struct address_space *mapping, struct file *filp)
+{
+	unsigned long ra_size;
+	unsigned long la_size;
+	int actual;
+
+	ra_size = ra_readahead_size(ra);
+	la_size = ra_lookahead_size(ra);
+	actual = __do_page_cache_readahead(mapping, filp,
+					ra->ra_index, ra_size, la_size);
+
+	return actual;
+}
+EXPORT_SYMBOL_GPL(ra_submit);
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
