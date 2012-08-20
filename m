From: akpm@linux-foundation.org
Subject: + rbtree-add-__rb_change_child-helper-function.patch added to -mm tree
Date: Mon, 20 Aug 2012 15:36:50 -0700
Message-ID: <20120820223651.9E84F5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:61406 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583Ab2HTWgz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 18:36:55 -0400
Received: by bkcjc3 with SMTP id jc3so315637bkc.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 15:36:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com


The patch titled
     Subject: rbtree: add __rb_change_child() helper function
has been added to the -mm tree.  Its filename is
     rbtree-add-__rb_change_child-helper-function.patch

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
Subject: rbtree: add __rb_change_child() helper function

Add __rb_change_child() as an inline helper function to replace code that
would otherwise be duplicated 4 times in the source.

No changes to binary size or speed.

Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree.c |   46 +++++++++++++++++-----------------------------
 1 file changed, 17 insertions(+), 29 deletions(-)

diff -puN lib/rbtree.c~rbtree-add-__rb_change_child-helper-function lib/rbtree.c
--- a/lib/rbtree.c~rbtree-add-__rb_change_child-helper-function
+++ a/lib/rbtree.c
@@ -66,6 +66,19 @@ static inline struct rb_node *rb_red_par
 	return (struct rb_node *)red->__rb_parent_color;
 }
 
+static inline void
+__rb_change_child(struct rb_node *old, struct rb_node *new,
+		  struct rb_node *parent, struct rb_root *root)
+{
+	if (parent) {
+		if (parent->rb_left == old)
+			parent->rb_left = new;
+		else
+			parent->rb_right = new;
+	} else
+		root->rb_node = new;
+}
+
 /*
  * Helper function for rotations:
  * - old's parent and color get assigned to new
@@ -78,13 +91,7 @@ __rb_rotate_set_parents(struct rb_node *
 	struct rb_node *parent = rb_parent(old);
 	new->__rb_parent_color = old->__rb_parent_color;
 	rb_set_parent_color(old, new, color);
-	if (parent) {
-		if (parent->rb_left == old)
-			parent->rb_left = new;
-		else
-			parent->rb_right = new;
-	} else
-		root->rb_node = new;
+	__rb_change_child(old, new, parent, root);
 }
 
 void rb_insert_color(struct rb_node *node, struct rb_root *root)
@@ -375,13 +382,7 @@ void rb_erase(struct rb_node *node, stru
 		while ((left = node->rb_left) != NULL)
 			node = left;
 
-		if (rb_parent(old)) {
-			if (rb_parent(old)->rb_left == old)
-				rb_parent(old)->rb_left = node;
-			else
-				rb_parent(old)->rb_right = node;
-		} else
-			root->rb_node = node;
+		__rb_change_child(old, node, rb_parent(old), root);
 
 		child = node->rb_right;
 		parent = rb_parent(node);
@@ -410,13 +411,7 @@ void rb_erase(struct rb_node *node, stru
 
 	if (child)
 		rb_set_parent(child, parent);
-	if (parent) {
-		if (parent->rb_left == node)
-			parent->rb_left = child;
-		else
-			parent->rb_right = child;
-	} else
-		root->rb_node = child;
+	__rb_change_child(node, child, parent, root);
 
 color:
 	if (color == RB_BLACK)
@@ -591,14 +586,7 @@ void rb_replace_node(struct rb_node *vic
 	struct rb_node *parent = rb_parent(victim);
 
 	/* Set the surrounding nodes to point to the replacement */
-	if (parent) {
-		if (victim == parent->rb_left)
-			parent->rb_left = new;
-		else
-			parent->rb_right = new;
-	} else {
-		root->rb_node = new;
-	}
+	__rb_change_child(victim, new, parent, root);
 	if (victim->rb_left)
 		rb_set_parent(victim->rb_left, new);
 	if (victim->rb_right)
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

