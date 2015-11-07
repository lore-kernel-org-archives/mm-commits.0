From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-test-string_helpersc-add-string_get_size-tests-v5.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 16:15:07 -0800
Message-ID: <563d428b.KcpgFxSEXh9D5SiU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52693 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbbKGAPI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 19:15:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, JBottomley@Odin.com, andriy.shevchenko@linux.intel.com, kys@microsoft.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-test-string_helpersc-add-string_get_size-tests-v5
has been removed from the -mm tree.  Its filename was
     lib-test-string_helpersc-add-string_get_size-tests-v5.patch

This patch was dropped because it was folded into lib-test-string_helpersc-add-string_get_size-tests.patch

------------------------------------------------------
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: lib-test-string_helpersc-add-string_get_size-tests-v5

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

 lib/test-string_helpers.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff -puN lib/test-string_helpers.c~lib-test-string_helpersc-add-string_get_size-tests-v5 lib/test-string_helpers.c
--- a/lib/test-string_helpers.c~lib-test-string_helpersc-add-string_get_size-tests-v5
+++ a/lib/test-string_helpers.c
@@ -326,21 +326,30 @@ out:
 	kfree(out_test);
 }
 
-static __init void test_string_get_size_one(u64 size, u64 blk_size,
-					    const enum string_size_units units,
-					    const char *exp_result)
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
 {
-	char buf[256];
+	char buf[string_get_size_maxbuf];
 
 	string_get_size(size, blk_size, units, buf, sizeof(buf));
-	if (!strncmp(buf, exp_result, min(sizeof(buf), strlen(exp_result))))
+	if (!memcmp(buf, exp_result, strlen(exp_result) + 1))
 		return;
 
+	buf[sizeof(buf) - 1] = '\0';
 	pr_warn("Test 'test_string_get_size_one' failed!\n");
 	pr_warn("string_get_size(size = %llu, blk_size = %llu, units = %d\n",
 		size, blk_size, units);
-	pr_warn("expected: %s, got %s\n", exp_result, buf);
