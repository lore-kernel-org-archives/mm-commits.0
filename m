From: akpm@linux-foundation.org
Subject: [merged] rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:09:31 -0700
Message-ID: <20121009180932.70F22200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:43032 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738Ab2JISJf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:09:35 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so365169wey.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:09:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, David.Woodhouse@intel.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, adrian.hunter@intel.com, alexander.shishkin@intel.com, axboe@kernel.dk, daniel.santos@pobox.com, ebiederm@xmission.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree: adjust node color in __rb_erase_color() only when necessary
has been removed from the -mm tree.  Its filename was
     rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[adrian.hunter@intel.com: perf tools: fix build for another rbtree.c change]
Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: David Woodhouse <David.Woodhouse@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Daniel Santos <daniel.santos@pobox.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree.c                           |   28 +++++++++++++----------
 tools/perf/util/include/linux/rbtree.h |    1 
 2 files changed, 18 insertions(+), 11 deletions(-)

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
diff -puN tools/perf/util/include/linux/rbtree.h~rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary tools/perf/util/include/linux/rbtree.h
--- a/tools/perf/util/include/linux/rbtree.h~rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary
+++ a/tools/perf/util/include/linux/rbtree.h
@@ -1,2 +1,3 @@
 #include <stdbool.h>
+#include <stdbool.h>
 #include "../../../../include/linux/rbtree.h"
_

Patches currently in -mm which might be from walken@google.com are

origin.patch
prio_tree-remove-fix.patch

