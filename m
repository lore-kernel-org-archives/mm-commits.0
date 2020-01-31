From: akpm@linux-foundation.org
Subject: [merged]
 uapi-rename-ext2_swab-to-swab-and-share-globally-in-swabh.patch removed
 from -mm tree
Date: Fri, 31 Jan 2020 15:20:33 -0800
Message-ID: <20200131232033.k--YSbS8Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXUe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:20:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: allison@lohutok.net, joe@perches.com, mm-commits@vger.kernel.org, tglx@linutronix.de, vilhelm.gray@gmail.com, yury.norov@gmail.com


The patch titled
     Subject: uapi: rename ext2_swab() to swab() and share globally in swab.h
has been removed from the -mm tree.  Its filename was
     uapi-rename-ext2_swab-to-swab-and-share-globally-in-swabh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yury Norov <yury.norov@gmail.com>
Subject: uapi: rename ext2_swab() to swab() and share globally in swab.h

ext2_swab() is defined locally in lib/find_bit.c However it is not specific
to ext2, neither to bitmaps.

There are many potential users of it, so rename it to just swab() and move
to include/uapi/linux/swab.h

ABI guarantees that size of unsigned long corresponds to BITS_PER_LONG,
therefore drop unneeded cast.

Link: http://lkml.kernel.org/r/20200103202846.21616-1-yury.norov@gmail.com
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Cc: Allison Randal <allison@lohutok.net>
Cc: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: William Breathitt Gray <vilhelm.gray@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swab.h      |    1 +
 include/uapi/linux/swab.h |   10 ++++++++++
 lib/find_bit.c            |   16 ++--------------
 3 files changed, 13 insertions(+), 14 deletions(-)

--- a/include/linux/swab.h~uapi-rename-ext2_swab-to-swab-and-share-globally-in-swabh
+++ a/include/linux/swab.h
@@ -7,6 +7,7 @@
 # define swab16 __swab16
 # define swab32 __swab32
 # define swab64 __swab64
+# define swab __swab
 # define swahw32 __swahw32
 # define swahb32 __swahb32
 # define swab16p __swab16p
--- a/include/uapi/linux/swab.h~uapi-rename-ext2_swab-to-swab-and-share-globally-in-swabh
+++ a/include/uapi/linux/swab.h
@@ -4,6 +4,7 @@
 
 #include <linux/types.h>
 #include <linux/compiler.h>
+#include <asm/bitsperlong.h>
 #include <asm/swab.h>
 
 /*
@@ -132,6 +133,15 @@ static inline __attribute_const__ __u32
 	__fswab64(x))
 #endif
 
+static __always_inline unsigned long __swab(const unsigned long y)
+{
+#if BITS_PER_LONG == 64
+	return __swab64(y);
+#else /* BITS_PER_LONG == 32 */
+	return __swab32(y);
+#endif
+}
+
 /**
  * __swahw32 - return a word-swapped 32-bit value
  * @x: value to wordswap
--- a/lib/find_bit.c~uapi-rename-ext2_swab-to-swab-and-share-globally-in-swabh
+++ a/lib/find_bit.c
@@ -149,18 +149,6 @@ EXPORT_SYMBOL(find_last_bit);
 
 #ifdef __BIG_ENDIAN
 
-/* include/linux/byteorder does not support "unsigned long" type */
-static inline unsigned long ext2_swab(const unsigned long y)
-{
-#if BITS_PER_LONG == 64
-	return (unsigned long) __swab64((u64) y);
-#elif BITS_PER_LONG == 32
-	return (unsigned long) __swab32((u32) y);
-#else
-#error BITS_PER_LONG not defined
-#endif
-}
-
 #if !defined(find_next_bit_le) || !defined(find_next_zero_bit_le)
 static inline unsigned long _find_next_bit_le(const unsigned long *addr1,
 		const unsigned long *addr2, unsigned long nbits,
@@ -177,7 +165,7 @@ static inline unsigned long _find_next_b
 	tmp ^= invert;
 
 	/* Handle 1st word. */
-	tmp &= ext2_swab(BITMAP_FIRST_WORD_MASK(start));
+	tmp &= swab(BITMAP_FIRST_WORD_MASK(start));
 	start = round_down(start, BITS_PER_LONG);
 
 	while (!tmp) {
@@ -191,7 +179,7 @@ static inline unsigned long _find_next_b
 		tmp ^= invert;
 	}
 
-	return min(start + __ffs(ext2_swab(tmp)), nbits);
+	return min(start + __ffs(swab(tmp)), nbits);
 }
 #endif
 
_

Patches currently in -mm which might be from yury.norov@gmail.com are

lib-string-add-strnchrnul.patch
bitops-more-bits_to_-macros.patch
lib-add-test-for-bitmap_parse.patch
lib-add-test-for-bitmap_parse-fix.patch
lib-make-bitmap_parse_user-a-wrapper-on-bitmap_parse.patch
lib-rework-bitmap_parse.patch
lib-new-testcases-for-bitmap_parse_user.patch
cpumask-dont-calculate-length-of-the-input-string.patch
