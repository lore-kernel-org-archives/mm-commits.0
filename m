From: akpm@linux-foundation.org
Subject: [to-be-updated] lib-test_printfc-test-dentry-printing.patch
 removed from -mm tree
Date: Wed, 02 Dec 2015 13:25:45 -0800
Message-ID: <565f61d9.mTxwiGCJoBiJOQqd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36208 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073AbbLBVZp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2015 16:25:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_printf.c: test dentry printing
has been removed from the -mm tree.  Its filename was
     lib-test_printfc-test-dentry-printing.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/test_printf.c: test dentry printing

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
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
 
@@ -297,9 +298,35 @@ uuid(void)
 	test("03020100-0504-0706-0809-0A0B0C0D0E0F", "%pUL", uuid);
 }
 
+static struct dentry test_dentry[4] __initdata = {
+	{ .d_parent = &test_dentry[0],
+	  .d_name = { .len = 3, .name = test_dentry[0].d_iname },
+	  .d_iname = "foo" },
+	{ .d_parent = &test_dentry[0],
+	  .d_name = { .len = 5, .name = test_dentry[1].d_iname },
+	  .d_iname = "bravo" },
+	{ .d_parent = &test_dentry[1],
+	  .d_name = { .len = 4, .name = test_dentry[2].d_iname },
+	  .d_iname = "alfa" },
+	{ .d_parent = &test_dentry[2],
+	  .d_name = { .len = 5, .name = test_dentry[3].d_iname },
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

lib-kasprintfc-add-sanity-check-to-kvasprintf.patch
powerpc-fadump-rename-cpu_online_mask-member-of-struct-fadump_crash_info_header.patch
kernel-cpuc-change-type-of-cpu_possible_bits-and-friends.patch
kernel-cpuc-export-__cpu__mask.patch
drivers-base-cpuc-use-__cpu__mask-directly.patch
kernel-cpuc-eliminate-cpu__mask.patch
kernel-cpuc-make-set_cpu_-static-inlines.patch

