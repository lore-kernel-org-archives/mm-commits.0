From: akpm@linux-foundation.org
Subject: [merged] lib-test_printfc-check-for-out-of-bound-writes.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:15:10 -0800
Message-ID: <569e994e.DyTVPH2EZd1GQZNS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44619 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933195AbcASUPL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:15:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com, joe@perches.com, keescook@chromium.org, mingo@kernel.org, mlombard@redhat.com, tj@kernel.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_printf.c: check for out-of-bound writes
has been removed from the -mm tree.  Its filename was
     lib-test_printfc-check-for-out-of-bound-writes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/test_printf.c: check for out-of-bound writes

Add a few padding bytes on either side of the test buffer, and check
that these (and the part of the buffer not used) are untouched by
vsnprintf.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Joe Perches <joe@perches.com>
Cc: Maurizio Lombardi <mlombard@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_printf.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff -puN lib/test_printf.c~lib-test_printfc-check-for-out-of-bound-writes lib/test_printf.c
--- a/lib/test_printf.c~lib-test_printfc-check-for-out-of-bound-writes
+++ a/lib/test_printf.c
@@ -16,6 +16,7 @@
 #include <linux/in.h>
 
 #define BUF_SIZE 256
+#define PAD_SIZE 16
 #define FILL_CHAR '$'
 
 #define PTR1 ((void*)0x01234567)
@@ -39,6 +40,7 @@
 static unsigned total_tests __initdata;
 static unsigned failed_tests __initdata;
 static char *test_buffer __initdata;
+static char *alloced_buffer __initdata;
 
 static int __printf(4, 0) __init
 do_test(int bufsize, const char *expect, int elen,
@@ -49,7 +51,7 @@ do_test(int bufsize, const char *expect,
 
 	total_tests++;
 
-	memset(test_buffer, FILL_CHAR, BUF_SIZE);
+	memset(alloced_buffer, FILL_CHAR, BUF_SIZE + 2*PAD_SIZE);
 	va_copy(aq, ap);
 	ret = vsnprintf(test_buffer, bufsize, fmt, aq);
 	va_end(aq);
@@ -60,8 +62,13 @@ do_test(int bufsize, const char *expect,
 		return 1;
 	}
 
+	if (memchr_inv(alloced_buffer, FILL_CHAR, PAD_SIZE)) {
+		pr_warn("vsnprintf(buf, %d, \"%s\", ...) wrote before buffer\n", bufsize, fmt);
+		return 1;
+	}
+
 	if (!bufsize) {
-		if (memchr_inv(test_buffer, FILL_CHAR, BUF_SIZE)) {
+		if (memchr_inv(test_buffer, FILL_CHAR, BUF_SIZE + PAD_SIZE)) {
 			pr_warn("vsnprintf(buf, 0, \"%s\", ...) wrote to buffer\n",
 				fmt);
 			return 1;
@@ -76,6 +83,12 @@ do_test(int bufsize, const char *expect,
 		return 1;
 	}
 
+	if (memchr_inv(test_buffer + written + 1, FILL_CHAR, BUF_SIZE + PAD_SIZE - (written + 1))) {
+		pr_warn("vsnprintf(buf, %d, \"%s\", ...) wrote beyond the nul-terminator\n",
+			bufsize, fmt);
+		return 1;
+	}
+
 	if (memcmp(test_buffer, expect, written)) {
 		pr_warn("vsnprintf(buf, %d, \"%s\", ...) wrote '%s', expected '%.*s'\n",
 			bufsize, fmt, test_buffer, written, expect);
@@ -342,16 +355,17 @@ test_pointer(void)
 static int __init
 test_printf_init(void)
 {
-	test_buffer = kmalloc(BUF_SIZE, GFP_KERNEL);
-	if (!test_buffer)
+	alloced_buffer = kmalloc(BUF_SIZE + 2*PAD_SIZE, GFP_KERNEL);
+	if (!alloced_buffer)
 		return -ENOMEM;
+	test_buffer = alloced_buffer + PAD_SIZE;
 
 	test_basic();
 	test_number();
 	test_string();
 	test_pointer();
 
-	kfree(test_buffer);
+	kfree(alloced_buffer);
 
 	if (failed_tests == 0)
 		pr_info("all %u tests passed\n", total_tests);
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header.patch
kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch
kernel-cpuc-export-__cpu__mask.patch
drivers-base-cpuc-use-__cpu__mask-directly.patch
kernel-cpuc-eliminate-cpu__mask.patch
kernel-cpuc-make-set_cpu_-static-inlines.patch

