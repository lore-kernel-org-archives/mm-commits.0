From: akpm@linux-foundation.org
Subject: [withdrawn] radix-tree-gang-set-if-tagged-operation.patch removed from -mm tree
Date: Thu, 02 Apr 2009 19:28:47 -0700
Message-ID: <200904030228.n332SlPn000786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752383AbZDCCaE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2009 22:30:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     radix-tree: gang set if tagged operation
has been removed from the -mm tree.  Its filename was
     radix-tree-gang-set-if-tagged-operation.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radix-tree: gang set if tagged operation
From: Nick Piggin <npiggin@suse.de>

Add a "radix_tree_gang_set_if_tagged" operation, which takes a range of
indexes, and sets a given tag, if any of the specified tags were found to
be set.  Used by the next patch to set an "fsync" bit on any dirty and
writeback pages.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    1 
 lib/radix-tree.c           |  107 +++++++++++++++++++++++++++++++++++
 2 files changed, 108 insertions(+)

diff -puN include/linux/radix-tree.h~radix-tree-gang-set-if-tagged-operation include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-gang-set-if-tagged-operation
+++ a/include/linux/radix-tree.h
@@ -183,6 +183,7 @@ unsigned int
 radix_tree_gang_lookup_tag_slot(struct radix_tree_root *root, void ***results,
 		unsigned long first_index, unsigned int max_items,
 		unsigned int tag);
+int radix_tree_gang_tag_set_if_tagged(struct radix_tree_root *root, unsigned long first_index, unsigned long last_index, unsigned long ifset, unsigned long thentag);
 int radix_tree_tagged(struct radix_tree_root *root, unsigned int tag);
 
 static inline void radix_tree_preload_end(void)
diff -puN lib/radix-tree.c~radix-tree-gang-set-if-tagged-operation lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-gang-set-if-tagged-operation
+++ a/lib/radix-tree.c
@@ -629,6 +629,113 @@ int radix_tree_tag_get(struct radix_tree
 EXPORT_SYMBOL(radix_tree_tag_get);
 #endif
 
+int node_tag_set_if_tagged(struct radix_tree_node *node, unsigned int height, unsigned long first_index, unsigned long last_index, unsigned long ifset, unsigned long thentag)
+{
+	unsigned long first, last;
+	int offset_start, offset_end, i;
+	int ret = 0;
+	unsigned int shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
+	unsigned int size = RADIX_TREE_MAP_SIZE << shift;
+
+	first = first_index;
+	last = min(last_index, ((first + size) & ~(size-1)) - 1);
+
+	offset_start = (first_index >> shift) & RADIX_TREE_MAP_MASK;
+	offset_end = (last_index >> shift) & RADIX_TREE_MAP_MASK;
+	for (i = offset_start; i <= offset_end; i++) {
+
+		if (height > 1) {
+			struct radix_tree_node *slot;
+
+			slot = node->slots[i];
+			if (!slot)
+				goto notset;
+
+			if (node_tag_set_if_tagged(slot, height - 1,
+						first, last,
+						ifset, thentag)) {
+				if (ifset == 0x1)
+					BUG_ON(!tag_get(node, 0, i));
+				if (ifset == 0x2)
+					BUG_ON(!tag_get(node, 1, i));
+				if (ifset == 0x2)
+					BUG_ON(!tag_get(node, 0, i) &&
+						!tag_get(node, 1, i));
+				if (thentag & 0x4) {
+					if (!tag_get(node, 2, i))
+						tag_set(node, 2, i);
+				}
+				ret = 1;
+			}
+notset:
+			first = last+1;
+			last = min(last_index, first + size - 1);
+
+		} else {
+			if (ifset & 0x1) {
+				if (tag_get(node, 0, i))
+					goto isset;
+			}
+			if (ifset & 0x2) {
+				if (tag_get(node, 1, i))
+					goto isset;
+			}
+			continue;
+isset:
+			if (thentag & 0x4) {
+				if (!tag_get(node, 2, i))
+					tag_set(node, 2, i);
+			}
+			ret = 1;
+		}
+	}
+
+	return ret;
+}
+
+int radix_tree_gang_tag_set_if_tagged(struct radix_tree_root *root, unsigned long first_index, unsigned long last_index, unsigned long ifset, unsigned long thentag)
+{
+	unsigned int height;
+	struct radix_tree_node *slot;
+
+	BUG_ON(ifset & ~0x3);
+	BUG_ON(thentag & ~0x4);
+
+	height = root->height;
+	if (height == 0) {
+		/* set the root's tag bit */
+		if (first_index != 0)
+			return 0;
+
+		if (ifset & 0x1)
+			if (root_tag_get(root, 0))
+				goto isset;
+		if (ifset & 0x2)
+			if (root_tag_get(root, 1))
+				goto isset;
+		return 0;
+isset:
+		if (thentag & 0x4) {
+			if (!root_tag_get(root, 2))
+				root_tag_set(root, 2);
+		}
+		return 1;
+	}
+
+	slot = radix_tree_indirect_to_ptr(root->rnode);
+	if (node_tag_set_if_tagged(slot, height, first_index, last_index, ifset, thentag)) {
+		/* set the root's tag bit */
+		if (thentag & 0x4) {
+			if (!root_tag_get(root, 2))
+				root_tag_set(root, 2);
+		}
+
+		return 1;
+	}
+
+	return 0;
+}
+
 /**
  *	radix_tree_next_hole    -    find the next hole (not-present entry)
  *	@root:		tree root
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-do_xip_mapping_read-fix-length-calculation.patch
linux-next.patch
radix-tree-gang-set-if-tagged-operation.patch
mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch
nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite-follow-page_mkwrite-prototype-change-for-matching-fault.patch
nilfs2-segment-constructor-insert-checks-and-hole-block-allocation-in-page_mkwrite-follow-page_mkwrite-prototype-change-for-matching-fault-fix-page_mkwrite-error-cases.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

