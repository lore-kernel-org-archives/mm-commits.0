From: akpm@linux-foundation.org
Subject: [patch 038/114] lib/test_bitmap.c: add
 bitmap_fill()/bitmap_set() test cases
Date: Tue, 06 Feb 2018 15:38:13 -0800
Message-ID: <20180206233813.uu0pdtf-2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54722 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754191AbeBFXiP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:38:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, rdunlap@infradead.org, torvalds@linux-foundation.org, ynorov@caviumnetworks.com

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/test_bitmap.c: add bitmap_fill()/bitmap_set() test cases

Explicitly test bitmap_fill() and bitmap_set() functions.

For bitmap_fill() we expect a consistent behaviour as in bitmap_zero(),
i.e.  the trailing bits will be set up to unsigned long boundary.

Link: http://lkml.kernel.org/r/20180109172430.87452-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Yury Norov <ynorov@caviumnetworks.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitmap.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff -puN lib/test_bitmap.c~bitmap-add-bitmap_fill-bitmap_set-test-cases lib/test_bitmap.c
--- a/lib/test_bitmap.c~bitmap-add-bitmap_fill-bitmap_set-test-cases
+++ a/lib/test_bitmap.c
@@ -134,6 +134,35 @@ static void __init test_zero_clear(void)
 	expect_eq_pbl("", bmap, 1024);
 }
 
+static void __init test_fill_set(void)
+{
+	DECLARE_BITMAP(bmap, 1024);
+
+	/* Known way to clear all bits */
+	memset(bmap, 0x00, 128);
+
+	expect_eq_pbl("", bmap, 23);
+	expect_eq_pbl("", bmap, 1024);
+
+	/* single-word bitmaps */
+	bitmap_set(bmap, 0, 9);
+	expect_eq_pbl("0-8", bmap, 1024);
+
+	bitmap_fill(bmap, 35);
+	expect_eq_pbl("0-63", bmap, 1024);
+
+	/* cross boundaries operations */
+	bitmap_set(bmap, 79, 19);
+	expect_eq_pbl("0-63,79-97", bmap, 1024);
+
+	bitmap_fill(bmap, 115);
+	expect_eq_pbl("0-127", bmap, 1024);
+
+	/* Zeroing entire area */
+	bitmap_fill(bmap, 1024);
+	expect_eq_pbl("0-1023", bmap, 1024);
+}
+
 static void __init test_zero_fill_copy(void)
 {
 	DECLARE_BITMAP(bmap1, 1024);
@@ -339,6 +368,7 @@ static void noinline __init test_mem_opt
 static int __init test_bitmap_init(void)
 {
 	test_zero_clear();
+	test_fill_set();
 	test_zero_fill_copy();
 	test_bitmap_arr32();
 	test_bitmap_parselist();
_
