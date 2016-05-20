From: akpm@linux-foundation.org
Subject: [folded-merged]
 radix-tree-rewrite-radix_tree_locate_item-fix.patch removed from -mm tree
Date: Fri, 20 May 2016 16:45:42 -0700
Message-ID: <573fa1a6.ktDC+nLjkUM7uJwd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbcETXpn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:45:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, ross.zwisler@linux.intel.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix-tree: rewrite radix_tree_locate_item fix
has been removed from the -mm tree.  Its filename was
     radix-tree-rewrite-radix_tree_locate_item-fix.patch

This patch was dropped because it was folded into radix-tree-rewrite-radix_tree_locate_item.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: radix-tree: rewrite radix_tree_locate_item fix

radix_tree_locate_item() is often returning the wrong index, causing
swapoff of shmem to hang because it cannot find the swap entry there.
__locate()'s use of base is bogus, it adds an offset twice into index.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.1605012108490.1166@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN lib/radix-tree.c~radix-tree-rewrite-radix_tree_locate_item-fix lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-rewrite-radix_tree_locate_item-fix
+++ a/lib/radix-tree.c
@@ -1315,18 +1315,17 @@ static unsigned long __locate(struct rad
 			      unsigned long index, struct locate_info *info)
 {
 	unsigned int shift, height;
-	unsigned long base, i;
+	unsigned long i;
 
 	height = slot->path & RADIX_TREE_HEIGHT_MASK;
 	shift = height * RADIX_TREE_MAP_SHIFT;
 
 	do {
 		shift -= RADIX_TREE_MAP_SHIFT;
-		base = index & ~((1UL << shift) - 1);
 
 		for (i = (index >> shift) & RADIX_TREE_MAP_MASK;
 		     i < RADIX_TREE_MAP_SIZE;
-		     i++, index = base + (i << shift)) {
+		     i++, index += (1UL << shift)) {
 			struct radix_tree_node *node =
 					rcu_dereference_raw(slot->slots[i]);
 			if (node == RADIX_TREE_RETRY)
_

Patches currently in -mm which might be from hughd@google.com are

radix-tree-rewrite-radix_tree_locate_item.patch

