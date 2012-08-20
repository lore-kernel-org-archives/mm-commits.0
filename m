From: akpm@linux-foundation.org
Subject: + rbtree-low-level-optimizations-in-rb_erase.patch added to -mm tree
Date: Mon, 20 Aug 2012 15:37:01 -0700
Message-ID: <20120820223702.60C6A1E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:42800 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583Ab2HTWhD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 18:37:03 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4115762obb.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 15:37:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com


The patch titled
     Subject: rbtree: low level optimizations in rb_erase()
has been added to the -mm tree.  Its filename is
     rbtree-low-level-optimizations-in-rb_erase.patch

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
Subject: rbtree: low level optimizations in rb_erase()

Various minor optimizations in rb_erase():
- Avoid multiple loading of node->__rb_parent_color when computing parent
  and color information (possibly not in close sequence, as there might
  be further branches in the algorithm)
- In the 1-child subcase of case 1, copy the __rb_parent_color field from
  the erased node to the child instead of recomputing it from the desired
  parent and color
- When searching for the erased node's successor, differentiate between
  cases 2 and 3 based on whether any left links were followed. This avoids
  a condition later down.
- In case 3, keep a pointer to the erased node's right child so we don't
  have to refetch it later to adjust its parent.
- In the no-childs subcase of cases 2 and 3, place the rebalance assigment
  last so that the compiler can remove the following if(rebalance) test.

Also, added some comments to illustrate cases 2 and 3.

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree.c |   98 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 64 insertions(+), 34 deletions(-)

diff -puN lib/rbtree.c~rbtree-low-level-optimizations-in-rb_erase lib/rbtree.c
--- a/lib/rbtree.c~rbtree-low-level-optimizations-in-rb_erase
+++ a/lib/rbtree.c
@@ -47,9 +47,14 @@
 #define	RB_RED		0
 #define	RB_BLACK	1
 
-#define rb_color(r)   ((r)->__rb_parent_color & 1)
-#define rb_is_red(r)   (!rb_color(r))
-#define rb_is_black(r) rb_color(r)
+#define __rb_parent(pc)    ((struct rb_node *)(pc & ~3))
+
+#define __rb_color(pc)     ((pc) & 1)
+#define __rb_is_black(pc)  __rb_color(pc)
+#define __rb_is_red(pc)    (!__rb_color(pc))
+#define rb_color(rb)       __rb_color((rb)->__rb_parent_color)
+#define rb_is_red(rb)      __rb_is_red((rb)->__rb_parent_color)
+#define rb_is_black(rb)    __rb_is_black((rb)->__rb_parent_color)
 
 static inline void rb_set_black(struct rb_node *rb)
 {
@@ -378,6 +383,7 @@ void rb_erase(struct rb_node *node, stru
 {
 	struct rb_node *child = node->rb_right, *tmp = node->rb_left;
 	struct rb_node *parent, *rebalance;
+	unsigned long pc;
 
 	if (!tmp) {
 		/*
@@ -387,51 +393,75 @@ void rb_erase(struct rb_node *node, stru
 		 * and node must be black due to 4). We adjust colors locally
 		 * so as to bypass __rb_erase_color() later on.
 		 */
-
-		parent = rb_parent(node);
+		pc = node->__rb_parent_color;
+		parent = __rb_parent(pc);
 		__rb_change_child(node, child, parent, root);
 		if (child) {
-			rb_set_parent_color(child, parent, RB_BLACK);
+			child->__rb_parent_color = pc;
 			rebalance = NULL;
-		} else {
-			rebalance = rb_is_black(node) ? parent : NULL;
-		}
+		} else
+			rebalance = __rb_is_black(pc) ? parent : NULL;
 	} else if (!child) {
 		/* Still case 1, but this time the child is node->rb_left */
-		parent = rb_parent(node);
+		tmp->__rb_parent_color = pc = node->__rb_parent_color;
+		parent = __rb_parent(pc);
 		__rb_change_child(node, tmp, parent, root);
-		rb_set_parent_color(tmp, parent, RB_BLACK);
 		rebalance = NULL;
 	} else {
-		struct rb_node *old = node, *left;
-
-		node = child;
-		while ((left = node->rb_left) != NULL)
-			node = left;
-
-		__rb_change_child(old, node, rb_parent(old), root);
-
-		child = node->rb_right;
-		parent = rb_parent(node);
-
-		if (parent == old) {
-			parent = node;
+		struct rb_node *successor = child, *child2;
+		tmp = child->rb_left;
+		if (!tmp) {
+			/*
+			 * Case 2: node's successor is its right child
+			 *
+			 *    (n)          (s)
+			 *    / \          / \
+			 *  (x) (s)  ->  (x) (c)
+			 *        \
+			 *        (c)
+			 */
+			parent = child;
+			child2 = child->rb_right;
 		} else {
-			parent->rb_left = child;
-
-			node->rb_right = old->rb_right;
-			rb_set_parent(old->rb_right, node);
+			/*
+			 * Case 3: node's successor is leftmost under
+			 * node's right child subtree
+			 *
+			 *    (n)          (s)
+			 *    / \          / \
+			 *  (x) (y)  ->  (x) (y)
+			 *      /            /
+			 *    (p)          (p)
+			 *    /            /
+			 *  (s)          (c)
+			 *    \
+			 *    (c)
+			 */
+			do {
+				parent = successor;
+				successor = tmp;
+				tmp = tmp->rb_left;
+			} while (tmp);
+			parent->rb_left = child2 = successor->rb_right;
+			successor->rb_right = child;
+			rb_set_parent(child, successor);
 		}
 
-		if (child) {
-			rb_set_parent_color(child, parent, RB_BLACK);
+		successor->rb_left = tmp = node->rb_left;
+		rb_set_parent(tmp, successor);
+
+		pc = node->__rb_parent_color;
+		tmp = __rb_parent(pc);
+		__rb_change_child(node, successor, tmp, root);
+		if (child2) {
+			successor->__rb_parent_color = pc;
+			rb_set_parent_color(child2, parent, RB_BLACK);
 			rebalance = NULL;
 		} else {
-			rebalance = rb_is_black(node) ? parent : NULL;
+			unsigned long pc2 = successor->__rb_parent_color;
+			successor->__rb_parent_color = pc;
+			rebalance = __rb_is_black(pc2) ? parent : NULL;
 		}
-		node->__rb_parent_color = old->__rb_parent_color;
-		node->rb_left = old->rb_left;
-		rb_set_parent(old->rb_left, node);
 	}
 
 	if (rebalance)
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

