From: akpm@linux-foundation.org
Subject: + bitmap-add-bitmap_zero-bitmap_clear-test-cases.patch added to
 -mm tree
Date: Tue, 09 Jan 2018 15:25:13 -0800
Message-ID: <5a554f59.CsCF/ujTW/EjynLO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58466 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753895AbeAIXZO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jan 2018 18:25:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, rdunlap@infradead.org, ynorov@caviumnetworks.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_bitmap.c: add bitmap_zero()/bitmap_clear() test cases
has been added to the -mm tree.  Its filename is
     bitmap-add-bitmap_zero-bitmap_clear-test-cases.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitmap-add-bitmap_zero-bitmap_clear-test-cases.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitmap-add-bitmap_zero-bitmap_clear-test-cases.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/test_bitmap.c: add bitmap_zero()/bitmap_clear() test cases

Explicitly test bitmap_zero() and bitmap_clear() functions.

Link: http://lkml.kernel.org/r/20180109172430.87452-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yury Norov <ynorov@caviumnetworks.com>
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

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

scripts-decodecode-make-it-take-multiline-code-line.patch
bitmap-add-bitmap_zero-bitmap_clear-test-cases.patch
bitmap-add-bitmap_fill-bitmap_set-test-cases.patch
bitmap-clean-up-test_zero_fill_copy-test-case-and-rename.patch
bitmap-make-bitmap_fill-and-bitmap_zero-consistent.patch

