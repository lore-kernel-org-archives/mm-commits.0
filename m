From: akpm@linux-foundation.org
Subject: [patch 123/162] radix-tree: fix radix_tree_create for sibling
 entries
Date: Fri, 20 May 2016 17:02:44 -0700
Message-ID: <573fa5a4.nVcAeXbRoV5uGkiy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53031 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbcEUACp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:02:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com

From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: fix radix_tree_create for sibling entries

If the radix tree user attempted to insert a colliding entry with an
existing multiorder entry, then radix_tree_create() could encounter a
sibling entry when walking down the tree to look for a slot.  Use
radix_tree_descend() to fix the problem, and add a test-case to make sure
the problem doesn't come back in future.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c                      |    4 ++--
 tools/testing/radix-tree/multiorder.c |    5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-fix-radix_tree_create-for-sibling-entries lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-fix-radix_tree_create-for-sibling-entries
+++ a/lib/radix-tree.c
@@ -548,9 +548,9 @@ int __radix_tree_create(struct radix_tre
 		/* Go a level down */
 		height--;
 		shift -= RADIX_TREE_MAP_SHIFT;
-		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
 		node = indirect_to_ptr(slot);
-		slot = node->slots[offset];
+		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
+		offset = radix_tree_descend(node, &slot, offset);
 	}
 
 #ifdef CONFIG_RADIX_TREE_MULTIORDER
diff -puN tools/testing/radix-tree/multiorder.c~radix-tree-fix-radix_tree_create-for-sibling-entries tools/testing/radix-tree/multiorder.c
--- a/tools/testing/radix-tree/multiorder.c~radix-tree-fix-radix_tree_create-for-sibling-entries
+++ a/tools/testing/radix-tree/multiorder.c
@@ -135,6 +135,11 @@ static void multiorder_check(unsigned lo
 		item_check_absent(&tree, i);
 	for (i = max; i < 2*max; i++)
 		item_check_absent(&tree, i);
+	for (i = min; i < max; i++) {
+		static void *entry = (void *)
+					(0xA0 | RADIX_TREE_EXCEPTIONAL_ENTRY);
+		assert(radix_tree_insert(&tree, i, entry) == -EEXIST);
+	}
 
 	assert(item_delete(&tree, index) != 0);
 
_
