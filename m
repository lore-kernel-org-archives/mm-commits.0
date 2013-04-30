From: akpm@linux-foundation.org
Subject: + lib-add-weak-__clzsi2-__clzdi2-functions.patch added to -mm tree
Date: Tue, 30 Apr 2013 12:50:15 -0700
Message-ID: <20130430195015.CE46B5A4005@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:53601 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742Ab3D3TuR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:50:17 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so94369vcb.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:50:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chanho.min@lge.com, geert@linux-m68k.org


The patch titled
     Subject: lib: add weak __clzsi2()/__clzdi2() functions
has been added to the -mm tree.  Its filename is
     lib-add-weak-__clzsi2-__clzdi2-functions.patch

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
Subject: lib: add weak __clzsi2()/__clzdi2() functions

Some architectures need __clzsi2() or __clzdi2() for __builtin_clz and It
causes build failure.  They can be implemented using the fls() and
overridden by linking arch-specific versions may not be implemented yet.

Needed by the forthcoming lz4 decompressor patches.

See https://lkml.org/lkml/2013/4/18/603

Signed-off-by: Chanho Min <chanho.min@lge.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile |    2 +-
 lib/clz.c    |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 1 deletion(-)

diff -puN lib/Makefile~lib-add-weak-__clzsi2-__clzdi2-functions lib/Makefile
--- a/lib/Makefile~lib-add-weak-__clzsi2-__clzdi2-functions
+++ a/lib/Makefile
@@ -23,7 +23,7 @@ lib-y	+= kobject.o klist.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
-	 gcd.o lcm.o list_sort.o uuid.o flex_array.o \
+	 gcd.o lcm.o list_sort.o uuid.o flex_array.o clz.o\
 	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o kfifo.o
 obj-y += string_helpers.o
 obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
diff -puN /dev/null lib/clz.c
--- /dev/null
+++ a/lib/clz.c
@@ -0,0 +1,36 @@
+/*
+ * lib/clz.c
+ *
+ * Copyright (C) 2013 Chanho Min <chanho.min@lge.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * __clzsi2/_clzdi2() can be overridden by linking arch-specific versions.
+ */
+
+#include <linux/export.h>
+#include <linux/kernel.h>
+
+int __weak __clzsi2(int val)
+{
+	return BITS_PER_LONG - fls(val);
+}
+EXPORT_SYMBOL(__clzsi2);
+
+#if BITS_PER_LONG == 32
+int __weak __clzdi2(long val)
+{
+	return BITS_PER_LONG - fls((int)val);
+}
+EXPORT_SYMBOL(__clzdi2);
+#elif BITS_PER_LONG == 64
+int __weak __clzdi2i(long val)
+{
+	return BITS_PER_LONG - fls64((u64)val);
+}
+EXPORT_SYMBOL(__clzdi2);
+#else
+#error BITS_PER_LONG not 32 or 64
+#endif
_

Patches currently in -mm which might be from chanho.min@lge.com are

origin.patch
lib-add-weak-__clzsi2-__clzdi2-functions.patch
lib-add-weak-__clzsi2-__clzdi2-functions-fix.patch
lib-add-lz4-compressor-module.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api.patch
crypto-add-lz4-cryptographic-api-fix.patch

