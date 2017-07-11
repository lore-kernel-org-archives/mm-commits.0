From: akpm@linux-foundation.org
Subject: [merged] test_bitmap-add-optimisation-tests.patch removed
 from -mm tree
Date: Tue, 11 Jul 2017 12:26:19 -0700
Message-ID: <20170711192619.IrnoYsfu4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48422 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932270AbdGKT0U (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:26:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, mawilcox@microsoft.com, mm-commits@vger.kernel.org, schwidefsky@de.ibm.com, willy@infradead.org


The patch titled
     Subject: lib/test_bitmap.c: add optimisation tests
has been removed from the -mm tree.  Its filename was
     test_bitmap-add-optimisation-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: lib/test_bitmap.c: add optimisation tests

Patch series "Bitmap optimisations", v2.

These three bitmap patches use more efficient specialisations when the
compiler can figure out that it's safe to do so.  Thanks to Rasmus's eagle
eyes, a nasty bug in v1 was avoided, and I've added a test case which
would have caught it.

This patch (of 4):

This version of the test is actually a no-op; the next patch will
enable it.

Link: http://lkml.kernel.org/r/20170628153221.11322-2-willy@infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bitmap.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff -puN lib/test_bitmap.c~test_bitmap-add-optimisation-tests lib/test_bitmap.c
--- a/lib/test_bitmap.c~test_bitmap-add-optimisation-tests
+++ a/lib/test_bitmap.c
@@ -333,10 +333,42 @@ static void __init test_bitmap_u32_array
 	}
 }
 
+#define __bitmap_set(a, b, c)	bitmap_set(a, b, c)
+#define __bitmap_clear(a, b, c)	bitmap_clear(a, b, c)
+
+static void noinline __init test_mem_optimisations(void)
+{
+	DECLARE_BITMAP(bmap1, 1024);
+	DECLARE_BITMAP(bmap2, 1024);
+	unsigned int start, nbits;
+
+	for (start = 0; start < 1024; start += 8) {
+		memset(bmap1, 0x5a, sizeof(bmap1));
+		memset(bmap2, 0x5a, sizeof(bmap2));
+		for (nbits = 0; nbits < 1024 - start; nbits += 8) {
+			bitmap_set(bmap1, start, nbits);
+			__bitmap_set(bmap2, start, nbits);
+			if (!bitmap_equal(bmap1, bmap2, 1024))
+				printk("set not equal %d %d\n", start, nbits);
+			if (!__bitmap_equal(bmap1, bmap2, 1024))
+				printk("set not __equal %d %d\n", start, nbits);
+
+			bitmap_clear(bmap1, start, nbits);
+			__bitmap_clear(bmap2, start, nbits);
+			if (!bitmap_equal(bmap1, bmap2, 1024))
+				printk("clear not equal %d %d\n", start, nbits);
+			if (!__bitmap_equal(bmap1, bmap2, 1024))
+				printk("clear not __equal %d %d\n", start,
+									nbits);
+		}
+	}
+}
+
 static int __init test_bitmap_init(void)
 {
 	test_zero_fill_copy();
 	test_bitmap_u32_array_conversions();
+	test_mem_optimisations();
 
 	if (failed_tests == 0)
 		pr_info("all %u tests passed\n", total_tests);
_

Patches currently in -mm which might be from mawilcox@microsoft.com are


