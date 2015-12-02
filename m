From: akpm@linux-foundation.org
Subject: [to-be-updated] lib-test_printfc-add-a-few-string-tests.patch
 removed from -mm tree
Date: Wed, 02 Dec 2015 13:25:39 -0800
Message-ID: <565f61d3.ae8EvEoaOBgEkine%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36202 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbbLBVZj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2015 16:25:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_printf.c: add a few string tests
has been removed from the -mm tree.  Its filename was
     lib-test_printfc-add-a-few-string-tests.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/test_printf.c: add a few string tests

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
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

