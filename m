From: akpm@linux-foundation.org
Subject: [to-be-updated] rbtree-performance-and-correctness-test.patch removed from -mm tree
Date: Fri, 13 Jul 2012 16:17:50 -0700
Message-ID: <20120713231751.99BB1200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:51462 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165Ab2GMXRy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 19:17:54 -0400
Received: by wgbdt11 with SMTP id dt11so207310wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 16:17:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, axboe@kernel.dk, daniel.santos@pobox.com, dwmw2@infradead.org, ebiederm@xmission.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rbtree: performance and correctness test
has been removed from the -mm tree.  Its filename was
     rbtree-performance-and-correctness-test.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: rbtree: performance and correctness test

This small module helps measure the performance of rbtree insert and
erase.

Additionally, we run a few correctness tests to check that the rbtrees have
all desired properties:
- contains the right number of nodes in the order desired,
- never two consecutive red nodes on any path,
- all paths to leaf nodes have the same number of black nodes,
- root node is black

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

 Makefile            |    2 
 lib/Kconfig.debug   |    1 
 tests/Kconfig       |   18 +++++
 tests/Makefile      |    1 
 tests/rbtree_test.c |  135 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 156 insertions(+), 1 deletion(-)

diff -puN Makefile~rbtree-performance-and-correctness-test Makefile
--- a/Makefile~rbtree-performance-and-correctness-test
+++ a/Makefile
@@ -715,7 +715,7 @@ export mod_strip_cmd
 
 
 ifeq ($(KBUILD_EXTMOD),)
-core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
+core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/ tests/
 
 vmlinux-dirs	:= $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
diff -puN lib/Kconfig.debug~rbtree-performance-and-correctness-test lib/Kconfig.debug
--- a/lib/Kconfig.debug~rbtree-performance-and-correctness-test
+++ a/lib/Kconfig.debug
@@ -1177,6 +1177,7 @@ config LATENCYTOP
 
 source mm/Kconfig.debug
 source kernel/trace/Kconfig
+source tests/Kconfig
 
 config PROVIDE_OHCI1394_DMA_INIT
 	bool "Remote debugging over FireWire early on boot"
diff -puN /dev/null tests/Kconfig
--- /dev/null
+++ a/tests/Kconfig
@@ -0,0 +1,18 @@
+menuconfig BENCHMARKS
+	bool "In kernel benchmarks"
+	def_bool n
+	help
+	  Includes in kernel benchmark modules in the build. These modules can
+	  be loaded later to trigger benchmarking kernel subsystems.
+	  Output will be generated in the system log.
+
+if BENCHMARKS
+
+config BENCHMARK_RBTREE
+	tristate "Red Black Tree Benchmark"
+	depends on m
+	default m
+	help
+	  A benchmark measuring the performance of the rbtree library.
+
+endif # BENCHMARKS
diff -puN /dev/null tests/Makefile
--- /dev/null
+++ a/tests/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_BENCHMARK_RBTREE) += rbtree_test.o
diff -puN /dev/null tests/rbtree_test.c
--- /dev/null
+++ a/tests/rbtree_test.c
@@ -0,0 +1,135 @@
+#include <linux/module.h>
+#include <linux/rbtree.h>
+#include <linux/random.h>
+#include <asm/timex.h>
+
+#define NODES       100
+#define PERF_LOOPS  100000
+#define CHECK_LOOPS 100
+
+struct test_node {
+	struct rb_node rb;
+	u32 key;
+};
+
+static struct rb_root root = RB_ROOT;
+static struct test_node nodes[NODES];
+
+static struct rnd_state rnd;
+
+static void insert(struct test_node *node, struct rb_root *root)
+{
+	struct rb_node **new = &root->rb_node, *parent = NULL;
+
+	while (*new) {
+		parent = *new;
+		if (node->key < rb_entry(parent, struct test_node, rb)->key)
+			new = &parent->rb_left;
+		else
+			new = &parent->rb_right;
+	}
+
+	rb_link_node(&node->rb, parent, new);
+	rb_insert_color(&node->rb, root);
+}
+
+static inline void erase(struct test_node *node, struct rb_root *root)
+{
+	rb_erase(&node->rb, root);
+}
+
+static void init(void)
+{
+	int i;
+	for (i = 0; i < NODES; i++)
+		nodes[i].key = prandom32(&rnd);
+}
+
+static bool is_red(struct rb_node *rb)
+{
+	return !(rb->__rb_parent_color & 1);
+}
+
+static int black_path_count(struct rb_node *rb)
+{
+	int count;
+	for (count = 0; rb; rb = rb_parent(rb))
+		count += !is_red(rb);
+	return count;
+}
+
+static void check(int nr_nodes)
+{
+	struct rb_node *rb;
+	int count = 0;
+	int blacks;
+	u32 prev_key = 0;
+
+	for (rb = rb_first(&root); rb; rb = rb_next(rb)) {
+		struct test_node *node = rb_entry(rb, struct test_node, rb);
+		WARN_ON_ONCE(node->key < prev_key);
+		WARN_ON_ONCE(is_red(rb) &&
+			     (!rb_parent(rb) || is_red(rb_parent(rb))));
+		if (!count)
+			blacks = black_path_count(rb);
+		else
+			WARN_ON_ONCE((!rb->rb_left || !rb->rb_right) &&
+				     blacks != black_path_count(rb));
+		prev_key = node->key;
+		count++;
+	}
+	WARN_ON_ONCE(count != nr_nodes);
+}
+
+static int rbtree_test_init(void)
+{
+	int i, j;
+	cycles_t time1, time2, time;
+
+	printk(KERN_ALERT "rbtree testing");
+
+	prandom32_seed(&rnd, 3141592653589793238);
+	init();
+
+	time1 = get_cycles();
+
+	for (i = 0; i < PERF_LOOPS; i++) {
+		for (j = 0; j < NODES; j++)
+			insert(nodes + j, &root);
+		for (j = 0; j < NODES; j++)
+			erase(nodes + j, &root);
+	}
+
+	time2 = get_cycles();
+	time = time2 - time1;
+
+	time = div_u64(time, PERF_LOOPS);
+	printk(" -> %llu cycles\n", time);
+
+	for (i = 0; i < CHECK_LOOPS; i++) {
+		init();
+		for (j = 0; j < NODES; j++) {
+			check(j);
+			insert(nodes + j, &root);
+		}
+		for (j = 0; j < NODES; j++) {
+			check(NODES - j);
+			erase(nodes + j, &root);
+		}
+		check(0);
+	}
+
+	return -EAGAIN; /* Fail will directly unload the module */
+}
+
+static void rbtree_test_exit(void)
+{
+	printk(KERN_ALERT "test exit\n");
+}
+
+module_init(rbtree_test_init)
+module_exit(rbtree_test_exit)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Michel Lespinasse");
+MODULE_DESCRIPTION("Red Black Tree test");
_

Patches currently in -mm which might be from walken@google.com are

slab-do-not-call-compound_head-in-page_get_cache.patch
rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch
rbtree-empty-nodes-have-no-color.patch
rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch
rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch
rbtree-low-level-optimizations-in-rb_insert_color.patch
rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch
rbtree-optimize-case-selection-logic-in-__rb_erase_color.patch
rbtree-low-level-optimizations-in-__rb_erase_color.patch
rbtree-coding-style-adjustments.patch

