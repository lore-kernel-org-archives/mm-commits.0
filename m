From: akpm@linux-foundation.org
Subject: [patch 116/162] radix-tree: fix multiorder BUG_ON in
 radix_tree_insert
Date: Fri, 20 May 2016 17:02:23 -0700
Message-ID: <573fa58f.YrT8fn3BbPkgJ5gg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbcEUACZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:02:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com

From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: fix multiorder BUG_ON in radix_tree_insert

These BUG_ON tests are to ensure that all the tags are clear when
inserting a new entry.  If we insert a multiorder entry, we'll end up
looking at the tags for a different node, and so the BUG_ON can end up
triggering spuriously.

Also, we now have three tags, not two, so check all three are clear, and
check all the root tags with a single call to BUG_ON since the bits are
stored contiguously.

Include a test-case to ensure this problem does not reoccur.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c                      |   14 ++++++++++----
 tools/testing/radix-tree/multiorder.c |   12 ++++++++++++
 2 files changed, 22 insertions(+), 4 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-fix-multiorder-bug_on-in-radix_tree_insert lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-fix-multiorder-bug_on-in-radix_tree_insert
+++ a/lib/radix-tree.c
@@ -165,6 +165,11 @@ static inline int root_tag_get(struct ra
 	return (__force unsigned)root->gfp_mask & (1 << (tag + __GFP_BITS_SHIFT));
 }
 
+static inline unsigned root_tags_get(struct radix_tree_root *root)
+{
+	return (__force unsigned)root->gfp_mask >> __GFP_BITS_SHIFT;
+}
+
 /*
  * Returns 1 if any slot in the node has this tag set.
  * Otherwise returns 0.
@@ -604,12 +609,13 @@ int __radix_tree_insert(struct radix_tre
 	rcu_assign_pointer(*slot, item);
 
 	if (node) {
+		unsigned offset = get_slot_offset(node, slot);
 		node->count++;
-		BUG_ON(tag_get(node, 0, index & RADIX_TREE_MAP_MASK));
-		BUG_ON(tag_get(node, 1, index & RADIX_TREE_MAP_MASK));
+		BUG_ON(tag_get(node, 0, offset));
+		BUG_ON(tag_get(node, 1, offset));
+		BUG_ON(tag_get(node, 2, offset));
 	} else {
-		BUG_ON(root_tag_get(root, 0));
-		BUG_ON(root_tag_get(root, 1));
+		BUG_ON(root_tags_get(root));
 	}
 
 	return 0;
diff -puN tools/testing/radix-tree/multiorder.c~radix-tree-fix-multiorder-bug_on-in-radix_tree_insert tools/testing/radix-tree/multiorder.c
--- a/tools/testing/radix-tree/multiorder.c~radix-tree-fix-multiorder-bug_on-in-radix_tree_insert
+++ a/tools/testing/radix-tree/multiorder.c
@@ -81,6 +81,17 @@ static void multiorder_shrink(unsigned l
 		item_check_absent(&tree, i);
 }
 
+static void multiorder_insert_bug(void)
+{
+	RADIX_TREE(tree, GFP_KERNEL);
+
+	item_insert(&tree, 0);
+	radix_tree_tag_set(&tree, 0, 0);
+	item_insert_order(&tree, 3 << 6, 6);
+
+	item_kill_tree(&tree);
+}
+
 void multiorder_checks(void)
 {
 	int i;
@@ -94,4 +105,5 @@ void multiorder_checks(void)
 	for (i = 0; i < 15; i++)
 		multiorder_shrink((1UL << (i + RADIX_TREE_MAP_SHIFT)), i);
 
+	multiorder_insert_bug();
 }
_
