From: akpm@linux-foundation.org
Subject: +
 lib-string_helpersc-fix-infinite-loop-in-string_get_size-v5.patch added to
 -mm tree
Date: Thu, 17 Sep 2015 13:40:31 -0700
Message-ID: <55fb253f.6NLL6ywUcYK0HmBb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45831 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbbIQUkc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Sep 2015 16:40:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, JBottomley@Odin.com, andriy.shevchenko@linux.intel.com, kys@microsoft.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-string_helpersc-fix-infinite-loop-in-string_get_size-v5
has been added to the -mm tree.  Its filename is
     lib-string_helpersc-fix-infinite-loop-in-string_get_size-v5.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-string_helpersc-fix-infinite-loop-in-string_get_size-v5.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-string_helpersc-fix-infinite-loop-in-string_get_size-v5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: lib-string_helpersc-fix-infinite-loop-in-string_get_size-v5

- Single quotes in pr_warn() to see empty strings [Andy Shevchenko].
- Check for test validity compile-time [Rasmus Villemoes, Andy Shevchenko].
- All __test_string_get_size() arguments are const.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: James Bottomley <JBottomley@Odin.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string_helpers.c      |    4 ----
 lib/test-string_helpers.c |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 4 deletions(-)

diff -puN lib/string_helpers.c~lib-string_helpersc-fix-infinite-loop-in-string_get_size-v5 lib/string_helpers.c
--- a/lib/string_helpers.c~lib-string_helpersc-fix-infinite-loop-in-string_get_size-v5
+++ a/lib/string_helpers.c
@@ -59,10 +59,6 @@ void string_get_size(u64 size, u64 blk_s
 	}
 
 	exp = divisor[units] / (u32)blk_size;
-	/*
-	 * size must be strictly greater than exp here to ensure that remainder
-	 * is greater than divisor[units] coming out of the if below.
-	 */
 	if (size > exp) {
 		remainder = do_div(size, divisor[units]);
 		remainder *= blk_size;
diff -puN lib/test-string_helpers.c~lib-string_helpersc-fix-infinite-loop-in-string_get_size-v5 lib/test-string_helpers.c
--- a/lib/test-string_helpers.c~lib-string_helpersc-fix-infinite-loop-in-string_get_size-v5
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

lib-string_helpersc-fix-infinite-loop-in-string_get_size.patch
lib-string_helpersc-fix-infinite-loop-in-string_get_size-v3.patch
lib-string_helpersc-fix-infinite-loop-in-string_get_size-v5.patch
lib-test-string_helpersc-add-string_get_size-tests.patch

