From: akpm@linux-foundation.org
Subject: [merged] lib-test_printfc-add-test-for-large-bitmaps.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:15:20 -0800
Message-ID: <569e9958.YaHpAoJQrG0Y55Vu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44650 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194AbcASUPV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:15:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com, joe@perches.com, keescook@chromium.org, mingo@kernel.org, mlombard@redhat.com, tj@kernel.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_printf.c: add test for large bitmaps
has been removed from the -mm tree.  Its filename was
     lib-test_printfc-add-test-for-large-bitmaps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/test_printf.c: add test for large bitmaps

Following "lib/vsprintf.c: expand field_width to 24 bits", let's add a
test to see that we now actually support bitmaps with 65536 bits.

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

 lib/test_printf.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN lib/test_printf.c~lib-test_printfc-add-test-for-large-bitmaps lib/test_printf.c
--- a/lib/test_printf.c~lib-test_printfc-add-test-for-large-bitmaps
+++ a/lib/test_printf.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 
+#include <linux/bitmap.h>
 #include <linux/socket.h>
 #include <linux/in.h>
 
@@ -341,6 +342,20 @@ struct_clk(void)
 }
 
 static void __init
+large_bitmap(void)
+{
+	const int nbits = 1 << 16;
+	unsigned long *bits = kcalloc(BITS_TO_LONGS(nbits), sizeof(long), GFP_KERNEL);
+	if (!bits)
+		return;
+
+	bitmap_set(bits, 1, 20);
+	bitmap_set(bits, 60000, 15);
+	test("1-20,60000-60014", "%*pbl", nbits, bits);
+	kfree(bits);
+}
+
+static void __init
 bitmap(void)
 {
 	DECLARE_BITMAP(bits, 20);
@@ -359,6 +374,8 @@ bitmap(void)
 	bitmap_fill(bits, 20);
 	test("fffff|fffff", "%20pb|%*pb", bits, 20, bits);
 	test("0-19|0-19", "%20pbl|%*pbl", bits, 20, bits);
+
+	large_bitmap();
 }
 
 static void __init
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header.patch
kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch
kernel-cpuc-export-__cpu__mask.patch
drivers-base-cpuc-use-__cpu__mask-directly.patch
kernel-cpuc-eliminate-cpu__mask.patch
kernel-cpuc-make-set_cpu_-static-inlines.patch

