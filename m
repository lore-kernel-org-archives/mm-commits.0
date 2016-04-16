From: akpm@linux-foundation.org
Subject: + radix-tree-rewrite-radix_tree_tag_get.patch added to -mm tree
Date: Fri, 15 Apr 2016 22:58:40 -0700
Message-ID: <5711d490.hQcvw5RjIz9tsASI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33398 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbcDPF6l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2016 01:58:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: Rewrite radix_tree_tag_get
has been added to the -mm tree.  Its filename is
     radix-tree-rewrite-radix_tree_tag_get.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-rewrite-radix_tree_tag_get.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-rewrite-radix_tree_tag_get.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: radix-tree: Rewrite radix_tree_tag_get

Use the new multi-order support functions to rewrite radix_tree_tag_get()

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   44 ++++++++++++++++++--------------------------
 1 file changed, 18 insertions(+), 26 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-rewrite-radix_tree_tag_get lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-rewrite-radix_tree_tag_get
+++ a/lib/radix-tree.c
@@ -831,45 +831,37 @@ EXPORT_SYMBOL(radix_tree_tag_clear);
 int radix_tree_tag_get(struct radix_tree_root *root,
 			unsigned long index, unsigned int tag)
 {
-	unsigned int height, shift;
-	struct radix_tree_node *node;
+	struct radix_tree_node *node, *parent;
+	unsigned long maxindex;
+	unsigned int shift;
 
-	/* check the root's tag bit */
 	if (!root_tag_get(root, tag))
 		return 0;
 
-	node = rcu_dereference_raw(root->rnode);
+	shift = radix_tree_load_root(root, &node, &maxindex);
+	if (index > maxindex)
+		return 0;
 	if (node == NULL)
 		return 0;
 
-	if (!radix_tree_is_indirect_ptr(node))
-		return (index == 0);
-	node = indirect_to_ptr(node);
+	while (radix_tree_is_indirect_ptr(node)) {
+		int offset;
 
-	height = node->path & RADIX_TREE_HEIGHT_MASK;
-	if (index > radix_tree_maxindex(height))
-		return 0;
+		shift -= RADIX_TREE_MAP_SHIFT;
+		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
 
-	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
+		parent = indirect_to_ptr(node);
+		offset = radix_tree_descend(parent, &node, offset);
 
-	for ( ; ; ) {
-		int offset;
-
-		if (node == NULL)
+		if (!node)
 			return 0;
-		node = indirect_to_ptr(node);
-
-		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
-		if (!tag_get(node, tag, offset))
+		if (!tag_get(parent, tag, offset))
 			return 0;
-		if (height == 1)
-			return 1;
-		node = rcu_dereference_raw(node->slots[offset]);
-		if (!radix_tree_is_indirect_ptr(node))
-			return 1;
-		shift -= RADIX_TREE_MAP_SHIFT;
-		height--;
+		if (node == RADIX_TREE_RETRY)
+			break;
 	}
+
+	return 1;
 }
 EXPORT_SYMBOL(radix_tree_tag_get);
 
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

radix-tree-test-suite-allow-testing-other-fan-out-values.patch
radix-tree-test-suite-keep-regression-test-runs-short.patch
radix-tree-test-suite-rebuild-when-headers-change.patch
radix-tree-remove-unused-looping-macros.patch
radix-tree-add-support-for-multi-order-iterating.patch
radix-tree-test-suite-multi-order-iteration-test.patch
radix-tree-rewrite-radix_tree_tag_set.patch
radix-tree-rewrite-radix_tree_tag_clear.patch
radix-tree-rewrite-radix_tree_tag_get.patch
radix-tree-test-suite-add-multi-order-tag-test.patch
radix-tree-fix-radix_tree_dump-for-multi-order-entries.patch

