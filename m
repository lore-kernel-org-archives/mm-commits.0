From: akpm@linux-foundation.org
Subject: + rbtree-coding-style-adjustments.patch added to -mm tree
Date: Fri, 13 Jul 2012 13:31:14 -0700
Message-ID: <20120713203115.A3DEA5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:45695 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212Ab2GMUbS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 16:31:18 -0400
Received: by mail-ee0-f74.google.com with SMTP id d4so147638eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 13:31:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, axboe@kernel.dk, daniel.santos@pobox.com, dwmw2@infradead.org, ebiederm@xmission.com, riel@redhat.com


The patch titled
     Subject: rbtree: coding style adjustments
has been added to the -mm tree.  Its filename is
     rbtree-coding-style-adjustments.patch

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
Subject: rbtree: coding style adjustments

Set comment and indentation style to be consistent with linux coding style
and the rest of the file, as suggested by Peter Zijlstra

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

 lib/rbtree.c |   42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff -puN lib/rbtree.c~rbtree-coding-style-adjustments lib/rbtree.c
--- a/lib/rbtree.c~rbtree-coding-style-adjustments
+++ a/lib/rbtree.c
@@ -363,8 +363,7 @@ void rb_erase(struct rb_node *node, stru
 		child = node->rb_right;
 	else if (!node->rb_right)
 		child = node->rb_left;
-	else
-	{
+	else {
 		struct rb_node *old = node, *left;
 
 		node = node->rb_right;
@@ -406,17 +405,15 @@ void rb_erase(struct rb_node *node, stru
 
 	if (child)
 		rb_set_parent(child, parent);
-	if (parent)
-	{
+	if (parent) {
 		if (parent->rb_left == node)
 			parent->rb_left = child;
 		else
 			parent->rb_right = child;
-	}
-	else
+	} else
 		root->rb_node = child;
 
- color:
+color:
 	if (color == RB_BLACK)
 		__rb_erase_color(child, parent, root);
 }
@@ -529,8 +526,10 @@ struct rb_node *rb_next(const struct rb_
 	if (RB_EMPTY_NODE(node))
 		return NULL;
 
-	/* If we have a right-hand child, go down and then left as far
-	   as we can. */
+	/*
+	 * If we have a right-hand child, go down and then left as far
+	 * as we can.
+	 */
 	if (node->rb_right) {
 		node = node->rb_right; 
 		while (node->rb_left)
@@ -538,12 +537,13 @@ struct rb_node *rb_next(const struct rb_
 		return (struct rb_node *)node;
 	}
 
-	/* No right-hand children.  Everything down and left is
-	   smaller than us, so any 'next' node must be in the general
-	   direction of our parent. Go up the tree; any time the
-	   ancestor is a right-hand child of its parent, keep going
-	   up. First time it's a left-hand child of its parent, said
-	   parent is our 'next' node. */
+	/*
+	 * No right-hand children. Everything down and left is smaller than us,
+	 * so any 'next' node must be in the general direction of our parent.
+	 * Go up the tree; any time the ancestor is a right-hand child of its
+	 * parent, keep going up. First time it's a left-hand child of its
+	 * parent, said parent is our 'next' node.
+	 */
 	while ((parent = rb_parent(node)) && node == parent->rb_right)
 		node = parent;
 
@@ -558,8 +558,10 @@ struct rb_node *rb_prev(const struct rb_
 	if (RB_EMPTY_NODE(node))
 		return NULL;
 
-	/* If we have a left-hand child, go down and then right as far
-	   as we can. */
+	/*
+	 * If we have a left-hand child, go down and then right as far
+	 * as we can.
+	 */
 	if (node->rb_left) {
 		node = node->rb_left; 
 		while (node->rb_right)
@@ -567,8 +569,10 @@ struct rb_node *rb_prev(const struct rb_
 		return (struct rb_node *)node;
 	}
 
-	/* No left-hand children. Go up till we find an ancestor which
-	   is a right-hand child of its parent */
+	/*
+	 * No left-hand children. Go up till we find an ancestor which
+	 * is a right-hand child of its parent.
+	 */
 	while ((parent = rb_parent(node)) && node == parent->rb_left)
 		node = parent;
 
_
Subject: Subject: rbtree: coding style adjustments

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

