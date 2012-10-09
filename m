From: akpm@linux-foundation.org
Subject: [merged] rbtree-optimize-case-selection-logic-in-__rb_erase_color.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:09:36 -0700
Message-ID: <20121009180936.D95BE100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:63749 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738Ab2JISJi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:09:38 -0400
Received: by mail-vc0-f202.google.com with SMTP id fy27so662066vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:09:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, David.Woodhouse@intel.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, axboe@kernel.dk, daniel.santos@pobox.com, ebiederm@xmission.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree: optimize case selection logic in __rb_erase_color()
has been removed from the -mm tree.  Its filename was
     rbtree-optimize-case-selection-logic-in-__rb_erase_color.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: rbtree: optimize case selection logic in __rb_erase_color()

In __rb_erase_color(), we have to select one of 3 cases depending on the
color on the 'other' node children.  If both children are black, we flip a
few node colors and iterate.  Otherwise, we do either one or two tree
rotations, depending on the color of the 'other' child opposite to 'node',
and then we are done.

The corresponding logic had duplicate checks for the color of the 'other'
child opposite to 'node'.  It was checking it first to determine if both
children are black, and then to determine how many tree rotations are
required.  Rearrange the logic to avoid that extra check.

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

 lib/rbtree.c |   68 +++++++++++++++++++++----------------------------
 1 file changed, 30 insertions(+), 38 deletions(-)

diff -puN lib/rbtree.c~rbtree-optimize-case-selection-logic-in-__rb_erase_color lib/rbtree.c
--- a/lib/rbtree.c~rbtree-optimize-case-selection-logic-in-__rb_erase_color
+++ a/lib/rbtree.c
@@ -283,28 +283,24 @@ static void __rb_erase_color(struct rb_n
 				__rb_rotate_left(parent, root);
 				other = parent->rb_right;
 			}
-			if ((!other->rb_left || rb_is_black(other->rb_left)) &&
-			    (!other->rb_right || rb_is_black(other->rb_right)))
-			{
-				rb_set_red(other);
-				node = parent;
-				parent = rb_parent(node);
-			}
-			else
-			{
-				if (!other->rb_right || rb_is_black(other->rb_right))
-				{
-					rb_set_black(other->rb_left);
+			if (!other->rb_right || rb_is_black(other->rb_right)) {
+				if (!other->rb_left ||
+				    rb_is_black(other->rb_left)) {
 					rb_set_red(other);
-					__rb_rotate_right(other, root);
-					other = parent->rb_right;
+					node = parent;
+					parent = rb_parent(node);
+					continue;
 				}
-				rb_set_color(other, rb_color(parent));
-				rb_set_black(parent);
-				rb_set_black(other->rb_right);
-				__rb_rotate_left(parent, root);
-				break;
+				rb_set_black(other->rb_left);
+				rb_set_red(other);
+				__rb_rotate_right(other, root);
+				other = parent->rb_right;
 			}
+			rb_set_color(other, rb_color(parent));
+			rb_set_black(parent);
+			rb_set_black(other->rb_right);
+			__rb_rotate_left(parent, root);
+			break;
 		} else {
 			other = parent->rb_left;
 			if (rb_is_red(other))
@@ -314,28 +310,24 @@ static void __rb_erase_color(struct rb_n
 				__rb_rotate_right(parent, root);
 				other = parent->rb_left;
 			}
-			if ((!other->rb_left || rb_is_black(other->rb_left)) &&
-			    (!other->rb_right || rb_is_black(other->rb_right)))
-			{
-				rb_set_red(other);
-				node = parent;
-				parent = rb_parent(node);
-			}
-			else
-			{
-				if (!other->rb_left || rb_is_black(other->rb_left))
-				{
-					rb_set_black(other->rb_right);
+			if (!other->rb_left || rb_is_black(other->rb_left)) {
+				if (!other->rb_right ||
+				    rb_is_black(other->rb_right)) {
 					rb_set_red(other);
-					__rb_rotate_left(other, root);
-					other = parent->rb_left;
+					node = parent;
+					parent = rb_parent(node);
+					continue;
 				}
-				rb_set_color(other, rb_color(parent));
-				rb_set_black(parent);
-				rb_set_black(other->rb_left);
-				__rb_rotate_right(parent, root);
-				break;
+				rb_set_black(other->rb_right);
+				rb_set_red(other);
+				__rb_rotate_left(other, root);
+				other = parent->rb_left;
 			}
+			rb_set_color(other, rb_color(parent));
+			rb_set_black(parent);
+			rb_set_black(other->rb_left);
+			__rb_rotate_right(parent, root);
+			break;
 		}
 	}
 }
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
prio_tree-remove-fix.patch

