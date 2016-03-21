From: akpm@linux-foundation.org
Subject: [merged] radix_tree-loop-based-on-shift-count-not-height.patch
 removed from -mm tree
Date: Mon, 21 Mar 2016 11:41:40 -0700
Message-ID: <56f04064.SytQHiNAeq6QHqHh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842AbcCUTVT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:21:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix_tree: loop based on shift count, not height
has been removed from the -mm tree.  Its filename was
     radix_tree-loop-based-on-shift-count-not-height.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -415,10 +415,10 @@ int __radix_tree_create(struct radix_tre
 	slot = indirect_to_ptr(root->rnode);
 
 	height = root->height;
-	shift = (height-1) * RADIX_TREE_MAP_SHIFT;
+	shift = height * RADIX_TREE_MAP_SHIFT;
 
 	offset = 0;			/* uninitialised var warning */
-	while (height > 0) {
+	while (shift > 0) {
 		if (slot == NULL) {
 			/* Have to add a child node.  */
 			if (!(slot = radix_tree_node_alloc(root)))
@@ -436,11 +436,11 @@ int __radix_tree_create(struct radix_tre
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


