From: akpm@linux-foundation.org
Subject: + rbtree-remove-prior-augmented-rbtree-implementation.patch added to -mm tree
Date: Mon, 20 Aug 2012 15:37:10 -0700
Message-ID: <20120820223711.55A73100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-iy0-f202.google.com ([209.85.210.202]:57383 "EHLO
	mail-iy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583Ab2HTWhM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 18:37:12 -0400
Received: by mail-iy0-f202.google.com with SMTP id o24so946511ial.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 15:37:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com


The patch titled
     Subject: rbtree: remove prior augmented rbtree implementation
has been added to the -mm tree.  Its filename is
     rbtree-remove-prior-augmented-rbtree-implementation.patch

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
Subject: rbtree: remove prior augmented rbtree implementation

convert arch/x86/mm/pat_rbtree.c to the proposed augmented rbtree api
and remove the old augmented rbtree implementation.

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat_rbtree.c |   65 +++++++++++++++++++++++----------
 include/linux/rbtree.h   |    8 ----
 lib/rbtree.c             |   71 -------------------------------------
 3 files changed, 46 insertions(+), 98 deletions(-)

diff -puN arch/x86/mm/pat_rbtree.c~rbtree-remove-prior-augmented-rbtree-implementation arch/x86/mm/pat_rbtree.c
--- a/arch/x86/mm/pat_rbtree.c~rbtree-remove-prior-augmented-rbtree-implementation
+++ a/arch/x86/mm/pat_rbtree.c
@@ -54,29 +54,57 @@ static u64 get_subtree_max_end(struct rb
 	return ret;
 }
 
-/* Update 'subtree_max_end' for a node, based on node and its children */
-static void memtype_rb_augment_cb(struct rb_node *node, void *__unused)
+static u64 compute_subtree_max_end(struct memtype *data)
 {
-	struct memtype *data;
-	u64 max_end, child_max_end;
-
-	if (!node)
-		return;
-
-	data = container_of(node, struct memtype, rb);
-	max_end = data->end;
+	u64 max_end = data->end, child_max_end;
 
-	child_max_end = get_subtree_max_end(node->rb_right);
+	child_max_end = get_subtree_max_end(data->rb.rb_right);
 	if (child_max_end > max_end)
 		max_end = child_max_end;
 
-	child_max_end = get_subtree_max_end(node->rb_left);
+	child_max_end = get_subtree_max_end(data->rb.rb_left);
 	if (child_max_end > max_end)
 		max_end = child_max_end;
 
-	data->subtree_max_end = max_end;
+	return max_end;
+}
+
+/* Update 'subtree_max_end' for node and its parents */
+static void memtype_rb_propagate_cb(struct rb_node *node, struct rb_node *stop)
+{
+	while (node != stop) {
+		struct memtype *data = container_of(node, struct memtype, rb);
+		u64 subtree_max_end = compute_subtree_max_end(data);
+		if (data->subtree_max_end == subtree_max_end)
+			break;
+		data->subtree_max_end = subtree_max_end;
+		node = rb_parent(&data->rb);
+	}
+}
+
+static void memtype_rb_copy_cb(struct rb_node *old, struct rb_node *new)
+{
+	struct memtype *old_data = container_of(old, struct memtype, rb);
+	struct memtype *new_data = container_of(new, struct memtype, rb);
+
+	new_data->subtree_max_end = old_data->subtree_max_end;
 }
 
+/* Update 'subtree_max_end' after tree rotation. old and new are the
+ * former and current subtree roots */
+static void memtype_rb_rotate_cb(struct rb_node *old, struct rb_node *new)
+{
+	struct memtype *old_data = container_of(old, struct memtype, rb);
+	struct memtype *new_data = container_of(new, struct memtype, rb);
+
+	new_data->subtree_max_end = old_data->subtree_max_end;
+	old_data->subtree_max_end = compute_subtree_max_end(old_data);
+}
+
+static const struct rb_augment_callbacks memtype_rb_augment_cb = {
+	memtype_rb_propagate_cb, memtype_rb_copy_cb, memtype_rb_rotate_cb
+};
+
 /* Find the first (lowest start addr) overlapping range from rb tree */
 static struct memtype *memtype_rb_lowest_match(struct rb_root *root,
 				u64 start, u64 end)
@@ -179,15 +207,17 @@ static void memtype_rb_insert(struct rb_
 		struct memtype *data = container_of(*node, struct memtype, rb);
 
 		parent = *node;
+		if (data->subtree_max_end < newdata->end)
+			data->subtree_max_end = newdata->end;
 		if (newdata->start <= data->start)
 			node = &((*node)->rb_left);
 		else if (newdata->start > data->start)
 			node = &((*node)->rb_right);
 	}
 
+	newdata->subtree_max_end = newdata->end;
 	rb_link_node(&newdata->rb, parent, node);
-	rb_insert_color(&newdata->rb, root);
-	rb_augment_insert(&newdata->rb, memtype_rb_augment_cb, NULL);
+	rb_insert_augmented(&newdata->rb, root, &memtype_rb_augment_cb);
 }
 
 int rbt_memtype_check_insert(struct memtype *new, unsigned long *ret_type)
@@ -209,16 +239,13 @@ int rbt_memtype_check_insert(struct memt
 
 struct memtype *rbt_memtype_erase(u64 start, u64 end)
 {
-	struct rb_node *deepest;
 	struct memtype *data;
 
 	data = memtype_rb_exact_match(&memtype_rbroot, start, end);
 	if (!data)
 		goto out;
 
-	deepest = rb_augment_erase_begin(&data->rb);
-	rb_erase(&data->rb, &memtype_rbroot);
-	rb_augment_erase_end(deepest, memtype_rb_augment_cb, NULL);
+	rb_erase_augmented(&data->rb, &memtype_rbroot, &memtype_rb_augment_cb);
 out:
 	return data;
 }
diff -puN include/linux/rbtree.h~rbtree-remove-prior-augmented-rbtree-implementation include/linux/rbtree.h
--- a/include/linux/rbtree.h~rbtree-remove-prior-augmented-rbtree-implementation
+++ a/include/linux/rbtree.h
@@ -80,14 +80,6 @@ rb_insert_augmented(struct rb_node *node
 }
 
 
-typedef void (*rb_augment_f)(struct rb_node *node, void *data);
-
-extern void rb_augment_insert(struct rb_node *node,
-			      rb_augment_f func, void *data);
-extern struct rb_node *rb_augment_erase_begin(struct rb_node *node);
-extern void rb_augment_erase_end(struct rb_node *node,
-				 rb_augment_f func, void *data);
-
 /* Find logical next and previous nodes in a tree */
 extern struct rb_node *rb_next(const struct rb_node *);
 extern struct rb_node *rb_prev(const struct rb_node *);
diff -puN lib/rbtree.c~rbtree-remove-prior-augmented-rbtree-implementation lib/rbtree.c
--- a/lib/rbtree.c~rbtree-remove-prior-augmented-rbtree-implementation
+++ a/lib/rbtree.c
@@ -538,77 +538,6 @@ void rb_erase_augmented(struct rb_node *
 }
 EXPORT_SYMBOL(rb_erase_augmented);
 
-static void rb_augment_path(struct rb_node *node, rb_augment_f func, void *data)
-{
-	struct rb_node *parent;
-
-up:
-	func(node, data);
-	parent = rb_parent(node);
-	if (!parent)
-		return;
-
-	if (node == parent->rb_left && parent->rb_right)
-		func(parent->rb_right, data);
-	else if (parent->rb_left)
-		func(parent->rb_left, data);
-
-	node = parent;
-	goto up;
-}
-
-/*
- * after inserting @node into the tree, update the tree to account for
- * both the new entry and any damage done by rebalance
- */
-void rb_augment_insert(struct rb_node *node, rb_augment_f func, void *data)
-{
-	if (node->rb_left)
-		node = node->rb_left;
-	else if (node->rb_right)
-		node = node->rb_right;
-
-	rb_augment_path(node, func, data);
-}
-EXPORT_SYMBOL(rb_augment_insert);
-
-/*
- * before removing the node, find the deepest node on the rebalance path
- * that will still be there after @node gets removed
- */
-struct rb_node *rb_augment_erase_begin(struct rb_node *node)
-{
-	struct rb_node *deepest;
-
-	if (!node->rb_right && !node->rb_left)
-		deepest = rb_parent(node);
-	else if (!node->rb_right)
-		deepest = node->rb_left;
-	else if (!node->rb_left)
-		deepest = node->rb_right;
-	else {
-		deepest = rb_next(node);
-		if (deepest->rb_right)
-			deepest = deepest->rb_right;
-		else if (rb_parent(deepest) != node)
-			deepest = rb_parent(deepest);
-	}
-
-	return deepest;
-}
-EXPORT_SYMBOL(rb_augment_erase_begin);
-
-/*
- * after removal, update the tree to account for the removed entry
- * and any rebalance damage.
- */
-void rb_augment_erase_end(struct rb_node *node, rb_augment_f func, void *data)
-{
-	if (node)
-		rb_augment_path(node, func, data);
-}
-EXPORT_SYMBOL(rb_augment_erase_end);
-
 /*
  * This function returns the first node (in sort order) of the tree.
  */
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

