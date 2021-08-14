Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E35ACC432BE
	for <mm-commits@archiver.kernel.org>; Sat, 14 Aug 2021 22:17:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3DCE60F51
	for <mm-commits@archiver.kernel.org>; Sat, 14 Aug 2021 22:17:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbhHNWRl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 14 Aug 2021 18:17:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:57160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229532AbhHNWRj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 14 Aug 2021 18:17:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C02260F48;
        Sat, 14 Aug 2021 22:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628979430;
        bh=wWJEuYL4DAf3FunT8cF+V3z7TkC1By7ofms7gVIhNIQ=;
        h=Date:From:To:Subject:From;
        b=pdFH13fbGiB33EwEDLreEQxjFnw5ZZGxW4dAmva42JpsYRJPIubJKYV3jPXQMma8G
         tg72qrvskPiz9A5qO4GtoQk5Ts/dVyg/f93rQIAhdwEH86vHy4qM28ReF4z5KgeJVr
         v8kxB0Aep4FucmXheumk/HTr1O+V/zxK0QAh0NSI=
Date:   Sat, 14 Aug 2021 15:17:10 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, wsa+renesas@sang-engineering.com,
        will@kernel.org, ulf.hansson@linaro.org, lkp@intel.com,
        jolsa@redhat.com, dennis@kernel.org,
        andriy.shevchenko@linux.intel.com, alobakin@pm.me,
        aklimov@redhat.com, yury.norov@gmail.com
Subject:  +
 bitops-move-find_bit__le-functions-from-leh-to-findh.patch added to -mm tree
Message-ID: <20210814221710.gw-nz%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: bitops: move find_bit_*_le functions from le.h to find.h
has been added to the -mm tree.  Its filename is
     bitops-move-find_bit__le-functions-from-leh-to-findh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/bitops-move-find_bit__le-functions-from-leh-to-findh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/bitops-move-find_bit__le-functions-from-leh-to-findh.patch

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
Subject: bitops: move find_bit_*_le functions from le.h to find.h

It's convenient to have all find_bit declarations in one place.

Link: https://lkml.kernel.org/r/20210814211713.180533-3-yury.norov@gmail.com
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

 include/asm-generic/bitops/find.h |   69 ++++++++++++++++++++++++++++
 include/asm-generic/bitops/le.h   |   64 -------------------------
 2 files changed, 69 insertions(+), 64 deletions(-)

--- a/include/asm-generic/bitops/find.h~bitops-move-find_bit__le-functions-from-leh-to-findh
+++ a/include/asm-generic/bitops/find.h
@@ -190,4 +190,73 @@ extern unsigned long find_next_clump8(un
 #define find_first_clump8(clump, bits, size) \
 	find_next_clump8((clump), (bits), (size), 0)
 
+#if defined(__LITTLE_ENDIAN)
+
+static inline unsigned long find_next_zero_bit_le(const void *addr,
+		unsigned long size, unsigned long offset)
+{
+	return find_next_zero_bit(addr, size, offset);
+}
+
+static inline unsigned long find_next_bit_le(const void *addr,
+		unsigned long size, unsigned long offset)
+{
+	return find_next_bit(addr, size, offset);
+}
+
+static inline unsigned long find_first_zero_bit_le(const void *addr,
+		unsigned long size)
+{
+	return find_first_zero_bit(addr, size);
+}
+
+#elif defined(__BIG_ENDIAN)
+
+#ifndef find_next_zero_bit_le
+static inline
+unsigned long find_next_zero_bit_le(const void *addr, unsigned
+		long size, unsigned long offset)
+{
+	if (small_const_nbits(size)) {
+		unsigned long val = *(const unsigned long *)addr;
+
+		if (unlikely(offset >= size))
+			return size;
+
+		val = swab(val) | ~GENMASK(size - 1, offset);
+		return val == ~0UL ? size : ffz(val);
+	}
+
+	return _find_next_bit(addr, NULL, size, offset, ~0UL, 1);
+}
+#endif
+
+#ifndef find_next_bit_le
+static inline
+unsigned long find_next_bit_le(const void *addr, unsigned
+		long size, unsigned long offset)
+{
+	if (small_const_nbits(size)) {
+		unsigned long val = *(const unsigned long *)addr;
+
+		if (unlikely(offset >= size))
+			return size;
+
+		val = swab(val) & GENMASK(size - 1, offset);
+		return val ? __ffs(val) : size;
+	}
+
+	return _find_next_bit(addr, NULL, size, offset, 0UL, 1);
+}
+#endif
+
+#ifndef find_first_zero_bit_le
+#define find_first_zero_bit_le(addr, size) \
+	find_next_zero_bit_le((addr), (size), 0)
+#endif
+
+#else
+#error "Please fix <asm/byteorder.h>"
+#endif
+
 #endif /*_ASM_GENERIC_BITOPS_FIND_H_ */
--- a/include/asm-generic/bitops/le.h~bitops-move-find_bit__le-functions-from-leh-to-findh
+++ a/include/asm-generic/bitops/le.h
@@ -2,83 +2,19 @@
 #ifndef _ASM_GENERIC_BITOPS_LE_H_
 #define _ASM_GENERIC_BITOPS_LE_H_
 
-#include <asm-generic/bitops/find.h>
 #include <asm/types.h>
 #include <asm/byteorder.h>
-#include <linux/swab.h>
 
 #if defined(__LITTLE_ENDIAN)
 
 #define BITOP_LE_SWIZZLE	0
 
-static inline unsigned long find_next_zero_bit_le(const void *addr,
-		unsigned long size, unsigned long offset)
-{
-	return find_next_zero_bit(addr, size, offset);
-}
-
-static inline unsigned long find_next_bit_le(const void *addr,
-		unsigned long size, unsigned long offset)
-{
-	return find_next_bit(addr, size, offset);
-}
-
-static inline unsigned long find_first_zero_bit_le(const void *addr,
-		unsigned long size)
-{
-	return find_first_zero_bit(addr, size);
-}
-
 #elif defined(__BIG_ENDIAN)
 
 #define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
 
-#ifndef find_next_zero_bit_le
-static inline
-unsigned long find_next_zero_bit_le(const void *addr, unsigned
-		long size, unsigned long offset)
-{
-	if (small_const_nbits(size)) {
-		unsigned long val = *(const unsigned long *)addr;
-
-		if (unlikely(offset >= size))
-			return size;
-
-		val = swab(val) | ~GENMASK(size - 1, offset);
-		return val == ~0UL ? size : ffz(val);
-	}
-
-	return _find_next_bit(addr, NULL, size, offset, ~0UL, 1);
-}
 #endif
 
-#ifndef find_next_bit_le
-static inline
-unsigned long find_next_bit_le(const void *addr, unsigned
-		long size, unsigned long offset)
-{
-	if (small_const_nbits(size)) {
-		unsigned long val = *(const unsigned long *)addr;
-
-		if (unlikely(offset >= size))
-			return size;
-
-		val = swab(val) & GENMASK(size - 1, offset);
-		return val ? __ffs(val) : size;
-	}
-
-	return _find_next_bit(addr, NULL, size, offset, 0UL, 1);
-}
-#endif
-
-#ifndef find_first_zero_bit_le
-#define find_first_zero_bit_le(addr, size) \
-	find_next_zero_bit_le((addr), (size), 0)
-#endif
-
-#else
-#error "Please fix <asm/byteorder.h>"
-#endif
 
 static inline int test_bit_le(int nr, const void *addr)
 {
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

