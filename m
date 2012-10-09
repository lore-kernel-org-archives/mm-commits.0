From: akpm@linux-foundation.org
Subject: [merged] rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:09:17 -0700
Message-ID: <20121009180918.C951320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:37938 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749Ab2JISJV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:09:21 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so363172eek.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:09:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, David.Woodhouse@intel.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, axboe@kernel.dk, daniel.santos@pobox.com, ebiederm@xmission.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree: break out of rb_insert_color loop after tree rotation
has been removed from the -mm tree.  Its filename was
     rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: rbtree: break out of rb_insert_color loop after tree rotation

It is a well known property of rbtrees that insertion never requires more
than two tree rotations.  In our implementation, after one loop iteration
identified one or two necessary tree rotations, we would iterate and look
for more.  However at that point the node's parent would always be black,
which would cause us to exit the loop.

We can make the code flow more obvious by just adding a break statement
after the tree rotations, where we know we are done.  Additionally, in the
cases where two tree rotations are necessary, we don't have to update the
'node' pointer as it wouldn't be used until the next loop iteration, which
we now avoid due to this break statement.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: David Woodhouse <David.Woodhouse@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Daniel Santos <daniel.santos@pobox.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN lib/rbtree.c~rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation lib/rbtree.c
--- a/lib/rbtree.c~rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation
+++ a/lib/rbtree.c
@@ -109,18 +109,15 @@ void rb_insert_color(struct rb_node *nod
 				}
 			}
 
-			if (parent->rb_right == node)
-			{
-				register struct rb_node *tmp;
+			if (parent->rb_right == node) {
 				__rb_rotate_left(parent, root);
-				tmp = parent;
 				parent = node;
-				node = tmp;
 			}
 
 			rb_set_black(parent);
 			rb_set_red(gparent);
 			__rb_rotate_right(gparent, root);
+			break;
 		} else {
 			{
 				register struct rb_node *uncle = gparent->rb_left;
@@ -134,18 +131,15 @@ void rb_insert_color(struct rb_node *nod
 				}
 			}
 
-			if (parent->rb_left == node)
-			{
-				register struct rb_node *tmp;
+			if (parent->rb_left == node) {
 				__rb_rotate_right(parent, root);
-				tmp = parent;
 				parent = node;
-				node = tmp;
 			}
 
 			rb_set_black(parent);
 			rb_set_red(gparent);
 			__rb_rotate_left(gparent, root);
+			break;
 		}
 	}
 
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
prio_tree-remove-fix.patch

