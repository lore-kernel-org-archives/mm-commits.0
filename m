From: akpm@linux-foundation.org
Subject: [merged] lib-test_printfc-test-precision-quirks.patch removed
 from -mm tree
Date: Tue, 19 Jan 2016 12:15:12 -0800
Message-ID: <569e9950.A57ROdNnpPYpZXnk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933192AbcASUPN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:15:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com, joe@perches.com, keescook@chromium.org, mingo@kernel.org, mlombard@redhat.com, tj@kernel.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_printf.c: test precision quirks
has been removed from the -mm tree.  Its filename was
     lib-test_printfc-test-precision-quirks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/test_printf.c: test precision quirks

The kernel's printf doesn't follow the standards in a few corner cases
(which are probably mostly irrelevant). Add tests that document the
current behaviour.

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

 lib/test_printf.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff -puN lib/test_printf.c~lib-test_printfc-test-precision-quirks lib/test_printf.c
--- a/lib/test_printf.c~lib-test_printfc-test-precision-quirks
+++ a/lib/test_printf.c
@@ -166,14 +166,23 @@ test_string(void)
 	test("", "%s%.0s", "", "123");
 	test("ABCD|abc|123", "%s|%.3s|%.*s", "ABCD", "abcdef", 3, "123456");
 	test("1  |  2|3  |  4|5  ", "%-3s|%3s|%-*s|%*s|%*s", "1", "2", 3, "3", 3, "4", -3, "5");
+	test("1234      ", "%-10.4s", "123456");
+	test("      1234", "%10.4s", "123456");
 	/*
-	 * POSIX and C99 say that a missing precision should be
-	 * treated as a precision of 0. However, the kernel's printf
-	 * implementation treats this case as if the . wasn't
-	 * present. Let's add a test case documenting the current
-	 * behaviour; should anyone ever feel the need to follow the
-	 * standards more closely, this can be revisited.
+	 * POSIX and C99 say that a negative precision (which is only
+	 * possible to pass via a * argument) should be treated as if
+	 * the precision wasn't present, and that if the precision is
+	 * omitted (as in %.s), the precision should be taken to be
+	 * 0. However, the kernel's printf behave exactly opposite,
+	 * treating a negative precision as 0 and treating an omitted
+	 * precision specifier as if no precision was given.
+	 *
+	 * These test cases document the current behaviour; should
+	 * anyone ever feel the need to follow the standards more
+	 * closely, this can be revisited.
 	 */
+	test("    ", "%4.*s", -5, "123456");
+	test("123456", "%.s", "123456");
 	test("a||", "%.s|%.0s|%.*s", "a", "b", 0, "c");
 	test("a  |   |   ", "%-3.s|%-3.0s|%-3.*s", "a", "b", 0, "c");
 }
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header.patch
kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch
kernel-cpuc-export-__cpu__mask.patch
drivers-base-cpuc-use-__cpu__mask-directly.patch
kernel-cpuc-eliminate-cpu__mask.patch
kernel-cpuc-make-set_cpu_-static-inlines.patch

