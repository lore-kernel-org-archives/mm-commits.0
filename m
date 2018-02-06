From: akpm@linux-foundation.org
Subject: [patch 039/114] lib/test_bitmap.c: clean up
 test_zero_fill_copy() test case and rename
Date: Tue, 06 Feb 2018 15:38:17 -0800
Message-ID: <20180206233817.fBzafq2wb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54734 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754019AbeBFXiT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:38:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org, rdunlap@infradead.org, torvalds@linux-foundation.org, ynorov@caviumnetworks.com

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib/test_bitmap.c: clean up test_zero_fill_copy() test case and rename

Since we have separate explicit test cases for bitmap_zero() /
bitmap_clear() and bitmap_fill() / bitmap_set(), clean up
test_zero_fill_copy() to only test bitmap_copy() functionality and thus
rename a function to reflect the changes.

While here, replace bitmap_fill() by bitmap_set() with proper values.

Link: http://lkml.kernel.org/r/20180109172430.87452-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Yury Norov <ynorov@caviumnetworks.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitmap.c |   29 +++++------------------------
 1 file changed, 5 insertions(+), 24 deletions(-)

diff -puN lib/test_bitmap.c~bitmap-clean-up-test_zero_fill_copy-test-case-and-rename lib/test_bitmap.c
--- a/lib/test_bitmap.c~bitmap-clean-up-test_zero_fill_copy-test-case-and-rename
+++ a/lib/test_bitmap.c
@@ -163,7 +163,7 @@ static void __init test_fill_set(void)
 	expect_eq_pbl("0-1023", bmap, 1024);
 }
 
-static void __init test_zero_fill_copy(void)
+static void __init test_copy(void)
 {
 	DECLARE_BITMAP(bmap1, 1024);
 	DECLARE_BITMAP(bmap2, 1024);
@@ -172,36 +172,20 @@ static void __init test_zero_fill_copy(v
 	bitmap_zero(bmap2, 1024);
 
 	/* single-word bitmaps */
-	expect_eq_pbl("", bmap1, 23);
-
-	bitmap_fill(bmap1, 19);
-	expect_eq_pbl("0-18", bmap1, 1024);
-
+	bitmap_set(bmap1, 0, 19);
 	bitmap_copy(bmap2, bmap1, 23);
 	expect_eq_pbl("0-18", bmap2, 1024);
 
-	bitmap_fill(bmap2, 23);
-	expect_eq_pbl("0-22", bmap2, 1024);
-
+	bitmap_set(bmap2, 0, 23);
 	bitmap_copy(bmap2, bmap1, 23);
 	expect_eq_pbl("0-18", bmap2, 1024);
 
-	bitmap_zero(bmap1, 23);
-	expect_eq_pbl("", bmap1, 1024);
-
 	/* multi-word bitmaps */
-	bitmap_zero(bmap1, 1024);
-	expect_eq_pbl("", bmap1, 1024);
-
-	bitmap_fill(bmap1, 109);
-	expect_eq_pbl("0-108", bmap1, 1024);
-
+	bitmap_set(bmap1, 0, 109);
 	bitmap_copy(bmap2, bmap1, 1024);
 	expect_eq_pbl("0-108", bmap2, 1024);
 
 	bitmap_fill(bmap2, 1024);
-	expect_eq_pbl("0-1023", bmap2, 1024);
-
 	bitmap_copy(bmap2, bmap1, 1024);
 	expect_eq_pbl("0-108", bmap2, 1024);
 
@@ -216,9 +200,6 @@ static void __init test_zero_fill_copy(v
 	bitmap_fill(bmap2, 1024);
 	bitmap_copy(bmap2, bmap1, 97);  /* ... but aligned on word length */
 	expect_eq_pbl("0-108,128-1023", bmap2, 1024);
