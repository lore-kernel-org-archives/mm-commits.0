From: akpm@linux-foundation.org
Subject: [merged] rbtree-place-easiest-case-first-in-rb_erase.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:09:54 -0700
Message-ID: <20121009180955.27ACB20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:43032 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738Ab2JISJ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:09:57 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so365169wey.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:09:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree: place easiest case first in rb_erase()
has been removed from the -mm tree.  Its filename was
     rbtree-place-easiest-case-first-in-rb_erase.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: rbtree: place easiest case first in rb_erase()

In rb_erase, move the easy case (node to erase has no more than
1 child) first. I feel the code reads easier that way.

Signed-off-by: Michel Lespinasse <walken@google.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree.c |   35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff -puN lib/rbtree.c~rbtree-place-easiest-case-first-in-rb_erase lib/rbtree.c
--- a/lib/rbtree.c~rbtree-place-easiest-case-first-in-rb_erase
+++ a/lib/rbtree.c
@@ -368,17 +368,28 @@ static void __rb_erase_color(struct rb_n
 
 void rb_erase(struct rb_node *node, struct rb_root *root)
 {
-	struct rb_node *child, *parent;
+	struct rb_node *child = node->rb_right, *tmp = node->rb_left;
+	struct rb_node *parent;
 	int color;
 
-	if (!node->rb_left)
-		child = node->rb_right;
-	else if (!node->rb_right)
-		child = node->rb_left;
-	else {
+	if (!tmp) {
+	case1:
+		/* Case 1: node to erase has no more than 1 child (easy!) */
+
+		parent = rb_parent(node);
+		color = rb_color(node);
+
+		if (child)
+			rb_set_parent(child, parent);
+		__rb_change_child(node, child, parent, root);
+	} else if (!child) {
+		/* Still case 1, but this time the child is node->rb_left */
+		child = tmp;
+		goto case1;
+	} else {
 		struct rb_node *old = node, *left;
 
-		node = node->rb_right;
+		node = child;
 		while ((left = node->rb_left) != NULL)
 			node = left;
 
@@ -402,18 +413,8 @@ void rb_erase(struct rb_node *node, stru
 		node->__rb_parent_color = old->__rb_parent_color;
 		node->rb_left = old->rb_left;
 		rb_set_parent(old->rb_left, node);
-
-		goto color;
 	}
 
-	parent = rb_parent(node);
-	color = rb_color(node);
-
-	if (child)
-		rb_set_parent(child, parent);
-	__rb_change_child(node, child, parent, root);
