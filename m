From: akpm@linux-foundation.org
Subject: + radix-tree-rewrite-radix_tree_tag_clear.patch added to -mm tree
Date: Fri, 15 Apr 2016 22:58:38 -0700
Message-ID: <5711d48e.uehthUzX0pY5rKPT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbcDPF6j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2016 01:58:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: Rewrite radix_tree_tag_clear
has been added to the -mm tree.  Its filename is
     radix-tree-rewrite-radix_tree_tag_clear.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-rewrite-radix_tree_tag_clear.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-rewrite-radix_tree_tag_clear.patch

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
Subject: radix-tree: Rewrite radix_tree_tag_clear

Use the new multi-order support functions to rewrite
radix_tree_tag_clear()

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   44 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-rewrite-radix_tree_tag_clear lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-rewrite-radix_tree_tag_clear
+++ a/lib/radix-tree.c
@@ -768,44 +768,40 @@ EXPORT_SYMBOL(radix_tree_tag_set);
 void *radix_tree_tag_clear(struct radix_tree_root *root,
 			unsigned long index, unsigned int tag)
 {
-	struct radix_tree_node *node = NULL;
-	struct radix_tree_node *slot = NULL;
-	unsigned int height, shift;
+	struct radix_tree_node *node, *parent;
+	unsigned long maxindex;
+	unsigned int shift;
 	int uninitialized_var(offset);
 
-	height = root->height;
-	if (index > radix_tree_maxindex(height))
-		goto out;
-
-	shift = height * RADIX_TREE_MAP_SHIFT;
-	slot = root->rnode;
+	shift = radix_tree_load_root(root, &node, &maxindex);
+	if (index > maxindex)
+		return NULL;
 
-	while (shift) {
-		if (slot == NULL)
-			goto out;
-		if (!radix_tree_is_indirect_ptr(slot))
-			break;
-		slot = indirect_to_ptr(slot);
+	parent = NULL;
 
+	while (radix_tree_is_indirect_ptr(node)) {
 		shift -= RADIX_TREE_MAP_SHIFT;
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
-		node = slot;
-		slot = slot->slots[offset];
+
+		parent = indirect_to_ptr(node);
+		offset = radix_tree_descend(parent, &node, offset);
 	}
 
-	if (slot == NULL)
+	if (node == NULL)
 		goto out;
 
-	while (node) {
-		if (!tag_get(node, tag, offset))
+	index >>= shift;
+
+	while (parent) {
+		if (!tag_get(parent, tag, offset))
 			goto out;
-		tag_clear(node, tag, offset);
-		if (any_tag_set(node, tag))
+		tag_clear(parent, tag, offset);
+		if (any_tag_set(parent, tag))
 			goto out;
 
 		index >>= RADIX_TREE_MAP_SHIFT;
 		offset = index & RADIX_TREE_MAP_MASK;
-		node = node->parent;
+		parent = parent->parent;
 	}
 
 	/* clear the root's tag bit */
@@ -813,7 +809,7 @@ void *radix_tree_tag_clear(struct radix_
 		root_tag_clear(root, tag);
 
 out:
-	return slot;
+	return node;
 }
 EXPORT_SYMBOL(radix_tree_tag_clear);
 
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

