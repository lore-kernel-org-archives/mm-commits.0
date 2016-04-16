From: akpm@linux-foundation.org
Subject: + radix-tree-fix-radix_tree_create-for-sibling-entries.patch
 added to -mm tree
Date: Fri, 15 Apr 2016 22:58:44 -0700
Message-ID: <5711d494.q0Ie5FVFXGeLA8pQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbcDPF6p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2016 01:58:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: fix radix_tree_create for sibling entries
has been added to the -mm tree.  Its filename is
     radix-tree-fix-radix_tree_create-for-sibling-entries.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-fix-radix_tree_create-for-sibling-entries.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-fix-radix_tree_create-for-sibling-entries.patch

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

