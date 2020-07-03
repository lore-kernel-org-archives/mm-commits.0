From: akpm@linux-foundation.org
Subject: + bits-add-tests-of-genmask-fix-2.patch added to -mm tree
Date: Thu, 02 Jul 2020 21:30:45 -0700
Message-ID: <20200703043045.tNy6Xj9MB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbgGCEaq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Jul 2020 00:30:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hulkci@huawei.com, mm-commits@vger.kernel.org, rikard.falkeborn@gmail.com, weiyongjun1@huawei.com


The patch titled
     Subject: lib/test_bits: make some functions static
has been added to the -mm tree.  Its filename is
     bits-add-tests-of-genmask-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bits-add-tests-of-genmask-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bits-add-tests-of-genmask-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: lib/test_bits: make some functions static

Fix sparse build warnings:

lib/test_bits.c:10:6: warning:
 symbol 'genmask_test' was not declared. Should it be static?
lib/test_bits.c:27:6: warning:
 symbol 'genmask_ull_test' was not declared. Should it be static?
lib/test_bits.c:42:6: warning:
 symbol 'genmask_input_check_test' was not declared. Should it be static?

Link: http://lkml.kernel.org/r/20200702150336.4756-1-weiyongjun1@huawei.com
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Cc: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_bits.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/lib/test_bits.c~bits-add-tests-of-genmask-fix-2
+++ a/lib/test_bits.c
@@ -7,7 +7,7 @@
 #include <linux/bits.h>
 
 
-void genmask_test(struct kunit *test)
+static void genmask_test(struct kunit *test)
 {
 	KUNIT_EXPECT_EQ(test, 1ul, GENMASK(0, 0));
 	KUNIT_EXPECT_EQ(test, 3ul, GENMASK(1, 0));
@@ -24,7 +24,7 @@ void genmask_test(struct kunit *test)
 
 }
 
-void genmask_ull_test(struct kunit *test)
+static void genmask_ull_test(struct kunit *test)
 {
 	KUNIT_EXPECT_EQ(test, 1ull, GENMASK_ULL(0, 0));
 	KUNIT_EXPECT_EQ(test, 3ull, GENMASK_ULL(1, 0));
@@ -39,7 +39,7 @@ void genmask_ull_test(struct kunit *test
 #endif
 }
 
-void genmask_input_check_test(struct kunit *test)
+static void genmask_input_check_test(struct kunit *test)
 {
 	unsigned int x, y;
 	int z, w;
_

Patches currently in -mm which might be from weiyongjun1@huawei.com are

mm-slub-extend-slub_debug-syntax-for-multiple-blocks-fix.patch
bits-add-tests-of-genmask-fix-2.patch
