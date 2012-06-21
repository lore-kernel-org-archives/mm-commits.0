From: akpm@linux-foundation.org
Subject: + string-introduce-memweight-fix-build-error-caused-by-memweight-introduction.patch added to -mm tree
Date: Thu, 21 Jun 2012 12:45:09 -0700
Message-ID: <20120621194509.67C41A0329@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:63276 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257Ab2FUTpL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 15:45:11 -0400
Received: by bkty5 with SMTP id y5so64010bkt.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 12:45:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, tony.luck@gmail.com


The patch titled
     Subject: string: fix build error caused by memweight() introduction
has been added to the -mm tree.  Its filename is
     string-introduce-memweight-fix-build-error-caused-by-memweight-introduction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: string: fix build error caused by memweight() introduction

Tony Luck reports a build error on the ia64 sim_defconfig:

 LD      arch/ia64/hp/sim/boot/bootloader
lib/lib.a(string.o): In function `bitmap_weight':
.../linux-next/include/linux/bitmap.h:280: undefined reference to `__bitmap_weight'

It fails because it pulls in lib/lib.a(string.o) to get some
innocuous function like strcpy() ... but it also gets
given memweight() which relies on __bitmap_weight()
which it doesn't have, because it doesn't include lib/built-in.o
(which is where bitmap.o, the definer of __bitmap_weight(), has
been linked).

This build error is introduced by the patch string-introduce-memweight.patch
in -mm tree.  Fix it by creating own file lib/memweight.c.

Reported-by: Tony Luck <tony.luck@gmail.com>
Suggested-by: Tony Luck <tony.luck@gmail.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile    |    2 +-
 lib/memweight.c |   38 ++++++++++++++++++++++++++++++++++++++
 lib/string.c    |   36 ------------------------------------
 3 files changed, 39 insertions(+), 37 deletions(-)

diff -puN lib/Makefile~string-introduce-memweight-fix-build-error-caused-by-memweight-introduction lib/Makefile
--- a/lib/Makefile~string-introduce-memweight-fix-build-error-caused-by-memweight-introduction
+++ a/lib/Makefile
@@ -22,7 +22,7 @@ lib-y	+= kobject.o klist.o
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
 	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o flex_array.o \
-	 bsearch.o find_last_bit.o find_next_bit.o llist.o
+	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o
 obj-y += kstrtox.o
 obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
 
diff -puN /dev/null lib/memweight.c
--- /dev/null
+++ a/lib/memweight.c
@@ -0,0 +1,38 @@
+#include <linux/export.h>
+#include <linux/bug.h>
+#include <linux/bitmap.h>
+
+/**
+ * memweight - count the total number of bits set in memory area
+ * @ptr: pointer to the start of the area
+ * @bytes: the size of the area
+ */
+size_t memweight(const void *ptr, size_t bytes)
+{
+	size_t ret = 0;
+	size_t longs;
+	const unsigned char *bitmap = ptr;
+
+	for (; bytes > 0 && ((unsigned long)bitmap) % sizeof(long);
+			bytes--, bitmap++)
+		ret += hweight8(*bitmap);
+
+	longs = bytes / sizeof(long);
+	if (longs) {
+		BUG_ON(longs >= INT_MAX / BITS_PER_LONG);
+		ret += bitmap_weight((unsigned long *)bitmap,
+				longs * BITS_PER_LONG);
+		bytes -= longs * sizeof(long);
+		bitmap += longs * sizeof(long);
+	}
+	/*
+	 * The reason that this last loop is distinct from the preceding
+	 * bitmap_weight() call is to compute 1-bits in the last region smaller
+	 * than sizeof(long) properly on big-endian systems.
+	 */
+	for (; bytes > 0; bytes--, bitmap++)
+		ret += hweight8(*bitmap);
+
+	return ret;
+}
+EXPORT_SYMBOL(memweight);
diff -puN lib/string.c~string-introduce-memweight-fix-build-error-caused-by-memweight-introduction lib/string.c
--- a/lib/string.c~string-introduce-memweight-fix-build-error-caused-by-memweight-introduction
+++ a/lib/string.c
@@ -26,7 +26,6 @@
 #include <linux/export.h>
 #include <linux/bug.h>
 #include <linux/errno.h>
-#include <linux/bitmap.h>
 
 #ifndef __HAVE_ARCH_STRNICMP
 /**
@@ -825,38 +824,3 @@ void *memchr_inv(const void *start, int 
 	return check_bytes8(start, value, bytes % 8);
 }
 EXPORT_SYMBOL(memchr_inv);
-
-/**
- * memweight - count the total number of bits set in memory area
- * @ptr: pointer to the start of the area
- * @bytes: the size of the area
- */
-size_t memweight(const void *ptr, size_t bytes)
-{
-	size_t ret = 0;
-	size_t longs;
-	const unsigned char *bitmap = ptr;
-
-	for (; bytes > 0 && ((unsigned long)bitmap) % sizeof(long);
-			bytes--, bitmap++)
-		ret += hweight8(*bitmap);
-
-	longs = bytes / sizeof(long);
-	if (longs) {
-		BUG_ON(longs >= INT_MAX / BITS_PER_LONG);
-		ret += bitmap_weight((unsigned long *)bitmap,
-				longs * BITS_PER_LONG);
-		bytes -= longs * sizeof(long);
-		bitmap += longs * sizeof(long);
-	}
-	/*
-	 * The reason that this last loop is distinct from the preceding
-	 * bitmap_weight() call is to compute 1-bits in the last region smaller
-	 * than sizeof(long) properly on big-endian systems.
-	 */
-	for (; bytes > 0; bytes--, bitmap++)
-		ret += hweight8(*bitmap);
