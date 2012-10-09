From: akpm@linux-foundation.org
Subject: [merged] rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:09:23 -0700
Message-ID: <20121009180923.C7C991E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:41762 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738Ab2JISJZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:09:25 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so518523qae.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:09:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, David.Woodhouse@intel.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, axboe@kernel.dk, daniel.santos@pobox.com, ebiederm@xmission.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree: adjust root color in rb_insert_color() only when necessary
has been removed from the -mm tree.  Its filename was
     rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: rbtree: adjust root color in rb_insert_color() only when necessary

The root node of an rbtree must always be black.  However,
rb_insert_color() only needs to maintain this invariant when it has been
broken - that is, when it exits the loop due to the current (red) node
being the root.  In all other cases (exiting after tree rotations, or
exiting due to an existing black parent) the invariant is already
satisfied, so there is no need to adjust the root node color.

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

 lib/rbtree.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff -puN lib/rbtree.c~rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary lib/rbtree.c
--- a/lib/rbtree.c~rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary
+++ a/lib/rbtree.c
@@ -91,8 +91,21 @@ void rb_insert_color(struct rb_node *nod
 {
 	struct rb_node *parent, *gparent;
 
-	while ((parent = rb_parent(node)) && rb_is_red(parent))
-	{
+	while (true) {
+		/*
+		 * Loop invariant: node is red
+		 *
+		 * If there is a black parent, we are done.
+		 * Otherwise, take some corrective action as we don't
+		 * want a red root or two consecutive red nodes.
+		 */
+		parent = rb_parent(node);
+		if (!parent) {
+			rb_set_black(node);
+			break;
+		} else if (rb_is_black(parent))
+			break;
+
 		gparent = rb_parent(parent);
 
 		if (parent == gparent->rb_left)
@@ -142,8 +155,6 @@ void rb_insert_color(struct rb_node *nod
 			break;
 		}
 	}
