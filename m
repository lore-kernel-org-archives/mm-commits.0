From: akpm@linux-foundation.org
Subject: [to-be-updated] rbtree-rb_erase-updates-and-comments.patch removed from -mm tree
Date: Wed, 15 Aug 2012 15:57:53 -0700
Message-ID: <20120815225754.6009B20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:38591 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2HOW55 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 18:57:57 -0400
Received: by eekd4 with SMTP id d4so100039eek.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 15:57:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, David.Woodhouse@intel.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, axboe@kernel.dk, daniel.santos@pobox.com, ebiederm@xmission.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree: rb_erase updates and comments
has been removed from the -mm tree.  Its filename was
     rbtree-rb_erase-updates-and-comments.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: rbtree: rb_erase updates and comments

Minor updates to the rb_erase() function:
- Reorder code to put simplest / common case (no more than 1 child) first.
- Fetch the parent first, since it ends up being required in all 3 cases.
- Add a few comments to illustrate case 2 (node to remove has 2 childs,
  but one of them is the successor) and case 3 (node to remove has 2 childs,
  successor is a left-descendant of the right child).

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Daniel Santos <daniel.santos@pobox.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree.c |  115 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 72 insertions(+), 43 deletions(-)

diff -puN lib/rbtree.c~rbtree-rb_erase-updates-and-comments lib/rbtree.c
--- a/lib/rbtree.c~rbtree-rb_erase-updates-and-comments
+++ a/lib/rbtree.c
@@ -2,7 +2,8 @@
   Red Black Trees
   (C) 1999  Andrea Arcangeli <andrea@suse.de>
   (C) 2002  David Woodhouse <dwmw2@infradead.org>
-  
+  (C) 2012  Michel Lespinasse <walken@google.com>
+
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
@@ -356,65 +357,93 @@ static void __rb_erase_color(struct rb_n
 
 void rb_erase(struct rb_node *node, struct rb_root *root)
 {
-	struct rb_node *child, *parent;
-	int color;
+	struct rb_node *parent = rb_parent(node);
+	struct rb_node *child = node->rb_right;
+	struct rb_node *tmp = node->rb_left;
+	bool black;
+
+	if (!tmp) {
+		/* Case 1: node to erase has no more than 1 child (easy!) */
+		if (child)
+one_child:
+			rb_set_parent(child, parent);
+		if (parent) {
+			if (parent->rb_left == node)
+				parent->rb_left = child;
+			else
+				parent->rb_right = child;
+		} else
+			root->rb_node = child;
 
-	if (!node->rb_left)
-		child = node->rb_right;
-	else if (!node->rb_right)
-		child = node->rb_left;
-	else {
-		struct rb_node *old = node, *left;
+		black = rb_is_black(node);
+	} else if (!child) {
+		/* Still case 1, but this time the child is node->rb_left */
+		child = tmp;
+		goto one_child;
+	} else {
+		struct rb_node *old = node;
 
+		/*
+		 * Old is the node we want to erase. It's got left and right
+		 * children, which makes things difficult. Let's find the
+		 * next node in the tree to have it fill old's position.
+		 */
 		node = node->rb_right;
-		while ((left = node->rb_left) != NULL)
-			node = left;
+		while ((tmp = node->rb_left) != NULL)
+			node = tmp;
 
-		if (rb_parent(old)) {
-			if (rb_parent(old)->rb_left == old)
-				rb_parent(old)->rb_left = node;
+		/* Graft node (old's successor) under old's parent. */
+		if (parent) {
+			if (parent->rb_left == old)
+				parent->rb_left = node;
 			else
-				rb_parent(old)->rb_right = node;
+				parent->rb_right = node;
 		} else
 			root->rb_node = node;
 
-		child = node->rb_right;
 		parent = rb_parent(node);
-		color = rb_color(node);
+		black = rb_is_black(node);
+		node->__rb_parent_color = old->__rb_parent_color;
+
+		/*
+		 * Node doesn't have a left child, since it is old's successor,
+		 * so we can take old's left child and graft it under node.
+		 */
+		node->rb_left = tmp = old->rb_left;
+		rb_set_parent(tmp, node);
 
+		child = node->rb_right;
 		if (parent == old) {
+			/*
+			 * Case 2: old is node's parent (we are done!)
+			 *
+			 *    (o)          (n)
+			 *    / \          / \
+			 *  (x) (n)  ->  (x) (c)
+			 *        \
+			 *        (c)
+			 */
 			parent = node;
 		} else {
+			/*
+			 * Case 3: old is node's ancestor but not its parent
+			 *
+			 *    (o)          (n)
+			 *    / \          / \
+			 *  (x) (y)  ->  (x) (y)
+			 *      /            /
+			 *    (n)          (c)
+			 *      \
+			 *      (c)
+			 */
+			node->rb_right = tmp = old->rb_right;
+			parent->rb_left = child;
+			rb_set_parent(tmp, node);
 			if (child)
 				rb_set_parent(child, parent);
-			parent->rb_left = child;
-
-			node->rb_right = old->rb_right;
-			rb_set_parent(old->rb_right, node);
 		}
-
-		node->__rb_parent_color = old->__rb_parent_color;
-		node->rb_left = old->rb_left;
-		rb_set_parent(old->rb_left, node);
-
-		goto color;
 	}
-
-	parent = rb_parent(node);
-	color = rb_color(node);
-
-	if (child)
-		rb_set_parent(child, parent);
-	if (parent) {
-		if (parent->rb_left == node)
-			parent->rb_left = child;
-		else
-			parent->rb_right = child;
-	} else
-		root->rb_node = child;
-
-color:
-	if (color == RB_BLACK)
+	if (black)
 		__rb_erase_color(child, parent, root);
 }
 EXPORT_SYMBOL(rb_erase);
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
slab-do-not-call-compound_head-in-page_get_cache.patch
ipc-mqueue-remove-unnecessary-rb_init_node-calls.patch
rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch
rbtree-empty-nodes-have-no-color.patch
rbtree-empty-nodes-have-no-color-fix.patch
rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec-fix.patch
rbtree-performance-and-correctness-test.patch
rbtree-performance-and-correctness-test-fix.patch
rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch
rbtree-low-level-optimizations-in-rb_insert_color.patch
rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch
rbtree-optimize-case-selection-logic-in-__rb_erase_color.patch
rbtree-low-level-optimizations-in-__rb_erase_color.patch
rbtree-coding-style-adjustments.patch
rbtree-optimize-fetching-of-sibling-node.patch

