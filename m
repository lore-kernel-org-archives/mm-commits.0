From: akpm@linux-foundation.org
Subject: + rbtree-faster-augmented-rbtree-manipulation.patch added to -mm tree
Date: Mon, 20 Aug 2012 15:37:07 -0700
Message-ID: <20120820223708.64A601E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-iy0-f202.google.com ([209.85.210.202]:57383 "EHLO
	mail-iy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583Ab2HTWhK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 18:37:10 -0400
Received: by ialo24 with SMTP id o24so946511ial.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 15:37:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com


The patch titled
     Subject: rbtree: faster augmented rbtree manipulation
has been added to the -mm tree.  Its filename is
     rbtree-faster-augmented-rbtree-manipulation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: rbtree: faster augmented rbtree manipulation

Introduce new augmented rbtree APIs that allow minimal recalculation of
augmented node information.

A new callback is added to the rbtree insertion and erase rebalancing
functions, to be called on each tree rotations. Such rotations preserve
the subtree's root augmented value, but require recalculation of the one
child that was previously located at the subtree root.

In the insertion case, the handcoded search phase must be updated to
maintain the augmented information on insertion, and then the rbtree
coloring/rebalancing algorithms keep it up to date.

In the erase case, things are more complicated since it is library
code that manipulates the rbtree in order to remove internal nodes.
This requires a couple additional callbacks to copy a subtree's
augmented value when a new root is stitched in, and to recompute
augmented values down the ancestry path when a node is removed from
the tree.

In order to preserve maximum speed for the non-augmented case,
we provide two versions of each tree manipulation function.
rb_insert_augmented() is the augmented equivalent of rb_insert_color(),
and rb_erase_augmented() is the augmented equivalent of rb_erase().

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/rbtree.txt |  194 ++++++++++++++++++++++++++++++-------
 include/linux/rbtree.h   |   19 +++
 lib/rbtree.c             |   83 ++++++++++++++-
 lib/rbtree_test.c        |   58 ++++++++---
 4 files changed, 298 insertions(+), 56 deletions(-)

diff -puN Documentation/rbtree.txt~rbtree-faster-augmented-rbtree-manipulation Documentation/rbtree.txt
--- a/Documentation/rbtree.txt~rbtree-faster-augmented-rbtree-manipulation
+++ a/Documentation/rbtree.txt
@@ -193,25 +193,43 @@ Example:
 Support for Augmented rbtrees
 -----------------------------
 
-Augmented rbtree is an rbtree with "some" additional data stored in each node.
-This data can be used to augment some new functionality to rbtree.
-Augmented rbtree is an optional feature built on top of basic rbtree
-infrastructure. An rbtree user who wants this feature will have to call the
-augmentation functions with the user provided augmentation callback
-when inserting and erasing nodes.
-
-On insertion, the user must call rb_augment_insert() once the new node is in
-place. This will cause the augmentation function callback to be called for
-each node between the new node and the root which has been affected by the
-insertion.
-
-When erasing a node, the user must call rb_augment_erase_begin() first to
-retrieve the deepest node on the rebalance path. Then, after erasing the
-original node, the user must call rb_augment_erase_end() with the deepest
-node found earlier. This will cause the augmentation function to be called
-for each affected node between the deepest node and the root.
+Augmented rbtree is an rbtree with "some" additional data stored in
+each node, where the additional data for node N must be a function of
+the contents of all nodes in the subtree rooted at N. This data can
+be used to augment some new functionality to rbtree. Augmented rbtree
+is an optional feature built on top of basic rbtree infrastructure.
+An rbtree user who wants this feature will have to call the augmentation
+functions with the user provided augmentation callback when inserting
+and erasing nodes.
+
+On insertion, the user must update the augmented information on the path
+leading to the inserted node, then call rb_link_node() as usual and
+rb_augment_inserted() instead of the usual rb_insert_color() call.
+If rb_augment_inserted() rebalances the rbtree, it will callback into
+a user provided function to update the augmented information on the
+affected subtrees.
+
+When erasing a node, the user must call rb_erase_augmented() instead of
+rb_erase(). rb_erase_augmented() calls back into user provided functions
+to updated the augmented information on affected subtrees.
+
+In both cases, the callbacks are provided through struct rb_augment_callbacks.
+3 callbacks must be defined:
+
+- A propagation callback, which updates the augmented value for a given
+  node and its ancestors, up to a given stop point (or NULL to update
+  all the way to the root).
+
+- A copy callback, which copies the augmented value for a given subtree
+  to a newly assigned subtree root.
+
+- A tree rotation callback, which copies the augmented value for a given
+  subtree to a newly assigned subtree root AND recomputes the augmented
+  information for the former subtree root.
 
 
+Sample usage:
+
 Interval tree is an example of augmented rb tree. Reference -
 "Introduction to Algorithms" by Cormen, Leiserson, Rivest and Stein.
 More details about interval trees:
@@ -230,26 +248,132 @@ and its immediate children. And this wil
 for lowest match (lowest start address among all possible matches)
 with something like:
 
-find_lowest_match(lo, hi, node)
+struct interval_tree_node *
+interval_tree_first_match(struct rb_root *root,
+			  unsigned long start, unsigned long last)
 {
-	lowest_match = NULL;
-	while (node) {
-		if (max_hi(node->left) > lo) {
-			// Lowest overlap if any must be on left side
-			node = node->left;
-		} else if (overlap(lo, hi, node)) {
-			lowest_match = node;
-			break;
-		} else if (lo > node->lo) {
-			// Lowest overlap if any must be on right side
-			node = node->right;
-		} else {
-			break;
+	struct interval_tree_node *node;
+
+	if (!root->rb_node)
+		return NULL;
+	node = rb_entry(root->rb_node, struct interval_tree_node, rb);
+
+	while (true) {
+		if (node->rb.rb_left) {
+			struct interval_tree_node *left =
+				rb_entry(node->rb.rb_left,
+					 struct interval_tree_node, rb);
+			if (left->__subtree_last >= start) {
+				/*
+				 * Some nodes in left subtree satisfy Cond2.
+				 * Iterate to find the leftmost such node N.
+				 * If it also satisfies Cond1, that's the match
+				 * we are looking for. Otherwise, there is no
+				 * matching interval as nodes to the right of N
+				 * can't satisfy Cond1 either.
+				 */
+				node = left;
+				continue;
+			}
 		}
+		if (node->start <= last) {		/* Cond1 */
+			if (node->last >= start)	/* Cond2 */
+				return node;	/* node is leftmost match */
+			if (node->rb.rb_right) {
+				node = rb_entry(node->rb.rb_right,
+					struct interval_tree_node, rb);
+				if (node->__subtree_last >= start)
+					continue;
+			}
+		}
+		return NULL;	/* No match */
+	}
+}
+
+Insertion/removal are defined using the following augmented callbacks:
+
+static inline unsigned long
+compute_subtree_last(struct interval_tree_node *node)
+{
+	unsigned long max = node->last, subtree_last;
+	if (node->rb.rb_left) {
+		subtree_last = rb_entry(node->rb.rb_left,
+			struct interval_tree_node, rb)->__subtree_last;
+		if (max < subtree_last)
+			max = subtree_last;
+	}
+	if (node->rb.rb_right) {
+		subtree_last = rb_entry(node->rb.rb_right,
+			struct interval_tree_node, rb)->__subtree_last;
+		if (max < subtree_last)
+			max = subtree_last;
+	}
+	return max;
+}
+
+static void augment_propagate(struct rb_node *rb, struct rb_node *stop)
+{
+	while (rb != stop) {
+		struct interval_tree_node *node =
+			rb_entry(rb, struct interval_tree_node, rb);
+		unsigned long subtree_last = compute_subtree_last(node);
+		if (node->__subtree_last == subtree_last)
+			break;
+		node->__subtree_last = subtree_last;
+		rb = rb_parent(&node->rb);
 	}
-	return lowest_match;
 }
 
-Finding exact match will be to first find lowest match and then to follow
-successor nodes looking for exact match, until the start of a node is beyond
-the hi value we are looking for.
+static void augment_copy(struct rb_node *rb_old, struct rb_node *rb_new)
+{
+	struct interval_tree_node *old =
+		rb_entry(rb_old, struct interval_tree_node, rb);
+	struct interval_tree_node *new =
+		rb_entry(rb_new, struct interval_tree_node, rb);
+
+	new->__subtree_last = old->__subtree_last;
+}
+
+static void augment_rotate(struct rb_node *rb_old, struct rb_node *rb_new)
+{
+	struct interval_tree_node *old =
+		rb_entry(rb_old, struct interval_tree_node, rb);
+	struct interval_tree_node *new =
+		rb_entry(rb_new, struct interval_tree_node, rb);
+
+	new->__subtree_last = old->__subtree_last;
+	old->__subtree_last = compute_subtree_last(old);
+}
+
+static const struct rb_augment_callbacks augment_callbacks = {
+	augment_propagate, augment_copy, augment_rotate
+};
+
+void interval_tree_insert(struct interval_tree_node *node,
+			  struct rb_root *root)
+{
+	struct rb_node **link = &root->rb_node, *rb_parent = NULL;
+	unsigned long start = node->start, last = node->last;
+	struct interval_tree_node *parent;
+
+	while (*link) {
+		rb_parent = *link;
+		parent = rb_entry(rb_parent, struct interval_tree_node, rb);
+		if (parent->__subtree_last < last)
+			parent->__subtree_last = last;
+		if (start < parent->start)
+			link = &parent->rb.rb_left;
+		else
+			link = &parent->rb.rb_right;
+	}
+
+	node->__subtree_last = last;
+	rb_link_node(&node->rb, rb_parent, link);
+	rb_insert_augmented(&node->rb, root, &augment_callbacks);
+}
+
+void interval_tree_remove(struct interval_tree_node *node,
+			  struct rb_root *root)
+{
+	rb_erase_augmented(&node->rb, root, &augment_callbacks);
+}
diff -puN include/linux/rbtree.h~rbtree-faster-augmented-rbtree-manipulation include/linux/rbtree.h
--- a/include/linux/rbtree.h~rbtree-faster-augmented-rbtree-manipulation
+++ a/include/linux/rbtree.h
@@ -61,6 +61,25 @@ struct rb_root {
 extern void rb_insert_color(struct rb_node *, struct rb_root *);
 extern void rb_erase(struct rb_node *, struct rb_root *);
 
+
+struct rb_augment_callbacks {
+	void (*propagate)(struct rb_node *node, struct rb_node *stop);
+	void (*copy)(struct rb_node *old, struct rb_node *new);
+	void (*rotate)(struct rb_node *old, struct rb_node *new);
+};
+
+extern void __rb_insert_augmented(struct rb_node *node, struct rb_root *root,
+	void (*augment_rotate)(struct rb_node *old, struct rb_node *new));
+extern void rb_erase_augmented(struct rb_node *node, struct rb_root *root,
+			       const struct rb_augment_callbacks *augment);
+static inline void
+rb_insert_augmented(struct rb_node *node, struct rb_root *root,
+		    const struct rb_augment_callbacks *augment)
+{
+	__rb_insert_augmented(node, root, augment->rotate);
+}
+
+
 typedef void (*rb_augment_f)(struct rb_node *node, void *data);
 
 extern void rb_augment_insert(struct rb_node *node,
diff -puN lib/rbtree.c~rbtree-faster-augmented-rbtree-manipulation lib/rbtree.c
--- a/lib/rbtree.c~rbtree-faster-augmented-rbtree-manipulation
+++ a/lib/rbtree.c
@@ -105,7 +105,9 @@ __rb_rotate_set_parents(struct rb_node *
 	__rb_change_child(old, new, parent, root);
 }
 
-void rb_insert_color(struct rb_node *node, struct rb_root *root)
+static __always_inline void
+__rb_insert(struct rb_node *node, struct rb_root *root,
+	    void (*augment_rotate)(struct rb_node *old, struct rb_node *new))
 {
 	struct rb_node *parent = rb_red_parent(node), *gparent, *tmp;
 
@@ -169,6 +171,7 @@ void rb_insert_color(struct rb_node *nod
 					rb_set_parent_color(tmp, parent,
 							    RB_BLACK);
 				rb_set_parent_color(parent, node, RB_RED);
+				augment_rotate(parent, node);
 				parent = node;
 				tmp = node->rb_right;
 			}
@@ -187,6 +190,7 @@ void rb_insert_color(struct rb_node *nod
 			if (tmp)
 				rb_set_parent_color(tmp, gparent, RB_BLACK);
 			__rb_rotate_set_parents(gparent, parent, root, RB_RED);
+			augment_rotate(gparent, parent);
 			break;
 		} else {
 			tmp = gparent->rb_left;
@@ -209,6 +213,7 @@ void rb_insert_color(struct rb_node *nod
 					rb_set_parent_color(tmp, parent,
 							    RB_BLACK);
 				rb_set_parent_color(parent, node, RB_RED);
+				augment_rotate(parent, node);
 				parent = node;
 				tmp = node->rb_left;
 			}
@@ -219,13 +224,15 @@ void rb_insert_color(struct rb_node *nod
 			if (tmp)
 				rb_set_parent_color(tmp, gparent, RB_BLACK);
 			__rb_rotate_set_parents(gparent, parent, root, RB_RED);
+			augment_rotate(gparent, parent);
 			break;
 		}
 	}
 }
-EXPORT_SYMBOL(rb_insert_color);
 
-static void __rb_erase_color(struct rb_node *parent, struct rb_root *root)
+static __always_inline void
+__rb_erase_color(struct rb_node *parent, struct rb_root *root,
+		 const struct rb_augment_callbacks *augment)
 {
 	struct rb_node *node = NULL, *sibling, *tmp1, *tmp2;
 
@@ -254,6 +261,7 @@ static void __rb_erase_color(struct rb_n
 				rb_set_parent_color(tmp1, parent, RB_BLACK);
 				__rb_rotate_set_parents(parent, sibling, root,
 							RB_RED);
+				augment->rotate(parent, sibling);
 				sibling = tmp1;
 			}
 			tmp1 = sibling->rb_right;
@@ -305,6 +313,7 @@ static void __rb_erase_color(struct rb_n
 				if (tmp1)
 					rb_set_parent_color(tmp1, sibling,
 							    RB_BLACK);
+				augment->rotate(sibling, tmp2);
 				tmp1 = sibling;
 				sibling = tmp2;
 			}
@@ -327,6 +336,7 @@ static void __rb_erase_color(struct rb_n
 				rb_set_parent(tmp2, parent);
 			__rb_rotate_set_parents(parent, sibling, root,
 						RB_BLACK);
+			augment->rotate(parent, sibling);
 			break;
 		} else {
 			sibling = parent->rb_left;
@@ -337,6 +347,7 @@ static void __rb_erase_color(struct rb_n
 				rb_set_parent_color(tmp1, parent, RB_BLACK);
 				__rb_rotate_set_parents(parent, sibling, root,
 							RB_RED);
+				augment->rotate(parent, sibling);
 				sibling = tmp1;
 			}
 			tmp1 = sibling->rb_left;
@@ -363,6 +374,7 @@ static void __rb_erase_color(struct rb_n
 				if (tmp1)
 					rb_set_parent_color(tmp1, sibling,
 							    RB_BLACK);
+				augment->rotate(sibling, tmp2);
 				tmp1 = sibling;
 				sibling = tmp2;
 			}
@@ -374,12 +386,15 @@ static void __rb_erase_color(struct rb_n
 				rb_set_parent(tmp2, parent);
 			__rb_rotate_set_parents(parent, sibling, root,
 						RB_BLACK);
+			augment->rotate(parent, sibling);
 			break;
 		}
 	}
 }
 
-void rb_erase(struct rb_node *node, struct rb_root *root)
+static __always_inline void
+__rb_erase(struct rb_node *node, struct rb_root *root,
+	   const struct rb_augment_callbacks *augment)
 {
 	struct rb_node *child = node->rb_right, *tmp = node->rb_left;
 	struct rb_node *parent, *rebalance;
@@ -401,12 +416,14 @@ void rb_erase(struct rb_node *node, stru
 			rebalance = NULL;
 		} else
 			rebalance = __rb_is_black(pc) ? parent : NULL;
+		tmp = parent;
 	} else if (!child) {
 		/* Still case 1, but this time the child is node->rb_left */
 		tmp->__rb_parent_color = pc = node->__rb_parent_color;
 		parent = __rb_parent(pc);
 		__rb_change_child(node, tmp, parent, root);
 		rebalance = NULL;
+		tmp = parent;
 	} else {
 		struct rb_node *successor = child, *child2;
 		tmp = child->rb_left;
@@ -420,8 +437,9 @@ void rb_erase(struct rb_node *node, stru
 			 *        \
 			 *        (c)
 			 */
-			parent = child;
-			child2 = child->rb_right;
+			parent = successor;
+			child2 = successor->rb_right;
+			augment->copy(node, successor);
 		} else {
 			/*
 			 * Case 3: node's successor is leftmost under
@@ -445,6 +463,8 @@ void rb_erase(struct rb_node *node, stru
 			parent->rb_left = child2 = successor->rb_right;
 			successor->rb_right = child;
 			rb_set_parent(child, successor);
+			augment->copy(node, successor);
+			augment->propagate(parent, successor);
 		}
 
 		successor->rb_left = tmp = node->rb_left;
@@ -462,13 +482,62 @@ void rb_erase(struct rb_node *node, stru
 			successor->__rb_parent_color = pc;
 			rebalance = __rb_is_black(pc2) ? parent : NULL;
 		}
+		tmp = successor;
 	}
 
+	augment->propagate(tmp, NULL);
 	if (rebalance)
-		__rb_erase_color(rebalance, root);
+		__rb_erase_color(rebalance, root, augment);
+}
+
+/*
+ * Non-augmented rbtree manipulation functions.
+ *
+ * We use dummy augmented callbacks here, and have the compiler optimize them
+ * out of the rb_insert_color() and rb_erase() function definitions.
+ */
+
+static inline void dummy_propagate(struct rb_node *node, struct rb_node *stop) {}
+static inline void dummy_copy(struct rb_node *old, struct rb_node *new) {}
+static inline void dummy_rotate(struct rb_node *old, struct rb_node *new) {}
+
+static const struct rb_augment_callbacks dummy_callbacks = {
+	dummy_propagate, dummy_copy, dummy_rotate
+};
+
+void rb_insert_color(struct rb_node *node, struct rb_root *root)
+{
+	__rb_insert(node, root, dummy_rotate);
+}
+EXPORT_SYMBOL(rb_insert_color);
+
+void rb_erase(struct rb_node *node, struct rb_root *root)
+{
+	__rb_erase(node, root, &dummy_callbacks);
 }
 EXPORT_SYMBOL(rb_erase);
 
+/*
+ * Augmented rbtree manipulation functions.
+ *
+ * This instantiates the same __always_inline functions as in the non-augmented
+ * case, but this time with user-defined callbacks.
+ */
+
+void __rb_insert_augmented(struct rb_node *node, struct rb_root *root,
+	void (*augment_rotate)(struct rb_node *old, struct rb_node *new))
+{
+	__rb_insert(node, root, augment_rotate);
+}
+EXPORT_SYMBOL(__rb_insert_augmented);
+
+void rb_erase_augmented(struct rb_node *node, struct rb_root *root,
+			const struct rb_augment_callbacks *augment)
+{
+	__rb_erase(node, root, augment);
+}
+EXPORT_SYMBOL(rb_erase_augmented);
+
 static void rb_augment_path(struct rb_node *node, rb_augment_f func, void *data)
 {
 	struct rb_node *parent;
diff -puN lib/rbtree_test.c~rbtree-faster-augmented-rbtree-manipulation lib/rbtree_test.c
--- a/lib/rbtree_test.c~rbtree-faster-augmented-rbtree-manipulation
+++ a/lib/rbtree_test.c
@@ -61,35 +61,65 @@ static inline u32 augment_recompute(stru
 	return max;
 }
 
-static void augment_callback(struct rb_node *rb, void *unused)
+static void augment_propagate(struct rb_node *rb, struct rb_node *stop)
 {
-	struct test_node *node = rb_entry(rb, struct test_node, rb);
-	node->augmented = augment_recompute(node);
+	while (rb != stop) {
+		struct test_node *node = rb_entry(rb, struct test_node, rb);
+		u32 augmented = augment_recompute(node);
+		if (node->augmented == augmented)
+			break;
+		node->augmented = augmented;
+		rb = rb_parent(&node->rb);
+	}
+}
+
+static void augment_copy(struct rb_node *rb_old, struct rb_node *rb_new)
+{
+	struct test_node *old = rb_entry(rb_old, struct test_node, rb);
+	struct test_node *new = rb_entry(rb_new, struct test_node, rb);
+	new->augmented = old->augmented;
 }
 
+static void augment_rotate(struct rb_node *rb_old, struct rb_node *rb_new)
+{
+	struct test_node *old = rb_entry(rb_old, struct test_node, rb);
+	struct test_node *new = rb_entry(rb_new, struct test_node, rb);
+
+	/* Rotation doesn't change subtree's augmented value */
+	new->augmented = old->augmented;
+	old->augmented = augment_recompute(old);
+}
+
+static const struct rb_augment_callbacks augment_callbacks = {
+	augment_propagate, augment_copy, augment_rotate
+};
+
 static void insert_augmented(struct test_node *node, struct rb_root *root)
 {
-	struct rb_node **new = &root->rb_node, *parent = NULL;
+	struct rb_node **new = &root->rb_node, *rb_parent = NULL;
 	u32 key = node->key;
+	u32 val = node->val;
+	struct test_node *parent;
 
 	while (*new) {
-		parent = *new;
-		if (key < rb_entry(parent, struct test_node, rb)->key)
-			new = &parent->rb_left;
+		rb_parent = *new;
+		parent = rb_entry(rb_parent, struct test_node, rb);
+		if (parent->augmented < val)
+			parent->augmented = val;
+		if (key < parent->key)
+			new = &parent->rb.rb_left;
 		else
-			new = &parent->rb_right;
+			new = &parent->rb.rb_right;
 	}
 
-	rb_link_node(&node->rb, parent, new);
-	rb_insert_color(&node->rb, root);
-	rb_augment_insert(&node->rb, augment_callback, NULL);
+	node->augmented = val;
+	rb_link_node(&node->rb, rb_parent, new);
+	rb_insert_augmented(&node->rb, root, &augment_callbacks);
 }
 
 static void erase_augmented(struct test_node *node, struct rb_root *root)
 {
-	struct rb_node *deepest = rb_augment_erase_begin(&node->rb);
-	rb_erase(&node->rb, root);
-	rb_augment_erase_end(deepest, augment_callback, NULL);
+	rb_erase_augmented(&node->rb, root, &augment_callbacks);
 }
 
 static void init(void)
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
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
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix-perf-compilation.patch
rbtree-low-level-optimizations-in-rb_insert_color.patch
rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch
rbtree-optimize-case-selection-logic-in-__rb_erase_color.patch
rbtree-low-level-optimizations-in-__rb_erase_color.patch
rbtree-coding-style-adjustments.patch
rbtree-optimize-fetching-of-sibling-node.patch
rbtree-test-fix-sparse-warning-about-64-bit-constant.patch
rbtree-add-__rb_change_child-helper-function.patch
rbtree-place-easiest-case-first-in-rb_erase.patch
rbtree-handle-1-child-recoloring-in-rb_erase-instead-of-rb_erase_color.patch
rbtree-low-level-optimizations-in-rb_erase.patch
rbtree-augmented-rbtree-test.patch
rbtree-faster-augmented-rbtree-manipulation.patch
rbtree-remove-prior-augmented-rbtree-implementation.patch
rbtree-add-rb_declare_callbacks-macro.patch

