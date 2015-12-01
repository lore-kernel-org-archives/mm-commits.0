From: akpm@linux-foundation.org
Subject: + lib-test_printfc-add-a-few-string-tests.patch added to -mm tree
Date: Tue, 01 Dec 2015 15:39:24 -0800
Message-ID: <565e2fac.xPhpeOqbX9h+cwta%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58503 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337AbbLAXjZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2015 18:39:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_printf.c: add a few string tests
has been added to the -mm tree.  Its filename is
     lib-test_printfc-add-a-few-string-tests.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-test_printfc-add-a-few-string-tests.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-test_printfc-add-a-few-string-tests.patch

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
Subject: lib/test_printf.c: add a few string tests

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_printf.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN lib/test_printf.c~lib-test_printfc-add-a-few-string-tests lib/test_printf.c
--- a/lib/test_printf.c~lib-test_printfc-add-a-few-string-tests
+++ a/lib/test_printf.c
@@ -166,6 +166,10 @@ test_string(void)
 	test("", "%s%.0s", "", "123");
 	test("ABCD|abc|123", "%s|%.3s|%.*s", "ABCD", "abcdef", 3, "123456");
 	test("1  |  2|3  |  4|5  ", "%-3s|%3s|%-*s|%*s|%*s", "1", "2", 3, "3", 3, "4", -3, "5");
+	test("1234      ", "%-10.4s", "123456");
+	test("      1234", "%10.4s", "123456");
+	/* Negative precision should be treated as 0. */
+	test("    ", "%4.*s", -5, "123456");
 	/*
 	 * POSIX and C99 say that a missing precision should be
 	 * treated as a precision of 0. However, the kernel's printf
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

