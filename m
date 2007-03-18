From: akpm@linux-foundation.org
Subject: + readahead-state-based-method-check-node-id.patch added to -mm tree
Date: Sat, 17 Mar 2007 23:49:34 -0800
Message-ID: <200703180749.l2I7nYRY018328@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58672 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137AbXCRHt5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 03:49:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn


The patch titled
     readahead: state based method: check node id
has been added to the -mm tree.  Its filename is
     readahead-state-based-method-check-node-id.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: readahead: state based method: check node id
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

The file_ra_state.age is node specific, comparing ages between two nodes is a
bug.

So add code to
- take down the node id in file_ra_state.flags;
- ensure that we are comparing the ages from the same node.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    2 +-
 mm/readahead.c     |   30 +++++++++++++++++++++++++-----
 2 files changed, 26 insertions(+), 6 deletions(-)

diff -puN include/linux/fs.h~readahead-state-based-method-check-node-id include/linux/fs.h
--- a/include/linux/fs.h~readahead-state-based-method-check-node-id
+++ a/include/linux/fs.h
@@ -738,7 +738,7 @@ struct file_ra_state {
 	unsigned long mmap_hit;		/* Cache hit stat for mmap accesses */
 	unsigned long mmap_miss;	/* Cache miss stat for mmap accesses */
 
-	unsigned long flags;	/* RA_FLAG_xxx | ra_class_old | ra_class_new */
+	unsigned long flags;	/* RA_FLAG_xxx | node_id | class_old | class_new */
 	unsigned long prev_page;	/* Cache last read() position */
 	unsigned long ra_pages;		/* Maximum readahead window */
 };
diff -puN mm/readahead.c~readahead-state-based-method-check-node-id mm/readahead.c
--- a/mm/readahead.c~readahead-state-based-method-check-node-id
+++ a/mm/readahead.c
@@ -52,11 +52,13 @@ EXPORT_SYMBOL_GPL(readahead_ratio);
 int readahead_hit_rate = 1;
 #endif /* CONFIG_ADAPTIVE_READAHEAD */
 
+#define RA_CLASS_SHIFT 4
+#define RA_CLASS_MASK  ((1 << RA_CLASS_SHIFT) - 1)
+#define RA_NODE_SHIFT  (2 * RA_CLASS_SHIFT)
+#define RA_NODE_MASK   ((MAX_NUMNODES-1) << RA_NODE_SHIFT)
 /*
  * Detailed classification of read-ahead behaviors.
  */
-#define RA_CLASS_SHIFT 4
-#define RA_CLASS_MASK  ((1 << RA_CLASS_SHIFT) - 1)
 enum ra_class {
 	RA_CLASS_ALL,
 	RA_CLASS_INITIAL,
@@ -802,6 +804,11 @@ static inline enum ra_class ra_class_old
 	return (ra->flags >> RA_CLASS_SHIFT) & RA_CLASS_MASK;
 }
 
+static inline int ra_node_id(struct file_ra_state *ra)
+{
+	return (ra->flags >> RA_NODE_SHIFT) & RA_NODE_MASK;
+}
+
 static unsigned long ra_readahead_size(struct file_ra_state *ra)
 {
 	return ra->readahead_index - ra->ra_index;
@@ -864,6 +871,18 @@ static void ra_set_size(struct file_ra_s
 }
 
 /*
+ * Save the current node id and age.
+ */
+static void ra_save_node_age(struct file_ra_state *ra)
+{
+	int nid = numa_node_id();
+
+	ra->flags &= ~RA_NODE_MASK;
+	ra->flags |= nid << RA_NODE_SHIFT;
+	ra->age = nr_scanned_pages_node(nid);
+}
+
+/*
  * Submit IO for the read-ahead request in file_ra_state.
  */
 static unsigned long ra_submit(struct file_ra_state *ra,
@@ -901,7 +920,7 @@ static unsigned long ra_submit(struct fi
 	}
 
 	/* Take down the current read-ahead aging value. */
-	ra->age = nr_scanned_pages_node(numa_node_id());
+	ra_save_node_age(ra);
 
 	ra_size = ra_readahead_size(ra);
 	la_size = ra_lookahead_size(ra);
@@ -1025,9 +1044,10 @@ static unsigned long compute_thrashing_t
 	unsigned long stream_shift;
 	unsigned long ra_size;
 	uint64_t ll;
+	int nid = ra_node_id(ra);
 
-	global_size = nr_free_inactive_pages_node(numa_node_id());
-	global_shift = nr_scanned_pages_node(numa_node_id()) - ra->age;
+	global_size = nr_free_inactive_pages_node(nid);
+	global_shift = nr_scanned_pages_node(nid) - ra->age;
 	global_shift |= 1UL;
 	stream_shift = ra_invoke_interval(ra);
 
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

readahead-kconfig-options.patch
radixtree-introduce-scan-hole-data-functions.patch
mm-introduce-probe_page.patch
mm-introduce-pg_readahead.patch
readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
readahead-insert-cond_resched-calls.patch
readahead-minmax_ra_pages.patch
readahead-events-accounting.patch
readahead-rescue_pages.patch
readahead-sysctl-parameters.patch
readahead-min-max-sizes.patch
readahead-state-based-method-aging-accounting.patch
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
