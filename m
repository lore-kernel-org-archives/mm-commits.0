From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 100/118] uapi: rename ext2_swab() to swab() and
 share globally in swab.h
Date: Thu, 30 Jan 2020 22:16:40 -0800
Message-ID: <20200131061640.uoh5g0QMM%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgAaGQm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:16:42 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, allison@lohutok.net, joe@perches.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org, vilhelm.gray@gmail.com, yury.norov@gmail.com

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
