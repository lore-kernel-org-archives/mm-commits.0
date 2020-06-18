From: akpm@linux-foundation.org
Subject: + mm-vmalloc-switch-to-propagate-callback.patch added to
 -mm tree
Date: Wed, 17 Jun 2020 18:58:51 -0700
Message-ID: <20200618015851.G2lsG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387430AbgFRB6w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 21:58:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, urezki@gmail.com


The patch titled
     Subject: mm/vmalloc: switch to "propagate()" callback
has been added to the -mm tree.  Its filename is
     mm-vmalloc-switch-to-propagate-callback.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-switch-to-propagate-callback.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-switch-to-propagate-callback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: switch to "propagate()" callback

An augment_tree_propagate_from() function uses its own implementation that
populates a tree from the specified node toward a root node.

On the other hand the RB_DECLARE_CALLBACKS_MAX macro provides the
"propagate()" callback that does exactly the same.  Having two similar
functions does not make sense and is redundant.

Reuse "built in" functionality to the macros.  So the code size gets
reduced.

Link: http://lkml.kernel.org/r/20200527205054.1696-3-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-switch-to-propagate-callback
+++ a/mm/vmalloc.c
@@ -677,25 +677,12 @@ augment_tree_propagate_check(void)
 static __always_inline void
 augment_tree_propagate_from(struct vmap_area *va)
 {
-	struct rb_node *node = &va->rb_node;
-	unsigned long new_va_sub_max_size;
-
-	while (node) {
-		va = rb_entry(node, struct vmap_area, rb_node);
-		new_va_sub_max_size = compute_subtree_max_size(va);
-
-		/*
-		 * If the newly calculated maximum available size of the
-		 * subtree is equal to the current one, then it means that
-		 * the tree is propagated correctly. So we have to stop at
-		 * this point to save cycles.
-		 */
-		if (va->subtree_max_size == new_va_sub_max_size)
-			break;
