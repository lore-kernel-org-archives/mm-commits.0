From: akpm@linux-foundation.org
Subject: [patch 134/162] radix tree test suite: remove dependencies on
 height
Date: Fri, 20 May 2016 17:03:16 -0700
Message-ID: <573fa5c4.nJUKZEkP6RjuWG4X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcEUADR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:03:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com

From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix tree test suite: remove dependencies on height

verify_node() can use node->shift instead of the height.

tree_verify_min_height() can be converted over to using node_maxindex()
and shift_maxindex() instead of radix_tree_maxindex().

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/test.c |   34 ++++++++++++++++++++----------
 tools/testing/radix-tree/test.h |    3 +-
 2 files changed, 25 insertions(+), 12 deletions(-)

diff -puN tools/testing/radix-tree/test.c~radix-tree-test-suite-remove-dependencies-on-height tools/testing/radix-tree/test.c
--- a/tools/testing/radix-tree/test.c~radix-tree-test-suite-remove-dependencies-on-height
+++ a/tools/testing/radix-tree/test.c
@@ -143,7 +143,7 @@ void item_full_scan(struct radix_tree_ro
 }
 
 static int verify_node(struct radix_tree_node *slot, unsigned int tag,
-			unsigned int height, int tagged)
+			int tagged)
 {
 	int anyset = 0;
 	int i;
@@ -159,7 +159,8 @@ static int verify_node(struct radix_tree
 		}
 	}
 	if (tagged != anyset) {
-		printf("tag: %u, height %u, tagged: %d, anyset: %d\n", tag, height, tagged, anyset);
+		printf("tag: %u, shift %u, tagged: %d, anyset: %d\n",
+			tag, slot->shift, tagged, anyset);
 		for (j = 0; j < RADIX_TREE_MAX_TAGS; j++) {
 			printf("tag %d: ", j);
 			for (i = 0; i < RADIX_TREE_TAG_LONGS; i++)
@@ -171,10 +172,10 @@ static int verify_node(struct radix_tree
 	assert(tagged == anyset);
 
 	/* Go for next level */
-	if (height > 1) {
+	if (slot->shift > 0) {
 		for (i = 0; i < RADIX_TREE_MAP_SIZE; i++)
 			if (slot->slots[i])
-				if (verify_node(slot->slots[i], tag, height - 1,
+				if (verify_node(slot->slots[i], tag,
 					    !!test_bit(i, slot->tags[tag]))) {
 					printf("Failure at off %d\n", i);
 					for (j = 0; j < RADIX_TREE_MAX_TAGS; j++) {
@@ -191,9 +192,10 @@ static int verify_node(struct radix_tree
 
 void verify_tag_consistency(struct radix_tree_root *root, unsigned int tag)
 {
-	if (!root->height)
+	struct radix_tree_node *node = root->rnode;
+	if (!radix_tree_is_indirect_ptr(node))
 		return;
-	verify_node(root->rnode, tag, root->height, !!root_tag_get(root, tag));
+	verify_node(node, tag, !!root_tag_get(root, tag));
 }
 
 void item_kill_tree(struct radix_tree_root *root)
@@ -218,9 +220,19 @@ void item_kill_tree(struct radix_tree_ro
 
 void tree_verify_min_height(struct radix_tree_root *root, int maxindex)
 {
-	assert(radix_tree_maxindex(root->height) >= maxindex);
-	if (root->height > 1)
-		assert(radix_tree_maxindex(root->height-1) < maxindex);
-	else if (root->height == 1)
-		assert(radix_tree_maxindex(root->height-1) <= maxindex);
+	unsigned shift;
+	struct radix_tree_node *node = root->rnode;
+	if (!radix_tree_is_indirect_ptr(node)) {
+		assert(maxindex == 0);
+		return;
+	}
+
+	node = indirect_to_ptr(node);
+	assert(maxindex <= node_maxindex(node));
+
+	shift = node->shift;
+	if (shift > 0)
+		assert(maxindex > shift_maxindex(shift - RADIX_TREE_MAP_SHIFT));
+	else
+		assert(maxindex > 0);
 }
diff -puN tools/testing/radix-tree/test.h~radix-tree-test-suite-remove-dependencies-on-height tools/testing/radix-tree/test.h
--- a/tools/testing/radix-tree/test.h~radix-tree-test-suite-remove-dependencies-on-height
+++ a/tools/testing/radix-tree/test.h
@@ -42,4 +42,5 @@ extern int nr_allocated;
 void *indirect_to_ptr(void *ptr);
 void radix_tree_dump(struct radix_tree_root *root);
 int root_tag_get(struct radix_tree_root *root, unsigned int tag);
-unsigned long radix_tree_maxindex(unsigned int height);
+unsigned long node_maxindex(struct radix_tree_node *);
+unsigned long shift_maxindex(unsigned int shift);
_
