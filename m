From: akpm@linux-foundation.org
Subject: [folded] string-introduce-memweight-fix-build-error-caused-by-memweight-introduction.patch removed from -mm tree
Date: Mon, 30 Jul 2012 14:24:29 -0700
Message-ID: <20120730212430.25465100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:43258 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2G3VYb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jul 2012 17:24:31 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4008747obb.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jul 2012 14:24:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, tony.luck@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: string: fix build error caused by memweight() introduction
has been removed from the -mm tree.  Its filename was
     string-introduce-memweight-fix-build-error-caused-by-memweight-introduction.patch

This patch was dropped because it was folded into string-introduce-memweight.patch

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
-
-	return ret;
-}
-EXPORT_SYMBOL(memweight);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
string-introduce-memweight.patch
qnx4fs-use-memweight.patch
dm-use-memweight.patch
affs-use-memweight.patch
video-uvc-use-memweight.patch
ocfs2-use-memweight.patch
ext2-use-memweight.patch
ext3-use-memweight.patch
ext4-use-memweight.patch
revert-sched-fix-fork-error-path-to-not-crash.patch
fork-fix-error-handling-in-dup_task.patch
fault-injection-notifier-error-injection.patch
fault-injection-notifier-error-injection-doc.patch
cpu-rewrite-cpu-notifier-error-inject-module.patch
pm-pm-notifier-error-injection-module.patch
memory-memory-notifier-error-injection-module.patch
memory-memory-notifier-error-injection-module-fix.patch
powerpc-pseries-reconfig-notifier-error-injection-module.patch
fault-injection-add-selftests-for-cpu-and-memory-hotplug.patch
fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc.patch
fault-injection-add-tool-to-run-command-with-failslab-or-fail_page_alloc-doc.patch

