From: akpm@linux-foundation.org
Subject: [merged] radix-tree-add-radix_tree_prev_hole.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:32:56 -0700
Message-ID: <200906171832.n5HIWuSE031463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758959AbZFQSds (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:33:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, jens.axboe@oracle.com, jmoyer@redhat.com, nickpiggin@yahoo.com.au, vst@vlnb.net, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     radix-tree: add radix_tree_prev_hole()
has been removed from the -mm tree.  Its filename was
     radix-tree-add-radix_tree_prev_hole.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radix-tree: add radix_tree_prev_hole()
From: Wu Fengguang <fengguang.wu@intel.com>

The counterpart of radix_tree_next_hole(). To be used by context readahead.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    2 +
 lib/radix-tree.c           |   37 +++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff -puN include/linux/radix-tree.h~radix-tree-add-radix_tree_prev_hole include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-add-radix_tree_prev_hole
+++ a/include/linux/radix-tree.h
@@ -167,6 +167,8 @@ radix_tree_gang_lookup_slot(struct radix
 			unsigned long first_index, unsigned int max_items);
 unsigned long radix_tree_next_hole(struct radix_tree_root *root,
 				unsigned long index, unsigned long max_scan);
+unsigned long radix_tree_prev_hole(struct radix_tree_root *root,
+				unsigned long index, unsigned long max_scan);
 int radix_tree_preload(gfp_t gfp_mask);
 void radix_tree_init(void);
 void *radix_tree_tag_set(struct radix_tree_root *root,
diff -puN lib/radix-tree.c~radix-tree-add-radix_tree_prev_hole lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-add-radix_tree_prev_hole
+++ a/lib/radix-tree.c
@@ -666,6 +666,43 @@ unsigned long radix_tree_next_hole(struc
 }
 EXPORT_SYMBOL(radix_tree_next_hole);
 
+/**
+ *	radix_tree_prev_hole    -    find the prev hole (not-present entry)
+ *	@root:		tree root
+ *	@index:		index key
+ *	@max_scan:	maximum range to search
+ *
+ *	Search backwards in the range [max(index-max_scan+1, 0), index]
+ *	for the first hole.
+ *
+ *	Returns: the index of the hole if found, otherwise returns an index
+ *	outside of the set specified (in which case 'index - return >= max_scan'
+ *	will be true). In rare cases of wrap-around, LONG_MAX will be returned.
+ *
+ *	radix_tree_next_hole may be called under rcu_read_lock. However, like
+ *	radix_tree_gang_lookup, this will not atomically search a snapshot of
+ *	the tree at a single point in time. For example, if a hole is created
+ *	at index 10, then subsequently a hole is created at index 5,
+ *	radix_tree_prev_hole covering both indexes may return 5 if called under
+ *	rcu_read_lock.
+ */
+unsigned long radix_tree_prev_hole(struct radix_tree_root *root,
+				   unsigned long index, unsigned long max_scan)
+{
+	unsigned long i;
+
+	for (i = 0; i < max_scan; i++) {
+		if (!radix_tree_lookup(root, index))
+			break;
+		index--;
+		if (index == LONG_MAX)
+			break;
+	}
+
+	return index;
+}
+EXPORT_SYMBOL(radix_tree_prev_hole);
+
 static unsigned int
 __lookup(struct radix_tree_node *slot, void ***results, unsigned long index,
 	unsigned int max_items, unsigned long *next_index)
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch

