From: akpm@linux-foundation.org
Subject: [merged] lib-test-string_helpersc-add-string_get_size-tests.patch removed from -mm tree
Date: Mon, 09 Nov 2015 12:12:37 -0800
Message-ID: <5640fe35.t79EHeYFKyV0yvis%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57573 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbbKIUMi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:12:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, JBottomley@Odin.com, andriy.shevchenko@linux.intel.com, kys@microsoft.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test-string_helpers.c: add string_get_size() tests
has been removed from the -mm tree.  Its filename was
     lib-test-string_helpersc-add-string_get_size-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: lib/test-string_helpers.c: add string_get_size() tests

Add a couple of simple tests for string_get_size().  The last one will
hang the kernel without the 'lib/string_helpers.c: fix infinite loop in
string_get_size()' fix.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: James Bottomley <JBottomley@Odin.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test-string_helpers.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff -puN lib/test-string_helpers.c~lib-test-string_helpersc-add-string_get_size-tests lib/test-string_helpers.c
--- a/lib/test-string_helpers.c~lib-test-string_helpersc-add-string_get_size-tests
+++ a/lib/test-string_helpers.c
@@ -326,6 +326,39 @@ out:
 	kfree(out_test);
 }
 
+#define string_get_size_maxbuf 16
+#define test_string_get_size_one(size, blk_size, units, exp_result)            \
+	do {                                                                   \
+		BUILD_BUG_ON(sizeof(exp_result) >= string_get_size_maxbuf);    \
+		__test_string_get_size((size), (blk_size), (units),            \
+				       (exp_result));                          \
+	} while (0)
+
+
+static __init void __test_string_get_size(const u64 size, const u64 blk_size,
+					  const enum string_size_units units,
+					  const char *exp_result)
+{
+	char buf[string_get_size_maxbuf];
+
+	string_get_size(size, blk_size, units, buf, sizeof(buf));
+	if (!memcmp(buf, exp_result, strlen(exp_result) + 1))
+		return;
+
+	buf[sizeof(buf) - 1] = '\0';
+	pr_warn("Test 'test_string_get_size_one' failed!\n");
+	pr_warn("string_get_size(size = %llu, blk_size = %llu, units = %d\n",
+		size, blk_size, units);
+	pr_warn("expected: '%s', got '%s'\n", exp_result, buf);
+}
+
+static __init void test_string_get_size(void)
+{
+	test_string_get_size_one(16384, 512, STRING_UNITS_2, "8.00 MiB");
+	test_string_get_size_one(8192, 4096, STRING_UNITS_10, "32.7 MB");
+	test_string_get_size_one(1, 512, STRING_UNITS_10, "512 B");
+}
+
 static int __init test_string_helpers_init(void)
 {
 	unsigned int i;
@@ -344,6 +377,9 @@ static int __init test_string_helpers_in
 	for (i = 0; i < (ESCAPE_ANY_NP | ESCAPE_HEX) + 1; i++)
 		test_string_escape("escape 1", escape1, i, TEST_STRING_2_DICT_1);
 
+	/* Test string_get_size() */
+	test_string_get_size();
+
 	return -EINVAL;
 }
 module_init(test_string_helpers_init);
_

Patches currently in -mm which might be from vkuznets@redhat.com are


