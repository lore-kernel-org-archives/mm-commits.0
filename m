From: akpm@linux-foundation.org
Subject: [merged]
 radix-tree-free-up-the-bottom-bit-of-exceptional-entries-for-reuse.patch
 removed from -mm tree
Date: Mon, 23 May 2016 12:51:25 -0700
Message-ID: <57435f3d.pdOpjeowqarQI7zu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38200 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152AbcEWTv0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:51:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: free up the bottom bit of exceptional entries for reuse
has been removed from the -mm tree.  Its filename was
     radix-tree-free-up-the-bottom-bit-of-exceptional-entries-for-reuse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: free up the bottom bit of exceptional entries for reuse

We are guaranteed that pointers to radix_tree_nodes always have the bottom
two bits clear (because they come from a slab cache, and slab caches have
a minimum alignment of sizeof(void *)), so we can redefine
'radix_tree_is_internal_node' to only return true if the bottom two bits
have value '01'.  This frees up one quarter of the potential values for
use by the user.

Idea from Neil Brown.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Suggested-by: Neil Brown <neilb@suse.de>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/radix-tree.h |   36 +++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff -puN include/linux/radix-tree.h~radix-tree-free-up-the-bottom-bit-of-exceptional-entries-for-reuse include/linux/radix-tree.h
--- a/include/linux/radix-tree.h~radix-tree-free-up-the-bottom-bit-of-exceptional-entries-for-reuse
+++ a/include/linux/radix-tree.h
@@ -29,28 +29,37 @@
 #include <linux/rcupdate.h>
 
 /*
- * Entries in the radix tree have the low bit set if they refer to a
- * radix_tree_node.  If the low bit is clear then the entry is user data.
+ * The bottom two bits of the slot determine how the remaining bits in the
+ * slot are interpreted:
  *
- * We also use the low bit to indicate that the slot will be freed in the
- * next RCU idle period, and users need to re-walk the tree to find the
- * new slot for the index that they were looking for.  See the comment in
- * radix_tree_shrink() for details.
+ * 00 - data pointer
+ * 01 - internal entry
+ * 10 - exceptional entry
+ * 11 - locked exceptional entry
+ *
+ * The internal entry may be a pointer to the next level in the tree, a
+ * sibling entry, or an indicator that the entry in this slot has been moved
+ * to another location in the tree and the lookup should be restarted.  While
+ * NULL fits the 'data pointer' pattern, it means that there is no entry in
+ * the tree for this index (no matter what level of the tree it is found at).
+ * This means that you cannot store NULL in the tree as a value for the index.
  */
-#define RADIX_TREE_INTERNAL_NODE	1
+#define RADIX_TREE_ENTRY_MASK		3UL
+#define RADIX_TREE_INTERNAL_NODE	1UL
 
 /*
- * A common use of the radix tree is to store pointers to struct pages;
- * but shmem/tmpfs needs also to store swap entries in the same tree:
- * those are marked as exceptional entries to distinguish them.
+ * Most users of the radix tree store pointers but shmem/tmpfs stores swap
+ * entries in the same tree.  They are marked as exceptional entries to
+ * distinguish them from pointers to struct page.
  * EXCEPTIONAL_ENTRY tests the bit, EXCEPTIONAL_SHIFT shifts content past it.
  */
 #define RADIX_TREE_EXCEPTIONAL_ENTRY	2
 #define RADIX_TREE_EXCEPTIONAL_SHIFT	2
 
-static inline int radix_tree_is_internal_node(void *ptr)
+static inline bool radix_tree_is_internal_node(void *ptr)
 {
-	return (int)((unsigned long)ptr & RADIX_TREE_INTERNAL_NODE);
+	return ((unsigned long)ptr & RADIX_TREE_ENTRY_MASK) ==
+				RADIX_TREE_INTERNAL_NODE;
 }
 
 /*** radix-tree API starts here ***/
@@ -236,8 +245,7 @@ static inline int radix_tree_exceptional
  */
 static inline int radix_tree_exception(void *arg)
 {
-	return unlikely((unsigned long)arg &
-		(RADIX_TREE_INTERNAL_NODE | RADIX_TREE_EXCEPTIONAL_ENTRY));
+	return unlikely((unsigned long)arg & RADIX_TREE_ENTRY_MASK);
 }
 
 /**
_

Patches currently in -mm which might be from willy@linux.intel.com are


