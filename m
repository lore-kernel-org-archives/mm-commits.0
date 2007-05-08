From: akpm@linux-foundation.org
Subject: - radixtree-introduce-scan-hole-data-functions.patch removed from -mm tree
Date: Tue, 08 May 2007 01:13:21 -0700
Message-ID: <200705080813.l488DLV6018908@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934565AbXEHIOO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:14:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     radixtree: introduce scan hole/data functions
has been removed from the -mm tree.  Its filename was
     radixtree-introduce-scan-hole-data-functions.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: radixtree: introduce scan hole/data functions
From: Wu Fengguang <wfg@mail.ustc.edu.cn>

Introduce a set of functions to scan radix tree for hole/data item.
	- radix_tree_scan_hole(root, index, max_scan)
	- radix_tree_scan_hole_backward(root, index, max_scan)
	- radix_tree_scan_data_backward(root, index, max_scan)

The implementation is dumb and obviously correct.
It will help to debug the smart ones to be introduced in future.

Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    6 ++
 lib/radix-tree.c           |   93 +++++++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+)

diff -puN include/linux/radix-tree.h~radixtree-introduce-scan-hole-data-functions include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radixtree-introduce-scan-hole-data-functions
+++ a/include/linux/radix-tree.h
@@ -155,6 +155,12 @@ void *radix_tree_delete(struct radix_tre
 unsigned int
 radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
 			unsigned long first_index, unsigned int max_items);
+unsigned long radix_tree_scan_hole(struct radix_tree_root *root,
+				unsigned long index, unsigned long max_scan);
+unsigned long radix_tree_scan_hole_backward(struct radix_tree_root *root,
+				unsigned long index, unsigned long max_scan);
+unsigned long radix_tree_scan_data_backward(struct radix_tree_root *root,
+				unsigned long index, unsigned long max_scan);
 int radix_tree_preload(gfp_t gfp_mask);
 void radix_tree_init(void);
 void *radix_tree_tag_set(struct radix_tree_root *root,
diff -puN lib/radix-tree.c~radixtree-introduce-scan-hole-data-functions lib/radix-tree.c
--- a/lib/radix-tree.c~radixtree-introduce-scan-hole-data-functions
+++ a/lib/radix-tree.c
@@ -600,6 +600,99 @@ int radix_tree_tag_get(struct radix_tree
 EXPORT_SYMBOL(radix_tree_tag_get);
 #endif
 
+static unsigned long
+radix_tree_scan_hole_dumb(struct radix_tree_root *root,
+				unsigned long index, unsigned long max_scan)
+{
+	unsigned long i;
+
+	for (i = 0; i < max_scan; i++)
+		if (!radix_tree_lookup(root, index) || ++index == 0)
+			break;
+
+	return index;
+}
+
+static unsigned long
+radix_tree_scan_hole_backward_dumb(struct radix_tree_root *root,
+				unsigned long index, unsigned long max_scan)
+{
+	unsigned long i;
+
+	for (i = 0; i < max_scan; i++)
+		if (!radix_tree_lookup(root, index) || --index == ULONG_MAX)
+			break;
+
+	return index;
+}
+
+static unsigned long
+radix_tree_scan_data_backward_dumb(struct radix_tree_root *root,
+				unsigned long index, unsigned long max_scan)
+{
+	unsigned long i;
+
+	for (i = 0; i < max_scan; i++)
+		if (radix_tree_lookup(root, index) || --index == ULONG_MAX)
+			break;
+
+	return index;
+}
+
+/**
+ *	radix_tree_scan_hole    -    scan for hole
+ *	@root:		radix tree root
+ *	@index:		index key
+ *	@max_scan:      advice on max items to scan (it may scan a little more)
+ *
+ *      Scan forward from @index for a hole/empty item, stop when
+ *      - hit hole
+ *      - wrap-around to index 0
+ *      - @max_scan or more items scanned
+ */
+unsigned long radix_tree_scan_hole(struct radix_tree_root *root,
+				unsigned long index, unsigned long max_scan)
+{
+	return radix_tree_scan_hole_dumb(root, index, max_scan);
+}
+EXPORT_SYMBOL(radix_tree_scan_hole);
+
+/**
+ *	radix_tree_scan_hole_backward    -    scan backward for hole
+ *	@root:		radix tree root
+ *	@index:		index key
+ *	@max_scan:      advice on max items to scan (it may scan a little more)
+ *
+ *      Scan backward from @index for a hole/empty item, stop when
+ *      - hit hole
+ *      - wrap-around to index ULONG_MAX
+ *      - @max_scan or more items scanned
+ */
+unsigned long radix_tree_scan_hole_backward(struct radix_tree_root *root,
+				unsigned long index, unsigned long max_scan)
+{
+	return radix_tree_scan_hole_backward_dumb(root, index, max_scan);
+}
+EXPORT_SYMBOL(radix_tree_scan_hole_backward);
+
+/**
+ *	radix_tree_scan_data_backward    -    scan backward for data
+ *	@root:		radix tree root
+ *	@index:		index key
+ *	@max_scan:      advice on max items to scan (it may scan a little more)
+ *
+ *      Scan backward from @index for a data item, stop when
+ *      - hit data
+ *      - wrap-around to index ULONG_MAX
+ *      - @max_scan or more items scanned
+ */
+unsigned long radix_tree_scan_data_backward(struct radix_tree_root *root,
+				unsigned long index, unsigned long max_scan)
+{
+	return radix_tree_scan_data_backward_dumb(root, index, max_scan);
+}
+EXPORT_SYMBOL(radix_tree_scan_data_backward);
+
 static unsigned int
 __lookup(struct radix_tree_node *slot, void **results, unsigned long index,
 	unsigned int max_items, unsigned long *next_index)
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
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
