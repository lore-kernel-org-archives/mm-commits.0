Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED20C179BC
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 18:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741719023; cv=none; b=Pp6J/KlF3+CTetlFl7Wj0MogE0Sk5lWgdyXymLSqI/aka9YsO0/B43NTxUoLS8etRARSmbkXT/D4KAyPDQmGMtUD+ylm8PSzMLIYiSOUcN4c0Eo0RwxCCAM2BZOh6VlJkgI3nOVfLmXEZeZPe2FHX0xUzFRopM6+u18ZdRLQr+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741719023; c=relaxed/simple;
	bh=NvecUT9KiWOTkB6pdufMDcaQ5d6qG953N5JEnOqnE30=;
	h=Date:To:From:Subject:Message-Id; b=Bo0OqMYgPkcNU/h82vIH9QGo95eBxYt6cITGVb/PZtHOzzJzgGIhydzRAhbzS5mHEUvtQbY7k4MmXalim7miGmrp44PBf0+Q2jkaNZCSbXGmRVIBlBJEhOehawFC6V+orCmoFhzRhzjKdNDAb7MJAJt5zYFY7cR0pFl0qGjO83Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ysVRwm4X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ysVRwm4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB30C4CEE9;
	Tue, 11 Mar 2025 18:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741719022;
	bh=NvecUT9KiWOTkB6pdufMDcaQ5d6qG953N5JEnOqnE30=;
	h=Date:To:From:Subject:From;
	b=ysVRwm4X3DDt2L+82BtoQRFc+JsSJi0d/jJ/GiAlsS8oUM4xu6DQg9xWa7uiG8Jv/
	 /zYcO+yJ3KrZsXGtcErzFf0TchB6U5Yjw7z6COrBLYBmPCd+vF0vEavZwf8H2fgxdo
	 fmC6PzszUciihmFKpMrTEvHsiuFsZHDgRVQv3X1Q=
Date: Tue, 11 Mar 2025 11:50:21 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,michel@lespinasse.org,jgg@nvidia.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-rbtree-enable-userland-test-suite-for-rbtree-related-data-structure.patch added to mm-nonmm-unstable branch
Message-Id: <20250311185022.5BB30C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/rbtree: enable userland test suite for rbtree related data structure
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-rbtree-enable-userland-test-suite-for-rbtree-related-data-structure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-rbtree-enable-userland-test-suite-for-rbtree-related-data-structure.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: lib/rbtree: enable userland test suite for rbtree related data structure
Date: Mon, 10 Mar 2025 07:49:32 +0000

Patch series "lib/interval_tree: add some test cases and cleanup", v2.

Since rbtree/augmented tree/interval tree share similar data structure,
besides new cases for interval tree, this patch set also does cleanup for
others.


This patch (of 7):

Currently we have some tests for rbtree related data structure, e.g. 
rbtree, augmented rbtree, interval tree, in lib/ as kernel module.

To facilitate the test and debug for those fundamental data structure,
this patch enable those tests in userland.

Link: https://lkml.kernel.org/r/20250310074938.26756-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20250310074938.26756-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michel Lespinasse <michel@lespinasse.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/asm/timex.h                          |   13 ++
 tools/include/linux/container_of.h                 |   18 +++
 tools/include/linux/kernel.h                       |   14 --
 tools/include/linux/math64.h                       |    5 +
 tools/include/linux/moduleparam.h                  |    7 +
 tools/include/linux/prandom.h                      |   51 ++++++++++
 tools/include/linux/slab.h                         |    1 
 tools/lib/slab.c                                   |   16 +++
 tools/testing/rbtree/Makefile                      |   31 ++++++
 tools/testing/rbtree/interval_tree_test.c          |   53 +++++++++++
 tools/testing/rbtree/rbtree_test.c                 |   45 +++++++++
 tools/testing/rbtree/test.h                        |    4 
 tools/testing/shared/interval_tree-shim.c          |    5 +
 tools/testing/shared/linux/interval_tree.h         |    7 +
 tools/testing/shared/linux/interval_tree_generic.h |    2 
 tools/testing/shared/linux/rbtree.h                |    8 +
 tools/testing/shared/linux/rbtree_augmented.h      |    7 +
 tools/testing/shared/linux/rbtree_types.h          |    8 +
 tools/testing/shared/rbtree-shim.c                 |    6 +
 19 files changed, 288 insertions(+), 13 deletions(-)

diff --git a/tools/include/asm/timex.h a/tools/include/asm/timex.h
new file mode 100644
--- /dev/null
+++ a/tools/include/asm/timex.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __TOOLS_LINUX_ASM_TIMEX_H
+#define __TOOLS_LINUX_ASM_TIMEX_H
+
+#include <time.h>
+
+#define cycles_t clock_t
+
+static inline cycles_t get_cycles(void)
+{
+	return clock();
+}
+#endif // __TOOLS_LINUX_ASM_TIMEX_H
diff --git a/tools/include/linux/container_of.h a/tools/include/linux/container_of.h
new file mode 100644
--- /dev/null
+++ a/tools/include/linux/container_of.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _TOOLS_LINUX_CONTAINER_OF_H
+#define _TOOLS_LINUX_CONTAINER_OF_H
+
+#ifndef container_of
+/**
+ * container_of - cast a member of a structure out to the containing structure
+ * @ptr:	the pointer to the member.
+ * @type:	the type of the container struct this is embedded in.
+ * @member:	the name of the member within the struct.
+ *
+ */
+#define container_of(ptr, type, member) ({			\
+	const typeof(((type *)0)->member) * __mptr = (ptr);	\
+	(type *)((char *)__mptr - offsetof(type, member)); })
+#endif
+
+#endif	/* _TOOLS_LINUX_CONTAINER_OF_H */
--- a/tools/include/linux/kernel.h~lib-rbtree-enable-userland-test-suite-for-rbtree-related-data-structure
+++ a/tools/include/linux/kernel.h
@@ -11,6 +11,7 @@
 #include <linux/panic.h>
 #include <endian.h>
 #include <byteswap.h>
+#include <linux/container_of.h>
 
 #ifndef UINT_MAX
 #define UINT_MAX	(~0U)
@@ -25,19 +26,6 @@
 #define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
 #endif
 
-#ifndef container_of
-/**
- * container_of - cast a member of a structure out to the containing structure
- * @ptr:	the pointer to the member.
- * @type:	the type of the container struct this is embedded in.
- * @member:	the name of the member within the struct.
- *
- */
-#define container_of(ptr, type, member) ({			\
-	const typeof(((type *)0)->member) * __mptr = (ptr);	\
-	(type *)((char *)__mptr - offsetof(type, member)); })
-#endif
-
 #ifndef max
 #define max(x, y) ({				\
 	typeof(x) _max1 = (x);			\
--- a/tools/include/linux/math64.h~lib-rbtree-enable-userland-test-suite-for-rbtree-related-data-structure
+++ a/tools/include/linux/math64.h
@@ -72,4 +72,9 @@ static inline u64 mul_u64_u64_div64(u64
 }
 #endif
 
+static inline u64 div_u64(u64 dividend, u32 divisor)
+{
+	return dividend / divisor;
+}
+
 #endif /* _LINUX_MATH64_H */
diff --git a/tools/include/linux/moduleparam.h a/tools/include/linux/moduleparam.h
new file mode 100644
--- /dev/null
+++ a/tools/include/linux/moduleparam.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _TOOLS_LINUX_MODULE_PARAMS_H
+#define _TOOLS_LINUX_MODULE_PARAMS_H
+
+#define MODULE_PARM_DESC(parm, desc)
+
+#endif // _TOOLS_LINUX_MODULE_PARAMS_H
diff --git a/tools/include/linux/prandom.h a/tools/include/linux/prandom.h
new file mode 100644
--- /dev/null
+++ a/tools/include/linux/prandom.h
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __TOOLS_LINUX_PRANDOM_H
+#define __TOOLS_LINUX_PRANDOM_H
+
+#include <linux/types.h>
+
+struct rnd_state {
+	__u32 s1, s2, s3, s4;
+};
+
+/*
+ * Handle minimum values for seeds
+ */
+static inline u32 __seed(u32 x, u32 m)
+{
+	return (x < m) ? x + m : x;
+}
+
+/**
+ * prandom_seed_state - set seed for prandom_u32_state().
+ * @state: pointer to state structure to receive the seed.
+ * @seed: arbitrary 64-bit value to use as a seed.
+ */
+static inline void prandom_seed_state(struct rnd_state *state, u64 seed)
+{
+	u32 i = ((seed >> 32) ^ (seed << 10) ^ seed) & 0xffffffffUL;
+
+	state->s1 = __seed(i,   2U);
+	state->s2 = __seed(i,   8U);
+	state->s3 = __seed(i,  16U);
+	state->s4 = __seed(i, 128U);
+}
+
+/**
+ *	prandom_u32_state - seeded pseudo-random number generator.
+ *	@state: pointer to state structure holding seeded state.
+ *
+ *	This is used for pseudo-randomness with no outside seeding.
+ *	For more random results, use get_random_u32().
+ */
+static inline u32 prandom_u32_state(struct rnd_state *state)
+{
+#define TAUSWORTHE(s, a, b, c, d) (((s & c) << d) ^ (((s << a) ^ s) >> b))
+	state->s1 = TAUSWORTHE(state->s1,  6U, 13U, 4294967294U, 18U);
+	state->s2 = TAUSWORTHE(state->s2,  2U, 27U, 4294967288U,  2U);
+	state->s3 = TAUSWORTHE(state->s3, 13U, 21U, 4294967280U,  7U);
+	state->s4 = TAUSWORTHE(state->s4,  3U, 12U, 4294967168U, 13U);
+
+	return (state->s1 ^ state->s2 ^ state->s3 ^ state->s4);
+}
+#endif // __TOOLS_LINUX_PRANDOM_H
--- a/tools/include/linux/slab.h~lib-rbtree-enable-userland-test-suite-for-rbtree-related-data-structure
+++ a/tools/include/linux/slab.h
@@ -12,6 +12,7 @@
 
 void *kmalloc(size_t size, gfp_t gfp);
 void kfree(void *p);
+void *kmalloc_array(size_t n, size_t size, gfp_t gfp);
 
 bool slab_is_available(void);
 
--- a/tools/lib/slab.c~lib-rbtree-enable-userland-test-suite-for-rbtree-related-data-structure
+++ a/tools/lib/slab.c
@@ -36,3 +36,19 @@ void kfree(void *p)
 		printf("Freeing %p to malloc\n", p);
 	free(p);
 }
+
+void *kmalloc_array(size_t n, size_t size, gfp_t gfp)
+{
+	void *ret;
+
+	if (!(gfp & __GFP_DIRECT_RECLAIM))
+		return NULL;
+
+	ret = calloc(n, size);
+	uatomic_inc(&kmalloc_nr_allocated);
+	if (kmalloc_verbose)
+		printf("Allocating %p from calloc\n", ret);
+	if (gfp & __GFP_ZERO)
+		memset(ret, 0, n * size);
+	return ret;
+}
diff --git a/tools/testing/rbtree/interval_tree_test.c a/tools/testing/rbtree/interval_tree_test.c
new file mode 100644
--- /dev/null
+++ a/tools/testing/rbtree/interval_tree_test.c
@@ -0,0 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * interval_tree.c: Userspace Interval Tree test-suite
+ * Copyright (c) 2025 Wei Yang <richard.weiyang@gmail.com>
+ */
+#include <linux/math64.h>
+#include <linux/kern_levels.h>
+#include "shared.h"
+
+#include "../../../lib/interval_tree_test.c"
+
+int usage(void)
+{
+	fprintf(stderr, "Userland interval tree test cases\n");
+	fprintf(stderr, "  -n: Number of nodes in the interval tree\n");
+	fprintf(stderr, "  -p: Number of iterations modifying the tree\n");
+	fprintf(stderr, "  -q: Number of searches to the interval tree\n");
+	fprintf(stderr, "  -s: Number of iterations searching the tree\n");
+	fprintf(stderr, "  -a: Searches will iterate all nodes in the tree\n");
+	fprintf(stderr, "  -m: Largest value for the interval's endpoint\n");
+	exit(-1);
+}
+
+void interval_tree_tests(void)
+{
+	interval_tree_test_init();
+	interval_tree_test_exit();
+}
+
+int main(int argc, char **argv)
+{
+	int opt;
+
+	while ((opt = getopt(argc, argv, "n:p:q:s:am:")) != -1) {
+		if (opt == 'n')
+			nnodes = strtoul(optarg, NULL, 0);
+		else if (opt == 'p')
+			perf_loops = strtoul(optarg, NULL, 0);
+		else if (opt == 'q')
+			nsearches = strtoul(optarg, NULL, 0);
+		else if (opt == 's')
+			search_loops = strtoul(optarg, NULL, 0);
+		else if (opt == 'a')
+			search_all = true;
+		else if (opt == 'm')
+			max_endpoint = strtoul(optarg, NULL, 0);
+		else
+			usage();
+	}
+
+	interval_tree_tests();
+	return 0;
+}
diff --git a/tools/testing/rbtree/Makefile a/tools/testing/rbtree/Makefile
new file mode 100644
--- /dev/null
+++ a/tools/testing/rbtree/Makefile
@@ -0,0 +1,31 @@
+# SPDX-License-Identifier: GPL-2.0
+
+.PHONY: clean
+
+TARGETS = rbtree_test interval_tree_test
+OFILES = $(LIBS) rbtree-shim.o interval_tree-shim.o
+DEPS = ../../../include/linux/rbtree.h \
+	../../../include/linux/rbtree_types.h \
+	../../../include/linux/rbtree_augmented.h \
+	../../../include/linux/interval_tree.h \
+	../../../include/linux/interval_tree_generic.h \
+	../../../lib/rbtree.c \
+	../../../lib/interval_tree.c
+
+targets: $(TARGETS)
+
+include ../shared/shared.mk
+
+ifeq ($(DEBUG), 1)
+	CFLAGS += -g
+endif
+
+$(TARGETS):	$(OFILES)
+
+rbtree-shim.o: $(DEPS)
+rbtree_test.o:  ../../../lib/rbtree_test.c
+interval_tree-shim.o: $(DEPS)
+interval_tree_test.o: 	../../../lib/interval_tree_test.c
+
+clean:
+	$(RM) $(TARGETS) *.o generated/*
diff --git a/tools/testing/rbtree/rbtree_test.c a/tools/testing/rbtree/rbtree_test.c
new file mode 100644
--- /dev/null
+++ a/tools/testing/rbtree/rbtree_test.c
@@ -0,0 +1,45 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * rbtree_test.c: Userspace Red Black Tree test-suite
+ * Copyright (c) 2025 Wei Yang <richard.weiyang@gmail.com>
+ */
+#include <linux/init.h>
+#include <linux/math64.h>
+#include <linux/kern_levels.h>
+#include "shared.h"
+
+#include "../../../lib/rbtree_test.c"
+
+int usage(void)
+{
+	fprintf(stderr, "Userland rbtree test cases\n");
+	fprintf(stderr, "  -n: Number of nodes in the rb-tree\n");
+	fprintf(stderr, "  -p: Number of iterations modifying the rb-tree\n");
+	fprintf(stderr, "  -c: Number of iterations modifying and verifying the rb-tree\n");
+	exit(-1);
+}
+
+void rbtree_tests(void)
+{
+	rbtree_test_init();
+	rbtree_test_exit();
+}
+
+int main(int argc, char **argv)
+{
+	int opt;
+
+	while ((opt = getopt(argc, argv, "n:p:c:")) != -1) {
+		if (opt == 'n')
+			nnodes = strtoul(optarg, NULL, 0);
+		else if (opt == 'p')
+			perf_loops = strtoul(optarg, NULL, 0);
+		else if (opt == 'c')
+			check_loops = strtoul(optarg, NULL, 0);
+		else
+			usage();
+	}
+
+	rbtree_tests();
+	return 0;
+}
diff --git a/tools/testing/rbtree/test.h a/tools/testing/rbtree/test.h
new file mode 100644
--- /dev/null
+++ a/tools/testing/rbtree/test.h
@@ -0,0 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+void rbtree_tests(void);
+void interval_tree_tests(void);
diff --git a/tools/testing/shared/interval_tree-shim.c a/tools/testing/shared/interval_tree-shim.c
new file mode 100644
--- /dev/null
+++ a/tools/testing/shared/interval_tree-shim.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Very simple shim around the interval tree. */
+
+#include "../../../lib/interval_tree.c"
diff --git a/tools/testing/shared/linux/interval_tree_generic.h a/tools/testing/shared/linux/interval_tree_generic.h
new file mode 100644
--- /dev/null
+++ a/tools/testing/shared/linux/interval_tree_generic.h
@@ -0,0 +1,2 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include "../../../../include/linux/interval_tree_generic.h"
diff --git a/tools/testing/shared/linux/interval_tree.h a/tools/testing/shared/linux/interval_tree.h
new file mode 100644
--- /dev/null
+++ a/tools/testing/shared/linux/interval_tree.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _TEST_INTERVAL_TREE_H
+#define _TEST_INTERVAL_TREE_H
+
+#include "../../../../include/linux/interval_tree.h"
+
+#endif /* _TEST_INTERVAL_TREE_H */
diff --git a/tools/testing/shared/linux/rbtree_augmented.h a/tools/testing/shared/linux/rbtree_augmented.h
new file mode 100644
--- /dev/null
+++ a/tools/testing/shared/linux/rbtree_augmented.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _TEST_RBTREE_AUGMENTED_H
+#define _TEST_RBTREE_AUGMENTED_H
+
+#include "../../../../include/linux/rbtree_augmented.h"
+
+#endif /* _TEST_RBTREE_AUGMENTED_H */
diff --git a/tools/testing/shared/linux/rbtree.h a/tools/testing/shared/linux/rbtree.h
new file mode 100644
--- /dev/null
+++ a/tools/testing/shared/linux/rbtree.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _TEST_RBTREE_H
+#define _TEST_RBTREE_H
+
+#include <linux/kernel.h>
+#include "../../../../include/linux/rbtree.h"
+
+#endif /* _TEST_RBTREE_H */
diff --git a/tools/testing/shared/linux/rbtree_types.h a/tools/testing/shared/linux/rbtree_types.h
new file mode 100644
--- /dev/null
+++ a/tools/testing/shared/linux/rbtree_types.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _TEST_RBTREE_TYPES_H
+#define _TEST_RBTREE_TYPES_H
+
+#include "../../../../include/linux/rbtree_types.h"
+
+#endif /* _TEST_RBTREE_TYPES_H */
+
diff --git a/tools/testing/shared/rbtree-shim.c a/tools/testing/shared/rbtree-shim.c
new file mode 100644
--- /dev/null
+++ a/tools/testing/shared/rbtree-shim.c
@@ -0,0 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Very simple shim around the rbtree. */
+
+#include "../../../lib/rbtree.c"
+
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mm_initc-use-round_up-to-align-movable-range.patch
mm-mm_initc-only-align-start-of-zone_movalbe-on-nodes-with-memory.patch
mm-mm_initc-use-round_up-to-calculate-usermap-size.patch
lib-rbtree-enable-userland-test-suite-for-rbtree-related-data-structure.patch
lib-rbtree-split-tests.patch
lib-rbtree-add-random-seed.patch
lib-interval_tree-add-test-case-for-interval_tree_iter_xxx-helpers.patch
lib-interval_tree-add-test-case-for-span-iteration.patch
lib-interval_tree-skip-the-check-before-go-to-the-right-subtree.patch
lib-interval_tree-fix-the-comment-of-interval_tree_span_iter_next_gap.patch

