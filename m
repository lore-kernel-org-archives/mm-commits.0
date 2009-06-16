From: akpm@linux-foundation.org
Subject: [folded] lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot-update.patch removed from -mm tree
Date: Tue, 16 Jun 2009 15:05:19 -0700
Message-ID: <200906162205.n5GM5KIZ001670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52340 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753623AbZFPWFT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 18:05:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie8@gmail.com, mm-commits@vger.kernel.org


The patch titled
     lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot update
has been removed from the -mm tree.  Its filename was
     lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot-update.patch

This patch was dropped because it was folded into lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot update
From: Huang Shijie <shijie8@gmail.com>

Signed-off-by: Huang Shijie <shijie8@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN lib/radix-tree.c~lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot-update lib/radix-tree.c
--- a/lib/radix-tree.c~lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot-update
+++ a/lib/radix-tree.c
@@ -355,8 +355,8 @@ EXPORT_SYMBOL(radix_tree_insert);
  * is_slot == 1 : search for the slot.
  * is_slot == 0 : search for the node.
  */
-static void * radix_tree_lookup_element(struct radix_tree_root *root,
-					unsigned long index, int is_slot)
+static void *radix_tree_lookup_element(struct radix_tree_root *root,
+				unsigned long index, int is_slot)
 {
 	unsigned int height, shift;
 	struct radix_tree_node *node, **slot;
@@ -389,25 +389,25 @@ static void * radix_tree_lookup_element(
 		height--;
 	} while (height > 0);
 
-	return is_slot ? (void *)slot : node;
+	return is_slot ? (void *)slot:node;
 }
 
 /**
- *    radix_tree_lookup_slot    -    lookup a slot in a radix tree
- *    @root:        radix tree root
- *    @index:        index key
+ *	radix_tree_lookup_slot    -    lookup a slot in a radix tree
+ *	@root:		radix tree root
+ *	@index:		index key
  *
- *    Returns:  the slot corresponding to the position @index in the
- *    radix tree @root. This is useful for update-if-exists operations.
+ *	Returns:  the slot corresponding to the position @index in the
+ *	radix tree @root. This is useful for update-if-exists operations.
  *
- *    This function can be called under rcu_read_lock iff the slot is not
- *    modified by radix_tree_replace_slot, otherwise it must be called
- *    exclusive from other writers. Any dereference of the slot must be done
- *    using radix_tree_deref_slot.
+ *	This function can be called under rcu_read_lock iff the slot is not
+ *	modified by radix_tree_replace_slot, otherwise it must be called
+ *	exclusive from other writers. Any dereference of the slot must be done
+ *	using radix_tree_deref_slot.
  */
 void **radix_tree_lookup_slot(struct radix_tree_root *root, unsigned long index)
 {
-	return (void**)radix_tree_lookup_element(root, index, 1);
+	return (void **)radix_tree_lookup_element(root, index, 1);
 }
 EXPORT_SYMBOL(radix_tree_lookup_slot);
 
@@ -425,7 +425,7 @@ EXPORT_SYMBOL(radix_tree_lookup_slot);
  */
 void *radix_tree_lookup(struct radix_tree_root *root, unsigned long index)
 {
-    return radix_tree_lookup_element(root, index, 0);
+	return radix_tree_lookup_element(root, index, 0);
 }
 EXPORT_SYMBOL(radix_tree_lookup);
 
_

Patches currently in -mm which might be from shijie8@gmail.com are

lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot.patch
lib-do-code-optimization-for-radix_tree_lookup-and-radix_tree_lookup_slot-update.patch

