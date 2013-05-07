From: akpm@linux-foundation.org
Subject: + lib-add-weak-clz-ctz-functions.patch added to -mm tree
Date: Tue, 07 May 2013 15:56:03 -0700
Message-ID: <20130507225603.8C07231C082@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:60989 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab3EGW4F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 18:56:05 -0400
Received: by mail-qc0-f202.google.com with SMTP id d1so122994qcz.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 15:56:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chanho.min@lge.com, djwong@us.ibm.com, geert@linux-m68k.org, herbert@gondor.hengli.com.au, kyungsik.lee@lge.com, richard@nod.at, rpearson@systemfabricworks.com, yann.collet.73@gmail.com


The patch titled
     Subject: lib: add weak clz/ctz functions
has been added to the -mm tree.  Its filename is
     lib-add-weak-clz-ctz-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-	 gcd.o lcm.o list_sort.o uuid.o flex_array.o \
+	 gcd.o lcm.o list_sort.o uuid.o flex_array.o clz_ctz.o\
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
lib-add-weak-clz-ctz-functions.patch
lib-add-lz4-compressor-module.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api.patch
crypto-add-lz4-cryptographic-api-fix.patch

