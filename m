From: akpm@linux-foundation.org
Subject: + lib-test-string_helpersc-add-string_get_size-tests.patch added
 to -mm tree
Date: Mon, 14 Sep 2015 14:26:00 -0700
Message-ID: <55f73b68.+qi883ZSltHWQk20%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46894 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbbINV0B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 17:26:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, JBottomley@Odin.com, andriy.shevchenko@linux.intel.com, kys@microsoft.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test-string_helpers.c: add string_get_size() tests
has been added to the -mm tree.  Its filename is
     lib-test-string_helpersc-add-string_get_size-tests.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-test-string_helpersc-add-string_get_size-tests.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-test-string_helpersc-add-string_get_size-tests.patch

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

 lib/test-string_helpers.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff -puN lib/test-string_helpers.c~lib-test-string_helpersc-add-string_get_size-tests lib/test-string_helpers.c
--- a/lib/test-string_helpers.c~lib-test-string_helpersc-add-string_get_size-tests
+++ a/lib/test-string_helpers.c
@@ -326,6 +326,30 @@ out:
 	kfree(out_test);
 }
 
+static __init void test_string_get_size_one(u64 size, u64 blk_size,
+					    const enum string_size_units units,
+					    const char *exp_result)
+{
+	char buf[256];
+
+	string_get_size(size, blk_size, units, buf, sizeof(buf));
+	if (!strncmp(buf, exp_result, min(sizeof(buf), strlen(exp_result))))
+		return;
+
+	pr_warn("Test 'test_string_get_size_one' failed!\n");
+	pr_warn("string_get_size(size = %llu, blk_size = %llu, units = %d\n",
+		size, blk_size, units);
+	pr_warn("expected: %s, got %s\n", exp_result, buf);
+
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
@@ -344,6 +368,9 @@ static int __init test_string_helpers_in
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
lib-test-string_helpersc-add-string_get_size-tests.patch

