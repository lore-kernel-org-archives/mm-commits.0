From: akpm@linux-foundation.org
Subject: [merged] radix-tree-fix-race-in-gang-lookup.patch removed from
 -mm tree
Date: Wed, 03 Feb 2016 13:53:28 -0800
Message-ID: <56b276d8.9YYsz5gMD1RGr/88%akpm__20264.8424231031$1454536422$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42274 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965157AbcBCVx3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2016 16:53:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, hughd@google.com, khlebnikov@openvz.org, ohad@wizery.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: fix race in gang lookup
has been removed from the -mm tree.  Its filename was
     radix-tree-fix-race-in-gang-lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: fix race in gang lookup

If the indirect_ptr bit is set on a slot, that indicates we need to redo
the lookup.  Introduce a new function radix_tree_iter_retry() which forces
the loop to retry the lookup by setting 'slot' to NULL and turning the
iterator back to point at the problematic entry.

This is a pretty rare problem to hit at the moment; the lookup has to race
with a grow of the radix tree from a height of 0.  The consequences of
hitting this race are that gang lookup could return a pointer to a
radix_tree_node instead of a pointer to whatever the user had inserted in
the tree.

Fixes: cebbd29e1c2f ("radix-tree: rewrite gang lookup using iterator")
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |   16 ++++++++++++++++
 lib/radix-tree.c           |   12 ++++++++++--
 2 files changed, 26 insertions(+), 2 deletions(-)

diff -puN include/linux/radix-tree.h~radix-tree-fix-race-in-gang-lookup include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-fix-race-in-gang-lookup
+++ a/include/linux/radix-tree.h
@@ -379,6 +379,22 @@ void **radix_tree_next_chunk(struct radi
 			     struct radix_tree_iter *iter, unsigned flags);
 
 /**
+ * radix_tree_iter_retry - retry this chunk of the iteration
+ * @iter:	iterator state
+ *
+ * If we iterate over a tree protected only by the RCU lock, a race
+ * against deletion or creation may result in seeing a slot for which
+ * radix_tree_deref_retry() returns true.  If so, call this function
+ * and continue the iteration.
+ */
+static inline __must_check
+void **radix_tree_iter_retry(struct radix_tree_iter *iter)
+{
+	iter->next_index = iter->index;
+	return NULL;
+}
+
+/**
  * radix_tree_chunk_size - get current chunk size
  *
  * @iter:	pointer to radix tree iterator
diff -puN lib/radix-tree.c~radix-tree-fix-race-in-gang-lookup lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-fix-race-in-gang-lookup
+++ a/lib/radix-tree.c
@@ -1019,9 +1019,13 @@ radix_tree_gang_lookup(struct radix_tree
 		return 0;
 
 	radix_tree_for_each_slot(slot, root, &iter, first_index) {
-		results[ret] = indirect_to_ptr(rcu_dereference_raw(*slot));
+		results[ret] = rcu_dereference_raw(*slot);
 		if (!results[ret])
 			continue;
+		if (radix_tree_is_indirect_ptr(results[ret])) {
+			slot = radix_tree_iter_retry(&iter);
+			continue;
+		}
 		if (++ret == max_items)
 			break;
 	}
@@ -1098,9 +1102,13 @@ radix_tree_gang_lookup_tag(struct radix_
 		return 0;
 
 	radix_tree_for_each_tagged(slot, root, &iter, first_index, tag) {
-		results[ret] = indirect_to_ptr(rcu_dereference_raw(*slot));
+		results[ret] = rcu_dereference_raw(*slot);
 		if (!results[ret])
 			continue;
+		if (radix_tree_is_indirect_ptr(results[ret])) {
+			slot = radix_tree_iter_retry(&iter);
+			continue;
+		}
 		if (++ret == max_items)
 			break;
 	}
_

Patches currently in -mm which might be from willy@linux.intel.com are

radix-tree-add-an-explicit-include-of-bitopsh.patch
radix-tree-test-harness.patch
radix_tree-tag-all-internal-tree-nodes-as-indirect-pointers.patch
radix_tree-loop-based-on-shift-count-not-height.patch
radix_tree-add-support-for-multi-order-entries.patch
radix_tree-add-radix_tree_dump.patch
btrfs-use-radix_tree_iter_retry.patch
mm-use-radix_tree_iter_retry.patch
radix-treeshmem-introduce-radix_tree_iter_next.patch

