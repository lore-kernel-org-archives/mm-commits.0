From: akpm@linux-foundation.org
Subject: + bitmap-clean-up-test_zero_fill_copy-test-case-and-rename.patch
 added to -mm tree
Date: Tue, 09 Jan 2018 15:25:19 -0800
Message-ID: <5a554f5f.8G+AZUEqRY4AUl1P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58494 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753895AbeAIXZU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jan 2018 18:25:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, rdunlap@infradead.org, ynorov@caviumnetworks.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_bitmap.c: clean up test_zero_fill_copy() test case and rename
has been added to the -mm tree.  Its filename is
     bitmap-clean-up-test_zero_fill_copy-test-case-and-rename.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bitmap-clean-up-test_zero_fill_copy-test-case-and-rename.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bitmap-clean-up-test_zero_fill_copy-test-case-and-rename.patch

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
Subject: lib/test_bitmap.c: clean up test_zero_fill_copy() test case and rename

Since we have separate explicit test cases for bitmap_zero() /
bitmap_clear() and bitmap_fill() / bitmap_set(), clean up
test_zero_fill_copy() to only test bitmap_copy() functionality and thus
rename a function to reflect the changes.

While here, replace bitmap_fill() by bitmap_set() with proper values.

Link: http://lkml.kernel.org/r/20180109172430.87452-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Yury Norov <ynorov@caviumnetworks.com>
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
