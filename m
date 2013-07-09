From: akpm@linux-foundation.org
Subject: [merged] lib-add-weak-clz-ctz-functions.patch removed from -mm
 tree
Date: Tue, 09 Jul 2013 16:22:19 -0700
Message-ID: <51dc9b2b.QFRImKFVDU91/M6u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab3GIXWU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:22:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yann.collet.73@gmail.com, rpearson@systemfabricworks.com, richard@nod.at, kyungsik.lee@lge.com, herbert@gondor.hengli.com.au, geert@linux-m68k.org, djwong@us.ibm.com, chanho.min@lge.com

Subject: [merged] lib-add-weak-clz-ctz-functions.patch removed from -mm tree
To: chanho.min@lge.com,djwong@us.ibm.com,geert@linux-m68k.org,herbert@gondor.hengli.com.au,kyungsik.lee@lge.com,richard@nod.at,rpearson@systemfabricworks.com,yann.collet.73@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:22:19 -0700


The patch titled
     Subject: lib: add weak clz/ctz functions
has been removed from the -mm tree.  Its filename was
     lib-add-weak-clz-ctz-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chanho Min <chanho.min@lge.com>
Subject: lib: add weak clz/ctz functions

Some architectures need __c[lt]z[sd]i2() for __builtin_c[lt]z[ll] and It
causes build failure.  They can be implemented using the fls()/__ffs() and
overridden by linking arch-specific versions may not be implemented yet.

This is required by "lib: add lz4 compressor module".

Reference: https://lkml.org/lkml/2013/4/18/603

Signed-off-by: Chanho Min <chanho.min@lge.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Bob Pearson <rpearson@systemfabricworks.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Yann Collet <yann.collet.73@gmail.com>
Cc: Kyungsik Lee <kyungsik.lee@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile  |    2 -
 lib/clz_ctz.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 1 deletion(-)

diff -puN lib/Makefile~lib-add-weak-clz-ctz-functions lib/Makefile
--- a/lib/Makefile~lib-add-weak-clz-ctz-functions
+++ a/lib/Makefile
@@ -23,7 +23,7 @@ lib-y	+= kobject.o klist.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
-	 gcd.o lcm.o list_sort.o uuid.o flex_array.o iovec.o \
+	 gcd.o lcm.o list_sort.o uuid.o flex_array.o iovec.o clz_ctz.o \
 	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o kfifo.o
 obj-y += string_helpers.o
 obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
diff -puN /dev/null lib/clz_ctz.c
--- /dev/null
+++ a/lib/clz_ctz.c
@@ -0,0 +1,58 @@
+/*
+ * lib/clz_ctz.c
+ *
+ * Copyright (C) 2013 Chanho Min <chanho.min@lge.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * __c[lt]z[sd]i2 can be overridden by linking arch-specific versions.
+ */
+
+#include <linux/export.h>
+#include <linux/kernel.h>
+
+int __weak __ctzsi2(int val)
+{
+	return __ffs(val);
+}
+EXPORT_SYMBOL(__ctzsi2);
+
+int __weak __clzsi2(int val)
+{
+	return 32 - fls(val);
+}
+EXPORT_SYMBOL(__clzsi2);
+
+#if BITS_PER_LONG == 32
+
+int __weak __clzdi2(long val)
+{
+	return 32 - fls((int)val);
+}
+EXPORT_SYMBOL(__clzdi2);
+
+int __weak __ctzdi2(long val)
+{
+	return __ffs((u32)val);
+}
+EXPORT_SYMBOL(__ctzdi2);
+
+#elif BITS_PER_LONG == 64
+
+int __weak __clzdi2(long val)
+{
+	return 64 - fls64((u64)val);
+}
+EXPORT_SYMBOL(__clzdi2);
+
+int __weak __ctzdi2(long val)
+{
+	return __ffs64((u64)val);
+}
+EXPORT_SYMBOL(__ctzdi2);
+
+#else
+#error BITS_PER_LONG not 32 or 64
+#endif
_

Patches currently in -mm which might be from chanho.min@lge.com are

origin.patch

