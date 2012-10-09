From: akpm@linux-foundation.org
Subject: [merged] rbtree-optimize-fetching-of-sibling-node.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:09:45 -0700
Message-ID: <20121009180945.C43D81E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:50800 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738Ab2JISJr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:09:47 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so574008yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:09:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, David.Woodhouse@intel.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, axboe@kernel.dk, daniel.santos@pobox.com, ebiederm@xmission.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree: optimize fetching of sibling node
has been removed from the -mm tree.  Its filename was
     rbtree-optimize-fetching-of-sibling-node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: rbtree: optimize fetching of sibling node

When looking to fetch a node's sibling, we went through a sequence of:
- check if node is the parent's left child
- if it is, then fetch the parent's right child

This can be replaced with:
- fetch the parent's right child as an assumed sibling
- check that node is NOT the fetched child

This avoids fetching the parent's left child when node is actually
that child. Saves a bit on code size, though it doesn't seem to make
a large difference in speed.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Daniel Santos <daniel.santos@pobox.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff -puN lib/rbtree.c~rbtree-optimize-fetching-of-sibling-node lib/rbtree.c
--- a/lib/rbtree.c~rbtree-optimize-fetching-of-sibling-node
+++ a/lib/rbtree.c
@@ -107,8 +107,8 @@ void rb_insert_color(struct rb_node *nod
 
 		gparent = rb_red_parent(parent);
 
-		if (parent == gparent->rb_left) {
-			tmp = gparent->rb_right;
+		tmp = gparent->rb_right;
+		if (parent != tmp) {	/* parent == gparent->rb_left */
 			if (tmp && rb_is_red(tmp)) {
 				/*
 				 * Case 1 - color flips
@@ -131,7 +131,8 @@ void rb_insert_color(struct rb_node *nod
 				continue;
 			}
 
-			if (parent->rb_right == node) {
+			tmp = parent->rb_right;
+			if (node == tmp) {
 				/*
 				 * Case 2 - left rotate at parent
 				 *
@@ -151,6 +152,7 @@ void rb_insert_color(struct rb_node *nod
 							    RB_BLACK);
 				rb_set_parent_color(parent, node, RB_RED);
 				parent = node;
+				tmp = node->rb_right;
 			}
 
 			/*
@@ -162,7 +164,7 @@ void rb_insert_color(struct rb_node *nod
 			 *     /                 \
 			 *    n                   U
 			 */
-			gparent->rb_left = tmp = parent->rb_right;
+			gparent->rb_left = tmp;  /* == parent->rb_right */
 			parent->rb_right = gparent;
 			if (tmp)
 				rb_set_parent_color(tmp, gparent, RB_BLACK);
@@ -180,7 +182,8 @@ void rb_insert_color(struct rb_node *nod
 				continue;
 			}
 
-			if (parent->rb_left == node) {
+			tmp = parent->rb_left;
+			if (node == tmp) {
 				/* Case 2 - right rotate at parent */
 				parent->rb_left = tmp = node->rb_right;
 				node->rb_right = parent;
@@ -189,10 +192,11 @@ void rb_insert_color(struct rb_node *nod
 							    RB_BLACK);
 				rb_set_parent_color(parent, node, RB_RED);
 				parent = node;
+				tmp = node->rb_left;
 			}
 
 			/* Case 3 - left rotate at gparent */
-			gparent->rb_right = tmp = parent->rb_left;
+			gparent->rb_right = tmp;  /* == parent->rb_left */
 			parent->rb_left = gparent;
 			if (tmp)
 				rb_set_parent_color(tmp, gparent, RB_BLACK);
@@ -223,8 +227,9 @@ static void __rb_erase_color(struct rb_n
 			break;
 		} else if (!parent) {
 			break;
-		} else if (parent->rb_left == node) {
-			sibling = parent->rb_right;
+		}
+		sibling = parent->rb_right;
+		if (node != sibling) {	/* node == parent->rb_left */
 			if (rb_is_red(sibling)) {
 				/*
 				 * Case 1 - left rotate at parent
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
prio_tree-remove-fix.patch

