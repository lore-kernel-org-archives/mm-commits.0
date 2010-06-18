From: akpm@linux-foundation.org
Subject: + radix-tree-implement-function-radix_tree_range_tag_if_tagged.patch added to -mm tree
Date: Fri, 18 Jun 2010 15:21:43 -0700
Message-ID: <201006182221.o5IMLhLD026594@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753972Ab0FRWW1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 18:22:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, axboe@kernel.dk, chris.mason@oracle.com, david@fromorbit.com, nickpiggin@yahoo.com.au, tytso@mit.edu


The patch titled
     radix-tree: implement function radix_tree_range_tag_if_tagged
has been added to the -mm tree.  Its filename is
     radix-tree-implement-function-radix_tree_range_tag_if_tagged.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radix-tree: implement function radix_tree_range_tag_if_tagged
From: Jan Kara <jack@suse.cz>

Implement a function for setting one tag if another tag is set for each
item within a given range.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |    4 +
 lib/radix-tree.c           |   92 +++++++++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+)

diff -puN include/linux/radix-tree.h~radix-tree-implement-function-radix_tree_range_tag_if_tagged include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-implement-function-radix_tree_range_tag_if_tagged
+++ a/include/linux/radix-tree.h
@@ -192,6 +192,10 @@ unsigned int
 radix_tree_gang_lookup_tag_slot(struct radix_tree_root *root, void ***results,
 		unsigned long first_index, unsigned int max_items,
 		unsigned int tag);
+unsigned long radix_tree_range_tag_if_tagged(struct radix_tree_root *root,
+		unsigned long *first_indexp, unsigned long last_index,
+		unsigned long nr_to_tag,
+		unsigned int fromtag, unsigned int totag);
 int radix_tree_tagged(struct radix_tree_root *root, unsigned int tag);
 
 static inline void radix_tree_preload_end(void)
diff -puN lib/radix-tree.c~radix-tree-implement-function-radix_tree_range_tag_if_tagged lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-implement-function-radix_tree_range_tag_if_tagged
+++ a/lib/radix-tree.c
@@ -609,6 +609,98 @@ int radix_tree_tag_get(struct radix_tree
 EXPORT_SYMBOL(radix_tree_tag_get);
 
 /**
+ * radix_tree_range_tag_if_tagged - for each item in given range set given
+ *				   tag if item has another tag set
+ * @root:		radix tree root
+ * @first_indexp:	pointer to a starting index of a range to scan
+ * @last_index:		last index of a range to scan
+ * @nr_to_tag:		maximum number items to tag
+ * @iftag: 		tag index to test
+ * @settag:		tag index to set if tested tag is set
+ *
+ * This function scans range of radix tree from first_index to last_index
+ * (inclusive).  For each item in the range if iftag is set, the function sets
+ * also settag. The function stops either after tagging nr_to_tag items or
+ * after reaching last_index.
+ *
+ * The function returns number of leaves where the tag was set and sets
+ * *first_indexp to the first unscanned index.
+ */
+unsigned long radix_tree_range_tag_if_tagged(struct radix_tree_root *root,
+                unsigned long *first_indexp, unsigned long last_index,
+                unsigned long nr_to_tag,
+		unsigned int iftag, unsigned int settag)
+{
+	unsigned int height = root->height, shift;
+	unsigned long tagged = 0, index = *first_indexp;
+	struct radix_tree_node *open_slots[height], *slot;
+
+	last_index = min(last_index, radix_tree_maxindex(height));
+	if (index > last_index)
+		return 0;
+	if (!root_tag_get(root, iftag)) {
+		*first_indexp = last_index + 1;
+		return 0;
+	}
+	if (height == 0) {
+		*first_indexp = last_index + 1;
+		root_tag_set(root, settag);
+		return 1;
+	}
+
+	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
+	slot = radix_tree_indirect_to_ptr(root->rnode);
+
+	for (;;) {
+		int offset;
+
+		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
+		if (!slot->slots[offset])
+			goto next;
+		if (!tag_get(slot, iftag, offset))
+			goto next;
+		tag_set(slot, settag, offset);
+		if (height == 1) {
+			tagged++;
+			goto next;
+		}
+		/* Go down one level */
+		height--;
+		shift -= RADIX_TREE_MAP_SHIFT;
+		open_slots[height] = slot;
+		slot = slot->slots[offset];
+		continue;
+next:
+		/* Go to next item at level determined by 'shift' */
+		index = ((index >> shift) + 1) << shift;
+		if (index > last_index)
+			break;
+		if (tagged > nr_to_tag)
+			break;
+		while (((index >> shift) & RADIX_TREE_MAP_MASK) == 0) {
+			/*
+			 * We've fully scanned this node. Go up. Because
+			 * last_index is guaranteed to be in the tree, what
+			 * we do below cannot wander astray.
+			 */
+			slot = open_slots[height];
+			height++;
+			shift += RADIX_TREE_MAP_SHIFT;
+		}
+	}
+	/*
+	 * The iftag must have been set somewhere because otherwise
+	 * we would return immediated at the beginning of the function
+	 */
+	root_tag_set(root, settag);
+	*first_indexp = index;
+
+	return tagged;
+}
+EXPORT_SYMBOL(radix_tree_range_tag_if_tagged);
+
+
+/**
  *	radix_tree_next_hole    -    find the next hole (not-present entry)
  *	@root:		tree root
  *	@index:		index key
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
radix-tree-implement-function-radix_tree_range_tag_if_tagged.patch
mm-implement-writeback-livelock-avoidance-using-page-tagging.patch
reiser4.patch

