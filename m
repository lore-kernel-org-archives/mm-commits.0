From: akpm@linux-foundation.org
Subject: + rbtree-augmented-rbtree-test.patch added to -mm tree
Date: Mon, 20 Aug 2012 15:37:04 -0700
Message-ID: <20120820223705.4A141100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:42800 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583Ab2HTWhG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 18:37:06 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4115762obb.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 15:37:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, dwmw2@infradead.org, riel@redhat.com


The patch titled
     Subject: rbtree: augmented rbtree test
has been added to the -mm tree.  Its filename is
     rbtree-augmented-rbtree-test.patch

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
Subject: rbtree: augmented rbtree test

Small test to measure the performance of augmented rbtrees.

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree_test.c |  103 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 101 insertions(+), 2 deletions(-)

diff -puN lib/rbtree_test.c~rbtree-augmented-rbtree-test lib/rbtree_test.c
--- a/lib/rbtree_test.c~rbtree-augmented-rbtree-test
+++ a/lib/rbtree_test.c
@@ -10,6 +10,10 @@
 struct test_node {
 	struct rb_node rb;
 	u32 key;
+
+	/* following fields used for testing augmented rbtree functionality */
+	u32 val;
+	u32 augmented;
 };
 
 static struct rb_root root = RB_ROOT;
@@ -20,10 +24,11 @@ static struct rnd_state rnd;
 static void insert(struct test_node *node, struct rb_root *root)
 {
 	struct rb_node **new = &root->rb_node, *parent = NULL;
+	u32 key = node->key;
 
 	while (*new) {
 		parent = *new;
-		if (node->key < rb_entry(parent, struct test_node, rb)->key)
+		if (key < rb_entry(parent, struct test_node, rb)->key)
 			new = &parent->rb_left;
 		else
 			new = &parent->rb_right;
@@ -38,11 +43,62 @@ static inline void erase(struct test_nod
 	rb_erase(&node->rb, root);
 }
 
+static inline u32 augment_recompute(struct test_node *node)
+{
+	u32 max = node->val, child_augmented;
+	if (node->rb.rb_left) {
+		child_augmented = rb_entry(node->rb.rb_left, struct test_node,
+					   rb)->augmented;
+		if (max < child_augmented)
+			max = child_augmented;
+	}
+	if (node->rb.rb_right) {
+		child_augmented = rb_entry(node->rb.rb_right, struct test_node,
+					   rb)->augmented;
+		if (max < child_augmented)
+			max = child_augmented;
+	}
+	return max;
+}
+
+static void augment_callback(struct rb_node *rb, void *unused)
+{
+	struct test_node *node = rb_entry(rb, struct test_node, rb);
+	node->augmented = augment_recompute(node);
+}
+
+static void insert_augmented(struct test_node *node, struct rb_root *root)
+{
+	struct rb_node **new = &root->rb_node, *parent = NULL;
+	u32 key = node->key;
+
+	while (*new) {
+		parent = *new;
+		if (key < rb_entry(parent, struct test_node, rb)->key)
+			new = &parent->rb_left;
+		else
+			new = &parent->rb_right;
+	}
+
+	rb_link_node(&node->rb, parent, new);
+	rb_insert_color(&node->rb, root);
+	rb_augment_insert(&node->rb, augment_callback, NULL);
+}
+
+static void erase_augmented(struct test_node *node, struct rb_root *root)
+{
+	struct rb_node *deepest = rb_augment_erase_begin(&node->rb);
+	rb_erase(&node->rb, root);
+	rb_augment_erase_end(deepest, augment_callback, NULL);
+}
+
 static void init(void)
 {
 	int i;
-	for (i = 0; i < NODES; i++)
+	for (i = 0; i < NODES; i++) {
 		nodes[i].key = prandom32(&rnd);
+		nodes[i].val = prandom32(&rnd);
+	}
 }
 
 static bool is_red(struct rb_node *rb)
@@ -81,6 +137,17 @@ static void check(int nr_nodes)
 	WARN_ON_ONCE(count != nr_nodes);
 }
 
+static void check_augmented(int nr_nodes)
+{
+	struct rb_node *rb;
+
+	check(nr_nodes);
+	for (rb = rb_first(&root); rb; rb = rb_next(rb)) {
+		struct test_node *node = rb_entry(rb, struct test_node, rb);
+		WARN_ON_ONCE(node->augmented != augment_recompute(node));
+	}
+}
+
 static int rbtree_test_init(void)
 {
 	int i, j;
@@ -119,6 +186,38 @@ static int rbtree_test_init(void)
 		check(0);
 	}
 
+	printk(KERN_ALERT "augmented rbtree testing");
+
+	init();
+
+	time1 = get_cycles();
+
+	for (i = 0; i < PERF_LOOPS; i++) {
+		for (j = 0; j < NODES; j++)
+			insert_augmented(nodes + j, &root);
+		for (j = 0; j < NODES; j++)
+			erase_augmented(nodes + j, &root);
+	}
+
+	time2 = get_cycles();
+	time = time2 - time1;
+
+	time = div_u64(time, PERF_LOOPS);
+	printk(" -> %llu cycles\n", (unsigned long long)time);
+
+	for (i = 0; i < CHECK_LOOPS; i++) {
+		init();
+		for (j = 0; j < NODES; j++) {
+			check_augmented(j);
+			insert_augmented(nodes + j, &root);
+		}
+		for (j = 0; j < NODES; j++) {
+			check_augmented(NODES - j);
+			erase_augmented(nodes + j, &root);
+		}
+		check_augmented(0);
+	}
+
 	return -EAGAIN; /* Fail will directly unload the module */
 }
 
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

