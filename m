From: akpm@linux-foundation.org
Subject: + radix_tree-loop-based-on-shift-count-not-height.patch added to
 -mm tree
Date: Tue, 26 Jan 2016 15:31:13 -0800
Message-ID: <56a801c1.EiGAaaVowl4Mt1lx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36247 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbcAZXbO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jan 2016 18:31:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix_tree: loop based on shift count, not height
has been added to the -mm tree.  Its filename is
     radix_tree-loop-based-on-shift-count-not-height.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix_tree-loop-based-on-shift-count-not-height.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix_tree-loop-based-on-shift-count-not-height.patch

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
Subject: radix_tree: loop based on shift count, not height

When we introduce entries that can cover multiple indices, we will need to
stop in __radix_tree_create based on the shift, not the height.  Split out
for ease of bisect.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/radix-tree.c~radix_tree-loop-based-on-shift-count-not-height lib/radix-tree.c
--- a/lib/radix-tree.c~radix_tree-loop-based-on-shift-count-not-height
+++ a/lib/radix-tree.c
@@ -407,10 +407,10 @@ int __radix_tree_create(struct radix_tre
 	slot = indirect_to_ptr(root->rnode);
 
 	height = root->height;
-	shift = (height-1) * RADIX_TREE_MAP_SHIFT;
+	shift = height * RADIX_TREE_MAP_SHIFT;
 
 	offset = 0;			/* uninitialised var warning */
-	while (height > 0) {
+	while (shift > 0) {
 		if (slot == NULL) {
 			/* Have to add a child node.  */
 			slot = radix_tree_node_alloc(root);
@@ -429,11 +429,11 @@ int __radix_tree_create(struct radix_tre
 		}
 
 		/* Go a level down */
+		shift -= RADIX_TREE_MAP_SHIFT;
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
 		node = slot;
 		slot = node->slots[offset];
 		slot = indirect_to_ptr(slot);
-		shift -= RADIX_TREE_MAP_SHIFT;
 		height--;
 	}
 
_

Patches currently in -mm which might be from willy@linux.intel.com are

radix-tree-add-an-explicit-include-of-bitopsh.patch
radix-tree-test-harness.patch
radix-tree-cleanups.patch
radix_tree-tag-all-internal-tree-nodes-as-indirect-pointers.patch
radix_tree-loop-based-on-shift-count-not-height.patch
radix_tree-add-support-for-multi-order-entries.patch
radix_tree-add-radix_tree_dump.patch

