From: akpm@linux-foundation.org
Subject: + rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch added to -mm tree
Date: Fri, 13 Jul 2012 13:30:55 -0700
Message-ID: <20120713203056.6075B100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:33059 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab2GMUa5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 16:30:57 -0400
Received: by mail-vc0-f202.google.com with SMTP id p1so130967vcq.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 13:30:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, axboe@kernel.dk, daniel.santos@pobox.com, dwmw2@infradead.org, ebiederm@xmission.com, riel@redhat.com


The patch titled
     Subject: rbtree: adjust root color in rb_insert_color() only when necessary
has been added to the -mm tree.  Its filename is
     rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch

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
Subject: rbtree: adjust root color in rb_insert_color() only when necessary

The root node of an rbtree must always be black.  However,
rb_insert_color() only needs to maintain this invariant when it has been
broken - that is, when it exits the loop due to the current (red) node
being the root.  In all other cases (exiting after tree rotations, or
exiting due to an existing black parent) the invariant is already
satisfied, so there is no need to adjust the root node color.

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
