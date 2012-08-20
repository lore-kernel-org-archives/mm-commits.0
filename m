From: akpm@linux-foundation.org
Subject: + rbtree-add-rb_declare_callbacks-macro.patch added to -mm tree
Date: Mon, 20 Aug 2012 15:37:13 -0700
Message-ID: <20120820223714.9DC8620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:35655 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756583Ab2HTWhR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2012 18:37:17 -0400
Received: by mail-lpp01m010-f74.google.com with SMTP id w12so313819lag.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 15:37:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com


The patch titled
     Subject: rbtree: add RB_DECLARE_CALLBACKS() macro
has been added to the -mm tree.  Its filename is
     rbtree-add-rb_declare_callbacks-macro.patch

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
-
-static const struct rb_augment_callbacks augment_callbacks = {
-	augment_propagate, augment_copy, augment_rotate
-};
+RB_DECLARE_CALLBACKS(static, augment_callbacks, struct test_node, rb,
+		     u32, augmented, augment_recompute)
 
 static void insert_augmented(struct test_node *node, struct rb_root *root)
 {
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
ipc-mqueue-remove-unnecessary-rb_init_node-calls.patch
rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch
rbtree-empty-nodes-have-no-color.patch
rbtree-empty-nodes-have-no-color-fix.patch
rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec-fix.patch
rbtree-performance-and-correctness-test.patch
rbtree-performance-and-correctness-test-fix.patch
rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix-perf-compilation.patch
rbtree-low-level-optimizations-in-rb_insert_color.patch
rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch
rbtree-optimize-case-selection-logic-in-__rb_erase_color.patch
rbtree-low-level-optimizations-in-__rb_erase_color.patch
rbtree-coding-style-adjustments.patch
rbtree-optimize-fetching-of-sibling-node.patch
rbtree-test-fix-sparse-warning-about-64-bit-constant.patch
rbtree-add-__rb_change_child-helper-function.patch
rbtree-place-easiest-case-first-in-rb_erase.patch
rbtree-handle-1-child-recoloring-in-rb_erase-instead-of-rb_erase_color.patch
rbtree-low-level-optimizations-in-rb_erase.patch
rbtree-augmented-rbtree-test.patch
rbtree-faster-augmented-rbtree-manipulation.patch
rbtree-remove-prior-augmented-rbtree-implementation.patch
rbtree-add-rb_declare_callbacks-macro.patch

