Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11BC218AA5
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189581; cv=none; b=U9CymsaOXttPpL4v4Kz+WaPnM7jdcEUUiaufPHL/NfDmdXOHODq+3Rk/14ZU26TcyxnbNT6MUFQ1+4ah0Mj2+0pcfWGlJ+F7Dk+GiM0LSbxkrK0lDWKLXi3HV5tBZ0TBZo1iKeUjwtm20UAJC0SuQIjOp9MA0eIBy5jtRAmREk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189581; c=relaxed/simple;
	bh=3+kFnU0gwWQhGg2loRuCJkIMamOpd5MUiIy8z0Eu0EM=;
	h=Date:To:From:Subject:Message-Id; b=nvYWLrHIbgB+1VaTVnr4K5XmLVsJHZgOYEj6OjdfE48uyXJhmUllDltWrWSM0vPak7m3pGnh5FthBz4a18v4KmFH6y0nutC4har5+Ogf5FZ5cO5NAd9Eh+lZ52Tbh4T1YvjrCcjosnYlqr7/ars7psMHneVw2gbg/S7b4Zi5oDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vVCwBgiG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vVCwBgiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952E5C4CEEC;
	Mon, 17 Mar 2025 05:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189581;
	bh=3+kFnU0gwWQhGg2loRuCJkIMamOpd5MUiIy8z0Eu0EM=;
	h=Date:To:From:Subject:From;
	b=vVCwBgiGemZkeNi2GNG/od575Mzgl7Lsvytz9VP58DZHHF6SzbhlS1gEyuXEsW8/K
	 Qb27z3msLkeyoeq78Mt1rK7XcLZN52mXRRk/3qSHJL2e+SYUDJihZWiWXwXHhbq1KY
	 hdPeU7+HnXySKnFEwAdEewQTclIq10wiRnspyyCE=
Date: Sun, 16 Mar 2025 22:33:01 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,michel@lespinasse.org,jgg@nvidia.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-interval_tree-add-test-case-for-span-iteration.patch removed from -mm tree
Message-Id: <20250317053301.952E5C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/interval_tree: add test case for span iteration
has been removed from the -mm tree.  Its filename was
     lib-interval_tree-add-test-case-for-span-iteration.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: lib/interval_tree: add test case for span iteration
Date: Mon, 10 Mar 2025 07:49:36 +0000

Verify interval_tree_span_iter_xxx() helpers works as expected.

Link: https://lkml.kernel.org/r/20250310074938.26756-6-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michel Lespinasse <michel@lespinasse.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/interval_tree_test.c                  |  117 ++++++++++++++++++++
 tools/testing/rbtree/Makefile             |    6 -
 tools/testing/rbtree/interval_tree_test.c |    2 
 3 files changed, 123 insertions(+), 2 deletions(-)

--- a/lib/interval_tree_test.c~lib-interval_tree-add-test-case-for-span-iteration
+++ a/lib/interval_tree_test.c
@@ -6,6 +6,7 @@
 #include <linux/slab.h>
 #include <asm/timex.h>
 #include <linux/bitmap.h>
+#include <linux/maple_tree.h>
 
 #define __param(type, name, init, msg)		\
 	static type name = init;		\
@@ -193,6 +194,121 @@ static int intersection_range_check(void
 	return 0;
 }
 
+#ifdef CONFIG_INTERVAL_TREE_SPAN_ITER
+/*
+ * Helper function to get span of current position from maple tree point of
+ * view.
+ */
+static void mas_cur_span(struct ma_state *mas, struct interval_tree_span_iter *state)
+{
+	unsigned long cur_start;
+	unsigned long cur_last;
+	int is_hole;
+
+	if (mas->status == ma_overflow)
+		return;
+
+	/* walk to current position */
+	state->is_hole = mas_walk(mas) ? 0 : 1;
+
+	cur_start = mas->index < state->first_index ?
+			state->first_index : mas->index;
+
+	/* whether we have followers */
+	do {
+
+		cur_last = mas->last > state->last_index ?
+				state->last_index : mas->last;
+
+		is_hole = mas_next_range(mas, state->last_index) ? 0 : 1;
+
+	} while (mas->status != ma_overflow && is_hole == state->is_hole);
+
+	if (state->is_hole) {
+		state->start_hole = cur_start;
+		state->last_hole = cur_last;
+	} else {
+		state->start_used = cur_start;
+		state->last_used = cur_last;
+	}
+
+	/* advance position for next round */
+	if (mas->status != ma_overflow)
+		mas_set(mas, cur_last + 1);
+}
+
+static int span_iteration_check(void)
+{
+	int i, j, k;
+	unsigned long start, last;
+	struct interval_tree_span_iter span, mas_span;
+
+	DEFINE_MTREE(tree);
+
+	MA_STATE(mas, &tree, 0, 0);
+
+	printk(KERN_ALERT "interval tree span iteration\n");
+
+	for (i = 0; i < search_loops; i++) {
+		/* Initialize interval tree for each round */
+		init();
+		for (j = 0; j < nnodes; j++)
+			interval_tree_insert(nodes + j, &root);
+
+		/* Put all the range into maple tree */
+		mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+		mt_set_in_rcu(&tree);
+
+		for (j = 0; j < nnodes; j++)
+			WARN_ON_ONCE(mtree_store_range(&tree, nodes[j].start,
+					nodes[j].last, nodes + j, GFP_KERNEL));
+
+		/* Let's try nsearches different ranges */
+		for (k = 0; k < nsearches; k++) {
+			/* Try whole range once */
+			if (!k) {
+				start = 0UL;
+				last = ULONG_MAX;
+			} else {
+				last = (prandom_u32_state(&rnd) >> 4) % max_endpoint;
+				start = (prandom_u32_state(&rnd) >> 4) % last;
+			}
+
+			mas_span.first_index = start;
+			mas_span.last_index = last;
+			mas_span.is_hole = -1;
+			mas_set(&mas, start);
+
+			interval_tree_for_each_span(&span, &root, start, last) {
+				mas_cur_span(&mas, &mas_span);
+
+				WARN_ON_ONCE(span.is_hole != mas_span.is_hole);
+
+				if (span.is_hole) {
+					WARN_ON_ONCE(span.start_hole != mas_span.start_hole);
+					WARN_ON_ONCE(span.last_hole != mas_span.last_hole);
+				} else {
+					WARN_ON_ONCE(span.start_used != mas_span.start_used);
+					WARN_ON_ONCE(span.last_used != mas_span.last_used);
+				}
+			}
+
+		}
+
+		WARN_ON_ONCE(mas.status != ma_overflow);
+
+		/* Cleanup maple tree for each round */
+		mtree_destroy(&tree);
+		/* Cleanup interval tree for each round */
+		for (j = 0; j < nnodes; j++)
+			interval_tree_remove(nodes + j, &root);
+	}
+	return 0;
+}
+#else
+static inline int span_iteration_check(void) {return 0; }
+#endif
+
 static int interval_tree_test_init(void)
 {
 	nodes = kmalloc_array(nnodes, sizeof(struct interval_tree_node),
@@ -211,6 +327,7 @@ static int interval_tree_test_init(void)
 	basic_check();
 	search_check();
 	intersection_range_check();
+	span_iteration_check();
 
 	kfree(queries);
 	kfree(nodes);
--- a/tools/testing/rbtree/interval_tree_test.c~lib-interval_tree-add-test-case-for-span-iteration
+++ a/tools/testing/rbtree/interval_tree_test.c
@@ -6,6 +6,7 @@
 #include <linux/math64.h>
 #include <linux/kern_levels.h>
 #include "shared.h"
+#include "maple-shared.h"
 
 #include "../../../lib/interval_tree_test.c"
 
@@ -51,6 +52,7 @@ int main(int argc, char **argv)
 			usage();
 	}
 
+	maple_tree_init();
 	interval_tree_tests();
 	return 0;
 }
--- a/tools/testing/rbtree/Makefile~lib-interval_tree-add-test-case-for-span-iteration
+++ a/tools/testing/rbtree/Makefile
@@ -3,7 +3,7 @@
 .PHONY: clean
 
 TARGETS = rbtree_test interval_tree_test
-OFILES = $(LIBS) rbtree-shim.o interval_tree-shim.o
+OFILES = $(SHARED_OFILES) rbtree-shim.o interval_tree-shim.o maple-shim.o
 DEPS = ../../../include/linux/rbtree.h \
 	../../../include/linux/rbtree_types.h \
 	../../../include/linux/rbtree_augmented.h \
@@ -25,7 +25,9 @@ $(TARGETS):	$(OFILES)
 rbtree-shim.o: $(DEPS)
 rbtree_test.o:  ../../../lib/rbtree_test.c
 interval_tree-shim.o: $(DEPS)
+interval_tree-shim.o: CFLAGS += -DCONFIG_INTERVAL_TREE_SPAN_ITER
 interval_tree_test.o: 	../../../lib/interval_tree_test.c
+interval_tree_test.o: CFLAGS += -DCONFIG_INTERVAL_TREE_SPAN_ITER
 
 clean:
-	$(RM) $(TARGETS) *.o generated/*
+	$(RM) $(TARGETS) *.o radix-tree.c idr.c generated/*
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


