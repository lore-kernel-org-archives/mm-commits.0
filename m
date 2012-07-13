From: akpm@linux-foundation.org
Subject: + rbtree-low-level-optimizations-in-rb_insert_color.patch added to -mm tree
Date: Fri, 13 Jul 2012 13:30:58 -0700
Message-ID: <20120713203059.BF80B20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:38140 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757037Ab2GMUbE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 16:31:04 -0400
Received: by lbbgp10 with SMTP id gp10so221139lbb.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 13:31:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, axboe@kernel.dk, daniel.santos@pobox.com, dwmw2@infradead.org, ebiederm@xmission.com, riel@redhat.com


The patch titled
     Subject: rbtree: low level optimizations in rb_insert_color()
has been added to the -mm tree.  Its filename is
     rbtree-low-level-optimizations-in-rb_insert_color.patch

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
Subject: rbtree: low level optimizations in rb_insert_color()

- Use the newly introduced rb_set_parent_color() function to flip the color
  of nodes whose parent is already known.
- Optimize rb_parent() when the node is known to be red - there is no need
  to mask out the color in that case.
- Flipping gparent's color to red requires us to fetch its rb_parent_color
  field, so we can reuse it as the parent value for the next loop iteration.
- Do not use __rb_rotate_left() and __rb_rotate_right() to handle tree
  rotations: we already have pointers to all relevant nodes, and know their
  colors (either because we want to adjust it, or because we've tested it,
  or we can deduce it as black due to the node proximity to a known red node).
  So we can generate more efficient code by making use of the node pointers
  we already have, and setting both the parent and color attributes for
  nodes all at once. Also in Case 2, some node attributes don't have to
  be set because we know another tree rotation (Case 3) will always follow
  and override them.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Daniel Santos <daniel.santos@pobox.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree.c |  164 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 130 insertions(+), 34 deletions(-)

diff -puN lib/rbtree.c~rbtree-low-level-optimizations-in-rb_insert_color lib/rbtree.c
--- a/lib/rbtree.c~rbtree-low-level-optimizations-in-rb_insert_color
+++ a/lib/rbtree.c
@@ -23,6 +23,25 @@
 #include <linux/rbtree.h>
 #include <linux/export.h>
 
+/*
+ * red-black trees properties:  http://en.wikipedia.org/wiki/Rbtree
+ *
+ *  1) A node is either red or black
+ *  2) The root is black
+ *  3) All leaves (NULL) are black
+ *  4) Both children of every red node are black
+ *  5) Every simple path from root to leaves contains the same number
+ *     of black nodes.
+ *
+ *  4 and 5 give the O(log n) guarantee, since 4 implies you cannot have two
+ *  consecutive red nodes in a path and every red node is therefore followed by
+ *  a black. So if B is the number of black nodes on every simple path (as per
+ *  5), then the longest possible path due to 4 is 2B.
+ *
+ *  We shall indicate color with case, where black nodes are uppercase and red
+ *  nodes will be lowercase.
+ */
+
 #define	RB_RED		0
 #define	RB_BLACK	1
 
@@ -41,6 +60,17 @@ static inline void rb_set_color(struct r
 	rb->__rb_parent_color = (rb->__rb_parent_color & ~1) | color;
 }
 
+static inline void rb_set_parent_color(struct rb_node *rb,
+				       struct rb_node *p, int color)
+{
+	rb->__rb_parent_color = (unsigned long)p | color;
+}
+
+static inline struct rb_node *rb_red_parent(struct rb_node *red)
+{
+	return (struct rb_node *)red->__rb_parent_color;
+}
+
 static void __rb_rotate_left(struct rb_node *node, struct rb_root *root)
 {
 	struct rb_node *right = node->rb_right;
@@ -87,9 +117,30 @@ static void __rb_rotate_right(struct rb_
 	rb_set_parent(node, left);
 }
 
+/*
+ * Helper function for rotations:
+ * - old's parent and color get assigned to new
+ * - old gets assigned new as a parent and 'color' as a color.
+ */
+static inline void
+__rb_rotate_set_parents(struct rb_node *old, struct rb_node *new,
+			struct rb_root *root, int color)
+{
+	struct rb_node *parent = rb_parent(old);
+	new->__rb_parent_color = old->__rb_parent_color;
+	rb_set_parent_color(old, new, color);
+	if (parent) {
+		if (parent->rb_left == old)
+			parent->rb_left = new;
+		else
+			parent->rb_right = new;
+	} else
+		root->rb_node = new;
+}
+
 void rb_insert_color(struct rb_node *node, struct rb_root *root)
 {
-	struct rb_node *parent, *gparent;
+	struct rb_node *parent = rb_red_parent(node), *gparent, *tmp;
 
 	while (true) {
 		/*
@@ -99,59 +150,104 @@ void rb_insert_color(struct rb_node *nod
 		 * Otherwise, take some corrective action as we don't
 		 * want a red root or two consecutive red nodes.
 		 */
-		parent = rb_parent(node);
 		if (!parent) {
-			rb_set_black(node);
+			rb_set_parent_color(node, NULL, RB_BLACK);
 			break;
 		} else if (rb_is_black(parent))
 			break;
 
-		gparent = rb_parent(parent);
+		gparent = rb_red_parent(parent);
 
-		if (parent == gparent->rb_left)
-		{
-			{
-				register struct rb_node *uncle = gparent->rb_right;
-				if (uncle && rb_is_red(uncle))
-				{
-					rb_set_black(uncle);
-					rb_set_black(parent);
-					rb_set_red(gparent);
-					node = gparent;
-					continue;
-				}
+		if (parent == gparent->rb_left) {
+			tmp = gparent->rb_right;
+			if (tmp && rb_is_red(tmp)) {
+				/*
+				 * Case 1 - color flips
+				 *
+				 *       G            g
+				 *      / \          / \
+				 *     p   u  -->   P   U
+				 *    /            /
+				 *   n            N
+				 *
+				 * However, since g's parent might be red, and
+				 * 4) does not allow this, we need to recurse
+				 * at g.
+				 */
+				rb_set_parent_color(tmp, gparent, RB_BLACK);
+				rb_set_parent_color(parent, gparent, RB_BLACK);
+				node = gparent;
+				parent = rb_parent(node);
+				rb_set_parent_color(node, parent, RB_RED);
+				continue;
 			}
 
 			if (parent->rb_right == node) {
-				__rb_rotate_left(parent, root);
+				/*
+				 * Case 2 - left rotate at parent
+				 *
+				 *      G             G
+				 *     / \           / \
+				 *    p   U  -->    n   U
+				 *     \           /
+				 *      n         p
+				 *
+				 * This still leaves us in violation of 4), the
+				 * continuation into Case 3 will fix that.
+				 */
+				parent->rb_right = tmp = node->rb_left;
+				node->rb_left = parent;
+				if (tmp)
+					rb_set_parent_color(tmp, parent,
+							    RB_BLACK);
+				rb_set_parent_color(parent, node, RB_RED);
 				parent = node;
 			}
 
-			rb_set_black(parent);
-			rb_set_red(gparent);
-			__rb_rotate_right(gparent, root);
+			/*
+			 * Case 3 - right rotate at gparent
+			 *
+			 *        G           P
+			 *       / \         / \
+			 *      p   U  -->  n   g
+			 *     /                 \
+			 *    n                   U
+			 */
+			gparent->rb_left = tmp = parent->rb_right;
+			parent->rb_right = gparent;
+			if (tmp)
+				rb_set_parent_color(tmp, gparent, RB_BLACK);
+			__rb_rotate_set_parents(gparent, parent, root, RB_RED);
 			break;
 		} else {
-			{
-				register struct rb_node *uncle = gparent->rb_left;
-				if (uncle && rb_is_red(uncle))
-				{
-					rb_set_black(uncle);
-					rb_set_black(parent);
-					rb_set_red(gparent);
-					node = gparent;
-					continue;
-				}
+			tmp = gparent->rb_left;
+			if (tmp && rb_is_red(tmp)) {
+				/* Case 1 - color flips */
+				rb_set_parent_color(tmp, gparent, RB_BLACK);
+				rb_set_parent_color(parent, gparent, RB_BLACK);
+				node = gparent;
+				parent = rb_parent(node);
+				rb_set_parent_color(node, parent, RB_RED);
+				continue;
 			}
 
 			if (parent->rb_left == node) {
-				__rb_rotate_right(parent, root);
+				/* Case 2 - right rotate at parent */
+				parent->rb_left = tmp = node->rb_right;
+				node->rb_right = parent;
+				if (tmp)
+					rb_set_parent_color(tmp, parent,
+							    RB_BLACK);
+				rb_set_parent_color(parent, node, RB_RED);
 				parent = node;
 			}
 
-			rb_set_black(parent);
-			rb_set_red(gparent);
-			__rb_rotate_left(gparent, root);
+			/* Case 3 - left rotate at gparent */
+			gparent->rb_right = tmp = parent->rb_left;
+			parent->rb_left = gparent;
+			if (tmp)
+				rb_set_parent_color(tmp, gparent, RB_BLACK);
+			__rb_rotate_set_parents(gparent, parent, root, RB_RED);
 			break;
 		}
 	}
_
Subject: Subject: rbtree: low level optimizations in rb_insert_color()

Patches currently in -mm which might be from walken@google.com are

slab-do-not-call-compound_head-in-page_get_cache.patch
rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch
rbtree-empty-nodes-have-no-color.patch
rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch
rbtree-performance-and-correctness-test.patch
rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch
rbtree-low-level-optimizations-in-rb_insert_color.patch
rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch
rbtree-optimize-case-selection-logic-in-__rb_erase_color.patch
rbtree-low-level-optimizations-in-__rb_erase_color.patch
rbtree-coding-style-adjustments.patch

