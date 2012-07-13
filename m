From: akpm@linux-foundation.org
Subject: + rbtree-performance-and-correctness-test.patch added to -mm tree
Date: Fri, 13 Jul 2012 16:18:35 -0700
Message-ID: <20120713231836.2FC18200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:42885 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab2GMXSk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 19:18:40 -0400
Received: by eaao13 with SMTP id o13so206881eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 16:18:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, axboe@kernel.dk, daniel.santos@pobox.com, dwmw2@infradead.org, ebiederm@xmission.com, riel@redhat.com


The patch titled
     Subject: rbtree: performance and correctness test
has been added to the -mm tree.  Its filename is
     rbtree-performance-and-correctness-test.patch

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
Subject: rbtree: performance and correctness test

This small module helps measure the performance of rbtree insert and
erase.

Additionally, we run a few correctness tests to check that the rbtrees
have all desired properties:

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

 lib/Kconfig.debug |    7 ++
 lib/Makefile      |    2 
 lib/rbtree_test.c |  135 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 144 insertions(+)

diff -puN lib/Kconfig.debug~rbtree-performance-and-correctness-test lib/Kconfig.debug
--- a/lib/Kconfig.debug~rbtree-performance-and-correctness-test
+++ a/lib/Kconfig.debug
@@ -1178,6 +1178,13 @@ config LATENCYTOP
 source mm/Kconfig.debug
 source kernel/trace/Kconfig
 
+config RBTREE_TEST
+	tristate "Red-Black tree test"
+	depends on m && DEBUG_KERNEL
+	help
+	  A benchmark measuring the performance of the rbtree library.
+	  Also includes rbtree invariant checks.
+
 config PROVIDE_OHCI1394_DMA_INIT
 	bool "Remote debugging over FireWire early on boot"
 	depends on PCI && X86
diff -puN lib/Makefile~rbtree-performance-and-correctness-test lib/Makefile
--- a/lib/Makefile~rbtree-performance-and-correctness-test
+++ a/lib/Makefile
@@ -135,6 +135,8 @@ $(foreach file, $(libfdt_files), \
 	$(eval CFLAGS_$(file) = -I$(src)/../scripts/dtc/libfdt))
 lib-$(CONFIG_LIBFDT) += $(libfdt_files)
 
+obj-$(CONFIG_RBTREE_TEST) += rbtree_test.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff -puN /dev/null lib/rbtree_test.c
--- /dev/null
+++ a/lib/rbtree_test.c
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
Subject: Subject: rbtree: performance and correctness test

Patches currently in -mm which might be from walken@google.com are

slab-do-not-call-compound_head-in-page_get_cache.patch
rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch
rbtree-empty-nodes-have-no-color.patch
rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch
rbtree-performance-and-correctness-test.patch
rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch
rbtree-low-level-optimizations-in-rb_insert_color.patch
rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch
rbtree-optimize-case-selection-logic-in-__rb_erase_color.patch
rbtree-low-level-optimizations-in-__rb_erase_color.patch
rbtree-coding-style-adjustments.patch

