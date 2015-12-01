From: akpm@linux-foundation.org
Subject: + lib-test_printfc-add-test-for-large-bitmaps.patch added to -mm
 tree
Date: Tue, 01 Dec 2015 15:39:28 -0800
Message-ID: <565e2fb0.wFGpj6M4I4TNJb6E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337AbbLAXj3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2015 18:39:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, keescook@chromium.org, mlombard@redhat.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_printf.c: add test for large bitmaps
has been added to the -mm tree.  Its filename is
     lib-test_printfc-add-test-for-large-bitmaps.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-test_printfc-add-test-for-large-bitmaps.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-test_printfc-add-test-for-large-bitmaps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/test_printf.c: add test for large bitmaps

Following "lib/vsprintf.c: expand field_width to 24 bits", let's add a
test to see that we now actually support bitmaps with 65536 bits.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Maurizio Lombardi <mlombard@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
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
 
@@ -312,6 +313,20 @@ struct_clk(void)
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
@@ -330,6 +345,8 @@ bitmap(void)
 	bitmap_fill(bits, 20);
 	test("fffff|fffff", "%20pb|%*pb", bits, 20, bits);
 	test("0-19|0-19", "%20pbl|%*pbl", bits, 20, bits);
+
+	large_bitmap();
 }
 
 static void __init
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

lib-vsprintfc-pull-out-padding-code-from-dentry_name.patch
lib-vsprintfc-move-string-below-widen_string.patch
lib-vsprintfc-eliminate-potential-race-in-string.patch
lib-vsprintfc-expand-field_width-to-24-bits.patch
lib-vsprintfc-help-gcc-make-number-smaller.patch
lib-vsprintfc-warn-about-too-large-precisions-and-field-widths.patch
lib-test_printfc-dont-bug.patch
lib-test_printfc-check-for-out-of-bound-writes.patch
lib-test_printfc-add-a-few-string-tests.patch
lib-test_printfc-account-for-kvasprintf-tests.patch
lib-test_printfc-add-test-for-large-bitmaps.patch
lib-test_printfc-test-dentry-printing.patch
lib-kasprintfc-add-sanity-check-to-kvasprintf.patch
powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header.patch
kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch
kernel-cpuc-export-__cpu__mask.patch
drivers-base-cpuc-use-__cpu__mask-directly.patch
kernel-cpuc-eliminate-cpu__mask.patch
kernel-cpuc-make-set_cpu_-static-inlines.patch

