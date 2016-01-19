From: akpm@linux-foundation.org
Subject: [merged] lib-test_printfc-add-a-few-number-tests.patch removed
 from -mm tree
Date: Tue, 19 Jan 2016 12:15:15 -0800
Message-ID: <569e9953.JBhFIK2HTJCeg54a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44635 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933212AbcASUPQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:15:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com, joe@perches.com, keescook@chromium.org, mingo@kernel.org, mlombard@redhat.com, tj@kernel.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_printf.c: add a few number() tests
has been removed from the -mm tree.  Its filename was
     lib-test_printfc-add-a-few-number-tests.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/test_printf.c: add a few number() tests

This adds a few tests to test_number, one of which serves to document
another deviation from POSIX/C99 (printing 0 with an explicit
precision of 0).

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Maurizio Lombardi <mlombard@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_printf.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN lib/test_printf.c~lib-test_printfc-add-a-few-number-tests lib=
/test_printf.c
--- a/lib/test_printf.c~lib-test_printfc-add-a-few-number-tests
+++ a/lib/test_printf.c
@@ -158,6 +158,30 @@ test_number(void)
 	test("0x1234abcd  ", "%#-12x", 0x1234abcd);
 	test("  0x1234abcd", "%#12x", 0x1234abcd);
 	test("0|001| 12|+123| 1234|-123|-1234", "%d|%03d|%3d|%+d|% d|%+d|% d"=
, 0, 1, 12, 123, 1234, -123, -1234);
+	test("0|1|1|128|255", "%hhu|%hhu|%hhu|%hhu|%hhu", 0, 1, 257, 128, -1)=
;
+	test("0|1|1|-128|-1", "%hhd|%hhd|%hhd|%hhd|%hhd", 0, 1, 257, 128, -1)=
;
+	test("2015122420151225", "%ho%ho%#ho", 1037, 5282, -11627);
+	/*
+	 * POSIX/C99: =C2=BBThe result of converting zero with an explicit
+	 * precision of zero shall be no characters.=C2=AB Hence the output
+	 * from the below test should really be "00|0||| ". However,
+	 * the kernel's printf also produces a single 0 in that
+	 * case. This test case simply documents the current
+	 * behaviour.
+	 */
+	test("00|0|0|0|0", "%.2d|%.1d|%.0d|%.*d|%1.0d", 0, 0, 0, 0, 0, 0);
+#ifndef __CHAR_UNSIGNED__
+	{
+		/*
+		 * Passing a 'char' to a %02x specifier doesn't do
+		 * what was presumably the intention when char is
+		 * signed and the value is negative. One must either &
+		 * with 0xff or cast to u8.
+		 */
+		char val =3D -16;
+		test("0xfffffff0|0xf0|0xf0", "%#02x|%#02x|%#02x", val, val & 0xff, (=
u8)val);
+	}
+#endif
 }
=20
 static void __init
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk a=
re

powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_inf=
o_header.patch
kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch
kernel-cpuc-export-__cpu__mask.patch
drivers-base-cpuc-use-__cpu__mask-directly.patch
kernel-cpuc-eliminate-cpu__mask.patch
kernel-cpuc-make-set_cpu_-static-inlines.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
