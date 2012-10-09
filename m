From: akpm@linux-foundation.org
Subject: [merged] rbtree-add-rb_declare_callbacks-macro.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:10:18 -0700
Message-ID: <20121009181018.C257D1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:57300 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab2JISKT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:10:19 -0400
Received: by mail-qc0-f202.google.com with SMTP id s25so662407qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:10:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree: add RB_DECLARE_CALLBACKS() macro
has been removed from the -mm tree.  Its filename was
     rbtree-add-rb_declare_callbacks-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: rbtree: add RB_DECLARE_CALLBACKS() macro

As proposed by Peter Zijlstra, this makes it easier to define the augmented
rbtree callbacks.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat_rbtree.c |   37 ++-----------------------------------
 include/linux/rbtree.h   |   30 ++++++++++++++++++++++++++++++
 lib/rbtree_test.c        |   34 ++--------------------------------
 3 files changed, 34 insertions(+), 67 deletions(-)

diff -puN arch/x86/mm/pat_rbtree.c~rbtree-add-rb_declare_callbacks-macro arch/x86/mm/pat_rbtree.c
--- a/arch/x86/mm/pat_rbtree.c~rbtree-add-rb_declare_callbacks-macro
+++ a/arch/x86/mm/pat_rbtree.c
@@ -69,41 +69,8 @@ static u64 compute_subtree_max_end(struc
 	return max_end;
 }
 
-/* Update 'subtree_max_end' for node and its parents */
-static void memtype_rb_propagate_cb(struct rb_node *node, struct rb_node *stop)
-{
-	while (node != stop) {
-		struct memtype *data = container_of(node, struct memtype, rb);
-		u64 subtree_max_end = compute_subtree_max_end(data);
-		if (data->subtree_max_end == subtree_max_end)
-			break;
-		data->subtree_max_end = subtree_max_end;
-		node = rb_parent(&data->rb);
-	}
-}
-
-static void memtype_rb_copy_cb(struct rb_node *old, struct rb_node *new)
-{
-	struct memtype *old_data = container_of(old, struct memtype, rb);
-	struct memtype *new_data = container_of(new, struct memtype, rb);
-
-	new_data->subtree_max_end = old_data->subtree_max_end;
-}
-
-/* Update 'subtree_max_end' after tree rotation. old and new are the
- * former and current subtree roots */
-static void memtype_rb_rotate_cb(struct rb_node *old, struct rb_node *new)
-{
-	struct memtype *old_data = container_of(old, struct memtype, rb);
-	struct memtype *new_data = container_of(new, struct memtype, rb);
-
-	new_data->subtree_max_end = old_data->subtree_max_end;
-	old_data->subtree_max_end = compute_subtree_max_end(old_data);
-}
-
-static const struct rb_augment_callbacks memtype_rb_augment_cb = {
-	memtype_rb_propagate_cb, memtype_rb_copy_cb, memtype_rb_rotate_cb
-};
+RB_DECLARE_CALLBACKS(static, memtype_rb_augment_cb, struct memtype, rb,
+		     u64, subtree_max_end, compute_subtree_max_end)
 
 /* Find the first (lowest start addr) overlapping range from rb tree */
 static struct memtype *memtype_rb_lowest_match(struct rb_root *root,
diff -puN include/linux/rbtree.h~rbtree-add-rb_declare_callbacks-macro include/linux/rbtree.h
--- a/include/linux/rbtree.h~rbtree-add-rb_declare_callbacks-macro
+++ a/include/linux/rbtree.h
@@ -79,6 +79,36 @@ rb_insert_augmented(struct rb_node *node
 	__rb_insert_augmented(node, root, augment->rotate);
 }
 
+#define RB_DECLARE_CALLBACKS(rbstatic, rbname, rbstruct, rbfield,	      \
+			     rbtype, rbaugmented, rbcompute)		      \
+static void rbname ## _propagate(struct rb_node *rb, struct rb_node *stop)    \
+{									      \
+	while (rb != stop) {						      \
+		rbstruct *node = rb_entry(rb, rbstruct, rbfield);	      \
+		rbtype augmented = rbcompute(node);			      \
+		if (node->rbaugmented == augmented)			      \
+			break;						      \
+		node->rbaugmented = augmented;				      \
+		rb = rb_parent(&node->rbfield);				      \
+	}								      \
+}									      \
+static void rbname ## _copy(struct rb_node *rb_old, struct rb_node *rb_new)   \
+{									      \
+	rbstruct *old = rb_entry(rb_old, rbstruct, rbfield);		      \
+	rbstruct *new = rb_entry(rb_new, rbstruct, rbfield);		      \
+	new->rbaugmented = old->rbaugmented;				      \
+}									      \
+static void rbname ## _rotate(struct rb_node *rb_old, struct rb_node *rb_new) \
+{									      \
+	rbstruct *old = rb_entry(rb_old, rbstruct, rbfield);		      \
+	rbstruct *new = rb_entry(rb_new, rbstruct, rbfield);		      \
+	new->rbaugmented = old->rbaugmented;				      \
+	old->rbaugmented = rbcompute(old);				      \
+}									      \
+rbstatic const struct rb_augment_callbacks rbname = {			      \
+	rbname ## _propagate, rbname ## _copy, rbname ## _rotate	      \
+};
+
 
 /* Find logical next and previous nodes in a tree */
 extern struct rb_node *rb_next(const struct rb_node *);
diff -puN lib/rbtree_test.c~rbtree-add-rb_declare_callbacks-macro lib/rbtree_test.c
--- a/lib/rbtree_test.c~rbtree-add-rb_declare_callbacks-macro
+++ a/lib/rbtree_test.c
@@ -61,38 +61,8 @@ static inline u32 augment_recompute(stru
 	return max;
 }
 
-static void augment_propagate(struct rb_node *rb, struct rb_node *stop)
-{
-	while (rb != stop) {
-		struct test_node *node = rb_entry(rb, struct test_node, rb);
-		u32 augmented = augment_recompute(node);
-		if (node->augmented == augmented)
-			break;
-		node->augmented = augmented;
-		rb = rb_parent(&node->rb);
-	}
-}
-
-static void augment_copy(struct rb_node *rb_old, struct rb_node *rb_new)
-{
-	struct test_node *old = rb_entry(rb_old, struct test_node, rb);
-	struct test_node *new = rb_entry(rb_new, struct test_node, rb);
-	new->augmented = old->augmented;
-}
-
-static void augment_rotate(struct rb_node *rb_old, struct rb_node *rb_new)
-{
-	struct test_node *old = rb_entry(rb_old, struct test_node, rb);
-	struct test_node *new = rb_entry(rb_new, struct test_node, rb);
-
-	/* Rotation doesn't change subtree's augmented value */
-	new->augmented = old->augmented;
-	old->augmented = augment_recompute(old);
-}
