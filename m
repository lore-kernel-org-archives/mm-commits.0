From: akpm@linux-foundation.org
Subject: [merged] rbtree-handle-1-child-recoloring-in-rb_erase-instead-of-rb_erase_color.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:09:58 -0700
Message-ID: <20121009180959.334C320005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:64548 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738Ab2JISKC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:10:02 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so360400fae.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:10:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree: handle 1-child recoloring in rb_erase() instead of rb_erase_color()
has been removed from the -mm tree.  Its filename was
     rbtree-handle-1-child-recoloring-in-rb_erase-instead-of-rb_erase_color.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: rbtree: handle 1-child recoloring in rb_erase() instead of rb_erase_color()

An interesting observation for rb_erase() is that when a node has
exactly one child, the node must be black and the child must be red.
An interesting consequence is that removing such a node can be done by
simply replacing it with its child and making the child black,
which we can do efficiently in rb_erase(). __rb_erase_color() then
only needs to handle the no-childs case and can be modified accordingly.

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree.c |  105 ++++++++++++++++++++++++++++---------------------
 1 file changed, 62 insertions(+), 43 deletions(-)

diff -puN lib/rbtree.c~rbtree-handle-1-child-recoloring-in-rb_erase-instead-of-rb_erase_color lib/rbtree.c
--- a/lib/rbtree.c~rbtree-handle-1-child-recoloring-in-rb_erase-instead-of-rb_erase_color
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
@@ -50,6 +51,11 @@
 #define rb_is_red(r)   (!rb_color(r))
 #define rb_is_black(r) rb_color(r)
 
+static inline void rb_set_black(struct rb_node *rb)
+{
+	rb->__rb_parent_color |= RB_BLACK;
+}
+
 static inline void rb_set_parent(struct rb_node *rb, struct rb_node *p)
 {
 	rb->__rb_parent_color = rb_color(rb) | (unsigned long)p;
@@ -214,27 +220,18 @@ void rb_insert_color(struct rb_node *nod
 }
 EXPORT_SYMBOL(rb_insert_color);
 
-static void __rb_erase_color(struct rb_node *node, struct rb_node *parent,
-			     struct rb_root *root)
+static void __rb_erase_color(struct rb_node *parent, struct rb_root *root)
 {
-	struct rb_node *sibling, *tmp1, *tmp2;
+	struct rb_node *node = NULL, *sibling, *tmp1, *tmp2;
 
 	while (true) {
 		/*
-		 * Loop invariant: all leaf paths going through node have a
-		 * black node count that is 1 lower than other leaf paths.
-		 *
-		 * If node is red, we can flip it to black to adjust.
-		 * If node is the root, all leaf paths go through it.
-		 * Otherwise, we need to adjust the tree through color flips
-		 * and tree rotations as per one of the 4 cases below.
+		 * Loop invariants:
+		 * - node is black (or NULL on first iteration)
+		 * - node is not the root (parent is not NULL)
+		 * - All leaf paths going through parent and node have a
+		 *   black node count that is 1 lower than other leaf paths.
 		 */
-		if (node && rb_is_red(node)) {
-			rb_set_parent_color(node, parent, RB_BLACK);
-			break;
-		} else if (!parent) {
-			break;
-		}
 		sibling = parent->rb_right;
 		if (node != sibling) {	/* node == parent->rb_left */
 			if (rb_is_red(sibling)) {
@@ -268,17 +265,22 @@ static void __rb_erase_color(struct rb_n
 					 *      / \           / \
 					 *     Sl  Sr        Sl  Sr
 					 *
-					 * This leaves us violating 5), so
-					 * recurse at p. If p is red, the
-					 * recursion will just flip it to black
-					 * and exit. If coming from Case 1,
-					 * p is known to be red.
+					 * This leaves us violating 5) which
+					 * can be fixed by flipping p to black
+					 * if it was red, or by recursing at p.
+					 * p is red when coming from Case 1.
 					 */
 					rb_set_parent_color(sibling, parent,
 							    RB_RED);
-					node = parent;
-					parent = rb_parent(node);
-					continue;
+					if (rb_is_red(parent))
+						rb_set_black(parent);
+					else {
+						node = parent;
+						parent = rb_parent(node);
+						if (parent)
+							continue;
+					}
+					break;
 				}
 				/*
 				 * Case 3 - right rotate at sibling
@@ -339,9 +341,15 @@ static void __rb_erase_color(struct rb_n
 					/* Case 2 - sibling color flip */
 					rb_set_parent_color(sibling, parent,
 							    RB_RED);
-					node = parent;
-					parent = rb_parent(node);
-					continue;
+					if (rb_is_red(parent))
+						rb_set_black(parent);
+					else {
+						node = parent;
+						parent = rb_parent(node);
+						if (parent)
+							continue;
+					}
+					break;
 				}
 				/* Case 3 - right rotate at sibling */
 				sibling->rb_right = tmp1 = tmp2->rb_left;
@@ -369,23 +377,31 @@ static void __rb_erase_color(struct rb_n
 void rb_erase(struct rb_node *node, struct rb_root *root)
 {
 	struct rb_node *child = node->rb_right, *tmp = node->rb_left;
-	struct rb_node *parent;
-	int color;
+	struct rb_node *parent, *rebalance;
 
 	if (!tmp) {
-	case1:
-		/* Case 1: node to erase has no more than 1 child (easy!) */
+		/*
+		 * Case 1: node to erase has no more than 1 child (easy!)
+		 *
+		 * Note that if there is one child it must be red due to 5)
+		 * and node must be black due to 4). We adjust colors locally
+		 * so as to bypass __rb_erase_color() later on.
+		 */
 
 		parent = rb_parent(node);
-		color = rb_color(node);
-
-		if (child)
-			rb_set_parent(child, parent);
 		__rb_change_child(node, child, parent, root);
+		if (child) {
+			rb_set_parent_color(child, parent, RB_BLACK);
+			rebalance = NULL;
+		} else {
+			rebalance = rb_is_black(node) ? parent : NULL;
+		}
 	} else if (!child) {
 		/* Still case 1, but this time the child is node->rb_left */
-		child = tmp;
-		goto case1;
+		parent = rb_parent(node);
+		__rb_change_child(node, tmp, parent, root);
+		rb_set_parent_color(tmp, parent, RB_BLACK);
+		rebalance = NULL;
 	} else {
 		struct rb_node *old = node, *left;
 
@@ -397,26 +413,29 @@ void rb_erase(struct rb_node *node, stru
 
 		child = node->rb_right;
 		parent = rb_parent(node);
-		color = rb_color(node);
 
 		if (parent == old) {
 			parent = node;
 		} else {
-			if (child)
-				rb_set_parent(child, parent);
 			parent->rb_left = child;
 
 			node->rb_right = old->rb_right;
 			rb_set_parent(old->rb_right, node);
 		}
 
+		if (child) {
+			rb_set_parent_color(child, parent, RB_BLACK);
+			rebalance = NULL;
+		} else {
+			rebalance = rb_is_black(node) ? parent : NULL;
+		}
 		node->__rb_parent_color = old->__rb_parent_color;
 		node->rb_left = old->rb_left;
 		rb_set_parent(old->rb_left, node);
 	}
 
-	if (color == RB_BLACK)
-		__rb_erase_color(child, parent, root);
+	if (rebalance)
+		__rb_erase_color(rebalance, root);
 }
 EXPORT_SYMBOL(rb_erase);
 
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
prio_tree-remove-fix.patch

