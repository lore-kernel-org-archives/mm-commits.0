From: akpm@linux-foundation.org
Subject: +
 radix-tree-free-up-the-bottom-bit-of-exceptional-entries-for-reuse.patch
 added to -mm tree
Date: Fri, 15 Apr 2016 23:05:09 -0700
Message-ID: <5711d615.hITCgq+MeXogNd5g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33696 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbcDPGFK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2016 02:05:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: free up the bottom bit of exceptional entries for reuse
has been added to the -mm tree.  Its filename is
     radix-tree-free-up-the-bottom-bit-of-exceptional-entries-for-reuse.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-free-up-the-bottom-bit-of-exceptional-entries-for-reuse.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-free-up-the-bottom-bit-of-exceptional-entries-for-reuse.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

radix-tree-introduce-radix_tree_empty.patch
radix-tree-test-suite-fix-build.patch
radix-tree-test-suite-add-tests-for-radix_tree_locate_item.patch
introduce-config_radix_tree_multiorder.patch
radix-tree-add-missing-sibling-entry-functionality.patch
radix-tree-fix-sibling-entry-insertion.patch
radix-tree-fix-deleting-a-multi-order-entry-through-an-alias.patch
radix-tree-remove-restriction-on-multi-order-entries.patch
radix-tree-introduce-radix_tree_load_root.patch
radix-tree-fix-extending-the-tree-for-multi-order-entries-at-offset-0.patch
radix-tree-test-suite-start-adding-multiorder-tests.patch
radix-tree-fix-several-shrinking-bugs-with-multiorder-entries.patch
radix-tree-rewrite-__radix_tree_lookup.patch
radix-tree-fix-multiorder-bug_on-in-radix_tree_insert.patch
radix-tree-fix-radix_tree_create-for-sibling-entries.patch
radix-tree-rewrite-radix_tree_locate_item.patch
radix-tree-fix-radix_tree_range_tag_if_tagged-for-multiorder-entries.patch
radix-tree-add-copyright-statements.patch
drivers-hwspinlock-use-correct-radix-tree-api.patch
radix-tree-miscellaneous-fixes.patch
radix-tree-split-node-path-into-offset-and-height.patch
radix-tree-replace-node-height-with-node-shift.patch
radix-tree-remove-a-use-of-root-height-from-delete_node.patch
radix-tree-test-suite-remove-dependencies-on-height.patch
radix-tree-remove-root-height.patch
radix-tree-rename-indirect_ptr-to-internal_node.patch
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

