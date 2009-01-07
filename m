From: akpm@linux-foundation.org
Subject: - mm-change-dirty-limit-type-specifiers-to-unsigned-long.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:12:27 -0800
Message-ID: <200901072212.n07MCRl5012627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755878AbZAGWMi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:12:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, cl@linux-foundation.org, david@fromorbit.com, peterz@infradead.org, righi.andrea@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: change dirty limit type specifiers to unsigned long
has been removed from the -mm tree.  Its filename was
     mm-change-dirty-limit-type-specifiers-to-unsigned-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: change dirty limit type specifiers to unsigned long
From: David Rientjes <rientjes@google.com>

The background dirty and dirty limits are better defined with type
specifiers of unsigned long since negative writeback thresholds are not
possible.

These values, as returned by get_dirty_limits(), are normally compared
with ZVC values to determine whether writeback shall commence or be
throttled.  Such page counts cannot be negative, so declaring the page
limits as signed is unnecessary.

Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Andrea Righi <righi.andrea@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    4 ++--
 mm/backing-dev.c          |    6 +++---
 mm/page-writeback.c       |   22 +++++++++++-----------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff -puN include/linux/writeback.h~mm-change-dirty-limit-type-specifiers-to-unsigned-long include/linux/writeback.h
--- a/include/linux/writeback.h~mm-change-dirty-limit-type-specifiers-to-unsigned-long
+++ a/include/linux/writeback.h
@@ -125,8 +125,8 @@ struct file;
 int dirty_writeback_centisecs_handler(struct ctl_table *, int, struct file *,
 				      void __user *, size_t *, loff_t *);
 
-void get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
-		 struct backing_dev_info *bdi);
+void get_dirty_limits(unsigned long *pbackground, unsigned long *pdirty,
+		      unsigned long *pbdi_dirty, struct backing_dev_info *bdi);
 
 void page_writeback_init(void);
 void balance_dirty_pages_ratelimited_nr(struct address_space *mapping,
diff -puN mm/backing-dev.c~mm-change-dirty-limit-type-specifiers-to-unsigned-long mm/backing-dev.c
--- a/mm/backing-dev.c~mm-change-dirty-limit-type-specifiers-to-unsigned-long
+++ a/mm/backing-dev.c
@@ -24,9 +24,9 @@ static void bdi_debug_init(void)
 static int bdi_debug_stats_show(struct seq_file *m, void *v)
 {
 	struct backing_dev_info *bdi = m->private;
-	long background_thresh;
-	long dirty_thresh;
-	long bdi_thresh;
+	unsigned long background_thresh;
+	unsigned long dirty_thresh;
+	unsigned long bdi_thresh;
 
 	get_dirty_limits(&background_thresh, &dirty_thresh, &bdi_thresh, bdi);
 
diff -puN mm/page-writeback.c~mm-change-dirty-limit-type-specifiers-to-unsigned-long mm/page-writeback.c
--- a/mm/page-writeback.c~mm-change-dirty-limit-type-specifiers-to-unsigned-long
+++ a/mm/page-writeback.c
@@ -362,13 +362,13 @@ unsigned long determine_dirtyable_memory
 }
 
 void
-get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
-		 struct backing_dev_info *bdi)
+get_dirty_limits(unsigned long *pbackground, unsigned long *pdirty,
+		 unsigned long *pbdi_dirty, struct backing_dev_info *bdi)
 {
 	int background_ratio;		/* Percentages */
 	int dirty_ratio;
-	long background;
-	long dirty;
+	unsigned long background;
+	unsigned long dirty;
 	unsigned long available_memory = determine_dirtyable_memory();
 	struct task_struct *tsk;
 
@@ -423,9 +423,9 @@ static void balance_dirty_pages(struct a
 {
 	long nr_reclaimable, bdi_nr_reclaimable;
 	long nr_writeback, bdi_nr_writeback;
-	long background_thresh;
-	long dirty_thresh;
-	long bdi_thresh;
+	unsigned long background_thresh;
+	unsigned long dirty_thresh;
+	unsigned long bdi_thresh;
 	unsigned long pages_written = 0;
 	unsigned long write_chunk = sync_writeback_pages();
 
@@ -580,8 +580,8 @@ EXPORT_SYMBOL(balance_dirty_pages_rateli
 
 void throttle_vm_writeout(gfp_t gfp_mask)
 {
-	long background_thresh;
-	long dirty_thresh;
+	unsigned long background_thresh;
+	unsigned long dirty_thresh;
 
         for ( ; ; ) {
 		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
@@ -624,8 +624,8 @@ static void background_writeout(unsigned
 	};
 
 	for ( ; ; ) {
-		long background_thresh;
-		long dirty_thresh;
+		unsigned long background_thresh;
+		unsigned long dirty_thresh;
 
 		get_dirty_limits(&background_thresh, &dirty_thresh, NULL, NULL);
 		if (global_page_state(NR_FILE_DIRTY) +
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim.patch
memory-cgroup-hierarchy-feature-selector-v4.patch
memory-cgroup-hierarchy-feature-selector-v4-fix.patch

