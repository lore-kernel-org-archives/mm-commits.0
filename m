From: akpm@linux-foundation.org
Subject: [merged]
 lib-test-string_helpersc-fix-and-improve-string_get_size-tests.patch
 removed from -mm tree
Date: Wed, 03 Feb 2016 13:52:59 -0800
Message-ID: <56b276bb.wsinTmZN7KsXg56i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42051 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130AbcBCVxA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2016 16:53:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, JBottomley@Odin.com, James.Bottomley@HansenPartnership.com, andriy.shevchenko@linux.intel.com, jejb@parisc-linux.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test-string_helpers.c: fix and improve string_get_size() tests
has been removed from the -mm tree.  Its filename was
     lib-test-string_helpersc-fix-and-improve-string_get_size-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: lib/test-string_helpers.c: fix and improve string_get_size() tests

Recently added 564b026fbd0d28e9 ("string_helpers: fix precision loss for
some inputs") fixed precision issues for string_get_size() and broke
tests.  Fix and improve them: test both STRING_UNITS_2 and STRING_UNITS_10
at a time, better failure reporting, test small an huge values.

Fixes: 564b026fbd0d28e9 ("string_helpers: fix precision loss for some inputs")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: James Bottomley <JBottomley@Odin.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test-string_helpers.c |   67 ++++++++++++++++++++++++++----------
 1 file changed, 49 insertions(+), 18 deletions(-)

diff -puN lib/test-string_helpers.c~lib-test-string_helpersc-fix-and-improve-string_get_size-tests lib/test-string_helpers.c
--- a/lib/test-string_helpers.c~lib-test-string_helpersc-fix-and-improve-string_get_size-tests
+++ a/lib/test-string_helpers.c
@@ -327,36 +327,67 @@ out:
 }
 
 #define string_get_size_maxbuf 16
-#define test_string_get_size_one(size, blk_size, units, exp_result)            \
+#define test_string_get_size_one(size, blk_size, exp_result10, exp_result2)    \
 	do {                                                                   \
-		BUILD_BUG_ON(sizeof(exp_result) >= string_get_size_maxbuf);    \
-		__test_string_get_size((size), (blk_size), (units),            \
-				       (exp_result));                          \
+		BUILD_BUG_ON(sizeof(exp_result10) >= string_get_size_maxbuf);  \
+		BUILD_BUG_ON(sizeof(exp_result2) >= string_get_size_maxbuf);   \
+		__test_string_get_size((size), (blk_size), (exp_result10),     \
+				       (exp_result2));                         \
 	} while (0)
 
 
-static __init void __test_string_get_size(const u64 size, const u64 blk_size,
-					  const enum string_size_units units,
-					  const char *exp_result)
+static __init void test_string_get_size_check(const char *units,
+					      const char *exp,
+					      char *res,
+					      const u64 size,
+					      const u64 blk_size)
 {
-	char buf[string_get_size_maxbuf];
-
-	string_get_size(size, blk_size, units, buf, sizeof(buf));
-	if (!memcmp(buf, exp_result, strlen(exp_result) + 1))
+	if (!memcmp(res, exp, strlen(exp) + 1))
 		return;
 
-	buf[sizeof(buf) - 1] = '\0';
-	pr_warn("Test 'test_string_get_size_one' failed!\n");
-	pr_warn("string_get_size(size = %llu, blk_size = %llu, units = %d\n",
+	res[string_get_size_maxbuf - 1] = '\0';
+
+	pr_warn("Test 'test_string_get_size' failed!\n");
+	pr_warn("string_get_size(size = %llu, blk_size = %llu, units = %s)\n",
 		size, blk_size, units);
-	pr_warn("expected: '%s', got '%s'\n", exp_result, buf);
+	pr_warn("expected: '%s', got '%s'\n", exp, res);
+}
+
+static __init void __test_string_get_size(const u64 size, const u64 blk_size,
+					  const char *exp_result10,
+					  const char *exp_result2)
+{
+	char buf10[string_get_size_maxbuf];
+	char buf2[string_get_size_maxbuf];
+
+	string_get_size(size, blk_size, STRING_UNITS_10, buf10, sizeof(buf10));
+	string_get_size(size, blk_size, STRING_UNITS_2, buf2, sizeof(buf2));
+
+	test_string_get_size_check("STRING_UNITS_10", exp_result10, buf10,
+				   size, blk_size);
+
+	test_string_get_size_check("STRING_UNITS_2", exp_result2, buf2,
+				   size, blk_size);
 }
 
 static __init void test_string_get_size(void)
 {
-	test_string_get_size_one(16384, 512, STRING_UNITS_2, "8.00 MiB");
-	test_string_get_size_one(8192, 4096, STRING_UNITS_10, "32.7 MB");
-	test_string_get_size_one(1, 512, STRING_UNITS_10, "512 B");
+	/* small values */
+	test_string_get_size_one(0, 512, "0 B", "0 B");
+	test_string_get_size_one(1, 512, "512 B", "512 B");
+	test_string_get_size_one(1100, 1, "1.10 kB", "1.07 KiB");
+
+	/* normal values */
+	test_string_get_size_one(16384, 512, "8.39 MB", "8.00 MiB");
+	test_string_get_size_one(500118192, 512, "256 GB", "238 GiB");
+	test_string_get_size_one(8192, 4096, "33.6 MB", "32.0 MiB");
+
+	/* weird block sizes */
+	test_string_get_size_one(3000, 1900, "5.70 MB", "5.44 MiB");
+
+	/* huge values */
+	test_string_get_size_one(U64_MAX, 4096, "75.6 ZB", "64.0 ZiB");
+	test_string_get_size_one(4096, U64_MAX, "75.6 ZB", "64.0 ZiB");
 }
 
 static int __init test_string_helpers_init(void)
_

Patches currently in -mm which might be from vkuznets@redhat.com are

memory-hotplug-add-automatic-onlining-policy-for-the-newly-added-memory.patch
xen_balloon-support-memory-auto-onlining-policy.patch

