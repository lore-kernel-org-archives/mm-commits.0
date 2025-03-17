Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D83218AA5
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189579; cv=none; b=nAp5SgoeLp0eh4Pva2GoDi1XDzvwsPkqeEBic8+V8FGhCMZfb1bTFRaWx8vJxoFUi9TXDE4CU9k+j7c8NlKDYv4dH960Q+MicXqoDkkg2+Vi8eIJeaJjxVJkUDf8TgQ91h0jCe26vvOiXJGW2Blxpxe/9AsvMdDNPrxBOVD1Vrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189579; c=relaxed/simple;
	bh=BAPfkqQfumRoq2G0Ml6mMA4FMy6VWVyH7X+7TaOzgmg=;
	h=Date:To:From:Subject:Message-Id; b=byald62Ed5c/oIl3xHwWxFnAr4+NMk6EHgGHr57afOdNFLvxubrAiUixWgm1m49Ix//r5yPe/z8i7pT0oG2EHVqp9CpIHW0tzDNxoRUv4+PzF18/SxYZKt7024pjjX5VVB4sHieKPDT8QSLl+uYs9U9rVi8XNyOkNFxj9f625Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fBIXKaE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fBIXKaE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2516C4CEEC;
	Mon, 17 Mar 2025 05:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189578;
	bh=BAPfkqQfumRoq2G0Ml6mMA4FMy6VWVyH7X+7TaOzgmg=;
	h=Date:To:From:Subject:From;
	b=fBIXKaE5eEzvzkogYs4uOAZluyIN502X3iOruF/qznIcXS3g29vTTNdMxQU1dqPgQ
	 35YFu0kuefNmGxMZqkRWVotd5wmiWt8S7X0BbdwBxEBXWwv8Vm802HR3d9vvpKzR6D
	 sI6Cd00cC7tbw4flKd7j1FnsHiW6hq0TsNFInaHU=
Date: Sun, 16 Mar 2025 22:32:58 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,michel@lespinasse.org,jgg@nvidia.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] lib-interval_tree-add-test-case-for-interval_tree_iter_xxx-helpers.patch removed from -mm tree
Message-Id: <20250317053258.C2516C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/interval_tree: add test case for interval_tree_iter_xxx() helpers
has been removed from the -mm tree.  Its filename was
     lib-interval_tree-add-test-case-for-interval_tree_iter_xxx-helpers.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: lib/interval_tree: add test case for interval_tree_iter_xxx() helpers
Date: Mon, 10 Mar 2025 07:49:35 +0000

Verify interval_tree_iter_xxx() helpers could find intersection ranges
as expected.

[sfr@canb.auug.org.au: some of tools/ uses -Wno-unused-parameter]
  Link: https://lkml.kernel.org/r/20250312113612.31ac808e@canb.auug.org.au
Link: https://lkml.kernel.org/r/20250310074938.26756-5-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michel Lespinasse <michel@lespinasse.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/interval_tree_test.c     |   69 +++++++++++++++++++++++++++++++++
 tools/include/linux/bitmap.h |   21 ++++++++++
 tools/lib/bitmap.c           |   20 +++++++++
 3 files changed, 110 insertions(+)

--- a/lib/interval_tree_test.c~lib-interval_tree-add-test-case-for-interval_tree_iter_xxx-helpers
+++ a/lib/interval_tree_test.c
@@ -5,6 +5,7 @@
 #include <linux/prandom.h>
 #include <linux/slab.h>
 #include <asm/timex.h>
+#include <linux/bitmap.h>
 
 #define __param(type, name, init, msg)		\
 	static type name = init;		\
@@ -125,6 +126,73 @@ static int search_check(void)
 	return 0;
 }
 
+static int intersection_range_check(void)
+{
+	int i, j, k;
+	unsigned long start, last;
+	struct interval_tree_node *node;
+	unsigned long *intxn1;
+	unsigned long *intxn2;
+
+	printk(KERN_ALERT "interval tree iteration\n");
+
+	intxn1 = bitmap_alloc(nnodes, GFP_KERNEL);
+	if (!intxn1) {
+		WARN_ON_ONCE("Failed to allocate intxn1\n");
+		return -ENOMEM;
+	}
+
+	intxn2 = bitmap_alloc(nnodes, GFP_KERNEL);
+	if (!intxn2) {
+		WARN_ON_ONCE("Failed to allocate intxn2\n");
+		bitmap_free(intxn1);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < search_loops; i++) {
+		/* Initialize interval tree for each round */
+		init();
+		for (j = 0; j < nnodes; j++)
+			interval_tree_insert(nodes + j, &root);
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
+			/* Walk nodes to mark intersection nodes */
+			bitmap_zero(intxn1, nnodes);
+			for (j = 0; j < nnodes; j++) {
+				node = nodes + j;
+
+				if (start <= node->last && last >= node->start)
+					bitmap_set(intxn1, j, 1);
+			}
+
+			/* Iterate tree to clear intersection nodes */
+			bitmap_zero(intxn2, nnodes);
+			for (node = interval_tree_iter_first(&root, start, last); node;
+			     node = interval_tree_iter_next(node, start, last))
+				bitmap_set(intxn2, node - nodes, 1);
+
+			WARN_ON_ONCE(!bitmap_equal(intxn1, intxn2, nnodes));
+		}
+
+		for (j = 0; j < nnodes; j++)
+			interval_tree_remove(nodes + j, &root);
+	}
+
+	bitmap_free(intxn1);
+	bitmap_free(intxn2);
+	return 0;
+}
+
 static int interval_tree_test_init(void)
 {
 	nodes = kmalloc_array(nnodes, sizeof(struct interval_tree_node),
@@ -142,6 +210,7 @@ static int interval_tree_test_init(void)
 
 	basic_check();
 	search_check();
+	intersection_range_check();
 
 	kfree(queries);
 	kfree(nodes);
--- a/tools/include/linux/bitmap.h~lib-interval_tree-add-test-case-for-interval_tree_iter_xxx-helpers
+++ a/tools/include/linux/bitmap.h
@@ -19,6 +19,7 @@ bool __bitmap_and(unsigned long *dst, co
 		 const unsigned long *bitmap2, unsigned int bits);
 bool __bitmap_equal(const unsigned long *bitmap1,
 		    const unsigned long *bitmap2, unsigned int bits);
+void __bitmap_set(unsigned long *map, unsigned int start, int len);
 void __bitmap_clear(unsigned long *map, unsigned int start, int len);
 bool __bitmap_intersects(const unsigned long *bitmap1,
 			 const unsigned long *bitmap2, unsigned int bits);
@@ -79,6 +80,11 @@ static inline void bitmap_or(unsigned lo
 		__bitmap_or(dst, src1, src2, nbits);
 }
 
+static inline unsigned long *bitmap_alloc(unsigned int nbits, gfp_t flags __maybe_unused)
+{
+	return malloc(bitmap_size(nbits));
+}
+
 /**
  * bitmap_zalloc - Allocate bitmap
  * @nbits: Number of bits
@@ -150,6 +156,21 @@ static inline bool bitmap_intersects(con
 		return __bitmap_intersects(src1, src2, nbits);
 }
 
+static inline void bitmap_set(unsigned long *map, unsigned int start, unsigned int nbits)
+{
+	if (__builtin_constant_p(nbits) && nbits == 1)
+		__set_bit(start, map);
+	else if (small_const_nbits(start + nbits))
+		*map |= GENMASK(start + nbits - 1, start);
+	else if (__builtin_constant_p(start & BITMAP_MEM_MASK) &&
+		 IS_ALIGNED(start, BITMAP_MEM_ALIGNMENT) &&
+		 __builtin_constant_p(nbits & BITMAP_MEM_MASK) &&
+		 IS_ALIGNED(nbits, BITMAP_MEM_ALIGNMENT))
+		memset((char *)map + start / 8, 0xff, nbits / 8);
+	else
+		__bitmap_set(map, start, nbits);
+}
+
 static inline void bitmap_clear(unsigned long *map, unsigned int start,
 			       unsigned int nbits)
 {
--- a/tools/lib/bitmap.c~lib-interval_tree-add-test-case-for-interval_tree_iter_xxx-helpers
+++ a/tools/lib/bitmap.c
@@ -101,6 +101,26 @@ bool __bitmap_intersects(const unsigned
 	return false;
 }
 
+void __bitmap_set(unsigned long *map, unsigned int start, int len)
+{
+	unsigned long *p = map + BIT_WORD(start);
+	const unsigned int size = start + len;
+	int bits_to_set = BITS_PER_LONG - (start % BITS_PER_LONG);
+	unsigned long mask_to_set = BITMAP_FIRST_WORD_MASK(start);
+
+	while (len - bits_to_set >= 0) {
+		*p |= mask_to_set;
+		len -= bits_to_set;
+		bits_to_set = BITS_PER_LONG;
+		mask_to_set = ~0UL;
+		p++;
+	}
+	if (len) {
+		mask_to_set &= BITMAP_LAST_WORD_MASK(size);
+		*p |= mask_to_set;
+	}
+}
+
 void __bitmap_clear(unsigned long *map, unsigned int start, int len)
 {
 	unsigned long *p = map + BIT_WORD(start);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


