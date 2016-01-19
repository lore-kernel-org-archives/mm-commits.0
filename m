From: akpm@linux-foundation.org
Subject: [merged] lib-test_printfc-test-dentry-printing.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:15:22 -0800
Message-ID: <569e995a.cl/eUtQULJ3F+f9F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933220AbcASUPX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:15:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com, joe@perches.com, keescook@chromium.org, mingo@kernel.org, mlombard@redhat.com, tj@kernel.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_printf.c: test dentry printing
has been removed from the -mm tree.  Its filename was
     lib-test_printfc-test-dentry-printing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/test_printf.c: test dentry printing

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

 lib/test_printf.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff -puN lib/test_printf.c~lib-test_printfc-test-dentry-printing lib/test_printf.c
--- a/lib/test_printf.c~lib-test_printfc-test-dentry-printing
+++ a/lib/test_printf.c
@@ -13,6 +13,7 @@
 #include <linux/string.h>
 
 #include <linux/bitmap.h>
+#include <linux/dcache.h>
 #include <linux/socket.h>
 #include <linux/in.h>
 
@@ -326,9 +327,35 @@ uuid(void)
 	test("03020100-0504-0706-0809-0A0B0C0D0E0F", "%pUL", uuid);
 }
 
+static struct dentry test_dentry[4] __initdata = {
+	{ .d_parent = &test_dentry[0],
+	  .d_name = QSTR_INIT(test_dentry[0].d_iname, 3),
+	  .d_iname = "foo" },
+	{ .d_parent = &test_dentry[0],
+	  .d_name = QSTR_INIT(test_dentry[1].d_iname, 5),
+	  .d_iname = "bravo" },
+	{ .d_parent = &test_dentry[1],
+	  .d_name = QSTR_INIT(test_dentry[2].d_iname, 4),
+	  .d_iname = "alfa" },
+	{ .d_parent = &test_dentry[2],
+	  .d_name = QSTR_INIT(test_dentry[3].d_iname, 5),
+	  .d_iname = "romeo" },
+};
+
 static void __init
 dentry(void)
 {
+	test("foo", "%pd", &test_dentry[0]);
+	test("foo", "%pd2", &test_dentry[0]);
+
+	test("romeo", "%pd", &test_dentry[3]);
+	test("alfa/romeo", "%pd2", &test_dentry[3]);
+	test("bravo/alfa/romeo", "%pd3", &test_dentry[3]);
+	test("/bravo/alfa/romeo", "%pd4", &test_dentry[3]);
+	test("/bravo/alfa", "%pd4", &test_dentry[2]);
+
+	test("bravo/alfa  |bravo/alfa  ", "%-12pd2|%*pd2", &test_dentry[2], -12, &test_dentry[2]);
+	test("  bravo/alfa|  bravo/alfa", "%12pd2|%*pd2", &test_dentry[2], 12, &test_dentry[2]);
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

