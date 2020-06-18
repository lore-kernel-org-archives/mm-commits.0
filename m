From: akpm@linux-foundation.org
Subject: +
 mm-vmalloc-simplify-augment_tree_propagate_check-func.patch added to -mm tree
Date: Wed, 17 Jun 2020 18:58:49 -0700
Message-ID: <20200618015849.T62Rn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733257AbgFRB6u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 21:58:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, urezki@gmail.com


The patch titled
     Subject: mm/vmalloc: simplify augment_tree_propagate_check()
has been added to the -mm tree.  Its filename is
     mm-vmalloc-simplify-augment_tree_propagate_check-func.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-simplify-augment_tree_propagate_check-func.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-simplify-augment_tree_propagate_check-func.patch

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
Subject: mm/vmalloc: simplify augment_tree_propagate_check()

This function is for debug purpose only.  Currently it uses recursion for
tree traversal, checking an augmented value of each node to find out if it
is valid or not.

The recursion can corrupt the stack because the tree can be huge if
synthetic tests are applied.  To prevent it, navigate the tree from bottom
to upper levels using a regular list instead, because nodes are linked
among each other also.  It is faster and without recursion.

Link: http://lkml.kernel.org/r/20200527205054.1696-2-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   42 ++++++++----------------------------------
 1 file changed, 8 insertions(+), 34 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-simplify-augment_tree_propagate_check-func
+++ a/mm/vmalloc.c
@@ -633,43 +633,17 @@ unlink_va(struct vmap_area *va, struct r
 
 #if DEBUG_AUGMENT_PROPAGATE_CHECK
 static void
-augment_tree_propagate_check(struct rb_node *n)
+augment_tree_propagate_check(void)
 {
 	struct vmap_area *va;
-	struct rb_node *node;
-	unsigned long size;
-	bool found = false;
-
-	if (n == NULL)
-		return;
-
-	va = rb_entry(n, struct vmap_area, rb_node);
-	size = va->subtree_max_size;
-	node = n;
+	unsigned long computed_size;
 
-	while (node) {
-		va = rb_entry(node, struct vmap_area, rb_node);
-
-		if (get_subtree_max_size(node->rb_left) == size) {
-			node = node->rb_left;
-		} else {
-			if (va_size(va) == size) {
-				found = true;
-				break;
-			}
-
-			node = node->rb_right;
-		}
+	list_for_each_entry(va, &free_vmap_area_list, list) {
+		computed_size = compute_subtree_max_size(va);
+		if (computed_size != va->subtree_max_size)
+			pr_emerg("tree is corrupted: %lu, %lu\n",
+				va_size(va), va->subtree_max_size);
 	}
-
-	if (!found) {
-		va = rb_entry(n, struct vmap_area, rb_node);
-		pr_emerg("tree is corrupted: %lu, %lu\n",
-			va_size(va), va->subtree_max_size);
-	}
