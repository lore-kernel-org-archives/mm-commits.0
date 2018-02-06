From: akpm@linux-foundation.org
Subject: [patch 037/114] lib/test_bitmap.c: add
 bitmap_zero()/bitmap_clear() test cases
Date: Tue, 06 Feb 2018 15:38:10 -0800
Message-ID: <20180206233810.0tU5KbrpA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54702 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754019AbeBFXiL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:38:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, rdunlap@infradead.org, torvalds@linux-foundation.org, ynorov@caviumnetworks.com

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/test_bitmap.c: add bitmap_zero()/bitmap_clear() test cases

Explicitly test bitmap_zero() and bitmap_clear() functions.

Link: http://lkml.kernel.org/r/20180109172430.87452-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Yury Norov <ynorov@caviumnetworks.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitmap.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff -puN lib/test_bitmap.c~bitmap-add-bitmap_zero-bitmap_clear-test-cases lib/test_bitmap.c
--- a/lib/test_bitmap.c~bitmap-add-bitmap_zero-bitmap_clear-test-cases
+++ a/lib/test_bitmap.c
@@ -105,6 +105,35 @@ __check_eq_u32_array(const char *srcfile
 #define expect_eq_pbl(...)		__expect_eq(pbl, ##__VA_ARGS__)
 #define expect_eq_u32_array(...)	__expect_eq(u32_array, ##__VA_ARGS__)
 
+static void __init test_zero_clear(void)
+{
+	DECLARE_BITMAP(bmap, 1024);
+
+	/* Known way to set all bits */
+	memset(bmap, 0xff, 128);
+
+	expect_eq_pbl("0-22", bmap, 23);
+	expect_eq_pbl("0-1023", bmap, 1024);
+
+	/* single-word bitmaps */
+	bitmap_clear(bmap, 0, 9);
+	expect_eq_pbl("9-1023", bmap, 1024);
+
+	bitmap_zero(bmap, 35);
+	expect_eq_pbl("64-1023", bmap, 1024);
+
+	/* cross boundaries operations */
+	bitmap_clear(bmap, 79, 19);
+	expect_eq_pbl("64-78,98-1023", bmap, 1024);
+
+	bitmap_zero(bmap, 115);
+	expect_eq_pbl("128-1023", bmap, 1024);
+
+	/* Zeroing entire area */
+	bitmap_zero(bmap, 1024);
+	expect_eq_pbl("", bmap, 1024);
+}
+
 static void __init test_zero_fill_copy(void)
 {
 	DECLARE_BITMAP(bmap1, 1024);
@@ -309,6 +338,7 @@ static void noinline __init test_mem_opt
 
 static int __init test_bitmap_init(void)
 {
+	test_zero_clear();
 	test_zero_fill_copy();
 	test_bitmap_arr32();
 	test_bitmap_parselist();
_
