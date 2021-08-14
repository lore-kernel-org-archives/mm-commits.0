Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B18BC4338F
	for <mm-commits@archiver.kernel.org>; Sat, 14 Aug 2021 22:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D11460F4B
	for <mm-commits@archiver.kernel.org>; Sat, 14 Aug 2021 22:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbhHNWSE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Aug 2021 18:18:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233276AbhHNWSA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 14 Aug 2021 18:18:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BC7760EE0;
        Sat, 14 Aug 2021 22:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628979451;
        bh=QLRquAttMFKmv502IrFVkB726YBdk+lBv5Pf6P4R8iI=;
        h=Date:From:To:Subject:From;
        b=OalHN9aMgD+hnZF/33Bhuo5Wyk7gta1B0iO8EE+aC7LeIO7nT3b7f0McGwPFWjqdf
         hvFYQ4Z9ApiiAPzZuiHfmrStEllNdbYAJE8J0IveXkWsGlmDZmOa6WdWknXyAg4sew
         ehHRfNeMX9Ly+Pdqi69/Xnes65GPFAulhL3Eezgs=
Date:   Sat, 14 Aug 2021 15:17:31 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wsa+renesas@sang-engineering.com,
        will@kernel.org, ulf.hansson@linaro.org, lkp@intel.com,
        jolsa@redhat.com, dennis@kernel.org,
        andriy.shevchenko@linux.intel.com, alobakin@pm.me,
        aklimov@redhat.com, yury.norov@gmail.com
Subject:  + tools-sync-tools-bitmap-with-mother-linux.patch added to
 -mm tree
Message-ID: <20210814221731.azMb3%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools: sync tools/bitmap with mother linux
has been added to the -mm tree.  Its filename is
     tools-sync-tools-bitmap-with-mother-linux.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-sync-tools-bitmap-with-mother-linux.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-sync-tools-bitmap-with-mother-linux.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: tools: sync tools/bitmap with mother linux

Remove tools/include/asm-generic/bitops/find.h and copy
include/linux/bitmap.h to tools.  find_*_le() functions are not copied
because not needed in tools.

Link: https://lkml.kernel.org/r/20210814211713.180533-9-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Alexey Klimov <aklimov@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                             |    2 
 tools/include/asm-generic/bitops.h      |    1 
 tools/include/asm-generic/bitops/find.h |  145 --------------
 tools/include/linux/bitmap.h            |    7 
 tools/include/linux/find.h              |  214 ++++++++++++++++++++++
 tools/lib/find_bit.c                    |   20 ++
 6 files changed, 239 insertions(+), 150 deletions(-)

--- a/MAINTAINERS~tools-sync-tools-bitmap-with-mother-linux
+++ a/MAINTAINERS
@@ -3268,8 +3268,8 @@ F:	lib/bitmap.c
 F:	lib/find_bit.c
 F:	lib/find_bit_benchmark.c
 F:	lib/test_bitmap.c
-F:	tools/include/asm-generic/bitops/find.h
 F:	tools/include/linux/bitmap.h
+F:	tools/include/linux/find.h
 F:	tools/lib/bitmap.c
 F:	tools/lib/find_bit.c
 
--- a/tools/include/asm-generic/bitops/find.h
+++ /dev/null
@@ -1,145 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _TOOLS_LINUX_ASM_GENERIC_BITOPS_FIND_H_
-#define _TOOLS_LINUX_ASM_GENERIC_BITOPS_FIND_H_
-
-extern unsigned long _find_next_bit(const unsigned long *addr1,
-		const unsigned long *addr2, unsigned long nbits,
-		unsigned long start, unsigned long invert, unsigned long le);
-extern unsigned long _find_first_bit(const unsigned long *addr, unsigned long size);
-extern unsigned long _find_first_zero_bit(const unsigned long *addr, unsigned long size);
-extern unsigned long _find_last_bit(const unsigned long *addr, unsigned long size);
-
-#ifndef find_next_bit
-/**
- * find_next_bit - find the next set bit in a memory region
- * @addr: The address to base the search on
- * @offset: The bitnumber to start searching at
- * @size: The bitmap size in bits
- *
- * Returns the bit number for the next set bit
- * If no bits are set, returns @size.
- */
-static inline
-unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
-			    unsigned long offset)
-{
-	if (small_const_nbits(size)) {
-		unsigned long val;
-
-		if (unlikely(offset >= size))
-			return size;
-
-		val = *addr & GENMASK(size - 1, offset);
-		return val ? __ffs(val) : size;
-	}
-
-	return _find_next_bit(addr, NULL, size, offset, 0UL, 0);
-}
-#endif
-
-#ifndef find_next_and_bit
-/**
- * find_next_and_bit - find the next set bit in both memory regions
- * @addr1: The first address to base the search on
- * @addr2: The second address to base the search on
- * @offset: The bitnumber to start searching at
- * @size: The bitmap size in bits
- *
- * Returns the bit number for the next set bit
- * If no bits are set, returns @size.
- */
-static inline
-unsigned long find_next_and_bit(const unsigned long *addr1,
-		const unsigned long *addr2, unsigned long size,
-		unsigned long offset)
-{
-	if (small_const_nbits(size)) {
-		unsigned long val;
-
-		if (unlikely(offset >= size))
-			return size;
-
-		val = *addr1 & *addr2 & GENMASK(size - 1, offset);
-		return val ? __ffs(val) : size;
-	}
-
-	return _find_next_bit(addr1, addr2, size, offset, 0UL, 0);
-}
-#endif
-
-#ifndef find_next_zero_bit
-/**
- * find_next_zero_bit - find the next cleared bit in a memory region
- * @addr: The address to base the search on
- * @offset: The bitnumber to start searching at
- * @size: The bitmap size in bits
- *
- * Returns the bit number of the next zero bit
- * If no bits are zero, returns @size.
- */
-static inline
-unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
-				 unsigned long offset)
-{
-	if (small_const_nbits(size)) {
-		unsigned long val;
-
-		if (unlikely(offset >= size))
-			return size;
-
-		val = *addr | ~GENMASK(size - 1, offset);
-		return val == ~0UL ? size : ffz(val);
-	}
-
-	return _find_next_bit(addr, NULL, size, offset, ~0UL, 0);
-}
-#endif
-
-#ifndef find_first_bit
-
-/**
- * find_first_bit - find the first set bit in a memory region
- * @addr: The address to start the search at
- * @size: The maximum number of bits to search
- *
- * Returns the bit number of the first set bit.
- * If no bits are set, returns @size.
- */
-static inline
-unsigned long find_first_bit(const unsigned long *addr, unsigned long size)
-{
-	if (small_const_nbits(size)) {
-		unsigned long val = *addr & GENMASK(size - 1, 0);
-
-		return val ? __ffs(val) : size;
-	}
-
-	return _find_first_bit(addr, size);
-}
-
-#endif /* find_first_bit */
-
-#ifndef find_first_zero_bit
-
-/**
- * find_first_zero_bit - find the first cleared bit in a memory region
- * @addr: The address to start the search at
- * @size: The maximum number of bits to search
- *
- * Returns the bit number of the first cleared bit.
- * If no bits are zero, returns @size.
- */
-static inline
-unsigned long find_first_zero_bit(const unsigned long *addr, unsigned long size)
-{
-	if (small_const_nbits(size)) {
-		unsigned long val = *addr | ~GENMASK(size - 1, 0);
-
-		return val == ~0UL ? size : ffz(val);
-	}
-
-	return _find_first_zero_bit(addr, size);
-}
-#endif
-
-#endif /*_TOOLS_LINUX_ASM_GENERIC_BITOPS_FIND_H_ */
--- a/tools/include/asm-generic/bitops.h~tools-sync-tools-bitmap-with-mother-linux
+++ a/tools/include/asm-generic/bitops.h
@@ -18,7 +18,6 @@
 #include <asm-generic/bitops/fls.h>
 #include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
-#include <asm-generic/bitops/find.h>
 
 #ifndef _TOOLS_LINUX_BITOPS_H_
 #error only <linux/bitops.h> can be included directly
--- a/tools/include/linux/bitmap.h~tools-sync-tools-bitmap-with-mother-linux
+++ a/tools/include/linux/bitmap.h
@@ -1,9 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _PERF_BITOPS_H
-#define _PERF_BITOPS_H
+#ifndef _TOOLS_LINUX_BITMAP_H
+#define _TOOLS_LINUX_BITMAP_H
 
 #include <string.h>
 #include <linux/bitops.h>
+#include <linux/find.h>
 #include <stdlib.h>
 #include <linux/kernel.h>
 
@@ -181,4 +182,4 @@ static inline int bitmap_intersects(cons
 		return __bitmap_intersects(src1, src2, nbits);
 }
 
-#endif /* _PERF_BITOPS_H */
+#endif /* _TOOLS_LINUX_BITMAP_H */
--- /dev/null
+++ a/tools/include/linux/find.h
@@ -0,0 +1,214 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _TOOLS_LINUX_FIND_H_
+#define _TOOLS_LINUX_FIND_H_
+
+#ifndef _TOOLS_LINUX_BITMAP_H
+#error tools: only <linux/bitmap.h> can be included directly
+#endif
+
+#include <linux/bitops.h>
+
+extern unsigned long _find_next_bit(const unsigned long *addr1,
+		const unsigned long *addr2, unsigned long nbits,
+		unsigned long start, unsigned long invert, unsigned long le);
+extern unsigned long _find_first_bit(const unsigned long *addr, unsigned long size);
+extern unsigned long _find_first_and_bit(const unsigned long *addr1,
+					 const unsigned long *addr2, unsigned long size);
+extern unsigned long _find_first_zero_bit(const unsigned long *addr, unsigned long size);
+extern unsigned long _find_last_bit(const unsigned long *addr, unsigned long size);
+
+#ifndef find_next_bit
+/**
+ * find_next_bit - find the next set bit in a memory region
+ * @addr: The address to base the search on
+ * @offset: The bitnumber to start searching at
+ * @size: The bitmap size in bits
+ *
+ * Returns the bit number for the next set bit
+ * If no bits are set, returns @size.
+ */
+static inline
+unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
+			    unsigned long offset)
+{
+	if (small_const_nbits(size)) {
+		unsigned long val;
+
+		if (unlikely(offset >= size))
+			return size;
+
+		val = *addr & GENMASK(size - 1, offset);
+		return val ? __ffs(val) : size;
+	}
+
+	return _find_next_bit(addr, NULL, size, offset, 0UL, 0);
+}
+#endif
+
+#ifndef find_next_and_bit
+/**
+ * find_next_and_bit - find the next set bit in both memory regions
+ * @addr1: The first address to base the search on
+ * @addr2: The second address to base the search on
+ * @offset: The bitnumber to start searching at
+ * @size: The bitmap size in bits
+ *
+ * Returns the bit number for the next set bit
+ * If no bits are set, returns @size.
+ */
+static inline
+unsigned long find_next_and_bit(const unsigned long *addr1,
+		const unsigned long *addr2, unsigned long size,
+		unsigned long offset)
+{
+	if (small_const_nbits(size)) {
+		unsigned long val;
+
+		if (unlikely(offset >= size))
+			return size;
+
+		val = *addr1 & *addr2 & GENMASK(size - 1, offset);
+		return val ? __ffs(val) : size;
+	}
+
+	return _find_next_bit(addr1, addr2, size, offset, 0UL, 0);
+}
+#endif
+
+#ifndef find_next_zero_bit
+/**
+ * find_next_zero_bit - find the next cleared bit in a memory region
+ * @addr: The address to base the search on
+ * @offset: The bitnumber to start searching at
+ * @size: The bitmap size in bits
+ *
+ * Returns the bit number of the next zero bit
+ * If no bits are zero, returns @size.
+ */
+static inline
+unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
+				 unsigned long offset)
+{
+	if (small_const_nbits(size)) {
+		unsigned long val;
+
+		if (unlikely(offset >= size))
+			return size;
+
+		val = *addr | ~GENMASK(size - 1, offset);
+		return val == ~0UL ? size : ffz(val);
+	}
+
+	return _find_next_bit(addr, NULL, size, offset, ~0UL, 0);
+}
+#endif
+
+#ifndef find_first_bit
+/**
+ * find_first_bit - find the first set bit in a memory region
+ * @addr: The address to start the search at
+ * @size: The maximum number of bits to search
+ *
+ * Returns the bit number of the first set bit.
+ * If no bits are set, returns @size.
+ */
+static inline
+unsigned long find_first_bit(const unsigned long *addr, unsigned long size)
+{
+	if (small_const_nbits(size)) {
+		unsigned long val = *addr & GENMASK(size - 1, 0);
+
+		return val ? __ffs(val) : size;
+	}
+
+	return _find_first_bit(addr, size);
+}
+#endif
+
+#ifndef find_first_and_bit
+/**
+ * find_first_and_bit - find the first set bit in both memory regions
+ * @addr1: The first address to base the search on
+ * @addr2: The second address to base the search on
+ * @size: The bitmap size in bits
+ *
+ * Returns the bit number for the next set bit
+ * If no bits are set, returns @size.
+ */
+static inline
+unsigned long find_first_and_bit(const unsigned long *addr1,
+				 const unsigned long *addr2,
+				 unsigned long size)
+{
+	if (small_const_nbits(size)) {
+		unsigned long val = *addr1 & *addr2 & GENMASK(size - 1, 0);
+
+		return val ? __ffs(val) : size;
+	}
+
+	return _find_first_and_bit(addr1, addr2, size);
+}
+#endif
+
+#ifndef find_first_zero_bit
+/**
+ * find_first_zero_bit - find the first cleared bit in a memory region
+ * @addr: The address to start the search at
+ * @size: The maximum number of bits to search
+ *
+ * Returns the bit number of the first cleared bit.
+ * If no bits are zero, returns @size.
+ */
+static inline
+unsigned long find_first_zero_bit(const unsigned long *addr, unsigned long size)
+{
+	if (small_const_nbits(size)) {
+		unsigned long val = *addr | ~GENMASK(size - 1, 0);
+
+		return val == ~0UL ? size : ffz(val);
+	}
+
+	return _find_first_zero_bit(addr, size);
+}
+#endif
+
+#ifndef find_last_bit
+/**
+ * find_last_bit - find the last set bit in a memory region
+ * @addr: The address to start the search at
+ * @size: The number of bits to search
+ *
+ * Returns the bit number of the last set bit, or size.
+ */
+static inline
+unsigned long find_last_bit(const unsigned long *addr, unsigned long size)
+{
+	if (small_const_nbits(size)) {
+		unsigned long val = *addr & GENMASK(size - 1, 0);
+
+		return val ? __fls(val) : size;
+	}
+
+	return _find_last_bit(addr, size);
+}
+#endif
+
+/**
+ * find_next_clump8 - find next 8-bit clump with set bits in a memory region
+ * @clump: location to store copy of found clump
+ * @addr: address to base the search on
+ * @size: bitmap size in number of bits
+ * @offset: bit offset at which to start searching
+ *
+ * Returns the bit offset for the next set clump; the found clump value is
+ * copied to the location pointed by @clump. If no bits are set, returns @size.
+ */
+extern unsigned long find_next_clump8(unsigned long *clump,
+				      const unsigned long *addr,
+				      unsigned long size, unsigned long offset);
+
+#define find_first_clump8(clump, bits, size) \
+	find_next_clump8((clump), (bits), (size), 0)
+
+
+#endif /*__LINUX_FIND_H_ */
--- a/tools/lib/find_bit.c~tools-sync-tools-bitmap-with-mother-linux
+++ a/tools/lib/find_bit.c
@@ -96,6 +96,26 @@ unsigned long _find_first_bit(const unsi
 }
 #endif
 
+#ifndef find_first_and_bit
+/*
+ * Find the first set bit in two memory regions.
+ */
+unsigned long _find_first_and_bit(const unsigned long *addr1,
+				  const unsigned long *addr2,
+				  unsigned long size)
+{
+	unsigned long idx, val;
+
+	for (idx = 0; idx * BITS_PER_LONG < size; idx++) {
+		val = addr1[idx] & addr2[idx];
+		if (val)
+			return min(idx * BITS_PER_LONG + __ffs(val), size);
+	}
+
+	return size;
+}
+#endif
+
 #ifndef find_first_zero_bit
 /*
  * Find the first cleared bit in a memory region.
_

Patches currently in -mm which might be from yury.norov@gmail.com are

bitops-protect-find_first_zero_bit-properly.patch
bitops-move-find_bit__le-functions-from-leh-to-findh.patch
include-move-findh-from-asm_generic-to-linux.patch
arch-remove-generic_find_first_bit-entirely.patch
lib-add-find_first_and_bit.patch
cpumask-use-find_first_and_bit.patch
all-replace-find_next_zero_bit-with-find_first_zero_bit-where-appropriate.patch
tools-sync-tools-bitmap-with-mother-linux.patch
cpumask-replace-cpumask_next_-with-cpumask_first_-where-appropriate.patch
include-linux-move-for_each_bit-macros-from-bitopsh-to-findh.patch
find-micro-optimize-for_each_setclear_bit.patch
replace-for_each__bit_from-with-for_each__bit-where-appropriate.patch
mm-percpu-micro-optimize-pcpu_is_populated.patch
bitmap-unify-find_bit-operations.patch
lib-bitmap-add-performance-test-for-bitmap_print_to_pagebuf.patch
vsprintf-rework-bitmap_list_string.patch

