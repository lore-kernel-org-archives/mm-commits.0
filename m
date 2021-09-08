Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE347C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:59:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A81496115A
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:59:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347460AbhIHDAi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 23:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347322AbhIHDA1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 23:00:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6257261152;
        Wed,  8 Sep 2021 02:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069960;
        bh=L5EZfAEV3G/KJ5grdPlSxh5bWV9+WFzCSV74/50lnV8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=aUmwapReN1ODImB4CUz1RYvyJpmxMSP7ChzHfpZui8vhmRRXus8D3GhbPgn+V8QHn
         Hh2f8NbLGjbO8XeudgRdx0XqMPEs7cTT6jQDsC8dXSJEH5NwFVtI74HA587T7M5Cp9
         d4+blzrnApwkyEABN16XVQEL7V+4Nmy4JFGun764=
Date:   Tue, 07 Sep 2021 19:59:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aklimov@redhat.com, akpm@linux-foundation.org, alobakin@pm.me,
        andriy.shevchenko@linux.intel.com, dennis@kernel.org,
        jolsa@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, ulf.hansson@linaro.org,
        will@kernel.org, wsa+renesas@sang-engineering.com,
        yury.norov@gmail.com
Subject:  [patch 114/147] tools: sync tools/bitmap with mother
 linux
Message-ID: <20210908025920.9it1GswOL%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                                   |  2 +-
 tools/include/asm-generic/bitops.h            |  1 -
 tools/include/linux/bitmap.h                  |  7 +-
 .../{asm-generic/bitops => linux}/find.h      | 81 +++++++++++++++++--
 tools/lib/find_bit.c                          | 20 +++++
 5 files changed, 100 insertions(+), 11 deletions(-)
 rename tools/include/{asm-generic/bitops => linux}/find.h (63%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9b62293f7b72..b033083dbb42 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3277,8 +3277,8 @@ F:	lib/bitmap.c
 F:	lib/find_bit.c
 F:	lib/find_bit_benchmark.c
 F:	lib/test_bitmap.c
-F:	tools/include/asm-generic/bitops/find.h
 F:	tools/include/linux/bitmap.h
+F:	tools/include/linux/find.h
 F:	tools/lib/bitmap.c
 F:	tools/lib/find_bit.c
 
diff --git a/tools/include/asm-generic/bitops.h b/tools/include/asm-generic/bitops.h
index 5d2ab38965cc..9ab313e93555 100644
--- a/tools/include/asm-generic/bitops.h
+++ b/tools/include/asm-generic/bitops.h
@@ -18,7 +18,6 @@
 #include <asm-generic/bitops/fls.h>
 #include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/fls64.h>
-#include <asm-generic/bitops/find.h>
 
 #ifndef _TOOLS_LINUX_BITOPS_H_
 #error only <linux/bitops.h> can be included directly
diff --git a/tools/include/linux/bitmap.h b/tools/include/linux/bitmap.h
index 9d959bc24859..13d90b574970 100644
--- a/tools/include/linux/bitmap.h
+++ b/tools/include/linux/bitmap.h
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
 
@@ -181,4 +182,4 @@ static inline int bitmap_intersects(const unsigned long *src1,
 		return __bitmap_intersects(src1, src2, nbits);
 }
 
-#endif /* _PERF_BITOPS_H */
+#endif /* _TOOLS_LINUX_BITMAP_H */
diff --git a/tools/include/asm-generic/bitops/find.h b/tools/include/linux/find.h
similarity index 63%
rename from tools/include/asm-generic/bitops/find.h
rename to tools/include/linux/find.h
index 6481fd11012a..47e2bd6c5174 100644
--- a/tools/include/asm-generic/bitops/find.h
+++ b/tools/include/linux/find.h
@@ -1,11 +1,19 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _TOOLS_LINUX_ASM_GENERIC_BITOPS_FIND_H_
-#define _TOOLS_LINUX_ASM_GENERIC_BITOPS_FIND_H_
+#ifndef _TOOLS_LINUX_FIND_H_
+#define _TOOLS_LINUX_FIND_H_
+
+#ifndef _TOOLS_LINUX_BITMAP_H
+#error tools: only <linux/bitmap.h> can be included directly
+#endif
+
+#include <linux/bitops.h>
 
 extern unsigned long _find_next_bit(const unsigned long *addr1,
 		const unsigned long *addr2, unsigned long nbits,
 		unsigned long start, unsigned long invert, unsigned long le);
 extern unsigned long _find_first_bit(const unsigned long *addr, unsigned long size);
+extern unsigned long _find_first_and_bit(const unsigned long *addr1,
+					 const unsigned long *addr2, unsigned long size);
 extern unsigned long _find_first_zero_bit(const unsigned long *addr, unsigned long size);
 extern unsigned long _find_last_bit(const unsigned long *addr, unsigned long size);
 
@@ -96,7 +104,6 @@ unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
 #endif
 
 #ifndef find_first_bit
-
 /**
  * find_first_bit - find the first set bit in a memory region
  * @addr: The address to start the search at
@@ -116,11 +123,34 @@ unsigned long find_first_bit(const unsigned long *addr, unsigned long size)
 
 	return _find_first_bit(addr, size);
 }
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
 
-#endif /* find_first_bit */
+		return val ? __ffs(val) : size;
+	}
 
-#ifndef find_first_zero_bit
+	return _find_first_and_bit(addr1, addr2, size);
+}
+#endif
 
+#ifndef find_first_zero_bit
 /**
  * find_first_zero_bit - find the first cleared bit in a memory region
  * @addr: The address to start the search at
@@ -142,4 +172,43 @@ unsigned long find_first_zero_bit(const unsigned long *addr, unsigned long size)
 }
 #endif
 
-#endif /*_TOOLS_LINUX_ASM_GENERIC_BITOPS_FIND_H_ */
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
diff --git a/tools/lib/find_bit.c b/tools/lib/find_bit.c
index 109aa7ffcf97..ba4b8d94e004 100644
--- a/tools/lib/find_bit.c
+++ b/tools/lib/find_bit.c
@@ -96,6 +96,26 @@ unsigned long _find_first_bit(const unsigned long *addr, unsigned long size)
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
-- 
_
