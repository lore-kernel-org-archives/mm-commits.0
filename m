From: akpm@linux-foundation.org
Subject: [merged] radix-tree-rename-indirect_ptr-to-internal_node.patch
 removed from -mm tree
Date: Mon, 23 May 2016 12:50:52 -0700
Message-ID: <57435f1c.x/GMKRtarVu+vf+w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbcEWTux (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:50:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: rename INDIRECT_PTR to INTERNAL_NODE
has been removed from the -mm tree.  Its filename was
     radix-tree-rename-indirect_ptr-to-internal_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: rename INDIRECT_PTR to INTERNAL_NODE

The name RADIX_TREE_INDIRECT_PTR doesn't really match the meaning.
RADIX_TREE_INTERNAL_NODE is a better name.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |   30 +++++++++++++-----------------
 lib/radix-tree.c           |    2 +-
 2 files changed, 14 insertions(+), 18 deletions(-)

diff -puN include/linux/radix-tree.h~radix-tree-rename-indirect_ptr-to-internal_node include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-rename-indirect_ptr-to-internal_node
+++ a/include/linux/radix-tree.h
@@ -29,20 +29,16 @@
 #include <linux/rcupdate.h>
 
 /*
- * An indirect pointer (root->rnode pointing to a radix_tree_node, rather
- * than a data item) is signalled by the low bit set in the root->rnode
- * pointer.
- *
- * In this case root->height is > 0, but the indirect pointer tests are
- * needed for RCU lookups (because root->height is unreliable). The only
- * time callers need worry about this is when doing a lookup_slot under
- * RCU.
- *
- * Indirect pointer in fact is also used to tag the last pointer of a node
- * when it is shrunk, before we rcu free the node. See shrink code for
- * details.
+ * Entries in the radix tree have the low bit set if they refer to a
+ * radix_tree_node.  If the low bit is clear then the entry is user data.
+ *
+ * We also use the low bit to indicate that the slot will be freed in the
+ * next RCU idle period, and users need to re-walk the tree to find the
+ * new slot for the index that they were looking for.  See the comment in
+ * radix_tree_shrink() for details.
  */
-#define RADIX_TREE_INDIRECT_PTR		1
+#define RADIX_TREE_INTERNAL_NODE	1
+
 /*
  * A common use of the radix tree is to store pointers to struct pages;
  * but shmem/tmpfs needs also to store swap entries in the same tree:
@@ -63,7 +59,7 @@
 
 static inline int radix_tree_is_indirect_ptr(void *ptr)
 {
-	return (int)((unsigned long)ptr & RADIX_TREE_INDIRECT_PTR);
+	return (int)((unsigned long)ptr & RADIX_TREE_INTERNAL_NODE);
 }
 
 /*** radix-tree API starts here ***/
@@ -228,7 +224,7 @@ static inline void *radix_tree_deref_slo
  */
 static inline int radix_tree_deref_retry(void *arg)
 {
-	return unlikely((unsigned long)arg & RADIX_TREE_INDIRECT_PTR);
+	return unlikely(radix_tree_is_indirect_ptr(arg));
 }
 
 /**
@@ -250,7 +246,7 @@ static inline int radix_tree_exceptional
 static inline int radix_tree_exception(void *arg)
 {
 	return unlikely((unsigned long)arg &
-		(RADIX_TREE_INDIRECT_PTR | RADIX_TREE_EXCEPTIONAL_ENTRY));
+		(RADIX_TREE_INTERNAL_NODE | RADIX_TREE_EXCEPTIONAL_ENTRY));
 }
 
 /**
@@ -448,7 +444,7 @@ radix_tree_chunk_size(struct radix_tree_
 
 static inline void *indirect_to_ptr(void *ptr)
 {
-	return (void *)((unsigned long)ptr & ~RADIX_TREE_INDIRECT_PTR);
+	return (void *)((unsigned long)ptr & ~RADIX_TREE_INTERNAL_NODE);
 }
 
 /**
diff -puN lib/radix-tree.c~radix-tree-rename-indirect_ptr-to-internal_node lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-rename-indirect_ptr-to-internal_node
+++ a/lib/radix-tree.c
@@ -68,7 +68,7 @@ static DEFINE_PER_CPU(struct radix_tree_
 
 static inline void *ptr_to_indirect(void *ptr)
 {
-	return (void *)((unsigned long)ptr | RADIX_TREE_INDIRECT_PTR);
+	return (void *)((unsigned long)ptr | RADIX_TREE_INTERNAL_NODE);
 }
 
 #define RADIX_TREE_RETRY	ptr_to_indirect(NULL)
_

Patches currently in -mm which might be from willy@linux.intel.com are

radix-tree-rename-ptr_to_indirect-to-node_to_entry.patch
radix-tree-rename-indirect_to_ptr-to-entry_to_node.patch
radix-tree-rename-radix_tree_is_indirect_ptr.patch
radix-tree-change-naming-conventions-in-radix_tree_shrink.patch
radix-tree-tidy-up-next_chunk.patch
radix-tree-tidy-up-range_tag_if_tagged.patch
radix-tree-tidy-up-__radix_tree_create.patch
radix-tree-introduce-radix_tree_replace_clear_tags.patch
radix-tree-make-radix_tree_descend-more-useful.patch
radix-tree-free-up-the-bottom-bit-of-exceptional-entries-for-reuse.patch

