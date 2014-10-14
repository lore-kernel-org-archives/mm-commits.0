From: akpm@linux-foundation.org
Subject: [merged] lib-string_helpers-refactoring-the-test-suite.patch
 removed from -mm tree
Date: Tue, 14 Oct 2014 11:22:48 -0700
Message-ID: <543d69f8.tNvYI1hHHKIJUsAn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbaJNSWr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:22:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org, joe@perches.com, johannes@sipsolutions.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib / string_helpers: refactoring the test suite
has been removed from the -mm tree.  Its filename was
     lib-string_helpers-refactoring-the-test-suite.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: lib / string_helpers: refactoring the test suite

This patch prepares test suite for a following update.  It introduces
test_string_check_buf() helper which checks the result and dumps an error.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W . Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test-string_helpers.c |   39 ++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff -puN lib/test-string_helpers.c~lib-string_helpers-refactoring-the-test-suite lib/test-string_helpers.c
--- a/lib/test-string_helpers.c~lib-string_helpers-refactoring-the-test-suite
+++ a/lib/test-string_helpers.c
@@ -10,6 +10,26 @@
 #include <linux/string.h>
 #include <linux/string_helpers.h>
 
+static __init bool test_string_check_buf(const char *name, unsigned int flags,
+					 char *in, size_t p,
+					 char *out_real, size_t q_real,
+					 char *out_test, size_t q_test)
+{
+	if (q_real == q_test && !memcmp(out_test, out_real, q_test))
+		return true;
+
+	pr_warn("Test '%s' failed: flags = %u\n", name, flags);
+
+	print_hex_dump(KERN_WARNING, "Input: ", DUMP_PREFIX_NONE, 16, 1,
+		       in, p, true);
+	print_hex_dump(KERN_WARNING, "Expected: ", DUMP_PREFIX_NONE, 16, 1,
+		       out_test, q_test, true);
+	print_hex_dump(KERN_WARNING, "Got: ", DUMP_PREFIX_NONE, 16, 1,
+		       out_real, q_real, true);
+
+	return false;
+}
+
 struct test_string {
 	const char *in;
 	const char *out;
@@ -39,7 +59,8 @@ static const struct test_string strings[
 	},
 };
 
-static void __init test_string_unescape(unsigned int flags, bool inplace)
+static void __init test_string_unescape(const char *name, unsigned int flags,
+					bool inplace)
 {
 	char in[256];
 	char out_test[256];
@@ -77,15 +98,8 @@ static void __init test_string_unescape(
 		q_real = string_unescape(in, out_real, q_real, flags);
 	}
 
-	if (q_real != q_test || memcmp(out_test, out_real, q_test)) {
-		pr_warn("Test failed: flags = %u\n", flags);
-		print_hex_dump(KERN_WARNING, "Input: ",
-			       DUMP_PREFIX_NONE, 16, 1, in, p - 1, true);
-		print_hex_dump(KERN_WARNING, "Expected: ",
-			       DUMP_PREFIX_NONE, 16, 1, out_test, q_test, true);
-		print_hex_dump(KERN_WARNING, "Got: ",
-			       DUMP_PREFIX_NONE, 16, 1, out_real, q_real, true);
-	}
+	test_string_check_buf(name, flags, in, p - 1, out_real, q_real,
+			      out_test, q_test);
 }
 
 static int __init test_string_helpers_init(void)
@@ -94,8 +108,9 @@ static int __init test_string_helpers_in
 
 	pr_info("Running tests...\n");
 	for (i = 0; i < UNESCAPE_ANY + 1; i++)
-		test_string_unescape(i, false);
-	test_string_unescape(get_random_int() % (UNESCAPE_ANY + 1), true);
+		test_string_unescape("unescape", i, false);
+	test_string_unescape("unescape inplace",
+			     get_random_int() % (UNESCAPE_ANY + 1), true);
 
 	return -EINVAL;
 }
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
linux-next.patch

