From: akpm@linux-foundation.org
Subject: + rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch added to -mm tree
Date: Fri, 13 Jul 2012 13:31:03 -0700
Message-ID: <20120713203104.35818100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:33059 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757297Ab2GMUbF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 16:31:05 -0400
Received: by mail-vc0-f202.google.com with SMTP id p1so130967vcq.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 13:31:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, axboe@kernel.dk, daniel.santos@pobox.com, dwmw2@infradead.org, ebiederm@xmission.com, riel@redhat.com


The patch titled
     Subject: rbtree: adjust node color in __rb_erase_color() only when necessary
has been added to the -mm tree.  Its filename is
     rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch

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
Subject: rbtree: adjust node color in __rb_erase_color() only when necessary

In __rb_erase_color(), we were always setting a node to black after
exiting the main loop.  And in one case, after fixing up the tree to
satisfy all rbtree invariants, we were setting the current node to root
just to guarantee a loop exit, at which point the root would be set to
black.  However this is not necessary, as the root of an rbtree is already
known to be black.  The only case where the color flip is required is when
we exit the loop due to the current node being red, and it's easiest to
just do the flip at that point instead of doing it after the loop.

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

 lib/rbtree.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff -puN lib/rbtree.c~rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary lib/rbtree.c
--- a/lib/rbtree.c~rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary
+++ a/lib/rbtree.c
@@ -259,10 +259,22 @@ static void __rb_erase_color(struct rb_n
 {
 	struct rb_node *other;
 
-	while ((!node || rb_is_black(node)) && node != root->rb_node)
-	{
-		if (parent->rb_left == node)
-		{
+	while (true) {
+		/*
+		 * Loop invariant: all leaf paths going through node have a
+		 * black node count that is 1 lower than other leaf paths.
+		 *
+		 * If node is red, we can flip it to black to adjust.
+		 * If node is the root, all leaf paths go through it.
+		 * Otherwise, we need to adjust the tree through color flips
+		 * and tree rotations as per one of the 4 cases below.
+		 */
+		if (node && rb_is_red(node)) {
+			rb_set_black(node);
+			break;
+		} else if (!parent) {
+			break;
+		} else if (parent->rb_left == node) {
 			other = parent->rb_right;
 			if (rb_is_red(other))
 			{
@@ -291,12 +303,9 @@ static void __rb_erase_color(struct rb_n
 				rb_set_black(parent);
 				rb_set_black(other->rb_right);
 				__rb_rotate_left(parent, root);
-				node = root->rb_node;
 				break;
 			}
-		}
-		else
-		{
+		} else {
 			other = parent->rb_left;
 			if (rb_is_red(other))
 			{
@@ -325,13 +334,10 @@ static void __rb_erase_color(struct rb_n
 				rb_set_black(parent);
 				rb_set_black(other->rb_left);
 				__rb_rotate_right(parent, root);
-				node = root->rb_node;
 				break;
 			}
 		}
 	}
-	if (node)
-		rb_set_black(node);
 }
 
 void rb_erase(struct rb_node *node, struct rb_root *root)
_
Subject: Subject: rbtree: adjust node color in __rb_erase_color() only when necessary

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

