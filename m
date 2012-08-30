From: akpm@linux-foundation.org
Subject: + rbtree-add-prio-tree-and-interval-tree-tests.patch added to -mm tree
Date: Thu, 30 Aug 2012 14:34:17 -0700
Message-ID: <20120830213417.79763100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:50761 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2H3VeT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Aug 2012 17:34:19 -0400
Received: by ghbz15 with SMTP id z15so268861ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 30 Aug 2012 14:34:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, catalin.marinas@arm.com, dhillf@gmail.com, dwmw2@infradead.org, riel@redhat.com


The patch titled
     Subject: rbtree: add prio tree and interval tree tests
has been added to the -mm tree.  Its filename is
     rbtree-add-prio-tree-and-interval-tree-tests.patch

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
Subject: rbtree: add prio tree and interval tree tests

Patch 1 implements support for interval trees, on top of the augmented
rbtree API. It also adds synthetic tests to compare the performance of
interval trees vs prio trees. Short answers is that interval trees are
slightly faster (~25%) on insert/erase, and much faster (~2.4 - 3x)
on search. It is debatable how realistic the synthetic test is, and I have
not made such measurements yet, but my impression is that interval trees
would still come out faster.

Patch 2 uses a preprocessor template to make the interval tree generic,
and uses it as a replacement for the vma prio_tree.

Patch 3 takes the other prio_tree user, kmemleak, and converts it to use
a basic rbtree. We don't actually need the augmented rbtree support here
because the intervals are always non-overlapping.

Patch 4 removes the now-unused prio tree library.

Patch 5 proposes an additional optimization to rb_erase_augmented, now
providing it as an inline function so that the augmented callbacks can be
inlined in. This provides an additional 5-10% performance improvement
for the interval tree insert/erase benchmark. There is a maintainance cost
as it exposes augmented rbtree users to some of the rbtree library internals;
however I think this cost shouldn't be too high as I expect the augmented
rbtree will always have much less users than the base rbtree.

I should probably add a quick summary of why I think it makes sense to
replace prio trees with augmented rbtree based interval trees now.  One of
the drivers is that we need augmented rbtrees for Rik's vma gap finding
code, and once you have them, it just makes sense to use them for interval
trees as well, as this is the simpler and more well known algorithm.  prio
trees, in comparison, seem *too* clever: they impose an additional 'heap'
constraint on the tree, which they use to guarantee a faster worst-case
complexity of O(k+log N) for stabbing queries in a well-balanced prio
tree, vs O(k*log N) for interval trees (where k=number of matches,
N=number of intervals).  Now this sounds great, but in practice prio trees
don't realize this theorical benefit.  First, the additional constraint
makes them harder to update, so that the kernel implementation has to
simplify things by balancing them like a radix tree, which is not always
ideal.  Second, the fact that there are both index and heap properties
makes both tree manipulation and search more complex, which results in a
higher multiplicative time constant.  As it turns out, the simple interval
tree algorithm ends up running faster than the more clever prio tree.




This patch:

Add two test modules:

- prio_tree_test measures the performance of lib/prio_tree.c, both for
  insertion/removal and for stabbing searches

- interval_tree_test measures the performance of a library of equivalent
  functionality, built using the augmented rbtree support.

In order to support the second test module, lib/interval_tree.c is
introduced. It is kept separate from the interval_tree_test main file
for two reasons: first we don't want to provide an unfair advantage
over prio_tree_test by having everything in a single compilation unit,
and second there is the possibility that the interval tree functionality
could get some non-test users in kernel over time.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/interval_tree.h |   27 +++++
 lib/Kconfig.debug             |   12 ++
 lib/Makefile                  |    4 
 lib/interval_tree.c           |  159 ++++++++++++++++++++++++++++++++
 lib/interval_tree_test_main.c |  105 +++++++++++++++++++++
 lib/prio_tree.c               |    4 
 lib/prio_tree_test.c          |  106 +++++++++++++++++++++
 7 files changed, 417 insertions(+)

diff -puN /dev/null include/linux/interval_tree.h
--- /dev/null
+++ a/include/linux/interval_tree.h
@@ -0,0 +1,27 @@
+#ifndef _LINUX_INTERVAL_TREE_H
+#define _LINUX_INTERVAL_TREE_H
+
+#include <linux/rbtree.h>
+
+struct interval_tree_node {
+	struct rb_node rb;
+	unsigned long start;	/* Start of interval */
+	unsigned long last;	/* Last location _in_ interval */
+	unsigned long __subtree_last;
+};
+
+extern void
+interval_tree_insert(struct interval_tree_node *node, struct rb_root *root);
+
+extern void
+interval_tree_remove(struct interval_tree_node *node, struct rb_root *root);
+
+extern struct interval_tree_node *
+interval_tree_iter_first(struct rb_root *root,
+			 unsigned long start, unsigned long last);
+
+extern struct interval_tree_node *
+interval_tree_iter_next(struct interval_tree_node *node,
+			unsigned long start, unsigned long last);
+
+#endif	/* _LINUX_INTERVAL_TREE_H */
diff -puN lib/Kconfig.debug~rbtree-add-prio-tree-and-interval-tree-tests lib/Kconfig.debug
--- a/lib/Kconfig.debug~rbtree-add-prio-tree-and-interval-tree-tests
+++ a/lib/Kconfig.debug
@@ -1286,6 +1286,18 @@ config RBTREE_TEST
 	  A benchmark measuring the performance of the rbtree library.
 	  Also includes rbtree invariant checks.
 
+config PRIO_TREE_TEST
+	tristate "Prio tree test"
+	depends on m && DEBUG_KERNEL
+	help
+	  A benchmark measuring the performance of the prio tree library
+
+config INTERVAL_TREE_TEST
+	tristate "Interval tree test"
+	depends on m && DEBUG_KERNEL
+	help
+	  A benchmark measuring the performance of the interval tree library
+
 config PROVIDE_OHCI1394_DMA_INIT
 	bool "Remote debugging over FireWire early on boot"
 	depends on PCI && X86
diff -puN lib/Makefile~rbtree-add-prio-tree-and-interval-tree-tests lib/Makefile
--- a/lib/Makefile~rbtree-add-prio-tree-and-interval-tree-tests
+++ a/lib/Makefile
@@ -141,6 +141,10 @@ $(foreach file, $(libfdt_files), \
 lib-$(CONFIG_LIBFDT) += $(libfdt_files)
 
 obj-$(CONFIG_RBTREE_TEST) += rbtree_test.o
+obj-$(CONFIG_PRIO_TREE_TEST) += prio_tree_test.o
+obj-$(CONFIG_INTERVAL_TREE_TEST) += interval_tree_test.o
+
+interval_tree_test-objs := interval_tree_test_main.o interval_tree.o
 
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
diff -puN /dev/null lib/interval_tree.c
--- /dev/null
+++ a/lib/interval_tree.c
@@ -0,0 +1,159 @@
+#include <linux/init.h>
+#include <linux/interval_tree.h>
+
+/* Callbacks for augmented rbtree insert and remove */
+
+static inline unsigned long
+compute_subtree_last(struct interval_tree_node *node)
+{
+	unsigned long max = node->last, subtree_last;
+	if (node->rb.rb_left) {
+		subtree_last = rb_entry(node->rb.rb_left,
+			struct interval_tree_node, rb)->__subtree_last;
+		if (max < subtree_last)
+			max = subtree_last;
+	}
+	if (node->rb.rb_right) {
+		subtree_last = rb_entry(node->rb.rb_right,
+			struct interval_tree_node, rb)->__subtree_last;
+		if (max < subtree_last)
+			max = subtree_last;
+	}
+	return max;
+}
+
+RB_DECLARE_CALLBACKS(static, augment_callbacks, struct interval_tree_node, rb,
+		     unsigned long, __subtree_last, compute_subtree_last)
+
+/* Insert / remove interval nodes from the tree */
+
+void interval_tree_insert(struct interval_tree_node *node,
+			  struct rb_root *root)
+{
+	struct rb_node **link = &root->rb_node, *rb_parent = NULL;
+	unsigned long start = node->start, last = node->last;
+	struct interval_tree_node *parent;
+
+	while (*link) {
+		rb_parent = *link;
+		parent = rb_entry(rb_parent, struct interval_tree_node, rb);
+		if (parent->__subtree_last < last)
+			parent->__subtree_last = last;
+		if (start < parent->start)
+			link = &parent->rb.rb_left;
+		else
+			link = &parent->rb.rb_right;
+	}
+
+	node->__subtree_last = last;
+	rb_link_node(&node->rb, rb_parent, link);
+	rb_insert_augmented(&node->rb, root, &augment_callbacks);
+}
+
+void interval_tree_remove(struct interval_tree_node *node,
+			  struct rb_root *root)
+{
+	rb_erase_augmented(&node->rb, root, &augment_callbacks);
+}
+
+/*
+ * Iterate over intervals intersecting [start;last]
+ *
+ * Note that a node's interval intersects [start;last] iff:
+ *   Cond1: node->start <= last
+ * and
+ *   Cond2: start <= node->last
+ */
+
+static struct interval_tree_node *
+subtree_search(struct interval_tree_node *node,
+	       unsigned long start, unsigned long last)
+{
+	while (true) {
+		/*
+		 * Loop invariant: start <= node->__subtree_last
+		 * (Cond2 is satisfied by one of the subtree nodes)
+		 */
+		if (node->rb.rb_left) {
+			struct interval_tree_node *left =
+				rb_entry(node->rb.rb_left,
+					 struct interval_tree_node, rb);
+			if (start <= left->__subtree_last) {
+				/*
+				 * Some nodes in left subtree satisfy Cond2.
+				 * Iterate to find the leftmost such node N.
+				 * If it also satisfies Cond1, that's the match
+				 * we are looking for. Otherwise, there is no
+				 * matching interval as nodes to the right of N
+				 * can't satisfy Cond1 either.
+				 */
+				node = left;
+				continue;
+			}
+		}
+		if (node->start <= last) {		/* Cond1 */
+			if (start <= node->last)	/* Cond2 */
+				return node;	/* node is leftmost match */
+			if (node->rb.rb_right) {
+				node = rb_entry(node->rb.rb_right,
+					struct interval_tree_node, rb);
+				if (start <= node->__subtree_last)
+					continue;
+			}
+		}
+		return NULL;	/* No match */
+	}
+}
+
+struct interval_tree_node *
+interval_tree_iter_first(struct rb_root *root,
+			 unsigned long start, unsigned long last)
+{
+	struct interval_tree_node *node;
+
+	if (!root->rb_node)
+		return NULL;
+	node = rb_entry(root->rb_node, struct interval_tree_node, rb);
+	if (node->__subtree_last < start)
+		return NULL;
+	return subtree_search(node, start, last);
+}
+
+struct interval_tree_node *
+interval_tree_iter_next(struct interval_tree_node *node,
+			unsigned long start, unsigned long last)
+{
+	struct rb_node *rb = node->rb.rb_right, *prev;
+
+	while (true) {
+		/*
+		 * Loop invariants:
+		 *   Cond1: node->start <= last
+		 *   rb == node->rb.rb_right
+		 *
+		 * First, search right subtree if suitable
+		 */
+		if (rb) {
+			struct interval_tree_node *right =
+				rb_entry(rb, struct interval_tree_node, rb);
+			if (start <= right->__subtree_last)
+				return subtree_search(right, start, last);
+		}
+
+		/* Move up the tree until we come from a node's left child */
+		do {
+			rb = rb_parent(&node->rb);
+			if (!rb)
+				return NULL;
+			prev = &node->rb;
+			node = rb_entry(rb, struct interval_tree_node, rb);
+			rb = node->rb.rb_right;
+		} while (prev == rb);
+
+		/* Check if the node intersects [start;last] */
+		if (last < node->start)		/* !Cond1 */
+			return NULL;
+		else if (start <= node->last)	/* Cond2 */
+			return node;
+	}
+}
diff -puN /dev/null lib/interval_tree_test_main.c
--- /dev/null
+++ a/lib/interval_tree_test_main.c
@@ -0,0 +1,105 @@
+#include <linux/module.h>
+#include <linux/interval_tree.h>
+#include <linux/random.h>
+#include <asm/timex.h>
+
+#define NODES        100
+#define PERF_LOOPS   100000
+#define SEARCHES     100
+#define SEARCH_LOOPS 10000
+
+static struct rb_root root = RB_ROOT;
+static struct interval_tree_node nodes[NODES];
+static u32 queries[SEARCHES];
+
+static struct rnd_state rnd;
+
+static inline unsigned long
+search(unsigned long query, struct rb_root *root)
+{
+	struct interval_tree_node *node;
+	unsigned long results = 0;
+
+	for (node = interval_tree_iter_first(root, query, query); node;
+	     node = interval_tree_iter_next(node, query, query))
+		results++;
+	return results;
+}
+
+static void init(void)
+{
+	int i;
+	for (i = 0; i < NODES; i++) {
+		u32 a = prandom32(&rnd), b = prandom32(&rnd);
+		if (a <= b) {
+			nodes[i].start = a;
+			nodes[i].last = b;
+		} else {
+			nodes[i].start = b;
+			nodes[i].last = a;
+		}
+	}
+	for (i = 0; i < SEARCHES; i++)
+		queries[i] = prandom32(&rnd);
+}
+
+static int interval_tree_test_init(void)
+{
+	int i, j;
+	unsigned long results;
+	cycles_t time1, time2, time;
+
+	printk(KERN_ALERT "interval tree insert/remove");
+
+	prandom32_seed(&rnd, 3141592653589793238ULL);
+	init();
+
+	time1 = get_cycles();
+
+	for (i = 0; i < PERF_LOOPS; i++) {
+		for (j = 0; j < NODES; j++)
+			interval_tree_insert(nodes + j, &root);
+		for (j = 0; j < NODES; j++)
+			interval_tree_remove(nodes + j, &root);
+	}
+
+	time2 = get_cycles();
+	time = time2 - time1;
+
+	time = div_u64(time, PERF_LOOPS);
+	printk(" -> %llu cycles\n", (unsigned long long)time);
+
+	printk(KERN_ALERT "interval tree search");
+
+	for (j = 0; j < NODES; j++)
+		interval_tree_insert(nodes + j, &root);
+
+	time1 = get_cycles();
+
+	results = 0;
+	for (i = 0; i < SEARCH_LOOPS; i++)
+		for (j = 0; j < SEARCHES; j++)
+			results += search(queries[j], &root);
+
+	time2 = get_cycles();
+	time = time2 - time1;
+
+	time = div_u64(time, SEARCH_LOOPS);
+	results = div_u64(results, SEARCH_LOOPS);
+	printk(" -> %llu cycles (%lu results)\n",
+	       (unsigned long long)time, results);
+
+	return -EAGAIN; /* Fail will directly unload the module */
+}
+
+static void interval_tree_test_exit(void)
+{
+	printk(KERN_ALERT "test exit\n");
+}
+
+module_init(interval_tree_test_init)
+module_exit(interval_tree_test_exit)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Michel Lespinasse");
+MODULE_DESCRIPTION("Interval Tree test");
diff -puN lib/prio_tree.c~rbtree-add-prio-tree-and-interval-tree-tests lib/prio_tree.c
--- a/lib/prio_tree.c~rbtree-add-prio-tree-and-interval-tree-tests
+++ a/lib/prio_tree.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/prio_tree.h>
+#include <linux/export.h>
 
 /*
  * A clever mix of heap and radix trees forms a radix priority search tree (PST)
@@ -241,6 +242,7 @@ struct prio_tree_node *prio_tree_insert(
 	BUG();
 	return NULL;
 }
+EXPORT_SYMBOL(prio_tree_insert);
 
 /*
  * Remove a prio_tree_node @node from a radix priority search tree @root. The
@@ -290,6 +292,7 @@ void prio_tree_remove(struct prio_tree_r
 	while (cur != node)
 		cur = prio_tree_replace(root, cur->parent, cur);
 }
+EXPORT_SYMBOL(prio_tree_remove);
 
 static void iter_walk_down(struct prio_tree_iter *iter)
 {
@@ -464,3 +467,4 @@ repeat:
 
 	goto repeat;
 }
+EXPORT_SYMBOL(prio_tree_next);
diff -puN /dev/null lib/prio_tree_test.c
--- /dev/null
+++ a/lib/prio_tree_test.c
@@ -0,0 +1,106 @@
+#include <linux/module.h>
+#include <linux/prio_tree.h>
+#include <linux/random.h>
+#include <asm/timex.h>
+
+#define NODES        100
+#define PERF_LOOPS   100000
+#define SEARCHES     100
+#define SEARCH_LOOPS 10000
+
+static struct prio_tree_root root;
+static struct prio_tree_node nodes[NODES];
+static u32 queries[SEARCHES];
+
+static struct rnd_state rnd;
+
+static inline unsigned long
+search(unsigned long query, struct prio_tree_root *root)
+{
+	struct prio_tree_iter iter;
+	unsigned long results = 0;
+
+	prio_tree_iter_init(&iter, root, query, query);
+	while (prio_tree_next(&iter))
+		results++;
+	return results;
+}
+
+static void init(void)
+{
+	int i;
+	for (i = 0; i < NODES; i++) {
+		u32 a = prandom32(&rnd), b = prandom32(&rnd);
+		if (a <= b) {
+			nodes[i].start = a;
+			nodes[i].last = b;
+		} else {
+			nodes[i].start = b;
+			nodes[i].last = a;
+		}
+	}
+	for (i = 0; i < SEARCHES; i++)
+		queries[i] = prandom32(&rnd);
+}
+
+static int prio_tree_test_init(void)
+{
+	int i, j;
+	unsigned long results;
+	cycles_t time1, time2, time;
+
+	printk(KERN_ALERT "prio tree insert/remove");
+
+	prandom32_seed(&rnd, 3141592653589793238ULL);
+	INIT_PRIO_TREE_ROOT(&root);
+	init();
+
+	time1 = get_cycles();
+
+	for (i = 0; i < PERF_LOOPS; i++) {
+		for (j = 0; j < NODES; j++)
+			prio_tree_insert(&root, nodes + j);
+		for (j = 0; j < NODES; j++)
+			prio_tree_remove(&root, nodes + j);
+	}
+
+	time2 = get_cycles();
+	time = time2 - time1;
+
+	time = div_u64(time, PERF_LOOPS);
+	printk(" -> %llu cycles\n", (unsigned long long)time);
+
+	printk(KERN_ALERT "prio tree search");
+
+	for (j = 0; j < NODES; j++)
+		prio_tree_insert(&root, nodes + j);
+
+	time1 = get_cycles();
+
+	results = 0;
+	for (i = 0; i < SEARCH_LOOPS; i++)
+		for (j = 0; j < SEARCHES; j++)
+			results += search(queries[j], &root);
+
+	time2 = get_cycles();
+	time = time2 - time1;
+
+	time = div_u64(time, SEARCH_LOOPS);
+	results = div_u64(results, SEARCH_LOOPS);
+	printk(" -> %llu cycles (%lu results)\n",
+	       (unsigned long long)time, results);
+
+	return -EAGAIN; /* Fail will directly unload the module */
+}
+
+static void prio_tree_test_exit(void)
+{
+	printk(KERN_ALERT "test exit\n");
+}
+
+module_init(prio_tree_test_init)
+module_exit(prio_tree_test_exit)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Michel Lespinasse");
+MODULE_DESCRIPTION("Prio Tree test");
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
mm-adjust-final-endif-position-in-mm-internalh.patch
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
rbtree-add-prio-tree-and-interval-tree-tests.patch
mm-replace-vma-prio_tree-with-an-interval-tree.patch
kmemleak-use-rbtree-instead-of-prio-tree.patch
prio_tree-remove.patch
rbtree-move-augmented-rbtree-functionality-to-rbtree_augmentedh.patch

